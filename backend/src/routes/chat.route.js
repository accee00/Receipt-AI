import { Router } from "express";
import { chatWithBudgetMasterController } from "../controllers/chat.controller.js";
import verifyToken from "../middleware/auth.middleware.js";

const router = Router();

router.use(verifyToken);
router.route("/").post(chatWithBudgetMasterController);

export default router;
