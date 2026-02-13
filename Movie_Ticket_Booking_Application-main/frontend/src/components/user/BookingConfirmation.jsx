import React from 'react';
import { Container, Row, Col, Card, Button } from 'react-bootstrap';
import { useLocation, useNavigate } from 'react-router-dom';

const BookingConfirmation = () => {
    const location = useLocation();
    const navigate = useNavigate();
    const booking = location.state?.booking;

    if (!booking) {
        return (
            <Container className="mt-5">
                <p>No booking information available</p>
                <Button onClick={() => navigate('/')}>Go to Home</Button>
            </Container>
        );
    }

    return (
        <Container className="mt-5">
            <Row className="justify-content-center">
                <Col md={8}>
                    <Card className="text-center">
                        <Card.Body className="p-5">
                            <div className="mb-4">
                                <i className="bi bi-check-circle-fill" style={{ fontSize: '4rem', color: '#00AA00' }}></i>
                            </div>

                            <h2 style={{ color: 'var(--bms-red)' }}>Booking Confirmed!</h2>
                            <p className="text-muted mb-4">Your tickets have been booked successfully</p>

                            <hr />

                            <Row className="mt-4 text-start">
                                <Col md={6}>
                                    <p><strong>Booking ID:</strong> {booking.id}</p>
                                    <p><strong>Movie:</strong> {booking.movieTitle}</p>
                                    <p><strong>Theatre:</strong> {booking.theatreName}</p>
                                </Col>
                                <Col md={6}>
                                    <p><strong>Date:</strong> {booking.showDate}</p>
                                    <p><strong>Time:</strong> {booking.showTime}</p>
                                    <p><strong>Status:</strong> <span className="badge bg-success">{booking.status}</span></p>
                                </Col>
                            </Row>

                            <div className="mt-4 text-start">
                                <p><strong>Seats:</strong></p>
                                <div className="mb-3">
                                    {booking.seats.map((seat) => (
                                        <span key={seat.seatId} className="badge bg-success me-2 mb-2">
                                            {seat.rowNumber}{seat.seatNumber} ({seat.seatType})
                                        </span>
                                    ))}
                                </div>
                            </div>

                            <div className="mt-4">
                                <h4 style={{ color: 'var(--bms-red)' }}>Total Amount: ₹{booking.totalAmount}</h4>
                            </div>

                            <hr />

                            <div className="mt-4">
                                <Button
                                    className="btn-bms me-3"
                                    onClick={() => navigate('/my-bookings')}
                                >
                                    View My Bookings
                                </Button>
                                <Button
                                    className="btn-bms-outline"
                                    onClick={() => navigate('/')}
                                >
                                    Book More Tickets
                                </Button>
                            </div>
                        </Card.Body>
                    </Card>
                </Col>
            </Row>
        </Container>
    );
};

export default BookingConfirmation;
