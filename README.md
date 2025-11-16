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

## Smart Contract Functions

### Public Functions

- `log-flight-hours`: Log a new flight with all relevant details
- `verify-flight-entry`: Airlines can verify logged flight entries
- `authorize-airline`: Contract owner authorizes airlines to verify entries
- `revoke-airline`: Contract owner revokes airline authorization

### Read-Only Functions

- `get-flight-entry`: Retrieve specific flight entry details
- `get-total-hours`: Get total logged hours for a crew member
- `get-crew-entries`: Get all entry IDs for a crew member
- `is-authorized-airline`: Check if an airline is authorized
- `get-total-entries`: Get total number of logged entries
- `get-verified-hours`: Get verified hours for a crew member

## Usage

### Logging Flight Hours
```clarity
(contract-call? .flight-hours-tracker log-flight-hours 
    u100500 
    "AA1234" 
    "JFK" 
    "LAX" 
    u6 
    "Commercial" 
    "Boeing 737" 
    "Captain")
```

### Verifying an Entry
```clarity
(contract-call? .flight-hours-tracker verify-flight-entry u1)
```

## Data Structure

Each flight entry includes:
- Flight date and number
- Departure and arrival airports
- Flight hours (validated 0-24)
- Flight type (Commercial, Training, etc.)
- Aircraft type
- Crew role (Captain, First Officer, Flight Attendant, etc.)
- Verification status

## Testing
- Contract passes `clarinet check` validation
- Hour validation prevents invalid entries
- Authorization system properly restricts verification
- All data structures tested for edge cases

## Type of Change
- New feature (non-breaking change which adds functionality)
- Smart contract implementation

