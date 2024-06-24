import express from 'express'
import {storeUtilizationData } from '../controllers/utilizationController.js'

const router = express.Router()


router.route("/")
    .post(storeUtilizationData)







export default router