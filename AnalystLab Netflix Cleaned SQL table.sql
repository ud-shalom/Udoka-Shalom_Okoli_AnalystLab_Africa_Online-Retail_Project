--PHASE 1: DATA QUALITY CHECK & DIAGNOSTICS
-- Project: AnalystLab Africa Internship Portfolio (Batch B)
-- Dataset: Netflix Movies & TV Shows
-- Objective: Auditing structural flaws, missing entries, and duplicates
--            BEFORE any cleaning modifications are made.

--CHECK 1: PREVIEW RAW DATA ROWS
-- Purpose: Grabs a quick 10-row snapshot to visually inspect how the 
--          text strings, spaces, and values look right after import.
SELECT TOP 10 * FROM dbo.[netflix_titles 1 csc];

-- CHECK B: IDENTIFY NUMBER OF ROWS
-- Purpose: Total row count audit. (Should display 8,807 rows).
SELECT COUNT(*) AS [Total Rows In Table] 
FROM [dbo].[netflix_titles 1 csc];

-- CHECK C: IDENTIFY DATA TYPES OF ALL COLUMNS & NUMBER OF COLUMNS
-- Purpose: Queries the system catalog for your exact table.
--          Each row returned in this grid represents 1 column.
SELECT 
    COLUMN_NAME AS [Column Name], 
    DATA_TYPE AS [Data Type], 
    CHARACTER_MAXIMUM_LENGTH AS [Max Character Length]
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'dbo.netflix_titles 1 csc';

-- CHECK D: IDENTIFY POSSIBLE UNIQUE IDENTIFIERS (PRIMARY KEY AUDIT)
-- Purpose: Checks if 'show_id' has any duplicate rows. 
-- If the result grid is blank, 'show_id' is 100% unique!
SELECT show_id, 
COUNT(*) AS [Occurrence Count]
FROM [dbo].[netflix_titles 1 csc]
GROUP BY show_id
HAVING COUNT(*) > 1;

-- PHASE 2: MISSING VALUE HANDLING (ZERO-DELETION IMPUTATION)
-- Project: AnalystLab Africa Internship Portfolio (Batch B)
-- Dataset: Netflix Movies & TV Shows
-- Objective: Standardize all missing/blank fields to 'Unknown' 
-- without dropping any rows to keep 100% data retention.

-- STEP 1: IDENTIFY & COUNT MISSING VALUES PER COLUMN
-- Purpose: Scans all columns for both system NULLs and blank spaces ('').
SELECT 
    SUM(CASE WHEN show_id IS NULL OR show_id = '' THEN 1 ELSE 0 END) AS Missing_show_id,
    SUM(CASE WHEN type IS NULL OR type = '' THEN 1 ELSE 0 END) AS Missing_type,
    SUM(CASE WHEN title IS NULL OR title = '' THEN 1 ELSE 0 END) AS Missing_title,
    SUM(CASE WHEN director IS NULL OR director = '' THEN 1 ELSE 0 END) AS Missing_director,
    SUM(CASE WHEN cast IS NULL OR cast = '' THEN 1 ELSE 0 END) AS Missing_cast,
    SUM(CASE WHEN country IS NULL OR country = '' THEN 1 ELSE 0 END) AS Missing_country,
    SUM(CASE WHEN date_added IS NULL OR date_added = '' THEN 1 ELSE 0 END) AS Missing_date_added,
    SUM(CASE WHEN release_year IS NULL THEN 1 ELSE 0 END) AS Missing_release_year,
    SUM(CASE WHEN rating IS NULL OR rating = '' THEN 1 ELSE 0 END) AS Missing_rating,
    SUM(CASE WHEN duration IS NULL OR duration = '' THEN 1 ELSE 0 END) AS Missing_duration,
    SUM(CASE WHEN listed_in IS NULL OR listed_in = '' THEN 1 ELSE 0 END) AS Missing_listed_in,
    SUM(CASE WHEN description IS NULL OR description = '' THEN 1 ELSE 0 END) AS Missing_description
FROM [dbo].[netflix_titles 1 csc];

