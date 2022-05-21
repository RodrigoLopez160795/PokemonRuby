# require neccesary files
require_relative "pokedex/pokemons"

class Pokemon
  # include neccesary modules
  attr_reader :current_stats, :poke_info, :level, :hp, :attack, :defense, :special_attack, :special_defense,
              :special_defense, :speed

  # (complete parameters)
  def initialize(string)
    pokemons = Pokedex::POKEMONS
    # string = "bulbasaur" o "charmander" o "squirtle"
    @current_stats = {}
    @poke_info = pokemons[string]
    base_stats = @poke_info[:base_stats]
    keys = %i[hp attack defense special_attack special_defense speed]
    default_values = []
    keys.length.times { default_values << rand(0..31) }
    @individual_values = keys.zip(default_values).to_h
    # puts  @individual_values
    @level = 1
    @effort_values = { hp: 0, attack: 0, defense: 0, special_attack: 0, special_defense: 0, speed: 0 }
    @base_values = base_stats
    @hp = 0
    @attack = 0
    @defense = 0
    @special_atack = 0
    @special_defense = 0
    @speed = 0
    # Retrieve pokemon info from Pokedex and set instance variables
    # Calculate Individual Values and store them in instance variable
    # Create instance variable with effort values. All set to 0
    # Store the level in instance variable
    # If level is 1, set experience points to 0 in instance variable.
    # If level is not 1, calculate the minimum experience point for that level and store it in instance variable.
    # Calculate pokemon stats and store them in instance variable
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

  # def attack(target)
  # Print attack message 'Tortuguita used MOVE!'
  # Accuracy check
  # If the movement is not missed
  # -- Calculate base damage
  # -- Critical Hit check
  # -- If critical, multiply base damage and print message 'It was CRITICAL hit!'
  # -- Effectiveness check
  # -- Mutltiply damage by effectiveness multiplier and round down. Print message if neccesary
  # ---- "It's not very effective..." when effectivenes is less than or equal to 0.5
  # ---- "It's super effective!" when effectivenes is greater than or equal to 1.5
  # ---- "It doesn't affect [target name]!" when effectivenes is 0
  # -- Inflict damage to target and print message "And it hit [target name] with [damage] damage""
  # Else, print "But it MISSED!"
  # end

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
