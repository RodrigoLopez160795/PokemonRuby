# require neccesary files
require_relative "pokedex/pokemons.rb"
require_relative "pokedex/moves.rb"

class Game
  def initialize
    @name_trainer = ""
    @initial_poke = ""
    @initial_poke_name = ""
  end

  def print_welcome
    puts "#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#"
    puts "#$#$#$#$#$#$#$                               $#$#$#$#$#$#$#"
    puts "#$##$##$##$ ---        Pokemon Ruby         --- #$##$##$#$#"
    puts "#$#$#$#$#$#$#$                               $#$#$#$#$#$#$#"
    puts "#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#"
    print " \n"
    puts "Hello there! Welcome to the world of POKEMON! My name is OAK!"
    puts "People call me the POKEMON PROF!"
    print " \n"
    puts "This world is inhabited by creatures called POKEMON! For some" 
    puts "people, POKEMON are pets. Others use them for fights. Myself..."
    puts "I study POKEMON as a profession."
    puts "First, what is your name?"
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
    print " \n"
    puts "1. Bulbasaur    2. Charmander   3. Squirtle"
    loop do
      print "> " 
      @initial_poke = gets.chomp
      initial_pokes = ["Bulbasaur","Charmander","Squirtle"]
      valid = initial_pokes.include?(@initial_poke)
      next unless valid
      break
    end
    puts "You selected #{@initial_poke.upcase}. Great choice!"
    puts "Give your pokemon a name?"
    print "> " 
    @initial_poke_name = gets.chomp
    @initial_poke_name = @initial_poke if @initial_poke_name.empty?

    stats
  end

  def stats
    pokemons = Pokedex::POKEMONS
    choosen_pokemon = pokemons.values_at(@initial_poke.capitalize) #find{|key,_value| key == @initial_poke.capitalize}
    p choosen_pokemon[0].values_at(:type)

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

  def train
    # Complete this
  end

  def challenge_leader
    # Complete this
  end

  def show_stats
    # Complete this
  end

  def goodbye
    # Complete this
  end

  def menu
    # Complete this
  end
end

game = Game.new
game.start
