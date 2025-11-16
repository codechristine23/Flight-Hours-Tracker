# Flight Hours Tracker

A blockchain-based flight hours logging and verification system for pilots and cabin crew on the Stacks blockchain.

## Overview

Flight Hours Tracker enables aviation professionals to maintain an immutable, verifiable record of their flight hours. Airlines can verify logged hours, creating a trusted system for tracking crew experience and regulatory compliance.

## Features

- **Flight Logging**: Log individual flights with detailed information
- **Automatic Hour Calculation**: Track total flight hours automatically
- **Airline Verification**: Authorized airlines can verify flight entries
- **Comprehensive Records**: Store flight numbers, airports, aircraft types, and crew roles
- **Entry Tracking**: Maintain complete history of all logged flights
- **Hour Validation**: Prevent invalid hour entries (0-24 hours per flight)

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

## Installation

1. Install Clarinet: https://github.com/hirosystems/clarinet
2. Clone this repository
3. Run `clarinet check` to validate the contract
4. Deploy with `clarinet deploy`

## Testing
```bash
clarinet test
```

## Validation Rules

- Flight hours must be between 1 and 24
- Each flight is logged as a separate entry
- Total hours automatically accumulate
- Only authorized airlines can verify entries

## Security Considerations

- Hour limits prevent data entry errors
- Only contract owner can authorize airlines
- All entries are immutable once created
- Verification status tracked separately

## Use Cases

- Pilot logbook replacement
- Regulatory compliance tracking
- Airline crew management
- Insurance verification
- Career progression documentation

## License

MIT License

## Contributing

Contributions welcome! Please open an issue or submit a pull request.

## Contact

For questions or support, please open an issue in this repository.