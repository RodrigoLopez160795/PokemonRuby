require_relative "pokedex/pokemons"
require_relative "pokedex/moves"
require_relative "pokemon"
class Battle
  # (complete parameters)

  def initialize(trainer, poke, opponent)
    @opponent = opponent

    @trainer = trainer
    @poke = poke
    # Complete this
  end

  def start
    o_current_stats = @opponent.increase_stats("", 2) # lee el level de la clase pokemon
    o_poke_moves = @opponent.poke_info[:moves]
    o_move = o_poke_moves[rand(0..o_poke_moves.length - 1)]
    o_priority = Pokedex::MOVES[o_move][:priority]
    o_speed = o_current_stats[:speed]

    puts "#{@trainer}, select your move:"
    move = @poke.set_current_move
    priority = Pokedex::MOVES[move][:priority]
    @poke.increase_stats("", 1) # deberia traer el level de la clase pokemon
    speed = @poke.current_stats[:speed]
    first = who_goes_first(o_priority,priority, o_speed, speed)
    if first == @poke 
      if check_accuracy(move) == true
        boolean = critical_hit?
      end
    else
     check_accuracy(o_move)
    end

    # Prepare the Battle (print messages and prepare pokemons)

    # Until one pokemon faints
    # --Print Battle Status
    # --Both players select their moves

    # --Calculate which go first and which second

    # --First attack second
    # --If second is fainted, print fainted message
    # --If second not fainted, second attack first
    # --If first is fainted, print fainted message

    # Check which player won and print messages
    # If the winner is the Player increase pokemon stats
  end
  def who_goes_first (o_priority,priority,o_speed, speed)
    if o_priority != priority
      first = o_priority > priority ? @opponent : @poke
    elsif o_speed != speed
      first = o_priority > priority ? @opponent : @poke
    end
    first
  end
  def check_accuracy (move)
    accuracy = Pokedex::MOVES[move][:accuracy]
    if accuracy == 100
      return true
    else
      limite = (100.0/(100-accuracy)).round(0)
      n = rand (1..limite)
      if n == 1 
       puts "#{move.upcase} has failed" 
      else
        return true
      end
    end
  end
  
  def critical_hit?
    n = rand (1..16)
      if n == 1 
       puts "It was a CRITICAL HIT!" 
       return true
      else
       return false
      end
  end
 
  def how_much_effective (move, first)
  second = first == @poke? @opponent : @poke
  f_type = Pokedex::MOVES[move][:type]
  s_type = second.poke_info[:type]
  arr = Pokedex::TYPE_MULTIPLIER
  # p arr.select {|hash| hash[:user] == f_type[0] &&  hash[:target] == s_type[0]}
  multiplier = 1
  arr.each do |hash|
    for i in 0..s_type.length-1
      if  hash[:user] == f_type &&  hash[:target] == s_type[i]
        multiplier= hash[:multiplier]
        multiplier *= multiplier
      end
    end
  end
   string_multiplier(multiplier)#puts de que tan efectivo
  end
  def string_multiplier(multiplier)
    case multiplier
      when 0 then puts "It's not effective at all"
      when 0.1..0.5 then puts "It's not very effective"
      when 0.6..1 then puts "It's a normal attack"
      when 1.1..2 then puts "It's super effective" 
    end
  end
end

poke = Pokemon.new("Charmander")
opponent = Pokemon.new("Bulbasaur")
batalla = Battle.new("Ash", poke, opponent)
# batalla.start
# 10.times {p batalla.check_accuracy("scratch")}
batalla.how_much_effective("vine whip", poke)
