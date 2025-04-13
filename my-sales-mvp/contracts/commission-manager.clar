;; commission-manager.clar
;; Contract for managing commission rates and payouts

;; Contract owner - only this principal can update commission settings
(define-data-var contract-owner principal tx-sender)

;; Commission tiers map
;; Key: tier-id, Value: (tuple with min-sales (minimum sales to qualify) and rate (percentage))
(define-map commission-tiers { tier-id: uint }
  { min-sales: uint, rate: uint })

;; Map to store the tier assigned to each salesperson
(define-map salesperson-tiers { salesperson: principal }
  { tier-id: uint })

;; Default commission tier (ID 1) with 5% rate
(map-set commission-tiers { tier-id: u1 } { min-sales: u0, rate: u5 })
;; Tier 2: 7% for $10,000+ in sales
(map-set commission-tiers { tier-id: u2 } { min-sales: u10000, rate: u7 })
;; Tier 3: 10% for $50,000+ in sales
(map-set commission-tiers { tier-id: u3 } { min-sales: u50000, rate: u10 })

;; Check if the sender is the contract owner
(define-private (is-contract-owner)
  (is-eq tx-sender (var-get contract-owner))
)

;; Transfer contract ownership
(define-public (transfer-ownership (new-owner principal))
  (begin
    (asserts! (is-contract-owner) (err u403))
    (asserts! (not (is-eq new-owner (var-get contract-owner))) (err u400))
    (var-set contract-owner new-owner)
    (ok true)
  )
)

;; Create or update a commission tier
(define-public (set-commission-tier (tier-id uint) (min-sales uint) (rate uint))
  (begin
    (asserts! (is-contract-owner) (err u403))
    (asserts! (< rate u100) (err u400)) ;; Commission rate must be less than 100%
    
    ;; Validate tier-id - ensure it's a reasonable value
    (asserts! (> tier-id u0) (err u400)) ;; Tier ID must be positive
    (asserts! (< tier-id u100) (err u400)) ;; Tier ID must be within reasonable range
    
    ;; Validate min-sales - ensure it's within a reasonable range
    (asserts! (<= min-sales u1000000000) (err u400)) ;; Set a reasonable upper limit for min-sales
    
    ;; Now set the values after validation
    (map-set commission-tiers { tier-id: tier-id } { min-sales: min-sales, rate: rate })
    (ok true)
  )
)

;; Manually assign a tier to a salesperson
(define-public (assign-tier (salesperson principal) (tier-id uint))
  (begin
    (asserts! (is-contract-owner) (err u403))
    
    ;; Validate tier-id - ensure it exists
    (asserts! (not (is-none (map-get? commission-tiers { tier-id: tier-id }))) (err u404))
    
    ;; Additional validation for tier-id
    (asserts! (> tier-id u0) (err u400)) ;; Tier ID must be positive
    (asserts! (< tier-id u100) (err u400)) ;; Tier ID must be within reasonable range
    
    ;; Validate salesperson (only basic validation possible for principals)
    (asserts! (not (is-eq salesperson tx-sender)) (err u401)) ;; Simple check to prevent self-assignment
    
    (map-set salesperson-tiers { salesperson: salesperson } { tier-id: tier-id })
    (ok true)
  )
)

;; Find the best tier for a given sales amount by checking each tier
(define-read-only (get-tier-for-sales (sales-amount uint))
  (let
    (
      (tier1 (unwrap-panic (map-get? commission-tiers { tier-id: u1 })))
      (tier2 (unwrap-panic (map-get? commission-tiers { tier-id: u2 })))
      (tier3 (unwrap-panic (map-get? commission-tiers { tier-id: u3 })))
      (min-sales-tier3 (get min-sales tier3))
      (min-sales-tier2 (get min-sales tier2))
    )
    (if (>= sales-amount min-sales-tier3)
      tier3
      (if (>= sales-amount min-sales-tier2)
        tier2
        tier1
      )
    )
  )
)

;; Calculate commission based on sales amount and appropriate tier
(define-read-only (calculate-tiered-commission (sales-amount uint))
  (let ((tier (get-tier-for-sales sales-amount)))
    (/ (* sales-amount (get rate tier)) u100)
  )
)

;; Get a salesperson's assigned tier
(define-read-only (get-salesperson-tier (salesperson principal))
  (default-to {tier-id: u1} (map-get? salesperson-tiers {salesperson: salesperson}))
)

;; Calculate commission for a salesperson with their assigned tier
(define-read-only (calculate-salesperson-commission (salesperson principal) (sales-amount uint))
  (let ((tier-id (get tier-id (get-salesperson-tier salesperson)))
        (tier (default-to {min-sales: u0, rate: u5} (map-get? commission-tiers {tier-id: tier-id}))))
    (/ (* sales-amount (get rate tier)) u100)
  )
)

;; Get contract owner
(define-read-only (get-contract-owner)
  (ok (var-get contract-owner))
)

;; Get commission tier details
(define-read-only (get-tier-details (tier-id uint))
  (ok (map-get? commission-tiers {tier-id: tier-id}))
)
