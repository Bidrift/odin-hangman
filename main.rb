require_relative "lib/game"
require "colorize"

def ask_load
  puts "Save file detected... Choose an option (0-1)".colorize(:yellow)
  puts "0 - Start new game\n1 - Load saved game"
  loop do
    answer = gets.chomp
    break answer if answer.match?(/^[0-1]$/)
  end == "1"
end

loop do
  if File.exist?("save.dat")
    HangmanGame.new(ask_load)
  else
    HangmanGame.new(false)
  end
end