-- STEP 2: APPLY 'UNKNOWN' IMPUTATION TO ALL POTENTIAL MISSING COLUMNS
-- Purpose: Scans text attributes and replaces empty strings ('') or 
-- system NULLs with 'Unknown' to preserve row completeness.
-- A. Update primary categorical fields
UPDATE [dbo].[netflix_titles 1 csc]
SET director = 'Unknown'
WHERE director IS NULL OR director = '';

UPDATE [dbo].[netflix_titles 1 csc]
SET cast = 'Unknown'
WHERE cast IS NULL OR cast = '';

UPDATE [dbo].[netflix_titles 1 csc]
SET country = 'Unknown'
WHERE country IS NULL OR country = '';

UPDATE [dbo].[netflix_titles 1 csc]
SET rating = 'Unknown'
WHERE rating IS NULL OR rating = '';

-- STEP 3: QUALITY ASSURANCE AUDIT (POST-IMPUTATION RE-CHECK)
-- Purpose: Verifies that every single blank/NULL space has been 
--          successfully converted. Total missing count must equal 0.
SELECT 
    COUNT(*) AS [Total Retained Rows], -- Should remain exactly 8,807
    SUM(CASE WHEN director IS NULL OR director = '' THEN 1 ELSE 0 END) AS Missing_Directors,
    SUM(CASE WHEN rating IS NULL OR rating = '' THEN 1 ELSE 0 END) AS Missing_Ratings,
    SUM(CASE WHEN date_added IS NULL OR date_added = '' THEN 1 ELSE 0 END) AS Missing_Dates
FROM [dbo].[netflix_titles 1 csc];

-- PHASE 3: DUPLICATE RECORD DIAGNOSTICS & CLEANING
-- Project: AnalystLab Africa Internship Portfolio (Batch B)
-- Dataset: Netflix Movies & TV Shows
-- Objective: Identify, count, and remove complete duplicate entries 
--while preserving the original unique rows.

-- STEP 1: IDENTIFY THE NUMBER OF DUPLICATE ROWS
-- Purpose: Uses a CTE (Common Table Expression) and ROW_NUMBER() to 
--flag duplicate rows. Any row with a Row_Num greater than 1 
--is a duplicate entry.
WITH DuplicateCheckCTE AS (
    SELECT 
        show_id,
        type,
        title,
        director,
        cast,
        country,
        date_added,
        release_year,
        rating,
        duration,
        listed_in,
        description,
        ROW_NUMBER() OVER (
            PARTITION BY show_id, type, title, director, cast, country, date_added, release_year, rating, duration, listed_in, description
            ORDER BY show_id
        ) AS Row_Num
    FROM [dbo].[netflix_titles 1 csc]
)
SELECT COUNT(*) AS [Total Duplicate Rows Found]
FROM DuplicateCheckCTE
WHERE Row_Num > 1;

-- PHASE 4: FORMATTING & STRUCTURAL CONSISTENCY
-- Project: AnalystLab Africa Internship Portfolio (Batch B)
-- Objective: Standardize date layouts, fix text casing, rename columns,
-- and clean up column data storage rules.

--STEP 1: CREATE THE PROPER CASE TRANSFORMATION TOOL
-- Purpose: Builds a custom scalar function because SQL Server lacks 
-- a native PROPER() function. This script processes multi-word 
-- strings and capitalizes letters following spaces or symbols.
-- Create the Proper Case helper tool

