-- ---------------------------------------------------------
-- BASIC RETRIEVAL
-- ---------------------------------------------------------

-- 1. View all customers
SELECT * FROM customers LIMIT 10;

-- 2. List all active checking accounts
SELECT * FROM accounts WHERE account_type = 'Checking' AND balance > 0;

-- 3. Find total balance of a specific customer (e.g., ID 1)
SELECT SUM(balance) AS total_wealth FROM accounts WHERE customer_id = 1;

-- 4. Count number of transactions per transaction type
SELECT transaction_type, COUNT(*) FROM transactions GROUP BY transaction_type;

-- 5. List all loans that are currently 'Active'
SELECT * FROM loans WHERE status = 'Active';

-- ---------------------------------------------------------
-- ADVANCED AGGREGATIONS & JOINS
-- ---------------------------------------------------------

-- 6. Customer Net Worth Report (Deposits)
SELECT c.first_name, c.last_name, SUM(a.balance) as total_balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id
ORDER BY total_balance DESC;

-- 7. Identify customers with NO accounts (Potential churn)
SELECT c.first_name, c.last_name
FROM customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id
WHERE a.account_id IS NULL;

-- 8. High-Interest Loans Report (> 5% interest)
SELECT c.first_name, l.loan_amount, l.interest_rate
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
WHERE l.interest_rate > 5.0;

-- 9. Daily Transaction Volume
SELECT DATE(transaction_date) as date, COUNT(*) as num_trans, SUM(ABS(amount)) as volume
FROM transactions
GROUP BY DATE(transaction_date);

-- 10. Average Loan Amount by Status
SELECT status, ROUND(AVG(loan_amount), 2) as avg_loan
FROM loans
GROUP BY status;

-- ---------------------------------------------------------
-- SIMULATING SYSTEM ACTIONS (Logic Tests)
-- ---------------------------------------------------------

-- 11. TESTING THE STORED PROCEDURE (Success Case)
-- Transfer $500 from Account 1 to Account 2
CALL transfer_funds(1, 2, 500.00);

-- 12. TESTING ACID ROLLBACK (Failure Case)
-- Try to transfer $1,000,000 (More than balance)
CALL transfer_funds(1, 2, 1000000.00);

-- 13. Verify Account Balances after transfer
SELECT account_id, balance FROM accounts WHERE account_id IN (1, 2);

-- 14. TESTING THE TRIGGER (Fraud Detection)
-- Insert a suspicious transaction > $10,000 manually
INSERT INTO transactions (account_id, transaction_type, amount) 
VALUES (1, 'Withdrawal', 15000.00);

-- 15. Check the Fraud Alerts Table
SELECT * FROM fraud_alerts;

-- ---------------------------------------------------------
-- COMPLEX REPORTING
-- ---------------------------------------------------------

-- 16. "VIP Customers" (Balance > $50,000 OR Loan > $100,000)
SELECT DISTINCT c.first_name, c.email
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
LEFT JOIN loans l ON c.customer_id = l.customer_id
WHERE a.balance > 50000 OR l.loan_amount > 100000;

-- 17. Transaction History for Customer ID 1
SELECT t.transaction_date, t.transaction_type, t.amount
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
WHERE a.customer_id = 1
ORDER BY t.transaction_date DESC;

-- 18. Bank Liquidity (Total Cash vs Total Loaned Out)
SELECT 
    (SELECT SUM(balance) FROM accounts) AS total_deposits,
    (SELECT SUM(loan_amount) FROM loans WHERE status='Active') AS total_outstanding_loans;

-- 19. Find Customers who defaulted on loans
SELECT c.first_name, c.last_name, l.loan_amount
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
WHERE l.status = 'Defaulted';

-- 20. View: Create a simplified 'Account Summary' for frontend apps
CREATE VIEW account_summary AS
SELECT c.first_name, c.last_name, a.account_type, a.balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id;

SELECT * FROM account_summary LIMIT 5;