# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @get('playerHand').on 'all', @playerEvents, @
    @get('dealerHand').on 'all', @dealerEvents, @


  playerEvents: (event, hand) ->
    switch event
      when 'bust' then @trigger 'win-dealer'
      when 'stand' then @get('dealerHand').playToWin()

  dealerEvents: (event, hand) ->
    switch event
      when 'bust' then @trigger 'win-player'
      when 'stand' then @findWinner()

  findWinner: ->
    if @get('playerHand').maxScore() > @get('dealerHand').maxScore()
      @trigger 'win-player'
    else if @get('playerHand').maxScore() < @get('dealerHand').maxScore()
      @trigger 'win-dealer'
    else
      @trigger 'push'