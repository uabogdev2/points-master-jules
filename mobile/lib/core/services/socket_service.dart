import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;
  bool isConnected = false;

  void init(String token, {String url = 'http://10.0.2.2:3000'}) {
    // 10.0.2.2 is localhost for Android Emulator
    socket = IO.io(url, IO.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .setAuth({'token': token})
      .build());

    socket.onConnect((_) {
      print('Connected to Socket Server');
      isConnected = true;
    });

    socket.onDisconnect((_) {
      print('Disconnected from Socket Server');
      isConnected = false;
    });

    socket.connect();
  }

  void joinRoom(String gameId) {
    socket.emit('join_room', {'game_id': gameId});
  }

  void playMove(String gameId, int p1, int p2) {
    socket.emit('play_move', {
      'game_id': gameId,
      'p1': p1,
      'p2': p2,
    });
  }

  void onBoardUpdate(Function(dynamic) callback) {
    socket.on('board_update', (data) => callback(data));
  }

  void onPlayerJoined(Function(dynamic) callback) {
    socket.on('player_joined', (data) => callback(data));
  }

  void dispose() {
    socket.dispose();
  }
}
