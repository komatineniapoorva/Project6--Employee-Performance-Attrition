select * from employee_data
select * from Datasetoverview
select * from employee_survey_data

--Retreving columns from all tables
select column_name from information_schema.columns where table_name='employeedata'
select column_name from information_schema.columns where table_name='employee_survey_data'
select column_name from information_schema.columns where table_name='manager_survey_data'

--checkng for missing values
select * from employee_data where age is null 
--setting primary key column
alter table employee_data add constraint pk_employeeid primary key (employeeid)
--alter table employee_data drop constraint pk_reportnumber
--
Alter table employee_data drop column over18
alter table employee_data alter column gender varchar(8)
alter table employee_data alter column maritalstatus varchar(10)
alter table employee_data alter column educationfield nvarchar(30)


-- Employee Data Analysis:
-- Counting the number of employees in the dataset
select count(employeeID) from employee_data

-- Calculating the average age of employees
select avg(age) as "avg age" from employee_data

-- Counting the number of employees who have left the company
select count(employeeID) from employee_data where Attrition =1

-- Calculating the percentage of employees who have left
--select count(employeeID)*100/4410  from employee_data where Attrition =1
select count(employeeID) * 100 / (select count(*) FROM employee_data) AS PercentageLeft from employee_data 
WHERE Attrition = 1;

-- Determining the number of distinct departments in the company
select distinct department from employee_data

--Finding different marital status
select distinct Maritalstatus from employee_data

-- Calculating the average distance from home for employees
select avg(distancefromhome) from employee_data

-- Analyzing the distribution of education levels among employees
select distinct education from employee_Data

--Different education fields available in data
select distinct(educationfield) from employee_data

-- Counting the number of employees in each education field
select education,count(employeeID) as "no of employees" from employee_data 
group by education
order by "no of employees"

-- Calculating the average monthly income of employees
select avg(monthlyincome) from employee_data

-- Counting the number of employees who have worked for more than one company
select count(employeeid) from employee_data where numcompaniesworked >=1

-- Calculating the average percent salary hike for employees
select avg(percentsalaryhike) from employee_data


-- Counting the number of employees with a performance rating of "Outstanding"
select count(e.employeeID) from employee_data e
join employee_survey_data es 
on e.EmployeeID=es.EmployeeID
where es.performancerating='Outstanding'

-- Calculating the average number of years employees have worked at the company
select avg(yearsatcompany) from employee_data

-- Counting the number of employees who have received training more than once last year
select count(distinct employeeID) from employee_data where TrainingTimesLastYear>1

-- Calculating the average work-life balance level among employees
select count(employeeID) from employee_survey_data where WorkLifeBalance='Good'

-- Counting the number of employees in each job role
select count(distinct EmployeeID) as "no of employees",jobRole from employee_data 
Group by jobRole
Order by count(distinct EmployeeID) desc

-- Analyzing the distribution of genders among employees
select count(distinct EmployeeID),Gender from employee_data
group by Gender

-- Calculating the average stock option level among employees
select avg(stockoptionlevel) from employee_data 

-- Counting the number of employees who have spent more than 5 years with the current manager
select count(distinct EmployeeID) from employee_data where YearsWithCurrManager>5

-- Find the number of employees who have received a promotion in the last year.
select count(employeeid) from employee_data where YearsSinceLastPromotion<=1

--Calculate the average percentage salary hike for employees
select avg(percentsalaryhike) from employee_data

-- Employee Survey Data Analysis:

-- Calculating the average environment satisfaction level among employees
select * from employee_survey_data where environmentsatisfaction='Medium'

-- Calculating the average job satisfaction level among employees
select * from employee_survey_data where JobSatisfaction='Medium'

-- Calculating the average work-life balance level among employees
select * from employee_survey_data where worklifebalance='Good'

--Comparative Analysis:

--Is there a difference in job satisfaction between employees who have left and those who have stayed?

--Is there a difference in performance ratings between different departments?
select count(e.EmployeeID),e.department,es.performancerating from employee_data e join employee_survey_data es
on e.EmployeeID=es.EmployeeID
Group by e.department,es.performancerating

--Is there a difference in work-life balance between different job roles?
select es.WorkLifeBalance ,e.jobrole from employee_data e
join employee_survey_data es
on e.EmployeeID=es.EmployeeID
Group by e.jobrole,es.WorkLifeBalance

-- Exploring education distribution by department
select count(employeeID),Education,Department from employee_data 
Group by Education,Department

-- Finding the highest-paid employees
Select Top 10 * from employee_data
Order by MonthlyIncome desc

