import axiosInstance from '../utils/axiosConfig';

const bookingService = {
    createBooking: async (bookingData) => {
        const response = await axiosInstance.post('/bookings', bookingData);
        return response.data;
    },

    getUserBookings: async () => {
        const response = await axiosInstance.get('/bookings/my-bookings');
        return response.data;
    },

    cancelBooking: async (id) => {
        await axiosInstance.put(`/bookings/${id}/cancel`);
    },

    getAvailableSeats: async (showId) => {
        const response = await axiosInstance.get(`/bookings/shows/${showId}/available-seats`);
        return response.data;
    },
};

export default bookingService;
