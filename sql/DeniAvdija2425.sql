
alter table dbo.deni_2425
alter column [Date] Date;

ALTER TABLE dbo.Deni_2425
ALTER COLUMN [FG_prcnt] FLOAT;

ALTER TABLE dbo.Deni_2425
ALTER COLUMN [3p_prcnt] FLOAT;

ALTER TABLE dbo.Deni_2425
ALTER COLUMN [2p_prcnt] FLOAT;

ALTER TABLE dbo.Deni_2425
ALTER COLUMN [efg] FLOAT;

alter table dbo.deni_2425
alter column pts int;

select top(10) *
from dbo.Deni_2425;

use Deni_Avdija_2425
go

USE Deni_Avdija_2425;
GO

-- 1. Drop the manual table so it stops complaining
IF OBJECT_ID('dbo.DA_2425', 'U') IS NOT NULL
    DROP TABLE dbo.DA_2425;
GO

-- 2. Now work ONLY with the imported table:
SELECT TOP (10) *
FROM dbo.Deni_2425;

select
    round(AVG(cast(pts as float)),2) as avg_PTS,
    round(AVG(cast(trb as float)),2) as avg_TRB,
    round(AVG(cast(ast as float)),2) as avg_AST
from dbo.Deni_2425;

select
    Home,
    COUNT(*) as Home_Games,
    ROUND(avg(cast(pts as float)),2) as avg_PTS,
    round(avg(cast(trb as float)),2) as avg_TRB,
    ROUND(AVG(cast(ast as float)),2) as avg_AST
from dbo.Deni_2425
group by Home;

SELECT
    Opp,
    COUNT(*) AS games,
    ROUND(AVG(CAST(pts AS FLOAT)), 2) AS avg_pts,
    ROUND(AVG(CAST(trb AS FLOAT)), 2) AS avg_reb,
    ROUND(AVG(CAST(ast AS FLOAT)), 2) AS avg_ast
FROM dbo.Deni_2425
GROUP BY Opp
ORDER BY avg_pts DESC;

SELECT
    Gtm,
    [Date],
    Opp,
    ROUND(FG_prcnt, 2) AS FG_pct,
    ROUND([3P_prcnt], 2) AS [3P_pct],
    ROUND([2P_prcnt], 2) AS [2P_pct],
    ROUND(efg, 2) AS eFG_pct,
    pts,
    trb,
    ast
FROM dbo.Deni_2425;

SELECT
    FORMAT([Date], 'yyyy-MM') AS Month,
    COUNT(*) AS games,
    ROUND(AVG(CAST(pts AS FLOAT)), 2) AS avg_pts,
    ROUND(AVG(CAST(trb AS FLOAT)), 2) AS avg_reb,
    ROUND(AVG(CAST(ast AS FLOAT)), 2) AS avg_ast
FROM dbo.Deni_2425
GROUP BY FORMAT([Date], 'yyyy-MM')
ORDER BY Month;

SELECT
    Gtm,
    [Date],
    Opp,
    pts,
    fga,
    fta,
    format( pts / (2.0 * (fga + 0.44 * fta)), 'n2' ) AS TS_pct
FROM dbo.Deni_2425
ORDER BY [Date];

SELECT
    Gtm,
    [Date],
    Opp,
    MP,
    fga,
    fta,
    tov,
    pts,
    -- possessions Deni personally used
    format(fga + 0.44 * fta + tov, 'n2') AS poss_used,
    -- possessions used per 36 minutes
    format((fga + 0.44 * fta + tov) * 36.0 / NULLIF(MP, 0), 'n2') AS poss_used_per_36,
    -- scoring efficiency per used possession
    format(pts / NULLIF((fga + 0.44 * fta + tov), 0), 'n2') AS pts_per_poss
FROM dbo.Deni_2425
ORDER BY [Date];

SELECT
    format(AVG(fga + 0.44 * fta + tov), 'n2') AS avg_poss_used,
    format(AVG((fga + 0.44 * fta + tov) * 36.0 / NULLIF(MP, 0)), 'n2') AS avg_poss_used_per_36,
    format(AVG(pts / NULLIF((fga + 0.44 * fta + tov), 0)), 'n2') AS avg_pts_per_poss
FROM dbo.Deni_2425;

