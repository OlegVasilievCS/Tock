from random import shuffle
class Deck():
    def __init__(self):

        self.ranks = ['ace_', '2_', '3_', '4_', '5_', '6_', '7_', '8_', '9_', '10_', 'jack_', 'queen_', 'king_']
        self.suits = ['_clubs', '_diamonds', '_hearts', '_spades']
        self.deck = []

    def create_deck(self):
        for i in self.ranks:
            for j in self.suits:
                self.deck.append(f"{i}of{j}")

    def shuffle_deck(self):
        shuffle(self.deck)

    def get_deck(self):
        return self.deck

    def give_random_card(self):
        card_on_top = self.deck[0]
        self.deck.pop(0)
        return card_on_top


