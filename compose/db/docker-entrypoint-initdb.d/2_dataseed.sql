BEGIN;

-- let's create a temp table to bulk data into and drop the table after commit
CREATE TEMPORARY TABLE seed_json (values text) on commit drop;
COPY seed_json from '/docker-entrypoint-initdb.d/seed.json';


insert into rushing (
    "Player",
    "Pos",
    "Team",
    "Att",
    "Att/G",
    "Yds",
    "Avg",
    "Yds/G",
    "TD",
    "Lng",
    "1st",
    "1st%",
    "20+",
    "40+",
    "FUM"
)

select values->>'Player' as "Player",
values->>'Team' as "Team",
values->>'Pos' as "Pos",
(values->>'Att')::INTEGER as "Att",
(values->>'Att/G')::FLOAT as "Att/G",
(values->>'Yds')::INTEGER as "Yds",
(values->>'Avg')::FLOAT as "Avg",
(values->>'Yds/G')::FLOAT as "Yds/G",
(values->>'TD')::INTEGER as "TD",
values->>'Lng' as "Lng",
(values->>'1st')::INTEGER as "1st",
(values->>'1st%')::FLOAT as "1st%",
(values->>'20+')::INTEGER as "20+",
(values->>'40+')::INTEGER as "40+",
(values->>'FUM')::INTEGER as "FUM"
from (
select json_array_elements(replace(values,'\','\\')::json) as values 
from seed_json
) a; 

-- TODO: add indexes

COMMIT;
END;