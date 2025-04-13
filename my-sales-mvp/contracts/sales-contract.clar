;; sales-contract.clar
;; Global sales totals and commission rate (stored as a percentage)
(define-data-var total-sales uint u0)
(define-data-var commission-rate uint u5) ;; 5% commission

;; Map to store detailed sales records.
;; Key: sale-id, Value: (tuple with amount, salesperson, and timestamp)
(define-map sales-records { sale-id: uint }
  { amount: uint, salesperson: principal, timestamp: uint })

;; Map to store total sales per salesperson.
;; Key: salesperson, Value: (tuple with total-sales)
(define-map sales-by-salesperson { salesperson: principal }
  { total-sales: uint })

;; Counter for generating unique sale IDs.
(define-data-var sale-counter uint u0)

;; Add a sale record and update state:
;;   - Updates the sales-records map.
;;   - Increments the global total-sales.
;;   - Updates the salesperson's total in sales-by-salesperson.
(define-public (add-sale (amount uint) (salesperson principal) (timestamp uint))
  (begin
    (asserts! (> amount u0) (err u1)) ;; Sale amount must be greater than 0
    
    ;; Additional validation for timestamp (must be reasonable)
    (asserts! (> timestamp u0) (err u2))
    
    ;; Validate the salesperson is not the zero address
    (asserts! (not (is-eq salesperson 'SP000000000000000000002Q6VF78)) (err u3))
    
    (let 
      (
        (sale-id (+ (var-get sale-counter) u1))
        ;; Get current total sales for the salesperson; if none exists, default to u0.
        (current-sales (default-to u0 (get total-sales (map-get? sales-by-salesperson { salesperson: salesperson }))))
      )
      (var-set sale-counter sale-id)
      (map-set sales-records { sale-id: sale-id }
               { amount: amount, salesperson: salesperson, timestamp: timestamp })
      (var-set total-sales (+ (var-get total-sales) amount))
      (map-set sales-by-salesperson { salesperson: salesperson }
               { total-sales: (+ current-sales amount) })
      (ok sale-id)
    )
  )
)

;; Read-only function to retrieve the global total sales.
(define-read-only (get-total-sales)
  (ok (var-get total-sales))
)

;; Read-only function to compute the commission for a given salesperson.
;; Commission is calculated as: (sales * commission-rate) / 100.
(define-read-only (get-commission (salesperson principal))
  (let ((sales (default-to u0 (get total-sales (map-get? sales-by-salesperson { salesperson: salesperson })))))
    (ok (/ (* sales (var-get commission-rate)) u100))
  )
)

;; Get a specific sale record by its ID
(define-read-only (get-sale (sale-id uint))
  (ok (map-get? sales-records { sale-id: sale-id }))
)

;; Get total sales for a specific salesperson
(define-read-only (get-salesperson-sales (salesperson principal))
  (ok (default-to u0 (get total-sales (map-get? sales-by-salesperson { salesperson: salesperson }))))
)
