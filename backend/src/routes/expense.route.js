import { Router } from "express";
import { upload } from "../utils/multer.js";
import {
    getDashboardData,
    addExpense,
    scanReceiptImage,
    getUserExpenseInsights,
    getAllExpense,
    updateExpense,
    deleteExpense,
    getExpense,
    getExpenseByMonthOrCategory
} from "../controllers/expense.controller.js";
import { verifyJWT } from "../middlewares/auth.middleware.js";

const router = Router();

router.use(verifyJWT);

router.route("/dashboard").get(getDashboardData);
router.route("/insights").get(getUserExpenseInsights);
router.route("/filter").get(getExpenseByMonthOrCategory);
router.route("/add-expense").post(addExpense);
router.route("/scan-receipt").post(upload.single("receipt"), scanReceiptImage);
router.route("/").get(getAllExpense);

router.route("/:expenseId")
    .get(getExpense)
    .put(updateExpense)
    .delete(deleteExpense);

export default router;