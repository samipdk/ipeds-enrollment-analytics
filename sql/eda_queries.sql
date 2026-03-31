-- ============================================================
-- IPEDS Enrollment & Retention Analysis
-- SQL EDA — Business Questions
-- Author: Samip Thakuri
-- Database: ipeds.db (90 Midwest public universities, 2019-2024)
-- ============================================================

-- Q1: Which Midwest public universities have the highest graduation rates?
SELECT 
    institution_name,
    state,
    size_label,
    locale_simple,
    retention_rate,
    grad_rate_6yr,
    stufac_ratio
FROM ipeds_main
WHERE year = 2024
  AND grad_rate_6yr IS NOT NULL
ORDER BY grad_rate_6yr DESC
LIMIT 10;

-- FINDINGS — Q1:
-- 1. United States Air Force Academy leads the region at 87.5% grad rate
--    with the lowest student-faculty ratio (7:1) — highly selective admissions
--    and structured environment drive outsized outcomes
-- 2. Colorado dominates the top 10 with 3 institutions (Air Force Academy,
--    Colorado School of Mines, CU Boulder) — suggesting strong state-level
--    academic infrastructure and selectivity
-- 3. Every top 10 institution has a retention rate of 85% or above —
--    confirming retention is a leading indicator of graduation success
-- 4. Institution size is mixed — both very small (Air Force Academy, Truman State)
--    and very large (Iowa State, Mizzou) appear in the top 10, suggesting
--    size alone does not determine outcomes
-- 5. Student-faculty ratio ranges from 7 to 19 across top performers —
--    lower ratios (Air Force Academy at 7, Truman State at 12) correlate
--    with higher graduation rates, supporting the case for instructional investment
--
-- PPT SLIDE IMPLICATION:
-- "Top performers share one trait: retention rates above 85%.
--  Size and location vary — but keeping students is what drives graduation."
-- ============================================================

-- Q2. Which states have seen the biggest enrollment decline since 2019, and are outcomes declining with enrollment
SELECT
    state,
    year,
    COUNT(DISTINCT unitid)          AS institutions,
    ROUND(AVG(entering_students),0) AS avg_enrollment,
    ROUND(AVG(retention_rate),1)    AS avg_retention,
    ROUND(AVG(grad_rate_6yr),1)     AS avg_grad_rate
FROM ipeds_main
WHERE entering_students IS NOT NULL
GROUP BY state, year
ORDER BY state, year;

-- FINDINGS — Q2:
-- 1. Colorado had the steepest enrollment drop during COVID —
--    avg enrollment fell from 2,914 (2019) to 2,576 (2021), a 12% decline —
--    but recovered to 2,923 by 2024, nearly back to pre-COVID levels
-- 2. Iowa is the most stable state — enrollment barely moved across 6 years
--    (5,316 in 2019 vs 5,419 in 2024) and consistently leads on both
--    retention (86.7%) and grad rate (72.6%)
-- 3. Kansas showed a dip in 2020-2021 but recovered strongly —
--    avg enrollment grew from 2,886 (2019) to 3,015 (2024), the only
--    state to end higher than it started
-- 4. Nebraska is the most concerning trend — enrollment declined from
--    2,171 (2019) to 1,868 (2023) and has not recovered, while grad
--    rate also slipped from 50.2% to 47.7%
-- 5. Oklahoma has the lowest outcomes across all years — retention
--    consistently below 67% and grad rate stuck around 35% —
--    enrollment decline during COVID (2021: 1,772) coincided with
--    the lowest retention rate in the dataset (61.9%)
-- 6. Critically: outcomes did NOT decline proportionally with enrollment
--    in most states — grad rates held steady or improved during COVID,
--    suggesting the students who stayed were more engaged
--
-- PPT SLIDE IMPLICATION:
-- "Enrollment recovered post-COVID in most states — but Nebraska
--  is the exception. Lower enrollment there has not bounced back,
--  and outcomes are slipping with it."
-- ============================================================

--Q3 which institution lost the most students between 2019-2024?

