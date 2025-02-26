import express from "express";
import authRoutes from "./routes/authRoutes.js";
import dailyRoutes from "./routes/dailyRoutes.js";
import unlimitedRoutes from "./routes/unlimitedRoutes.js";
import gameRoutes from "./routes/gameRoutes.js";
import playersRoutes from "./routes/playersRoutes.js";
import connectToMongoDB from "./db/connectToMongoDB.js";
import { fileURLToPath } from "url";
import { dirname } from "path";
import cors from "cors";
import path from "path";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const PORT = process.env.PORT || 5001;
const app = express();

app.use(cors());
app.use(express.json());

// Define API routes before the static assets and catch-all route
app.use("/api/auth", authRoutes);
app.use("/api/daily", dailyRoutes);
app.use("/api/unlimited", unlimitedRoutes);
app.use("/api/game", gameRoutes);
app.use("/api/players", playersRoutes);

// Serve static assets if in production
if (process.env.NODE_ENV === "production") {
  // Set static folder
  app.use(express.static("frontend/build"));
  app.get("*", (req, res) => {
    res.sendFile(path.resolve(__dirname, "frontend", "build", "index.html"));
  });
}

app.listen(PORT, () => {
  connectToMongoDB();
  console.log(`Server running on port ${PORT}`);
});
