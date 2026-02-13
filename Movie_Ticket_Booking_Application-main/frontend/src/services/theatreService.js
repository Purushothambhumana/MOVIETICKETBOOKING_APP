import axiosInstance from '../utils/axiosConfig';

const theatreService = {
    getAllTheatres: async () => {
        const response = await axiosInstance.get('/theatres');
        return response.data;
    },

    getAllScreens: async () => {
        const response = await axiosInstance.get('/theatres/screens/all');
        return response.data;
    },

    getTheatresByCity: async (city) => {
        const response = await axiosInstance.get(`/theatres/city/${city}`);
        return response.data;
    },

    createTheatre: async (theatreData) => {
        const response = await axiosInstance.post('/theatres', theatreData);
        return response.data;
    },

    createScreen: async (screenData) => {
        const response = await axiosInstance.post('/theatres/screens', screenData);
        return response.data;
    },

    createSeats: async (screenId, seatData) => {
        await axiosInstance.post(`/theatres/screens/${screenId}/seats`, seatData);
    },

    getScreensByTheatreId: async (theatreId) => {
        const response = await axiosInstance.get(`/theatres/${theatreId}/screens`);
        return response.data;
    },

    updateTheatre: async (id, theatreData) => {
        const response = await axiosInstance.put(`/theatres/${id}`, theatreData);
        return response.data;
    },

    updateScreen: async (id, screenData) => {
        const response = await axiosInstance.put(`/theatres/screens/${id}`, screenData);
        return response.data;
    },

    deleteScreen: async (id) => {
        await axiosInstance.delete(`/theatres/screens/${id}`);
    },

    deleteTheatre: async (id) => {
        await axiosInstance.delete(`/theatres/${id}`);
    },

    // Bulk seat management for custom layouts
    createBulkSeats: async (screenId, seats) => {
        const response = await axiosInstance.post(`/theatres/screens/${screenId}/seats/bulk`, seats);
        return response.data;
    },

    deleteAllSeatsForScreen: async (screenId) => {
        const response = await axiosInstance.delete(`/theatres/screens/${screenId}/seats`);
        return response.data;
    },

    getSeatsForScreen: async (screenId) => {
        const response = await axiosInstance.get(`/theatres/screens/${screenId}/seats`);
        return response.data;
    },
};

export default theatreService;
