import axios from 'axios';

const baseURL = import.meta.env.VITE_API_URL || 'http://localhost:3001';

export const healthCheck = async () => {
    const response = await axios.get('/health_check');
    if (response.status !== 200) {
        throw new Error('Health check failed');
    }

    return response.data;
}

export const getWorkouts = async () => {
    const response = await axios.get(`${baseURL}/workouts`);
    return handleResponse(response)
}

const handleResponse = (response) => {
    if (response.status !== 200) {
        return { error: response.data, data: null };
    }
    return {data: response.data, error: null};
}
