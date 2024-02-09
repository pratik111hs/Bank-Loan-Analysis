select * from bank_loan_data

--Total Loan Application
select COUNT(id)as tot_loan_applications from bank_loan_data

select COUNT(id)as MTD_loan_applications from bank_loan_data
where MONTH(issue_date)=12 AND YEAR(issue_date)=2021

-- Month on Month % changes in loan_applications
SELECT
  month,
  loan_applications,
  CASE WHEN LAG(loan_applications, 1) OVER (ORDER BY month) IS NOT NULL THEN
      100 * (loan_applications - LAG(loan_applications, 1) OVER (ORDER BY month)) / LAG(loan_applications, 1) OVER (ORDER BY month)
    ELSE NULL END AS pct_change
FROM (
  SELECT
    MONTH(issue_date) AS month,
    COUNT(id) AS loan_applications
  FROM bank_loan_data
  GROUP BY MONTH(issue_date)
) AS subquery
ORDER BY month;

--- Total Funded Amount

select sum(loan_amount) as total_funded_amount from bank_loan_data

-- Get data for latest month

select sum(loan_amount) as MTD_funded_amount from bank_loan_data
where MONTH(issue_date) = 12

-- Month on Month % changes in loan_amount

SELECT
  month,
  monthly_loan_amount,
  CASE WHEN LAG(monthly_loan_amount, 1) OVER (ORDER BY month) IS NOT NULL THEN
      100 * (monthly_loan_amount - LAG(monthly_loan_amount, 1) OVER (ORDER BY month)) / LAG(monthly_loan_amount, 1) OVER (ORDER BY month)
    ELSE NULL END AS pct_change
FROM (
  SELECT
    MONTH(issue_date) AS month,
    sum(loan_amount) AS monthly_loan_amount
  FROM bank_loan_data
  GROUP BY MONTH(issue_date)
) AS subquery
ORDER BY month;

-- Total Recieved Amount

select sum(total_payment)as Total_amount_recieved from bank_loan_data 

-- Month on Month % changes in Avg_Int_Rate

SELECT
  month,
  Total_amount_recieved,
  CASE WHEN LAG(Total_amount_recieved, 1) OVER (ORDER BY month) IS NOT NULL THEN
      100 * (Total_amount_recieved - LAG(Total_amount_recieved, 1) OVER (ORDER BY month)) / LAG(Total_amount_recieved, 1) OVER (ORDER BY month)
    ELSE NULL END AS pct_change
FROM (
  SELECT
    MONTH(issue_date) AS month,
    sum(total_payment)as Total_amount_recieved
  FROM bank_loan_data
  GROUP BY MONTH(issue_date)
) AS subquery
ORDER BY month;


-- Average Interest Rate

select ROUND(AVG(int_rate)*100,2) as Avg_Int_Rate from bank_loan_data

-- Month on Month % changes in Avg_Int_Rate

 SELECT
  month,
  Avg_Int_Rate,
  CASE WHEN LAG(Avg_Int_Rate, 1) OVER (ORDER BY month) IS NOT NULL THEN
      100 * (Avg_Int_Rate - LAG(Avg_Int_Rate, 1) OVER (ORDER BY month)) / LAG(Avg_Int_Rate, 1) OVER (ORDER BY month)
    ELSE NULL END AS pct_change
FROM (
  SELECT
    MONTH(issue_date) AS month,
    ROUND(AVG(int_rate)*100,2) as Avg_Int_Rate
  FROM bank_loan_data
  GROUP BY MONTH(issue_date)
) AS subquery
ORDER BY month;

-- Avg Debt to income Ratio

select Round(AVG(dti)*100,2) as Avg_dti from bank_loan_data

-- Good Loan Application %

select distinct(loan_status) from bank_loan_data

-- Good loan are Current and Fully Paid

select 
COUNT(Case when loan_status IN('Fully Paid','Current') THEN id END) *100 / COUNT(id) as Good_Loan_percentage 
from bank_loan_data

-- Good loan Application
select count(id) as Good_Loan_Applications from bank_loan_data
where loan_status IN ('Fully Paid','Current')

--Good Loan Funded Amount
select sum(loan_amount) as Good_Loan_Funded_Amount from bank_loan_data
where loan_status IN ('Fully Paid','Current')

--Good Loan Total Recieved Amount
select sum(total_payment) as Good_Loan_Recieved_Amount from bank_loan_data
where loan_status IN ('Fully Paid','Current')

-- Bad Loan %
select 
COUNT(Case when loan_status IN('Charged Off') THEN id END) *100 / COUNT(id) as Good_Loan_percentage 
from bank_loan_data

-- Bad Loan Application
select count(id) as Good_Loan_Applications from bank_loan_data
where loan_status IN ('Charged Off')

-- Bad Loan Funded Amount
select sum(loan_amount) as Good_Loan_Funded_Amount from bank_loan_data
where loan_status IN ('Charged Off')

-- Bad Loan Total Recieved Amount
select sum(total_payment) as Good_Loan_Recieved_Amount from bank_loan_data
where loan_status IN ('Charged Off')

-- Loan Status Grid View

select loan_status, count(id) as Loan_Applications,
sum(loan_amount) as tot_loan_amt,
sum(total_payment) as tot_amt_paid,
avg(int_rate*100) as avg_int_rate,
avg(dti *100) as dti
from bank_loan_data
group by loan_status

-- Monthly Trends by Issue Date

select MONTH(issue_date)as Month_Number,
DATENAME(month, issue_date) as month,
count(id) as Loan_Applications,
sum(loan_amount) as tot_loan_amt,
sum(total_payment) as tot_amt_paid
from bank_loan_data
group by DATENAME(month, issue_date),MONTH(issue_date)
order by MONTH(issue_date)

-- Regional Analysis by State

select address_state,
count(id) as Loan_Applications,
sum(loan_amount) as tot_loan_amt,
sum(total_payment) as tot_amt_paid
from bank_loan_data
group by address_state
order by address_state

-- Loan Term Analysis

select term,
count(id) as Loan_Applications,
sum(loan_amount) as tot_loan_amt,
sum(total_payment) as tot_amt_paid
from bank_loan_data
group by term
order by term

-- Employee Length Analysis
select emp_length,
count(id) as Loan_Applications,
sum(loan_amount) as tot_loan_amt,
sum(total_payment) as tot_amt_paid
from bank_loan_data
group by emp_length
order by tot_loan_amt

-- Loan Purpose Breakdown
select purpose,
count(id) as Loan_Applications,
sum(loan_amount) as tot_loan_amt,
sum(total_payment) as tot_amt_paid
from bank_loan_data
group by purpose
order by tot_loan_amt DESC

-- Home Ownership Analysi

select home_ownership,
count(id) as Loan_Applications,
sum(loan_amount) as tot_loan_amt,
sum(total_payment) as tot_amt_paid
from bank_loan_data
group by home_ownership
order by tot_loan_amt DESC













