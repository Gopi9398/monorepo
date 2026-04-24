// 👇 ADD THIS FIRST (TOP OF FILE)
jest.mock("pg", () => {
  const mPool = {
    query: jest.fn().mockResolvedValue({
      rows: [{ id: 1, title: "Test Task" }],
    }),
  };
  return { Pool: jest.fn(() => mPool) };
});

// 👇 THEN your imports
const request = require("supertest");
const { app } = require("../app");

// 👇 THEN your test
test("GET /tasks should return 200", async () => {
  const res = await request(app).get("/tasks");
  expect(res.statusCode).toBe(200);
});

