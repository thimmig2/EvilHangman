
class Hangman

  @@dictionaryFileName
  @@dictionary = Array.new



  @@wordLength
  @@guessedLetters


  def startNewGame
    @@wordLength = rand()




  end

  def initializeDictionary()

    dictIn = File.open("dictionary", "r")

    dictIn.each_line do |line|
      if line.length == @@wordLength
        @@dictionary.push line.strip
      end
    end

    dictOut.close()

  end


end