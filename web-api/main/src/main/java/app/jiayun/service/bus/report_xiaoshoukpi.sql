-- 本月-客户跟进完成率
select 
  u.name as '姓名',
  count(t1.id) as '完成数量',
  round(count(t1.id)/t.khbf_month_sum,4) as '完成率',
  (case when (count(t1.id)-t.khbf_month_sum)>=0
        then 100*t.khbf_month_percent
        else (100+(count(t1.id)-t.khbf_month_sum)*2.2) * t.khbf_month_percent
        end) as '得分'
from i8gdl_JiaYun_XiaoShouJXZB t
left join h_org_user u
     on u.id=t.userName
left join i8gdl_JiaYun_KeHuGenJin t1 
     on t.userName=t1.creater
     and date_format(t.month,'%Y-%m')=date_format(t1.genJinTime,'%Y-%m')
     and t1.sequenceStatus='COMPLETED'
     and (t1.genJinLeiXing='客户' or t1.genJinLeiXing='线索')
     and t1.genJinXiaoGuo in('有效沟通','产生商机')
where 
  date_format(t.month,'%Y-%m')=date_format(NOW(),'%Y-%m')
group by t.userName

-- 本月-新增有效客户量
select 
  u.name as '姓名',
  count(t1.id) as '完成数量',
  round(count(t1.id)/t.khxz_month_sum,4) as '完成率',
  (case when (count(t1.id)-t.khxz_month_sum)>0 
        then 100*t.khxz_month_percent
        else (100+(count(t1.id)-t.khxz_month_sum)*5) * t.khxz_month_percent
        end) as '得分'
from i8gdl_JiaYun_XiaoShouJXZB t
left join h_org_user u
     on u.id=t.userName
left join i8gdl_JiaYun_KeHuGuanLi t1
     on t.userName=t1.creater
     and date_format(t.month,'%Y-%m')=date_format(t1.createdTime,'%Y-%m')
     and t1.sequenceStatus='COMPLETED'
where 
  date_format(t.month,'%Y-%m')=date_format(NOW(),'%Y-%m')
group by t.userName

-- 有效商机+成交
select 
  d.uname as '姓名',
  d.ddsl as '订单数量',
  d.dddf as '订单得分',
  d.sjsl as '商机数量',
  d.sjdf as '商机得分',
  (d.dddf+d.sjdf)*percent as '总分'
from(
    select 
      u.name as uname,
      t.yxsjAndKh_percent as percent,
      count(t1.id) as ddsl,
      (case when count(t1.id)>0 
            then 100
            else 0
            end) as dddf,
      count(t2.id) as sjsl,
      (case when count(t2.id)>0 
            then count(t2.id)*30
            else 0
            end) as sjdf
    from i8gdl_JiaYun_XiaoShouJXZB t
    left join h_org_user u 
         on u.id=t.userName
    left join i8gdl_JiaYun_DingDanGuanLi t1
         on t.userName=t1.creater
         and date_format(t.month,'%Y-%m')=date_format(t1.createdTime,'%Y-%m')
    left join i8gdl_JiaYun_ShangJiGuanLi t2
         on t.userName=t2.creater
         and date_format(t.month,'%Y-%m')=date_format(t2.createdTime,'%Y-%m')
         and t2.shangJiZhuangTai='有效'
    where 
        date_format(t.month,'%Y-%m')=date_format(NOW(),'%Y-%m')
    group by t.userName
) d

