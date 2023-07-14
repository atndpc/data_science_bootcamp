# HW02 - Pao Ying Chub
import random as rd
def pao_ying_chub():
    print("Let's play Pao Ying Chub game")
    print("Who's got 3 scores first will be the winner")
    print("Type exit if you want to quit")
    print("Choose one option")
    print("h = hammer, s = scissor, p = paper")
    user_sc = 0
    com_sc = 0
    user_ch = "0"
    while (user_sc < 3 and com_sc < 3):
        user_ch = input("What is your choice? ")
        
        # choice right play game
        if (user_ch == "h" or user_ch == "s" or user_ch == "p"):
            if(user_ch == "h"):   user_ch = "hammer"
            elif(user_ch == "s"): user_ch = "scissor"
            elif(user_ch == "p"): user_ch = "paper"
            com_ch = rd.choice(["hammer", "scissor", "paper"])
            print(f"Your choice : {user_ch} and computer choice : {com_ch}")
            
            # you win
            if ((user_ch == "hammer" and com_ch == "scissor") 
            or (user_ch == "scissor" and com_ch == "paper") 
            or (user_ch == "paper" and com_ch == "hammer")):
                user_sc = user_sc + 1
                print("yes!")
                print(f"Now your score : {user_sc} and computer score : {com_sc}")
            
            # you lose
            if ((user_ch == "hammer" and com_ch == "paper") 
            or (user_ch == "scissor" and com_ch == "hammer") 
            or (user_ch == "paper" and com_ch == "scissor")):
                com_sc = com_sc + 1
                print("no!")
                print(f"Now your score : {user_sc} and computer score : {com_sc}")
            
            # you tie
            if ((user_ch == "hammer" and com_ch == "hammer") 
            or (user_ch == "scissor" and com_ch == "scissor") 
            or (user_ch == "paper" and com_ch == "paper")):
                print("ok!")
                print(f"Now your score : {user_sc} and computer score : {com_sc}")
        
        # choice wrong type again
        else: print("your choice is not right please type again")
    
    # summary
    if(user_sc > com_sc):
        print("Congrats You win 😄")
    else:
        print("Sorry! You lose 😭")
    
pao_ying_chub()
