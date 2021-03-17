CREATE TABLE usertemp(
    id   SERIAL PRIMARY KEY,
    name VARCHAR
);

CREATE TABLE rushing(
    id       SERIAL PRIMARY KEY,
    "Player" VARCHAR,
    "Team"   VARCHAR,
    "Pos"    VARCHAR,
    "Att"    INTEGER,
    "Att/G"  FLOAT,
    "Yds"    INTEGER,
    "Avg"    FLOAT,
    "Yds/G"  FLOAT,
    "TD"     INTEGER,
    "Lng"    VARCHAR,
    "1st"    INTEGER,
    "1st%"   FLOAT,
    "20+"    INTEGER,
    "40+"    INTEGER,
    "FUM"    INTEGER
);

-- CREATE INDEX rushing_player ON rushing(Player);