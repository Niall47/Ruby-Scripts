def look_at_hand
  @hand = Hash.new
  $players.each do |player|
    each_hand = []
    cards = player.hand
    cards.each do |card|
      each_hand << card
    end
    @hand.store(player.name, each_hand)
  end
end

def compare_cards #Currently only looks for pairs, 2 pair, 3 of a kind, quads, full house and flush
  $players.each do |player|
  name, hand = player.name, player.hand
    pair?(name, hand)
    flush?(name, hand)
  end
end

def flush_prep
  suits = {"Clubs" => [], "Hearts" => [], "Spades" => [], "Diamonds" => []}
  $community_cards.each do |cc| #loads the community cards into a hash so we can count number of each suit
    case cc.suit
    when 'Clubs'
      suits['Clubs'] << cc
    when 'Hearts'
      suits['Hearts'] << cc
    when 'Spades'
      suits['Spades'] << cc
    when 'Diamonds'
      suits['Diamonds'] << cc
    end
  end
 return suits
end

def flush?(name, hand)
  suits = flush_prep
  hand.each do |card|
    case card.suit
    when 'Clubs'
      suits['Clubs'] << card
    when 'Hearts'
      suits['Hearts'] << card
    when 'Spades'
      suits['Spades'] << card
    when 'Diamonds'
      suits['Diamonds'] << card
    end
  end
  suits.each do |suit|
    p "#{name} has a flush of #{suit[0]}" if suit[1].count == 5
  end
 # p "#{suits['Hearts'].count} - #{suits['Clubs'].count} - #{suits['Spades'].count} - #{suits['Diamonds'].count}"
end

def pair?(name, hand)
  all_cards, @pairs = [], []
  $community_cards.each do |community_cards|
    all_cards << community_cards
  end
  hand.each do |cards|
    all_cards << cards
  end
  all_cards.each do |card|
    all_cards.each do |card2|
      if card.pair_match?(card2)
        @pairs << card # Everything that matched goes into the array
        @pairs << card2
      end
    end
  end
  @pairs.uniq! #Get rid of duplicate cards
  case @pairs.count
  when 0
    p "#{name} has nothing of value"
  when 2
    p "#{name} found #{@pairs.count / 2} pair of  #{@pairs[0].rank}s"
  when 3
    p "#{name} found #{@pairs.count} of a kind"
  when 4
    two_pair_or_quad(@pairs, name)
  when  5
    p "#{name} found a full house"
  else
    p "#{name} found #{@pairs.count / 2} of a kind" #3 pairs, cba to check for it now
  end
end

def two_pair_or_quad(pairs, name)
  pairs.sort! {|a,b| a.value <=> b.value}
  if pairs[0].value == pairs[2].value
    p "#{name} had quads #{pairs[0].value}"
  elsif pairs[1].value != pairs[3].value
    p "#{name} - has 2 pair #{pairs[0].rank}s & #{pairs[2].rank}s"
  end
end

def read_cards(hand)
  hand.each do |player|
    cards = []
    player[1].each do |card| #player[1] is the hand (both cards)
    cards << card
    end
    p "#{player[0]} #{cards[0].rank} of #{cards[0].suit} & #{cards[1].rank} of #{cards[1].suit}"
  end
end

