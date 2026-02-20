import random

class GameSession():
    def __init__(self, player_one):
        self.player_one = player_one
        self.player_two = ''
        self.player_three = ''
        self.player_four = ''

        self.game_session_number = self.game_session_number_generator()



    def game_session_number_generator(self):
        return random.randint(1, 100)