with stats as (
    select
        AVG(cast(pts as float)) as mean_pts,
        STDEV(cast(pts as float)) as sd_pts,
        COUNT(*) as n
    from dbo.Deni_2425
)
select
    FORMAT(mean_pts,'n2') as mean_pts,
    FORMAT(sd_pts,'n2') as sd_pts,
    FORMAT(mean_pts-1.96*(sd_pts/SQRT(n)),'n2') as CI_Lower,
    FORMAT(mean_pts+1.96*(sd_pts/sqrt(n)),'n2') as CI_Upper
from stats;

with stats as(
    select
        AVG(cast(pts as float)) as mean_pts,
        STDEV(cast(pts as float)) as sd_pts
    from dbo.Deni_2425
)
select 
    FORMAT(mean_pts-1.96*sd_pts,'n2') as NrmlRng_Lower,
    FORMAT(mean_pts+1.96*sd_pts,'n2') as NrmlRng_Upper
from stats;

with stats as (
    select
        AVG(cast(TRB as float)) as mean_TRB,
        STDEV(cast(TRB as float)) as sd_TRB,
        COUNT(*) as n
    from dbo.Deni_2425
)
select
    FORMAT(mean_TRB,'n2') as mean_TRB,
    FORMAT(sd_TRB,'n2') as sd_TRB,
    FORMAT(mean_TRB-1.96*(sd_TRB/SQRT(n)),'n2') as CI_Lower,
    FORMAT(mean_TRB+1.96*(sd_TRB/sqrt(n)),'n2') as CI_Upper
from stats;

with stats as(
    select
        AVG(cast(TRB as float)) as mean_trb,
        STDEV(cast(TRB as float)) as sd_trb
    from dbo.Deni_2425
)
select 
    FORMAT(mean_trb-1.96*sd_trb,'n2') as NrmlRng_Lower,
    FORMAT(mean_trb+1.96*sd_trb,'n2') as NrmlRng_Upper
from stats;

with stats as (
    select
        AVG(cast(AST as float)) as mean_ast,
        STDEV(cast(AST as float)) as sd_ast,
        COUNT(*) as n
    from dbo.Deni_2425
)
select
    FORMAT(mean_ast,'n2') as mean_ast,
    FORMAT(sd_ast,'n2') as sd_ast,
    FORMAT(mean_ast-1.96*(sd_ast/SQRT(n)),'n2') as CI_Lower,
    FORMAT(mean_ast+1.96*(sd_ast/sqrt(n)),'n2') as CI_Upper
from stats;

with stats as(
    select
        AVG(cast(AST as float)) as mean_ast,
        STDEV(cast(AST as float)) as sd_ast
    from dbo.Deni_2425
)
select 
    FORMAT(mean_ast-1.96*sd_ast,'n2') as NrmlRng_Lower,
    FORMAT(mean_ast+1.96*sd_ast,'n2') as NrmlRng_Upper
from stats;


select
    FORMAT(
        1.0*SUM(case when pts>=30 then 1 else 0 end)
        /COUNT(*),
        'p2'
    ) as probability_30pts_away
from dbo.Deni_2425
where Home=0;


USE Deni_Avdija_2425;
GO

CREATE OR ALTER VIEW dbo.vw_Deni_Advanced AS
SELECT
    -- All original columns you want to expose
    Gtm,
    [Date],
    Team,
    Home,
    Win,
    Opp,
    Portland_Score,
    Others_Score,
    GS,
    MP,
    FG,
    FGA,
    FG_prcnt,
    [_3P],
    [_3PA],
    [3p_prcnt],
    [_2P],
    [_2PA],
    [2p_prcnt],
    efg,
    FT,
    FTA,
    ORB,
    DRB,
    TRB,
    AST,
    STL,
    BLK,
    TOV,
    PF,
    PTS,
    GmSc,
    [Plus_Minus],

    -- Calculated columns
    pts / (2.0 * (fga + 0.44 * fta))                    AS TS_pct,
    (fga + 0.44 * fta + tov)                            AS poss_used,
    (fga + 0.44 * fta + tov) * 36.0 / NULLIF(MP, 0)     AS poss_used_per_36,
    pts / NULLIF((fga + 0.44 * fta + tov), 0)           AS pts_per_poss

FROM dbo.Deni_2425;
GO

select 
    gs,
    count(*) as games,
    sum(cast(win as int)) as wins,
    FORMAT(avg(cast(win as float)),'p2') as winrate
