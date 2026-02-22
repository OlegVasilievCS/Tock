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

# @socketio.on('getGameNumber')
# def handle_game_number():
#     emit('gameNumberFromServer', )

def find_game_via_id_and_add_new_player(currentGameNumber, new_player_joining):
    for game in game_array:
        if int(currentGameNumber) == game.game_session_number:
            if game.player_two == '':
                game.player_two = str(new_player_joining)
            print("Game found")
            print(f"P1:", {game.player_one})
            print(f"P2:", {game.player_two})


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

    print(f'Game created for {new_game_session.player_one} ')
    print(f'Gname Number is {new_game_session.game_session_number} ')
    emit('gameNumberFromServer', new_game_session.game_session_number)

    # emit('announceGame', str(new_game_session.game_session_number))


@socketio.on('requestCard')
def handle_cards():
    # distribute_cards()
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

# def distribute_cards():



if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=5000, debug=True)