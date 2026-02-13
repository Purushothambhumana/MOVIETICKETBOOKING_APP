import React, { useState } from 'react';
import { Modal, Form, InputGroup, Row, Col } from 'react-bootstrap';
import { FaSearch, FaMapMarkerAlt } from 'react-icons/fa';
import './CityModal.css';

const CityModal = ({ show, onHide, selectedCity, onCityChange }) => {
    const [searchQuery, setSearchQuery] = useState('');

    const popularCities = [
        { name: 'Mumbai', icon: '🏙️' },
        { name: 'Kochi', icon: '🌴' },
        { name: 'Delhi-NCR', icon: '🏛️' },
        { name: 'Bengaluru', icon: '🌆' },
        { name: 'Hyderabad', icon: '🏰' },
        { name: 'Chandigarh', icon: '🌳' },
        { name: 'Ahmedabad', icon: '🕌' },
        { name: 'Pune', icon: '🏫' },
        { name: 'Chennai', icon: '🏖️' },
        { name: 'Kolkata', icon: '🎭' }
    ];

    const allCities = [
        'Mumbai', 'Delhi-NCR', 'Bengaluru', 'Hyderabad', 'Ahmedabad', 'Chandigarh',
        'Chennai', 'Pune', 'Kolkata', 'Kochi', 'Jaipur', 'Lucknow', 'Kanpur',
        'Nagpur', 'Indore', 'Thane', 'Bhopal', 'Visakhapatnam', 'Pimpri-Chinchwad',
        'Patna', 'Vadodara', 'Ghaziabad', 'Ludhiana', 'Agra', 'Nashik', 'Faridabad',
        'Meerut', 'Rajkot', 'Kalyan-Dombivali', 'Vasai-Virar', 'Varanasi', 'Srinagar',
        'Aurangabad', 'Dhanbad', 'Amritsar', 'Navi Mumbai', 'Allahabad', 'Ranchi',
        'Howrah', 'Coimbatore', 'Jabalpur', 'Gwalior', 'Vijayawada', 'Jodhpur',
        'Madurai', 'Raipur', 'Kota', 'Guwahati', 'Chandigarh', 'Solapur', 'Hubli-Dharwad',
        'Bareilly', 'Moradabad', 'Mysore', 'Gurgaon', 'Aligarh', 'Jalandhar', 'Tiruchirappalli',
        'Bhubaneswar', 'Salem', 'Mira-Bhayandar', 'Thiruvananthapuram', 'Bhiwandi',
        'Saharanpur', 'Gorakhpur', 'Guntur', 'Bikaner', 'Amravati', 'Noida', 'Jamshedpur',
        'Bhilai', 'Cuttack', 'Firozabad', 'Kochi', 'Nellore', 'Bhavnagar', 'Dehradun',
        'Durgapur', 'Asansol', 'Rourkela', 'Nanded', 'Kolhapur', 'Ajmer', 'Akola',
        'Gulbarga', 'Jamnagar', 'Ujjain', 'Loni', 'Siliguri', 'Jhansi', 'Ulhasnagar',
        'Jammu', 'Sangli-Miraj & Kupwad', 'Mangalore', 'Erode', 'Belgaum', 'Ambattur',
        'Tirunelveli', 'Malegaon', 'Gaya', 'Jalgaon', 'Udaipur', 'Maheshtala'
    ];

    const filteredCities = allCities.filter(city =>
        city.toLowerCase().includes(searchQuery.toLowerCase())
    );

    const handleCitySelect = (city) => {
        onCityChange(city);
        onHide();
    };

    const handleDetectLocation = () => {
        if (!navigator.geolocation) {
            alert('Geolocation is not supported by your browser');
            return;
        }

        // Show loading state
        const detectButton = document.querySelector('.detect-location');
        if (detectButton) {
            detectButton.innerHTML = '<span>Detecting location...</span>';
        }

        navigator.geolocation.getCurrentPosition(
            async (position) => {
                const { latitude, longitude } = position.coords;

                try {
                    // Use reverse geocoding to get city name
                    // Using OpenStreetMap Nominatim API (free, no API key required)
                    const response = await fetch(
                        `https://nominatim.openstreetmap.org/reverse?format=json&lat=${latitude}&lon=${longitude}`
                    );
                    const data = await response.json();

                    // Extract city from response
                    let detectedCity = data.address.city ||
                        data.address.town ||
                        data.address.village ||
                        data.address.state_district ||
                        data.address.state;

                    // Map common variations to our city list
                    const cityMappings = {
                        'Bangalore': 'Bengaluru',
                        'Bombay': 'Mumbai',
                        'Calcutta': 'Kolkata',
                        'Madras': 'Chennai',
                        'Pune City': 'Pune',
                        'New Delhi': 'Delhi-NCR',
                        'Delhi': 'Delhi-NCR',
                        'Noida': 'Delhi-NCR',
                        'Gurgaon': 'Delhi-NCR',
                        'Gurugram': 'Delhi-NCR',
                        'Faridabad': 'Delhi-NCR',
                        'Ghaziabad': 'Delhi-NCR'
                    };

                    detectedCity = cityMappings[detectedCity] || detectedCity;

                    // Check if detected city is in our list
                    if (allCities.includes(detectedCity)) {
                        handleCitySelect(detectedCity);
                    } else {
                        // If not found, try to find closest match
                        const closestCity = allCities.find(city =>
                            city.toLowerCase().includes(detectedCity.toLowerCase()) ||
                            detectedCity.toLowerCase().includes(city.toLowerCase())
                        );

                        if (closestCity) {
                            handleCitySelect(closestCity);
                        } else {
                            alert(`Location detected: ${detectedCity}\nThis city is not in our service area yet. Please select a nearby city.`);
                            // Reset button
                            if (detectButton) {
                                detectButton.innerHTML = '<svg class="location-icon">...</svg><span>Detect my location</span>';
                            }
                        }
                    }
                } catch (error) {
                    console.error('Error getting city name:', error);
                    alert('Could not determine your city. Please select manually.');
                    // Reset button
                    if (detectButton) {
                        detectButton.innerHTML = '<svg class="location-icon">...</svg><span>Detect my location</span>';
                    }
                }
            },
            (error) => {
                let errorMessage = 'Unable to detect location. ';
                switch (error.code) {
                    case error.PERMISSION_DENIED:
                        errorMessage += 'Please allow location access in your browser.';
                        break;
                    case error.POSITION_UNAVAILABLE:
                        errorMessage += 'Location information is unavailable.';
                        break;
                    case error.TIMEOUT:
                        errorMessage += 'Location request timed out.';
                        break;
                    default:
                        errorMessage += 'An unknown error occurred.';
                }
                alert(errorMessage);
                // Reset button
                if (detectButton) {
                    detectButton.innerHTML = '<svg class="location-icon">...</svg><span>Detect my location</span>';
                }
            },
            {
                enableHighAccuracy: true,
                timeout: 10000,
                maximumAge: 0
            }
        );
    };

    return (
        <Modal show={show} onHide={onHide} centered size="lg" className="city-modal">
            <Modal.Body className="p-4">
                <div className="city-modal-content">
                    {/* Search Bar */}
                    <InputGroup className="mb-3">
                        <InputGroup.Text>
                            <FaSearch />
                        </InputGroup.Text>
                        <Form.Control
                            type="text"
                            placeholder="Search for your city"
                            value={searchQuery}
                            onChange={(e) => setSearchQuery(e.target.value)}
                            autoFocus
                        />
                    </InputGroup>

                    {/* Detect Location */}
                    <div className="detect-location mb-4" onClick={handleDetectLocation}>
                        <FaMapMarkerAlt className="location-icon" />
                        <span>Detect my location</span>
                    </div>

                    {!searchQuery && (
                        <>
                            {/* Popular Cities */}
                            <h6 className="section-title">Popular Cities</h6>
                            <Row className="popular-cities mb-4">
                                {popularCities.map((city) => (
                                    <Col
                                        key={city.name}
                                        xs={6}
                                        sm={4}
                                        md={3}
                                        lg={2}
                                        className="city-item"
                                        onClick={() => handleCitySelect(city.name)}
                                    >
                                        <div className="city-card">
                                            <div className="city-icon">{city.icon}</div>
                                            <div className="city-name">{city.name}</div>
                                        </div>
                                    </Col>
                                ))}
                            </Row>

                            {/* View All Cities Link */}
                            <div className="text-center">
                                <span
                                    className="view-all-link"
                                    onClick={() => setSearchQuery(' ')}
                                >
                                    View All Cities
                                </span>
                            </div>
                        </>
                    )}

                    {/* All Cities List (shown when searching or "View All" clicked) */}
                    {searchQuery && (
                        <>
                            <h6 className="section-title">
                                {filteredCities.length} Cities
                            </h6>
                            <div className="all-cities-list">
                                {filteredCities.map((city) => (
                                    <div
                                        key={city}
                                        className={`city-list-item ${selectedCity === city ? 'selected' : ''}`}
                                        onClick={() => handleCitySelect(city)}
                                    >
                                        {city}
                                    </div>
                                ))}
                                {filteredCities.length === 0 && (
                                    <div className="no-results">
                                        No cities found matching "{searchQuery}"
                                    </div>
                                )}
                            </div>
                        </>
                    )}
                </div>
            </Modal.Body>
        </Modal>
    );
};

export default CityModal;
