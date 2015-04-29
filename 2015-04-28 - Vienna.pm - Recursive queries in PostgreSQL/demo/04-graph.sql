-- -*- Mode: sql; sql-product: postgres -*-

with recursive
  graph (node_from, node_to, distance) as (
      values
      ('Prague', 'Brno', 2 ),
      ('Brno',   'Wien', 3 ),
      ('Brno',   'Bratislava', 1),
      ('Bratislava', 'Wien',   1)
  ),
  connections (node_from, node_to, distance) as (
    select node_from, node_to, distance from graph
    union
    select node_to, node_from, distance from graph
  ),
  all_connections (node_from, node_to, distance, via) as (
     select node_from
          , node_to
          , distance
          , ARRAY[]::text[] as via
       from connections
     union all
     select c.node_from
          , a.node_to
          , a.distance + c.distance
          , a.via || ARRAY[c.node_to]
       from connections c
       join all_connections a on (
             c.node_to    = a.node_from
         and c.node_from != a.node_to
         and c.node_from != ALL (a.via)
         and c.node_to   != ALL (a.via)
         )
  ),
  result (node_from, node_to, distance, via) as (
    select distinct
      node_from,
      node_to,
      first_value (distance) over shortest as distance,
      first_value (via)      over shortest as distance
    from all_connections
    window shortest as (partition by node_from, node_to order by distance)
  )
  select * from result order by 1, 2
  ;

