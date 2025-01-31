# Clarity Multi-Signature Wallet

This Clarity smart contract implements a multi-signature wallet with up to 3 owners and a customizable approval threshold.

## Features

* **Multiple Owners:** Supports up to 3 distinct principals as wallet owners.
* **Customizable Threshold:** Define the number of approvals required to execute a transaction (up to the number of owners).
* **Transaction Management:**  Stores transaction details including recipient, amount, approvals, and execution status.
* **Secure Execution:** Transactions require the defined approval threshold before funds can be transferred.

## How it Works

1. **Initialization:** The contract is initialized with a list of owners and an approval threshold.
2. **Transaction Creation:** Any owner can create a new transaction proposal, specifying the recipient and amount.
3. **Approval:** Owners can approve pending transactions.
4. **Execution:** Once a transaction receives the required number of approvals (defined by the threshold), it can be executed, transferring the funds to the recipient.

## Code Overview

The contract utilizes Clarity's data structures and functions to manage the multi-signature functionality:

* `owners`: A list of up to 3 principals representing the wallet owners.
* `threshold`:  An unsigned integer representing the required approvals for transaction execution.
* `transactions`: A map storing transaction details, keyed by a unique transaction ID. Each transaction record includes the recipient, amount, number of approvals, and execution status.
* `transaction-id`: A counter to generate unique transaction IDs.
* `is-owner`: A private function to verify if a given principal is a registered owner of the wallet.

## Usage

### Deployment

Deploy the `ms-wallet.clar` contract to a Stacks blockchain using the Clarity CLI.  During deployment, provide the initial list of owners and the desired approval threshold.

### Transactions

* **Create Transaction:**  Use a function (not yet implemented in provided code snippet) to create a new transaction proposal. This function should require an owner signature and specify the recipient and amount.
* **Approve Transaction:** Use a function (not yet implemented) to approve a pending transaction by its ID. This function should require an owner signature.
* **Execute Transaction:** Use a function (not yet implemented) to execute a transaction that has met the approval threshold. This function should verify the approvals and transfer the funds.

## Future Enhancements

* **Generalized Owner List:**  Remove the 3-owner limit and allow for a dynamic number of owners.
* **Transaction Cancellation:** Implement a mechanism for canceling pending transactions.
* **Security Considerations:** Add further security checks and best practices to mitigate potential vulnerabilities.
* **Comprehensive Testing:** Develop a robust test suite to cover various scenarios and edge cases.


## Contributing

Contributions are welcome! Feel free to open issues and submit pull requests.
