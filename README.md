# Enrollment & Outcome Intelligence — Midwest Universities

**Analyzing enrollment trends, retention rates, and 6-year graduation outcomes  
across 90 public universities in 6 Midwest states (2019–2024)**

---

## Live Dashboard
[View Interactive Power BI Dashboard →](https://app.powerbi.com/view?r=eyJrIjoiZmFjYjhkM2UtOWI2Ni00ZDhjLThkNWMtYjZmYWQ5MzI2OWRlIiwidCI6ImUwNWI2YjNmLTE5ODAtNGIyNC04NjM3LTU4MDc3MWY0NGRlZSIsImMiOjN9)

---

## Business Problem
Enrollment declines and retention gaps cost universities millions in tuition revenue annually.  
This project analyzes IPEDS data to identify which institutional factors most strongly predict  
student success — and how Midwest universities can benchmark their performance against peers.

---

## Key Findings

| Finding | Insight |
|---|---|
| Iowa leads the region | 72.6% avg graduation rate — 37.5pp above Oklahoma |
| Missouri in crisis | 4 institutions lost 36–53% of students since 2019 |
| COVID resilience | Enrollment dropped 7.8% but grad rates actually improved |
| Size drives outcomes | Large universities outperform small ones by 26pp on grad rate |
| Retention predicts everything | Every top-10 institution retains 85%+ of students |

---

## Project Structure
```
├── notebook/
│   └── 01_etl.ipynb           # ETL pipeline — load, clean, merge 18 IPEDS CSV files → SQLite
├── sql/
│   └── eda_queries.sql        # 6 business questions answered with documented findings
├── report/
│   ├── IPEDS_Midwest_Analysis.pptx    # Executive presentation — 11 slides
│   └── charts/                        # 6 exported PNG charts for research brief
└── Data/
    └── dictionaries/          # IPEDS data dictionaries (HD, EF-D, GR surveys)
```

---

## Analytical Pipeline

| Step | Tool | Description |
|---|---|---|
| 01 ETL | Python + Pandas | Load 18 IPEDS CSVs, filter to Midwest public 4-year, merge → SQLite |
| 02 SQL EDA | DBeaver + SQLite | 6 business questions with findings documented in SQL comments |
| 03 Modeling | Python + Scikit-learn | Linear regression + Random Forest — graduation rate drivers |
| 04 Dashboard | Power BI | 3-page interactive dashboard published publicly |
| 05 Report | PowerPoint | 11-slide executive presentation with charts and recommendations |

---

## Data Source

**IPEDS Complete Data Files — National Center for Education Statistics (NCES)**

| Survey | File | Variables used |
|---|---|---|
| Institutional Characteristics | HD{year}.csv | Institution name, state, size, urbanization |
| Fall Enrollment | EF{year}D.csv | Retention rate, student-faculty ratio, cohort size |
| Graduation Rates | GR{year}.csv | 6-year completion rate |

- Years: 2019–2024
- Scope: Public 4-year universities in KS, MO, NE, OK, IA, CO
- Total institutions: 90
- Total rows in analytical dataset: 468

---

## Tech Stack

![Python](https://img.shields.io/badge/Python-3.13-blue)
![SQL](https://img.shields.io/badge/SQL-SQLite-lightgrey)
![Power BI](https://img.shields.io/badge/Power%20BI-PL--300-yellow)
![IPEDS](https://img.shields.io/badge/Data-IPEDS%2FNCES-green)

`Python` · `Pandas` · `Scikit-learn` · `SQLite` · `SQL` · `DBeaver` · `Power BI (PL-300)` · `Matplotlib` · `Seaborn`

---

## SQL Business Questions

1. Which Midwest public universities have the highest 6-year graduation rates?
2. Which states have seen the biggest enrollment decline since 2019?
3. Which institutions lost the most students between 2019 and 2024?
4. How wide is the retention rate gap between states?
5. Did COVID permanently damage enrollment and outcomes?
6. Do larger universities produce better graduation outcomes?

---

## Dashboard Pages

| Page | Focus | Key Visuals |
|---|---|---|
| Regional Overview | State-level comparison | Choropleth map, grad rate bar chart, dynamic insight cards |
| Enrollment Trends | Institution-level trends | Multi-line chart, Top 10 / Bottom 10 toggle, scatter plot, benchmarking table |
| Institution Benchmarking | Peer comparison | Drill-through scatter, ranked table with conditional formatting |

---

## Author

**Samip Thakuri**  
Wichita State University · MS Business Analytics (STEM) · Expected May 2026  

[![LinkedIn](https://img.shields.io/badge/LinkedIn-samipkhthak-blue)](https://www.linkedin.com/in/samipkhthak/)
```

---

**After saving:**

1. Replace `YOUR_POWER_BI_PUBLIC_URL_HERE` with your actual dashboard link
2. Save the file as `README.md` (not `.txt`)
3. Run these three commands:
```
git add .
git commit -m "Add professional README with dashboard link and project documentation"
git push
