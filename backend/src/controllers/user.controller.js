import { User } from "../models/user.model.js";

const registerUser = async (req, res) => {
    const { name, email, password } = req.body || {};
    if (!name?.trim() || !email?.trim() || !password?.trim()) {
        return res.status(400).json({
            error: "All fields are required",
            statusCode: 400,
        });
    }
    const user = await User.create({
        name, email, password,
    }).select("-password");
    const token = user.generateToken();
    return res.status(201).json({
        message: "User registered successfully",
        data: user,
        token: token,
    });
};

const loginUser = async (req, res) => {
    const { email, password } = req.body || {};

    if (!email?.trim() || !password?.trim()) {
        return res.status(400).json({
            error: "All fields are required"
        })
    }
    const user = await User.findOne({ email });
    if (!user) {
        return res.status(404).json({
            error: "User not found."
        });
    }

    const isPasswordValid = await user.isPasswordCorrect(password);
    if (!isPasswordValid) {
        return res.status(401).json({
            error: "Invalid password."
        });
    }
    const token = user.generateToken();
    return res.status(200).json({
        message: "User logged in successfully",
        data: user,
        token: token,
    });
};

const getCurrentUser = async (req, res) => {
    return res.status(200).json({
        message: "User fetched successfully",
        data: req.user,
    })
}

export { registerUser, loginUser, getCurrentUser };