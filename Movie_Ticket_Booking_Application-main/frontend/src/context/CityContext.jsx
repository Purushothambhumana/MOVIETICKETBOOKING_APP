import React, { createContext, useState, useEffect } from 'react';

// Create the context
export const CityContext = createContext();

// Create the provider component
export const CityProvider = ({ children }) => {
    const [selectedCity, setSelectedCity] = useState(() => {
        // Load from localStorage if available
        return localStorage.getItem('selectedCity') || 'Bengaluru';
    });

    // Save to localStorage whenever city changes
    useEffect(() => {
        if (selectedCity) {
            localStorage.setItem('selectedCity', selectedCity);
        }
    }, [selectedCity]);

    return (
        <CityContext.Provider value={{ selectedCity, setSelectedCity }}>
            {children}
        </CityContext.Provider>
    );
};
