
-- have a look at the table

SELECT * 
FROM ifood.dbo.ml_project1_data_original;


-- calculate the number of rows： 2240

SELECT count(ID)
FROM ifood.dbo.ml_project1_data_original;


-- calculate the number of columns： 29

SELECT COUNT(COLUMN_NAME) 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_CATALOG = 'ifood' AND TABLE_SCHEMA = 'dbo'
AND TABLE_NAME = 'ml_project1_data_original';   


-- create columns Age

SELECT YEAR(GETDATE()) - Year_Birth AS CustAge
FROM ml_project1_data_original;

--ALTER TABLE ml_project1_data_original
--DROP COLUMN Age;

ALTER TABLE ml_project1_data_original
ADD Age INT;

UPDATE ml_project1_data_original
SET Age = (YEAR(GETDATE()) - Year_Birth); 



SELECT * FROM ml_project1_data_original;
-- Create column days of being a member

SELECT DATEDIFF(day, Dt_Customer, CAST(GETDATE() AS DATE)) AS Days_Member
FROM ifood.dbo.ml_project1_data_original;

ALTER TABLE ifood.dbo.ml_project1_data_original
ADD Days_Member INT;

UPDATE ifood.dbo.ml_project1_data_original
SET Days_Member = DATEDIFF(day, Dt_Customer, CAST(GETDATE() AS DATE));

-- create columns for each marital status

-- check unique values in Marital Status： “Single, Divorced, Together, Married, YOLO, Widow, Alone, Absurd"

SELECT DISTINCT(Marital_Status)
FROM ml_project1_data_original;

ALTER TABLE ml_project1_data_original
ADD Marital_Single BIT;

UPDATE ml_project1_data_original
SET Marital_Single = 
  CASE 
    WHEN Marital_Status = 'Single' THEN 1
    ELSE 0
  END;

ALTER TABLE ml_project1_data_original  -- run first, then update, cannot run together
ADD Marital_Together BIT;

UPDATE ml_project1_data_original
SET Marital_Together = 
  CASE 
    WHEN Marital_Status = 'Together' THEN 1
    ELSE 0
  END;

ALTER TABLE ml_project1_data_original
ADD Marital_Divorced BIT;

UPDATE ml_project1_data_original
SET Marital_Divorced = 
  CASE 
    WHEN Marital_Status = 'Divorced' THEN 1
    ELSE 0
  END;

ALTER TABLE ml_project1_data_original
ADD Marital_Married BIT;

UPDATE ml_project1_data_original
SET Marital_Married = 
  CASE 
    WHEN Marital_Status = 'Married' THEN 1
    ELSE 0
  END;

ALTER TABLE ml_project1_data_original
ADD Marital_YOLO BIT;

UPDATE ml_project1_data_original
SET Marital_YOLO = 
  CASE 
    WHEN Marital_Status = 'YOLO' THEN 1
    ELSE 0
  END;

ALTER TABLE ml_project1_data_original
ADD Marital_Widow BIT;

UPDATE ml_project1_data_original
SET Marital_Widow = 
  CASE 
    WHEN Marital_Status = 'Widow' THEN 1
    ELSE 0
  END;

ALTER TABLE ml_project1_data_original
ADD Marital_Alone BIT;

UPDATE ml_project1_data_original
SET Marital_Alone = 
  CASE 
    WHEN Marital_Status = 'Alone' THEN 1
    ELSE 0
  END;

ALTER TABLE ml_project1_data_original
ADD Marital_Absurd BIT;

UPDATE ml_project1_data_original
SET Marital_Absurd = 
  CASE 
    WHEN Marital_Status = 'Absurd' THEN 1
    ELSE 0
  END;

SELECT * 
FROM ifood.dbo.ml_project1_data_original;



--create total amount of regular products: total amount of all products except gold products

ALTER TABLE ml_project1_data_original
ADD MntRegProducts INT;

UPDATE ml_project1_data_original
SET MntRegProducts = 
  (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts);


-- change the column name of Mnt gold products for consistency: caution

EXEC sp_rename 'ml_project1_data_original.MntGoldProds', 'MntGoldProducts', 'COLUMN';


-- create total amount of products


ALTER TABLE ml_project1_data_original
ADD MntAllProducts INT;

UPDATE ml_project1_data_original
SET MntAllProducts = 
  (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProducts);


-- create total accpeted compaign for each user id

ALTER TABLE ml_project1_data_original
ADD TotalAcceptedCmp INT;

UPDATE ml_project1_data_original
SET TotalAcceptedCmp = 
  CAST(AcceptedCmp3 AS INT) +
  CAST(AcceptedCmp4 AS INT) +
   CAST(AcceptedCmp5 AS INT) +
   CAST(AcceptedCmp1 AS INT) +
    CAST(AcceptedCmp2 AS INT);


-- get all column names

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ml_project1_data_original'


-- sget columns for each education level
-- Graduation PhD Master 2n Cycle Basic 

SELECT DISTINCT(Education)
FROM ml_project1_data_original;

ALTER TABLE ml_project1_data_original
ADD Edu_Graduation BIT;

UPDATE ml_project1_data_original
SET Edu_Graduation = 
CASE
WHEN Education = 'Graduation' THEN 1
ELSE 0
END;

ALTER TABLE ml_project1_data_original
ADD Edu_PhD BIT;

UPDATE ml_project1_data_original
SET Edu_PhD = 
CASE
WHEN Education = 'PhD' THEN 1
ELSE 0
END;

ALTER TABLE ml_project1_data_original
ADD Edu_Master BIT;

UPDATE ml_project1_data_original
SET Edu_Master = 
CASE
WHEN Education = 'Master' THEN 1
ELSE 0
END;

ALTER TABLE ml_project1_data_original
ADD Edu_2n_Cycle BIT;

UPDATE ml_project1_data_original
SET Edu_2n_Cycle =
CASE
WHEN Education = '2n Cycle' THEN 1
ELSE 0
END;

ALTER TABLE ml_project1_data_original
ADD Edu_Basic BIT;

UPDATE ml_project1_data_original
SET Edu_Basic = 
CASE
WHEN Education = 'Basic' THEN 1
ELSE 0
END;

SELECT * 
FROM ifood.dbo.ml_project1_data_original;


--check duplicate rows： 0 

SELECT ID, Year_Birth,Education,Marital_Status, Income, Kidhome, Teenhome,Dt_Customer, Recency
FROM ifood.dbo.ml_project1_data_original
GROUP BY
ID, Year_Birth,Education,Marital_Status, Income, Kidhome, Teenhome,Dt_Customer, Recency
HAVING COUNT(*) > 1;


-- drop columns

ALTER TABLE ml_project1_data_original
DROP COLUMN Year_Birth;

-- drop rows containing NULL values


DELETE FROM ifood.dbo.ml_project1_data_original
WHERE Income IS NULL;


SELECT * 
FROM ifood.dbo.ml_project1_data_original;



-- save output to a local file
--  terminal -> bcp ? -> bcp <database_name>.<schema_name>.<table_name> out <file_destination_path> -S<server_instance> -c -t"," -T
-- copy paste: open an empty csv file -> results tab right click -> select all -> right click results copy with header -> paste to the empty file.