class GameController < ApplicationController
  def index
  end

  def runGame
    numberOfGuesses = 20
    game = Hangman.new(numberOfGuesses)

    # can provide a wordlength as a parameter
    # if none provided generates a random one
    wordLength = nil
    game.startNewGame(wordLength)

    until game.gameOver
      # Read user input from view
      if letter =~ /\w{1}/
        # guessLetter returns number of times letter was used in word 0 <= times <= wordLength
        timesUsed = game.guessLetter(letter.downcase)
      elsif
        puts "Invalid Input"
      end

      # functions to use to update view:
        # an array of letters that represents the word so far
        # if an element is nil it hasnt been revealed yet
        game.wordClass


        # an array of all letters guessed so far
        game.guessedLetters
        # an array of letters that were correct
        game.getCorrectGuesses
        # an array of letters that were wrong
        game.getWrongGuesses
    end



  end
end