CREATE FUNCTION dbo.fn_ProperCase(@InputString VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @Index INT
    DECLARE @Char CHAR(1)
    DECLARE @OutputString VARCHAR(MAX)
    
    SET @OutputString = LOWER(@InputString)
    SET @Index = 2
    SET @OutputString = STUFF(@OutputString, 1, 1, UPPER(SUBSTRING(@OutputString, 1, 1)))
    
    WHILE @Index <= LEN(@InputString)
    BEGIN
     SET @Char = SUBSTRING(@OutputString, @Index - 1, 1)
     IF @Char IN (' ', ';', ':', ',', '.', '-', '/', '(', ')')
     BEGIN
      SET @OutputString = STUFF(@OutputString, @Index, 1, UPPER(SUBSTRING(@OutputString, @Index, 1)))
        END
        SET @Index = @Index + 1
    END
    
    RETURN @OutputString
END;
USE [Analystlab];

-- EXECUTE PROPER CASE TRANSFORMATION FOR ALL TEXT COLUMNS
-- Purpose: Applies the function across all text features simultaneously.
UPDATE [dbo].[netflix_titles 1 csc]
SET 
    title       = dbo.fn_ProperCase(title),
    director    = dbo.fn_ProperCase(director),
    cast        = dbo.fn_ProperCase(cast),
    country     = dbo.fn_ProperCase(country),
    listed_in   = dbo.fn_ProperCase(listed_in), -- Use 'genre' if already renamed
    description = dbo.fn_ProperCase(description);

-- VERIFICATION VIEW
SELECT TOP 5 title, director, cast, country, listed_in FROM [dbo].[netflix_titles 1 csc];


-- STEP 2: DATA TYPE CONSISTENCY & SCHEMAS
-- Purpose: Changes column data storage rules from massive open-ended text 
--          (varchar(MAX)) down to clean, precise, and memory-safe blocks.


-- Set show_id to a fixed, strict string length and ensure it can't be empty
ALTER TABLE [dbo].[netflix_titles 1 csc]
ALTER COLUMN show_id VARCHAR(50) NOT NULL;

-- Set content_type (Movie/Tv Show) to a clean, small text limit
ALTER TABLE [dbo].[netflix_titles 1 csc]
ALTER COLUMN content_type VARCHAR(50);

-- Set rating (PG-13, R, etc.) to a standard code text limit
ALTER TABLE [dbo].[netflix_titles 1 csc]
ALTER COLUMN rating VARCHAR(50);

-- STEP 3: VERIFICATION AUDIT
-- Purpose: Queries the system blueprint to verify our schema changes are live.
SELECT 
    COLUMN_NAME AS [Updated Column Name], 
    DATA_TYPE AS [New Data Type], 
    CHARACTER_MAXIMUM_LENGTH AS [Max Length]
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'netflix_titles 1 csc';

-- PHASE 4: DATA VALIDATION (OUTLIERS, ANOMALIES & INVALID VALUES)
-- Project: AnalystLab Africa Internship Portfolio (Batch B)
-- Table Name: [dbo].[netflix_titles 1 csc]
-- Objective: Identify and flag structural anomalies, impossible dates, 
-- and numeric outliers before starting EDA.

-- STEP 1: IDENTIFY & FIX FORMAT INCONSIStENCIES (DURATION COLUMN)
-- Purpose: Runtimes for Movies are in 'min', but TV Shows use 'Seasons'.
--  If text values are swapped or placed in wrong rows, calculations break.
-- A. Diagnostic Check: Find any TV Shows with 'min' or Movies with 'Seasons'

SELECT show_id, content_type, title, duration 
FROM [dbo].[netflix_titles 1 csc]
WHERE (content_type = 'Movie' AND duration LIKE '%Season%')
   OR (content_type = 'Tv show' AND duration LIKE '%min%');

-- B. Validation Rule: Standardize any corrupted text formats to 'Unknown' if misaligned
UPDATE [dbo].[netflix_titles 1 csc]
SET duration = 'Unknown'
WHERE (content_type = 'Movie' AND duration LIKE '%Season%')
   OR (content_type = 'Tv show' AND duration LIKE '%min%');

-- PHASE 5: FINAL DATA EXTRACTION & VERIFICATION
-- Project: AnalystLab Africa Internship Portfolio (Batch B)
-- Objective: Retrieve the entire fully-cleaned, standardized table 
-- and display all changes simultaneously for a final quality.

-- VIEW COMPLETE CLEANED DATASET
-- Purpose: Pulls all columns and rows to confirm proper casing, 
--          imputed values, and renamed headers are perfectly live.
SELECT * FROM [dbo].[netflix_titles 1 csc];

