play_game <- function() {
  print("Let's play Pao Ying Chub game")
  print("Who's got 3 scores first will be the winner")
  print("Type exit if you want to quit")
  print("Choose one option")
  print("h = hammer, s = scissor, p = paper")
  # Create Variables
  options_1 <- c("h", "s", "p")
  options_2 <- c("h" = "hammer", "s" = "scissor", "p" = "paper")
  play_again <- 0
  user_score <- 0
  computer_score <- 0
  user_win <- 0
  computer_win <- 0

  # While loop for play again
  while (play_again == 0) {

    # While loop for game
    while (user_score < 3 & computer_score < 3) {

      # User choice
      cat("Choose one: ")
      user_select = readLines("stdin", 1)
      # Computer choice by random
      computer_select <- sample(options_1, 1)
      
      # If user want to exit break while loop
      if (user_select == 'exit') {
        print(paste("Your score:", user_score, "Computer score:", computer_score))
        play_again <- 1
        break
      }
      # Case 1 : Tie
      else if (user_select == computer_select) {
        print(paste("Your choice:", options_2[[user_select]]))
        print(paste("Computer choice:", options_2[[computer_select]]))
        print("tie!")
        print(paste("Your score:", user_score, "Computer score:", computer_score))
      }
      # Case 2 : User win
      else if ((user_select == 'h' & computer_select == 's') |
               (user_select == 'p' & computer_select == 'h') |
               (user_select == 's' & computer_select == 'p')
              ) {
        print(paste("Your choice:", options_2[[user_select]]))
        print(paste("Computer choice:", options_2[[computer_select]]))
        user_score <- user_score + 1
        print(paste("Your score:", user_score, "Computer score:", computer_score))
      }
      # Case 3 : User lose
      else if ((user_select == 'h' & computer_select == 'p') |
               (user_select == 'p' & computer_select == 's') |
               (user_select == 's' & computer_select == 'h')
              ) {
        print(paste("Your choice:", options_2[[user_select]]))
        print(paste("Computer choice:", options_2[[computer_select]]))
        computer_score <- computer_score+1
        print(paste("Your score:", user_score, "Computer score:", computer_score))
      }
      # If user type wrong text
      else {
        print("you type wrong text")
        print(paste("Your score:", user_score, "Computer score:", computer_score))
      }
    }
    
    # Out of game loop
    # If user want to exit will summarize and finish here
      if (user_select == 'exit') {
      print("Thank for playing!")
      print(paste("Your win's game:", user_win, "Computer win's game:",     computer_win))
      win_rate <- round((user_win/(computer_win+user_win)*100.0),2)
      print(paste("Your win's rate:", win_rate))
    }
    
    # Summary scores and ask user if they want to play again ?
      else {
        # Summary
        if (computer_score > user_score) {
          user_score <- 0
          computer_score <- 0
          computer_win <- computer_win + 1
          print("Sorry! you lose😭")
        } else {
          user_score <- 0
          computer_score <- 0
          user_win <- user_win + 1
          print("Congrats! you win😁")
        }

        # Play again
        cat("Do you want to play again? (Type Y if you want): ")
        play_ask = readLines("stdin", 1)
        # If Yes don't update play_again so the loop don't break
        if (play_ask == 'Y') {
          play_again <- 0
        } 

        # If No summerize and update play_again to break play again loop
        else {
          print("Thank for playing!")
          print(paste("Your win's game:", user_win, "Computer win's game:", computer_win))
          win_rate <- round((user_win/(computer_win+user_win)*100.0),2)
          print(paste("Your win's rate:", win_rate))
          play_again <- 1
        }
      }  
  }
  # Out of play again loop
}

greeting_bot <- function() {
  # Question 1 : ask user name
  cat("What's your name: ")
  username = readLines("stdin", 1)
  print(paste("Hello!", username))

  # Question 2 : ask user age
  cat("How old are you? ")
  user_age = readLines("stdin", 1)
  user_age = as.numeric(user_age)
  print(paste("You are", user_age, "years old"))

  # Question 3 : ask user if they want to play game
  cat("Do you want to play Pao Ying Chub (type Y if you want) ")
  user_game = readLines("stdin", 1)
  if (user_game == 'Y') {
     play_game()
  } else {
    print(paste("Thank you for answer", username, "see you again!"))
  }
}

greeting_bot()
