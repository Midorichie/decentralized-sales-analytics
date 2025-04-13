;; sales-contract-test.clar

(define-test test-add-sale
  (begin
    (let ((sale-id (contract-call? .sales-contract add-sale u100 tx-sender u1633046400)))
      (asserts! (is-ok sale-id) "Sale ID should be returned")
    )
  )
)

(define-test test-get-total-sales
  (begin
    ;; Assume a sale of 100 has been added in a previous test setup
    (let ((total (contract-call? .sales-contract get-total-sales)))
      (asserts! (is-eq total (ok u100)) "Total sales should equal 100")
    )
  )
)

(define-test test-commission-calculation
  (begin
    ;; Add a sale for a given salesperson
    (contract-call? .sales-contract add-sale u200 tx-sender u1633046400)
    (let ((commission (contract-call? .sales-contract get-commission tx-sender)))
      ;; For 200 units sale at 5%, commission should be 10 units
      (asserts! (is-eq commission (ok u10)) "Commission for the salesperson should be 10 units")
    )
  )
)
