import axiosInstance from '../utils/axiosConfig';

const authService = {
    register: async (userData) => {
        const response = await axiosInstance.post('/auth/register', userData);
        return response.data;
    },

    login: async (credentials) => {
        const response = await axiosInstance.post('/auth/login', credentials);
        if (response.data.token) {
            localStorage.setItem('token', response.data.token);
            localStorage.setItem('user', JSON.stringify(response.data));
        }
        return response.data;
    },

    logout: () => {
        localStorage.removeItem('token');
        localStorage.removeItem('user');
    },

    getCurrentUser: () => {
        return JSON.parse(localStorage.getItem('user'));
    },

    isAuthenticated: () => {
        return localStorage.getItem('token') !== null;
    },

    isAdmin: () => {
        const user = authService.getCurrentUser();
        return user && user.roles && user.roles.includes('ROLE_ADMIN');
    },
};

export default authService;
