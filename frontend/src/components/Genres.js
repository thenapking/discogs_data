function Genres({genres}) {
  return (
    <div className="genre">
      <div className="genre-container">
        <h2>Genre</h2>
        <div className="genre-list">
          {genres.map((genre) => (
            <div key={genre.id} className="genre-item">
              <h3>{genre.name}</h3>
              <p>Count: {genre.count}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

export default Genres;
