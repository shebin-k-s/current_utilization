// server.js

import express from "express";
import mongoose from "mongoose";
import dotenv from 'dotenv';
import { Server } from 'socket.io';
import { verifyToken } from "./middleware/authMiddleware.js";
import { utilizationRoute, authRoute, storeUtilizationRoute, deviceRoute, userDeviceRoute } from "./routes/index.js";
import { SocketDevice } from "./socket/socketDevice.js";

dotenv.config();

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/api/auth", authRoute);
app.use("/api/utilization", verifyToken, utilizationRoute);
app.use("/api/storeutilization", storeUtilizationRoute);
app.use("/api/device", deviceRoute);
app.use("/api/user-device", verifyToken, userDeviceRoute);

const PORT = process.env.PORT || 5000;

let io;
const socketDeviceMap = {};

mongoose.connect(process.env.CONNECTION_URL)
    .then(() => {
        const server = app.listen(PORT, () => {
            console.log(`Server running at ${PORT}`);
        });
        io = new Server(server);

        io.on('connection', (socket) => {
            console.log('Client connected');

            const socketDevice = new SocketDevice(socket.id);

            socketDeviceMap[socket.id] = socketDevice;

            socket.on('setDevices', (deviceIds) => {
                console.log(deviceIds);
                socketDevice.addDeviceIds(deviceIds);
            });


            socket.on('disconnect', () => {
                delete socketDeviceMap[socket.id];
                console.log('Client disconnected');
            });
        });

    })
    .catch((error) => {
        console.log(error);
    });

export const updateDeviceStatus = (deviceId, deviceOn) => {
    try {
        for (const socketId in socketDeviceMap) {
            const socketDevice = socketDeviceMap[socketId];
            console.log(socketDevice);
            if (socketDevice.deviceIds.includes(deviceId)) {
                io.to(socketId).emit('deviceStatus', { deviceId, deviceOn });
            }
        }
    } catch (error) {
        console.error('Error updating device status:', error);
    }
};
