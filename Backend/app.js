const express = require("express");
const { Pool } = require("pg");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(express.json());

const pool = new Pool({
  user: "postgres",
  host: "database-1.cn22q0gk8wbf.ap-south-2.rds.amazonaws.com",
  database: "tasksdb",
  password: "gopikrishna123",
  port: 5432,
});

// ✅ Initialize DB properly
async function initDB() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS tasks (
      id SERIAL PRIMARY KEY,
      title TEXT
    )
  `);
  console.log("Table ensured");
}

// Routes
app.get("/tasks", async (req, res) => {
  const result = await pool.query("SELECT * FROM tasks");
  res.json(result.rows);
});

app.post("/tasks", async (req, res) => {
  const { title } = req.body;
  await pool.query("INSERT INTO tasks(title) VALUES($1)", [title]);
  res.send("Task added");
});

app.delete("/tasks/:id", async (req, res) => {
  await pool.query("DELETE FROM tasks WHERE id=$1", [req.params.id]);
  res.send("Task deleted");
});

// ✅ Start server only after DB ready
initDB().then(() => {
  app.listen(5000, () => {
    console.log("Backend running on port 5000");
  });
});