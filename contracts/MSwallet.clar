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

;; Function: Initialize the wallet with owners and a threshold.
(define-public (initialize (initial-owners (list 3 principal)) (initial-threshold uint))
  (begin
    (asserts! (is-eq (var-get owners) (list)) (err u100)) ;; Ensure wallet not already initialized.
    (asserts! (is-eq (len initial-owners) u3) (err u101)) ;; Require exactly 3 owners.
    (asserts! (>= initial-threshold u1) (err u102)) ;; Threshold must be >= 1.
    (asserts! (<= initial-threshold u3) (err u103)) ;; Threshold can't exceed number of owners.
    (var-set owners initial-owners) ;; Set the owners.
    (var-set threshold initial-threshold) ;; Set the threshold.
    (ok true)))

;; Function: Submit a transaction to the wallet.
(define-public (submit-transaction (recipient principal) (amount uint))
  (begin
    (asserts! (is-owner tx-sender) (err u104)) ;; Only owners can submit transactions.
    (asserts! (> amount u0) (err u112)) ;; Validate amount is greater than 0.
    (asserts! (is-ok (principal-destruct? recipient)) (err u114)) ;; Validate recipient principal
    (let ((tx-id (+ (var-get transaction-id) u1))) ;; Directly increment transaction ID
      (begin
        (var-set transaction-id tx-id) ;; Store as uint
        (map-insert transactions tx-id
          { recipient: recipient, amount: amount, approvals: u1, executed: false }) ;; Add transaction with 1 approval (from submitter)
        (ok tx-id)))))

;; Function: Approve and execute transactions if threshold is met.
(define-public (approve-transaction (tx-id uint))
  (let ((tx (unwrap! (map-get? transactions tx-id) (err u106))))
    (asserts! (is-owner tx-sender) (err u105)) ;; Only owners can approve transactions.
    (asserts! (not (get executed tx)) (err u107)) ;; Ensure transaction not already executed.
    (let ((new-approvals (+ (get approvals tx) u1)))
      (if (>= new-approvals (var-get threshold))
          ;; Execute transaction.
          (begin
            (map-set transactions tx-id
              { recipient: (get recipient tx), amount: (get amount tx),
                approvals: new-approvals, executed: true })
            (asserts! (is-ok (stx-transfer? (get amount tx) tx-sender (get recipient tx))) (err u108))
            (ok true))
          ;; Update approvals without executing.
          (begin
            (map-set transactions tx-id
              { recipient: (get recipient tx), amount: (get amount tx),
                approvals: new-approvals, executed: false })
            (ok false))))))

;; Function: Remove an owner from the wallet.
(define-public (remove-owner (owner principal))
  (let ((current-owners (var-get owners)))
    (asserts! (is-owner tx-sender) (err u109)) ;; Only owners can remove an owner.
    (asserts! (> (len current-owners) u1) (err u110)) ;; Ensure at least one owner remains.
    
    ;; Create a new list without the specified owner
    (let ((owner1 (unwrap-panic (element-at current-owners u0)))
          (owner2 (unwrap-panic (element-at current-owners u1)))
          (owner3 (unwrap-panic (element-at current-owners u2)))
          (new-owners (list)))
      
      ;; Add owners that don't match the one to be removed
      (let ((updated-owners1 
              (if (is-eq owner owner1) 
                  new-owners 
                  (append new-owners owner1))))
        (let ((updated-owners2 
                (if (is-eq owner owner2) 
                    updated-owners1 
                    (append updated-owners1 owner2))))
          (let ((final-owners 
                  (if (is-eq owner owner3) 
                      updated-owners2 
                      (append updated-owners2 owner3))))
            
            ;; Ensure owner was removed
            (asserts! (< (len new-owners) (len current-owners)) (err u113))
            
            ;; Update the owners list
            (var-set owners new-owners)
            
            ;; Adjust threshold if necessary
            (if (> (var-get threshold) (len new-owners))
                (var-set threshold (len new-owners))
                true)
            
            (ok true)))))))

