create table hrdata
(
	emp_no int8 PRIMARY KEY,
	gender varchar(50) NOT NULL,
	marital_status varchar(50),
	age_band varchar(50),
	age int8,
	department varchar(50),
	education varchar(50),
	education_field varchar(50),
	job_role varchar(50),
	business_travel varchar(50),
	employee_count int8,
	attrition varchar(50),
	attrition_label varchar(50),
	job_satisfaction int8,
	active_employee int8
)

select * from hrdata

#####if the above method without query to import not works use below mentioned query:#####
---->>>>copy hrdata from 'C:\Users\rohit\Downloads\hrdata.csv' delimiter ',' csv header;

%%%%%functional validity with powerbi report/tableau report%%%%%

q1.what is total employee count?(should be 1470)

select sum(employee_count) from hrdata

q2.Employee count based question with application of filters i.e where clause.
select sum(employee_count) from hrdata
where education='High School'

select sum(employee_count) as emp_sales from hrdata
where department ='Sales'

select sum(employee_count) as emp_med from hrdata
where education_field ='Medical'

Q3.Attrition based questions
--where attrition = 'Yes' and education ='Doctoral Degree'
SELECT COUNT(attrition) from hrdata
where attrition = 'Yes' and education ='Doctoral Degree'


--where attrition = 'Yes' and Dept ='sales'
SELECT COUNT(attrition) from hrdata
where attrition = 'Yes' and department ='sales'

--where attrition = 'Yes' and Dept is r&d and field is medical---
SELECT COUNT(attrition) from hrdata
WHERE attrition = 'Yes' and department ='R&D' AND education_field = 'Medical'

Q4.find out attrition rate.

select ((select count(attrition) from hrdata where attrition ='Yes')/sum(employee_count))*100 from hrdata

Q5.Round off attrition rate.

select round(((select count(attrition) from hrdata where attrition ='Yes')/sum(employee_count))*100,2) 
from hrdata
---ROUND((),digits to round off)-for rounding off to decimal places

--for sales department:we have to divide by total employee in sales dept=92 so need to add dept=sales in first where clause to get right answer
select round(((select count(attrition) from hrdata where attrition ='Yes' and department ='Sales' )/sum(employee_count))*100,2) 
from hrdata
where department ='Sales'

--- FOR EDUCATION FEILD-----
select round(((select count(attrition) from hrdata where attrition ='Yes' and education ='High School' )/sum(employee_count))*100,2) 
from hrdata
where education ='High School'

Q6.Active employee based question.

--Active employee=total employee-attrited employee from company
select sum(employee_count)-(select count(attrition) from hrdata where attrition ='Yes') from hrdata

---gender filter apply gender in and out of query to find male list and then filter no of attrition in male list
select sum(employee_count)-(select count(attrition) from hrdata where attrition ='Yes'  ) 
from hrdata where gender ='Male'

--now we have to gender filter inside count as well to get male based attrition count
select sum(employee_count)-(select count(attrition) from hrdata where attrition ='Yes' and gender ='Male' ) 
from hrdata where gender ='Male'

Q7.Average age based
select avg(age) from hrdata

--round off 
select round(avg(age),0) from hrdata 


####Testing our charts####
--attrition by gender---

select gender,count(attrition) from hrdata where attrition ='Yes' and education ='High School'
group by gender
order by count(attrition) desc 

--attrition by department---

select department,count(attrition) from hrdata
where attrition = 'Yes'
group by department
order by count(attrition) desc

--percentage attrition--
---after multiplying with 100 the result is coming because we have to convert it into numeric datatype using CAST now it is in bigint type.we have to convert it into numeric------
--- intially count(attrition) was in float/bigint data type hence outcome was 0,so we converted it into numeric *100 to get into percentage----

select department,count(attrition),
round((cast(count(attrition) as numeric)/(select count(attrition) from hrdata where attrition='Yes' and gender ='Female'))*100,2) as attrition_rate
from hrdata
where attrition = 'Yes' and gender ='Female'
group by department
order by count(attrition) desc

--no of employee vs age---
select age,sum(employee_count) from hrdata 
group by age
order by age 

--EMPLOYEE VS AGE IN ANY DEPARTMENT---
select age,sum(employee_count) from hrdata where department ='R&D'
group by age
order by age


---EDUCATION WISE ATTRITION---
SELECT education_field,count(attrition) from hrdata
where attrition ='Yes'
group by education_field
order by count(attrition) desc

---EDUCATION WISE ATTRITION and department----
SELECT education_field,count(attrition) from hrdata
where attrition ='Yes' and department ='Sales'
group by education_field
order by count(attrition) desc

---Attrition rate by age group and gender---

SELECT age_band,gender,count(attrition),
(round(cast(count(attrition) as numeric)/(select count(attrition)from hrdata where attrition ='Yes')* 100,2)) as pct_attrition from hrdata
where attrition ='Yes'
group by age_band,gender
order by age_band,gender

----JOB SATISFACTION BASED---

SELECT job_role,job_satisfaction,sum(employee_count) 
	from hrdata
	group by job_role,job_satisfaction
	order by job_role,job_satisfaction

--##NOTE:we found job role vs job satifaction and employee count who have have respective ratings. we want how many have give 1,2,3,4 stars w.r.t to job role.
--for this we have to use CROSSTAB
--use of crosstab---
(basic knowledge)-
it cleans the table as per our requirement and gives result as what we want in rows/columns,w.r.t we are using groupby and order by,what should be counting,

---have to use "CREATE EXTENSION IF NOT EXISTS tablefunc;" to activate crosstab in postgresql
CREATE EXTENSION IF NOT EXISTS tablefunc;


select *
FROM CROSSTAB(
	'SELECT job_role,job_satisfaction,sum(employee_count) 
	from hrdata
	group by job_role,job_satisfaction
	order by job_role,job_satisfaction'
					   ) as CT(job_role varchar(50), one numeric, two numeric, three numeric, four numeric)
ORDER BY job_role;

---age and gender wise employee count---
select age_band,gender,sum(employee_count) from hrdata
group by age_band,gender
order by age_band,gender desc
					  
					   
