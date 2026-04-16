import { GoogleGenerativeAI } from "@google/generative-ai";
import fs from "fs";
import dotenv from "dotenv";
import { ApiError } from "./api.error.js";

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

        const prompt = `
You are an expert accounting AI specialized in analyzing receipt images.
Extract the following information from the receipt and return ONLY valid JSON matching this exact structure:

{
  "merchant": "Clean store or restaurant name (do not include address or store number)",
  "totalAmount": 0.00,
  "date": "YYYY-MM-DD",
  "category": "Must be exactly one of: ['food', 'transport', 'shopping', 'health', 'entertainment', 'utilities', 'travel', 'other']",
  "items": [
    { "name": "Exact item name from receipt", "amount": 0.00 }
  ]
}

Extraction Rules:
1. Total Amount: Must be the final total paid, including any taxes, tips, and fees. Do not include currency symbols. Ensure it's a number.
2. Date: Use the transaction date shown (YYYY-MM-DD format). If no date is visible, respond with today's date (${new Date().toISOString().split('T')[0]}).
3. Merchant Name: Provide the primary business name only. Ignore address details or legal suffixes like LLC/Inc if possible.
4. Category: Intelligently analyze the merchant and items to select the most appropriate category from the provided list. Default to 'other' only if entirely ambiguous.
5. Items Array: 
    - List every individual purchased item clearly visible.
    - Exclude tax, tip, or subtotal lines from the items list (they belong in the total only).
    - If individual items are illegible, provide a single item summarizing the purchase (e.g., {"name": "General Purchase", "amount": [total]}).
6. Formatting: Ensure the output is strictly valid JSON without any conversational text or markdown code block wrapping.
`;

        const imagePart = {
            inlineData: {
                data: Buffer.from(imageBytes).toString("base64"),
                mimeType: "image/jpeg",
            },
        };

        const response = await model.generateContent([
            prompt,
            imagePart,
        ]);

        const text = response.response.text() || "{}";
        const json = JSON.parse(text);

        const items = (json.items || []).map((item) => ({
            name: item.name || "Item",
            amount: Number(item.amount) || 0.0,
        }));

        let category = json.category || "other";
        const validCategories = [
            "food",
            "transport",
            "shopping",
            "health",
            "entertainment",
            "utilities",
            "travel",
            "other"
        ];

        if (!validCategories.includes(category)) {
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
            total: Number(json.total) || 0.0,
            items: items,
            category: category,
            date: date,
        };
    } catch (error) {
        throw new ApiError({
            statusCode: 500,
            message: `Failed to parse receipt data: ${error.message}`
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

    const prompt = `
You are a highly intelligent, friendly personal finance AI assistant.
Your user has spent a total of $${total.toFixed(2)} across ${expenses.length} transactions this month.
Here is their spending breakdown by category: ${summaryText}

Please write a personalized, warm, and engaging 3-sentence spending insight.
Follow these exact rules:
1. Sentence 1: Acknowledge their biggest spending category without judgment. Note if it's typical or if it's trending high.
2. Sentence 2: Provide ONE highly creative and actionable micro-tip tailored precisely to their top spending category to help them save.
3. Sentence 3: End with an encouraging and positive observation about their ongoing financial tracking.

Tone / Constraints:
- Strict maximum of 80 words.
- Be conversational and warm (use "you" and "your").
- Absolutely no bullet points, lists, emojis, or generic robotic phrases like "In summary" or "Overall".
`;

    try {
        const response = await textModel.generateContent(prompt);
        return response.response.text() || "Keep tracking your expenses to get insights!";
    } catch (error) {
        throw new ApiError({
            statusCode: 500,
            message: `Failed to generate insights: ${error.message}`
        });
    }
};

export { scanReceipt, generateInsights };
