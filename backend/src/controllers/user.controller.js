import { User } from "../models/user.model.js";
import { asyncHandler } from "../utils/asyncHandler.js";
import { ApiError } from "../utils/api.error.js";
import { ApiResponse } from "../utils/api.response.js";

const signUpUser = asyncHandler(async (req, res) => {
    const { name, email, password } = req.body || {};

    if (!name?.trim() || !email?.trim() || !password?.trim()) {
        throw new ApiError({ statusCode: 400, message: "All fields are required" });
    }

    const existingUser = await User.findOne({ email });
    if (existingUser) {
        throw new ApiError({ statusCode: 409, message: "User already exists" });
    }

    const user = await User.create({ name, email, password });

    const token = user.generateToken();

    const safeUser = user.toObject();
    delete safeUser.password;

    return res.status(201).json(
        new ApiResponse({
            statusCode: 201,
            message: "User registered successfully",
            data: { user: safeUser, token },
        })
    );
});

const loginUser = asyncHandler(async (req, res) => {
    const { email, password } = req.body || {};

    if (!email?.trim() || !password?.trim()) {
        throw new ApiError({ statusCode: 400, message: "All fields are required" });
    }

    const user = await User.findOne({ email });
    if (!user) {
        throw new ApiError({ statusCode: 404, message: "User not found" });
    }

    const isPasswordValid = await user.isPasswordCorrect(password);
    if (!isPasswordValid) {
        throw new ApiError({ statusCode: 401, message: "Invalid password" });
    }

    const token = user.generateToken();

    const safeUser = user.toObject();
    delete safeUser.password;

    return res.status(200).json(
        new ApiResponse({
            statusCode: 200,
            message: "User logged in successfully",
            data: { user: safeUser, token },
        })
    );
});

const getCurrentUser = asyncHandler(async (req, res) => {
    return res.status(200).json(
        new ApiResponse({
            statusCode: 200,
            message: "User fetched successfully",
            data: req.user,
        })
    );
});

const updateUserName = asyncHandler(async (req, res) => {
    const { name } = req.body;

    if (!name?.trim()) {
        throw new ApiError({ statusCode: 400, message: "Name is required" });
    }

    const user = await User.findByIdAndUpdate(
        req.user._id,
        { name },
        { new: true }
    ).select("-password");

    if (!user) {
        throw new ApiError({ statusCode: 404, message: "User not found" });
    }

    return res.status(200).json(
        new ApiResponse({
            statusCode: 200,
            message: "Name updated successfully",
            data: user,
        })
    );
});

export { signUpUser, loginUser, getCurrentUser, updateUserName };