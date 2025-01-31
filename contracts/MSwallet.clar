;; File: ms-wallet.clar

;; Data variable: List of wallet owners, supports up to 3 principals.
(define-data-var owners (list 3 principal) (list))

;; Data variable: Approval threshold for transaction execution.
(define-data-var threshold uint u2)

;; Data variable: Map of transaction details keyed by transaction ID.
(define-map transactions
  uint
  { recipient: principal, amount: uint, approvals: uint, executed: bool })

;; Data variable: Counter for unique transaction IDs.
(define-data-var transaction-id uint u0)

;; Function: Check if a principal is an owner.
(define-private (is-owner (sender principal))
  (let ((current-owners (var-get owners)))
    (or
      (and (is-some (element-at current-owners u0))
           (is-eq sender (unwrap-panic (element-at current-owners u0))))
      (or
        (and (is-some (element-at current-owners u1))
             (is-eq sender (unwrap-panic (element-at current-owners u1))))
        (and (is-some (element-at current-owners u2))
             (is-eq sender (unwrap-panic (element-at current-owners u2))))))))

