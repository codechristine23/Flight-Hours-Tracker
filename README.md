Add Flight Hours Tracker with Airline Verification System

## Description
This PR implements a blockchain-based flight hours logging system that enables pilots and cabin crew to maintain verifiable records of their flight time with airline verification capabilities.

## Changes
- Implemented flight hours logging with detailed flight information
- Added automatic hour accumulation and tracking
- Created airline authorization and verification system
- Built validation rules to prevent invalid entries
- Included comprehensive flight data storage (airports, aircraft, roles)

## Features
- Log individual flights with complete details
- Automatic calculation of total flight hours
- Airline verification workflow for logged entries
- Track flight history by crew member
- Validate flight hours (1-24 hours per flight)
- Store aircraft type, flight route, and crew role information

## Testing
- Contract passes `clarinet check` validation
- Hour validation prevents invalid entries
- Authorization system properly restricts verification
- All data structures tested for edge cases

## Type of Change
- New feature (non-breaking change which adds functionality)
- Smart contract implementation

