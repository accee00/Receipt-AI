import { User } from "../models/user.model.js";
import { ApiError } from "../utils/api.error.js";
import { ApiResponse } from "../utils/api.response.js";
import { asyncHandler } from "../utils/asyncHandler.js";

const getProfile = asyncHandler((req, res) => {
    return res.status(200).json(
        new ApiResponse({
            statusCode: 200,
            message: "User fetched successfully",
            data: req.user,
        })
    );
});

const updateProfile = asyncHandler(async (req, res) => {
    const { name } = req.body;
    if (!name?.trim()) {
        throw new ApiError({
            statusCode: 400,
            message: "Name is required."
        })
    }
    const updatedUser = await User.findByIdAndUpdate(req.user._id, {
        $set: {
            name
        }
    }, { new: true }).select("-password");

    if (!updatedUser) {
        throw new ApiError({
            statusCode: 400,
            message: "Failed to update the user."
        });
    }

    return res.status(200).json(
        new ApiResponse({
            statusCode: 200,
            message: "User name updated.",
            data: updatedUser
        })
    );
});

export { getProfile, updateProfile };