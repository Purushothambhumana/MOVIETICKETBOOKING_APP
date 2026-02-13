import axiosInstance from '../utils/axiosConfig';

const showService = {
    getAllShows: async () => {
        const response = await axiosInstance.get('/shows');
        return response.data;
    },

    getShowById: async (id) => {
        const response = await axiosInstance.get(`/shows/${id}`);
        return response.data;
    },

    getShowsByMovieId: async (movieId) => {
        const response = await axiosInstance.get(`/shows/movie/${movieId}`);
        return response.data;
    },

    getShowsByMovieAndCity: async (movieId, city) => {
        const response = await axiosInstance.get(`/shows/movie/${movieId}/city/${city}`);
        return response.data;
    },

    createShow: async (showData) => {
        const response = await axiosInstance.post('/shows', showData);
        return response.data;
    },

    createBulkShows: async (showsArray) => {
        const response = await axiosInstance.post('/shows/bulk', showsArray);
        return response.data;
    },

    updateShow: async (id, showData) => {
        const response = await axiosInstance.put(`/shows/${id}`, showData);
        return response.data;
    },

    deleteShow: async (id) => {
        await axiosInstance.delete(`/shows/${id}`);
    },
};

export default showService;
