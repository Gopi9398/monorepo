const express = require("express");
const { Pool } = require("pg");
const cors = require("cors");

const app = express();
app.use(cors({
  origin: "https://dev-ops-assignment-8byte.vercel.app/"
}));
app.use(express.json());

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: 5432,
  ssl: {
    rejectUnauthorized: false,
  },  
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

app.get("/", (req, res) => {
  res.status(200).send("OK");
});


// ✅ Start server only after DB ready

module.exports = { app, pool };

if (require.main === module) {
  initDB()
    .then(() => {
      app.listen(5000, "0.0.0.0", () => {
        console.log("Backend running on port 5000");
      });
    })
    .catch((err) => {
      console.error("Failed to connect to DB:", err);
      process.exit(1);
    });
}
