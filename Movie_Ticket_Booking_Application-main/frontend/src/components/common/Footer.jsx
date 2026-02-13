import React from 'react';
import { Container } from 'react-bootstrap';

const Footer = () => {
    const currentYear = new Date().getFullYear();

    return (
        <footer className="footer mt-5 py-4 bg-dark text-white">
            <Container>
                <div className="row">
                    <div className="col-md-6 text-center text-md-start">
                        <h5 style={{ color: 'var(--bms-red)' }}>Movie Ticket Booking</h5>
                        <p className="mb-0">Your Gateway to Entertainment</p>
                        <p className="small text-muted">
                            Built with Spring Boot & React
                        </p>
                    </div>
                    <div className="col-md-6 text-center text-md-end">
                        <p className="mb-2">
                            <strong>Developed by:</strong> Bhumana Purushotham
                        </p>
                        <p className="small text-muted mb-0">
                            © {currentYear} All Rights Reserved
                        </p>
                        <p className="small text-muted">
                            For educational purposes only
                        </p>
                    </div>
                </div>
            </Container>
        </footer>
    );
};

export default Footer;
