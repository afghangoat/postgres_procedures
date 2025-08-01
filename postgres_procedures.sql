--Types
CREATE EXTENSION Hstore;

CREATE TYPE Human AS(
  name TEXT,
  email TEXT,
  age INT,
  birthday DATE,
  --dna char[4][4], ARRAY[ARRAY['A','T','G','C'],ARRAY['A','T','G','C'],ARRAY['A','T','G','C'],ARRAY['A','T','G','C']],
  bio JSON,
  skills Hstore
);


--Procedures
CREATE OR REPLACE PROCEDURE REGISTER_PROGRAMMER(
    p_name TEXT,
    p_email TEXT,
    p_age INT,
    p_birthday DATE,
    p_bio JSON,
    p_skills Hstore
)
LANGUAGE plpgsql
AS $$
  BEGIN
    INSERT INTO Programmers (details)
    VALUES (
      ROW(
      p_name,
      p_email,
      p_age,
      p_birthday,
      p_bio::JSON,
      p_skills::Hstore
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION GET_PROGRAMMER_SKILL(
  p_name TEXT,
  p_skill TEXT
) RETURNS TABLE(target_name TEXT, target_skill TEXT)
LANGUAGE plpgsql
AS $$
  BEGIN
    RETURN QUERY
    SELECT 
      (details).name,
      (details).skills -> p_skill
    FROM Programmers
    WHERE (details).name = p_name;
  END;
$$;

--Database definitions
CREATE TABLE Programmers (
  id SERIAL PRIMARY KEY,
  details Human
);

--Commands
CALL REGISTER_PROGRAMMER('Joseph Seed','joseph@seed.com',50,'1999-01-01','{"about":"Jeff is a 10x dev!"}','python=>*****,cobol=>***');

SELECT * FROM GET_PROGRAMMER_SKILL('Joseph Seed','python');