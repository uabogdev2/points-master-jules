require('dotenv').config();
const { Server } = require('socket.io');
const { createClient } = require('redis');
const { createAdapter } = require('@socket.io/redis-adapter');
const gameHandler = require('./handlers/gameHandler');

const PORT = process.env.PORT || 3000;
const REDIS_HOST = process.env.REDIS_HOST || 'localhost';
const REDIS_PORT = process.env.REDIS_PORT || 6379;

async function startServer() {
    const io = new Server(PORT, {
        cors: {
            origin: "*",
            methods: ["GET", "POST"]
        }
    });

    const pubClient = createClient({ url: `redis://${REDIS_HOST}:${REDIS_PORT}` });
    const subClient = pubClient.duplicate();

    await Promise.all([pubClient.connect(), subClient.connect()]);

    io.adapter(createAdapter(pubClient, subClient));

    io.on('connection', (socket) => {
        console.log(`User connected: ${socket.id}`);

        // Register handlers
        gameHandler(io, socket);

        socket.on('disconnect', () => {
            console.log(`User disconnected: ${socket.id}`);
        });
    });

    console.log(`Socket.IO Server running on port ${PORT}`);
}

startServer().catch(console.error);
