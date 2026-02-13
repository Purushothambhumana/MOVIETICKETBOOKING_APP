import React, { useState, useEffect, useContext } from 'react';
import { Container, Row, Col, Card, Button, Badge } from 'react-bootstrap';
import { useParams, useNavigate } from 'react-router-dom';
import movieService from '../../services/movieService';
import showService from '../../services/showService';
import { CityContext } from '../../context/CityContext';
import CitySelector from '../common/CitySelector';

const MovieDetails = () => {
    const { id } = useParams();
    const navigate = useNavigate();
    const [movie, setMovie] = useState(null);
    const [shows, setShows] = useState([]);
    const { selectedCity, setSelectedCity } = useContext(CityContext);
    const [selectedDate, setSelectedDate] = useState(null);
    const [availableDates, setAvailableDates] = useState([]);

    useEffect(() => {
        loadMovieDetails();
        loadShows();
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [id, selectedCity]);

    useEffect(() => {
        // Generate next 7 days for date selector
        const dates = [];
        const today = new Date();
        for (let i = 0; i < 7; i++) {
            const date = new Date(today);
            date.setDate(today.getDate() + i);
            dates.push(date);
        }
        setAvailableDates(dates);
        setSelectedDate(dates[0]); // Select today by default
    }, []);

    const loadMovieDetails = async () => {
        try {
            const data = await movieService.getMovieById(id);
            setMovie(data);
        } catch (error) {
            console.error('Error loading movie details:', error);
        }
    };

    const loadShows = async () => {
        try {
            const data = await showService.getShowsByMovieAndCity(id, selectedCity);
            setShows(data);
        } catch (error) {
            console.error('Error loading shows:', error);
        }
    };

    const handleShowSelection = (showId) => {
        navigate(`/seat-selection/${showId}`);
    };

    const formatDate = (date) => {
        const days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
        const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];

        return {
            day: days[date.getDay()],
            date: date.getDate(),
            month: months[date.getMonth()],
            fullDate: date.toISOString().split('T')[0]
        };
    };

    const isSameDate = (date1, date2) => {
        return date1.toISOString().split('T')[0] === date2.toISOString().split('T')[0];
    };

    const isToday = (date) => {
        const today = new Date();
        return isSameDate(date, today);
    };

    // Get theatre logo/badge based on name
    const getTheatreBadge = (theatreName) => {
        const name = theatreName.toLowerCase();
        if (name.includes('pvr')) {
            return { name: 'PVR', color: '#C4242B', icon: '🎬' };
        } else if (name.includes('inox')) {
            return { name: 'INOX', color: '#1976D2', icon: '🎬' };
        } else if (name.includes('cinepolis')) {
            return { name: 'CINEPOLIS', color: '#E91E63', icon: '🎬' };
        } else if (name.includes('carnival')) {
            return { name: 'CARNIVAL', color: '#FF9800', icon: '🎬' };
        } else if (name.includes('metropolis')) {
            return { name: 'METROPOLIS', color: '#9C27B0', icon: '🎬' };
        } else {
            // Generic badge with first letters
            const words = theatreName.split(' ');
            const initials = words.slice(0, 2).map(w => w[0]).join('').toUpperCase();
            return { name: initials, color: '#666666', icon: '🏢' };
        }
    };

    // Check if show is premium screen
    const isPremiumScreen = (show) => {
        const screenName = (show.screenName || '').toLowerCase();
        const theatreName = (show.theatreName || '').toLowerCase();

        if (screenName.includes('prime') || screenName.includes('luxe')) return 'PRIME LUXE';
        if (screenName.includes('imax')) return 'IMAX';
        if (screenName.includes('4dx')) return '4DX';
        if (screenName.includes('gold') || theatreName.includes('gold')) return 'GOLD';
        if (screenName.includes('vip')) return 'VIP';
        return null;
    };

    // Filter shows by selected date
    const filteredShows = shows.filter(show => {
        if (!selectedDate) return true;
        const showDate = new Date(show.showDate);
        return isSameDate(showDate, selectedDate);
    });

    // Group shows by theatre
    const showsByTheatre = filteredShows.reduce((acc, show) => {
        if (!acc[show.theatreName]) {
            acc[show.theatreName] = {
                name: show.theatreName,
                city: show.city || selectedCity,
                shows: []
            };
        }
        acc[show.theatreName].shows.push(show);
        return acc;
    }, {});

    if (!movie) {
        return <Container className="mt-5"><p>Loading...</p></Container>;
    }

    return (
        <Container className="mt-4">
            {/* City Selector */}
            <Row className="mb-4">
                <Col md={12}>
                    <div className="d-flex align-items-center justify-content-between p-3" style={{ backgroundColor: 'var(--bms-light-gray)', borderRadius: '8px' }}>
                        <h5 className="mb-0" style={{ color: 'var(--bms-dark-gray)' }}>Select Your City</h5>
                        <div style={{ width: '300px' }}>
                            <CitySelector
                                selectedCity={selectedCity}
                                onCityChange={setSelectedCity}
                            />
                        </div>
                    </div>
                </Col>
            </Row>

            <Row>
                <Col md={3}>
                    <img
                        src={movie.posterUrl || 'https://via.placeholder.com/300x400?text=' + movie.title}
                        alt={movie.title}
                        className="img-fluid rounded"
                    />
                </Col>
                <Col md={9}>
                    <h1>{movie.title}</h1>
                    <div className="mb-3">
                        <Badge bg="secondary" className="me-2">{movie.certification}</Badge>
                        <Badge bg="info">{movie.language}</Badge>
                    </div>
                    <p><strong>Genre:</strong> {movie.genre}</p>
                    <p><strong>Duration:</strong> {movie.duration} minutes</p>
                    <p><strong>Release Date:</strong> {new Date(movie.releaseDate).toLocaleDateString()}</p>
                    <p className="mt-3">{movie.description}</p>
                </Col>
            </Row>

            <hr className="my-5" />

            {/* Date Selector */}
            <div className="date-selector-container mb-4">
                <div className="date-selector-scroll">
                    {availableDates.map((date, index) => {
                        const formatted = formatDate(date);
                        const selected = selectedDate && isSameDate(date, selectedDate);
                        const today = isToday(date);

                        return (
                            <button
                                key={index}
                                className={`date-selector-btn ${selected ? 'selected' : ''}`}
                                onClick={() => setSelectedDate(date)}
                            >
                                <div className="date-day">{formatted.day}</div>
                                <div className="date-number">{formatted.date}</div>
                                <div className="date-month">{today ? 'TODAY' : formatted.month}</div>
                            </button>
                        );
                    })}
                </div>
            </div>

            <h3 className="mb-4">Select Theatre & Show Time</h3>
            {Object.keys(showsByTheatre).length > 0 ? (
                Object.entries(showsByTheatre).map(([theatreName, theatre]) => {
                    const badge = getTheatreBadge(theatreName);

                    return (
                        <Card key={theatreName} className="theatre-card mb-3">
                            <Card.Body>
                                <div className="d-flex justify-content-between align-items-start mb-2">
                                    <div className="flex-grow-1">
                                        <div className="d-flex align-items-center mb-2">
                                            <span
                                                className="theatre-badge me-2"
                                                style={{
                                                    backgroundColor: badge.color,
                                                    color: 'white',
                                                    padding: '4px 10px',
                                                    borderRadius: '4px',
                                                    fontSize: '0.75rem',
                                                    fontWeight: '700',
                                                    letterSpacing: '0.5px'
                                                }}
                                            >
                                                {badge.icon} {badge.name}
                                            </span>
                                            <h5 className="theatre-name mb-0">
                                                {theatreName.replace(/^(PVR|INOX|Cinepolis|Carnival|Metropolis):/i, '').trim()}
                                            </h5>
                                        </div>
                                        <div className="d-flex align-items-center gap-2 mb-1">
                                            <p className="theatre-info text-muted mb-0">
                                                <small>📍 {theatre.city}</small>
                                            </p>
                                        </div>
                                        <div className="amenities-container mb-2">
                                            <span className="amenity-icon" title="Food & Beverages">🍿</span>
                                            <span className="amenity-icon" title="M-Ticket">📱</span>
                                        </div>
                                        <p className="cancellation-text">
                                            <small>✓ Cancellation available</small>
                                        </p>
                                    </div>
                                    <button className="favorite-btn" title="Add to favorites">
                                        ❤️
                                    </button>
                                </div>
                                <div className="show-times-container">
                                    {theatre.shows.map((show) => {
                                        const premiumLabel = isPremiumScreen(show);

                                        return (
                                            <button
                                                key={show.id}
                                                className={`show-time-btn ${premiumLabel ? 'premium-show' : ''}`}
                                                onClick={() => handleShowSelection(show.id)}
                                            >
                                                <div className="show-time-text">
                                                    {new Date(`2000-01-01T${show.showTime}`).toLocaleTimeString([], {
                                                        hour: '2-digit',
                                                        minute: '2-digit',
                                                        hour12: true
                                                    })}
                                                </div>
                                                {premiumLabel && (
                                                    <div className="premium-label">{premiumLabel}</div>
                                                )}
                                            </button>
                                        );
                                    })}
                                </div>
                            </Card.Body>
                        </Card>
                    );
                })
            ) : (
                <div className="no-shows-message">
                    <p className="text-muted text-center">
                        No shows available for this movie in {selectedCity} on {selectedDate && formatDate(selectedDate).day} {selectedDate && formatDate(selectedDate).date} {selectedDate && formatDate(selectedDate).month}
                    </p>
                </div>
            )}
        </Container>
    );
};

export default MovieDetails;
