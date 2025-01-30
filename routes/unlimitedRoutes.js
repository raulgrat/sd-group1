import express from "express";
import { collectlux, updateScore, collectSensorData, updateLedState} from "../controllers/unlimitedController.js";

const router = express.Router();

router.post("/collectlux", collectlux);
router.post("/collectSensorData", collectSensorData);
router.post("/updateLedState", updateLedState);
router.post("/updateScore", updateScore);


export default router;