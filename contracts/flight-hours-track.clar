;; Flight Hours Tracker
;; Track and verify flight hours for pilots and cabin crew members

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u200))
(define-constant err-not-found (err u201))
(define-constant err-invalid-hours (err u202))
(define-constant err-unauthorized (err u203))
(define-constant err-already-logged (err u204))

;; Data Variables
(define-data-var log-entry-counter uint u0)

;; Data Maps
(define-map flight-log-entries
    { entry-id: uint }
    {
        crew-member: principal,
        flight-date: uint,
        flight-number: (string-ascii 20),
        departure-airport: (string-ascii 10),
        arrival-airport: (string-ascii 10),
        flight-hours: uint,
        flight-type: (string-ascii 30),
        aircraft-type: (string-ascii 30),
        role: (string-ascii 30),
        verified: bool
    }
)

(define-map crew-member-total-hours
    { crew-member: principal }
    {
        total-hours: uint,
        last-updated: uint,
        entry-count: uint
    }
)

(define-map crew-member-entries
    { crew-member: principal }
    { entry-ids: (list 200 uint) }
)

(define-map authorized-airlines
    { airline: principal }
    { authorized: bool }
)

;; Public Functions

;; Log flight hours
(define-public (log-flight-hours
    (flight-date uint)
    (flight-number (string-ascii 20))
    (departure-airport (string-ascii 10))
    (arrival-airport (string-ascii 10))
    (flight-hours uint)
    (flight-type (string-ascii 30))
    (aircraft-type (string-ascii 30))
    (role (string-ascii 30)))
    (let
        (
            (new-entry-id (+ (var-get log-entry-counter) u1))
            (current-totals (default-to 
                { total-hours: u0, last-updated: u0, entry-count: u0 }
                (map-get? crew-member-total-hours { crew-member: tx-sender })))
        )
        (asserts! (> flight-hours u0) err-invalid-hours)
        (asserts! (<= flight-hours u24) err-invalid-hours)
        (map-set flight-log-entries
            { entry-id: new-entry-id }
            {
                crew-member: tx-sender,
                flight-date: flight-date,
                flight-number: flight-number,
                departure-airport: departure-airport,
                arrival-airport: arrival-airport,
                flight-hours: flight-hours,
                flight-type: flight-type,
                aircraft-type: aircraft-type,
                role: role,
                verified: false
            }
        )
        (map-set crew-member-total-hours
            { crew-member: tx-sender }
            {
                total-hours: (+ (get total-hours current-totals) flight-hours),
                last-updated: flight-date,
                entry-count: (+ (get entry-count current-totals) u1)
            }
        )
        (match (map-get? crew-member-entries { crew-member: tx-sender })
            existing-entries (map-set crew-member-entries
                { crew-member: tx-sender }
                { entry-ids: (unwrap-panic (as-max-len? (append (get entry-ids existing-entries) new-entry-id) u200)) }
            )
            (map-set crew-member-entries
                { crew-member: tx-sender }
                { entry-ids: (list new-entry-id) }
            )
        )
        (var-set log-entry-counter new-entry-id)
        (ok new-entry-id)
    )
)

;; Verify flight hours entry (airline can verify)
(define-public (verify-flight-entry (entry-id uint))
    (let
        (
            (entry (unwrap! (map-get? flight-log-entries { entry-id: entry-id }) err-not-found))
        )
        (asserts! (is-authorized-airline tx-sender) err-unauthorized)
        (map-set flight-log-entries
            { entry-id: entry-id }
            (merge entry { verified: true })
        )
        (ok true)
    )
)

;; Authorize an airline
(define-public (authorize-airline (airline principal))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (ok (map-set authorized-airlines { airline: airline } { authorized: true }))
    )
)

;; Revoke airline authorization
(define-public (revoke-airline (airline principal))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (ok (map-set authorized-airlines { airline: airline } { authorized: false }))
    )
)

;; Read-only Functions

;; Get flight log entry
(define-read-only (get-flight-entry (entry-id uint))
    (map-get? flight-log-entries { entry-id: entry-id })
)

;; Get crew member total hours
(define-read-only (get-total-hours (crew-member principal))
    (map-get? crew-member-total-hours { crew-member: crew-member })
)

;; Get crew member entries
(define-read-only (get-crew-entries (crew-member principal))
    (map-get? crew-member-entries { crew-member: crew-member })
)

;; Check if airline is authorized
(define-read-only (is-authorized-airline (airline principal))
    (default-to false (get authorized (map-get? authorized-airlines { airline: airline })))
)

;; Get total logged entries
(define-read-only (get-total-entries)
    (ok (var-get log-entry-counter))
)

;; Calculate verified hours for a crew member
(define-read-only (get-verified-hours (crew-member principal))
    (ok (get total-hours (default-to 
        { total-hours: u0, last-updated: u0, entry-count: u0 }
        (map-get? crew-member-total-hours { crew-member: crew-member }))))
)