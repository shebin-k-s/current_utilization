import mongoose from 'mongoose';
import Utilization from '../models/utilizationModel.js'
import moment from 'moment-timezone';
import Device from '../models/deviceModel.js';

export const fetchUnitConsumed = async (req, res) => {

    const { startDate, endDate, deviceId } = req.query;
    console.log(req.query);
    
    const startDateUTC = moment(startDate).utc().toDate();
    const endDateUTC = moment(endDate).utc().toDate();

    const endOfDate = new Date(endDateUTC);
    endOfDate.setHours(23, 59, 59, 999);

    try {
        const deviceObjectId = await Device
            .findOne({ deviceId })
            .select('_id')

        const utilizationData = await Utilization
            .find({
                deviceId: deviceObjectId,
                startDate: { $gte: startDateUTC, $lte: endOfDate }
            })
            .select('unitConsumed')

        let totalUnitConsumed = 0;
        utilizationData.forEach(data => {
            totalUnitConsumed += data.unitConsumed;
        });

        console.log(totalUnitConsumed);

        return res.status(200).json({ totalUnitConsumed })
    }
    catch (error) {
        console.error('Error fetching unit consumed:', error);
        return res.status(500).json({ message: "Internal server error" })

    }
}

export const fetchUtilization = async (req, res) => {

    const { startDate, endDate, deviceId } = req.query;
    console.log(req.query);


    const startDateUTC = moment(startDate).utc().toDate();
    const endDateUTC = moment(endDate).utc().toDate();
    const endOfDate = new Date(endDateUTC);
    endOfDate.setHours(23, 59, 59, 999);
    try {
        const deviceObjectId = await Device
            .findOne({ deviceId })
            .select('_id')
        const utilizationData = await Utilization
            .find({
                deviceId: deviceObjectId,
                startDate: { $gte: startDateUTC, $lte: endOfDate }
            })
            .populate('deviceId','deviceName')
            .sort({ startDate: -1 })
            .select('startDate endDate unitConsumed deviceName')
        const utilization = utilizationData.map(data => ({
            startDate: moment(data.startDate).tz('Asia/Kolkata').format('YYYY-MM-DD HH:mm:ss'),
            endDate: moment(data.endDate).tz('Asia/Kolkata').format('YYYY-MM-DD HH:mm:ss'),
            unitConsumed: data.unitConsumed,
            deviceName: data.deviceId.deviceName
        }));
        console.log(utilization);

        return res.status(200).json({ utilization })
    }
    catch (error) {
        console.error('Error fetching utilization Data:', error);
        return res.status(500).json({ message: "Internal server error" })

    }
}

export const storeUtilizationData = async (req, res) => {
    const { deviceId, startDate, endDate, unitConsumed } = req.body;
    try {
        const deviceObjectId = await Device
            .findOne({ deviceId })
            .select('_id')

        const utilizationData = new Utilization({
            deviceId: deviceObjectId,
            startDate,
            endDate,
            unitConsumed
        });
        await utilizationData.save()
        console.log(utilizationData);
        return res.status(201).json({ message: 'Utilization data stored successfully' });
    } catch (error) {
        console.error('Error storing utilization data:', error);
        return res.status(500).json({ message: 'Internal server error' });
    }
}

