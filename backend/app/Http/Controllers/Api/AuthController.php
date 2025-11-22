<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Kreait\Laravel\Firebase\Facades\Firebase;
use Throwable;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'firebase_token' => 'required|string',
        ]);

        $firebaseToken = $request->input('firebase_token');

        try {
            $auth = Firebase::auth();
            // Verify the token
            $verifiedIdToken = $auth->verifyIdToken($firebaseToken);
            $uid = $verifiedIdToken->claims()->get('sub');

            // Fetch user info from Firebase to sync
            $firebaseUser = $auth->getUser($uid);

            // Create or Update User
            $user = User::updateOrCreate(
                ['firebase_uid' => $uid],
                [
                    'name' => $firebaseUser->displayName ?? 'Player ' . substr($uid, 0, 6),
                    'email' => $firebaseUser->email ?? $uid . '@example.com', // Fallback if no email
                    'avatar_url' => $firebaseUser->photoUrl,
                    'is_active' => true,
                ]
            );

            // Create Sanctum Token
            $token = $user->createToken('auth_token')->plainTextToken;

            return response()->json([
                'access_token' => $token,
                'token_type' => 'Bearer',
                'user' => $user,
            ]);

        } catch (Throwable $e) {
            return response()->json([
                'message' => 'Authentication failed',
                'error' => $e->getMessage(),
            ], 401);
        }
    }

    public function me(Request $request) {
        return response()->json($request->user());
    }
}