from dbo.Deni_2425
group by GS;

with stats as(
    select
        count(*) as n,
        avg(cast(pts as float)) as mean_pts,
        avg(cast(win as float)) as mean_win,
        avg(cast(pts as float) * cast(win as float)) as mean_pts_win,
        STDEV(cast(pts as float)) as sd_pts,
        STDEV(cast(win as float)) as sd_win
    from dbo.Deni_2425
)
select 
    FORMAT(mean_pts,'n2') as mean_pts,
    FORMAT(mean_win,'n2') as mean_win,
    FORMAT(
        (mean_pts_win-mean_pts*mean_win)/(sd_pts*sd_win),
        'n3'
    ) as corr_pts_win
from stats;

WITH stats AS (
    SELECT
        COUNT(*) AS n,
        AVG(CAST(GS AS FLOAT)) AS mean_gs,
        AVG(CAST(Win AS FLOAT)) AS mean_win,
        AVG(CAST(GS AS FLOAT) * CAST(Win AS FLOAT)) AS mean_gs_win,
        STDEV(CAST(GS AS FLOAT)) AS sd_gs,
        STDEV(CAST(Win AS FLOAT)) AS sd_win
    FROM dbo.Deni_2425
)
SELECT
    FORMAT(mean_gs, 'N2') AS mean_gs,
    FORMAT(mean_win, 'N2') AS mean_win,
    FORMAT(
        (mean_gs_win - mean_gs * mean_win) / (sd_gs * sd_win),
        'N3'
    ) AS corr_gs_win
FROM stats;

SELECT
    CASE WHEN _3P >= 3 THEN '3+ Threes' ELSE '0-2 Threes' END AS Three_Group,
    COUNT(*) AS games,
    SUM(CAST(Win AS INT)) AS wins,
    FORMAT(AVG(CAST(Win AS FLOAT)), 'P2') AS win_rate
FROM dbo.Deni_2425
GROUP BY CASE WHEN _3P >= 3 THEN '3+ Threes' ELSE '0-2 Threes' END;

WITH A AS (
    SELECT
        COUNT(*) AS n1,
        SUM(CAST(Win AS INT)) AS w1,
        AVG(CAST(Win AS FLOAT)) AS p1
    FROM dbo.Deni_2425
    WHERE _3P >= 3
),

B AS (
    SELECT
        COUNT(*) AS n2,
        SUM(CAST(Win AS INT)) AS w2,
        AVG(CAST(Win AS FLOAT)) AS p2
    FROM dbo.Deni_2425
    WHERE _3P < 3
),

ZTest AS (
    SELECT
        p1, p2, n1, n2,
        (p1 - p2) AS diff,
        SQRT( (p1*(1-p1))/n1 + (p2*(1-p2))/n2 ) AS se
    FROM A CROSS JOIN B
)

SELECT
    FORMAT(p1, 'P2') AS win_rate_3plus,
    FORMAT(p2, 'P2') AS win_rate_under3,
    FORMAT(diff, 'P2') AS difference,
    FORMAT(diff / se, 'N3') AS z_value,

    FORMAT( 2 * (1 - EXP(-POWER(diff / se, 2) / 2)), 'N4' ) AS approx_p_value

FROM ZTest;


with a as (
    select
        count(*) as n1,
        sum(cast(win as int)) as win1,
        avg(cast(win as float)) as p1_win,
        (1-AVG(CAST(win as float))) as p1_loss
    from dbo.Deni_2425
    where Portland_Score<=100
),
b as (
    select
        count(*) as n2,
        SUM(cast(win as int)) as win2,
        AVG(cast(win as float)) as p2_win,
        (1-AVG(cast(win as float))) as p2_loss
    from dbo.Deni_2425
    where Portland_Score>100
),

z_test as (
    select
        p1_loss,p2_loss,n1,n2,
        (p1_loss - p2_loss) as diff,
        SQRT((p1_loss*(1-p1_loss))/n1+(p2_loss*(1-p2_loss))/n2) as se
    from a cross join b
)

select 
    round(p1_loss*100,2) as loss_rate_u100,
    round(p2_loss*100,2) as loss_rate_o100,
    round((p1_loss-p2_loss)*100,2) as diff_prcnt,
    round(diff/se,3) as z_value
from z_test;
