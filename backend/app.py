from flask import Flask
from flask_socketio import SocketIO, emit

from card_deck import Deck
from game_session import GameSession

app = Flask(__name__)
socketio = SocketIO(app, cors_allowed_origins="*")

game_array = []

new_deck = Deck()
new_deck.create_deck()
new_deck.shuffle_deck()


def find_game_via_id_and_add_new_player(currentGameNumber, new_player_joining):
    for game in game_array:
        if int(currentGameNumber) == game.game_session_number:
            if len(game.players) < 4:
                game.players.append(str(new_player_joining))
            print("Game found")
            i = 1
            for player in game.players:
                print(f"P",{i}, ":", {player})
                i += 1


@socketio.on('joinGameViaGameID')
def handle_game_join(data):
    game_id = data.get('gameId')
    new_player_joining = data.get('name')
    find_game_via_id_and_add_new_player(game_id, new_player_joining)
    print(f"Request received to join game id: {str(game_id)}")


@socketio.on('startGame')
def handle_game_creation(name_of_game_creator):
    print(f'Request from {name_of_game_creator} was received')

    new_game_session = GameSession(name_of_game_creator)
    game_array.append(new_game_session)

    print(f'Game created for {new_game_session.players[0]} ')
    print(f'Game Number is {new_game_session.game_session_number} ')
    emit('gameNumberFromServer', new_game_session.game_session_number)



@socketio.on('requestCard')
def handle_cards(game_id):
    # distribute_cards()
    print(f"Received cards request from game: ", game_id)
    hand = []
    for i in range(4):
        hand.append(new_deck.give_random_card())
    emit('getCard',str(hand) )

@socketio.on('sendPosition')
def handle_marble(position):
    print(f'The marble X moved to position {position}')

@socketio.on('connect')
def handle_connect():
    print('A Flutter client connected!')

@socketio.on('msg')
def handle_message(data):
    print(f'Received message: {data}')
    emit('fromServer', 'Message received loud and clear!')




if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=5000, debug=True)