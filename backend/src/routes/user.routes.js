import { Router } from "express";
import { signUpUser, loginUser, getCurrentUser } from "../controllers/user.controller.js";
import verifyToken from "../middleware/auth.middleware.js";

const router = Router();

router.route("/signup").post(signUpUser);
router.route("/login").post(loginUser);
router.route("/me").get(verifyToken, getCurrentUser);
export default router;