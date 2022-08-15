-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
	dept_no VARCHAR(4) NOT NULL, 
	dept_name VARCHAR(40) NOT NULL, 
	PRIMARY KEY (dept_no), 
	UNIQUE (dept_name)
);

CREATE TABLE employees (
	emp_no INT NOT NULL, 
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL, 
	to_date DATE NOT NULL,
	
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no)
);

CREATE TABLE titles(
	emp_no INT NOT NULL,
	title VARCHAR(100) NOT NULL, 
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (emp_no) REFERENCES salaries (emp_no)
);

SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND  '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- CREATE NEW TABLES

SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND  '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

Select * From retirement_info;

DROP TABLE retirement_info;

-- Table joins 

SELECT departments.dept_name, dept_manager.emp_no, dept_manager.from_date, dept_manager.to_date
from departments
inner join dept_manager
ON departments.dept_no = dept_manager.dept_no;

Select retirement_info.emp_no, retirement_info.first_name, retirement_info.last_name,dept_emp.to_date
from retirement_info 
left join dept_emp
on retirement_info.emp_no = dept_emp.emp_no;

select re.emp_no, re.first_name, re.last_name, de.to_date
into current_emp
from retirement_info as re
left join dept_emp as de
on re.emp_no = de.emp_no
where de.to_date = ('9999-01-01')

-- count by group by (pivot table stuff)
-- employee count by number
select count(ce.emp_no), de.dept_no
Into retiring_employees
from current_emp as ce
left join dept_emp as de
on ce.emp_no = de.emp_no
group by de.dept_no
order by de.dept_no;

select e.emp_no, e.first_name, e.last_name, e.gender, s.salary, de.to_date
into emp_info
from employees as e
inner join salaries as s
on e.emp_no = s.emp_no
Inner join dept_emp as de
on e.emp_no = de.emp_no
where (e.birth_date between '1952-01-01' and '1955-12-31')
	and (e.hire_date between '1985-01-01' and '1988-12-31');

select dm.dept_no, d.dept_name, dm.emp_no, ce.last_name, ce.first_name, dm.from_date, dm.to_date
into manager_info
from dept_manager as dm
	Inner join departments as d
		on (dm.dept_no = d.dept_no)
	Inner Join current_emp as ce
		on (dm.emp_no = ce.emp_no);

select ce.emp_no, ce.first_name, ce.last_name, d.dept_name
into dept_info
from current_emp as ce
inner join dept_emp as de
on (ce.emp_no = de.emp_no)
inner join departments as d
on (de.dept_no = d.dept_no);



