import { Expense } from "../models/expense.model.js";
import { ApiError } from "../utils/api.error.js";
import { ApiResponse } from "../utils/api.response.js";
import { asyncHandler } from "../utils/asyncHandler.js";
import { uploadReceiptOnCloudinary } from "../utils/cloudinary.js";
import { scanReceipt, generateInsights } from "../utils/gemini.js";

const getDashboardData = asyncHandler(async (req, res) => {
    const userId = req.user._id;
    const { startDate, endDate } = req.query;

    const dateFilter = {};
    if (startDate) dateFilter.$gte = new Date(startDate);
    if (endDate) dateFilter.$lte = new Date(endDate);

    const matchStage = { user: userId };
    if (startDate || endDate) matchStage.date = dateFilter;

    const statsPipeline = await Expense.aggregate([
        { $match: matchStage },
        {
            $group: {
                _id: null,
                totalExpenses: { $sum: "$totalAmount" },
                totalItems: { $sum: { $size: { $ifNull: ["$items", []] } } },
                uniqueCategories: { $addToSet: "$category" },
                uniqueMerchants: { $addToSet: "$merchant" },
            },
        },
        {
            $project: {
                _id: 0,
                totalExpenses: 1,
                totalItems: 1,
                totalCategories: { $size: "$uniqueCategories" },
                totalMerchants: { $size: "$uniqueMerchants" },
            },
        },
    ]);

    const dashboardStats = statsPipeline[0] || {
        totalExpenses: 0,
        totalItems: 0,
        totalCategories: 0,
        totalMerchants: 0,
    };

    const expenses = await Expense.find(matchStage);
    const insights = await generateInsights(expenses);

    return res.status(200).json(
        new ApiResponse({
            statusCode: 200,
            message: "Dashboard data fetched successfully",
            data: {
                totalExpenses: dashboardStats.totalExpenses,
                totalItems: dashboardStats.totalItems,
                totalCategories: dashboardStats.totalCategories,
                totalMerchants: dashboardStats.totalMerchants,
                insights,
            },
        })
    );
});

const addExpense = asyncHandler(async (req, res) => {
    const { merchant, items, category, description, notes, receiptImage, date } = req.body || {};

    if (!merchant?.trim() || !category?.trim()) {
        throw new ApiError({ statusCode: 400, message: "Merchant and category are required" });
    }



    const totalAmount = items && items.length > 0
        ? items.reduce((acc, item) => acc + (item.amount || item.price || 0), 0) : "00";

    const expense = await Expense.create({
        merchant,
        totalAmount,
        items,
        date: date ? new Date(date) : new Date(),
        category,
        description,
        notes,
        receiptImage,
        user: req.user._id,
    });

    return res.status(201).json(
        new ApiResponse({
            statusCode: 201,
            message: "Expense saved successfully",
            data: expense,
        })
    );
});

const scanReceiptImage = asyncHandler(async (req, res) => {
    const receiptImage = req.file?.path;
    if (!receiptImage) {
        throw new ApiError({ statusCode: 400, message: "Receipt image is required" });
    }

    const scannedData = await scanReceipt(receiptImage);

    const receiptUrl = await uploadReceiptOnCloudinary(receiptImage);

    if (!receiptUrl || !receiptUrl.url) {
        throw new ApiError({ statusCode: 500, message: "Failed to upload receipt to Cloudinary" });
    }

    return res.status(200).json(
        new ApiResponse({
            statusCode: 200,
            message: "Receipt scanned successfully. Awaiting user confirmation.",
            data: {
                extractedData: scannedData,
                receiptImageUrl: receiptUrl.url
            }
        })
    );
});

const getUserExpenseInsights = asyncHandler(async (req, res) => {
    const expenses = await Expense.find({ user: req.user._id });

    const insights = await generateInsights(expenses);

    return res.status(200).json(
        new ApiResponse({
            statusCode: 200,
            message: "Insights generated successfully",
            data: { insights },
        })
    );
});

const getAllExpense = asyncHandler(async (req, res) => {
    const expenses = await Expense.find({ user: req.user._id });
    return res.status(200).json(
        new ApiResponse({
            statusCode: 200,
            message: "Expenses fetched successfully",
            data: expenses,
        })
    );
});

const getExpenseByMonthOrCategory = asyncHandler(async (req, res) => {

    const paramsAndQuery = { ...req.params, ...req.query };
    const { month, year, category, amount, merchant, startDate, endDate } = paramsAndQuery;

    const dbQuery = { user: req.user._id };

    if (year && month) {
        dbQuery.date = {
            $gte: new Date(year, month - 1, 1),
            $lt: new Date(year, month, 1)
        };
    }

    if (startDate || endDate) {
        dbQuery.date = {};
        if (startDate) dbQuery.date.$gte = new Date(startDate);
        if (endDate) dbQuery.date.$lte = new Date(endDate);
    }

    if (category && category !== "null" && category.trim() !== "") {
        dbQuery.category = category;
    }

    if (amount) {
        dbQuery.totalAmount = Number(amount);
    }

    if (merchant && merchant !== "null" && merchant.trim() !== "") {
        dbQuery.merchant = merchant;
    }

    const expenses = await Expense.find(dbQuery);

    return res.status(200).json(
        new ApiResponse({
            statusCode: 200,
            message: "Expenses fetched successfully",
            data: expenses,
        })
    );
});

const deleteExpense = asyncHandler(async (req, res) => {
    const { expenseId } = req.params;
    const expense = await Expense.findByIdAndDelete(expenseId);
    if (!expense) {
        throw new ApiError({ statusCode: 404, message: "Expense not found" });
    }
    return res.status(200).json(
        new ApiResponse({
            statusCode: 200,
            message: "Expense deleted successfully",
            data: expense,
        })
    );
});

const getExpense = asyncHandler(async (req, res) => {
    const { expenseId } = req.params;
    const expense = await Expense.findById(expenseId);
    if (!expense) {
        throw new ApiError({ statusCode: 404, message: "Expense not found" });
    }
    return res.status(200).json(
        new ApiResponse({
            statusCode: 200,
            message: "Expense fetched successfully",
            data: expense,
        })
    );
});

const updateExpense = asyncHandler(async (req, res) => {
    const { expenseId } = req.params;
    const { merchant, items, category, description, notes, receiptImage, date } = req.body || {};

    const updateFields = {};
    if (merchant !== undefined) updateFields.merchant = merchant;
    if (category !== undefined) updateFields.category = category;
    if (description !== undefined) updateFields.description = description;
    if (notes !== undefined) updateFields.notes = notes;
    if (receiptImage !== undefined) updateFields.receiptImage = receiptImage;
    if (date !== undefined) updateFields.date = date;

    if (items !== undefined) {
        updateFields.items = items.map(({ _id, name, amount }) => ({
            _id,
            name,
            amount: Number(amount) || 0,
        }));

        updateFields.totalAmount = updateFields.items.reduce(
            (sum, item) => sum + item.amount, 0
        );
    }

    const expense = await Expense.findByIdAndUpdate(
        expenseId,
        { $set: updateFields },
        {
            new: true,
            // check schema for validation of data
            runValidators: true
        }
    );

    if (!expense) {
        throw new ApiError({ statusCode: 404, message: "Expense not found" });
    }

    return res.status(200).json(
        new ApiResponse({
            statusCode: 200,
            message: "Expense updated successfully",
            data: expense,
        })
    );
});

export {
    getDashboardData,
    addExpense,
    scanReceiptImage,
    getUserExpenseInsights,
    getAllExpense,
    getExpenseByMonthOrCategory,
    deleteExpense,
    updateExpense,
    getExpense
};