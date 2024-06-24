import express from 'express'
import { forgetPassword, login, signupUser, resetPassword, deleteUser } from '../controllers/userController.js'

const router = express.Router()

router.route("/signup")
    .post(signupUser)

router.route("/login")
    .post(login)

router.route("/forget-password")
    .post(forgetPassword)

router.route("/reset-password")
    .post(resetPassword)

router.route("/delete-account")
    .delete(deleteUser)

export default router