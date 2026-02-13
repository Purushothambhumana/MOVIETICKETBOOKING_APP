import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import 'bootstrap/dist/css/bootstrap.min.css';
import './App.css';

// Context
import { CityProvider } from './context/CityContext';

// Common Components
import NavbarComponent from './components/common/Navbar';
import Footer from './components/common/Footer';
import PrivateRoute from './components/common/PrivateRoute';

// Auth Components
import Login from './components/auth/Login';
import Register from './components/auth/Register';

// User Components
import Home from './components/user/Home';
import MovieDetails from './components/user/MovieDetails';
import SeatSelection from './components/user/SeatSelection';
import BookingConfirmation from './components/user/BookingConfirmation';
import MyBookings from './components/user/MyBookings';

// Admin Components
import AdminDashboard from './components/admin/AdminDashboard';

function App() {
    return (
        <CityProvider>
            <Router
                future={{
                    v7_startTransition: true,
                    v7_relativeSplatPath: true
                }}
            >
                <div className="App">
                    <NavbarComponent />
                    <Routes>
                        {/* Public Routes */}
                        <Route path="/" element={<Home />} />
                        <Route path="/login" element={<Login />} />
                        <Route path="/register" element={<Register />} />
                        <Route path="/movies" element={<Home />} />
                        <Route path="/movies/:id" element={<MovieDetails />} />

                        {/* Protected User Routes */}
                        <Route
                            path="/seat-selection/:showId"
                            element={
                                <PrivateRoute>
                                    <SeatSelection />
                                </PrivateRoute>
                            }
                        />
                        <Route
                            path="/booking-confirmation"
                            element={
                                <PrivateRoute>
                                    <BookingConfirmation />
                                </PrivateRoute>
                            }
                        />
                        <Route
                            path="/my-bookings"
                            element={
                                <PrivateRoute>
                                    <MyBookings />
                                </PrivateRoute>
                            }
                        />

                        {/* Protected Admin Routes */}
                        <Route
                            path="/admin"
                            element={
                                <PrivateRoute adminOnly={true}>
                                    <AdminDashboard />
                                </PrivateRoute>
                            }
                        />
                    </Routes>
                    <Footer />
                </div>
            </Router>
        </CityProvider>
    );
}

export default App;
