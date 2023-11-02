-- Процентное соотношение уровня опыта по годам
CREATE VIEW proc_exp_year AS
SELECT 
	ds.work_year,
	ds.experience_level, 
	COUNT(ds.experience_level) AS count_exp_lvl,
	COUNT(ds.experience_level)*100/wyc.cnt AS percentage
FROM ds_salary ds
JOIN (
	SELECT 
		work_year, 
		COUNT(work_year) AS cnt 
	FROM ds_salary ds 
	GROUP BY 1) 
	AS wyc
ON ds.work_year = wyc.work_year
GROUP BY 1,2

-- Процентное соотношение Data направлений по годам
SELECT 
	ds.work_year,
	ds.job_category, 
	COUNT(ds.job_category) AS job_category_cnt,
	COUNT(ds.job_category)*100/wyc.cnt AS percentage
FROM ds_salary ds
JOIN (SELECT 
			work_year, 
			count(work_year) AS cnt 
		FROM ds_salary ds 
		GROUP BY 1) 
		AS wyc
ON ds.work_year = wyc.work_year
GROUP BY 1,2

--- за весь период
SELECT 
	ds.job_category, 
	COUNT(ds.job_category) AS job_category_cnt,
	COUNT(ds.job_category)*100/cnt_all.cnt_all AS percentage
FROM ds_salary ds
JOIN (SELECT 
			COUNT(*) as cnt_all 
		FROM ds_salary ds) 
		AS cnt_all
GROUP BY 1

-- Выборка по годам
SELECT
	work_year ,
	COUNT(work_year) AS cnt
FROM ds_salary ds
GROUP BY 1

-- Максимальные зарплаты в направлениях по годам
SELECT 
	ds.work_year,
	ds.job_category,
	ds.job_title,
	MAX(salary_in_usd) AS max_s
FROM ds_salary ds
GROUP BY 1,2
ORDER BY 1,4

-- Средние зарплаты в направлениях по годам
SELECT 
	ds.work_year,
	ds.job_category,
	ds.job_title,
	ROUND(AVG(salary_in_usd)) AS avg_s
FROM ds_salary ds
GROUP BY 1,2
ORDER BY 1,4

-- Изменения з/п год к году по направлениям Data профессий
SELECT 
	ds.job_category,
	ds.work_year,
	ROUND(AVG(salary_in_usd)) AS avarage_salary,
	ROUND((ROUND(AVG(salary_in_usd)) * 100 / lag(ROUND(AVG(salary_in_usd))) OVER (PARTITION BY job_category ORDER BY job_category) - 100) , 2) AS y_y_сhanges_perc,
	ROUND((ROUND(AVG(salary_in_usd)) * 100 / first_value(ROUND(AVG(salary_in_usd))) OVER (PARTITION BY job_category ORDER BY job_category) - 100) , 2) AS сhanges_perc
	FROM ds_salary ds
GROUP BY 1,2

-- В отрыве от профессий
CREATE VIEW yy AS
SELECT 
	ds.work_year,
	ROUND(AVG(salary_in_usd)) AS avarage_salary,
	ROUND((ROUND(AVG(salary_in_usd)) * 100 / lag(ROUND(AVG(salary_in_usd))) OVER (ORDER BY ds.work_year) - 100) , 2) AS y_y_сhanges_perc,
	ROUND((ROUND(AVG(salary_in_usd)) * 100 / first_value(ROUND(AVG(salary_in_usd))) OVER (ORDER BY ds.work_year) - 100) , 2) AS сhanges_perc
	FROM ds_salary ds
GROUP BY 1

-- ТОП направлений Data профессий
SELECT 
	job_category,
	COUNT(job_category)
FROM ds_salary ds 
GROUP BY 1
ORDER BY 2 DESC

-- 1. ТОП Data профессий
SELECT 
	job_title ,
	COUNT(job_title) AS count
FROM ds_salary ds 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 15

-- 2. WHERE (если категория = профессия)
CREATE VIEW top_jt AS
SELECT 
	job_title ,
	COUNT(job_title) AS count
FROM ds_salary ds 
WHERE job_title NOT IN ('Data Engineer', 
						'Data Scientist',
						'Data Analyst', 
						'Machine Learning Engineer',
						'Data Architect')
GROUP BY 1
ORDER BY 2 DESC
LIMIT 15

-- 3. Категории + профессии
CREATE VIEW cat_title AS
SELECT 
	job_category, 
	job_title,
	COUNT(job_title) AS count
