use hr;

select employee_id, salary, department_id from employees order by department_id;
select * from employees;
select * from locations;
select * from departments;
select * from regions;
select * from job_history;
select * from countries;
select * from jobs;

--1. Write a SQL query to find the total salary of employees who is in Tokyo excluding whose first name is Nancy
select sum(salary) from employees e INNER JOIN departments d ON e.department_id = d.department_id INNER JOIN locations l ON d.location_id = l.location_id where l.city='Toronto' AND e.first_name != 'Nancy' ORDER BY l.location_id;

--2. Fetch all details of employees who has salary more than the avg salary by each department.
select * from employees e1 INNER JOIN departments d ON e1.department_id = d.department_id where salary > (select avg(salary) from employees e2 where e2.department_id = e1.department_id);

--3. Write a SQL query to find the number of employees and its location whose salary is greater than or equal to 7000 and less than 10000
select count(employee_id) as COUNT_OF_EMPLOYEES, l.city from employees e INNER JOIN departments d ON e.department_id = d.department_id INNER JOIN locations l on d.location_id = l.location_id where e.salary>=7000 AND e.salary<10000 group by l.city;

--4.	Fetch max salary, min salary and avg salary by job and department. 
--Info:  grouped by department id and job id ordered by department id and max salary
select job_id, department_id, max(salary), min(salary), avg(salary) from employees GROUP BY department_id, job_id ORDER BY department_id, max(salary);

--5.	Write a SQL query to find the total salary of employees whose country_id is ‘US’ excluding whose first name is Nancy  
select sum(salary) from employees e INNER JOIN departments d ON e.department_id = d.department_id INNER JOIN locations l ON d.location_id = l.location_id where first_name!='Nancy' AND l.country_id='US';

--6.	Fetch max salary, min salary and avg salary by job id and department id but only for folks who worked in more than one role(job) in a department.
--select count(employee_id) as count_emp_id, department_id from job_history group by department_id, employee_id having count_emp_id>1;
select job_id, department_id, max(salary), min(salary), avg(salary) from employee INNER JOIN (select employee_id, count(employee_id) as count_emp_id from job_history group by department_id, employee_id having count_emp_id>1) as e ON e.employee_id = employee.employee_id group by job_id, department_id order by department_id;

alter table employees modify column department_id  varchar(10);
--7.	Display the employee count in each department and also in the same result.  
-- Info: * the total employee count categorized as "Total"
-- •	the null department count categorized as "-" *
select department_id, count(employee_id) from employees group by department_id having department_id IS NOT null union;
select "total", count(*) from employees union
select "-", count(*) from employees where department_id=null; 

-- 8.	Display the jobs held and the employee count. 
-- Hint: every employee is part of at least 1 job 
-- Hint: use the previous questions answer
-- Sample
-- JobsHeld EmpCount
-- 1	100
-- 2	4
-- select employee_id, count(*) as jobs_held from (select employee_id, job_id from employees union all select employee_id, job_id from job_history order by employee_id) group by employee_id;

select j.jobs_held, count(employee_id) from (select e.employee_id, count(*) as jobs_held from (select employee_id, job_id from employees union all select employee_id, job_id from job_history order by employee_id) as e group by e.employee_id) as j group by jobs_held order by jobs_held;

-- 9.  Display average salary by department and country.
select e.department_id, l.country_id, avg(salary) from employees e INNER JOIN departments d on e.department_id = d.department_id INNER JOIN locations l on d.location_id = l.location_id group by e.department_id, l.country_id order by e.department_id;

--10.	Display manager names and the number of employees reporting to them by countries (each employee works for only one department, and each department belongs to a country)
select e.employee_id as manager_id, e.first_name as manager_name, l.country_id, c.country_name from employees e INNER JOIN departments d ON e.department_id = d.department_id INNER JOIN locations l ON l.location_id = d.location_id INNER JOIN countries c on l.country_id = c.country_id group by e.employee_id, e.first_name, l.country_id, c.country_name order by e.employee_id;

--11.  Group salaries of employees in 4 buckets eg: 0-10000, 10000-20000,.. (Like the previous question) but now group by department and categorize it like below.
-- Eg : 
-- DEPT ID 0-10000 10000-20000
-- 50          2               10
-- 60          6                5
select department_id, count(case when salary between 0 and 10000 then 1 end) as "0-10000", count(case when salary between 10001 and 20000 then 1 end) as "10000-20000",
count(case when salary between 20001 and 30000 then 1 end) as "20000-30000" from employee group by department_id order by department_id;

