import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/socket_service.dart';
import '../widgets/game_board.dart';

final socketProvider = Provider((ref) => SocketService());

class GamePage extends ConsumerStatefulWidget {
  final String gameId;
  const GamePage({super.key, required this.gameId});

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  late SocketService _socketService;
  List<Map<String, int>> moves = [];

  @override
  void initState() {
    super.initState();
    _socketService = ref.read(socketProvider);
    // In real app, token comes from AuthProvider
    _socketService.init("dummy_token_for_test");
    _socketService.joinRoom(widget.gameId);

    _socketService.onBoardUpdate((data) {
      if (mounted) {
        setState(() {
          var move = data['last_move'];
          moves.add({'p1': move['p1'], 'p2': move['p2']});
        });
      }
    });
  }

  @override
  void dispose() {
    _socketService.dispose();
    super.dispose();
  }

  void _handleLineDrawn(int p1, int p2) {
    // Prevent duplicate moves locally
    // Logic to check if line exists...
    _socketService.playMove(widget.gameId, p1, p2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Game ${widget.gameId}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: GameBoard(
            gridSize: 6,
            moves: moves,
            onLineDrawn: _handleLineDrawn,
          ),
        ),
      ),
    );
  }
}
