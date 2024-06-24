import express from 'express'
import { addDeviceToUser, changeDeviceName, getDevices, removeDeviceFromUser } from '../controllers/deviceController.js'

const router = express.Router()

router.route("/add-device")
    .post(addDeviceToUser)

router.route("/remove-device")
    .delete(removeDeviceFromUser)

router.route("/get-devices")
    .get(getDevices)
router.route("/change-devicename")
    .post(changeDeviceName)



export default router