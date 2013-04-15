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

  attr_reader :wordClass
  attr_reader :wordLength
  attr_reader :guessedLetters

=begin
  attr_reader :gameOver
=end

  def initialize(numberOfGuesses = 26)
    @numberOfGuesses = numberOfGuesses  # defaults to 26

    @dictionary
    @wordLength = -1
    @guessedLetters   # array of letters that have been guessed

    @wordClass      # array length @@wordlength of nil until player narrows dictionary down to 1
    @gameOver = true
  end

  # returns number of times letter was used in word
  def guessLetter(letter)
    if @guessedLetters.include? letter
      puts "You already guessed that number stupid!"
      return
    end

    @guessedLetters.push letter
    letterIndexes = findEvilWords(letter)

    # check if letter was used at all
    if letterIndexes.length > 0
      letterIndexes.each do |index|
        @wordClass[index] = letter
      end
    end

    if @guessedLetters.length >= @numberOfGuesses
      @gameOver = true
      puts "You ran out of guesses loser!"
    end

    # all letters have been filled in
    unless @wordClass.include? nil
      @gameOver = true
      puts "You won after " + @guessedLetters.length.to_s + "guesses!"
    end

    letterIndexes.length
  end

  # Finds most unlikely words to be guessed based on letter
  # returns the indexs of this letter if there are any
   def findEvilWords(letter)
    max = 0
    maxKey = []

    wordClasses = buildWordClasses(letter)
    wordClasses.each_pair do |key, value|
      if value.length > max
        max = value.length
        maxKey = key
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
      # for each word in the dictionary
      wordClasses.keys.each do |letterSpots|
        # check that letter at each index is the guessed letter
        index = 0
        # keep track of unique letters in the word that havent been guessed yet
        #   (we want to eliminate words that have more letters to guess than guesses left)
        uniqueLetters = Set.new
        letterIndexes = Array.new
        until index == word.length
          if word[index] == letter
            letterIndexes.push index
          else
            # check if the current letter has been guessed yet
            uniqueLetters.add word[index] unless word[index] == @wordClass[index]
          end
          index += 1
        end

        # means passed all index lookups and the player has enough guesses left to get the word
        if letterSpots.eql?(letterIndexes) && uniqueLetters.size <= (@guessedLetters.length - @numberOfGuesses)
          wordClasses[letterSpots].push word    # add it to this word class
          break
        end
      end

    end

    # return all word classes with more than 1 word
    wordClasses.reject {|key, value| value.length == 0}
  end

  def startNewGame(debugWordLength = nil)
    puts "You are about to embark on an arduous journey, good luck my friend, you will need it. Haha..hahaa...hahahahahah\n\n"
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

  def printIncorrect
    print "Incorrect Guesses : "
      @guessedLetters.each do |letter|
        unless @wordClass.include? letter
          print letter + " "
        end
      end
    puts ""
  end

  def getCorrectGuesses
    wordClass.uniq
  end

  def getWrongGuesses
    guessedLetters - self.getCorrectGuesses
  end

end