WITH base AS (
    SELECT unitid, institution_name, state,
           entering_students AS enroll_2019
    FROM ipeds_main
    WHERE year = 2019
),
latest AS (
    SELECT unitid,
           entering_students AS enroll_2024
    FROM ipeds_main
    WHERE year = 2024
)
SELECT 
    b.institution_name,
    b.state,
    b.enroll_2019,
    l.enroll_2024,
    ROUND((l.enroll_2024 - b.enroll_2019) * 100.0 / b.enroll_2019, 1) AS pct_change
FROM base b
JOIN latest l ON b.unitid = l.unitid
WHERE b.enroll_2019 IS NOT NULL 
  AND l.enroll_2024 IS NOT NULL
ORDER BY pct_change ASC
LIMIT 10;

-- FINDINGS — Q3:
-- 1. Missouri Western State University suffered the most severe decline
--    in the region — losing 53.3% of entering students (1,613 → 753)
--    over just 5 years, more than half its enrollment gone
-- 2. Missouri dominates the decline list with 4 of the top 10 hardest-hit
--    institutions (Missouri Western, Harris-Stowe, Lincoln University,
--    University of Central Missouri) — pointing to a state-level crisis
--    not just isolated institutional problems
-- 3. Harris-Stowe State University (-42.4%) and Lincoln University (-39.4%)
--    are both HBCUs in Missouri — their decline signals equity implications
--    beyond just enrollment numbers
-- 4. Fort Hays State University in Kansas dropped 38.9% (3,993 → 2,441) —
--    the largest absolute loss in the top 10 at 1,552 students
-- 5. No state is immune — CO, KS, MO, NE, and OK all appear in the
--    top 10 decline list, confirming this is a regional pattern
--    not isolated to one state
-- 6. Colorado State University-Global Campus (-21.9%) is notable —
--    an online-focused institution losing enrollment signals even
--    the digital pivot did not protect all institutions post-COVID
--
-- PPT SLIDE IMPLICATION:
-- "Missouri is facing a enrollment crisis — 4 institutions lost
--  between 36% and 53% of students since 2019. This is not a COVID
--  blip — it is a structural decline requiring urgent policy attention."
-- ============================================================

-- Q4: How wide is the retention rate gap between states which institutions are at most risk?
SELECT
    state,
    COUNT(DISTINCT unitid)                              AS institutions,
    ROUND(MIN(retention_rate),1)                        AS min_retention,
    ROUND(AVG(retention_rate),1)                        AS avg_retention,
    ROUND(MAX(retention_rate),1)                        AS max_retention,
    ROUND(MAX(retention_rate) - MIN(retention_rate),1)  AS retention_gap,
    COUNT(CASE WHEN retention_rate < 60 THEN 1 END)     AS at_risk_count
FROM ipeds_main
WHERE year = 2024
  AND retention_rate IS NOT NULL
GROUP BY state
ORDER BY avg_retention DESC;

-- FINDINGS — Q4:
-- 1. Iowa is the most consistent state — retention ranges only 8 points
--    (82% to 90%) with zero at-risk institutions, confirming Iowa's
--    universities operate at uniformly high standards
-- 2. Colorado has the widest retention gap in the region at 100 points
--    (0% to 100%) — the 0% floor is likely a data suppression or
--    reporting issue for one institution, but even excluding that,
--    Colorado's spread signals high variability across its 19 institutions
-- 3. Missouri has the highest absolute retention (100% max) but also
--    1 at-risk institution below 60% — its 46-point gap reflects
--    a two-tier system where flagship universities perform well
--    but smaller regional institutions struggle to retain students
-- 4. Oklahoma has 2 at-risk institutions and the lowest avg retention
--    at 66.9% — consistent with its position at the bottom of
--    graduation rates in Q1 and Q2
-- 5. Kansas shows zero at-risk institutions despite an 18-point gap —
--    all 7 institutions retain above 68%, suggesting a solid floor
--    even if ceiling varies
-- 6. Nebraska's 63% minimum with zero at-risk is borderline —
--    institutions just above 60% are vulnerable and worth monitoring
--
-- DATA NOTE:
-- Colorado's 0% minimum retention is flagged as a likely reporting
-- anomaly and should be verified before including in the PPT report.
--
-- PPT SLIDE IMPLICATION:
-- "Iowa sets the benchmark — tight retention range, no at-risk
--  institutions, consistent outcomes. Oklahoma and Missouri need
--  targeted intervention at their lowest-performing institutions."
-- ===============================

