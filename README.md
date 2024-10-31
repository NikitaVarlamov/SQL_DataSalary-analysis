# Salary Analysis in Data Professions
Репозиторий содержит pet-проект на тему анализа заработной платы в Дата-профессиях, включающий работу с БД (DBeaver, SQlite) и применение инструментов визуализации (plotly, matplotlib.pyplot, seaborn).<br>
Для анализа данных был взят датасет с сайта Kaggle.com, содержащий информацию о заработной плате в различных областях Data-профессий на 2023 год.<br>
С проектом можно ознакомиться в удобном формате [презентации.](https://github.com/NikitaVarlamov/SQL_salary-analysis/blob/master/presentation.pdf)

## О датасете
Набор данных о зарплатах в сфере Data Science содержит 11 столбцов:
- work_year: год выплаты зарплаты.
- experience_level: уровень опыта работы на должности в течение года.
- employment_type: тип занятости на соответствующей должности.
- job_title: наименование должность.
- salary: общая сумма выплаченной заработной платы за год.
- salary_currency: валюта выплачиваемой зарплаты в виде кода валюты ISO 4217.
- salaryinusd: заработная плата в долларах США.
- employee_residence: основная страна проживания сотрудника в течение рабочего года в виде кода страны ISO 3166.
- remote_ratio: общий объем работы, выполненной удаленно.
- company_location: страна головного офиса или филиала работодателя.
- company_size: среднее количество людей, работавших в компании в течение года.

## Библиотеки
1. Основные: numpy, pandas, sqlite3
2. Визуализация: plotly, matplotlib.pyplot, seaborn, wordcloud
3. Статистика: scipy

## Постановка задач
Цель: Определение влияния внешних и внутренних факторов на уровень заработной платы в Data-профессиях

1. Общий анализ. Определение состава выборки, процентных соотношений групп датасета;
2. Изменение з/п. Анализ изменения заработной платы г/г, определение средней зарплаты по Data-профессиям;
3. Формат занятости. Определение изменений в соотношении формата занятости (удаленной работы);
4. Анализ заработной платы. Выявление зависимости заработной платы от различных факторов;
5. Корреляция. Определение статистической взаимосвязи.