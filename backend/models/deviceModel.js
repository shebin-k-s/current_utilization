import mongoose from "mongoose"

const deviceSchema = new mongoose.Schema({
    deviceId: {
        type: Number,
        required: true,
        unique: true,
    },
    serialNumber: {
        type: String,
        required: true,
        unique: true,
    },
    deviceOn: {
        type: Boolean,
        required: true,
        default: false,
    },
    deviceName: {
        type: String,
    },
})

const Device = mongoose.model('Device', deviceSchema);

export default Device