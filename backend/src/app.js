import express from "express";

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
app.route("/").get((req, res) => {
    res.status(200).json({
        message: "Welcome to the Recept AI API",
    });
});

app.use("/api/v1/users", userRouter);

/// Error logger
app.use((err, req, res, next) => {
    console.error({
        timestamp: new Date().toISOString(),
        message: err.message,
        stack: err.stack,
        path: req.path,
        method: req.method,
    });

    res.status(500).json({
        error: "Something went wrong"
    });
});

export { app };