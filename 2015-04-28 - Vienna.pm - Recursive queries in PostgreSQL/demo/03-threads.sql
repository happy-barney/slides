-- -*- Mode: sql; sql-product: postgres -*-

/* Structure
   1
     2
     4
   3
     5
       8
         9
     6
       7
 */

with recursive
  forum (id, parent) as (
    values
    (1, null),
    (2, 1),
    (3, null),
    (4, 1),
    (5, 3),
    (6, 3),
    (7, 6),
    (8, 5),
    (9, 8)
  ),
  thread (head, depth, parent, id) as (
    select id, 0, parent, id from forum where parent is null
    union all
    select t.head, t.depth + 1, f.parent, f.id
      from thread t
      join forum f on (f.parent = t.id)
  )
  select * from thread
  ;
