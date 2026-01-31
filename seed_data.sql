USE banking_system;

-- 1. Insert Customers
INSERT INTO customers (first_name, last_name, email, phone, address, join_date) VALUES
('John', 'Doe', 'john.doe@example.com', '555-1234', '123 Elm St, NY', '2023-01-15'),
('Jane', 'Smith', 'jane.smith@example.com', '555-5678', '456 Oak Ave, CA', '2023-02-20'),
('Alice', 'Johnson', 'alice.j@example.com', '555-8765', '789 Pine Rd, TX', '2023-03-10'),
('Bob', 'Brown', 'bob.b@example.com', '555-4321', '321 Maple Dr, FL', '2023-04-05'),
('Charlie', 'Davis', 'charlie.d@example.com', '555-6789', '654 Cedar Ln, WA', '2023-05-12'),
('Frank', 'Miller', 'frank.m@example.com', '555-9999', '987 Birch Blvd, OH', '2023-06-01'); -- Frank has no accounts (for Query 7)

-- 2. Insert Accounts
INSERT INTO accounts (customer_id, account_type, balance, created_at) VALUES
(1, 'Savings', 5000.00, '2023-01-16 10:00:00'), -- John
(1, 'Checking', 1500.00, '2023-01-16 10:05:00'), -- John
(2, 'Checking', 12000.50, '2023-02-21 09:30:00'), -- Jane (High Balance)
(3, 'Savings', 3000.00, '2023-03-11 11:00:00'), -- Alice
(4, 'Checking', 200.00, '2023-04-06 14:00:00'),  -- Bob (Low Balance)
(5, 'Checking', 4500.00, '2023-05-13 16:00:00'); -- Charlie

-- 3. Insert Loans
INSERT INTO loans (customer_id, loan_amount, interest_rate, status, start_date) VALUES
(1, 25000.00, 4.50, 'Active', '2023-06-01'),    -- John (Standard Loan)
(3, 5000.00, 3.50, 'Paid', '2023-01-20'),       -- Alice (Paid off)
(4, 150000.00, 6.50, 'Defaulted', '2023-02-15'), -- Bob (High interest, Defaulted - For Query 19 & 8)
(2, 10000.00, 4.00, 'Active', '2023-07-01');    -- Jane

-- 4. Insert Transactions
INSERT INTO transactions (account_id, transaction_type, amount, transaction_date) VALUES
(1, 'Deposit', 1000.00, '2023-06-01 10:00:00'),
(1, 'Withdrawal', 200.00, '2023-06-02 14:00:00'),
(2, 'Deposit', 500.00, '2023-06-03 09:00:00'),
(3, 'Deposit', 5000.00, '2023-06-04 11:00:00'),
(3, 'Withdrawal', 1000.00, '2023-06-05 16:00:00'),
(4, 'Deposit', 300.00, '2023-06-06 12:00:00'),
(5, 'Withdrawal', 50.00, '2023-06-07 08:30:00'),
(6, 'Deposit', 2000.00, '2023-06-08 15:00:00');

-- 5. Trigger Test Data (Automatically adds to fraud_alerts)
-- This transaction is > 10,000, so it should trigger the logic.sql trigger
INSERT INTO transactions (account_id, transaction_type, amount, transaction_date) VALUES
(3, 'Transfer', 15000.00, NOW());