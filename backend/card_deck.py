from random import shuffle
class Deck():
    def __init__(self):

        self.ranks = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
        self.suits = ['CLUB', 'DIAMOND', 'Heart', 'SPADE']
        self.deck = []

    def create_deck(self):
        for i in self.ranks:
            for j in self.suits:
                self.deck.append(f"{i} of {j}")

    def shuffle_deck(self):
        shuffle(self.deck)

    def get_deck(self):
        return self.deck

    def give_random_card(self):
        card_on_top = self.deck[0]
        self.deck.pop(0)
        return card_on_top


# new_deck = Deck()
# new_deck.create_deck()
# new_deck.shuffle_deck()
# new_deck.give_random_card()

# print(str(len(new_deck.deck)) + str(new_deck.deck))
# print(new_deck.give_random_card())
# print(str(len(new_deck.deck)) + str(new_deck.deck))

