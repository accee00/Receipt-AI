import dotenv from "dotenv";
import connectDb from "./db/index.js";
import { app } from "./app.js";

dotenv.config({
    path: "./.env"
});

connectDb().then(() => {
    app.on("error", () => {
        console.log(`Error:${error}`)
    });

    app.listen(process.env.PORT || 8000, () => {
        console.log(`Server running at http://localhost:${process.env.PORT}`);
    });
}).catch((error) => {
    console.log(error);
});
