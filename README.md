# Pewlett-Hackard-Analysis

## Project Overview
Analyze employee hire dates to determine the number of employees of Pewlette-Hackard that are expected to retire in the near future. As part of this analysis assess the results by department and title throughout the company. 

1. Calculate the total number of employees in the expected retirement range based on date of birth
2. Count the total number of expected retirees by title
3. Determine eligible employees to participate in a mentorship program

## Resources
- Data Sources: departments.csv, dept_manager.csv, dept_emp.csv, employees.csv, salaries.csv, titles.csv
- Software: pgAdmin 4 version 5.2, PostgreSQL 11

## Results
Provide a bulleted list with four major points from the two analysis deliverables. Use images as support where needed

- There are 90,398 positions across all departments expected to retire.
- There are 1,549 people who would be eligible to participate in a mentorship program
- The two departments expecting the largest retirements include d004 Production and d005 Development
  - d004 Production is expecting 22,199 retirees
  - d005 Development is expecting 25,628 retirees
- The ratio of mentors to retirees is ~1 to 60
  - [Retirees per Department](Resources/dept_retirees.PNG)
```
SELECT COUNT(ut.emp_no), de.dept_no, d.dept_name
FROM unique_titles as ut
LEFT JOIN dept_emp as de
ON ut.emp_no = de.emp_no
LEFT JOIN departments as d
ON (de.dept_no = d.dept_no)
GROUP BY de.dept_no, d.dept_name
ORDER BY de.dept_no;
```
  - [Mentors per Department](Resources/dept_mentors.PNG)
```
SELECT COUNT(ut.emp_no), de.dept_no, d.dept_name
FROM mentorship_eligibility as ut
LEFT JOIN dept_emp as de
ON ut.emp_no = de.emp_no
LEFT JOIN departments as d
ON (de.dept_no = d.dept_no)
GROUP BY de.dept_no, d.dept_name
ORDER BY de.dept_no;
```
 - About a quarter of the positions expected to retire are Senior Engineers.
  - [Senior Engineer Retirees from Production and Development](Resources/senior_engineers.PNG)
```
SELECT COUNT(ut.title), ut.title, de.dept_no, d.dept_name
FROM unique_titles as ut
LEFT JOIN dept_emp as de
ON ut.emp_no = de.emp_no
LEFT JOIN departments as d
ON (de.dept_no = d.dept_no)
GROUP BY de.dept_no, ut.title, d.dept_name
ORDER BY de.dept_no, ut.title;
```
 - 21,209 employees were born during 1952 that are expected to be the start of the retirement wave
  - [1952 Retirees](Resources/1952_retirees.PNG)
```
SELECT COUNT(ut.emp_no)
FROM unique_titles as ut
LEFT JOIN employees as e
ON (ut.emp_no = e.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1952-12-31');
```
 - Departmental breakdown of the first wave of retirees
  - [1952 Departmental Breakdown](Resources/1952_dept.PNG)
```
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
```
## Summary
How many roles will need to be filled as the "silver tsunami" begins to make an impact?
  - The analysis shows that if everyone expected to retire in the first year does so, 21,209 people could retire with an emphasis on people in the Production and Development departments and specifically people in Senior Engineer positions.
Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees? 
  - Reviewing the total expected number of first year retirees, if each potential mentor was willing to oversee approximately 15 people each that would allow for promotions into positions that are expected to retire.

These numbers are the results of the additional queries listed above.
