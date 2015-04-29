-- -*- Mode: sql; sql-product: postgres -*-

-- Math taken from: http://ncalculators.com/math-worksheets/iteration-method-numerical-analysis.htm
-- x^3 + x^2 = 1
-- => x[i] = 1/sqrt(x[i-1])

with recursive
  iter (n, res, diff) as (
    values (1, 0.5, 1.0)
    union
    select d.n, d.res, d.diff
    from (
      select c.n, c.res, abs (c.res - c.prev) as diff
      from (
         select p.n +1 as n
              , 1 / sqrt (1 + p.res) as res
              , p.res as prev
           from iter p
      ) c
    ) d
    where d.diff > 0.0000001
  ),
  res (n, res) as (
    select n, res from iter order by diff limit 1
  )
  select * from iter;
