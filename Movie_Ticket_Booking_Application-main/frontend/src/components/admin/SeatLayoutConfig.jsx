import React, { useState, useEffect } from 'react';
import { Modal, Form, Button, Row, Col, Alert, Badge } from 'react-bootstrap';
import { FaCouch } from 'react-icons/fa';
import theatreService from '../../services/theatreService';

const SeatLayoutConfig = ({ show, onHide, screen, onSuccess }) => {
    const [loading, setLoading] = useState(false);
    const [message, setMessage] = useState('');
    const [existingSeats, setExistingSeats] = useState([]);

    // Configuration state
    const [config, setConfig] = useState({
        platinumRows: 'A,B,C,D,E',
        platinumSeatsPerRow: 12,
        platinumGaps: '6',
        goldRows: 'A,B,C,D,E,F',
        goldSeatsPerRow: 15,
        goldGaps: '7,8',
        silverRows: 'A,B,C,D,E,F,G',
        silverSeatsPerRow: 15,
        silverGaps: '7,8'
    });

    useEffect(() => {
        if (show && screen) {
            loadExistingSeats();
        }
    }, [show, screen]);

    const loadExistingSeats = async () => {
        try {
            const seats = await theatreService.getSeatsForScreen(screen.id);
            setExistingSeats(seats);

            // Parse existing seats to populate config
            if (seats && seats.length > 0) {
                parseExistingSeats(seats);
            }
        } catch (error) {
            console.error('Error loading seats:', error);
        }
    };

    const parseExistingSeats = (seats) => {
        // Group seats by type
        const platinumSeats = seats.filter(s => s.seatType === 'PLATINUM');
        const goldSeats = seats.filter(s => s.seatType === 'GOLD');
        const silverSeats = seats.filter(s => s.seatType === 'SILVER');

        // Helper to extract config from seat group
        const extractConfig = (seatGroup) => {
            if (seatGroup.length === 0) return { rows: '', seatsPerRow: 0, gaps: '' };

            // Get unique rows
            const rows = [...new Set(seatGroup.map(s => s.rowNumber))].sort();

            // Get max seat number to determine seats per row
            const maxSeatNumber = Math.max(...seatGroup.map(s => s.seatNumber));

            // Detect gaps by checking which seat numbers are missing
            const seatNumbersInFirstRow = seatGroup
                .filter(s => s.rowNumber === rows[0])
                .map(s => s.seatNumber)
                .sort((a, b) => a - b);

            const gaps = [];
            for (let i = 1; i <= maxSeatNumber; i++) {
                if (!seatNumbersInFirstRow.includes(i)) {
                    gaps.push(i);
                }
            }

            return {
                rows: rows.join(','),
                seatsPerRow: maxSeatNumber,
                gaps: gaps.join(',')
            };
        };

        const platinumConfig = extractConfig(platinumSeats);
        const goldConfig = extractConfig(goldSeats);
        const silverConfig = extractConfig(silverSeats);

        setConfig({
            platinumRows: platinumConfig.rows || 'A,B,C,D,E',
            platinumSeatsPerRow: platinumConfig.seatsPerRow || 12,
            platinumGaps: platinumConfig.gaps || '6',
            goldRows: goldConfig.rows || 'A,B,C,D,E,F',
            goldSeatsPerRow: goldConfig.seatsPerRow || 15,
            goldGaps: goldConfig.gaps || '7,8',
            silverRows: silverConfig.rows || 'A,B,C,D,E,F,G',
            silverSeatsPerRow: silverConfig.seatsPerRow || 15,
            silverGaps: silverConfig.gaps || '7,8'
        });
    };

    const generateSeats = () => {
        const seats = [];

        // Helper to generate seats for a section
        const generateSection = (rowsStr, seatsPerRow, gapsStr, seatType) => {
            const rows = rowsStr.split(',').map(r => r.trim()).filter(r => r);
            const gaps = gapsStr.split(',').map(g => parseInt(g.trim())).filter(g => !isNaN(g));

            rows.forEach(row => {
                for (let i = 1; i <= seatsPerRow; i++) {
                    // Skip if this position is a gap
                    if (!gaps.includes(i)) {
                        seats.push({
                            rowNumber: row,
                            seatNumber: i,
                            seatType: seatType
                        });
                    }
                }
            });
        };

        // Generate all sections
        generateSection(config.platinumRows, parseInt(config.platinumSeatsPerRow), config.platinumGaps, 'PLATINUM');
        generateSection(config.goldRows, parseInt(config.goldSeatsPerRow), config.goldGaps, 'GOLD');
        generateSection(config.silverRows, parseInt(config.silverSeatsPerRow), config.silverGaps, 'SILVER');

        return seats;
    };

    const handleSave = async () => {
        try {
            setLoading(true);
            setMessage('');

            const seats = generateSeats();

            if (seats.length === 0) {
                setMessage('No seats to create. Please check your configuration.');
                return;
            }

            await theatreService.createBulkSeats(screen.id, seats);
            setMessage(`Successfully created ${seats.length} seats!`);

            setTimeout(() => {
                onSuccess();
                onHide();
            }, 1500);
        } catch (error) {
            setMessage('Error creating seats: ' + (error.response?.data?.message || error.message));
        } finally {
            setLoading(false);
        }
    };

    const previewSeats = () => {
        const seats = generateSeats();
        const seatsByRow = seats.reduce((acc, seat) => {
            if (!acc[seat.rowNumber]) acc[seat.rowNumber] = [];
            acc[seat.rowNumber].push(seat);
            return acc;
        }, {});

        return (
            <div className="seat-preview mt-3 p-3" style={{ backgroundColor: '#f8f9fa', borderRadius: '8px', maxHeight: '300px', overflowY: 'auto' }}>
                <h6>Preview ({seats.length} seats)</h6>
                {Object.keys(seatsByRow).sort().map(row => {
                    const rowSeats = seatsByRow[row].sort((a, b) => a.seatNumber - b.seatNumber);
                    const maxSeat = Math.max(...rowSeats.map(s => s.seatNumber));

                    return (
                        <div key={row} style={{ marginBottom: '8px', display: 'flex', alignItems: 'center', gap: '4px' }}>
                            <Badge bg="secondary" style={{ width: '30px' }}>{row}</Badge>
                            {Array.from({ length: maxSeat }, (_, i) => {
                                const seatNum = i + 1;
                                const seat = rowSeats.find(s => s.seatNumber === seatNum);

                                if (!seat) {
                                    return <div key={i} style={{ width: '24px', height: '24px' }}></div>;
                                }

                                const color = seat.seatType === 'PLATINUM' ? '#E5E4E2' :
                                    seat.seatType === 'GOLD' ? '#FFD700' : '#C0C0C0';

                                return (
                                    <div
                                        key={i}
                                        style={{
                                            width: '24px',
                                            height: '24px',
                                            backgroundColor: color,
                                            borderRadius: '4px',
                                            display: 'flex',
                                            alignItems: 'center',
                                            justifyContent: 'center',
                                            fontSize: '10px',
                                            color: '#333'
                                        }}
                                        title={`${row}${seatNum} - ${seat.seatType}`}
                                    >
                                        <FaCouch />
                                    </div>
                                );
                            })}
                        </div>
                    );
                })}
                <div className="mt-2">
                    <Badge style={{ backgroundColor: '#E5E4E2', color: '#333' }}>Platinum</Badge>{' '}
                    <Badge style={{ backgroundColor: '#FFD700', color: '#333' }}>Gold</Badge>{' '}
                    <Badge style={{ backgroundColor: '#C0C0C0', color: '#333' }}>Silver</Badge>
                </div>
            </div>
        );
    };

    return (
        <Modal show={show} onHide={onHide} size="lg">
            <Modal.Header closeButton>
                <Modal.Title>Configure Seat Layout - Screen {screen?.screenNumber}</Modal.Title>
            </Modal.Header>
            <Modal.Body>
                {message && <Alert variant={message.includes('Error') ? 'danger' : 'success'}>{message}</Alert>}

                {existingSeats.length > 0 && (
                    <Alert variant="warning">
                        This screen has {existingSeats.length} existing seats. Saving will replace them with the new layout.
                    </Alert>
                )}

                <Form>
                    {/* Platinum Section */}
                    <h5 className="mt-3">Platinum Section (Premium)</h5>
                    <Row>
                        <Col md={4}>
                            <Form.Group className="mb-3">
                                <Form.Label>Rows (comma-separated)</Form.Label>
                                <Form.Control
                                    type="text"
                                    value={config.platinumRows}
                                    onChange={(e) => setConfig({ ...config, platinumRows: e.target.value })}
                                    placeholder="A,B,C,D,E"
                                />
                                <Form.Text className="text-muted">Each section starts from row A</Form.Text>
                            </Form.Group>
                        </Col>
                        <Col md={4}>
                            <Form.Group className="mb-3">
                                <Form.Label>Seats per Row</Form.Label>
                                <Form.Control
                                    type="number"
                                    value={config.platinumSeatsPerRow}
                                    onChange={(e) => setConfig({ ...config, platinumSeatsPerRow: e.target.value })}
                                />
                            </Form.Group>
                        </Col>
                        <Col md={4}>
                            <Form.Group className="mb-3">
                                <Form.Label>Gap Positions</Form.Label>
                                <Form.Control
                                    type="text"
                                    value={config.platinumGaps}
                                    onChange={(e) => setConfig({ ...config, platinumGaps: e.target.value })}
                                    placeholder="6"
                                />
                                <Form.Text className="text-muted">Seat numbers to skip (aisle)</Form.Text>
                            </Form.Group>
                        </Col>
                    </Row>

                    {/* Gold Section */}
                    <h5 className="mt-3">Gold Section (Middle)</h5>
                    <Row>
                        <Col md={4}>
                            <Form.Group className="mb-3">
                                <Form.Label>Rows</Form.Label>
                                <Form.Control
                                    type="text"
                                    value={config.goldRows}
                                    onChange={(e) => setConfig({ ...config, goldRows: e.target.value })}
                                    placeholder="A,B,C,D,E,F"
                                />
                                <Form.Text className="text-muted">Starts from row A</Form.Text>
                            </Form.Group>
                        </Col>
                        <Col md={4}>
                            <Form.Group className="mb-3">
                                <Form.Label>Seats per Row</Form.Label>
                                <Form.Control
                                    type="number"
                                    value={config.goldSeatsPerRow}
                                    onChange={(e) => setConfig({ ...config, goldSeatsPerRow: e.target.value })}
                                />
                            </Form.Group>
                        </Col>
                        <Col md={4}>
                            <Form.Group className="mb-3">
                                <Form.Label>Gap Positions</Form.Label>
                                <Form.Control
                                    type="text"
                                    value={config.goldGaps}
                                    onChange={(e) => setConfig({ ...config, goldGaps: e.target.value })}
                                    placeholder="7,8"
                                />
                            </Form.Group>
                        </Col>
                    </Row>

                    {/* Silver Section */}
                    <h5 className="mt-3">Silver Section (Economy)</h5>
                    <Row>
                        <Col md={4}>
                            <Form.Group className="mb-3">
                                <Form.Label>Rows</Form.Label>
                                <Form.Control
                                    type="text"
                                    value={config.silverRows}
                                    onChange={(e) => setConfig({ ...config, silverRows: e.target.value })}
                                    placeholder="A,B,C,D,E,F,G"
                                />
                                <Form.Text className="text-muted">Starts from row A</Form.Text>
                            </Form.Group>
                        </Col>
                        <Col md={4}>
                            <Form.Group className="mb-3">
                                <Form.Label>Seats per Row</Form.Label>
                                <Form.Control
                                    type="number"
                                    value={config.silverSeatsPerRow}
                                    onChange={(e) => setConfig({ ...config, silverSeatsPerRow: e.target.value })}
                                />
                            </Form.Group>
                        </Col>
                        <Col md={4}>
                            <Form.Group className="mb-3">
                                <Form.Label>Gap Positions</Form.Label>
                                <Form.Control
                                    type="text"
                                    value={config.silverGaps}
                                    onChange={(e) => setConfig({ ...config, silverGaps: e.target.value })}
                                    placeholder="7,8"
                                />
                            </Form.Group>
                        </Col>
                    </Row>

                    {/* Preview */}
                    {previewSeats()}
                </Form>
            </Modal.Body>
            <Modal.Footer>
                <Button variant="secondary" onClick={onHide} disabled={loading}>
                    Cancel
                </Button>
                <Button variant="primary" onClick={handleSave} disabled={loading}>
                    {loading ? 'Saving...' : 'Save Layout'}
                </Button>
            </Modal.Footer>
        </Modal>
    );
};

export default SeatLayoutConfig;
