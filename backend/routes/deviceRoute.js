import express from 'express'
import { addDevice, changeDeviceStatus, removeDevice } from '../controllers/deviceController.js'

const router = express.Router()

router.route("/add-device")
    .post(addDevice)

router.route("/remove-device")
    .delete(removeDevice)

router.route("/change-devicestatus")
    .post(changeDeviceStatus)
export default router