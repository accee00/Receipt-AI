import { Expense } from "../models/expense.model.js";
import { User } from "../models/user.model.js";
import { ApiError } from "../utils/api.error.js";
import { ApiResponse } from "../utils/api.response.js";
import { asyncHandler } from "../utils/asyncHandler.js";
import { chatWithBudgetMaster } from "../utils/gemini.js";

const getCurrentMonthRange = () => {
    const now = new Date();
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
    const startOfNextMonth = new Date(now.getFullYear(), now.getMonth() + 1, 1);
    return { startOfMonth, startOfNextMonth };
};

const getMonthlySpendingContext = async (userId) => {
    const { startOfMonth, startOfNextMonth } = getCurrentMonthRange();

    const matchStage = {
        user: userId,
        date: { $gte: startOfMonth, $lt: startOfNextMonth },
    };

    const [result] = await Expense.aggregate([
        { $match: matchStage },
        {
            $facet: {
                totals: [
                    {
                        $group: {
                            _id: null,
                            totalSpent: { $sum: "$totalAmount" },
                            expenseCount: { $sum: 1 },
                        },
                    },
                ],
                byCategory: [
                    {
                        $group: {
                            _id: "$category",
                            amount: { $sum: "$totalAmount" },
                        },
                    },
                    { $sort: { amount: -1 } },
                ],
                recentTransactions: [
                    { $sort: { date: -1 } },
                    { $limit: 10 },
                    {
                        $project: {
                            merchant: 1,
                            category: 1,
                            totalAmount: 1,
                            date: 1,
                        },
                    },
                ],
            },
        },
    ]);

    const totals = result?.totals?.[0] ?? {
        totalSpent: 0,
        expenseCount: 0,
    };

    const categoryBreakdown = (result?.byCategory ?? []).reduce(
        (acc, row) => {
            acc[row._id || "other"] = row.amount;
            return acc;
        },
        {}
    );

    return {
        totalSpent: totals.totalSpent,
        expenseCount: totals.expenseCount,
        categoryBreakdown,
        recentExpenses: result?.recentTransactions ?? [],
    };
};

const chatWithBudgetMasterController = asyncHandler(async (req, res) => {
    const { message, history = [] } = req.body ?? {};

    if (!message?.trim()) {
        throw new ApiError({ statusCode: 400, message: "Message is required" });
    }

    const userId = req.user._id;

    const [monthlyContext, user] = await Promise.all([
        getMonthlySpendingContext(userId),
        User.findById(userId).select("name budgetLimit"),
    ]);

    const reply = await chatWithBudgetMaster({
        message,
        history,
        userContext: {
            userName: user?.name,
            budgetLimit: user?.budgetLimit ?? 0,
            totalSpent: monthlyContext.totalSpent,
            expenseCount: monthlyContext.expenseCount,
            categoryBreakdown: monthlyContext.categoryBreakdown,
            recentExpenses: monthlyContext.recentExpenses,
        },
    });

    return res.status(200).json(
        new ApiResponse({
            statusCode: 200,
            message: "Reply generated successfully",
            data: {
                reply,
                context: {
                    totalSpent: monthlyContext.totalSpent,
                    expenseCount: monthlyContext.expenseCount,
                    categoryBreakdown: monthlyContext.categoryBreakdown,
                },
            },
        })
    );
});

export { chatWithBudgetMasterController };
