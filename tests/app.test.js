const request = require('supertest');
const { app, server } = require('../src/index');

afterAll(() => server.close());

describe('StreamApp API Tests', () => {

  test('GET /health → returns healthy', async () => {
    const res = await request(app).get('/health');
    expect(res.statusCode).toBe(200);
    expect(res.body.status).toBe('healthy');
  });

  test('GET / → returns welcome message', async () => {
    const res = await request(app).get('/');
    expect(res.statusCode).toBe(200);
    expect(res.body.message).toContain('StreamApp');
  });

  test('GET /api/movies → returns movies list', async () => {
    const res = await request(app).get('/api/movies');
    expect(res.statusCode).toBe(200);
    expect(res.body.movies.length).toBeGreaterThan(0);
  });

  test('GET /api/status → returns uptime', async () => {
    const res = await request(app).get('/api/status');
    expect(res.statusCode).toBe(200);
    expect(res.body.uptime).toBeDefined();
  });

});
