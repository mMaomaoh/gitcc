-- 报表高级数据源-钉钉考勤率统计

-- 部门-昨天
select 
  t2.percent as '出勤率',
  t2.orgFirstDept as '一级部门ID',
  t3.name as '一级部门名称'
from (
  select 
    round(sum(t1.attendance_days)/sum(t1.should_attendance_days),4) as percent,
    t1.orgFirstDept
  from iktwa_JiaYun_KaoQinMingXi t1
  where TO_DAYS(NOW()) - TO_DAYS(t1.dakaTimes) <= 1
  group by t1.orgFirstDept
) t2
left join h_org_department t3
     on t2.orgFirstDept = t3.id

-- 部门-本周
select 
  t2.percent as '出勤率',
  t2.orgFirstDept as '一级部门ID',
  t3.name as '一级部门名称'
from (
  select 
    round(sum(t1.attendance_days)/sum(t1.should_attendance_days),4) as percent,
    t1.orgFirstDept
  from iktwa_JiaYun_KaoQinMingXi t1
  where YEARWEEK(date_format(t1.dakaTimes,'%Y-%m-%d'),1) = YEARWEEK(NOW(),1)
  group by t1.orgFirstDept
) t2
left join h_org_department t3
     on t2.orgFirstDept = t3.id
     
-- 部门-上周
select 
  t2.percent as '出勤率',
  t2.orgFirstDept as '一级部门ID',
  t3.name as '一级部门名称'
from (
  select 
    round(sum(t1.attendance_days)/sum(t1.should_attendance_days),4) as percent,
    t1.orgFirstDept
  from iktwa_JiaYun_KaoQinMingXi t1
  where YEARWEEK(date_format(t1.dakaTimes,'%Y-%m-%d'),1) = YEARWEEK(DATE_SUB(NOW(), INTERVAL 1 WEEK),1)
  group by t1.orgFirstDept
) t2
left join h_org_department t3
     on t2.orgFirstDept = t3.id
    
-- 部门-本月
select 
  t2.percent as '出勤率',
  t2.orgFirstDept as '一级部门ID',
  t3.name as '一级部门名称'
from (
  select 
    round(sum(t1.attendance_days)/sum(t1.should_attendance_days),4) as percent,
    t1.orgFirstDept
  from iktwa_JiaYun_KaoQinMingXi t1
  where DATE_FORMAT(t1.dakaTimes, '%Y%m') = DATE_FORMAT(CURDATE(), '%Y%m')
  group by t1.orgFirstDept
) t2
left join h_org_department t3
     on t2.orgFirstDept = t3.id

-- 部门-上月
select 
  t2.percent as '出勤率',
  t2.orgFirstDept as '一级部门ID',
  t3.name as '一级部门名称'
from (
  select 
    round(sum(t1.attendance_days)/sum(t1.should_attendance_days),4) as percent,
    t1.orgFirstDept
  from iktwa_JiaYun_KaoQinMingXi t1
  where DATE_FORMAT(t1.dakaTimes, '%Y%m') = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 MONTH), '%Y%m')
  group by t1.orgFirstDept
) t2
left join h_org_department t3
     on t2.orgFirstDept = t3.id