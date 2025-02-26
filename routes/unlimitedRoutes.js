import express from "express";
import { collectlux, updateScore, collectSensorData, updateLEDStates} from "../controllers/unlimitedController.js";

const router = express.Router();
// Middleware to parse JSON bodies
app.use(express.json());

router.post("/collectlux", collectlux);
router.post("/collectSensorData", collectSensorData);
router.post("/ledcontrol", updateLEDStates);
router.post("/updateScore", updateScore);

// Serve static files from the React app
app.use(express.static('client/build'));

export default router;