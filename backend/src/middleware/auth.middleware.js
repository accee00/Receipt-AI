import jwt from "jsonwebtoken";
import { User } from "../models/user.model.js";

const verifyToken = async (req, _, next) => {
    try {
        const token = req.headers["Authorization"];
        if (!token) {
            return res.status(401).json({ message: "Unauthorized" });
        }
        const decodedToken = jwt.verify(token, process.env.TOKEN_SECRET);
        const user = User.findById(decodedToken._id).select("-password");
        if (!user) {
            return res.status(401).json({ message: "Expired or malfunctioned token." });
        }
        req.user = user;
        next();
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
export default verifyToken;