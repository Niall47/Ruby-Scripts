require_relative "card_ranking"

$players = []
$community_cards = []
@names = ['Dave', 'Greg', 'Rob', 'Steve', 'Carl', 'Matt', 'Niall', 'Kev', 'Ronnie']

class Deck
  attr_accessor :the_cards
  def initialize
    @ranks = [*(2..10), 'J', 'Q', 'K', 'A']
    @suits = ["Clubs", "Hearts", "Spades", "Diamonds"]
    @the_cards = []
    @ranks.each do |rank|
      @suits.each do |suit|
        @the_cards << Card.new(rank, suit)
      end
    end
    @the_cards.shuffle!
  end
  def deal
    @the_cards.slice!(0) #pulls the top card off the stack
  end
  def shuffle
    @the_cards.shuffle!
    p 'The deck has been shuffled'
  end
  def show_remaining
    @the_cards.count
  end
end

class Card
  attr_accessor :rank, :suit, :value

  SpecialRanks = {'J' => 11,'Q' => 12,'K' => 13,'A' => 14}

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
    @value = SpecialRanks.fetch(rank, rank)
  end

  def output_card
    output = "#{@rank}-#{@suit}"
  end

  def pair_match?(other_card) #messy AF
    if self == other_card
      false
    else
      if self.value == other_card.value
        true
      end
    end
  end
end


class Player
  attr_accessor :hand, :name, :money
  def initialize(name)
    @name = name
    @hand = []
    @money = money
  end
  def inspect_player
    p "#{@name} - Money: #{@money}  Hand: #{@hand}"
  end
  def introduce_player
    p "#{@name} has joined the game"
  end
  def recieve_card(card)
    @hand << card
  end
end

def start_game
  @full_deck = Deck.new
  $players = 4.times.map { Player.new(pick_name) }
  p "Generated #{$players.count} players"
  $players.each(&:introduce_player) #introduce everyone
end

def pick_name
  @names.shuffle!
  name = @names[0]
  @names.delete_at(0)
  return name
end

def deal
  $players.each do |player|
    player.recieve_card(@full_deck.deal) #every player recieves two cards
  end
end

def community_cards
  $community_cards << (@full_deck.deal) unless $community_cards.count >= 5
  p "#{$community_cards.last.rank} of #{$community_cards.last.suit}"
end

p '________TEXAS HOLDEM:_______'
start_game
@full_deck.shuffle
p 'Dealing cards'
p '____________________________'
p '_________THE DEAL:__________'
2.times{deal}
look_at_hand
read_cards(@hand)
p '____________________________'
p '_________THE FLOP:__________'
3.times{community_cards}
p '____________________________'
p '_________THE TURN:__________'
community_cards
p '____________________________'
p '_________THE RIVER:__________'
community_cards
p '____________________________'
p '________THE RESULT:_________'
compare_cards
p '____________________________'
