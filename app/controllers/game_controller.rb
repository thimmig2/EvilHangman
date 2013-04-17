class GameController < ApplicationController

  def index
    # this page calculates history stats for currently logged in user and shows games played by others

    # change the ugly format of anonymous users stored in database to a prettier version
    @user = User.find(session[:user_id])
    if @user.user_type == 1
      @user.username = "Anonymous"
    end

    # get all entries and sort them by the most letters guessed right
    @historyEntries = HistoryEntry.all
    @historyEntries.sort! { |a,b| b.word.split("").reject{|letter| letter.eql?("_")}.length  <=> a.word.split("").reject{|letter| letter.eql?("_")}.length }

    # calculate stats for a user with all of their history entries
    userEntries = HistoryEntry.find_all_by_user_id(session[:user_id])
    if userEntries.length > 0
      @percent=winPercent(userEntries)
      @totalLetters=totalLettersGuessed(userEntries)
      @totalGames= userEntries.length
      @longestWord=longestWordGuessed(userEntries)
      @percentLetters=lettersGuessedPercent(userEntries)
    else
      # all stats are 0 if the user hasn't played a game yet
      @percent=0
      @totalLetters=0
      @totalGames=0
      @longestWord=0
      @percentLetters=0
    end
  end


  def hangman
    # the logic and model for the game are contained within public/assets and were written in javascript
  end

  def save_history
    # called by hangmanController.js and is used to save a game into the history table
    @history_entry = HistoryEntry.new({:user_id => session[:user_id], :word => params[:word], :letters_guessed => params[:letters_guessed], :win => params[:win]})

    if @history_entry.save
      redirect_to(game_path(), notice: 'History entry was successfully created.')
    else
      redirect_to(game_path(), notice: 'Sorry there was adding the game history')
    end
  end


# the following functions are used to calculate stats for a user
#===============================================================

  def winPercent(userHistory)
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


  def totalLettersGuessed(userHistory)
    totalLetters=0.0
    userHistory.each do |entry|
      hold = entry.letters_guessed.split(//)
      hold = hold.reject{ |element| element=="_"}
      totalLetters=totalLetters+hold.length
    end
    totalLetters
  end

  def longestWordGuessed(userHistory)
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


  def correctLettersGuessed(userHistory)
    correct=0.0
    userHistory.each do |entry|
      correct += entry.word.split(//).reject{|letter| letter.eql?("_")}.length
    end
    correct
  end


  def lettersGuessedPercent(userHistory)
    percent = correctLettersGuessed(userHistory) / totalLettersGuessed(userHistory) * 100
    percent.round(1).to_s + "%"
  end

#=================================================================

end
