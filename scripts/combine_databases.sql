ATTACH DATABASE "20201024-2.3.1-switrs.sqlite3" AS db20;
ATTACH DATABASE "20180925-2.3.1-switrs.sqlite3" AS db18;
ATTACH DATABASE "20170112-2.3.1-switrs.sqlite3" AS db17;
ATTACH DATABASE "20160924-2.3.1-switrs.sqlite3" AS db16;
ATTACH DATABASE "/tmp/output.sqlite3" AS outputdb;

-- Select all from 2020
CREATE TABLE outputdb.Case_IDs AS 
SELECT Case_ID, '2020' AS db_year
FROM db20.Collision;

-- Now add the rows that don't match from earlier databases, in
-- reverse chronological order so that the newer rows are not
-- overwritten.
INSERT INTO outputdb.Case_IDs
SELECT * FROM (
    SELECT older.Case_ID, '2018'
    FROM db18.Collision AS older
    LEFT JOIN outputdb.Case_IDs AS prime
    ON prime.Case_ID = older.Case_ID
    WHERE prime.Case_ID IS NULL
);

INSERT INTO outputdb.Case_IDs
SELECT * FROM (
    SELECT older.Case_ID, '2017'
    FROM db17.Collision AS older
    LEFT JOIN outputdb.Case_IDs AS prime
    ON prime.Case_ID = older.Case_ID
    WHERE prime.Case_ID IS NULL
);

INSERT INTO outputdb.Case_IDs
SELECT * FROM (
    SELECT older.Case_ID, '2016'
    FROM db16.Collision AS older
    LEFT JOIN outputdb.Case_IDs AS prime
    ON prime.Case_ID = older.Case_ID
    WHERE prime.Case_ID IS NULL
);

SELECT db_year, COUNT(1)
FROM outputdb.Case_IDs
GROUP BY db_year;

-- Create the combined collision table

CREATE TABLE outputdb.Collision AS
SELECT *
FROM db20.Collision;

INSERT INTO outputdb.Collision
SELECT * FROM (
    SELECT col.*
    FROM db18.Collision AS col
    INNER JOIN outputdb.Case_IDs AS ids
    ON ids.Case_ID = col.Case_ID
    WHERE ids.db_year = '2018'
);

INSERT INTO outputdb.Collision
SELECT * FROM (
    SELECT col.*
    FROM db17.Collision AS col
    INNER JOIN outputdb.Case_IDs AS ids
    ON ids.Case_ID = col.Case_ID
    WHERE ids.db_year = '2017'
);

INSERT INTO outputdb.Collision
SELECT * FROM (
    SELECT col.*
    FROM db16.Collision AS col
    INNER JOIN outputdb.Case_IDs AS ids
    ON ids.Case_ID = col.Case_ID
    WHERE ids.db_year = '2016'
);

-- Create the party table
CREATE TABLE outputdb.Victim AS
SELECT *
FROM db20.Victim;

INSERT INTO outputdb.Victim
SELECT * FROM (
    SELECT col.*
    FROM db18.Victim AS col
    INNER JOIN outputdb.Case_IDs AS ids
    ON ids.Case_ID = col.Case_ID
    WHERE ids.db_year = '2018'
);

INSERT INTO outputdb.Victim
SELECT * FROM (
    SELECT col.*
    FROM db17.Victim AS col
    INNER JOIN outputdb.Case_IDs AS ids
    ON ids.Case_ID = col.Case_ID
    WHERE ids.db_year = '2017'
);

INSERT INTO outputdb.Victim
SELECT * FROM (
    SELECT col.*
    FROM db16.Victim AS col
    INNER JOIN outputdb.Case_IDs AS ids
    ON ids.Case_ID = col.Case_ID
    WHERE ids.db_year = '2016'
);

-- Create the party table
CREATE TABLE outputdb.Party AS
SELECT *
FROM db20.Party;

INSERT INTO outputdb.Party
SELECT * FROM (
    SELECT col.*
    FROM db18.Party AS col
    INNER JOIN outputdb.Case_IDs AS ids
    ON ids.Case_ID = col.Case_ID
    WHERE ids.db_year = '2018'
);

INSERT INTO outputdb.Party
SELECT * FROM (
    SELECT col.*
    FROM db17.Party AS col
    INNER JOIN outputdb.Case_IDs AS ids
    ON ids.Case_ID = col.Case_ID
    WHERE ids.db_year = '2017'
);

INSERT INTO outputdb.Party
SELECT * FROM (
    SELECT col.*
    FROM db16.Party AS col
    INNER JOIN outputdb.Case_IDs AS ids
    ON ids.Case_ID = col.Case_ID
    WHERE ids.db_year = '2016'
);
