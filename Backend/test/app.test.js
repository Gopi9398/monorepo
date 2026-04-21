const request = require("supertest");
const { app, pool } = require("../app");

test("GET /tasks should return 200", async () => {
  const res = await request(app).get("/tasks");
  expect(res.statusCode).toBe(200);
});

// 👇 THIS IS IMPORTANT
afterAll(async () => {
  await pool.end();
});