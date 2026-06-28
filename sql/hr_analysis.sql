CREATE DATABASE hr_db;
USE hr_db;

SELECT * FROM hr_cleaned LIMIT 5;

SELECT COUNT(*) FROM hr_cleaned;

-- Business Overview

SELECT
    COUNT(*)  AS Total_Employees,
    
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Total_Attrition,
    
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Attrition_Rate,
    
    ROUND(AVG(MonthlyIncome), 2) AS Avg_Monthly_Income,
    
    ROUND(AVG(YearsAtCompany), 2) AS Avg_Tenure
	FROM hr_cleaned;
-- What this tells us: Overall HR health in one view.



-- Attrition by Department
SELECT
    Department,
    COUNT(*) AS Total_Employees,
    
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2)AS Attrition_Rate
FROM hr_cleaned
GROUP BY Department
ORDER BY Attrition_Rate DESC;
-- What this tells us: Which department loses most employees.



-- Attrition by Job Role
SELECT
    JobRole,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Attrition_Rate
FROM hr_cleaned
GROUP BY JobRole
ORDER BY Attrition_Rate DESC;
-- What this tells us: Which job role has highest attrition.



-- Overtime vs Attrition
SELECT
    OverTime,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Attrition_Rate
FROM hr_cleaned
GROUP BY OverTime
ORDER BY Attrition_Rate DESC;
-- What this tells us: Overtime employees leave more.



-- Salary Analysis by Department
SELECT
    Department,
    ROUND(AVG(MonthlyIncome), 2) AS Avg_Salary,
    ROUND(MIN(MonthlyIncome), 2) AS Min_Salary,
    ROUND(MAX(MonthlyIncome), 2) AS Max_Salary,
    ROUND(AVG(CASE WHEN Attrition = 'Yes'
        THEN MonthlyIncome END), 2) AS Avg_Salary_Left
FROM hr_cleaned
GROUP BY Department
ORDER BY Avg_Salary DESC;
-- What this tells us: Salary distribution and who left at what salary.



-- Attrition by Tenure Band
SELECT
    `Tenure Band`,
    COUNT(*)  AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Attrition_Rate
FROM hr_cleaned
GROUP BY `Tenure Band`
ORDER BY Attrition_Rate DESC;
-- What this tells us: New employees leave most.


-- High Risk Employees (CTE)
-- CTE finds employees most at risk of leaving
-- Overtime + Low satisfaction + Low tenure
WITH High_Risk AS (
    SELECT *
    FROM hr_cleaned
    WHERE OverTime = 'Yes'
    AND JobSatisfaction <= 2
    AND YearsAtCompany <= 2
)
SELECT
    COUNT(*) AS High_Risk_Count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Attrition_Rate,
    ROUND(AVG(MonthlyIncome), 2) AS Avg_Salary
FROM High_Risk;
-- What this tells us: Exact high risk employee segment.


 -- Salary Rank by Department (Window Function)
SELECT
    EmployeeNumber,
    Department,
    JobRole,
    MonthlyIncome,
    RANK() OVER (PARTITION BY Department
                 ORDER BY MonthlyIncome DESC) AS Salary_Rank
FROM hr_cleaned
ORDER BY Department, Salary_Rank
LIMIT 20;
-- What this tells us: Who earns most in each department.



-- Job Satisfaction vs Attrition
SELECT
    JobSatisfaction,
    COUNT(*)AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2)AS Attrition_Rate
FROM hr_cleaned
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;
-- What this tells us: Who earns most in each department.



-- Attrition Risk Score Analysis
SELECT
    `Attrition Risk Score`,
    COUNT(*)AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Attrition_Rate
FROM hr_cleaned
GROUP BY `Attrition Risk Score`
ORDER BY `Attrition Risk Score` DESC;	
-- What this tells us: Higher risk score = higher attrition confirms our scoring model works.


