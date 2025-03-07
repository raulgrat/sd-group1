//models for user databse collections/tables

import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
  },
  emailVerified: {
    type: Boolean,
    default: false,
  },
  username: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
    minLength: 6,
  },
  lux0: {
    type: Number, 
    default: 0 ,
  },
  lux1: {
    type: Number, 
    default: 0 ,
  },
  lux2: {
    type: Number, 
    default: 0 ,
  },
  co2: {
    type: Number,
    default: 0,
  },
  temperature: {
    type: Number,
    default: 0,
  },
  humidity: {
    type: Number,
    default: 0,
  },

  ledStates: { 
    type: [Boolean], 
    default: () => new Array(20).fill(false) 
  },
  
});

const User = mongoose.model("users", userSchema);

export default User;
