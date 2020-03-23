select 
main_tab.customer_id as customer_id,
min(main_tab.create_date) as first_create_date,
       sum(case
             when main_tab.create_date = filter_dates.create_date_1 then
              1
             else
              0
           end) as cnt_orders_1_day,
       sum(case
             when main_tab.create_date = filter_dates.create_date_1 then
              main_tab.amount
             else
              0
           end) as sum_orders_1_day,
date_add( MIN(create_date), interval '5'  DAY) as first_day_plus_5,
       sum(case
             when main_tab.create_date = filter_dates.create_date_5 then
              1
             else
              0
           end) as cnt_orders_5_day,
       sum(case
             when main_tab.create_date = filter_dates.create_date_5 then
              main_tab.amount
             else
              0
           end) as sum_orders_5_day
  FROM orders_2 main_tab
  join (select customer_id as customer_id,
               min(STR_TO_DATE(create_date, '%Y-%m-%d')) as create_date_1,
               date_add(min(STR_TO_DATE(create_date, '%Y-%m-%d')), interval '5'  DAY) as create_date_5
          FROM orders_2
         group by customer_id) filter_dates
    on main_tab.customer_id = filter_dates.customer_id
   and (main_tab.create_date = filter_dates.create_date_1 or
       main_tab.create_date = filter_dates.create_date_5)
 group by main_tab.customer_id 
 order by main_tab.customer_id;