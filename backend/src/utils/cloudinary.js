import { v2 as cloudinary } from "cloudinary";
import fs from 'fs'
import dotenv from "dotenv";
dotenv.config({
    path: "./.env"
})

cloudinary.config({
    cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
    api_key: process.env.CLOUDINARY_API_KEY,
    api_secret: process.env.CLOUDINARY_API_SECRET,
});

const uploadReceiptOnCloudinary = async (localFilePath) => {
    try {
        if (!localFilePath) return null;
        const response = await cloudinary.uploader.upload(localFilePath, {
            folder: "expenses",
        });
        console.log("File uploaded successfully", response);
        fs.unlinkSync(localFilePath);
        return response;
    } catch (error) {
        console.log("Error uploading file", error);
        fs.unlinkSync(localFilePath)
        return null;
    }
};

export { uploadReceiptOnCloudinary };