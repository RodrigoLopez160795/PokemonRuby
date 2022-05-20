# require neccesary files
require_relative "pokedex/pokemons"
require_relative "pokedex/moves"

class Game
  def initialize
    @name_trainer = ""
    @initial_poke = ""
    @initial_poke_name = ""
    @initial_poke_lvl = 1
  end

  def start
    print_welcome

    # Create a welcome method(s) to get the name, pokemon and pokemon_name from the user

    # Then create a Player with that information and store it in @player

    # Suggested game flow
    action = menu
    until action == "Exit"
      case action
      when "Train"
        train
        action = menu
      when "Leader"
        challenge_leader
        action = menu
      when "Stats"
        show_stats
        action = menu
      end
    end

    goodbye
  end

  def valid_trainer_name
    loop do
      print "> "
      @name_trainer = gets.chomp
      next if @name_trainer.empty?

      puts "Right! So your name is #{@name_trainer.upcase}!"
      puts "Your very own POKEMON legend is about to unfold! A world of"
      puts "dreams and adventures with POKEMON awaits! Let's go!"
      puts "Here, #{@name_trainer.upcase}! There are 3 POKEMON here! Haha!"
      puts "When I was young, I was a serious POKEMON trainer."
      puts "In my old age, I have only 3 left, but you can have one! Choose!"
      break
    end
  end

  def valid_initial_pokemon
    loop do
      print "> "
      @initial_poke = gets.chomp
      initial_pokes = ["Bulbasaur", "Charmander", "Squirtle"]
      valid = initial_pokes.include?(@initial_poke)
      next unless valid

      break
    end
  end

  def print_welcome
    puts "#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#"
    puts "#$#$#$#$#$#$#$                               $#$#$#$#$#$#$#"
    puts "#$##$##$##$ ---        Pokemon Ruby         --- #$##$##$#$#"
    puts "#$#$#$#$#$#$#$                               $#$#$#$#$#$#$#"
    puts "#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$# \n\n"
    puts "Hello there! Welcome to the world of POKEMON! My name is OAK!"
    puts "People call me the POKEMON PROF! \n\n"
    puts "This world is inhabited by creatures called POKEMON! For some"
    puts "people, POKEMON are pets. Others use them for fights. Myself..."
    puts "I study POKEMON as a profession."
    puts "First, what is your name?"
    valid_trainer_name
    puts "\n 1. Bulbasaur    2. Charmander   3. Squirtle"
    valid_initial_pokemon
    puts "You selected #{@initial_poke.upcase}. Great choice!"
    puts "Give your pokemon a name?"
    print "> "
    @initial_poke_name = gets.chomp
    @initial_poke_name = @initial_poke if @initial_poke_name.empty?
  end

  def train
    pokemons = Pokedex::POKEMONS
    target = pokemons.keys[rand(0..pokemons.length)]
    level = rand(1..10)
    puts "Great master challenge Random Person for training"
    puts "Random Person has a #{target} level #{level}"
    puts "What do you want to do now? \n"
    puts "1. Fight        2. Leave"
    loop do
      print ">"
      action = gets.chomp
      next unless ["Leave", "Fight"].include?(action)

      fight(target, level) if action == "Fight"
      break
    end
  end

  def fight(target, _level)
    puts "Random Person sent out #{target.upcase}!"
    puts "Great master sent out #{@initial_poke_name.upcase}!"
    puts "-------------------Battle Start!-------------------"
    puts
  end

  def challenge_leader
    # Complete this
  end

  def show_stats
    pokemons = Pokedex::POKEMONS
    poke_info = pokemons[@initial_poke]
    # # Debemos corregir de donde sacamos los stats
    puts "\n#{@initial_poke_name} :"
    puts "Kind: #{@initial_poke}"
    puts "Type: #{poke_info[:type].join(', ')}"
    puts "Stats:"
    labels = ["HP: ", "Attack: ", "Defense: ", "Special Attack: ", "Special Defense: ", "Speed: "]
    (0..labels.length - 1).each do |i|
      print labels[i]
      puts poke_info[:base_stats].values[i]
    end
    print "Experience Points: "
    puts 0 # esto cambiara
  end

  def goodbye
    # Complete this
  end

  def menu
    puts "-----------------------Menu-----------------------"
    puts "1. Stats        2. Train        3. Leader       4. Exit"
    options = ["Stats", "Train", "Leader", "Exit"]
    action = ""
    loop do
      print "> "
      action = gets.chomp
      next unless options.include?(action)

      break
    end
    action
  end
end

game = Game.new
game.start
