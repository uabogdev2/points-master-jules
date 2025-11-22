const { verifyToken, saveMove } = require('../utils/api');

module.exports = (io, socket) => {
    socket.on('join_room', async (payload) => {
        const token = payload.auth_token || socket.handshake.auth.token;
        if (!token) {
            socket.emit('error', { message: 'Missing token' });
            return;
        }

        const user = await verifyToken(token);
        if (!user) {
            socket.emit('error', { message: 'Unauthorized' });
            return;
        }

        const gameId = payload.game_id;
        socket.join(`game_${gameId}`);

        io.to(`game_${gameId}`).emit('player_joined', {
            user: {
                id: user.id,
                name: user.name,
                avatar_url: user.avatar_url
            }
        });

        console.log(`User ${user.id} joined game ${gameId}`);
    });

    socket.on('play_move', async (payload) => {
        const token = payload.auth_token || socket.handshake.auth.token;
        if (!token) return;

        const user = await verifyToken(token);
        if (!user) {
            socket.emit('error', { message: 'Unauthorized' });
            return;
        }

        try {
            const moveData = {
                game_id: payload.game_id,
                segment_data: { p1: payload.p1, p2: payload.p2 },
                points_earned: payload.points_earned || 0,
                move_number: payload.move_number || 0
            };

            if (payload.next_turn_user_id) {
                moveData.next_turn_user_id = payload.next_turn_user_id;
            }

            await saveMove(token, moveData);

            io.to(`game_${payload.game_id}`).emit('board_update', {
                game_id: payload.game_id,
                last_move: {
                    user_id: user.id,
                    p1: payload.p1,
                    p2: payload.p2
                },
                points_earned: payload.points_earned,
                next_turn: payload.next_turn_user_id
            });

        } catch (err) {
            const msg = err.response?.data?.message || 'Move failed';
            socket.emit('move_error', { message: msg });
        }
    });
};
