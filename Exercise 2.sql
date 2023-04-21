use hr;

select * from employees;
truncate table employees;
select * from locations;
--1.	Write a SQL query to remove the details of an employee whose first name ends in ‘even’
delete from employees where first_name LIKE '%even';

--2.	Write a query in SQL to show the three minimum values of the salary from the table.
select DISTINCT salary, first_name, last_name from employees order by salary LIMIT 3;

--3.	Write a SQL query to remove the employees table from the database
drop table employees;

--4.	Write a SQL query to copy the details of this table into a new table with table name as Employee table and to delete the records in employees table
drop table employee;
CREATE TABLE Employee AS SELECT * FROM employees;
select * from Employee;

--5.	Write a SQL query to remove the column Age from the table
ALTER TABLE employees DROP age;

--6.	Obtain the list of employees (their full name, email, hire_year) where they have joined the firm before 2000
select concat(first_name, ' ', last_name) as full_name, email, YEAR(hire_date) AS hire_year from employee where YEAR(hire_date)<2000;

--7.	Fetch the employee_id and job_id of those employees whose start year lies in the range of 1990 and 1999
select employee_id, job_id,hire_date from employees where YEAR(hire_date) BETWEEN 1990 AND 1999;

--8.	Find the first occurrence of the letter 'A' in each employees Email ID Return the employee_id, email id and the letter position
select employee_id, email, charindex('A', email) as letter_position from Employee where position('A' IN email)!=0;

--9.	Fetch the list of employees(Employee_id, full name, email) whose full name holds characters less than 12
select employee_id, concat(first_name, ' ', last_name) as full_name, email from Employee where LENGTH(full_name) < 12;

--10.	Create a unique string by hyphenating the first name, last name , and email of the employees to obtain a new field named UNQ_ID Return the employee_id, and their corresponding UNQ_ID;
select employee_id, concat_ws('-',first_name, last_name, email) as UNQ_ID from Employee;

--11.	Write a SQL query to update the size of email column to 30
ALTER TABLE Employee MODIFY email varchar(30);
desc table employee;

--12.	Fetch all employees with their first name , email , phone (without extension part) and extension (just the extension)  Info : this mean you need to separate phone into 2 parts eg: 123.123.1234.12345 => 123.123.1234 and 12345 . first half in phone column and second half in extension column 
select first_name, email, substr(phone_number, 0, length(phone_number)- charindex('.', REVERSE(phone_number))) as phone_without_extension, substr(phone_number, length(phone_number)- charindex('.', REVERSE(phone_number), 1)+2) as phone_number_extension from employees;

--13.	Write a SQL query to find the employee with second and third maximum salary.
select first_name, last_name, salary from Employee order by salary desc LIMIT 3 OFFSET 1;

--14.   Fetch all details of top 3 highly paid employees who are in department Shipping and IT
-- select e.first_name, e.last_name, e.job_id, e.department_id, d.department_name from Employees e INNER JOIN departments d ON (e.department_id=d.department_id) AND (e.department_id=50 OR e.department_id=60) order by salary desc LIMIT 3;

select first_name, last_name, department_id, salary from employees where department_id IN (select department_id from departments where department_name IN ('Shipping', 'IT'))  order by salary DESC LIMIT 3; 

--15.   Display employee id and the positions(jobs) held by that employee (including the current position)
(select employees.employee_id, employees.job_id, jobs.job_title from employees, jobs where employees.job_id=jobs.job_id) UNION
(select job_history.employee_id, job_history.job_id, jobs.job_title from jobs, job_history where jobs.job_id=job_history.job_id) ORDER BY employee_id;

--16.	Display Employee first name and date joined as WeekDay, Month Day, Year
--Eg : 
--Emp ID      Date Joined
--1	Monday, June 21st, 1999
-- select first_name, date_format(hire_date, "%d, %b %D,%Y") as hired_day from employees;
select first_name, concat(dayname(hire_date),',',monthname(hire_date),' ', day(hire_date),decode(day(hire_date), '1','st','2','nd','3','rd',
'21','st','22','nd','23','rd','th'),', ',year(hire_date)) as hired_day from employees;

-- 17.	The company holds a new job opening for Data Engineer (DT_ENGG) with a minimum salary of 12,000 and maximum salary of 30,000 .  
-- The job position might be removed based on market trends (so, save the changes) . 
--  Later, update the maximum salary to 40,000 . 
-- Save the entries as well.
--  Now, revert back the changes to the initial state, where the salary was 30,000
ALTER session set autocommit=false;

SELECT * from jobs;
INSERT into jobs values('DT_ENG', 'Data Engineer', 12000, 30000);
COMMIT;

UPDATE jobs SET max_salary=40000 where job_id='DT_ENG';
Rollback;

ALTER session set autocommit=true;

--18.	Find the average salary of all the employees who got hired after 8th January 1996 but before 1st January 2000 and round the result to 3 decimals
select round(avg(salary),3) as AVG_SALARY from employees where hire_date > '08-JAN-1996' AND hire_date  < '01-JAN-2000';

-- 19. Display  Australia, Asia, Antarctica, Europe along with the regions in the region table (Note: Do not insert data into the table)
-- A. Display all the regions
-- B. Display all the unique regions
select region_name from regions;
select region_name from regions UNION ALL select 'Australia' UNION ALL select 'Asia' UNION ALL select 'Antartica' UNION ALL select 'Europe';
select region_name from regions UNION select 'Australia' UNION select 'Asia' UNION select 'Antartica' UNION select 'Europe';