FROM ds_salary ds 
GROUP BY 1,2

-- 4. Категории + профессии (с условием)
CREATE VIEW cat_title_2 AS
SELECT 
	job_category, 
	job_title,
	COUNT(job_title) AS count
FROM ds_salary ds 
WHERE job_title NOT IN ('Data Engineer', 
						'Data Scientist',
						'Data Analyst', 
						'Machine Learning Engineer',
						'Data Architect')
GROUP BY 1,2
ORDER BY 3 DESC


-- Как менялось процентное соотношение "удаленки"
SELECT 
	ds.remote_ratio,
	ds.work_year,
	COUNT(ds.remote_ratio)*100/wyc.cnt AS remote_perc,
	(COUNT(ds.remote_ratio)*100/wyc.cnt) * 100 / lag(COUNT(ds.remote_ratio)*100/wyc.cnt) OVER (PARTITION BY ds.remote_ratio ORDER BY ds.work_year) - 100 AS y_y_perc
FROM ds_salary ds
JOIN (SELECT work_year, count(work_year) AS cnt FROM ds_salary ds GROUP BY 1) AS wyc
ON ds.work_year = wyc.work_year
GROUP BY 1,2

-- Зависимость уровня з/п по направлениям Data профессий от:

-- 1. размера компании
SELECT 
	ds.job_category,
	ds.company_size,
	MIN(ds.salary_in_usd) AS min_s,
	ROUND(AVG(ds.salary_in_usd)) AS avg_s,
	MAX(ds.salary_in_usd) AS max_s
FROM ds_salary ds 
GROUP BY 1,2

-- в отрыве от направлений профессий
SELECT 
	ds.company_size,
	MIN(ds.salary_in_usd) AS min_s,
	ROUND(AVG(ds.salary_in_usd)) AS avg_s,
	MAX(ds.salary_in_usd) AS max_s
FROM ds_salary ds 
GROUP BY 1

-- 2. от типа занятости
-- в отрыве от направлений профессий, но с учетом года
SELECT 
	ds.remote_ratio,
	ds.work_year,
	MIN(ds.salary_in_usd) AS min_s,
	ROUND(AVG(ds.salary_in_usd)) AS avg_s,
	MAX(ds.salary_in_usd) AS max_s,
	ROUND(((AVG(ds.salary_in_usd)) * 100 / lag(ROUND(AVG(ds.salary_in_usd))) 
		OVER (PARTITION BY ds.remote_ratio ORDER BY ds.work_year) - 100), 2) AS y_y_perc,
	yy.y_y_сhanges_perc
FROM ds_salary ds 
JOIN yy 
ON yy.work_year = ds.work_year
GROUP BY 1,2

-- 3. от уровня профессий
SELECT 
	ds.experience_level,
	ds.work_year,
	MIN(ds.salary_in_usd) as min_s,
	ROUND(AVG(ds.salary_in_usd)) as avg_s,
	MAX(ds.salary_in_usd) as max_s,
	ROUND(((AVG(ds.salary_in_usd)) * 100 / lag(ROUND(AVG(ds.salary_in_usd))) 
		OVER (PARTITION BY ds.experience_level ORDER BY ds.work_year) - 100), 2) AS y_y_perc,
	yy.y_y_сhanges_perc
FROM ds_salary ds 
JOIN yy 
ON yy.work_year = ds.work_year
GROUP BY 1,2

-- 4. от локации компании/резиденции
CREATE VIEW loc AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY ROUND(AVG(ds.salary_in_usd)) DESC) as loc_id,
	ds.company_location,
	MIN(ds.salary_in_usd) AS min_s,
	ROUND(AVG(ds.salary_in_usd)) AS avg_s,
	MAX(ds.salary_in_usd) AS max_s,
	count(ds.company_location) AS loc_cnt
FROM ds_salary ds 
GROUP BY 2
LIMIT 7

CREATE VIEW res AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY ROUND(AVG(ds.salary_in_usd)) DESC) as res_id,
	ds.employee_residence,
	MIN(ds.salary_in_usd) AS min_s,
	ROUND(AVG(ds.salary_in_usd)) AS avg_s,
	MAX(ds.salary_in_usd) AS max_s,
	count(ds.employee_residence) AS res_cnt
FROM ds_salary ds 
GROUP BY 2
LIMIT 7

SELECT *
FROM loc
JOIN res
ON loc.loc_id = res.res_id

