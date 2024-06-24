export class SocketDevice {
    constructor(socketId) {
        this.socketId = socketId;
        this.deviceIds = [];
    }

    addDeviceIds(deviceIds) {
        this.deviceIds.length = 0;

        this.deviceIds.push(...deviceIds);
    }

    getDeviceIds() {
        return this.deviceIds;
    }
}