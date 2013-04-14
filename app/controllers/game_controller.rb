class GameController < ApplicationController

  def index
    @user = User.find(session[:user_id])
    if @user.user_type == 1
      @user.username = "Anonymous"
    end
  end

  def new_game
    numberOfGuesses = 20
    session[:game] = Hangman.new(numberOfGuesses)

    # can provide a wordlength as a parameter
    # if none provided generates a random one
    wordLength = 2
    session[:game].startNewGame(wordLength)

    redirect_to guessing_path
  end

  def guessing
    @game = session[:game]
  end

  def guessing_letter
    @game = session[:game]
    letter = params[:letter].strip.downcase
    if letter =~ /[a-z]/
      # guessLetter returns number of times letter was used in word 0 <= times <= wordLength
      timesUsed = @game.guessLetter(letter)
      redirect_to guessing_path(:notice => "Guessed letter #{letter}"), :method => "get"
    elsif
     redirect_to guessing_path(:notice => "#{params[:letter]} isn't letter silly."), :method => "get"
    end
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
