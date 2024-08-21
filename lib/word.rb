require "colorize"

# A word class that handles a guess word
class Word
  def initialize(word)
    @found = []
    @visibility = word.chars.map { |v| [v, false] }
    @letters = word.chars.each_with_index.with_object({}) do |v, a|
      a[v[0]] = [] unless a.key?(v[0])
      a[v[0]].push(v[1])
    end
  end

  def exist?(letter)
    @found << letter
    @letters.key?(letter) ? @letters[letter].each { |v| @visibility[v][1] = true }.size : false
  end

  def valid?(letter)
    !@found.include?(letter)
  end

  def to_s
    @visibility.map { |v| v[1] ? v[0].colorize(:green) : "_" }.join(" ")
  end

  def found?
    @visibility.all? { |v| v[1] }
  end

  def size
    @visibility.size
  end

  def solve
    @visibility.map! { |v| [v[0], true] }
  end
end
