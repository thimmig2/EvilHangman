class GameController < ApplicationController
  def index
    @user = User.find(session[:user_id])
    if @user.user_type == 1
      @user.username = "Anonymous"
    end
  end

  def runGame
    numberOfGuesses = 20
    @game = Hangman.new(numberOfGuesses)

    # can provide a wordlength as a parameter
    # if none provided generates a random one
    wordLength = nil
    @game.startNewGame(wordLength)

    until @game.gameOver
      # Read user input from view
      if letter =~ /\w{1}/
        # guessLetter returns number of times letter was used in word 0 <= times <= wordLength
        timesUsed = @game.guessLetter(letter.downcase)
      elsif
        puts "Invalid Input"
      end

      # functions to use to update view:
        # an array of letters that represents the word so far
        # if an element is nil it hasnt been revealed yet
      @game.wordClass


      # an array of all letters guessed so far
      @game.guessedLetters
      # an array of letters that were correct
      @game.getCorrectGuesses
      # an array of letters that were wrong
      @game.getWrongGuesses
    end

    saveHistory



  end

  def saveHistory
    @history_entry = HistoryEntry.new({:user_id => session[:user_id], :word => @game.wordClass.join, :letters_guessed => @game.guessedLetters.join})

    if @history_entry.save
      redirect_to(game_path(), notice: 'History entry was successfully created.')
    else
      redirect_to(game_path(), notice: 'Sorry there was adding the game history')
    end
  end


end
