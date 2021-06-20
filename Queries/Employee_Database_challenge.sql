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