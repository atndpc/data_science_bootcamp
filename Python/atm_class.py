# HW03 - create new ATM class
# ฝากเงิน, ถอนเงิน, ขอ OTP
class ATM:
    def __init__(self, name, bank, balance):
        self.name = name
        self.bank = bank
        self.balance = balance
    
    def deposit(self, amt):
        self.balance += amt
    def withdraw(self, wtd):
        self.balance -= wtd
    def otp(self):
        print(str(rd.choice(range(0, 10))) + \
        str(rd.choice(range(0, 10))) + \
        str(rd.choice(range(0, 10))) + \
        str(rd.choice(range(0, 10))) + \
        str(rd.choice(range(0, 10))) + \
        str(rd.choice(range(0, 10))))
