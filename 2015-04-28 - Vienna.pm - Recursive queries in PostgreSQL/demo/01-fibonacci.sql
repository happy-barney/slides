-- -*- Mode: sql; sql-product: postgres -*-

-- termination clause: row limit
with recursive fib (n, prev, val) as (
  values (1, 0, 1)
  union all
  select n+1, val, prev + val from fib
)
select * from fib limit 10
;

-- termination clause: row limit
with recursive fib (n, prev, val) as (
  values (1, 0, 1)
  union all
  select n+1, val, prev + val from fib
)
select * from fib limit 10 offset 10
;

-- termination clause: iteration condition
with recursive fib (n, prev, val) as (
  values (1, 0, 1)
  union all
  select n+1, val, prev + val from fib where n < 10
)
select * from fib
;

