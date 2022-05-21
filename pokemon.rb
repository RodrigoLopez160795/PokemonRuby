# require neccesary files
require_relative "pokedex/pokemons"

class Pokemon
  # include neccesary modules
  attr_reader :name, :current_stats, :poke_info, :level
  attr_writer :name
  # (complete parameters)
  def initialize(string)
    @name=""
    pokemons = Pokedex::POKEMONS
    @pokemons = pokemons
    # string = "bulbasaur" o "charmander" o "squirtle"
    @current_stats = {}
    @poke_info = pokemons[string]   
    @individual_values = {}
    generate_individual_values
    @level = 1
    @effort_values = { hp: 0, attack: 0, defense: 0, special_attack: 0, special_defense: 0, speed: 0 }
    @base_values = @poke_info[:base_stats]
    @hp = 0
    @attack = 0
    @defense = 0
    @special_atack = 0
    @special_defense = 0
    @speed = 0
    @remaining_experience = 0
    # Retrieve pokemon info from Pokedex and set instance variables
    # Calculate Individual Values and store them in instance variable
    # Create instance variable with effort values. All set to 0
    # Store the level in instance variable
    # If level is 1, set experience points to 0 in instance variable.
    # If level is not 1, calculate the minimum experience point for that level and store it in instance variable.
    # Calculate pokemon stats and store them in instance variable
  end
  def generate_individual_values
    keys = %i[hp attack defense special_attack special_defense speed]
    default_values = []
    keys.length.times { default_values << rand(0..31) }
    @individual_values = keys.zip(default_values).to_h
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
    puts "-"*50
    current_move
  end

  def fainted?
    # Complete this
  end

  
  def increase_level (gain_experience,growth_rate)
    gain_experience += @remaining_experience
    cont = 0
    while gain_experience > cont
      cont = calculate_next_level(growth_rate)
      if gain_experience > cont
        @level += 1
        puts "#{@initial_poke_name} you reached level #{@level}!"
      end
      gain_experience -= cont
    end
    @remaining_experience = gain_experience

  end
  def calculate_next_level(growth_rate)
    to_new_level = 0
    case growth_rate
    when "slow"
      to_new_level = ((5*(@level**3))/4.0).round(0) #@level
    when "medium_slow"
      to_new_level = ((6*(@level**3)/5.0)-(15*(@level**2))+(100*@level)-140).round(0)
    when "medium_fast"
      to_new_level = @level**3
    when "fast"
      to_new_level = (4*(@level**3)/5.0).round(0)
    end
    to_new_level
  end

  def change_level(initial_poke,enemy_level)
    pokemons = Pokedex::POKEMONS
    poke_info = pokemons[initial_poke] # initial poke
    base_exp = poke_info[:base_exp]
    growth_rate = poke_info[:growth_rate].to_s
    gain_experience = (base_exp * enemy_level / 7).floor
    increase_level(gain_experience, growth_rate)
  end

  def increase_stats(_target, level)
    # aqui cambian los effort_values dependiendo del target (pokemon oponente)
    keys = %i[hp attack defense special_attack special_defense speed]
    stat_values = []
    keys.each do |key|
      const = key == :hp ? 10 : 5
      stat_value = ((((2 * @base_values[key]) + @individual_values[key] + @effort_values[key]) * level / 100) + level + const).floor
      stat_values << stat_value
    end
    hash = keys.zip(stat_values).to_h
    # Pensar en una forma más efectiva de aisgnar estos valores
    @hp = hash[:hp]
    @attack = hash[:attack]
    @defense = hash[:defense]
    @special_atack = hash[:special_atack]
    @special_defense = hash[:special_defense]
    @speed = hash[:speed]

    @current_stats = hash

    # Increase stats base on the defeated pokemon and print message "#[pokemon name] gained [amount] experience points"

    # If the new experience point are enough to level up, do it and print
    # message "#[pokemon name] reached level [level]!" # -- Re-calculate the stat
  end

  # private methods:
  # Create here auxiliary methods
end

# poke = Pokemon.new("Charmander")
# # poke.increase_stats("hola")

# puts poke.increase_stats("hola")
# puts poke.level
# puts poke.hp
# poke.set_current_move

# poke.change_level("Pikachu",1)

