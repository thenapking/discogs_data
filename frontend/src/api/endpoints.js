import axios from 'axios';

const API_BASE_URL = 'http://127.0.0.1:3000/api'; // Replace with your actual API base URL
const GENRES_URL = `${API_BASE_URL}/genre_summaries`;

async function getGenres() {
  const response = await axios.get(GENRES_URL);
  return response.data;
}

export { getGenres };
