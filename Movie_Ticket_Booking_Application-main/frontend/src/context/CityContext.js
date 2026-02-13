import React, { createContext, useState, useEffect } from 'react';

// Create City Context
export const CityContext = createContext();

// City Provider Component
export const CityProvider = ({ children }) => {
    // Initialize city from localStorage or default to 'Mumbai'
    const [selectedCity, setSelectedCity] = useState(() => {
        const savedCity = localStorage.getItem('selectedCity');
        return savedCity || 'Mumbai';
    });

    // Save to localStorage whenever city changes
    useEffect(() => {
        localStorage.setItem('selectedCity', selectedCity);
    }, [selectedCity]);

    const value = {
        selectedCity,
        setSelectedCity
    };

    return (
        <CityContext.Provider value={value}>
            {children}
        </CityContext.Provider>
    );
};
