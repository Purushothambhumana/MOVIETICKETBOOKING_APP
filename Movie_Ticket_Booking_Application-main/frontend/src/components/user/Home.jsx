import React, { useState, useEffect, useContext } from 'react';
import { Container, Row, Col, Card, Form, InputGroup } from 'react-bootstrap';
import { useNavigate } from 'react-router-dom';
import movieService from '../../services/movieService';
import { CityContext } from '../../context/CityContext';
import CitySelector from '../common/CitySelector';

const Home = () => {
    const navigate = useNavigate();
    const [movies, setMovies] = useState([]);
    const [searchQuery, setSearchQuery] = useState('');
    const { selectedCity, setSelectedCity } = useContext(CityContext);

    useEffect(() => {
        loadMovies();
    }, []);

    const loadMovies = async () => {
        try {
            const data = await movieService.getMoviesByStatus('NOW_SHOWING');
            setMovies(data);
        } catch (error) {
            console.error('Error loading movies:', error);
        }
    };

    const handleMovieClick = (movieId) => {
        navigate(`/movies/${movieId}`);
    };

    // Filter movies based on search query
    const filteredMovies = movies.filter(movie =>
        movie.title.toLowerCase().includes(searchQuery.toLowerCase())
    );

    return (
        <>
            <div style={{ backgroundColor: 'var(--bms-light-gray)', padding: '2rem 0' }}>
                <Container>
                    <Row className="align-items-center">
                        <Col md={6}>
                            <h1 style={{ color: 'var(--bms-dark-gray)' }}>
                                Welcome to Bhumana'Show
                            </h1>
                            <p className="text-muted">Book your favorite movies now!</p>
                        </Col>
                        <Col md={6}>
                            <div>
                                <label className="fw-bold mb-2">Select Your City</label>
                                <CitySelector
                                    selectedCity={selectedCity}
                                    onCityChange={setSelectedCity}
                                />
                            </div>
                        </Col>
                    </Row>
                </Container>
            </div>

            <Container className="mt-4">
                <Row className="align-items-center mb-4">
                    <Col md={6}>
                        <h2 style={{ color: 'var(--bms-dark-gray)' }}>
                            Movies Now Showing {filteredMovies.length > 0 && `(${filteredMovies.length})`}
                        </h2>
                    </Col>
                    <Col md={6}>
                        <InputGroup>
                            <InputGroup.Text>
                                <i className="bi bi-search"></i>
                            </InputGroup.Text>
                            <Form.Control
                                type="text"
                                placeholder="Search movies by title..."
                                value={searchQuery}
                                onChange={(e) => setSearchQuery(e.target.value)}
                            />
                            {searchQuery && (
                                <InputGroup.Text
                                    style={{ cursor: 'pointer' }}
                                    onClick={() => setSearchQuery('')}
                                >
                                    <i className="bi bi-x-lg"></i>
                                </InputGroup.Text>
                            )}
                        </InputGroup>
                    </Col>
                </Row>
                <Row>
                    {filteredMovies.length > 0 ? (
                        filteredMovies.map((movie) => (
                            <Col key={movie.id} md={3} className="mb-4">
                                <Card
                                    className="movie-card"
                                    onClick={() => handleMovieClick(movie.id)}
                                >
                                    <Card.Img
                                        variant="top"
                                        src={movie.posterUrl || 'https://via.placeholder.com/300x400?text=' + movie.title}
                                        className="movie-poster"
                                    />
                                    <Card.Body>
                                        <Card.Title className="movie-title">{movie.title}</Card.Title>
                                        <Card.Text className="movie-genre">
                                            {movie.genre} • {movie.language}
                                        </Card.Text>
                                        <span className="badge bg-secondary">{movie.certification}</span>
                                    </Card.Body>
                                </Card>
                            </Col>
                        ))
                    ) : (
                        <Col>
                            <p className="text-center text-muted">
                                {searchQuery ? `No movies found matching "${searchQuery}"` : 'No movies available'}
                            </p>
                        </Col>
                    )}
                </Row>
            </Container>
        </>
    );
};

export default Home;

