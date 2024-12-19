USE employees;

-- Soru 1: 1 Ocak 2000'den sonra işe alınan çalışanların adları ve işe giriş tarihleri
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date > '2000-01-01';

-- Soru 2: 'S' harfiyle başlayan departman isimleri
SELECT dept_name
FROM departments
WHERE dept_name LIKE 'S%';

-- Soru 3: Maaşı 80,000'den büyük olan çalışanlar
SELECT emp_no, salary, from_date
FROM salaries
WHERE salary > 80000;

-- Soru 4: Her unvan için çalışan sayısı
SELECT title, COUNT(*) AS employee_count
FROM titles
GROUP BY title
ORDER BY employee_count DESC;

-- Soru 5: Her departmanın numarası ve ortalama maaşı
SELECT d.dept_no, AVG(s.salary) AS avg_salary
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no
JOIN salaries s ON de.emp_no = s.emp_no
GROUP BY d.dept_no
ORDER BY d.dept_no;



-- Soru 6: 'Sales' departmanındaki çalışanların adları
SELECT e.first_name, e.last_name, d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales';

-- Soru 7: Çalışanlar ve yöneticilerinin adları
SELECT e.first_name AS employee_first_name, e.last_name AS employee_last_name,
       m.first_name AS manager_first_name, m.last_name AS manager_last_name
FROM employees e
JOIN dept_manager dm ON e.emp_no = dm.emp_no
JOIN employees m ON dm.emp_no = m.emp_no;

-- Soru 8: Ortalama maaştan yüksek maaş alan çalışanlar
SELECT emp_no, salary
FROM salaries
WHERE salary > (SELECT AVG(salary) FROM salaries);

-- Soru 9: 'Sales' veya 'Marketing' departmanlarındaki çalışanlar
SELECT e.emp_no
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales'
UNION
SELECT e.emp_no
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Marketing';

-- Soru 10: Hiçbir departmanda çalışmamış çalışanlar
SELECT e.first_name, e.last_name
FROM employees e
LEFT JOIN dept_emp de ON e.emp_no = de.emp_no
WHERE de.dept_no IS NULL;


-- Soru 11: Bölüm ortalama maaşından fazla kazanan çalışanlar
SELECT e.emp_no, s.salary, d.dept_name
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE s.salary > (
    SELECT AVG(s2.salary)
    FROM salaries s2
    JOIN dept_emp de2 ON s2.emp_no = de2.emp_no
    WHERE de2.dept_no = d.dept_no
);

-- Soru 12: 'Manager' unvanına sahip ve kendi bölümünde en yüksek maaşı alan çalışanlar
SELECT e.first_name, e.last_name
FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
JOIN salaries s ON e.emp_no = s.emp_no
JOIN dept_emp de ON e.emp_no = de.emp_no
WHERE t.title = 'Manager'
  AND s.salary = (
      SELECT MAX(s2.salary)
      FROM salaries s2
      JOIN dept_emp de2 ON s2.emp_no = de2.emp_no
      WHERE de2.dept_no = de.dept_no
);

-- Soru 13: Ortalama maaşı 70,000'den fazla olan bölümler
SELECT d.dept_name
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no
JOIN salaries s ON de.emp_no = s.emp_no
GROUP BY d.dept_no, d.dept_name
HAVING AVG(s.salary) > 70000;

-- Soru 14: Bölüm "d005"'in maksimum maaşından fazla kazanan çalışanlar
SELECT e.emp_no, t.title
FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.salary > (
    SELECT MAX(s2.salary)
    FROM salaries s2
    JOIN dept_emp de2 ON s2.emp_no = de2.emp_no
    WHERE de2.dept_no = 'd005'
);

-- Soru 15: Birden fazla bölümde çalışmış olan çalışanlar
SELECT de.emp_no
FROM dept_emp de
GROUP BY de.emp_no
HAVING COUNT(DISTINCT de.dept_no) > 1;



DROP VIEW IF EXISTS high_salary_employees;

CREATE VIEW high_salary_employees AS
SELECT e.emp_no, e.first_name, e.last_name, s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.salary > 100000;

SELECT *
FROM high_salary_employees;

-- Soru 17: 'Development' departmanındaki yüksek maaşlı çalışanlar
SELECT h.emp_no, h.first_name, h.last_name, h.salary
FROM high_salary_employees h
JOIN dept_emp de ON h.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Development';

-- Soru 18: Her departmanın ortalama maaşı için bir görünüm
DROP VIEW IF EXISTS dept_avg_salary;

CREATE VIEW dept_avg_salary AS
SELECT d.dept_no, d.dept_name, AVG(s.salary) AS avg_salary
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no
JOIN salaries s ON de.emp_no = s.emp_no
GROUP BY d.dept_no, d.dept_name;

SELECT *
FROM dept_avg_salary;

-- Soru 19: Ortalama maaşı 90,000'den fazla olan departmanlar
SELECT dept_name
FROM dept_avg_salary
WHERE avg_salary > 90000;

SELECT e.first_name, e.last_name, s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
ORDER BY s.salary DESC
LIMIT 5;
