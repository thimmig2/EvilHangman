class GameController < ApplicationController

  def index
    @user = User.find(session[:user_id])
    if @user.user_type == 1
      @user.username = "Anonymous"
    end

    @historyEntries = HistoryEntry.all
    @historyEntries.sort! { |a,b| b.word.split("").reject{|letter| letter.eql?("_")}.length  <=> a.word.split("").reject{|letter| letter.eql?("_")}.length }

    if HistoryEntry.find_all_by_user_id(session[:user_id]).length > 0
      @percent=winPercent
      @totalLetters=totalLettersGuessed
      @totalgames=totalGamesPlayed
      @longestword=longestWordGuessed
      @percentletters=lettersGuessedPercent
    else
      @percent=0
      @totalLetters=0
      @totalgames=0
      @longestword=0
      @percentletters=0
    end
  end

  def winPercent
    userHistory = HistoryEntry.find_all_by_user_id(session[:user_id])
    win=0.0
    loss=0.0
    userHistory.each do |entry|
      if(entry.win == 1)
        win=win+1.0
      else
        loss=loss+1.0
      end
    end
    percent=(win/(win+loss))
    percent.to_s + "%"
  end


  def totalLettersGuessed
    userHistory = HistoryEntry.find_all_by_user_id(session[:user_id])
    totalLetters=0.0
    userHistory.each do |entry|
      hold = entry.letters_guessed.split(//)
      hold = hold.reject{ |element| element=="_"}
      totalLetters=totalLetters+hold.length
    end
    totalLetters
  end


  def totalGamesPlayed
    userHistory = HistoryEntry.find_all_by_user_id(session[:user_id])
    userHistory.length
  end


  def longestWordGuessed
    userHistory = HistoryEntry.find_all_by_user_id(session[:user_id])
    max = 0
    longestWord = ""
    hold = ""
    userHistory.each do |entry|
      hold = entry.word.split(//)
      if !hold.include? '_'
        if entry.word.length > max
          max=entry.word.length
          longestWord = entry.word
        end
      end
    end
    return longestWord if longestWord.length > 0
    "none"
  end


  def correctLettersGuessed
    userHistory = HistoryEntry.find_all_by_user_id(session[:user_id])
    correct=0.0
    userHistory.each do |entry|
      correct += entry.word.split(//).reject{|letter| letter.eql?("_")}.length
    end
    correct
  end


  def lettersGuessedPercent
    percent = correctLettersGuessed / totalLettersGuessed * 100
    percent.round(1).to_s + "%"
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
