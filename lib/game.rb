require_relative "word"
require_relative "hangman"
require "colorize"

# A class that runs the game
class HangmanGame
  def initialize(is_load)
    if is_load
      load_game
      return
    end

    puts "Starting game...".colorize(:green)
    puts "YOU CAN SAVE THE GAME BY TYPING 'save' AT ANY TURN".colorize(:red)
    choose_word
    create_hangman
    run_game
  end

  def load_game
    puts "Loading game..."
    File.open("save.dat", "r") do |f|
      loaded = Marshal.load(f) # rubocop:disable Security/MarshalLoad
      @word = loaded.word
      @hangman = loaded.hangman
      @letter = loaded.letter
    end
    run_game
  end

  protected

  attr_reader :word, :hangman, :letter

  private

  def choose_word
    puts "Choosing word...".colorize(:green)
    @word = Word.new(load_valid_words.sample.upcase)
  end

  def load_valid_words
    throw LoadError.new("dict.txt was not found") unless File.exist?("dict.txt")
    File.read("dict.txt").split("\n").select { |v| v.size.between?(5, 12) }
  end

  def create_hangman
    puts "Creating hangman...".colorize(:green)
    @hangman = Hangman.new
  end

  def run_game
    puts "The word has #{@word.size} letters".colorize(:green)
    until @word.found? || @hangman.dead?
      show_word
      @letter = fetch_attempt
      feedback = @word.exist?(@letter)
      show_feedback(feedback)
      @hangman.step unless feedback
    end
    show_results
  end

  def fetch_attempt
    puts "You have #{@hangman.health} wrong attempts left, guess a letter (case insensitive)".colorize(:red)
    loop do
      letter = gets.chomp.upcase
      save_game if letter == "SAVE"
      return letter if letter.match?(/^[A-Z]$/) && @word.valid?(letter)

      puts "Invalid input".colorize(:red)
    end
  end

  def show_feedback(feedback)
    text = if feedback
             "There are #{feedback} #{@letter}(s) in the word"
           else
             "There are no #{@letter}s in the word. The hangman loses a life."
           end
    puts text.colorize(:blue)
  end

  def show_word
    puts "\n\t\t#{@word}\n\n"
  end

  def show_results
    text = @word.found? ? "You found the word, you win!" : "You hangman died... You lose"
    puts text.colorize(:blue)
    puts "The word was"
    reveal_word
  end

  def reveal_word
    @word.solve
    show_word
  end

  def save_game
    conf = true
    conf = confirmation_save if File.exist?("save.dat")
    return unless conf

    File.open("save.dat", "w") do |f|
      f.print Marshal.dump(self)
    end
    exit!
  end

  def confirmation_save
    puts "Are you sure to save file? This will overwrite current save file".colorize(:red)
    puts "0 - Save\n1 - Cancel"
    loop do
      answer = gets.chomp
      break answer if answer.match?(/^[0-1]$/)
    end == "0"
  end
end
