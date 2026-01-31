-- ---------------------------------------------------------
-- 1. TRIGGER: Fraud Detection System
-- ---------------------------------------------------------
-- Rule: If a transaction > $10,000 occurs, log it immediately in fraud_alerts.
DELIMITER $$
CREATE TRIGGER check_fraud_high_amount
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    IF NEW.amount > 10000 THEN
        INSERT INTO fraud_alerts (transaction_id, account_id, alert_message)
        VALUES (NEW.transaction_id, NEW.account_id, 'High Value Transaction Detected: Potential Fraud');
    END IF;
END $$
DELIMITER ;

-- ---------------------------------------------------------
-- 2. STORED PROCEDURE: Secure Money Transfer (ACID)
-- ---------------------------------------------------------
-- This procedure ensures that money is not lost if an error occurs halfway.
DELIMITER $$
CREATE PROCEDURE transfer_funds(
    IN sender_id INT,
    IN receiver_id INT,
    IN amount DECIMAL(15,2)
)
BEGIN
    -- A. Start the Transaction (Turn off auto-commit)
    START TRANSACTION;

    -- B. Check if sender has enough money
    SET @current_balance = (SELECT balance FROM accounts WHERE account_id = sender_id);
    
    IF @current_balance >= amount THEN
        -- 1. Deduct from Sender
        UPDATE accounts SET balance = balance - amount WHERE account_id = sender_id;
        
        -- 2. Add to Receiver
        UPDATE accounts SET balance = balance + amount WHERE account_id = receiver_id;
        
        -- 3. Record the Transaction logs
        INSERT INTO transactions (account_id, transaction_type, amount) VALUES (sender_id, 'Transfer', -amount);
        INSERT INTO transactions (account_id, transaction_type, amount) VALUES (receiver_id, 'Transfer', amount);
        
        -- C. Commit changes (Save permanently)
        COMMIT;
        SELECT 'Transaction Successful' AS status;
        
    ELSE
        -- D. Rollback if insufficient funds (Undo everything)
        ROLLBACK;
        SELECT 'Insufficient Funds - Transaction Cancelled' AS status;
    END IF;
END $$
DELIMITER ;