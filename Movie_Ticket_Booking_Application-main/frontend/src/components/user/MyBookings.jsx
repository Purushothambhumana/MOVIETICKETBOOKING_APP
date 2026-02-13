import React, { useState, useEffect } from 'react';
import { Container, Table, Button, Badge, Alert } from 'react-bootstrap';
import { useNavigate } from 'react-router-dom';
import bookingService from '../../services/bookingService';
import authService from '../../services/authService';

const MyBookings = () => {
    const navigate = useNavigate();
    const [bookings, setBookings] = useState([]);
    const [error, setError] = useState('');

    useEffect(() => {
        if (!authService.isAuthenticated()) {
            navigate('/login');
            return;
        }
        loadBookings();
    }, []);

    const loadBookings = async () => {
        try {
            const data = await bookingService.getUserBookings();
            setBookings(data);
        } catch (error) {
            console.error('Error loading bookings:', error);
            setError('Failed to load bookings');
        }
    };

    const handleCancelBooking = async (bookingId) => {
        if (!window.confirm('Are you sure you want to cancel this booking?')) {
            return;
        }

        try {
            await bookingService.cancelBooking(bookingId);
            loadBookings(); // Reload bookings
        } catch (error) {
            setError(error.response?.data?.message || 'Failed to cancel booking');
        }
    };

    return (
        <Container className="mt-4">
            <div className="d-flex justify-content-between align-items-center mb-4">
                <h2 style={{ color: 'var(--bms-dark-gray)', marginBottom: 0 }}>
                    My Bookings
                </h2>
                <Button
                    className="btn-bms"
                    onClick={() => navigate('/')}
                >
                    Book More Tickets
                </Button>
            </div>

            {error && <Alert variant="danger">{error}</Alert>}

            {bookings.length > 0 ? (
                <Table responsive striped hover>
                    <thead>
                        <tr>
                            <th>Booking ID</th>
                            <th>Movie</th>
                            <th>Theatre</th>
                            <th>Date & Time</th>
                            <th>Seats</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        {bookings.map((booking) => (
                            <tr key={booking.id}>
                                <td>#{booking.id}</td>
                                <td>{booking.movieTitle}</td>
                                <td>{booking.theatreName}</td>
                                <td>
                                    {booking.showDate}<br />
                                    <small className="text-muted">{booking.showTime}</small>
                                </td>
                                <td>
                                    {booking.seats.map((seat) => (
                                        <Badge key={seat.seatId} bg="secondary" className="me-1">
                                            {seat.rowNumber}{seat.seatNumber}
                                        </Badge>
                                    ))}
                                </td>
                                <td>₹{booking.totalAmount}</td>
                                <td>
                                    <Badge bg={booking.status === 'CONFIRMED' ? 'success' : 'danger'}>
                                        {booking.status}
                                    </Badge>
                                </td>
                                <td>
                                    {booking.status === 'CONFIRMED' && (
                                        <Button
                                            variant="outline-danger"
                                            size="sm"
                                            onClick={() => handleCancelBooking(booking.id)}
                                        >
                                            Cancel
                                        </Button>
                                    )}
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </Table>
            ) : (
                <div className="text-center mt-5">
                    <p className="text-muted">No bookings found</p>
                    <Button className="btn-bms" onClick={() => navigate('/')}>
                        Book Tickets Now
                    </Button>
                </div>
            )}
        </Container>
    );
};

export default MyBookings;
