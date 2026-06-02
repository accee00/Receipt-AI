import { Router } from "express";
import { getProfile, updateUserName } from "../controllers/profile.controller.js";
import verifyToken from "../middleware/auth.middleware.js";

const rotuer = Router();

router.use(verifyToken);
rotuer.route("/profile").get(getProfile);
rotuer.route("/update-name").patch(updateUserName);


export default rotuer;

