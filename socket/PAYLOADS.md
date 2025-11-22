# Socket.IO Events & Payloads

## A. Connection / Room Management

**Event: `join_room` (Client -> Server)**
Used to join a game room.
```json
{
  "game_id": 101,
  "user_id": 45,
  "auth_token": "firebase_token_here"
}
```

**Event: `player_joined` (Server -> Client Broadcast)**
Notify others that a player has joined.
```json
{
  "user": {
    "id": 45,
    "name": "PlayerOne",
    "avatar": "url..."
  },
  "player_order": 2
}
```

**Event: `room_state` (Server -> Client)**
Sent to the user who just joined (sync state).
```json
{
  "game_id": 101,
  "status": "pending",
  "players": [ ... ],
  "grid_size": 6,
  "scores": { "45": 0, "52": 0 },
  "board_state": {
    "segments": [ { "p1": 0, "p2": 1, "owner": 52 } ],
    "squares": []
  },
  "current_turn": 52
}
```

## B. Gameplay

**Event: `start_game` (Server -> Client Broadcast)**
When both players are ready.
```json
{
  "game_id": 101,
  "status": "playing",
  "current_turn": 45
}
```

**Event: `play_move` (Client -> Server)**
Player attempts to draw a line.
```json
{
  "game_id": 101,
  "p1": 12,
  "p2": 13
}
```

**Event: `move_error` (Server -> Client)**
If move is invalid.
```json
{
  "code": "INVALID_MOVE",
  "message": "Segment already occupied"
}
```

**Event: `board_update` (Server -> Client Broadcast)**
Successful move.
```json
{
  "game_id": 101,
  "last_move": {
    "user_id": 45,
    "p1": 12,
    "p2": 13
  },
  "completed_squares": [
     { "sq_id": 5, "owner": 45 }
  ],
  "scores": {
    "45": 1,
    "52": 0
  },
  "next_turn": 45,
  "extra_turn": true
}
```
*Note: `extra_turn` is true if the player completed a square.*

## C. Game End

**Event: `game_over` (Server -> Client Broadcast)**
```json
{
  "game_id": 101,
  "winner_id": 45,
  "reason": "score_limit" // or "disconnect"
}
```
