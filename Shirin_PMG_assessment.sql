select * from marketing_data;
select * from store_revenue;

#Question0
select * from marketing_data limit 2;

#Question1
select SUM(clicks) as 'Total Clicks' from marketing_data;

#Question2
select store_location as geo, SUM(revenue) as 'Total Revenue' FROM store_revenue
group by store_location;

#Question3
SELECT COALESCE(md.date, sr.date) as date, 
COALESCE(md.geo, sr.geo) AS geo,
COALESCE(md.impressions,0) AS impressions,
COALESCE(md.clicks,0) AS clicks,
COALESCE(sr.revenue,0) AS revenue
FROM marketing_data as md
FULL JOIN (SELECT date, substr(store_location,15,2) as geo, sum(revenue) as revenue from store_revenue group by date, geo) sr
ON  md.date = sr.date
AND sr.geo = md.geo
ORDER BY md.date, sr.date;  

#Question4
SELECT COALESCE(geo, 'Other') as geo, avg(ctr), avg(revenue), avg(rpc)
from (SELECT
COALESCE(md.date, sr.date) as date, 
COALESCE(md.geo, sr.geo) AS geo,
COALESCE(md.impressions,0) AS impressions,
COALESCE(md.clicks,0) AS clicks,
COALESCE(sr.revenue,0) AS revenue,
ROUND(CAST(md.clicks AS float)/CAST(md.impressions AS float),3) as CTR,
COALESCE(sr.revenue/md.clicks,0) as RPC
FROM marketing_data md
FULL JOIN (SELECT date, substr(store_location,15,2) as geo, sum(revenue) as revenue from store_revenue group by date, store_location) sr
ON  md.date = sr.date
AND sr.geo = md.geo) AS X
GROUP BY geo;
#The store at CA is the most efficient, as the click through rate(CTR) is 1.8% and average revenue per click(Conversion rate) is much higher compared to the other states which is 1304.4
#If we look at Average revenue, it is the highest(47047.4) as well amongst other stores.
#Hence, store at CA is the most efficient store here

#Question5
SELECT RANK() OVER(ORDER BY revenue DESC) AS rank, geo, revenue
from (SELECT store_location as geo, sum(revenue) as revenue from store_revenue
group by store_location);
