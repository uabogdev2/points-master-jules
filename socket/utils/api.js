const axios = require('axios');

const API_URL = process.env.API_URL || 'http://localhost:8000/api';

async function verifyToken(token) {
    try {
        const response = await axios.get(`${API_URL}/user`, {
            headers: { Authorization: `Bearer ${token}` }
        });
        return response.data;
    } catch (error) {
        // console.error('Token verification failed:', error.message);
        return null;
    }
}

async function saveMove(token, moveData) {
    try {
        const response = await axios.post(`${API_URL}/moves`, moveData, {
            headers: { Authorization: `Bearer ${token}` }
        });
        return response.data;
    } catch (error) {
        console.error('Save move failed:', error.response?.data || error.message);
        throw error;
    }
}

module.exports = { verifyToken, saveMove };
