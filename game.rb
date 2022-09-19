# require neccesary files
require_relative "pokedex/pokemons"
require_relative "pokedex/moves"
require_relative "pokedex/pokemon_art"
require_relative "pokemon"
require_relative "battle"
class Game
  attr_reader :initial_poke, :initial_poke_name, :name_trainer

  def initialize
    puts Art::POKEMONS["Pikachu"]
    puts " "
    @name_trainer = ""
    @initial_poke = ""
    @initial_poke_name = ""
    @poke = ""
    @current_stats = {}
    @difficulty = 1
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
        action = challenge_leader == true ? "Exit" : menu
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
      initial_pokes = ["Bulbasaur", "Charmander", "Squirtle", "Pikachu"]
      valid = initial_pokes.include?(@initial_poke)
      next unless valid

      break
    end
    puts Art::POKEMONS[@initial_poke]
    puts "\n \n"
    @poke = Pokemon.new(@initial_poke)
    @current_stats = @poke.increase_stats
  end

  def print_welcome
    puts "#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#"
    puts "#$#$#$#$#$#$#$                               $#$#$#$#$#$#$#"
    puts "#$##$##$##$ ---        Pokemon Ruby         --- #$##$##$#$#"
    puts "#$#$#$#$#$#$#$                               $#$#$#$#$#$#$#"
    puts "#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$# \n\n"
    choose_difficulty
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
    @poke.name = @initial_poke_name
  end

  def choose_difficulty
    puts "\nSelect difficulty"
    puts "1.Easy   2.Medium    3.Hard"
    puts "Choose a number:"
    valid_difficulty
  end

  def valid_difficulty
    loop do
      print "> "
      difficulty = gets.chomp.to_i
      next unless [1, 2, 3].include?(difficulty)

      @difficulty = difficulty
      break
    end
  end

  def train
    pokemons = Pokedex::POKEMONS
    target = pokemons.keys[rand(0..pokemons.length - 1)]
    level = rand(1..@poke.level + @difficulty)
    puts "#{@name_trainer} challenge Random Person for training"
    puts "Random Person has a #{target} level #{level}"
    puts "What do you want to do now? \n"
    puts "1. Fight        2. Leave"
    loop do
      print "> "
      action = gets.chomp
      next unless ["Leave", "Fight"].include?(action)

      fight(target, level) if action == "Fight"
      break
    end
  end

  def fight(target, level, o_trainer = "Random Person")
    puts "#{o_trainer} sent out #{target.upcase}!"
    puts "#{@name_trainer} sent out #{@initial_poke_name.upcase}!"
    puts "-------------------Battle Start!-------------------"
    puts "#{@name_trainer}'s #{@initial_poke_name} - Level #{@poke.level}"
    print "HP: "
    puts @poke.current_stats[:hp]
    puts "#{o_trainer}'s #{target} - Level #{level}"
    print "HP: "
    opponent = Pokemon.new(target)
    opponent.name = target
    opponent.level = level
    opponent.increase_stats
    puts opponent.current_stats[:hp]
    battle = Battle.new(@name_trainer, @poke, o_trainer, opponent)
    battle.start
    battle.win
  end

  def challenge_leader
    win = false
    target = "Onix"
    level = 10
    puts "#{@name_trainer} challenge the Gym Leader Brock for a fight"
    puts "Brock has a #{target} level #{level}"
    puts "What do you want to do now? \n"
    puts "1. Fight        2. Leave"
    loop do
      print "> "
      action = gets.chomp
      next unless ["Leave", "Fight"].include?(action)

      win = fight(target, level, "Brock") if action == "Fight"
      break
    end
    win
  end

  def show_stats
    # pokemons = Pokedex::POKEMONS
    # poke_info = pokemons[@initial_poke]
    puts "\n#{@poke.name} :"
    puts "Kind: #{@poke.poke_info[:species]}"
    puts "Type: #{@poke.poke_info[:type].join(', ')}"
    puts "Stats:"
    labels = ["HP: ", "Attack: ", "Defense: ", "Special Attack: ", "Special Defense: ", "Speed: "]
    (0..labels.length - 1).each do |i|
      print labels[i]
      puts @poke.current_stats.values[i]
    end
    print "Experience Points: "
    puts @poke.total_experience
    print "Experience Points to next level: "
    puts @poke.exp_to_nxtlvl
  end

  def goodbye
    puts "Thanks for playing Pokemon Ruby"
    puts "This game was created with love by Rodrigo, Erik, Joshua and Steph"
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
# poke= Pokemon.new
game = Game.new
game.start

# p poke.level
