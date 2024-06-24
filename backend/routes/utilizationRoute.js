import express from 'express'
import { fetchUnitConsumed, fetchUtilization, storeUtilizationData } from '../controllers/utilizationController.js'

const router = express.Router()



router.route("/unit-consumed")
    .get(fetchUnitConsumed)
router.route("/history")
    .get(fetchUtilization)







export default router