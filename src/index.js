const express = require('express');
const app = express();

app.use(express.json());

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    app: 'StreamApp',
    version: process.env.APP_VERSION || 'v1.0'
  });
});

app.get('/', (req, res) => {
  res.status(200).json({
    message: '🎬 Welcome to StreamApp',
    endpoints: ['/health', '/api/movies', '/api/status']
  });
});

app.get('/api/movies', (req, res) => {
  res.status(200).json({
    movies: [
      { id: 1, title: 'Inception', genre: 'Sci-Fi' },
      { id: 2, title: 'Interstellar', genre: 'Sci-Fi' },
      { id: 3, title: 'The Dark Knight', genre: 'Action' }
    ]
  });
});

app.get('/api/status', (req, res) => {
  res.status(200).json({
    uptime: process.uptime(),
    timestamp: new Date().toISOString(),
    build: process.env.BUILD_NUMBER || 'local'
  });
});

const PORT = process.env.PORT || 3000;
const server = app.listen(PORT, () => {
  console.log(`StreamApp running on port ${PORT}`);
});

module.exports = { app, server };
