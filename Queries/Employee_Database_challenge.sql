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

-- Challenge query delivery 1 Step 3 - Titles
select count(title),
	title
into retiring_titles
from unique_titles
group by title
order by count(title) desc;