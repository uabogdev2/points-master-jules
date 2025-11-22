<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasFactory, Notifiable, HasApiTokens;

    protected $fillable = [
        'firebase_uid',
        'name',
        'email',
        'avatar_url',
        'is_active',
    ];

    protected $hidden = [
        'remember_token',
    ];

    public function sessions()
    {
        return $this->hasMany(GameSession::class);
    }

    public function moves()
    {
        return $this->hasMany(Move::class);
    }
}
