import express from "express";
import { ApiError } from "./utils/api.error.js";

const app = express();

app.use(express.json({ limit: "16kb" }))

app.use(express.urlencoded({ extended: true, limit: "16kb" }))

/// Logger
app.use((req, res, next) => {
    console.log({
        time: new Date().toISOString(),
        method: req.method,
        url: req.url
    });
    next();
});

///API Routes
import userRouter from "./routes/user.routes.js";
import expenseRouter from "./routes/expense.route.js";

app.route("/").get((req, res) => {
    res.status(200).json({
        message: "Welcome to the Recept AI API",
    });
});

app.use("/api/v1/users", userRouter);
app.use("/api/v1/expenses", expenseRouter);

/// Error logger and response 
app.use((err, req, res, next) => {

    console.error({
        timestamp: new Date().toISOString(),
        error: err.message,
        stack: err.stack,
        path: req.path,
        method: req.method,
    });

    if (err instanceof ApiError) {
        return res.status(err.statusCode || 500).json({
            isSuccess: err.success,
            error: err.error,
            statusCode: err.statusCode,
        });
    }

    return res.status(500).json({
        success: false,
        message: err.message || "Internal Server Error",
    });
});

export { app };