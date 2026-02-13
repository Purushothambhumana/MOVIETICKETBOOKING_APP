import axiosInstance from '../utils/axiosConfig';

const movieService = {
    getAllMovies: async () => {
        const response = await axiosInstance.get('/movies');
        return response.data;
    },

    getMovieById: async (id) => {
        const response = await axiosInstance.get(`/movies/${id}`);
        return response.data;
    },

    getMoviesByStatus: async (status) => {
        const response = await axiosInstance.get(`/movies/status/${status}`);
        return response.data;
    },

    createMovie: async (movieData) => {
        const response = await axiosInstance.post('/movies', movieData);
        return response.data;
    },

    updateMovie: async (id, movieData) => {
        const response = await axiosInstance.put(`/movies/${id}`, movieData);
        return response.data;
    },

    deleteMovie: async (id) => {
        await axiosInstance.delete(`/movies/${id}`);
    },
};

export default movieService;
