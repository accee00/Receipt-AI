import { GoogleGenerativeAI } from "@google/generative-ai";
import fs from "fs";
import dotenv from "dotenv";
import { ApiError } from "./api.error.js";
import {
    VALID_EXPENSE_CATEGORIES,
    buildBudgetMasterSystemInstruction,
    buildInsightsPrompt,
    getReceiptScanPrompt,
} from "./prompts.js";

dotenv.config({ path: "./.env" });

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || "");
const model = genAI.getGenerativeModel({
    model: "gemini-2.5-flash",
    generationConfig: {
        responseMimeType: "application/json",
        temperature: 0.1,
    },
});

const scanReceipt = async (localFilePath) => {
    try {
        const imageBytes = fs.readFileSync(localFilePath);

        const imagePart = {
            inlineData: {
                data: Buffer.from(imageBytes).toString("base64"),
                mimeType: "image/jpeg",
            },
        };

        const response = await model.generateContent([
            getReceiptScanPrompt(),
            imagePart,
        ]);

        const text = response.response.text() || "{}";
        const json = JSON.parse(text);

        const items = (json.items || []).map((item) => ({
            name: item.name || "Item",
            amount: Number(item.amount) || 0.0,
        }));

        let category = json.category || "other";
        if (!VALID_EXPENSE_CATEGORIES.includes(category)) {
            category = "other";
        }

        let date;
        try {
            date = new Date(json.date);
            if (isNaN(date.getTime())) {
                date = new Date();
            }
        } catch (_) {
            date = new Date();
        }
        console.log(json);
        return {
            merchant: json.merchant || "Unknown Merchant",
            totalAmount: parseFloat(json.totalAmount ?? 0),
            items: items,
            category: category,
            date: date,
        };
    } catch (error) {
        throw new ApiError({
            statusCode: 500,
            message: `Failed to parse receipt data: ${error.message}`,
        });
    }
};

const generateInsights = async (expenses) => {
    if (!expenses || expenses.length === 0) {
        return "No spending data yet. Scan your first receipt!";
    }

    const summary = expenses.reduce((map, e) => {
        const cat = e.category || "other";
        const amount = e.totalAmount || e.total || 0;
        map[cat] = (map[cat] || 0) + amount;
        return map;
    }, {});

    const total = expenses.reduce(
        (sum, e) => sum + (e.totalAmount || e.total || 0),
        0
    );

    const summaryText = Object.entries(summary)
        .map(([key, value]) => `${key}: $${value.toFixed(2)}`)
        .join(", ");

    const textModel = genAI.getGenerativeModel({
        model: "gemini-2.5-flash",
    });

    const prompt = buildInsightsPrompt({
        total,
        expenseCount: expenses.length,
        summaryText,
    });

    try {
        const response = await textModel.generateContent(prompt);
        return (
            response.response.text() ||
            "Keep tracking your expenses to get insights!"
        );
    } catch (error) {
        throw new ApiError({
            statusCode: 500,
            message: `Failed to generate insights: ${error.message}`,
        });
    }
};

/** Gemini chat history must start with `user` and alternate user/model. */
const chatHistory = (history = []) => {
    const formatted = history
        .filter((entry) => entry?.role && entry?.content?.trim())
        .slice(-20)
        .map((entry) => {
            const role =
                entry.role === "assistant" || entry.role === "model"
                    ? "model"
                    : "user";
            return {
                role,
                parts: [{ text: String(entry.content).trim() }],
            };
        });

    let start = 0;
    while (start < formatted.length && formatted[start].role === "model") {
        start += 1;
    }

    const merged = [];
    for (const msg of formatted.slice(start)) {
        const last = merged[merged.length - 1];
        if (last && last.role === msg.role) {
            last.parts[0].text += `\n${msg.parts[0].text}`;
        } else {
            merged.push(msg);
        }
    }

    if (merged.length > 0 && merged[merged.length - 1].role === "user") {
        merged.pop();
    }

    return merged;
};

const chatWithBudgetMaster = async ({
    message,
    history = [],
    userContext = {},
}) => {
    if (!message?.trim()) {
        throw new ApiError({
            statusCode: 400,
            message: "Message is required",
        });
    }

    try {
        const chatModel = genAI.getGenerativeModel({
            model: "gemini-2.5-flash",
            systemInstruction: buildBudgetMasterSystemInstruction(userContext),
            generationConfig: {
                temperature: 0.65,
                maxOutputTokens: 1024,
            },
        });

        const formattedHistory = chatHistory(history);
        const chat = chatModel.startChat({ history: formattedHistory });
        const response = await chat.sendMessage(message.trim());
        const text = response.response.text()?.trim();

        if (!text) {
            throw new ApiError({
                statusCode: 500,
                message:
                    "Budget Master returned an empty reply. Please try again.",
            });
        }

        return text;
    } catch (error) {
        if (error instanceof ApiError) throw error;
        console.error("chatWithBudgetMaster error:", error);
        throw new ApiError({
            statusCode: 500,
            message:
                error?.message ||
                "Failed to chat with our BudgetMaster. Try again later.",
        });
    }
};

export { scanReceipt, generateInsights, chatWithBudgetMaster };