--12.  Display employee count by country and the avg salary 
-- Eg : 
-- Emp Count       Country        Avg Salary
-- 10                     Germany      34242.8
select count(e.employee_id), l.country_id, c.country_name, avg(salary) from employees e INNER JOIN departments d ON d.department_id = e.department_id INNER JOIN locations l ON l.location_id = d.location_id INNER JOIN countries c ON l.country_id = c.country_id group by l.country_id, c.country_name order by avg(salary);

--13. Display region and the number of employees by department
-- Eg : 
-- Dept ID   America   Europe  Asia
-- 10            22               -            -
-- 40             -                 34         -
-- (Please put "-" instead of leaving it NULL or Empty)
select e.department_id, r.region_name, count(e.employee_id) as total_employees from employees e INNER JOIN departments d ON e.department_id = d.department_id INNER JOIN locations l ON l.location_id = d.location_id INNER JOIN countries c ON c.country_id = l.country_id INNER JOIN regions r ON r.region_id = c.region_id group by e.department_id, r.region_name order by e.department_id;

--14.  Select the list of all employees who work either for one or more departments or have not yet joined / allocated to any department
select e.employee_id, concat(e.first_name, ' ', e.last_name) as name, d.department_id, d.department_name from employees e LEFT JOIN departments d ON e.department_id = d.department_id order by e.employee_id, d.department_id; 

--15.	write a SQL query to find the employees and their respective managers. Return the first name, last name of the employees and their managers
select e1.employee_id, e1.first_name as employee_name, m.manager_id as manager_id, m.first_name as manager_name from employees e1 LEFT JOIN employees m ON e1.employee_id=m.employee_id order by e1.first_name;

--16.	write a SQL query to display the artment name, city, and state province for each department.
select d.department_name, l.city, l.state_province from departments d INNER JOIN locations l ON d.location_id = l.location_id;

--17.	write a SQL query to list the employees (first_name , last_name, department_name) who belong to a department or don't
select e.first_name, e.last_name, d.department_name from employees e LEFT JOIN departments d ON e.department_id = d.department_id;

--18.	The HR decides to make an analysis of the employees working in every department. Help him to determine the salary given in average per department and the total number of employees working in a department.  List the above along with the department id, department name
select e.department_id, d.department_name, count(e.employee_id) as total_no_of_employees, avg(e.salary) from employees e INNER JOIN departments d ON e.department_id = d.department_id group by e.department_id, d.department_name order by e.department_id;

--19.	Write a SQL query to combine each row of the employees with each row of the jobs to obtain a consolidated results. (i.e.) Obtain every possible combination of rows from the employees and the jobs relation.
select * from employees CROSS JOIN jobs;

--20.   Write a query to display first_name, last_name, and email of employees who are from Europe and Asia
select e.first_name, e.last_name, e.email, r.region_name 
from employees e 
INNER JOIN departments d 
ON e.department_id = d.department_id 
INNER JOIN locations l 
ON d.location_id = l.location_id 
INNER JOIN countries c 
ON l.country_id = c.country_id 
INNER JOIN regions r 
ON c.region_id = r.region_id 
where r.region_name='Europe' OR r.region_name='Asia';

--21.   Write a query to display full name with alias as FULL_NAME (Eg: first_name = 'John' and last_name='Henry' - full_name = "John Henry") who are from oxford city and their second last character of their last name is 'e' and are not from finance and shipping department.
select concat(e.first_name, ' ', e.last_name) as FULL_NAME, l.city, d.department_name from employees e INNER JOIN departments d ON e.department_id = d.department_id INNER JOIN locations l ON d.location_id = l.location_id where l.city='Oxford' AND e.last_name LIKE '%e_' AND d.department_name NOT IN ('Shipping','Finance');

--22.   Display the first name and phone number of employees who have less than 50 months of experience
select * from employees e INNER JOIN job_history j ON e.employee_id = j.employee_id where datediff(month, start_date, end_date) < 50;

--23.   Display Employee id, first_name, last name, hire_date and salary for employees who has the highest salary for each hiring year. (For eg: John and Deepika joined on year 2023,  and john has a salary of 5000, and Deepika has a salary of 6500. Output should show Deepika’s details only).
select employee_id, first_name, last_name, hire_date, salary from employees where (YEAR(hire_date), salary) IN (select hire_year, max(salary) from (select YEAR(hire_date) as hire_year, salary from employee) group by hire_year) order by hire_date;


(select YEAR(hire_date) as hire_year, sum(salary) from employee group by hire_year order by hire_year) 