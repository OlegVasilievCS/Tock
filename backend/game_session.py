import random

from card_deck import Deck


class GameSession():
    def __init__(self, player_one):
        self.players = []
        self.players.append(player_one)
        self.game_deck = Deck()


        self.game_session_number = self.game_session_number_generator()



    def game_session_number_generator(self):
        return random.randint(1, 100)

