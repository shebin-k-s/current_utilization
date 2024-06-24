import { updateDeviceStatus } from "../index.js";
import Device from "../models/deviceModel.js";
import User from "../models/userModel.js"

export const addDeviceToUser = async (req, res) => {
    const userId = req.user.userId;
    const { deviceId, serialNumber } = req.body;

    try {
        let device = await Device.findOne({ serialNumber, deviceId });
        if (!device) {
            return res.status(204).json({ message: "Device not found" });

        }
        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        if (user.devices.includes(device._id)) {
            return res.status(400).json({ message: "Device already added to the user" });
        }

        user.devices.push(device._id);
        await user.save();

        res.status(200).json({ message: "Successfully added device to the user" });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Internal server error" });
    }
};


export const removeDeviceFromUser = async (req, res) => {
    const userId = req.user.userId;
    const { deviceId, serialNumber } = req.body;

    try {
        let device = await Device.findOne({ serialNumber, deviceId });

        if (!device) {
            return res.status(404).json({ message: "Device not found" });

        }
        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        const deviceIndex = user.devices.indexOf(device._id);
        if (deviceIndex === -1) {
            return res.status(400).json({ message: "Device is not associated with this user" });
        }
        user.devices.splice(deviceIndex, 1);
        await user.save();

        res.status(200).json({ message: "Successfully removed device from user" });

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Internal server error" });
    }
};


export const getDevices = async (req, res) => {
    const userId = req.user.userId;

    try {
        const userDevices = await User.findById(userId).populate('devices').select('devices');

        const devices = userDevices.devices.map(device => ({
            deviceId: device.deviceId,
            serialNumber: device.serialNumber,
            deviceOn: device.deviceOn,
            deviceName: device.deviceName
        }));
        if (!devices) {
            return res.status(404).json({ message: "device not found" });
        }
        res.status(200).json({ devices });

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Internal server error" });
    }
};


export const addDevice = async (req, res) => {
    const { deviceId, serialNumber } = req.body;

    try {
        let device = await Device.findOne({ serialNumber });

        if (device) {
            return res.status(404).json({ message: "Device already added" });

        }

        const newDevice = new Device({
            deviceId,
            serialNumber,
            deviceName: `Device ${deviceId}`
        });
        await newDevice.save();

        res.status(200).json({ message: "Device added successfully" });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Internal server error" });
    }
};


export const removeDevice = async (req, res) => {
    const { deviceId, serialNumber } = req.body;

    try {
        let device = await Device.findOne({ serialNumber, deviceId });

        if (!device) {
            return res.status(404).json({ message: "Device not found" });

        }

        await Device.deleteOne({ serialNumber });


        res.status(200).json({ message: "Device deleted successfully" });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Internal server error" });
    }
};

export const changeDeviceName = async (req, res) => {
    const { deviceId, serialNumber, deviceName } = req.body;

    try {
        let device = await Device.findOne({ serialNumber, deviceId });

        if (!device) {
            return res.status(404).json({ message: "Device not found" });
        }

        device.deviceName = deviceName;
        await device.save();

        return res.status(200).json({ message: "Device name updated successfully", device });
    } catch (error) {
        console.error("Error updating device name:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
}

export const changeDeviceStatus = async (req, res) => {
    const { deviceId, deviceOn } = req.body;

    try {
        let device = await Device.findOne({ deviceId });

        if (!device) {
            return res.status(404).json({ message: "Device not found" });
        }

        device.deviceOn = deviceOn;
        await device.save();

        updateDeviceStatus(device.deviceId, deviceOn);

        return res.status(200).json({ message: "Device status updated successfully", device });
    } catch (error) {
        console.error("Error updating device status:", error);
        return res.status(500).json({ message: "Internal server error" });
    }
}

