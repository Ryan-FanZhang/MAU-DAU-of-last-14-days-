SELECT t1.dt,
count
(
DISTINCT CASE WHEN to_timestamp(t2.dt, 'yyyyMMdd') BETWEEN to_timestamp(t1.dt, 'yyyyMMdd') - interval 29 DAY 
AND to_timestamp(t1.dt, 'yyyyMMdd') THEN t2.uid ELSE NULL END
) AS month_act_num,
COUNT(distinct t1.uid) day_act_num
FROM
  (
	  SELECT substr(CAST(ds AS string),1,8) dt,
	  uid
	   FROM beacon_olap.ieg_gameplus_gameplus_user_action_report_kk
	   WHERE 
		 substr(CAST(ds AS string),1,8) >=cast(substring(from_unixtime(unix_timestamp(now() - interval 14 DAY), 'yyyyMMdd'),1,8) AS string)
		 AND operid IN (
		        '1003000110601',
						'1101000110101',
						'1003000110302',
						'1102000110101',
						'1801000110101', -- 群组频道列表曝光
						'1802000110101', --	群组频道聊天页面曝光"
						'1901000110101', --群组频道列表曝光
						'1902000110101',--群组频道聊天页面曝光
                         '1903000110101'
)
	   GROUP BY substr(CAST(ds AS string),1,8),uid
   ) t1
LEFT JOIN
  (
  SELECT substr(CAST(ds AS string),1,8) dt,
          uid
   FROM beacon_olap.ieg_gameplus_gameplus_user_action_report_kk
   WHERE 
     substr(CAST(ds AS string),1,8) >=cast(substring(from_unixtime(unix_timestamp(now() - interval 43 DAY), 'yyyyMMdd'),1,8) AS string)
     AND operid IN ('1003000110601',
						'1101000110101',
						'1003000110302',
						'1102000110101',
						'1801000110101', -- 群组频道列表曝光
						'1802000110101', -- 群组频道聊天页面曝光"
						'1901000110101',-- 群组频道列表曝光
            '1902000110101', --群组频道聊天页面曝光
             '1903000110101'
					)
   GROUP BY substr(CAST(ds AS string),1,8),
            uid
	) t2 ON 1=1
GROUP BY t1.dt
ORDER BY t1.dt DESC;