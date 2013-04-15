class GameController < ApplicationController

  def index
    @user = User.find(session[:user_id])
    if @user.user_type == 1
      @user.username = "Anonymous"
    end
  end


  def hangman


  end

  def save_history
    @history_entry = HistoryEntry.new({:user_id => session[:user_id], :word => params[:word], :letters_guessed => @game.guessedLetters.join})

    if @history_entry.save
      redirect_to(game_path(), notice: 'History entry was successfully created.')
    else
      redirect_to(game_path(), notice: 'Sorry there was adding the game history')
    end
  end


end
