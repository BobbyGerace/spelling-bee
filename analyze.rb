require 'set'

class Words
  attr_reader :word_list

  def initialize()
    @word_list = get_word_list
  end

  def get_word_list
    File.open('english.txt').each_line.map do |line|
      line.strip.upcase
    end.select { |word| word.size >= 4 && word =~ /\A[A-Z]*\z/}
  end

  def seven_letter_combos
    combos = Set.new

    @word_list.each do |word|
      uniq = word.chars.uniq

      next if uniq.size != 7

      combos.add(uniq.sort.join)
    end

    combos
  end

  def possible_stats(combo, center_letter)
    word_count = 0
    possible_score = 0

    letters = Letters.new(combo)
    @word_list.each do |word|
      next unless letters.can_spell_word?(word, center_letter)

      word_count +=1
      possible_score += score(word)
    end

    { word_count: word_count, possible_score: possible_score }
  end

  def score(word)
    return 14 if word.size == 7

    return 1 if word.size == 4

    return word.size
  end
end

class Letters
  def initialize(letters)
    @letters = letters.chars
    @letters_set = @letters.to_set
  end

  def can_spell_word?(word, center_letter)
    return false unless word.include?(center_letter)

    word.chars.all? { |ch| @letters_set.include?(ch) }
  end
end

words = Words.new

combos = words.seven_letter_combos

puts combos.first(10)
puts combos.size

start = Time.now
combos.first(10).each do |letters|
  letters.chars.each do |center_letter|
    puts center_letter + " | " + letters
    puts words.possible_stats(letters, center_letter)
  end
end
puts "time: " + (Time.now - start).to_s

puts words.word_list.size


# letters = 'HBCEIOT'
# letters.chars.each do |center_letter|
#   puts center_letter + " | " + letters
#   puts words.possible_stats(letters, center_letter)
# end
