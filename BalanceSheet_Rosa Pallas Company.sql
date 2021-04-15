USE H_Accounting;
DROP PROCEDURE IF EXISTS `lsuhuyanly2020_sp`;

DELIMITER $$

CREATE PROCEDURE `lsuhuyanly2020_sp`(varCalendarYear YEAR)
BEGIN

# Declare variables to store the number for each item
DECLARE varCurrentAssets DOUBLE DEFAULT 0;
DECLARE varFixedAssets DOUBLE DEFAULT 0;
DECLARE varDeferredAssets DOUBLE DEFAULT 0;
DECLARE varCurrentLiabilities DOUBLE DEFAULT 0;
DECLARE varLongtermLiabilities DOUBLE DEFAULT 0;
DECLARE varDeferredLiabilities DOUBLE DEFAULT 0;
DECLARE varEquity DOUBLE DEFAULT 0;

# Get the summary of Current Assets
SELECT IFNULL(SUM(jeli.debit),0) - IFNULL(SUM(jeli.credit),0) INTO varCurrentAssets
FROM journal_entry_line_item AS jeli
INNER JOIN account AS a ON a.account_id = jeli.account_id
INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
INNER JOIN statement_section AS ss ON ss.statement_section_id = a.balance_sheet_section_id
WHERE ss.statement_section_code = "CA"
#AND je.debit_credit_balanced = 1
AND je.cancelled = 0
AND YEAR(je.entry_date) = varCalendarYear;

# Get the summary of Fixed Assets
SELECT IFNULL(SUM(jeli.debit),0) - IFNULL(SUM(jeli.credit),0) INTO varFixedAssets
FROM journal_entry_line_item AS jeli
INNER JOIN account AS a ON a.account_id = jeli.account_id
INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
INNER JOIN statement_section AS ss ON ss.statement_section_id = a.balance_sheet_section_id
WHERE ss.statement_section_code = "FA"
#AND je.debit_credit_balanced = 1
AND je.cancelled = 0
AND YEAR(je.entry_date) = varCalendarYear;

# Get the summary of Deferred Assets
SELECT IFNULL(SUM(jeli.debit),0) - IFNULL(SUM(jeli.credit),0) INTO varDeferredAssets
FROM journal_entry_line_item AS jeli
INNER JOIN account AS a ON a.account_id = jeli.account_id
INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
INNER JOIN statement_section AS ss ON ss.statement_section_id = a.balance_sheet_section_id
WHERE ss.statement_section_code = "DA"
#AND je.debit_credit_balanced = 1
AND je.cancelled = 0
AND YEAR(je.entry_date) = varCalendarYear;

# Get the summary of Current Liabilities
SELECT IFNULL(SUM(jeli.debit),0) - IFNULL(SUM(jeli.credit),0) INTO varCurrentLiabilities
FROM journal_entry_line_item AS jeli
INNER JOIN account AS a ON a.account_id = jeli.account_id
INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
INNER JOIN statement_section AS ss ON ss.statement_section_id = a.balance_sheet_section_id
WHERE ss.statement_section_code = "CL"
#AND je.debit_credit_balanced = 1
AND je.cancelled = 0
AND YEAR(je.entry_date) = varCalendarYear;

# Get the summary of Long-term Liabilities
SELECT IFNULL(SUM(jeli.debit),0) - IFNULL(SUM(jeli.credit),0) INTO varLongtermLiabilities
FROM journal_entry_line_item AS jeli
INNER JOIN account AS a ON a.account_id = jeli.account_id
INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
INNER JOIN statement_section AS ss ON ss.statement_section_id = a.balance_sheet_section_id
WHERE ss.statement_section_code = "LLL"
#AND je.debit_credit_balanced = 1
AND je.cancelled = 0
AND YEAR(je.entry_date) = varCalendarYear;

# Get the summary of Deferred Liabilities
SELECT IFNULL(SUM(jeli.debit),0) - IFNULL(SUM(jeli.credit),0) INTO varDeferredLiabilities
FROM journal_entry_line_item AS jeli
INNER JOIN account AS a ON a.account_id = jeli.account_id
INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
INNER JOIN statement_section AS ss ON ss.statement_section_id = a.balance_sheet_section_id
WHERE ss.statement_section_code = "DL"
#AND je.debit_credit_balanced = 1
AND je.cancelled = 0
AND YEAR(je.entry_date) = varCalendarYear;

# Get the summary of Equity
SELECT IFNULL(SUM(jeli.debit),0) - IFNULL(SUM(jeli.credit),0) INTO varEquity
FROM journal_entry_line_item AS jeli
INNER JOIN account AS a ON a.account_id = jeli.account_id
INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
INNER JOIN statement_section AS ss ON ss.statement_section_id = a.balance_sheet_section_id
WHERE ss.statement_section_code = "EQ"
#AND je.debit_credit_balanced = 1
AND je.cancelled = 0
AND YEAR(je.entry_date) = varCalendarYear;

# Show the result
SELECT '0', 'Balance Sheet', varCalendarYear
UNION
SELECT '1','ASSETS ', ''
UNION
SELECT '2','Current Assets', FORMAT(IFNULL(varCurrentAssets, 0), 2)
UNION
SELECT '3','Non-current Assets', ''
UNION
SELECT '4','  Fixed Assets', FORMAT(IFNULL(varFixedAssets, 0), 2)
UNION
SELECT '5','  Deferred Assets', FORMAT(IFNULL(varDeferredAssets, 0), 2)
UNION
SELECT '6','Total Assets', FORMAT(IFNULL(varCurrentAssets, 0) + IFNULL(varFixedAssets, 0) + IFNULL(varDeferredAssets, 0), 2)
UNION
SELECT '7','',''
UNION
SELECT '8','LIABILITIES ', ''
UNION
SELECT '9','Current Liabilities', FORMAT(IFNULL(varCurrentLiabilities * -1, 0), 2)
UNION
SELECT '10','Non-current Liabilities', ''
UNION
SELECT '11','  Long-term Liabilities', FORMAT(IFNULL(varLongtermLiabilities, 0), 2)
UNION
SELECT '12','  Deferred Liabilities', FORMAT(IFNULL(varDeferredLiabilities, 0), 2)
UNION
SELECT '13','Total Liabilities', FORMAT(IFNULL(varCurrentLiabilities * -1, 0) + IFNULL(varLongtermLiabilities, 0) + IFNULL(varDeferredLiabilities, 0), 2)
UNION
SELECT '14','EQUITY ', FORMAT(IFNULL(varEquity * -1, 0), 2)
UNION
SELECT '15','Total Liabilities and Equity', FORMAT(IFNULL(varCurrentLiabilities*-1, 0) + IFNULL(varLongtermLiabilities, 0) + IFNULL(varDeferredLiabilities, 0) + IFNULL(varEquity*-1, 0), 2);

END $$
DELIMITER ;

CALL lsuhuyanly2020_sp(2015);