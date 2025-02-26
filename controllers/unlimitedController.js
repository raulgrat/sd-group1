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
export const updateLEDStates = async (req, res) => {
  try {
    const { ledStates } = req.body;
    // Validate that ledStates is an array of 20 booleans.
    if (!Array.isArray(ledStates) || ledStates.length !== 20) {
      return res
        .status(400)
        .json({ error: "ledStates must be an array of 20 booleans." });
    }
    
    // Optionally, update the "Bot" user's LED states.
    const userName = "Bot";
    const userRecord = await User.findOne({ username: userName });
    if (userRecord) {
      userRecord.ledStates = ledStates;
      await userRecord.save();
      return res.status(200).json({ ledStates: userRecord.ledStates });
    } else {
      // If the user isn’t found, simply return the sent LED states.
      return res.status(200).json({ ledStates });
    }
  } catch (error) {
    console.error("Error updating LED states:", error.message);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};

//get LED state
export const getLEDStates = async (req, res) => {
  try {
    const userName = "Bot";
    // Retrieve the "Bot" user's LED states
    const userRecord = await User.findOne({ username: userName });
    if (userRecord) {
      return res.status(200).json({ ledStates: userRecord.ledStates });
    } else {
      // Optionally, return a default LED state if the user isn't found
      return res.status(404).json({ error: "User not found" });
    }
  } catch (error) {
    console.error("Error fetching LED states:", error.message);
    return res.status(500).json({ error: "Internal Server Error" });
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