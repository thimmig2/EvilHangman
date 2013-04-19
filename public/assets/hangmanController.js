/* Hangman Game Controller

    This file is the hangman game controller.
    It interacts with the hangman model and the
    hangman view to provide a complete game.

    There are four main parts to this file :

        1. Model setup
        2. View setup
        3. View updating
        4. Redirect on gameover

*/

//=====================================================
//  Model Setup

var status = 1.0
var guesses = 13.0
var game = new Hangman(guesses)

var wordMin = 3
var wordMax = 6
var wordLength = getRandomInt(wordMin, wordMax)
game.startNewGame(wordLength)


//=====================================================
//  View Setup

$(document).ready(function() {

    // make sure the cursor starts in the guess box
    $("#letter").focus()
    // and that it's empty
    $("#letter").val("")

    // add event handler to letter submitted button
    $("#guess").click(handleGuess)

})


//=====================================================
//  View Updating

function handleGuess() {
    // get the guessed letter
    var guessedLetter = $("#letter").val().trim().toLowerCase()
    // clear the textinput for next guess
    $("#letter").val("")

    // validate it is a letter
    if(/^[a-z]{1}$/.test(guessedLetter)) {
        // if it is a letter forward it to model
        if(game.guessLetter(guessedLetter) > 0){
            // means the letter was used and we need to update
            // word box
            updateView(true)
        } else {
            // means letter wasnt used and we dont
            updateView(false)
        }
    } else {
        // handle invalid input (not a letter)
        alert("Unless you were unaware '" + guessedLetter + "' is not a single letter, you should probably go back to elementary school.")
    }

    // make sure game isnt over
    if(game.isOver()) {
        // if it is, wrap up
        finishGame()
    }

    // make sure the form doesnt redirect the page
    return false;
}

function updateView(usedLetter) {

    // if the letter was used in the word
    if(usedLetter == true) {
        // update word box
        var wordString = ""
        var wordArray = game.getWord()
        // replace characters not guessed yet with _'s
        for(var i=0; i< wordArray.length; i++) {
            if(wordArray[i] == null) {
                wordString += "_ "
            } else {
                wordString += wordArray[i] + " "
            }
        }
        $("#word").html(wordString)
    } else {
        // update picture
        status += 26.0/guesses
        console.log(status)
        var pictureNumber = Math.floor(status)
        var pictureUrl = "assets/hang" + pictureNumber + ".png"
        $('#hangmanPicture').attr("src", pictureUrl);

    }

    // update guessed letters box
    var guessedLetters = game.getGuessedLetters()
    var guessesString = ""
    for(var i=0; i< guessedLetters.length; i++) {
        guessesString += guessedLetters[i]
        if(i < guessedLetters.length - 1) {
            guessesString += ", "
        }
    }
    $("#guessedLetters").html(guessesString)


}


//=====================================================
//  Gameover Redirect

function finishGame() {
    // redirect to path that saves a game as a history entry
    var historySaveUrl = "/save_history?"

    var endWord = ""
    var wordArray = game.getWord()
    var win = true
    for(var i=0; i< wordArray.length; i++) {
        if(wordArray[i] == null) {
            endWord += "_"
            win = false
        } else {
            endWord += wordArray[i]
        }
    }
    var won = 0
    if(win) {
        won = 1
        alert("Wow, nice job, you are one lucky bastard!")
    } else {
        alert("Not surprised you lost. Better luck next time chap ;D. Guess you'll never know what your word was, could have been " + game.getPossibleWord() + " though.")
    }

    var arguments = {
        "word" : endWord,
        "letters_guessed" : game.getGuessedLetters().join(""),
        "win" : won
    }
    historySaveUrl += $.param(arguments)
    window.location.replace(historySaveUrl);
}
