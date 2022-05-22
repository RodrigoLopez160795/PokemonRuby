require_relative "pokedex/pokemons"
require_relative "pokedex/moves"
require_relative "pokemon"
class Battle
  # (complete parameters)
  attr_reader :win

  def initialize(trainer, poke, o_trainer, opponent)
    @win = false
    @trainer = trainer
    @poke = poke
    @o_trainer = o_trainer
    @opponent = opponent
    # Complete this
  end

  def start
    poke_hp = @poke.current_stats[:hp]
    opponnent_hp = @opponent.current_stats[:hp]
    while opponnent_hp.positive? && poke_hp.positive?
      moves = choosing_moves
      move = moves[0]
      o_move = moves[1]
      first = who_goes_first(move, o_move)
      # second = first == @poke? @opponent : @poke
      if first == @poke
        f_remaining_hp = poke_hp
        s_remaining_hp = opponnent_hp
        opponnent_hp = attacks(move, @poke, @opponent, s_remaining_hp)
        poke_hp = attacks(o_move, @opponent, @poke, f_remaining_hp) if opponnent_hp.positive?
      else
        s_remaining_hp = poke_hp
        f_remaining_hp = opponnent_hp
        poke_hp = attacks(o_move, @opponent, @poke, s_remaining_hp)
        opponnent_hp = attacks(move, @poke, @opponent, f_remaining_hp) if poke_hp.positive?
      end
    end
    who_won?(poke_hp)
  end

  def who_won?(poke_hp)
    puts "--------------------------------------------------"
    winner = if poke_hp.positive?
               @poke
             else
               @opponent
             end
    winner_messages(winner)
  end

  def winner_messages(winner)
    if winner == @poke
      puts "#{@opponent.name} FAINTED!"
      puts "--------------------------------------------------"
      puts "#{@poke.name} WINS!"
      base_exp = @opponent.poke_info[:base_exp]
      gain_experience = (base_exp * @opponent.level / 7).floor
      @poke.total_experience += gain_experience
      puts "#{@poke.name} gained #{gain_experience} experience points"
      @poke.increase_level(gain_experience)
      @poke.increase_stats(@opponent)
      @win = true
      puts "Congratulations! You win the BOULDER BADGE." if @o_trainer == "Brock"
    else
      puts "#{@poke.name} FAINTED!"
      puts "--------------------------------------------------"
      puts "#{@opponent.name} WINS!"
    end
  end

  def attacks(move, attacker, attacked, current_hp)
    puts "#{attacker.name} used #{move.upcase}!"
    if check_accuracy(move) == true
      factor = critical_hit? ? 1.5 : 1
      multiplier = how_much_effective(move, attacker)
      damage = calculate_damage(move, attacker)
      final_damage = (damage * factor * multiplier).floor
      current_hp -= final_damage
      puts "And it hit #{attacked.name} with #{final_damage} damage"
      puts ""
      current_hp
    else
      attacked.current_stats[:hp]
    end
  end

  def choosing_moves
    o_poke_moves = @opponent.poke_info[:moves]
    o_move = o_poke_moves[rand(0..o_poke_moves.length - 1)]
    puts "#{@trainer}, select your move:"
    move = @poke.set_current_move
    [move, o_move]
  end

  def who_goes_first(move, o_move)
    o_priority = Pokedex::MOVES[o_move][:priority]
    o_speed = @opponent.current_stats[:speed]

    priority = Pokedex::MOVES[move][:priority]
    speed = @poke.current_stats[:speed]

    if o_priority != priority
      first = o_priority > priority ? @opponent : @poke
    elsif o_speed != speed
      first = o_speed > speed ? @opponent : @poke
    else
      options = [@poke, @opponent]
      first = options[rand(0..1)]
    end
    first
  end

  def check_accuracy(move)
    accuracy = Pokedex::MOVES[move][:accuracy]
    if accuracy == 100
      true
    else
      limite = (100.0 / (100 - accuracy)).round(0)
      n = rand(1..limite)
      if n == 1
        puts "#{move.upcase} has failed"
      else
        true
      end
    end
  end

  def critical_hit?
    n = rand(1..16)
    if n == 1
      puts "It was a CRITICAL HIT!"
      true
    else
      false
    end
  end

  def how_much_effective(move, first)
    second = first == @poke ? @opponent : @poke
    f_type = Pokedex::MOVES[move][:type]
    s_type = second.poke_info[:type]
    arr = Pokedex::TYPE_MULTIPLIER
    # p arr.select {|hash| hash[:user] == f_type[0] &&  hash[:target] == s_type[0]}
    multiplier = 1
    arr.each do |hash|
      (0..s_type.length - 1).each do |i|
        multiplier = hash[:multiplier] * multiplier if hash[:user] == f_type && hash[:target] == s_type[i]
      end
    end
    string_multiplier(multiplier) # puts de que tan efectivo
    multiplier
  end

  def string_multiplier(multiplier)
    case multiplier
    when 0 then puts "It's not effective at all"
    when 0.1..0.5 then puts "It's not very effective"
    when 0.6..1 then puts "It's a normal attack"
    when 1.1..4 then puts "It's super effective"
    end
  end

  def calculate_damage(move, attacker)
    attacked = attacker == @poke ? @opponent : @poke
    level = attacker.level
    move_type = Pokedex::MOVES[move][:type]
    special_moves = Pokedex::SPECIAL_MOVE_TYPE
    if special_moves.include?(move_type)
      offensive_stat = attacker.current_stats[:special_attack]
      target_defensive_stat = attacked.current_stats[:special_defense]
    else
      offensive_stat = attacker.current_stats[:attack]
      target_defensive_stat = attacked.current_stats[:defense]
    end
    move_power = Pokedex::MOVES[move][:power]
    ((((2 * level / 5.0) + 2).floor * offensive_stat * move_power / target_defensive_stat).floor / 50.0).floor + 2
  end
end

# poke = Pokemon.new("Charmander")
# opponent = Pokemon.new("Bulbasaur")
# batalla = Battle.new("Ash", poke, opponent)
# # batalla.calculate_damage("ember")
# batalla.start
# 10.times {p batalla.check_accuracy("scratch")}
# batalla.how_much_effective("vine whip", poke)
