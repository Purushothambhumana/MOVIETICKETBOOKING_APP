import React, { useState, useEffect } from 'react';
import { Container, Row, Col, Card, Button, Alert, Badge, Spinner } from 'react-bootstrap';
import { useParams, useNavigate } from 'react-router-dom';
import { FaCouch, FaTimes } from 'react-icons/fa';
import showService from '../../services/showService';
import bookingService from '../../services/bookingService';
import authService from '../../services/authService';

const SeatSelection = () => {
    const { showId } = useParams();
    const navigate = useNavigate();
    const [show, setShow] = useState(null);
    const [seats, setSeats] = useState([]);
    const [selectedSeats, setSelectedSeats] = useState([]);
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(true);
    const [bookingLoading, setBookingLoading] = useState(false);

    // Seat pricing by type
    const seatPrices = {
        'PLATINUM': 300,
        'GOLD': 200,
        'SILVER': 150
    };

    useEffect(() => {
        if (!authService.isAuthenticated()) {
            navigate('/login');
            return;
        }
        loadShowDetails();
        loadSeats();
    }, [showId]);

    const loadShowDetails = async () => {
        try {
            console.log('Loading show details for showId:', showId);
            const data = await showService.getShowById(showId);
            console.log('Show data received:', data);
            setShow(data);
        } catch (error) {
            console.error('Error loading show details:', error);
            setError('Failed to load show details');
        }
    };

    const loadSeats = async () => {
        try {
            setLoading(true);
            console.log('Loading seats for showId:', showId);
            const data = await bookingService.getAvailableSeats(showId);
            console.log('Seats data received:', data);
            console.log('Number of seats:', data?.length || 0);

            if (!data || data.length === 0) {
                console.warn('No seats found for this show');
                setError('No seats available for this show. Please contact support.');
            }

            setSeats(data || []);
        } catch (error) {
            console.error('Error loading seats:', error);
            setError('Failed to load seats. Please try again.');
        } finally {
            setLoading(false);
        }
    };

    const handleSeatClick = (seat) => {
        if (seat.booked) {
            // Shake animation for booked seats
            return;
        }

        if (selectedSeats.find(s => s.id === seat.id)) {
            setSelectedSeats(selectedSeats.filter(s => s.id !== seat.id));
        } else {
            setSelectedSeats([...selectedSeats, seat]);
        }
    };

    const removeSeat = (seatId) => {
        setSelectedSeats(selectedSeats.filter(s => s.id !== seatId));
    };

    const handleBooking = async () => {
        if (selectedSeats.length === 0) {
            setError('Please select at least one seat');
            return;
        }

        setBookingLoading(true);
        setError('');

        try {
            const bookingData = {
                showId: parseInt(showId),
                seatIds: selectedSeats.map(s => s.id),
                paymentMethod: 'CARD',
            };

            const response = await bookingService.createBooking(bookingData);
            navigate('/booking-confirmation', { state: { booking: response } });
        } catch (error) {
            setError(error.response?.data?.message || 'Booking failed. Please try again.');
        } finally {
            setBookingLoading(false);
        }
    };

    if (loading) {
        return (
            <Container className="mt-5 text-center">
                < Spinner animation="border" variant="danger" />
                <p className="mt-3">Loading seats...</p>
            </Container >
        );
    }

    if (!show) {
        return <Container className="mt-5"><p>Loading show details...</p></Container>;
    }

    // Group seats by row and type
    const seatsByRow = seats.reduce((acc, seat) => {
        if (!acc[seat.rowNumber]) {
            acc[seat.rowNumber] = [];
        }
        acc[seat.rowNumber].push(seat);
        return acc;
    }, {});

    // Group rows by seat type
    const rowsByType = {
        'PLATINUM': [],
        'GOLD': [],
        'SILVER': []
    };

    Object.keys(seatsByRow).forEach(row => {
        const firstSeat = seatsByRow[row][0];
        if (firstSeat && rowsByType[firstSeat.seatType]) {
            rowsByType[firstSeat.seatType].push(row);
        }
    });

    // Calculate pricing
    const calculateTotal = () => {
        return selectedSeats.reduce((total, seat) => {
            return total + (seatPrices[seat.seatType] || 0);
        }, 0);
    };

    const subtotal = calculateTotal();
    const convenienceFee = selectedSeats.length * 20;
    const gst = (subtotal + convenienceFee) * 0.18;
    const totalPrice = subtotal + convenienceFee + gst;

    // Group selected seats by type
    const selectedByType = selectedSeats.reduce((acc, seat) => {
        if (!acc[seat.seatType]) {
            acc[seat.seatType] = [];
        }
        acc[seat.seatType].push(seat);
        return acc;
    }, {});

    return (
        <Container fluid className="seat-selection-page">
            <Row className="mt-4">
                <Col lg={9}>
                    {/* Movie Info Header */}
                    <Card className="mb-4 movie-info-card">
                        <Card.Body>
                            <h3 className="mb-2">{show.movieTitle}</h3>
                            <p className="text-muted mb-0">
                                <strong>{show.theatreName}</strong> | Screen {show.screenNumber} | {' '}
                                {new Date(show.showDate).toLocaleDateString('en-IN', {
                                    weekday: 'short',
                                    day: 'numeric',
                                    month: 'short',
                                    year: 'numeric'
                                })} | {' '}
                                {new Date(`2000-01-01T${show.showTime}`).toLocaleTimeString([], {
                                    hour: '2-digit',
                                    minute: '2-digit'
                                })}
                            </p>
                        </Card.Body>
                    </Card>

                    {error && <Alert variant="danger" dismissible onClose={() => setError('')}>{error}</Alert>}

                    {/* Seat Selection Area */}
                    <div className="seat-selection-container-enhanced">
                        {/* Curved Screen */}
                        <div className="screen-indicator">
                            <div className="screen-curve"></div>
                            <div className="screen-text">SCREEN THIS WAY</div>
                        </div>

                        {seats.length === 0 ? (
                            <Alert variant="warning" className="mt-4">
                                <h5>No Seats Available</h5>
                                <p>There are no seats configured for this screen. Please contact the theatre or try another show.</p>
                            </Alert>
                        ) : (
                            <div className="seats-container">
                                {/* Silver Section - Near Screen */}
                                {rowsByType.SILVER.length > 0 && (
                                    <div className="seat-section silver-section">
                                        <div className="section-header">
                                            <span className="section-icon">�</span>
                                            <span className="section-name">SILVER</span>
                                            <span className="section-price">₹{seatPrices.SILVER}</span>
                                        </div>
                                        <div className="seats-grid">
                                            {rowsByType.SILVER.sort().map((row) => {
                                                const rowSeats = seatsByRow[row].sort((a, b) => a.seatNumber - b.seatNumber);
                                                const midPoint = Math.ceil(rowSeats.length / 2);
                                                const leftSeats = rowSeats.slice(0, midPoint);
                                                const rightSeats = rowSeats.slice(midPoint);

                                                return (
                                                    <div key={row} className="seat-row">
                                                        <div className="row-label">{row}</div>
                                                        <div className="seats-row-container">
                                                            {/* Left section */}
                                                            {leftSeats.map((seat) => (
                                                                <div
                                                                    key={seat.id}
                                                                    className={`seat silver ${seat.booked ? 'booked' :
                                                                        selectedSeats.find(s => s.id === seat.id) ? 'selected' :
                                                                            'available'
                                                                        }`}
                                                                    onClick={() => handleSeatClick(seat)}
                                                                    title={`${seat.rowNumber}${seat.seatNumber} - ${seat.seatType} - ₹${seatPrices[seat.seatType]}`}
                                                                >
                                                                    <FaCouch />
                                                                </div>
                                                            ))}

                                                            {/* Aisle gap */}
                                                            <div className="aisle-gap"></div>

                                                            {/* Right section */}
                                                            {rightSeats.map((seat) => (
                                                                <div
                                                                    key={seat.id}
                                                                    className={`seat silver ${seat.booked ? 'booked' :
                                                                        selectedSeats.find(s => s.id === seat.id) ? 'selected' :
                                                                            'available'
                                                                        }`}
                                                                    onClick={() => handleSeatClick(seat)}
                                                                    title={`${seat.rowNumber}${seat.seatNumber} - ${seat.seatType} - ₹${seatPrices[seat.seatType]}`}
                                                                >
                                                                    <FaCouch />
                                                                </div>
                                                            ))}
                                                        </div>
                                                        <div className="row-label">{row}</div>
                                                    </div>
                                                );
                                            })}
                                        </div>
                                    </div>
                                )}

                                {/* Gold Section - Middle */}
                                {rowsByType.GOLD.length > 0 && (
                                    <div className="seat-section gold-section">
                                        <div className="section-header">
                                            <span className="section-icon">💺</span>
                                            <span className="section-name">GOLD</span>
                                            <span className="section-price">₹{seatPrices.GOLD}</span>
                                        </div>
                                        <div className="seats-grid">
                                            {rowsByType.GOLD.sort().map((row) => {
                                                const rowSeats = seatsByRow[row].sort((a, b) => a.seatNumber - b.seatNumber);
                                                const midPoint = Math.ceil(rowSeats.length / 2);
                                                const leftSeats = rowSeats.slice(0, midPoint);
                                                const rightSeats = rowSeats.slice(midPoint);

                                                return (
                                                    <div key={row} className="seat-row">
                                                        <div className="row-label">{row}</div>
                                                        <div className="seats-row-container">
                                                            {leftSeats.map((seat) => (
                                                                <div
                                                                    key={seat.id}
                                                                    className={`seat gold ${seat.booked ? 'booked' :
                                                                        selectedSeats.find(s => s.id === seat.id) ? 'selected' :
                                                                            'available'
                                                                        }`}
                                                                    onClick={() => handleSeatClick(seat)}
                                                                    title={`${seat.rowNumber}${seat.seatNumber} - ${seat.seatType} - ₹${seatPrices[seat.seatType]}`}
                                                                >
                                                                    <FaCouch />
                                                                </div>
                                                            ))}
                                                            <div className="aisle-gap"></div>
                                                            {rightSeats.map((seat) => (
                                                                <div
                                                                    key={seat.id}
                                                                    className={`seat gold ${seat.booked ? 'booked' :
                                                                        selectedSeats.find(s => s.id === seat.id) ? 'selected' :
                                                                            'available'
                                                                        }`}
                                                                    onClick={() => handleSeatClick(seat)}
                                                                    title={`${seat.rowNumber}${seat.seatNumber} - ${seat.seatType} - ₹${seatPrices[seat.seatType]}`}
                                                                >
                                                                    <FaCouch />
                                                                </div>
                                                            ))}
                                                        </div>
                                                        <div className="row-label">{row}</div>
                                                    </div>
                                                );
                                            })}
                                        </div>
                                    </div>
                                )}

                                {/* Platinum Section - Back (Away from Screen) */}
                                {rowsByType.PLATINUM.length > 0 && (
                                    <div className="seat-section platinum-section">
                                        <div className="section-header">
                                            <span className="section-icon">�</span>
                                            <span className="section-name">PLATINUM</span>
                                            <span className="section-price">₹{seatPrices.PLATINUM}</span>
                                        </div>
                                        <div className="seats-grid">
                                            {rowsByType.PLATINUM.sort().map((row) => {
                                                const rowSeats = seatsByRow[row].sort((a, b) => a.seatNumber - b.seatNumber);
                                                const midPoint = Math.ceil(rowSeats.length / 2);
                                                const leftSeats = rowSeats.slice(0, midPoint);
                                                const rightSeats = rowSeats.slice(midPoint);

                                                return (
                                                    <div key={row} className="seat-row">
                                                        <div className="row-label">{row}</div>
                                                        <div className="seats-row-container">
                                                            {leftSeats.map((seat) => (
                                                                <div
                                                                    key={seat.id}
                                                                    className={`seat premium ${seat.booked ? 'booked' :
                                                                        selectedSeats.find(s => s.id === seat.id) ? 'selected' :
                                                                            'available'
                                                                        }`}
                                                                    onClick={() => handleSeatClick(seat)}
                                                                    title={`${seat.rowNumber}${seat.seatNumber} - ${seat.seatType} - ₹${seatPrices[seat.seatType]}`}
                                                                >
                                                                    <FaCouch />
                                                                </div>
                                                            ))}
                                                            <div className="aisle-gap"></div>
                                                            {rightSeats.map((seat) => (
                                                                <div
                                                                    key={seat.id}
                                                                    className={`seat premium ${seat.booked ? 'booked' :
                                                                        selectedSeats.find(s => s.id === seat.id) ? 'selected' :
                                                                            'available'
                                                                        }`}
                                                                    onClick={() => handleSeatClick(seat)}
                                                                    title={`${seat.rowNumber}${seat.seatNumber} - ${seat.seatType} - ₹${seatPrices[seat.seatType]}`}
                                                                >
                                                                    <FaCouch />
                                                                </div>
                                                            ))}
                                                        </div>
                                                        <div className="row-label">{row}</div>
                                                    </div>
                                                );
                                            })}
                                        </div>
                                    </div>
                                )}
                            </div>
                        )}

                        {/* Legend */}
                        <div className="seat-legend-enhanced">
                            <div className="legend-item">
                                <div className="legend-seat available"><FaCouch /></div>
                                <span>Available</span>
                            </div>
                            <div className="legend-item">
                                <div className="legend-seat selected"><FaCouch /></div>
                                <span>Selected</span>
                            </div>
                            <div className="legend-item">
                                <div className="legend-seat booked"><FaCouch /></div>
                                <span>Booked</span>
                            </div>
                        </div>
                    </div>
                </Col>

                {/* Enhanced Booking Summary */}
                <Col lg={3}>
                    <div className="booking-summary-enhanced">
                        <h4 className="summary-title">Booking Summary</h4>

                        {/* Selected Seats */}
                        <div className="selected-seats-section">
                            <h6 className="section-subtitle">Selected Seats</h6>
                            {selectedSeats.length > 0 ? (
                                <div className="selected-seats-list">
                                    {Object.keys(selectedByType).map(type => (
                                        <div key={type} className="seat-type-group">
                                            <div className="seat-type-label">{type}</div>
                                            <div className="seat-badges">
                                                {selectedByType[type].map(seat => (
                                                    <Badge
                                                        key={seat.id}
                                                        className={`seat-badge ${type.toLowerCase()}`}
                                                    >
                                                        {seat.rowNumber}{seat.seatNumber}
                                                        <FaTimes
                                                            className="remove-seat"
                                                            onClick={() => removeSeat(seat.id)}
                                                        />
                                                    </Badge>
                                                ))}
                                            </div>
                                        </div>
                                    ))}
                                </div>
                            ) : (
                                <p className="no-seats-text">No seats selected</p>
                            )}
                        </div>

                        {/* Pricing Breakdown */}
                        {selectedSeats.length > 0 && (
                            <>
                                <hr />
                                <div className="pricing-breakdown">
                                    <h6 className="section-subtitle">Price Breakdown</h6>

                                    {Object.keys(selectedByType).map(type => (
                                        <div key={type} className="price-row">
                                            <span>{type} ({selectedByType[type].length} × ₹{seatPrices[type]})</span>
                                            <span>₹{selectedByType[type].length * seatPrices[type]}</span>
                                        </div>
                                    ))}

                                    <div className="price-row">
                                        <span>Convenience Fee ({selectedSeats.length} × ₹20)</span>
                                        <span>₹{convenienceFee}</span>
                                    </div>

                                    <div className="price-row">
                                        <span>GST (18%)</span>
                                        <span>₹{gst.toFixed(2)}</span>
                                    </div>

                                    <hr />

                                    <div className="total-price-row">
                                        <span>Total Amount</span>
                                        <span className="total-amount">₹{totalPrice.toFixed(2)}</span>
                                    </div>
                                </div>
                            </>
                        )}

                        <Button
                            className="btn-bms w-100 mt-4 proceed-btn"
                            onClick={handleBooking}
                            disabled={selectedSeats.length === 0 || bookingLoading}
                            size="lg"
                        >
                            {bookingLoading ? (
                                <>
                                    <Spinner animation="border" size="sm" className="me-2" />
                                    Processing...
                                </>
                            ) : (
                                `Proceed to Pay ₹${totalPrice.toFixed(2)}`
                            )}
                        </Button>

                        <p className="terms-text mt-3">
                            By proceeding, you agree to our Terms & Conditions
                        </p>
                    </div>
                </Col>
            </Row>
        </Container>
    );
};

export default SeatSelection;