-- Assessing training frequency by job role
select avg(TrainingTimesLastYear),jobrole from employee_data
Group by JobRole

--avg salary by education
select Education, AVG(MonthlyIncome) AS AvgSalary from employee_data
group by Education;

--Identify employees who have been with the company for more than 10 years,
--have a job level of 4 or higher, and have not received a promotion in the last 5 years.
select * from employee_data where YearsAtCompany>10 and JobLevel>=4 and YearsSinceLastPromotion>5

-- Analyzing average income for experienced Bachelor's degree holders in Sales
select avg(monthlyincome) from employee_data where Department='sales' and Education='Graduate' and YearsAtCompany>5

-- 3. Determine the percentage of employees who have had more than 3 companies of work experience and are currently in a job role with a stock option level of 3 or higher.
-- Finding the proportion of employees with diverse work experience and high stock option levels

-- Identifying the department with the most satisfied employees
select Top 2 count(e.EmployeeID), e.department,es.jobsatisfaction from employee_data e 
join employee_survey_data es 
on e.employeeid=es.employeeid
where es.jobsatisfaction='Very High'
Group by e.department,es.jobsatisfaction 
order by count(e.EmployeeID) desc

-- Identify employees whose monthly income is above the average monthly income of employees
--in their department
select * from employee_data e 
join employee_data d
on e.EmployeeID=d.EmployeeID
where e.MonthlyIncome>(select avg(d.MonthlyIncome) from employee_data d) and e.Department=d.Department

 --Find the employee(s) with the highest monthly income.
 select * from employee_data where MonthlyIncome=(select max(monthlyincome) from employee_data)

-- Find employees who have the same job role as the employee with EmployeeID 100.
select * from employee_data where JobRole=(select JobRole from employee_data where EmployeeID=100)

-- Calculate the percentage of employees who have left the company.
select count(*)*100/(select count(*) from employee_data) from employee_data where Attrition=1

--What is the distribution of attrition across different departments?
select count(*)*100/(select count(*) from employee_data),department from employee_data where Attrition=1
Group by department

--Male and Female Married Employees under Attrition with No Promotion in the Last 2 Years
select * from employee_data where MaritalStatus='Married' and Attrition=1 and YearsSinceLastPromotion>=2

-- Employees with Maximum and Minimum Percentage Salary Hike
select count(employeeID) ,max(percentsalaryhike) as maxsalary,min(PercentSalaryHike)
as minsalary from employee_data
Group by count(*)
having MonthlyIncome=max(percentsalaryhike) or MonthlyIncome=min(PercentSalaryHike)

--mployees Working Overtime with Minimum Salary Hike (>5 years)
select * from employee_data where percentsalaryhike=(select min(percentsalaryhike) from employee_data) and StandardHours=8

-- Employees Working Overtime with Maximum Salary Hike (<5 years)
select * from employee_data where percentsalaryhike=(select max(percentsalaryhike) from employee_data) and StandardHours=8

-- Employees without Overtime with Maximum Salary Hike (<5 years)
select * from employee_data where percentsalaryhike=(select max(percentsalaryhike) from employee_data) and StandardHours=8

--employees leaving the company by department
select count(employeeid),Department from employee_data where attrition=1
Group by Department

--Atrrtition by age
select count(employeeid),Age from employee_data where attrition=1
Group by Age

--Attrtiton by frequency of travel
--Atrrtition by age
select count(employeeid),BusinessTravel from employee_data where attrition=1
Group by businesstravel

 ⁠--List the top 3 departments with the highest salary and less attrition
select TOP 3 * from employee_data where Monthlyincome=(select max(Monthlyincome) from employee_data) and attrition=0

--Views:
--using views we can virtual table not physical table,we can encapsulate the main table,store it without showing the original data,store complex logic in view,
--can access only required data by view
-- 1.Create a view here the employee's monthly income is above the departmental average, and the job satisfaction level is 'Very High' or 'Excellent' 

create view HighJobSatisfactionEmployees as
select e.employeeid,e.jobrole,e.monthlyincome,es.jobsatisfaction,es.worklifebalance from employee_data e
inner join employee_survey_data es
on e.employeeid=es.employeeid
where e.monthlyincome>(select avg(monthlyincome) from employee_data where department=e.department) and es.jobsatisfaction='Very High'

--2. Create a view to display employees who have received a performance rating of 'Outstanding' and have a monthly income above the departmental average.

