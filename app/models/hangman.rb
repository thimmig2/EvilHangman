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
  attr_reader :gameOver

  def initialize(numberOfGuesses = 26)
    @numberOfGuesses = numberOfGuesses

    @dictionary
    @wordLength = -1
    @guessedLetters   # array of letters that have been guessed

    @wordClass      # array length @@wordlength of nil until player narrows dictionary down to 1
    @gameOver = true
  end


  def guessLetter(letter)
    findEvilWords(letter).each do |index|
      @wordClass[index] = letter
    end

    @guessedLetters.push letter

    if @guessedLetters.length >= @numberOfGuesses
      @gameOver = true
    end
  end

  # Finds most unlikely words to be guessed based on letter
  def findEvilWords(letter)
    max = 0
    maxKey = []

    wordClasses = buildWordClasses(letter)
    wordClasses.each_pair do |key, value|
      if value.length > max
        max = value.length
        maxKey = key
        puts key
      end
    end

    @dictionary = wordClasses[maxKey]
    maxKey
  end


  def buildWordClasses(letter, debugWordClass = nil)

    if debugWordClass != nil
      @wordClass = debugWordClass
    end

    unknownLetters = Array.new(0)
    @wordClass.each_with_index do |letter, index|
       if letter == nil
         unknownLetters.push index
       end
    end

    # instantiates a hash with each possible letter placement as keys
    #   we will map these keys to an array of words following that pattern
    wordClasses = Hash.new()
    index = unknownLetters.length
    until index < 0
      unknownLetters.permutation(index).to_a.each do |key|
        wordClasses[key] = []
      end
      index -= 1
    end

    @dictionary.each_with_index do |word, index|

      wordClasses.keys.each do |letterSpots|
        addWord = true

        # check that letter at each index is the guessed letter
        letterIndex = 0
        tempArray = Array.new
        until letterIndex == word.length
          tempArray.push letterIndex if word[letterIndex] == letter
          letterIndex += 1
        end

        if letterSpots.eql?(tempArray)   # means passed all index lookups
          wordClasses[letterSpots].push word    # add it to this word class
          break
        end
      end

    end

    # return all word classes with more than 1 word
    wordClasses.reject {|key, value| value.length == 0}
  end

  def printWordsLeft
    puts @dictionary.length.to_s + " words left. " + @dictionary.to_s
    @dictionary.to_s
  end

  def printWordClass
    word = ""
    @wordClass.each do |letter|
      if letter == nil
        word += "_ "
      else
        word += letter + " "
      end
    end
    puts word
  end

  def startNewGame(debugWordLength = nil)
    oldLength = @wordLength

    if debugWordLength == nil
      @wordLength = rand(@@LENGTH_RANGE)
    else
      @wordLength = debugWordLength
    end

    initializeDictionary

    @guessedLetters = Array.new(0)
    @wordClass = Array.new(@wordLength)
    @gameOver = false
  end

  def initializeDictionary()
    @dictionary = Array.new

    dictIn = File.open(@@dictionaryFileName, "r")

    dictIn.each_line do |line|
      if line.strip!.length == @wordLength
        @dictionary.push line.downcase
      end
    end

    dictIn.close()
  end

end


game = Hangman.new
game.startNewGame(5)
until game.gameOver
  game.printWordsLeft
  game.printWordClass

  print "Guess a letter: "
  letter = gets.strip
  game.guessLetter(letter)
end



