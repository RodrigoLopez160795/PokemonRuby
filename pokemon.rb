# require neccesary files
require_relative "pokedex/pokemons"

class Pokemon
  # include neccesary modules
  attr_accessor :name, :level
  attr_reader :current_stats, :poke_info, :remaining_experience, :effort_values, :individual_values
  attr_accessor :total_experience, :exp_to_nxtlvl

  # (complete parameters)
  def initialize(string)
    @name = ""
    @poke_info = Pokedex::POKEMONS[string]
    @growth_rate = @poke_info[:growth_rate].to_s
    @current_stats = {}
    @individual_values = generate_values(31)
    @level = 1
    @effort_values = generate_values(0)
    @base_values = @poke_info[:base_stats]
    @remaining_experience = 0
    @total_experience = 0
    @exp_to_nxtlvl = calculate_next_level
  end

  def generate_values(max_value)
    keys = %i[hp attack defense special_attack special_defense speed]
    default_values = []
    keys.length.times { default_values << rand(0..max_value) }
    keys.zip(default_values).to_h
  end

  def prepare_for_battle
    # Complete this
  end

  def receive_damage
    # Complete this
  end

  def set_current_move
    current_move = ""
    poke_moves = @poke_info[:moves]
    (1..poke_moves.length).each do |i|
      print "#{i}. #{poke_moves[i - 1]}      "
    end
    puts ""
    loop do
      print "> "
      current_move = gets.chomp
      next unless poke_moves.include?(current_move)

      break
    end
    puts "-" * 50
    current_move
  end

  def fainted?
    # Complete this
  end

  def increase_level(gain_experience)
    gain_experience += @remaining_experience
    cont = 0
    while gain_experience > cont
      cont = calculate_next_level
      if gain_experience > cont
        @level += 1
        puts "#{@name} reached level #{@level}!"
        gain_experience -= cont
      end
      cont = calculate_next_level
    end
    @remaining_experience = gain_experience
    @exp_to_nxtlvl = cont - @remaining_experience
  end

  def calculate_next_level
    to_new_level = 0
    case @growth_rate
    when "slow"
      to_new_level = (((5 * ((@level + 1)**3))) / 4.0).round(0) # @level+1)
    when "medium_slow"
      a = ((6 * ((@level + 1)**3)) / 5.0)
      b = ((15 * ((@level + 1)**2)))
      c = (100 * (@level + 1))
      to_new_level = (a - b + c - 140).round(0)
    when "medium_fast"
      to_new_level = (@level + 1)**3
    when "fast"
      to_new_level = ((4 * ((@level + 1)**3)) / 5.0).round(0)
    end
    to_new_level
  end

  def increase_effort_values(target)
    info = target.poke_info[:effort_points]
    type = info[:type]
    amount = info[:amount]
    @effort_values[type] += amount
  end

  def increase_stats(target = nil)
    increase_effort_values(target) unless target.nil?
    keys = %i[hp attack defense special_attack special_defense speed]
    stat_values = []
    keys.each do |key|
      const = key == :hp ? @level + 10 : 5
      a = (2 * @base_values[key])
      stat_value = (((a + @individual_values[key] + @effort_values[key]) * @level / 100) + const).floor
      stat_values << stat_value
    end
    hash = keys.zip(stat_values).to_h
    @current_stats = hash
  end

  # private methods:
  # Create here auxiliary methods
end

# poke = Pokemon.new("Charmander")
# poke1 = Pokemon.new("Bulbasaur")
# p poke.effort_values
# poke.increase_effort_values(poke1)
# p poke.effort_values

# puts poke.increase_stats("hola")
# puts poke.level
# puts poke.hp
# poke.set_current_move

# poke.change_level("Pikachu",1)
