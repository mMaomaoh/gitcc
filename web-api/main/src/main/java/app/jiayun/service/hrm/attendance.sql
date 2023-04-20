-- 报表高级数据源-钉钉考勤率统计
-- 当天
select * from iktwa_JiaYun_KaoQinMingXi t1 where TO_DAYS(t1.dakaTimes) = TO_DAYS(NOW());
-- 昨天
select * from iktwa_JiaYun_KaoQinMingXi t1 where TO_DAYS(NOW()) - TO_DAYS(t1.dakaTimes) <= 1;
-- 本月
select * from iktwa_JiaYun_KaoQinMingXi t1 where DATE_FORMAT(t1.dakaTimes, '%Y%m' ) = DATE_FORMAT(CURDATE(), '%Y%m' )
-- 本周
select * from iktwa_JiaYun_KaoQinMingXi t1 where YEARWEEK(date_format(t1.dakaTimes,'%Y-%m-%d')) = YEARWEEK(NOW());

-- 部门-昨天
select 
    t2.percent as '出勤率',
    t2.userDept as '部门ID',
    t3.name as '部门名称'
from (
    select 
        round(sum(t1.attendance_days)/sum(t1.should_attendance_days),4) as percent,
        t1.userDept,
        t1.belongOrg
    from iktwa_JiaYun_KaoQinMingXi t1
    where TO_DAYS(NOW()) - TO_DAYS(t1.dakaTimes) <= 1
    group by t1.userDept
) t2
left join h_org_department t3
    on t2.userDept = t3.id

-- 部门-本周
select 
    t2.percent as '出勤率',
    t2.userDept as '部门ID',
    t3.name as '部门名称'
from (
    select 
        round(sum(t1.attendance_days)/sum(t1.should_attendance_days),4) as percent,
        t1.userDept,
        t1.belongOrg
    from iktwa_JiaYun_KaoQinMingXi t1
    where YEARWEEK(date_format(t1.dakaTimes,'%Y-%m-%d')) = YEARWEEK(NOW())
    group by t1.userDept
) t2
left join h_org_department t3
    on t2.userDept = t3.id
    
-- 部门-本月
select 
    t2.percent as '出勤率',
    t2.userDept as '部门ID',
    t3.name as '部门名称'
from (
    select 
        round(sum(t1.attendance_days)/sum(t1.should_attendance_days),4) as percent,
        t1.userDept,
        t1.belongOrg
    from iktwa_JiaYun_KaoQinMingXi t1
    where DATE_FORMAT(t1.dakaTimes, '%Y%m') = DATE_FORMAT(CURDATE(), '%Y%m')
    group by t1.userDept
) t2
left join h_org_department t3
    on t2.userDept = t3.id

-- 组织-昨天
select 
    t2.percent as '出勤率',
    t4.id as '组织映射ID',
    t4.orgShortName as '组织名称'
from (
    select 
        round(sum(t1.attendance_days)/sum(t1.should_attendance_days),4) as percent,
        t1.userDept,
        t1.belongOrg
    from iktwa_JiaYun_KaoQinMingXi t1
    where TO_DAYS(NOW()) - TO_DAYS(t1.dakaTimes) <= 1
    group by t1.belongOrg
) t2
left join iktwa_JiaYun_OrgMapping t4
 on t4.id = t2.belongOrg

-- 组织-本周
select 
    t2.percent as '出勤率',
    t4.id as '组织映射ID',
    t4.orgShortName as '组织名称'
from (
    select 
        round(sum(t1.attendance_days)/sum(t1.should_attendance_days),4) as percent,
        t1.userDept,
        t1.belongOrg
    from iktwa_JiaYun_KaoQinMingXi t1
    where YEARWEEK(date_format(t1.dakaTimes,'%Y-%m-%d')) = YEARWEEK(NOW())
    group by t1.belongOrg
) t2
left join iktwa_JiaYun_OrgMapping t4
 on t4.id = t2.belongOrg
 
-- 组织-本月
select 
    t2.percent as '出勤率',
    t4.id as '组织映射ID',
    t4.orgShortName as '组织名称'
from (
    select 
        round(sum(t1.attendance_days)/sum(t1.should_attendance_days),4) as percent,
        t1.userDept,
        t1.belongOrg
    from iktwa_JiaYun_KaoQinMingXi t1
    where DATE_FORMAT(t1.dakaTimes, '%Y%m') = DATE_FORMAT(CURDATE(), '%Y%m')
    group by t1.belongOrg
) t2
left join iktwa_JiaYun_OrgMapping t4
 on t4.id = t2.belongOrg
