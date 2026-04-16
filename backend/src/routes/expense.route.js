import { Router } from "express";
import { upload } from "../utils/multer.js";
import {
    getDashboardData,
    addExpense,
    scanReceiptImage,
    getUserExpenseInsights,
    updateExpense,
    deleteExpense,
    getExpense,
    getExpenseByMonthOrCategory
} from "../controllers/expense.controller.js";
import verifyToken from "../middleware/auth.middleware.js";

const router = Router();

router.use(verifyToken);

router.route("/dashboard").get(getDashboardData);
router.route("/insights").get(getUserExpenseInsights);
router.route("/").get(getExpenseByMonthOrCategory);
router.route("/add-expense").post(addExpense);
router.route("/scan-receipt").post(upload.single("receipt"), scanReceiptImage);


router.route("/:expenseId")
    .get(getExpense)
    .put(updateExpense)
    .delete(deleteExpense);

export default router;