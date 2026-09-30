# texas-freeze-2021

How Winter Storm Uri grounded five Texas airports — a flight and weather analysis built with dbt, pandas and seaborn.

## The story

In February 2021 an Arctic outbreak pushed Texas below freezing for more than a week. On 15 February at 01:20 the state grid operator (ERCOT) began rolling blackouts that lasted until 19 February. Around 4.5 million homes lost power.

This project looks at what that did to air travel. I took every scheduled departure from the five busiest airports in the affected area — **DFW, IAH, AUS, SAT and MAF** — for January to March 2021, joined it to daily weather at each airport, and asked one question: *was it the cold that stopped the flights, or something else?*

The short answer: the cold opened the door, but the storm and the blackout walked through it. Airports kept flying through several sub-zero days. Cancellations only spiked in the six days that line up with the winter storm and the grid failure — and recovered a day *before* the freeze ended.

## Data

| Source | What | Grain |
|---|---|---|
| US Bureau of Transportation Statistics | On-time performance — every scheduled flight, with delay and cancellation flags | one row per flight |
| Meteostat | Daily and hourly weather per airport station | one row per airport per day / hour |

Period: 1 Jan – 31 Mar 2021. Airports: DFW (Dallas/Fort Worth), IAH (Houston), AUS (Austin), SAT (San Antonio), MAF (Midland).

## Stack

- **PostgreSQL** — raw and prepared tables
- **dbt** — transformation layer; `mart_daily_airport` aggregates flights to one row per airport per day and joins the same day's weather. Tests cover nulls, accepted airport codes and uniqueness of (airport, date).
- **pandas + SQLAlchemy** — load the mart into Python
- **seaborn / matplotlib** — charts
- **Jupyter** — one notebook, one section per insight

## Insights

### 1. The schedule barely changed

Scheduled departures dropped only 0–11% during the storm days (IAH actually rose 3%). Airlines did not cut flights ahead of the storm — they kept the timetable and cancelled day-of. The damage is in the cancellation rate, not the schedule.

### 2. Cancellations are where the damage is

Daily cancellation rate per airport for February, with the ERCOT grid-emergency window shaded. Every airport spikes in the same window, 14–19 February.

### 3. How cold, and for how long

Every airport bottomed out on 15–16 February — DFW at −18.3 °C, MAF −18.8 °C, even Houston at −10.5 °C. Duration mattered more than the minimum: DFW spent 12 of February's 28 days below freezing, AUS and SAT 9, MAF 16.

### 4. Cancellations followed the storm, not the temperature

DFW was below freezing for 12 days (9–20 Feb), but cancellations only spiked on 6 of them (14–19 Feb). The airport kept flying through five sub-zero days before the storm, and recovered on 19 Feb, a day before the freeze ended. The cancellation window matches the winter storm and the ERCOT blackout almost exactly — that is what grounded the airport, not the cold.

### 5. Cold was necessary, not sufficient

Scatter of daily minimum temperature against cancellation rate, all airports, all 90 days. Above 0 °C there are essentially no cancellations. Below 0 °C cancellations appear — but only on the storm days. Many sub-zero airport-days had almost none.

*(More insights in progress: recovery speed per airport, airline share, top routes, delay by hour of day.)*

## Repository layout

```
dbt/
  models/
    prep/          staging models (flights, airports, weather)
    mart/          mart_daily_airport.sql + schema.yml
notebooks/
  analysis.ipynb   the insights, one section each
README.md
```

## How to run

1. Load the raw BTS and Meteostat tables into Postgres.
2. `dbt run` then `dbt test` inside `dbt/`.
3. Open `notebooks/analysis.ipynb`, point the SQLAlchemy connection string at your database, run top to bottom.

## Author

Payam Zahedi
