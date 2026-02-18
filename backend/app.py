from flask import Flask
from flask_socketio import SocketIO, emit

from card_deck import Deck

app = Flask(__name__)
socketio = SocketIO(app, cors_allowed_origins="*")

new_deck = Deck()
new_deck.create_deck()
new_deck.shuffle_deck()

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