<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Game;
use App\Models\GameSession;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class GameController extends Controller
{
    public function index(Request $request)
    {
        // Return games the user is participating in
        return response()->json(
            $request->user()->sessions()->with('game')->latest()->get()
        );
    }

    public function store(Request $request)
    {
        $request->validate([
            'grid_size' => 'required|integer|in:6,8,10',
        ]);

        $user = $request->user();

        $game = DB::transaction(function () use ($request, $user) {
            // Create Game
            $game = Game::create([
                'status' => 'pending',
                'grid_size' => $request->grid_size,
                'current_turn_user_id' => $user->id,
            ]);

            // Add Creator as Player 1
            GameSession::create([
                'game_id' => $game->id,
                'user_id' => $user->id,
                'player_order' => 1,
                'score' => 0,
                'color' => '#EF4444', // Tailwind Red-500
                'connection_status' => 'connected',
            ]);

            return $game;
        });

        return response()->json($game->load('players'));
    }

    public function join(Request $request, $id)
    {
        $user = $request->user();
        $game = Game::findOrFail($id);

        if ($game->status !== 'pending') {
            // Allow re-joining if disconnected? handled by socket mostly.
            // API join usually means "take a seat".
            return response()->json(['message' => 'Game already started or finished'], 400);
        }

        if ($game->sessions()->where('user_id', $user->id)->exists()) {
            return response()->json($game->load('players'));
        }

        if ($game->sessions()->count() >= 2) {
            return response()->json(['message' => 'Game is full'], 400);
        }

        DB::transaction(function () use ($game, $user) {
            GameSession::create([
                'game_id' => $game->id,
                'user_id' => $user->id,
                'player_order' => 2,
                'score' => 0,
                'color' => '#3B82F6', // Tailwind Blue-500
                'connection_status' => 'connected',
            ]);

            // Update status to playing as we have 2 players
            $game->update([
                'status' => 'playing',
                'started_at' => now()
            ]);
        });

        return response()->json($game->load('players'));
    }

    public function show($id)
    {
        $game = Game::with(['players', 'moves', 'winner'])->findOrFail($id);
        return response()->json($game);
    }
}
