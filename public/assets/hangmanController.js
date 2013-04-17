var status = 1.0
var guesses = 13.0
var game = new Hangman(guesses)

var wordMin = 3
var wordMax = 6
var wordLength = getRandomInt(wordMin, wordMax)
game.startNewGame(wordLength)


$(document).ready(function() {

    $("#letter").focus()
    $("#letter").val("")

    $("#guess").click(handleGuess)

})

function handleGuess() {
    var guessedLetter = $("#letter").val().trim().toLowerCase()
    $("#letter").val("")
    if(/^[a-z]{1}$/.test(guessedLetter)) {
        if(game.guessLetter(guessedLetter) > 0){
            updateView(true)
        } else {
            updateView(false)
        }
    } else {
        alert("Unless you were unaware '" + guessedLetter + "' is not a single letter, you should probably go back to elementary school.")
    }

    if(game.isOver()) {
        finishGame()
    }

    return false;
}



function updateView(usedLetter) {
    var wordString = ""
    var wordArray = game.getWord()
    for(var i=0; i< wordArray.length; i++) {
        if(wordArray[i] == null) {
            wordString += "_ "
        } else {
            wordString += wordArray[i] + " "
        }
    }
    $("#word").html(wordString)

    var guessedLetters = game.getGuessedLetters()
    var guessesString = ""
    for(var i=0; i< guessedLetters.length; i++) {
        guessesString += guessedLetters[i]
        if(i < guessedLetters.length - 1) {
            guessesString += ", "
        }
    }
    $("#guessedLetters").html(guessesString)

    if(usedLetter == false) {
        status += 26.0/guesses
        console.log(status)
        var pictureNumber = Math.floor(status)
        var pictureUrl = "assets/hang" + pictureNumber + ".png"
        $('#hangmanPicture').attr("src", pictureUrl);
    }
}

function finishGame() {
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
