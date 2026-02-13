import React, { useState, useContext } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Navbar, Nav, Container, Button } from 'react-bootstrap';
import { FaMapMarkerAlt } from 'react-icons/fa';
import authService from '../../services/authService';
import { CityContext } from '../../context/CityContext';
import CityModal from './CityModal';

const NavbarComponent = () => {
    const navigate = useNavigate();
    const isAuthenticated = authService.isAuthenticated();
    const isAdmin = authService.isAdmin();
    const user = authService.getCurrentUser();
    const { selectedCity, setSelectedCity } = useContext(CityContext);
    const [showCityModal, setShowCityModal] = useState(false);

    const handleLogout = () => {
        authService.logout();
        navigate('/login');
    };

    return (
        <>
            <Navbar expand="lg" className="navbar-custom">
                <Container>
                    <Navbar.Brand as={Link} to="/">
                        Bhumana'Show
                    </Navbar.Brand>
                    <Navbar.Toggle aria-controls="basic-navbar-nav" />
                    <Navbar.Collapse id="basic-navbar-nav">
                        <Nav className="ms-auto align-items-center">
                            {/* City Selector Button */}
                            <Button
                                variant="outline-light"
                                size="sm"
                                className="me-3 city-selector-btn"
                                onClick={() => setShowCityModal(true)}
                            >
                                <FaMapMarkerAlt className="me-1" />
                                {selectedCity || 'Select City'}
                            </Button>

                            <Nav.Link as={Link} to="/">Home</Nav.Link>
                            <Nav.Link as={Link} to="/movies">Movies</Nav.Link>

                            {isAuthenticated && (
                                <>
                                    <Nav.Link as={Link} to="/my-bookings">My Bookings</Nav.Link>
                                    {isAdmin && (
                                        <Nav.Link as={Link} to="/admin">Admin</Nav.Link>
                                    )}
                                    <Nav.Link className="text-white">
                                        Welcome, {user?.username || 'User'}
                                    </Nav.Link>
                                    <Button
                                        variant="outline-light"
                                        size="sm"
                                        onClick={handleLogout}
                                        className="ms-2"
                                    >
                                        Logout
                                    </Button>
                                </>
                            )}

                            {!isAuthenticated && (
                                <>
                                    <Nav.Link as={Link} to="/login">Login</Nav.Link>
                                    <Button
                                        variant="outline-light"
                                        size="sm"
                                        as={Link}
                                        to="/register"
                                        className="ms-2"
                                    >
                                        Sign Up
                                    </Button>
                                </>
                            )}
                        </Nav>
                    </Navbar.Collapse>
                </Container>
            </Navbar>

            {/* City Selection Modal */}
            <CityModal
                show={showCityModal}
                onHide={() => setShowCityModal(false)}
                selectedCity={selectedCity}
                onCityChange={setSelectedCity}
            />
        </>
    );
};

export default NavbarComponent;

