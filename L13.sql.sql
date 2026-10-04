with cust_info as (
    select player_id,
    event_date,
    games_played, 
    lead(event_date,1) over (partition by player_id order by event_date) as next_date
    from Activity
),
cal_info as (
    select count(*) as player_count,
    cc.player_id
    from cust_info cc
    WHERE cc.next_date = DATE_ADD(cc.event_date, INTERVAL 1 DAY)
      AND cc.event_date = (
          SELECT MIN(event_date)
          FROM Activity a
          WHERE a.player_id = cc.player_id
      )    GROUP BY cc.player_id
),
tot_cnt as(
    select count(distinct player_id) as tot from Activity 
)
select round(COALESCE(SUM(ci.player_count), 0) / cc.tot,2) as fraction
from tot_cnt cc left join cal_info ci
on 1=1;