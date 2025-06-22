-- Here we created a type a sepeate type called season_stats which is type : array
CREATE TYPE season_stats as (
       season integer,
       gp REAL ,
        pts REAL,
        reb REAL,
        ast REAL
                         );
-- DROP TABLE Player;
-- Here we create a new table called palyers which will be using to store accumulated data or historical data till yesterday.
CREATE TABLE Player (
    player_name text,
    height text,
    weight INTEGER,
    college text,
    country text,
    draft_year text,
    draft_round text,
    draft_number text,
    current_season INTEGER,
    season_stats season_stats[],
    primary key (player_name , current_season)

);

-- here we created two ctes whill will fetch the yesterday data that is from our historical table and new data that is today
with yesterday as (
    select *
    from Player , UNNEST(season_stats) AS season
    where season = 1995

),
    today as (
    select *
    from player_seasons
    where season = 1996
    )

-- here we are printing the data in the most cumulative compress form till today.
select
       COALESCE(y.player_name,t.player_name) AS Player_name ,
       COALESCE(y.height,t.height) AS height ,
       COALESCE(y.weight,t.weight) AS weight ,
       COALESCE(y.college,t.college) AS college ,
       COALESCE(y.country,t.country) AS country ,
       COALESCE(y.draft_year,t.draft_year) AS draft_year ,
       COALESCE(y.draft_number,t.draft_number) AS draft_number ,
       COALESCE(y.draft_round,t.draft_round) AS draft_round,
        CASE
            WHEN season_stats IS NULL THEN
                ARRAY[ ROW(
                     t.gp,
                    t.pts ,
                    t.reb ,
                    t.ast ,
                    t.netrtg
                    ) :: season_stats
                    ]
            WHEN t.season IS NOT NULL THEN  concat(y.season_stats,
                        ARRAY [ ROW (
                            t.gp,
                            t.pts ,
                            t.reb ,
                            t.ast ,
                            t.netrtg
                            ) :: season_stats
                            ]
                 )
            ELSE y.season
            END as season_stats
FROM
    yesterday as y
    FULL OUTER JOIN
    today as t ON  y.player_name = t.player_name ;










