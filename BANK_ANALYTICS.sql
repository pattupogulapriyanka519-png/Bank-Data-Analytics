use bank_loan_project ;
select * from finance_01 ;
select * from finance_2 ;

/*
Year wise loan amount
 Grade-Subgrade wise revolution balance
 Total Payment For Verified Status Vs Non Verified Status
 State Wise Last credit pull _d Wise Loan Status
 Home Ownership Vs Last Payment Date Stats.
*/

#change data type of issue_d in date tye
ALTER TABLE finance_01
modify issue_d date;

update finance_01
set issue_d=str_to_date(issue_d,"%d-%m-%Y");

# Total Loan Amount
Select sum(loan_amnt) total_loan_amnt from finance_01;

# Total loan issued
Select distinct count(member_id) as number_of_loan_issued
from finance_01;

# Cumulative interest rate
Select avg(int_rate) as cumulative_interest_rate
from finance_01;

#average dti
select avg(cast(replace(dti, '%', '') as decimal (5,2))) as average_dti
from finance_01;

# Average funded amount
Select avg(funded_amnt) as average_funded_amount
from finance_01;


#KPI 1    Year wise loan amount
select year(issue_d) as year_of_issue_d, sum(loan_amnt) as total_loan_amount
from finance_01 
group by year_of_issue_d 
order by total_loan_amount desc;


# KPI 2  Grade-Subgrade wise revolution balance
select grade, sub_grade, sum(revol_bal) as total_revol_balance
from finance_01 inner join finance_2
on(finance_01.id=finance_2.id)
group by grade, sub_grade
order by grade, sub_grade;

# KPI 3  Total Payment For Verified Status Vs Non Verified Status

select verification_status, 
concat("$", format(round(sum(total_pymnt)/1000000,2),2),"M") as total_payment
from finance_01 inner join finance_2
on(finance_01.id=finance_2.id)
group by verification_status ;


#KPI 4  State Wise Last credit pull _d Wise Loan Status

select addr_state, last_credit_pull_d, loan_status
from finance_01 inner join finance_2
on(finance_01.id=finance_2.id)
group by addr_state, last_credit_pull_d, loan_status
order by last_credit_pull_d desc,  loan_status;

#KPI5  Home Ownership Vs Last Payment Date Stats.

select f1.home_ownership, sum(last_pymnt_d) as last_payment_d 
from finance_2 as f2
join finance_01 as f1 on f1.id=f2.id 
group by home_ownership 
having sum(last_pymnt_d);


#select home_ownership, last_pymnt_d, concat ('$', format(round(sum(last_pymnt_amnt)/10000, 2), 2), 'k') as total_amount
#from finance_01  inner join finance_2 on (finance_01.id=finance_2.id) group by 
# home_ownership, last_pymnt_d order by home_ownership desc , last_pymnt_d desc;


/* Term Wise Popularity */
select term, sum(loan_amnt) total_amount from finance_01
group by term;

/* Top 5 States */ 
select addr_state as state_name, count(*) as customer_count
from finance_01
group by addr_state
order by customer_count desc
limit 5;


select * from finance_01 ;
select * from finance_2 ;
