<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Game;
use App\Models\Move;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class MoveController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'game_id' => 'required|exists:games,id',
            'segment_data' => 'required|array',
            'segment_data.p1' => 'required|integer',
            'segment_data.p2' => 'required|integer',
            'points_earned' => 'required|integer|min:0',
            'move_number' => 'required|integer',
            'next_turn_user_id' => 'nullable|exists:users,id',
        ]);

        $user = $request->user();
        $game = Game::findOrFail($request->game_id);

        if ($game->status !== 'playing') {
            return response()->json(['message' => 'Game not active'], 400);
        }

        if ($game->current_turn_user_id !== $user->id) {
             return response()->json(['message' => 'Not your turn'], 403);
        }

        DB::transaction(function () use ($request, $user, $game) {
            Move::create([
                'game_id' => $game->id,
                'user_id' => $user->id,
                'segment_data' => $request->segment_data,
                'points_earned' => $request->points_earned,
                'move_number' => $request->move_number,
            ]);

            if ($request->points_earned > 0) {
                $game->sessions()->where('user_id', $user->id)->increment('score', $request->points_earned);
            }

            if ($request->has('next_turn_user_id') && $request->next_turn_user_id) {
                $game->update(['current_turn_user_id' => $request->next_turn_user_id]);
            }
        });

        return response()->json(['success' => true]);
    }
}
