import React from 'react';
import Select from 'react-select';
import INDIAN_CITIES from '../../config/cities';

const CitySelector = ({ selectedCity, onCityChange, className = '' }) => {
    // Transform cities array into react-select options format
    const cityOptions = INDIAN_CITIES.map(city => ({
        value: city,
        label: city
    }));

    // Find the selected option
    const selectedOption = cityOptions.find(option => option.value === selectedCity);

    // Custom styles for city selector
    const customStyles = {
        control: (provided, state) => ({
            ...provided,
            borderColor: state.isFocused ? 'var(--bms-red)' : '#ced4da',
            boxShadow: state.isFocused ? '0 0 0 0.2rem rgba(220, 53, 69, 0.25)' : 'none',
            '&:hover': {
                borderColor: 'var(--bms-red)'
            },
            minHeight: '38px',
            cursor: 'pointer'
        }),
        option: (provided, state) => ({
            ...provided,
            backgroundColor: state.isSelected
                ? 'var(--bms-red)'
                : state.isFocused
                    ? 'rgba(220, 53, 69, 0.1)'
                    : 'white',
            color: state.isSelected ? 'white' : 'var(--bms-dark-gray)',
            cursor: 'pointer',
            '&:active': {
                backgroundColor: 'var(--bms-red)'
            }
        }),
        input: (provided) => ({
            ...provided,
            color: 'var(--bms-dark-gray)'
        }),
        placeholder: (provided) => ({
            ...provided,
            color: '#6c757d'
        }),
        singleValue: (provided) => ({
            ...provided,
            color: 'var(--bms-dark-gray)'
        })
    };

    return (
        <Select
            value={selectedOption}
            onChange={(option) => onCityChange(option.value)}
            options={cityOptions}
            styles={customStyles}
            placeholder="Search or select your city..."
            className={className}
            isSearchable={true}
            isClearable={false}
        />
    );
};

export default CitySelector;
