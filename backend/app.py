from flask import Flask
from flask_socketio import SocketIO, emit

app = Flask(__name__)
socketio = SocketIO(app, cors_allowed_origins="*")


@socketio.on('connect')
def handle_connect():
    print('A Flutter client connected!')

@socketio.on('msg')
def handle_message(data):
    print(f'Received message: {data}')
    emit('fromServer', 'Message received loud and clear!')

if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=5000, debug=True)