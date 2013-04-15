class GameController < ApplicationController

  def index
    @user = User.find(session[:user_id])
    if @user.user_type == 1
      @user.username = "Anonymous"
    end
  end

  def winPercent
    user = HistoryEntries.find(:all, :user_id => :session[user_id])
    win=0.0
    loss=0.0
    user.each do |i|
      if(user[i].win == 1)
        win=win+1.0
      else
        loss=loss+1.0
      end
    end
    percent=(win/(win+loss))
    percent
  end


  def totalLettersGuessed
    user = HistoryEntries.find(:all, :user_id => :session[user_id])
    totalLetters=0
    hold = ""
    user.each do |i|
      hold = user[i].letters_guessed.split(//)
      hold = hold.reject{ |element| element=="_"}
      totalLetters=totalLetters+user[i].hold.length
    end
    totalLetters
  end


  def totalGamesPlayed
    user = HistoryEntries.find(:all, :user_id => :session[user_id])
    totalGames=user.length
    totalGames
  end


  def longestWordGuessed
    user = HistoryEntries.find(:all, :user_id => :session[user_id])
    max = 0
    longestWord = ""
    hold = ""
    user.each do |i|
      hold = user[i].word.split(//)
      if !hold.include? '_'
        if user[i].word.length > max
          max=user[i].word.length
          longestWord = user[i].word
        end
      end
    end
    longestWord
  end


  def correctLettersGuessed
    hold = ""
    hold2 = ""
    user = HistoryEntries.find(:all, :user_id => :session[user_id])
    correct=0
    user.each do |i|
      hold2 = user[i].word.split(//)
      hold = hold2.reject { |element| element=="_"}
      correct=correct+hold.length
    end
    correct
  end


  def lettersGuessedPercent
    right = correctLettersGuessed
    total = totalLettersGuessed
    lettersGuessedPerc = (correctLetters/total)
    lettersGuessedPerc
  end



  def hangman
    # nothing really to do here
  end

  def save_history
    @history_entry = HistoryEntry.new({:user_id => session[:user_id], :word => params[:word], :letters_guessed => params[:letters_guessed], :win => params[:win]})

    if @history_entry.save
      redirect_to(game_path(), notice: 'History entry was successfully created.')
    else
      redirect_to(game_path(), notice: 'Sorry there was adding the game history')
    end
  end


end
