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

// Catch-all handler for any requests that don't match the above
app.get('*', (req, res) => {
    res.sendFile(path.resolve('client', 'build', 'index.html'));
  });


export default router;