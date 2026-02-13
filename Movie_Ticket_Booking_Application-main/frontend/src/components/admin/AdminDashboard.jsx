import React, { useState, useEffect, useMemo, useCallback } from 'react';
import { Container, Row, Col, Nav, Tab, Form, Button, Table, Alert, Badge, Pagination, Spinner } from 'react-bootstrap';
import { useNavigate } from 'react-router-dom';
import movieService from '../../services/movieService';
import theatreService from '../../services/theatreService';
import showService from '../../services/showService';
import authService from '../../services/authService';
import PaginationComponent from '../common/PaginationComponent';
import SeatLayoutConfig from './SeatLayoutConfig';

const AdminDashboard = () => {
    const navigate = useNavigate();
    const [activeTab, setActiveTab] = useState('movies');
    const [message, setMessage] = useState('');

    // Loading states
    const [loading, setLoading] = useState(false);

    // Data states
    const [movies, setMovies] = useState([]);
    const [theatres, setTheatres] = useState([]);
    const [screens, setScreens] = useState([]);
    const [shows, setShows] = useState([]);

    // Pagination states
    const [currentPage, setCurrentPage] = useState({
        movies: 1,
        theatres: 1,
        screens: 1,
        shows: 1
    });
    const itemsPerPage = 20;

    const [editingMovieId, setEditingMovieId] = useState(null);
    const [editingTheatreId, setEditingTheatreId] = useState(null);
    const [editingScreenId, setEditingScreenId] = useState(null);
    const [editingShowId, setEditingShowId] = useState(null);

    // Multi-select state
    const [selectedMovies, setSelectedMovies] = useState([]);
    const [selectedTheatres, setSelectedTheatres] = useState([]);
    const [selectedScreens, setSelectedScreens] = useState([]);
    const [selectedShows, setSelectedShows] = useState([]);

    // Search state
    const [searchQueries, setSearchQueries] = useState({
        movies: '',
        theatres: '',
        screens: '',
        shows: ''
    });

    // Movie form state
    const [movieForm, setMovieForm] = useState({
        title: '',
        description: '',
        duration: '',
        language: '',
        genre: '',
        posterUrl: '',
        releaseDate: '',
        status: 'NOW_SHOWING',
        certification: 'U',
    });

    // Theatre form state
    const [theatreForm, setTheatreForm] = useState({
        name: '',
        city: '',
        address: '',
    });

    // Screen form state
    const [screenForm, setScreenForm] = useState({
        theatreId: '',
        screenNumber: '',
        totalSeats: '',
        rows: 10,
        seatsPerRow: 15,
    });

    // Show form state
    const [showForm, setShowForm] = useState({
        movieId: '',
        screenId: '',
        showDate: '',
        showTime: '',
        price: '',
        platinumPrice: '',
        goldPrice: '',
        silverPrice: '',
    });
    const [bulkMode, setBulkMode] = useState(false);

    // Seat layout config modal state
    const [showSeatConfig, setShowSeatConfig] = useState(false);
    const [selectedScreen, setSelectedScreen] = useState(null);

    // All hooks must be defined before any conditional returns
    // Data loading functions with useCallback
    const loadMovies = useCallback(async () => {
        try {
            setLoading(true);
            const response = await movieService.getAllMovies();
            setMovies(response?.data || response || []);
        } catch (error) {
            console.error('Error loading movies:', error);
            setMovies([]);
            setMessage('Error loading movies. Please try again.');
        } finally {
            setLoading(false);
        }
    }, []);

    const loadTheatres = useCallback(async () => {
        try {
            setLoading(true);
            const response = await theatreService.getAllTheatres();
            setTheatres(response?.data || response || []);
        } catch (error) {
            console.error('Error loading theatres:', error);
            setTheatres([]);
            setMessage('Error loading theatres. Please try again.');
        } finally {
            setLoading(false);
        }
    }, []);

    const loadScreens = useCallback(async () => {
        try {
            setLoading(true);
            const response = await theatreService.getAllScreens();
            setScreens(response || []);
        } catch (error) {
            console.error('Error loading screens:', error);
            setScreens([]);
            setMessage('Error loading screens. Please try again.');
        } finally {
            setLoading(false);
        }
    }, []);

    const loadShows = useCallback(async () => {
        try {
            setLoading(true);
            const response = await showService.getAllShows();
            setShows(response?.data || response || []);
        } catch (error) {
            console.error('Error loading shows:', error);
            setShows([]);
            setMessage('Error loading shows. Please try again.');
        } finally {
            setLoading(false);
        }
    }, []);

    // Effect to load data when tab changes
    useEffect(() => {
        if (activeTab === 'movies') {
            loadMovies();
        } else if (activeTab === 'theatres') {
            loadTheatres();
        } else if (activeTab === 'screens') {
            loadScreens();
        } else if (activeTab === 'shows') {
            loadShows();
        }
    }, [activeTab, loadMovies, loadTheatres, loadScreens, loadShows]);

    // Pagination logic with useMemo for performance
    // First filter the data based on search queries
    const filteredMovies = useMemo(() => {
        return movies.filter(movie =>
            movie.title.toLowerCase().includes(searchQueries.movies.toLowerCase()) ||
            movie.language.toLowerCase().includes(searchQueries.movies.toLowerCase()) ||
            movie.genre.toLowerCase().includes(searchQueries.movies.toLowerCase())
        );
    }, [movies, searchQueries.movies]);

    const filteredTheatres = useMemo(() => {
        return theatres.filter(theatre =>
            theatre.name.toLowerCase().includes(searchQueries.theatres.toLowerCase()) ||
            theatre.city.toLowerCase().includes(searchQueries.theatres.toLowerCase())
        );
    }, [theatres, searchQueries.theatres]);

    const filteredScreens = useMemo(() => {
        return screens.filter(screen =>
            screen.theatreName?.toLowerCase().includes(searchQueries.screens.toLowerCase()) ||
            screen.screenNumber?.toString().includes(searchQueries.screens)
        );
    }, [screens, searchQueries.screens]);

    const filteredShows = useMemo(() => {
        return shows.filter(show =>
            show.movieTitle?.toLowerCase().includes(searchQueries.shows.toLowerCase()) ||
            show.theatreName?.toLowerCase().includes(searchQueries.shows.toLowerCase())
        );
    }, [shows, searchQueries.shows]);

    // Then paginate the filtered results
    const paginatedMovies = useMemo(() => {
        const startIndex = (currentPage.movies - 1) * itemsPerPage;
        return filteredMovies.slice(startIndex, startIndex + itemsPerPage);
    }, [filteredMovies, currentPage.movies, itemsPerPage]);

    const paginatedTheatres = useMemo(() => {
        const startIndex = (currentPage.theatres - 1) * itemsPerPage;
        return filteredTheatres.slice(startIndex, startIndex + itemsPerPage);
    }, [filteredTheatres, currentPage.theatres, itemsPerPage]);

    const paginatedScreens = useMemo(() => {
        const startIndex = (currentPage.screens - 1) * itemsPerPage;
        return filteredScreens.slice(startIndex, startIndex + itemsPerPage);
    }, [filteredScreens, currentPage.screens, itemsPerPage]);

    const paginatedShows = useMemo(() => {
        const startIndex = (currentPage.shows - 1) * itemsPerPage;
        return filteredShows.slice(startIndex, startIndex + itemsPerPage);
    }, [filteredShows, currentPage.shows, itemsPerPage]);

    // Page change handlers
    const handlePageChange = useCallback((tab, page) => {
        setCurrentPage(prev => ({ ...prev, [tab]: page }));
    }, []);

    // Check admin access AFTER all hooks
    if (!authService.isAdmin()) {
        navigate('/');
        return null;
    }

    const handleMovieSubmit = async (e) => {
        e.preventDefault();
        try {
            if (editingMovieId) {
                // Update existing movie
                await movieService.updateMovie(editingMovieId, movieForm);
                setMessage('Movie updated successfully!');
                setEditingMovieId(null);
            } else {
                // Create new movie
                await movieService.createMovie(movieForm);
                setMessage('Movie added successfully!');
            }
            setMovieForm({
                title: '',
                description: '',
                duration: '',
                language: '',
                genre: '',
                posterUrl: '',
                releaseDate: '',
                status: 'NOW_SHOWING',
                certification: 'U',
            });
            loadMovies();
            loadTheatres(); // Added as per instruction
            loadScreens(); // Added as per instruction
        } catch (error) {
            const action = editingMovieId ? 'updating' : 'adding';
            setMessage(`Error ${action} movie: ` + (error.response?.data?.message || error.message));
        }
    };

    const handleMovieEdit = (movie) => {
        setEditingMovieId(movie.id);
        setMovieForm({
            title: movie.title,
            description: movie.description || '',
            duration: movie.duration,
            language: movie.language || '',
            genre: movie.genre || '',
            posterUrl: movie.posterUrl || '',
            releaseDate: movie.releaseDate || '',
            status: movie.status || 'NOW_SHOWING',
            certification: movie.certification || 'U',
        });
        // Scroll to top of the page to show the form
        window.scrollTo({ top: 0, behavior: 'smooth' });
    };

    const handleCancelEdit = () => {
        setEditingMovieId(null);
        setMovieForm({
            title: '',
            description: '',
            duration: '',
            language: '',
            genre: '',
            posterUrl: '',
            releaseDate: '',
            status: 'NOW_SHOWING',
            certification: 'U',
        });
    };

    const handleMovieDelete = async (id) => {
        if (window.confirm('Are you sure you want to delete this movie?')) {
            try {
                await movieService.deleteMovie(id);
                setMessage('Movie deleted successfully!');
                loadMovies();
            } catch (error) {
                setMessage('Error deleting movie: ' + (error.response?.data?.message || error.message));
            }
        }
    };

    const handleTheatreSubmit = async (e) => {
        e.preventDefault();
        try {
            if (editingTheatreId) {
                // Update existing theatre
                await theatreService.updateTheatre(editingTheatreId, theatreForm);
                setMessage('Theatre updated successfully!');
                setEditingTheatreId(null);
            } else {
                // Create new theatre
                await theatreService.createTheatre(theatreForm);
                setMessage('Theatre added successfully!');
            }
            setTheatreForm({ name: '', city: '', address: '' });
            loadTheatres();
        } catch (error) {
            const action = editingTheatreId ? 'updating' : 'adding';
            setMessage(`Error ${action} theatre: ` + (error.response?.data?.message || error.message));
        }
    };

    const handleTheatreDelete = async (id) => {
        if (window.confirm('Are you sure you want to delete this theatre?')) {
            try {
                await theatreService.deleteTheatre(id);
                setMessage('Theatre deleted successfully!');
                loadTheatres();
            } catch (error) {
                setMessage('Error deleting theatre: ' + (error.response?.data?.message || error.message));
            }
        }
    };

    const handleTheatreEdit = (theatre) => {
        setEditingTheatreId(theatre.id);
        setTheatreForm({
            name: theatre.name,
            city: theatre.city,
            address: theatre.address
        });
        // Scroll to top to show the form
        window.scrollTo({ top: 0, behavior: 'smooth' });
    };

    const handleScreenSubmit = async (e) => {
        e.preventDefault();
        try {
            // Calculate totalSeats from rows and seatsPerRow
            const calculatedTotalSeats = parseInt(screenForm.rows) * parseInt(screenForm.seatsPerRow);

            if (editingScreenId) {
                // Update existing screen
                await theatreService.updateScreen(editingScreenId, {
                    theatreId: parseInt(screenForm.theatreId),
                    screenNumber: parseInt(screenForm.screenNumber),
                    totalSeats: calculatedTotalSeats,
                });
                setMessage('Screen updated successfully!');
                setEditingScreenId(null);
            } else {
                // Create new screen
                await theatreService.createScreen({
                    theatreId: parseInt(screenForm.theatreId),
                    screenNumber: parseInt(screenForm.screenNumber),
                    totalSeats: calculatedTotalSeats,
                    rows: parseInt(screenForm.rows),
                    seatsPerRow: parseInt(screenForm.seatsPerRow),
                });
                setMessage('Screen and seats added successfully!');
            }

            setScreenForm({
                theatreId: '',
                screenNumber: '',
                totalSeats: 150,
                rows: 10,
                seatsPerRow: 15,
            });
            // Reload screens to show the new one
            loadScreens();
        } catch (error) {
            console.error('Full error object:', error);
            console.error('Error response:', error.response);
            console.error('Error response data:', error.response?.data);

            let errorMsg = 'Unknown error';
            if (error.response?.data) {
                if (typeof error.response.data === 'string') {
                    errorMsg = error.response.data;
                } else if (error.response.data.message) {
                    errorMsg = error.response.data.message;
                } else {
                    errorMsg = JSON.stringify(error.response.data);
                }
            } else if (error.message) {
                errorMsg = error.message;
            }

            setMessage('Error adding screen: ' + errorMsg);
        }
    };

    const handleShowSubmit = async (e) => {
        e.preventDefault();
        try {
            if (editingShowId) {
                // Update existing show
                await showService.updateShow(editingShowId, showForm);
                setMessage('Show updated successfully!');
                setEditingShowId(null);
            } else if (bulkMode) {
                // Bulk create shows
                const dates = showForm.showDate.split(',').map(d => d.trim()).filter(d => d);
                const times = showForm.showTime.split(',').map(t => t.trim()).filter(t => t);

                // Generate all combinations
                const showsToCreate = [];
                for (const date of dates) {
                    for (const time of times) {
                        showsToCreate.push({
                            movieId: parseInt(showForm.movieId),
                            screenId: parseInt(showForm.screenId),
                            showDate: date,
                            showTime: time,
                            price: parseFloat(showForm.price)
                        });
                    }
                }

                const response = await showService.createBulkShows(showsToCreate);
                setMessage(`Successfully created ${response.count} shows!`);
            } else {
                // Create single show
                await showService.createShow(showForm);
                setMessage('Show added successfully!');
            }

            setShowForm({
                movieId: '',
                screenId: '',
                showDate: '',
                showTime: '',
                price: '',
                platinumPrice: '',
                goldPrice: '',
                silverPrice: '',
            });
            setBulkMode(false);
            loadShows();
        } catch (error) {
            const action = editingShowId ? 'updating' : (bulkMode ? 'bulk creating' : 'adding');
            setMessage(`Error ${action} show(s): ` + (error.response?.data?.message || error.message));
        }
    };

    const handleShowDelete = async (id) => {
        if (window.confirm('Are you sure you want to delete this show?')) {
            try {
                await showService.deleteShow(id);
                setMessage('Show deleted successfully!');
                loadShows();
            } catch (error) {
                setMessage('Error deleting show: ' + (error.response?.data?.message || error.message));
            }
        }
    };

    const handleShowEdit = (show) => {
        setEditingShowId(show.id);
        setBulkMode(false); // Disable bulk mode when editing
        setShowForm({
            movieId: show.movieId,
            screenId: show.screenId,
            showDate: show.showDate,
            showTime: show.showTime,
            price: show.price,
            platinumPrice: show.platinumPrice || '',
            goldPrice: show.goldPrice || '',
            silverPrice: show.silverPrice || '',
        });
        // Scroll to top to show the form
        window.scrollTo({ top: 0, behavior: 'smooth' });
    };

    const handleScreenDelete = async (id) => {
        if (window.confirm('Are you sure you want to delete this screen? This will also delete all associated seats.')) {
            try {
                await theatreService.deleteScreen(id);
                setMessage('Screen deleted successfully!');
                loadScreens();
            } catch (error) {
                setMessage('Error deleting screen: ' + (error.response?.data?.message || error.message));
            }
        }
    };

    const handleScreenEdit = (screen) => {
        setEditingScreenId(screen.id);
        setScreenForm({
            theatreId: screen.theatreId.toString(),
            screenNumber: screen.screenNumber.toString(),
            totalSeats: screen.totalSeats.toString(),
            rows: 10,
            seatsPerRow: 15,
        });
        // Scroll to top to show the form
        window.scrollTo({ top: 0, behavior: 'smooth' });
    };

    // Multi-select handlers
    const handleSelectAll = (entityType, items) => {
        const allIds = items.map(item => item.id);
        switch (entityType) {
            case 'movies':
                setSelectedMovies(selectedMovies.length === items.length ? [] : allIds);
                break;
            case 'theatres':
                setSelectedTheatres(selectedTheatres.length === items.length ? [] : allIds);
                break;
            case 'screens':
                setSelectedScreens(selectedScreens.length === items.length ? [] : allIds);
                break;
            case 'shows':
                setSelectedShows(selectedShows.length === items.length ? [] : allIds);
                break;
            default:
                break;
        }
    };

    const handleSelectItem = (entityType, id) => {
        switch (entityType) {
            case 'movies':
                setSelectedMovies(prev =>
                    prev.includes(id) ? prev.filter(itemId => itemId !== id) : [...prev, id]
                );
                break;
            case 'theatres':
                setSelectedTheatres(prev =>
                    prev.includes(id) ? prev.filter(itemId => itemId !== id) : [...prev, id]
                );
                break;
            case 'screens':
                setSelectedScreens(prev =>
                    prev.includes(id) ? prev.filter(itemId => itemId !== id) : [...prev, id]
                );
                break;
            case 'shows':
                setSelectedShows(prev =>
                    prev.includes(id) ? prev.filter(itemId => itemId !== id) : [...prev, id]
                );
                break;
            default:
                break;
        }
    };

    // Bulk delete handlers
    const handleBulkDeleteMovies = async () => {
        if (selectedMovies.length === 0) return;

        if (window.confirm(`Are you sure you want to delete ${selectedMovies.length} movie(s)?`)) {
            try {
                for (const id of selectedMovies) {
                    await movieService.deleteMovie(id);
                }
                setMessage(`${selectedMovies.length} movie(s) deleted successfully!`);
                setSelectedMovies([]);
                loadMovies();
            } catch (error) {
                setMessage('Error deleting movies: ' + (error.response?.data?.message || error.message));
            }
        }
    };

    const handleBulkDeleteTheatres = async () => {
        if (selectedTheatres.length === 0) return;

        if (window.confirm(`Are you sure you want to delete ${selectedTheatres.length} theatre(s)?`)) {
            try {
                for (const id of selectedTheatres) {
                    await theatreService.deleteTheatre(id);
                }
                setMessage(`${selectedTheatres.length} theatre(s) deleted successfully!`);
                setSelectedTheatres([]);
                loadTheatres();
            } catch (error) {
                setMessage('Error deleting theatres: ' + (error.response?.data?.message || error.message));
            }
        }
    };

    const handleBulkDeleteScreens = async () => {
        if (selectedScreens.length === 0) return;

        if (window.confirm(`Are you sure you want to delete ${selectedScreens.length} screen(s)? This will also delete all associated seats.`)) {
            try {
                for (const id of selectedScreens) {
                    await theatreService.deleteScreen(id);
                }
                setMessage(`${selectedScreens.length} screen(s) deleted successfully!`);
                setSelectedScreens([]);
                loadScreens();
            } catch (error) {
                setMessage('Error deleting screens: ' + (error.response?.data?.message || error.message));
            }
        }
    };

    const handleBulkDeleteShows = async () => {
        if (selectedShows.length === 0) return;

        if (window.confirm(`Are you sure you want to delete ${selectedShows.length} show(s)?`)) {
            try {
                for (const id of selectedShows) {
                    await showService.deleteShow(id);
                }
                setMessage(`${selectedShows.length} show(s) deleted successfully!`);
                setSelectedShows([]);
                loadShows();
            } catch (error) {
                setMessage('Error deleting shows: ' + (error.response?.data?.message || error.message));
            }
        }
    };

    return (
        <Container fluid className="mt-4">
            <h2 className="mb-4" style={{ color: 'var(--bms-red)' }}>
                Admin Dashboard
            </h2>

            {message && <Alert variant="info" onClose={() => setMessage('')} dismissible>{message}</Alert>}

            <Tab.Container activeKey={activeTab} onSelect={(k) => setActiveTab(k)}>
                <Row>
                    <Col md={3}>
                        <Nav variant="pills" className="flex-column">
                            <Nav.Item>
                                <Nav.Link eventKey="movies">Manage Movies</Nav.Link>
                            </Nav.Item>
                            <Nav.Item>
                                <Nav.Link eventKey="theatres">Manage Theatres</Nav.Link>
                            </Nav.Item>
                            <Nav.Item>
                                <Nav.Link eventKey="screens">Manage Screens</Nav.Link>
                            </Nav.Item>
                            <Nav.Item>
                                <Nav.Link eventKey="shows">Manage Shows</Nav.Link>
                            </Nav.Item>
                        </Nav>
                    </Col>

                    <Col md={9}>
                        <Tab.Content>
                            {/* Movies Tab */}
                            <Tab.Pane eventKey="movies">
                                <h4>{editingMovieId ? 'Edit Movie' : 'Add New Movie'}</h4>
                                <Form onSubmit={handleMovieSubmit} className="mb-4">
                                    <Row>
                                        <Col md={6}>
                                            <Form.Group className="mb-3">
                                                <Form.Label>Title</Form.Label>
                                                <Form.Control
                                                    type="text"
                                                    value={movieForm.title}
                                                    onChange={(e) => setMovieForm({ ...movieForm, title: e.target.value })}
                                                    required
                                                />
                                            </Form.Group>
                                        </Col>
                                        <Col md={6}>
                                            <Form.Group className="mb-3">
                                                <Form.Label>Duration (minutes)</Form.Label>
                                                <Form.Control
                                                    type="number"
                                                    value={movieForm.duration}
                                                    onChange={(e) => setMovieForm({ ...movieForm, duration: e.target.value })}
                                                    required
                                                />
                                            </Form.Group>
                                        </Col>
                                    </Row>

                                    <Form.Group className="mb-3">
                                        <Form.Label>Description</Form.Label>
                                        <Form.Control
                                            as="textarea"
                                            rows={2}
                                            value={movieForm.description}
                                            onChange={(e) => setMovieForm({ ...movieForm, description: e.target.value })}
                                        />
                                    </Form.Group>

                                    <Row>
                                        <Col md={3}>
                                            <Form.Group className="mb-3">
                                                <Form.Label>Language</Form.Label>
                                                <Form.Control
                                                    type="text"
                                                    value={movieForm.language}
                                                    onChange={(e) => setMovieForm({ ...movieForm, language: e.target.value })}
                                                />
                                            </Form.Group>
                                        </Col>
                                        <Col md={3}>
                                            <Form.Group className="mb-3">
                                                <Form.Label>Genre</Form.Label>
                                                <Form.Control
                                                    type="text"
                                                    value={movieForm.genre}
                                                    onChange={(e) => setMovieForm({ ...movieForm, genre: e.target.value })}
                                                />
                                            </Form.Group>
                                        </Col>
                                        <Col md={3}>
                                            <Form.Group className="mb-3">
                                                <Form.Label>Certification</Form.Label>
                                                <Form.Select
                                                    value={movieForm.certification}
                                                    onChange={(e) => setMovieForm({ ...movieForm, certification: e.target.value })}
                                                >
                                                    <option value="U">U</option>
                                                    <option value="UA">UA</option>
                                                    <option value="A">A</option>
                                                </Form.Select>
                                            </Form.Group>
                                        </Col>
                                        <Col md={3}>
                                            <Form.Group className="mb-3">
                                                <Form.Label>Status</Form.Label>
                                                <Form.Select
                                                    value={movieForm.status}
                                                    onChange={(e) => setMovieForm({ ...movieForm, status: e.target.value })}
                                                >
                                                    <option value="NOW_SHOWING">Now Showing</option>
                                                    <option value="UPCOMING">Upcoming</option>
                                                </Form.Select>
                                            </Form.Group>
                                        </Col>
                                    </Row>

                                    <Row>
                                        <Col md={8}>
                                            <Form.Group className="mb-3">
                                                <Form.Label>Poster URL</Form.Label>
                                                <Form.Control
                                                    type="text"
                                                    value={movieForm.posterUrl}
                                                    onChange={(e) => setMovieForm({ ...movieForm, posterUrl: e.target.value })}
                                                />
                                            </Form.Group>
                                        </Col>
                                        <Col md={4}>
                                            <Form.Group className="mb-3">
                                                <Form.Label>Release Date</Form.Label>
                                                <Form.Control
                                                    type="date"
                                                    value={movieForm.releaseDate}
                                                    onChange={(e) => setMovieForm({ ...movieForm, releaseDate: e.target.value })}
                                                    required
                                                />
                                            </Form.Group>
                                        </Col>
                                    </Row>

                                    <Button type="submit" className="btn-bms">
                                        {editingMovieId ? 'Update Movie' : 'Add Movie'}
                                    </Button>
                                    {editingMovieId && (
                                        <Button
                                            variant="secondary"
                                            className="ms-2"
                                            onClick={handleCancelEdit}
                                        >
                                            Cancel
                                        </Button>
                                    )}
                                </Form>

                                <hr />

                                <Form.Group className="mb-3">
                                    <Form.Label>Search Movies</Form.Label>
                                    <Form.Control
                                        type="text"
                                        placeholder="Search by title, language, or genre..."
                                        value={searchQueries.movies}
                                        onChange={(e) => setSearchQueries({ ...searchQueries, movies: e.target.value })}
                                    />
                                </Form.Group>

                                <h4 className="mt-4">All Movies ({filteredMovies.length})</h4>
                                {selectedMovies.length > 0 && (
                                    <Button
                                        variant="danger"
                                        className="mb-3"
                                        onClick={handleBulkDeleteMovies}
                                    >
                                        Delete Selected ({selectedMovies.length})
                                    </Button>
                                )}
                                <Table striped bordered hover responsive>
                                    <thead>
                                        <tr>
                                            <th>
                                                <Form.Check
                                                    type="checkbox"
                                                    checked={selectedMovies.length === movies.length && movies.length > 0}
                                                    onChange={() => handleSelectAll('movies', movies)}
                                                />
                                            </th>
                                            <th>ID</th>
                                            <th>Title</th>
                                            <th>Language</th>
                                            <th>Genre</th>
                                            <th>Duration</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {loading ? (
                                            <tr>
                                                <td colSpan="8" className="text-center py-4">
                                                    <Spinner animation="border" role="status">
                                                        <span className="visually-hidden">Loading...</span>
                                                    </Spinner>
                                                </td>
                                            </tr>
                                        ) : movies.length === 0 ? (
                                            <tr>
                                                <td colSpan="8" className="text-center">No movies found</td>
                                            </tr>
                                        ) : (
                                            paginatedMovies.map((movie) => (
                                                <tr key={movie.id} style={{ backgroundColor: selectedMovies.includes(movie.id) ? '#e3f2fd' : 'transparent' }}>
                                                    <td>
                                                        <Form.Check
                                                            type="checkbox"
                                                            checked={selectedMovies.includes(movie.id)}
                                                            onChange={() => handleSelectItem('movies', movie.id)}
                                                        />
                                                    </td>
                                                    <td>{movie.id}</td>
                                                    <td>{movie.title}</td>
                                                    <td>{movie.language}</td>
                                                    <td>{movie.genre}</td>
                                                    <td>{movie.duration} min</td>
                                                    <td>
                                                        <Badge bg={movie.status === 'NOW_SHOWING' ? 'success' : 'secondary'}>
                                                            {movie.status}
                                                        </Badge>
                                                    </td>
                                                    <td>
                                                        <Button
                                                            variant="primary"
                                                            size="sm"
                                                            onClick={() => handleMovieEdit(movie)}
                                                            className="me-2"
                                                        >
                                                            Edit
                                                        </Button>
                                                        <Button
                                                            variant="danger"
                                                            size="sm"
                                                            onClick={() => handleMovieDelete(movie.id)}
                                                        >
                                                            Delete
                                                        </Button>
                                                    </td>
                                                </tr>
                                            ))
                                        )}
                                    </tbody>
                                </Table>
                                <PaginationComponent
                                    currentPage={currentPage.movies}
                                    totalItems={movies.length}
                                    itemsPerPage={itemsPerPage}
                                    onPageChange={(page) => handlePageChange('movies', page)}
                                />
                            </Tab.Pane>

                            {/* Theatres Tab */}
                            <Tab.Pane eventKey="theatres">
                                <h4>{editingTheatreId ? 'Edit Theatre' : 'Add New Theatre'}</h4>
                                <Form onSubmit={handleTheatreSubmit} className="mb-4">
                                    <Form.Group className="mb-3">
                                        <Form.Label>Theatre Name</Form.Label>
                                        <Form.Control
                                            type="text"
                                            value={theatreForm.name}
                                            onChange={(e) => setTheatreForm({ ...theatreForm, name: e.target.value })}
                                            required
                                        />
                                    </Form.Group>

                                    <Form.Group className="mb-3">
                                        <Form.Label>City</Form.Label>
                                        <Form.Control
                                            type="text"
                                            value={theatreForm.city}
                                            onChange={(e) => setTheatreForm({ ...theatreForm, city: e.target.value })}
                                            required
                                        />
                                    </Form.Group>

                                    <Form.Group className="mb-3">
                                        <Form.Label>Address</Form.Label>
                                        <Form.Control
                                            as="textarea"
                                            rows={2}
                                            value={theatreForm.address}
                                            onChange={(e) => setTheatreForm({ ...theatreForm, address: e.target.value })}
                                        />
                                    </Form.Group>

                                    <Button type="submit" className="btn-bms">
                                        {editingTheatreId ? 'Update Theatre' : 'Add Theatre'}
                                    </Button>
                                </Form>

                                <hr />

                                <Form.Group className="mb-3">
                                    <Form.Label>Search Theatres</Form.Label>
                                    <Form.Control
                                        type="text"
                                        placeholder="Search by theatre name or city..."
                                        value={searchQueries.theatres}
                                        onChange={(e) => setSearchQueries({ ...searchQueries, theatres: e.target.value })}
                                    />
                                </Form.Group>

                                <h4 className="mt-4">All Theatres ({filteredTheatres.length})</h4>
                                {selectedTheatres.length > 0 && (
                                    <Button
                                        variant="danger"
                                        className="mb-3"
                                        onClick={handleBulkDeleteTheatres}
                                    >
                                        Delete Selected ({selectedTheatres.length})
                                    </Button>
                                )}
                                <Table striped bordered hover responsive>
                                    <thead>
                                        <tr>
                                            <th>
                                                <Form.Check
                                                    type="checkbox"
                                                    checked={selectedTheatres.length === theatres.length && theatres.length > 0}
                                                    onChange={() => handleSelectAll('theatres', theatres)}
                                                />
                                            </th>
                                            <th>ID</th>
                                            <th>Name</th>
                                            <th>City</th>
                                            <th>Address</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {loading ? (
                                            <tr>
                                                <td colSpan="6" className="text-center py-4">
                                                    <Spinner animation="border" role="status">
                                                        <span className="visually-hidden">Loading...</span>
                                                    </Spinner>
                                                </td>
                                            </tr>
                                        ) : theatres.length === 0 ? (
                                            <tr>
                                                <td colSpan="6" className="text-center">No theatres found</td>
                                            </tr>
                                        ) : (
                                            paginatedTheatres.map((theatre) => (
                                                <tr key={theatre.id} style={{ backgroundColor: selectedTheatres.includes(theatre.id) ? '#e3f2fd' : 'transparent' }}>
                                                    <td>
                                                        <Form.Check
                                                            type="checkbox"
                                                            checked={selectedTheatres.includes(theatre.id)}
                                                            onChange={() => handleSelectItem('theatres', theatre.id)}
                                                        />
                                                    </td>
                                                    <td>{theatre.id}</td>
                                                    <td>{theatre.name}</td>
                                                    <td>{theatre.city}</td>
                                                    <td>{theatre.address}</td>
                                                    <td>
                                                        <Button
                                                            variant="warning"
                                                            size="sm"
                                                            onClick={() => handleTheatreEdit(theatre)}
                                                            className="me-2"
                                                        >
                                                            Edit
                                                        </Button>
                                                        <Button
                                                            variant="danger"
                                                            size="sm"
                                                            onClick={() => handleTheatreDelete(theatre.id)}
                                                        >
                                                            Delete
                                                        </Button>
                                                    </td>
                                                </tr>
                                            ))
                                        )}
                                    </tbody>
                                </Table>
                                <PaginationComponent
                                    currentPage={currentPage.theatres}
                                    totalItems={theatres.length}
                                    itemsPerPage={itemsPerPage}
                                    onPageChange={(page) => handlePageChange('theatres', page)}
                                />
                            </Tab.Pane>

                            {/* Screens Tab */}
                            <Tab.Pane eventKey="screens">
                                <h4>{editingScreenId ? 'Edit Screen' : 'Add New Screen'}</h4>
                                <Form onSubmit={handleScreenSubmit} className="mb-4">
                                    <Form.Group className="mb-3">
                                        <Form.Label>Theatre ID</Form.Label>
                                        <Form.Control
                                            type="number"
                                            value={screenForm.theatreId}
                                            onChange={(e) => setScreenForm({ ...screenForm, theatreId: e.target.value })}
                                            required
                                        />
                                        <Form.Text>Check Theatres tab for IDs</Form.Text>
                                    </Form.Group>

                                    <Row>
                                        <Col md={4}>
                                            <Form.Group className="mb-3">
                                                <Form.Label>Screen Number</Form.Label>
                                                <Form.Control
                                                    type="number"
                                                    value={screenForm.screenNumber}
                                                    onChange={(e) => setScreenForm({ ...screenForm, screenNumber: e.target.value })}
                                                    required
                                                />
                                            </Form.Group>
                                        </Col>
                                        <Col md={4}>
                                            <Form.Group className="mb-3">
                                                <Form.Label>Number of Rows</Form.Label>
                                                <Form.Control
                                                    type="number"
                                                    value={screenForm.rows}
                                                    onChange={(e) => {
                                                        const rows = e.target.value;
                                                        const seatsPerRow = screenForm.seatsPerRow;
                                                        setScreenForm({
                                                            ...screenForm,
                                                            rows: rows,
                                                            totalSeats: rows * seatsPerRow
                                                        });
                                                    }}
                                                    required
                                                    min="1"
                                                />
                                            </Form.Group>
                                        </Col>
                                        <Col md={4}>
                                            <Form.Group className="mb-3">
                                                <Form.Label>Seats Per Row</Form.Label>
                                                <Form.Control
                                                    type="number"
                                                    value={screenForm.seatsPerRow}
                                                    onChange={(e) => {
                                                        const seatsPerRow = e.target.value;
                                                        const rows = screenForm.rows;
                                                        setScreenForm({
                                                            ...screenForm,
                                                            seatsPerRow: seatsPerRow,
                                                            totalSeats: rows * seatsPerRow
                                                        });
                                                    }}
                                                    required
                                                    min="1"
                                                />
                                            </Form.Group>
                                        </Col>
                                    </Row>

                                    <Form.Group className="mb-3">
                                        <Form.Label>Total Seats (Auto-calculated)</Form.Label>
                                        <Form.Control
                                            type="number"
                                            value={screenForm.totalSeats || (screenForm.rows && screenForm.seatsPerRow ? screenForm.rows * screenForm.seatsPerRow : 150)}
                                            readOnly
                                            style={{ backgroundColor: '#f0f0f0' }}
                                        />
                                    </Form.Group>

                                    <Button type="submit" className="btn-bms">
                                        {editingScreenId ? 'Update Screen' : 'Add Screen & Create Seats'}
                                    </Button>
                                </Form>

                                <hr />

                                <Form.Group className="mb-3">
                                    <Form.Label>Search Screens</Form.Label>
                                    <Form.Control
                                        type="text"
                                        placeholder="Search by theatre name or screen number..."
                                        value={searchQueries.screens}
                                        onChange={(e) => setSearchQueries({ ...searchQueries, screens: e.target.value })}
                                    />
                                </Form.Group>

                                <h4 className="mt-4">All Screens ({filteredScreens.length})</h4>
                                {selectedScreens.length > 0 && (
                                    <Button
                                        variant="danger"
                                        className="mb-3"
                                        onClick={handleBulkDeleteScreens}
                                    >
                                        Delete Selected ({selectedScreens.length})
                                    </Button>
                                )}
                                <Table striped bordered hover responsive>
                                    <thead>
                                        <tr>
                                            <th>
                                                <Form.Check
                                                    type="checkbox"
                                                    checked={selectedScreens.length === screens.length && screens.length > 0}
                                                    onChange={() => handleSelectAll('screens', screens)}
                                                />
                                            </th>
                                            <th>ID</th>
                                            <th>Theatre</th>
                                            <th>City</th>
                                            <th>Screen #</th>
                                            <th>Total Seats</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {loading ? (
                                            <tr>
                                                <td colSpan="7" className="text-center py-4">
                                                    <Spinner animation="border" role="status">
                                                        <span className="visually-hidden">Loading...</span>
                                                    </Spinner>
                                                </td>
                                            </tr>
                                        ) : screens.length === 0 ? (
                                            <tr>
                                                <td colSpan="7" className="text-center">No screens found</td>
                                            </tr>
                                        ) : (
                                            paginatedScreens.map((screen) => (
                                                <tr key={screen.id} style={{ backgroundColor: selectedScreens.includes(screen.id) ? '#e3f2fd' : 'transparent' }}>
                                                    <td>
                                                        <Form.Check
                                                            type="checkbox"
                                                            checked={selectedScreens.includes(screen.id)}
                                                            onChange={() => handleSelectItem('screens', screen.id)}
                                                        />
                                                    </td>
                                                    <td>{screen.id}</td>
                                                    <td>{screen.theatreName}</td>
                                                    <td>{screen.theatreCity}</td>
                                                    <td>{screen.screenNumber}</td>
                                                    <td>{screen.totalSeats}</td>
                                                    <td>
                                                        <Button
                                                            variant="info"
                                                            size="sm"
                                                            onClick={() => {
                                                                setSelectedScreen(screen);
                                                                setShowSeatConfig(true);
                                                            }}
                                                            className="me-2"
                                                        >
                                                            Configure Seats
                                                        </Button>
                                                        <Button
                                                            variant="warning"
                                                            size="sm"
                                                            onClick={() => handleScreenEdit(screen)}
                                                            className="me-2"
                                                        >
                                                            Edit
                                                        </Button>
                                                        <Button
                                                            variant="danger"
                                                            size="sm"
                                                            onClick={() => handleScreenDelete(screen.id)}
                                                        >
                                                            Delete
                                                        </Button>
                                                    </td>
                                                </tr>
                                            ))
                                        )}
                                    </tbody>
                                </Table>
                                <PaginationComponent
                                    currentPage={currentPage.screens}
                                    totalItems={screens.length}
                                    itemsPerPage={itemsPerPage}
                                    onPageChange={(page) => handlePageChange('screens', page)}
                                />
                            </Tab.Pane>

                            {/* Shows Tab */}
                            <Tab.Pane eventKey="shows">
                                <h4>{editingShowId ? 'Edit Show' : 'Add New Show'}</h4>

                                {/* Bulk Mode Toggle */}
                                {!editingShowId && (
                                    <Form.Check
                                        type="switch"
                                        id="bulk-mode-switch"
                                        label={bulkMode ? "Bulk Create Mode (Multiple Dates/Times)" : "Single Show Mode"}
                                        checked={bulkMode}
                                        onChange={(e) => setBulkMode(e.target.checked)}
                                        className="mb-3"
                                    />
                                )}

                                <Form onSubmit={handleShowSubmit} className="mb-4">
                                    <Row>
                                        <Col md={6}>
                                            <Form.Group className="mb-3">
                                                <Form.Label>Movie ID</Form.Label>
                                                <Form.Control
                                                    type="number"
                                                    value={showForm.movieId}
                                                    onChange={(e) => setShowForm({ ...showForm, movieId: e.target.value })}
                                                    required
                                                />
                                                <Form.Text>Check Movies tab for IDs</Form.Text>
                                            </Form.Group>
                                        </Col>
                                        <Col md={6}>
                                            <Form.Group className="mb-3">
                                                <Form.Label>Screen ID</Form.Label>
                                                <Form.Control
                                                    type="number"
                                                    value={showForm.screenId}
                                                    onChange={(e) => setShowForm({ ...showForm, screenId: e.target.value })}
                                                    required
                                                />
                                                <Form.Text>Check Screens tab or database for IDs</Form.Text>
                                            </Form.Group>
                                        </Col>
                                    </Row>

                                    <Row>
                                        <Col md={4}>
                                            <Form.Group className="mb-3">
                                                <Form.Label>
                                                    {bulkMode ? 'Show Dates (comma-separated)' : 'Show Date'}
                                                </Form.Label>
                                                {bulkMode ? (
                                                    <Form.Control
                                                        type="text"
                                                        placeholder="e.g., 2026-02-16, 2026-02-17, 2026-02-18"
                                                        value={showForm.showDate}
                                                        onChange={(e) => setShowForm({ ...showForm, showDate: e.target.value })}
                                                        required
                                                    />
                                                ) : (
                                                    <Form.Control
                                                        type="date"
                                                        value={showForm.showDate}
                                                        onChange={(e) => setShowForm({ ...showForm, showDate: e.target.value })}
                                                        required
                                                    />
                                                )}
                                                {bulkMode && <Form.Text>Enter dates in YYYY-MM-DD format, separated by commas</Form.Text>}
                                            </Form.Group>
                                        </Col>
                                        <Col md={4}>
                                            <Form.Group className="mb-3">
                                                <Form.Label>
                                                    {bulkMode ? 'Show Times (comma-separated)' : 'Show Time'}
                                                </Form.Label>
                                                {bulkMode ? (
                                                    <Form.Control
                                                        type="text"
                                                        placeholder="e.g., 09:30, 12:30, 15:30, 18:30, 21:30"
                                                        value={showForm.showTime}
                                                        onChange={(e) => setShowForm({ ...showForm, showTime: e.target.value })}
                                                        required
                                                    />
                                                ) : (
                                                    <Form.Control
                                                        type="time"
                                                        value={showForm.showTime}
                                                        onChange={(e) => setShowForm({ ...showForm, showTime: e.target.value })}
                                                        required
                                                    />
                                                )}
                                                {bulkMode && <Form.Text>Enter times in HH:MM format, separated by commas</Form.Text>}
                                            </Form.Group>
                                        </Col>
                                        <Col md={4}>
                                            <Form.Group className="mb-3">
                                                <Form.Label>Price (₹)</Form.Label>
                                                <Form.Control
                                                    type="number"
                                                    step="0.01"
                                                    value={showForm.price}
                                                    onChange={(e) => setShowForm({ ...showForm, price: e.target.value })}
                                                    required
                                                />
                                            </Form.Group>
                                        </Col>
                                    </Row>

                                    {/* Seat Type Pricing */}
                                    <Row>
                                        <Col md={12}>
                                            <h6 className="mb-2">Seat Type Pricing (Optional - overrides base price)</h6>
                                        </Col>
                                        <Col md={4}>
                                            <Form.Group className="mb-3">
                                                <Form.Label>Platinum (₹)</Form.Label>
                                                <Form.Control
                                                    type="number"
                                                    step="0.01"
                                                    placeholder="e.g., 300"
                                                    value={showForm.platinumPrice}
                                                    onChange={(e) => setShowForm({ ...showForm, platinumPrice: e.target.value })}
                                                />
                                            </Form.Group>
                                        </Col>
                                        <Col md={4}>
                                            <Form.Group className="mb-3">
                                                <Form.Label>Gold (₹)</Form.Label>
                                                <Form.Control
                                                    type="number"
                                                    step="0.01"
                                                    placeholder="e.g., 200"
                                                    value={showForm.goldPrice}
                                                    onChange={(e) => setShowForm({ ...showForm, goldPrice: e.target.value })}
                                                />
                                            </Form.Group>
                                        </Col>
                                        <Col md={4}>
                                            <Form.Group className="mb-3">
                                                <Form.Label>Silver (₹)</Form.Label>
                                                <Form.Control
                                                    type="number"
                                                    step="0.01"
                                                    placeholder="e.g., 150"
                                                    value={showForm.silverPrice}
                                                    onChange={(e) => setShowForm({ ...showForm, silverPrice: e.target.value })}
                                                />
                                            </Form.Group>
                                        </Col>
                                    </Row>

                                    {/* Bulk Mode Preview */}
                                    {bulkMode && showForm.showDate && showForm.showTime && (() => {
                                        const dates = showForm.showDate.split(',').map(d => d.trim()).filter(d => d);
                                        const times = showForm.showTime.split(',').map(t => t.trim()).filter(t => t);
                                        const totalShows = dates.length * times.length;
                                        return (
                                            <Alert variant="info" className="mb-3">
                                                <strong>Preview:</strong> Will create <strong>{totalShows}</strong> shows
                                                ({dates.length} dates × {times.length} times)
                                            </Alert>
                                        );
                                    })()}

                                    <Button type="submit" className="btn-bms">
                                        {editingShowId ? 'Update Show' : (bulkMode ? 'Add Shows' : 'Add Show')}
                                    </Button>
                                </Form>

                                <hr />

                                <Form.Group className="mb-3">
                                    <Form.Label>Search Shows</Form.Label>
                                    <Form.Control
                                        type="text"
                                        placeholder="Search by movie or theatre name..."
                                        value={searchQueries.shows}
                                        onChange={(e) => setSearchQueries({ ...searchQueries, shows: e.target.value })}
                                    />
                                </Form.Group>

                                <h4 className="mt-4">All Shows ({filteredShows.length})</h4>
                                {selectedShows.length > 0 && (
                                    <Button
                                        variant="danger"
                                        className="mb-3"
                                        onClick={handleBulkDeleteShows}
                                    >
                                        Delete Selected ({selectedShows.length})
                                    </Button>
                                )}
                                <Table striped bordered hover responsive>
                                    <thead>
                                        <tr>
                                            <th>
                                                <Form.Check
                                                    type="checkbox"
                                                    checked={selectedShows.length === shows.length && shows.length > 0}
                                                    onChange={() => handleSelectAll('shows', shows)}
                                                />
                                            </th>
                                            <th>ID</th>
                                            <th>Movie</th>
                                            <th>Date</th>
                                            <th>Time</th>
                                            <th>Price</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {loading ? (
                                            <tr>
                                                <td colSpan="7" className="text-center py-4">
                                                    <Spinner animation="border" role="status">
                                                        <span className="visually-hidden">Loading...</span>
                                                    </Spinner>
                                                </td>
                                            </tr>
                                        ) : shows.length === 0 ? (
                                            <tr>
                                                <td colSpan="7" className="text-center">No shows found</td>
                                            </tr>
                                        ) : (
                                            paginatedShows.map((show) => (
                                                <tr key={show.id} style={{ backgroundColor: selectedShows.includes(show.id) ? '#e3f2fd' : 'transparent' }}>
                                                    <td>
                                                        <Form.Check
                                                            type="checkbox"
                                                            checked={selectedShows.includes(show.id)}
                                                            onChange={() => handleSelectItem('shows', show.id)}
                                                        />
                                                    </td>
                                                    <td>{show.id}</td>
                                                    <td>{show.movieTitle || `Movie ID: ${show.movieId}`}</td>
                                                    <td>{show.showDate}</td>
                                                    <td>{show.showTime}</td>
                                                    <td>₹{show.price}</td>
                                                    <td>
                                                        <Button
                                                            variant="warning"
                                                            size="sm"
                                                            onClick={() => handleShowEdit(show)}
                                                            className="me-2"
                                                        >
                                                            Edit
                                                        </Button>
                                                        <Button
                                                            variant="danger"
                                                            size="sm"
                                                            onClick={() => handleShowDelete(show.id)}
                                                        >
                                                            Delete
                                                        </Button>
                                                    </td>
                                                </tr>
                                            ))
                                        )}
                                    </tbody>
                                </Table>
                                <PaginationComponent
                                    currentPage={currentPage.shows}
                                    totalItems={shows.length}
                                    itemsPerPage={itemsPerPage}
                                    onPageChange={(page) => handlePageChange('shows', page)}
                                />
                            </Tab.Pane>
                        </Tab.Content>
                    </Col>
                </Row>
            </Tab.Container>

            {/* Seat Layout Configuration Modal */}
            <SeatLayoutConfig
                show={showSeatConfig}
                onHide={() => {
                    setShowSeatConfig(false);
                    setSelectedScreen(null);
                }}
                screen={selectedScreen}
                onSuccess={() => {
                    loadScreens();
                    setMessage('Seat layout configured successfully!');
                }}
            />
        </Container>
    );
};

export default AdminDashboard;
