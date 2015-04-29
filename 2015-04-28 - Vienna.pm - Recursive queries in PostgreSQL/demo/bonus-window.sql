-- -*- Mode: sql; sql-product: postgres -*-

with
  city (country, name, pop) as (
    values
    ('AT', 'Wien',      1800000),
    ('AT', 'Graz',       270000),
    ('AT', 'Linz',       200000),
    ('AT', 'Salzburg',   150000),
    ('CZ', 'Praha',     1250000),
    ('CZ', 'Brno',       380000),
    ('CZ', 'Ostrava',    170000),
    ('CZ', 'Plzen',      140000),
    ('SK', 'Bratislava', 460000),
    ('SK', 'Kosice',     250000),
    ('SK', 'Presov',      90000),
    ('SK', 'Zilina',      85000)
  ),
  select_1st as (
    select
        country,
        first_value (name) over order_by_pop,
        first_value (pop)  over order_by_pop
      from city
      window order_by_pop as (partition by country order by pop desc )
  ),
  select_2nd as (
    select
        country,
        nth_value (name, 2) over order_by_pop as name,
        nth_value (pop, 2)  over order_by_pop as pop
      from city
      window order_by_pop as (partition by country order by pop desc )
  )
  select * from select_2nd
;

