<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Game extends Model
{
    use HasFactory;

    protected $fillable = [
        'status',
        'grid_size',
        'current_turn_user_id',
        'winner_id',
        'started_at',
        'ended_at',
    ];

    protected $casts = [
        'started_at' => 'datetime',
        'ended_at' => 'datetime',
    ];

    public function sessions()
    {
        return $this->hasMany(GameSession::class);
    }

    public function players()
    {
        return $this->belongsToMany(User::class, 'game_sessions')
                    ->withPivot('score', 'player_order', 'color', 'connection_status')
                    ->withTimestamps();
    }

    public function moves()
    {
        return $this->hasMany(Move::class);
    }

    public function winner()
    {
        return $this->belongsTo(User::class, 'winner_id');
    }

    public function currentTurnUser()
    {
        return $this->belongsTo(User::class, 'current_turn_user_id');
    }
}
