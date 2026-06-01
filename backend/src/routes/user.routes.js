import { Router } from "express";
import { signUpUser, loginUser, getCurrentUser, addBudget } from "../controllers/user.controller.js";
import verifyToken from "../middleware/auth.middleware.js";

const router = Router();

router.route("/signup").post(signUpUser);
router.route("/login").post(loginUser);
router.route("/me").get(verifyToken, getCurrentUser);
router.route("/add-budget").patch(verifyToken, addBudget);
export default router;