-- Q5: Did COVID permanently damage enrollment and outcomes?
SELECT
    CASE 
        WHEN year = 2019                THEN '1. Pre-COVID (2019)'
        WHEN year IN (2020, 2021)       THEN '2. COVID Years (2020-21)'
        WHEN year IN (2022, 2023, 2024) THEN '3. Post-COVID (2022-24)'
    END                                         AS period,
    ROUND(AVG(entering_students),0)             AS avg_enrollment,
    ROUND(AVG(retention_rate),1)                AS avg_retention,
    ROUND(AVG(grad_rate_6yr),1)                 AS avg_grad_rate,
    COUNT(DISTINCT unitid)                      AS institutions
FROM ipeds_main
WHERE entering_students IS NOT NULL
GROUP BY period
ORDER BY period;

-- FINDINGS — Q5:
-- 1. Enrollment dropped sharply during COVID — avg entering students
--    fell from 2,652 (2019) to 2,445 (2020-21), a 7.8% regional decline —
--    but recovered to 2,627 by the post-COVID period, nearly back
--    to pre-COVID levels
-- 2. Retention rate was remarkably resilient — only dropped 0.7 points
--    during COVID (72.0 → 71.3) and recovered to 71.8 post-COVID —
--    suggesting universities adapted quickly to remote learning
-- 3. Most surprising finding: graduation rates actually IMPROVED during
--    COVID (44.9 → 45.8) and held at 45.8 post-COVID — the students
--    who stayed enrolled during the pandemic completed at higher rates,
--    likely because less motivated students stopped out
-- 4. Institution count grew from 67 to 75 across periods — more
--    institutions reporting complete data post-COVID, which may
--    partially explain the stable averages
-- 5. The overall picture is one of regional resilience — Midwest public
--    universities absorbed a significant enrollment shock without
--    a corresponding collapse in outcomes
--
-- PPT SLIDE IMPLICATION:
-- "COVID caused a 7.8% enrollment drop — but outcomes held.
--  Graduation rates actually improved during the pandemic years,
--  suggesting the institutions that invested in student support
--  during COVID are reaping the benefits now."
-- ============================================================

-- Q6: Do larger universities produce better graduation outcomes?
-- ============================================================
SELECT
    size_label,
    COUNT(DISTINCT unitid)          AS institutions,
    ROUND(AVG(entering_students),0) AS avg_enrollment,
    ROUND(AVG(stufac_ratio),1)      AS avg_stufac_ratio,
    ROUND(AVG(retention_rate),1)    AS avg_retention,
    ROUND(AVG(grad_rate_6yr),1)     AS avg_grad_rate
FROM ipeds_main
WHERE year = 2024
GROUP BY size_label
ORDER BY avg_grad_rate DESC;

-- FINDINGS — Q6:
-- 1. Larger universities dramatically outperform smaller ones —
--    institutions with 20,000+ students achieve an avg grad rate
--    of 65.8% vs just 39.6% for institutions with 1,000-4,999 students —
--    a 26 percentage point gap driven by resources, selectivity,
--    and academic support infrastructure
-- 2. The retention story is even starker — large institutions (20,000+)
--    retain 86.9% of students vs 66.4% at small institutions (1,000-4,999)
--    a 20 point gap confirming that keeping students is where
--    small institutions most need to invest
-- 3. Student-faculty ratio does NOT explain the gap — large institutions
--    have HIGHER ratios (18.3) than small ones (14.2), yet dramatically
--    better outcomes — suggesting faculty access alone is not the
--    driver of graduation success
-- 4. The Under 1,000 category (2 institutions) shows the lowest grad
--    rate at 20% with missing retention data — these institutions
--    are likely community college pipelines or highly specialized
--    programs where 6-year bachelor's rates are not meaningful metrics
-- 5. Mid-size institutions (10,000-19,999) underperform their size —
--    avg grad rate of 40.8% is lower than small institutions (39.6%
--    is close) suggesting mid-size schools face the worst of both
--    worlds — too large for personal attention, too small for
--    flagship resources
--
-- PPT SLIDE IMPLICATION:
-- "Size matters — but not because of faculty ratios.
--  Large universities retain 87% of students vs 66% at small ones.
--  The gap is in student support systems, not classroom size."
-- ============================================================
