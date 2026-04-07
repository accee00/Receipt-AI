import mongoose from "mongoose";
import { DB_NAME } from "../constants.js";
const connectDB = async () => {
    try {
        const dbConnection = await mongoose.connect(`${process.env.MONGOOSE_URI}/${DB_NAME}`);
        console.log(`MongoDB connected To : ${dbConnection.connection.host}`);
    } catch (e) {
        console.log(`DB connection error: ${e}`);
        process.exit(1);
    }
};

export default connectDB;