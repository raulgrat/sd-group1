import express from "express";
import { collectlux, updateScore, collectSensorData, updateLEDStates,getLEDStates} from "../controllers/unlimitedController.js";

const router = express.Router();

router.post("/collectlux", collectlux);
router.post("/collectSensorData", collectSensorData);
router.post("/ledcontrol", updateLEDStates);
router.get("/getLED", getLEDStates);
router.post("/updateScore", updateScore);

export default router;