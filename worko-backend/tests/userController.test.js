const request = require('supertest');
const app = require('../app');
const mongoose = require('mongoose');

describe('User API', () => {
  beforeAll(async () => {
    await mongoose.connect(process.env.DB_URI, { useNewUrlParser: true, useUnifiedTopology: true });
  });

  afterAll(async () => {
    await mongoose.disconnect();
  });

  it('should create a new user', async () => {
    const response = await request(app)
      .post('/worko/user')
      .send({
        email: 'test@example.com',
        name: 'Test User',
        age: 25,
        city: 'Test City',
        zipCode: '12345'
      });
    expect(response.status).toBe(200);
    expect(response.body.email).toBe('test@example.com');
  });

  // Additional tests for other endpoints can be added similarly
});
