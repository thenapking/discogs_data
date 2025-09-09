import logo from './logo.svg';
import './App.css';
import Genres from './components/Genres';
import { useState, useEffect } from 'react'; // React hooks
import { getGenres } from './api/endpoints';

function App() {
  const [genres, setGenres] = useState([]);

  useEffect(() => {
    const fetchGenres = async () => {
      const data = await getGenres();
      setGenres(data);
      console.log(data);
    }
    fetchGenres();
  }, []); 

  return (
    <div className="App">
      <div className="app-container">
        <h1>Discogs</h1>
        <Genres genres={genres} />
      </div>
    </div>
  )
}
export default App;
