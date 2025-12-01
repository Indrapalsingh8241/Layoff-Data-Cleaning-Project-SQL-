CREATE TABLE layoff (
company	varchar(100),
location varchar(100),	
industry varchar(100),	
total_laid_off	int,
percentage_laid_off	numeric(10,2),
date	date,
stage	varchar(100),
country	varchar(100),
funds_raised_millions	int

);
select*from layoff;
-- remove duplicates
--standardize the data
--null values or blank values
-- remove any columns
 CREATE TABLE layoff2
(LIKE layoff INCLUDING ALL);

insert into layoff2
select*from layoff;
select*from layoff2;
SELECT
    *,
    ROW_NUMBER() OVER (
        PARTITION BY company,
                     location,
                     industry,
                     total_laid_off,
                     percentage_laid_off,
                     date,
                     stage,
                     country,
                     funds_raised_millions
      
    ) AS row_num
FROM layoff2;


with duplicate_cte as(
SELECT
    *,
    ROW_NUMBER() OVER (
        PARTITION BY company,
                     location,
                     industry,
                     total_laid_off,
                     percentage_laid_off,
                     date,
                     stage,
                     country,
                     funds_raised_millions
      
    ) AS row_num
FROM layoff2
)

select*from duplicate_cte
where row_num>1;

CREATE TABLE layoff3 (
company	varchar(100),
location varchar(100),	
industry varchar(100),	
total_laid_off	int,
percentage_laid_off	numeric(10,2),
date	date,
stage	varchar(100),
country	varchar(100),
funds_raised_millions	int,
row_num int
);

insert into layoff3
SELECT
    *,
    ROW_NUMBER() OVER (
        PARTITION BY company,
                     location,
                     industry,
                     total_laid_off,
                     percentage_laid_off,
                     date,
                     stage,
                     country,
                     funds_raised_millions
      
    ) AS row_num
FROM layoff2;

delete from layoff3
where row_num>1;


select* from layoff3;
--standardizing date;
select company,trim(company) from layoff3;

update layoff3
set company=trim(company);

select distinct industry from layoff3 order by 1;

select* from layoff3
where industry like 'Crypto%';

update layoff3
set industry='Crypto'
where industry like 'Crypto%';

select distinct country from layoff3 order by 1;


update layoff3
set country='United States'
where country like 'United States%';

SELECT TO_CHAR("date", 'MM-DD-YYYY')
FROM layoff3;

ALTER TABLE layoff3
ALTER COLUMN "date" TYPE text;

UPDATE layoff3
SET "date" = TO_CHAR(TO_DATE("date", 'YYYY-MM-DD'), 'MM-DD-YYYY');


select* from layoff3;

ALTER TABLE layoff3
ALTER COLUMN "date" TYPE date
USING TO_DATE("date", 'MM-DD-YYYY');


select t1.industry,t2.industry
from layoff3 t1
join layoff3 t2
on t1.company=t2.company
where (t1.industry is null or t1.industry = ' ')
and t2.industry is not null;

UPDATE layoff3 t1
SET industry = t2.industry
FROM layoff3 t2
WHERE t1.company = t2.company
  AND t1.industry IS NULL
  AND t2.industry IS NOT NULL;
select* from layoff3
where industry is null;

select* from layoff3
where percentage_laid_off is null and total_laid_off is null;

delete from layoff3
where percentage_laid_off is null and total_laid_off is null;

alter table layoff3
drop column row_num;

 select* from layoff3;
 where total_laid_off is null;


select industry ,sum(total_laid_off) from layoff3
group by  industry
order by 2 desc;


SELECT 
    EXTRACT(YEAR FROM "date") AS year,
    SUM(total_laid_off) AS total_laid_off
FROM layoff3
GROUP BY EXTRACT(YEAR FROM "date")
ORDER BY 1 DESC;   






















