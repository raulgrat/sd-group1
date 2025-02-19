//game lux page api

import User from "../models/userModel.js";

import Player from "../models/playerModel.js";

export const collectlux = async (req, res) => {
  try {
    // Destructure all three lux values from the request body
    const { lux0, lux1, lux2 } = req.body;
    const userName = "Bot"; // Define the username to search for

    // For example, you might want to store all lux values as an object
    if (lux0 !== undefined && lux1!== undefined && lux2!== undefined) {
    const userRecord = await User.findOne({ username: userName });
    if (userRecord) {
      userRecord.lux0 = parseInt(lux0);
      userRecord.lux1 = parseInt(lux1);
      userRecord.lux2 = parseInt(lux2);
      await userRecord.save();
      res.status(201).json({ lux0: userRecord.lux0, lux1: userRecord.lux1, lux2: userRecord.lux2 });
    } else {
      res.status(404).json({ error: "User not found" });
    }
  } else {
    const userRecord = await User.findOne({ username: userName });
    if (userRecord) {
      res.status(201).json({ user: userRecord });
    } else {
      res.status(404).json({ error: "User not found" });
    }
  }
 } catch (error) {
    console.log("Error in unlimited controller", error.message);
    res.status(500).json({ error: "Internal Server Error" });
  }
};


export const collectSensorData = async (req, res) => {
    try {
        const { co2, temperature, humidity } = req.body;
        const userName = "Bot"; // Define the username to search for

        if (co2 !== undefined && temperature !== undefined && humidity !== undefined) {
          const userRecord = await User.findOne({ username: userName });
          if (userRecord) {
            userRecord.co2 = parseInt(co2); // Set CO2 value
            userRecord.temperature = parseFloat(temperature); // Set temperature value
            userRecord.humidity = parseFloat(humidity); // Set humidity value
            await userRecord.save(); // Save updated record
            res.status(201).json({ co2: userRecord.co2, temperature: userRecord.temperature, humidity: userRecord.humidity }); // Return updated values
          } else {
            res.status(404).json({ error: "User not found" });
          }
        } else {
          const userRecord = await User.findOne({ username: userName });
          if (userRecord) {
            res.status(201).json({ user: userRecord });
          } else {
            res.status(404).json({ error: "User not found" });
          }
        }

    } catch (error) {
      console.log("Error in unlimited controller", error.message);
      res.status(500).json({ error: "Internal Server Error" });
    }
};

// API to handle LED state updates and retrieval
export const updateLedState = async (req, res) => {
  try {
      const userName = "Bot"; // Define the username to search for

      if (req.method === "POST") {
          const { ledState } = req.body; // Expect "on" or "off"

          if (ledState !== "on" && ledState !== "off") {
              return res.status(400).json({ error: "Invalid LED state. Use 'on' or 'off'." });
          }

          const userRecord = await User.findOne({ username: userName });

          if (userRecord) {
              userRecord.ledState = ledState; // Save LED state
              await userRecord.save();
              res.status(201).json({ ledState: userRecord.ledState });
          } else {
              res.status(404).json({ error: "User not found" });
          }
      } else if (req.method === "GET") {
          const userRecord = await User.findOne({ username: userName });

          if (userRecord) {
              res.status(200).json({ ledState: userRecord.ledState || "off" });
          } else {
              res.status(404).json({ error: "User not found" });
          }
      } else {
          res.status(405).json({ error: "Method not allowed" });
      }
  } catch (error) {
      console.log("Error in updateLedState controller", error.message);
      res.status(500).json({ error: "Internal Server Error" });
  }
};


export const updateScore = async (req, res) => {
    try {
        const { username, score } = req.body;

        await User.updateOne({ username }, { score: score })

        res.status(201).json({
            username: username,
            score: score || 0
          });

    } catch (error) {
      console.log("Error in unlimited controller", error.message);
      res.status(500).json({ error: "Internal Server Error" });
    }
};