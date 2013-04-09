
=begin

  guess a letter

  there is a word family for each location of that letter in the word

  along each step
    eliminate unreachable words
    words with double letters count as less than 1 word
      (easier to complete the word)
      every occurrence of a double letter reduces word value
    words with commonly guessed letters by the player count as less than 1 word

  word family is chosen by number of words in family


Save for later :
"abc".split.each_with_index do |letter, index|
  puts
end

=end


class Hangman

  @@dictionaryFileName = "dictionary"
  @@LENGTH_RANGE = 5..15 # 23 is the longest word in dictionary

  attr_reader :wordLength
  attr_reader :guessedLetters
  attr_reader :wordClass

  def initialize(numberOfGuesses = 26)
    @dictionary
    @wordLength = -1

    @guessedLetters   # array of letters that have been guessed
    @wordClass      # array length @@wordlength of nil until player narrows dictionary down to 1
  end


  def guessLetter(letter)

  end

  # Finds most unlikely words to be guessed based on letter
  def findEvilWords(letter)
    evilWords = Array.new

    evilWords
  end

  def printWordsLeft
    puts @dictionary.to_s
    @dictionary.to_s
  end

  def startNewGame
    oldLength = @wordLength
    @wordLength = rand(@@LENGTH_RANGE)

    unless oldLength == @wordLength and @dictionary.length > 0
      initializeDictionary
    end

    @guessedLetters = Array.new(0)
    @wordClass = Array.new(0)
    @wordClass[wordLength - 1] = nil
  end

  def initializeDictionary()
    @dictionary = Array.new

    dictIn = File.open(@@dictionaryFileName, "r")

    dictIn.each_line do |line|
      if line.length == @wordLength
        @dictionary.push line.strip
      end
    end

    dictIn.close()
  end

end


game = Hangman.new
game.startNewGame
game.printWordsLeft