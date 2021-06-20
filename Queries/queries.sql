--Initial Queries for analysis
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';
-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1952-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Prep for export
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Verify data in new table
SELECT * FROM retirement_info;
-- Drop current retirement_info table
DROP TABLE retirement_info;

-- Recreate retirement_info table with emp_no
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table to verify data
select * from retirement_info;

-- Testing joins using departments and dept_manager tables
SELECT departments.dept_name,
	dept_manager.emp_no,
	dept_manager.from_date,
	dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Updating departments and dept_manager table join using aliases
SELECT d.dept_name,
	dm.emp_no,
	dm.from_date,
	dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;


-- Join new retirement_info table with dept_emp table to segregate by department
SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- Recreating join with aliases
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

-- Current employees
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Verify data in current employees
SELECT * FROM current_emp;

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO dept_retirement
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Reviewing salaries data
select * from salaries;

select * from salaries
order by to_date DESC;

-- creating base of new query
select emp_no, first_name, last_name, gender
into emp_info
from employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

drop table emp_info;

-- joining new table with salary info
select e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
into emp_info
from employees as e
inner join salaries as s
on (e.emp_no = s.emp_no)
inner join dept_emp as de
on (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
select ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
into dept_info
from current_emp as ce
inner join dept_emp as de
on (ce.emp_no = de.emp_no)
inner join departments as d
on (de.dept_no = d.dept_no);

-- skill drill sales team query
select ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
from current_emp as ce
inner join dept_emp as de
on (ce.emp_no = de.emp_no)
inner join departments as d
on (de.dept_no = d.dept_no)
where d.dept_name = 'Sales';

-- skill drill mentor program sales & development query
select ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
from current_emp as ce
inner join dept_emp as de
on (ce.emp_no = de.emp_no)
inner join departments as d
on (de.dept_no = d.dept_no)
where d.dept_name = 'Sales' or d.dept_name = 'Development';

-- Challenge query Deliverable 1 Step 1 - Find retiring employees
select e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
into retirement_titles
from employees as e
inner join titles as t
on (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
order by (e.emp_no);

-- Challenge query Deliverable 1 Step 2 - Remove duplicates keeping last title
-- Use Distinct with Orderby to remove duplicate rows.
SELECT DISTINCT ON (emp_no) emp_no,
	first_name,
	last_name,
	title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

select * from unique_titles;

-- Challenge query delivery 1 Step 3 - Titles
select count(title),
	title
into retiring_titles
from unique_titles
group by title
order by count(title) desc;

select sum(count) from retiring_titles;

-- Challenge query Deliverable 2 Step 1 - Create the Mentorship Eligibility table

select distinct on (e.emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	ti.title
INTO mentorship_eligibility
from employees as e
left join dept_emp as de
on (e.emp_no = de.emp_no)
left join titles as ti
on (e.emp_no = ti.emp_no)
where (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
and (de.to_date = '9999-01-01')
order by e.emp_no, to_date desc;

select * from unique_titles;
select * from mentorship_eligibility;
select * from dept_retirement;
select * from departments;
select * from current_emp;

-- Employee count by department number updated from unique_titles
SELECT COUNT(ut.emp_no), de.dept_no, d.dept_name
FROM unique_titles as ut
LEFT JOIN dept_emp as de
ON ut.emp_no = de.emp_no
LEFT JOIN departments as d
ON (de.dept_no = d.dept_no)
GROUP BY de.dept_no, d.dept_name
ORDER BY de.dept_no;

-- Employee count by department number updated from mentorship_eligibility
SELECT COUNT(ut.emp_no), de.dept_no, d.dept_name
FROM mentorship_eligibility as ut
LEFT JOIN dept_emp as de
ON ut.emp_no = de.emp_no
LEFT JOIN departments as d
ON (de.dept_no = d.dept_no)
GROUP BY de.dept_no, d.dept_name
ORDER BY de.dept_no;

-- Title count by department number updated from unique_titles
SELECT COUNT(ut.title), ut.title, de.dept_no, d.dept_name
FROM unique_titles as ut
LEFT JOIN dept_emp as de
ON ut.emp_no = de.emp_no
LEFT JOIN departments as d
ON (de.dept_no = d.dept_no)
GROUP BY de.dept_no, ut.title, d.dept_name
ORDER BY de.dept_no, ut.title;

-- Expected first year retirement
SELECT COUNT(ut.emp_no), de.dept_no, d.dept_name
FROM unique_titles as ut
LEFT JOIN dept_emp as de
ON ut.emp_no = de.emp_no
LEFT JOIN departments as d
ON (de.dept_no = d.dept_no)
LEFT JOIN employees as e
ON (ut.emp_no = e.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1952-12-31')
GROUP BY de.dept_no, d.dept_name
ORDER BY de.dept_no;

SELECT COUNT(ut.emp_no)
FROM unique_titles as ut
LEFT JOIN employees as e
ON (ut.emp_no = e.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1952-12-31');