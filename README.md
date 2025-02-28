# Clarity Multi-Signature Wallet

This Clarity smart contract implements a multi-signature wallet with up to 3 owners and a customizable approval threshold.

## Features

* **Multiple Owners:** Supports up to 3 distinct principals as wallet owners.
* **Customizable Threshold:** Define the number of approvals required to execute a transaction (up to the number of owners).
* **Transaction Management:** Stores transaction details including recipient, amount, approvals, and execution status.
* **Secure Execution:** Transactions require the defined approval threshold before funds can be transferred.

## How it Works

1. **Initialization (`initialize`)**: The contract is initialized with a list of 3 owners and an approval threshold. It ensures the wallet isn't already initialized, requires exactly 3 owners, and validates the threshold (1 <= threshold <= 3).

2. **Transaction Creation (`submit-transaction`)**: Any owner can create a new transaction proposal, specifying the recipient and amount. The function validates the recipient and ensures the amount is greater than zero. A unique transaction ID is generated and the transaction details are stored.

3. **Approval (`approve-transaction`)**: Owners can approve pending transactions. The function checks if the transaction exists and isn't already executed. It increments the approval count.

4. **Execution**: Once a transaction receives the required number of approvals (defined by the threshold), it's executed within the `approve-transaction` function. Funds are transferred to the recipient using `stx-transfer?`.

5. **Owner Removal (`remove-owner`)**: An owner can be removed from the wallet. The function ensures the caller is an owner and that at least one owner remains. It creates a new list without the specified owner and updates the owners list. The threshold is adjusted if necessary.

## Code Overview

Key data structures and functions:

* **`owners`**: List of wallet owners (up to 3 principals).
* **`threshold`**: Approval threshold (unsigned integer).
* **`transactions`**: Map storing transaction details (recipient, amount, approvals, executed).
* **`transaction-id`**: Counter for generating unique transaction IDs.
* **`is-owner`**: Private function to verify ownership.
* **`initialize`**: Public function to initialize the wallet.
* **`submit-transaction`**: Public function to submit a transaction proposal.
* **`approve-transaction`**: Public function to approve a transaction and execute it if the threshold is met.
* **`remove-owner`**: Public function to remove an owner from the wallet.

## Usage

### Deployment

Deploy the `ms-wallet.clar` contract to a Stacks blockchain. Provide the initial list of owners and the desired approval threshold during deployment.

### Transactions

* **Create Transaction:** Call `submit-transaction` with the recipient principal and the amount.
* **Approve Transaction:** Call `approve-transaction` with the transaction ID.
* **Check Transaction Status:** Query the `transactions` map using the transaction ID to retrieve its details.
* **Remove Owner:** Call `remove-owner` with the principal of the owner to be removed.

## Future Enhancements

* **Generalized Owner List:** Remove the 3-owner limit.
* **Transaction Cancellation:** Allow cancellation of pending transactions.
* **Security Enhancements:** Add further security checks.
* **Comprehensive Testing:** Expand the test suite.

## Contributing

Contributions are welcome!