Create view TopPerformingEmployees as
select e.employeeid,e.jobrole,e.monthlyincome,es.PerformanceRating from employee_data e 
inner join employee_survey_data es
on e.employeeid=es.employeeid
 where e.Monthlyincome>(select avg(monthlyincome) from employee_data where department=department) AND es.performancerating='Outstanding'


--3. Create a view to show employees who have been with the company for more than 10 years and have a job role of 'Senior Manager' or 'Director', and also have a performance rating of 'Outstanding'

create view LongServingEmployees as 
select e.employeeid,e.jobrole,e.yearsatcompany from employee_data e
where es.performancerating='Outstanding' AND e.yearsatcompany>5

--Alter the "LongServingEmployees" view to include only employees who have been with the company for more than 10 years and have a job role of 'Senior Manager' or 'Director', and also have a performance rating of 'Outstanding'.

alter view LongServingEmployees as 
select e.employeeid,e.jobrole,e.yearsatcompany,es.performancerating from employee_data e
inner join employee_survey_data es
on e.employeeid=es.employeeid
where (e.JobRole like '%Manager%' or e.JobRole like '%Director%') AND e.yearsatcompany>5 AND es.performancerating='Outstanding'

--4. Create a view to display the count of unique job roles in each department.
create view Jobroledivision as
select count(distinct jobrole) as jobroles,department from employee_data
Group by Department

--renaming the view:
exec sp_rename 'Jobroledivision','jobrolediversity'

--Dropping the Jobrole Division view
drop view jobroledivision

--To execute a view:
select * from HighJobSatisfactionEmployees
select * from TopPerformingEmployees
select * from LongServingEmployees
select * from jobrolediversity


--Window Functions or Rank Functions
--1.Rownumber:
select *, row_number() over(order by monthlyincome) as rownumber from TopPerformingEmployees
select *, row_number() over(partition by jobrole order by monthlyincome) as rownumber from TopPerformingEmployees

--2.Rank function:it skips the number for similar values
select *, rank() over(order by yearsatcompany) as rank from LongServingEmployees
select *, rank() over(partition by jobrole order by yearsatcompany) as rank from LongServingEmployees

--3.Dense Rank:
select *,dense_rank() over(order by jobsatisfaction) as denserank from HighJobSatisfactionEmployees
select *,dense_rank() over(partition by jobrole order by jobsatisfaction) as denserank from HighJobSatisfactionEmployees

--4.NTile
select *, Ntile(4) over(order by jobsatisfaction) as ntile from HighJobSatisfactionEmployees


--Stored Procedures:
-- Create a stored procedure to analyze employee attrition trends, calculating attrition rates for each department and 
--identifying factors contributing to attrition, such as job satisfaction levels, distance from home, and years with current manager.
create procedure employeeAttritionAnalysis as
begin
select e.employeeid,e.department,es.jobsatisfaction from employee_data e
inner join employee_survey_data es
on e.employeeid=es.employeeid
where Attrition=1
Group by e.employeeid,e.department,es.jobsatisfaction
End

--To execute or call stored procedure
exec employeeAttritionAnalysis


--Write a stored procedure to generate a report on employee performance, including details such as job role, monthly income, performance rating, and work-life balance level for employees with a performance rating of 'Outstanding' or 'Excellent'.

create procedure excellentemployee
as 
begin
select e.employeeid,e.jobrole,e.monthlyincome,es.performancerating,es.worklifebalance from employeee_data e
inner join
employee_survey_data es
on e.employeeid=es.employeeid
where es.performancerating='Outstanding'
end

-- Develop a stored procedure that takes department ID and job role as input parameters and returns a list of employees who belong to that department and 
--have the specified job role with monthlyincome more than 75000
create procedure Getemployee @department as varchar(50),@jobrole as varchar(50),@monthlyincome as int as 
begin 
select * from employee_data where department=@department and jobrole=@jobrole and monthlyincome>@monthlyincome
end

--execution
exec Getemployee 'sales','Sales Executive',85000

--Write a stored procedure named "CalculateNewSalaryWithHikeById" that takes an employee ID and a
--percentage hike as input parameters. The procedure should retrieve the employee's current salary from the database
ALTER PROCEDURE CalculateNewSalaryWithHikeById
    @employeeid INT,@percenthike INT, @currentsalary INT,@newsalary INT OUTPUT
AS
BEGIN
    -- Select employee information
    SELECT  employeeid, @currentsalary AS current_salary, jobrole, department,@newsalary FROM employee_data 
    WHERE employeeid = @employeeid
    -- Calculate new salary with hike
    SET @newsalary = @currentsalary * (1 + @percenthike / 100)
END

--Execute
exec CalculateNewSalaryWithHikeById 100,10,50000
