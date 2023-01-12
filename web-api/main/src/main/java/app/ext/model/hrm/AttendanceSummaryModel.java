package app.ext.model.hrm;

/**
 * 考勤汇总表单
 * 
 * @author quyw
 * @date 2022/11/25
 */
public class AttendanceSummaryModel {

    public static final String kaoQinYue = "kaoQinYue"; // 考勤月份
    public static final String userName = "userName"; // 姓名
    public static final String userDept = "userDept"; // 部门

    public static final String countQingJiaTimes = "countQingJiaTimes";

    public static final String realWorkDays = "realWorkDays"; // 实际出勤（天）
    public static final String shouldWorkDays = "shouldWorkDays"; // 应出勤（天）
    public static final String queKaShu = "queKaShu"; // 缺卡次数
    public static final String chiDaoShu = "chiDaoShu"; // 迟到次数
    public static final String chiDaoTimes = "chiDaoTimes"; // 迟到时长（分钟）
    public static final String zaoTuiShu = "zaoTuiShu"; // 早退次数
    public static final String zaoTuiTimes = "zaoTuiTimes"; // 早退时长（分钟）

    public static final String shiJia = "shiJia"; // 请假-事假（天）
    public static final String bingJia = "bingJia"; // 请假-病假（天）
    public static final String hunJia = "hunJia"; // 请假-婚假（天）
    public static final String sangJia = "sangJia"; // 请假-丧假（天）
    public static final String chanJia = "chanJia"; // 请假-产假（天）
    public static final String chanJianJia = "chanJian"; // 请假-产检假（天）
    public static final String peiChanJia = "peiChanJia"; // 请假-陪产假（天）
    public static final String tiaoXiu = "tiaoXiu"; // 请假-调休（天）
    public static final String youxXinJia = "youxXinJia"; // 请假-有薪假（天）
    public static final String qiTaQingJia = "qiTaQingJia"; // 请假-其他（天）
    public static final String nianJia = "nianJia"; // 请假-年假（天）
    public static final String chuChai = "chuChai"; // 出差（天）

    public static final String jieJiaRiJiaBan = "jieJiaRiJiaBan"; // 节假日加班时长
    public static final String gongZuoRiJiaBan = "gongZuoRiJiaBan";// 工作日加班时长
    public static final String xiuXiRiJiaBan = "xiuXiRiJiaBan";// 休息日加班时长
    public static final String jieSuanXinZiJiaBan = "jieSuanXinZiJiaBan";// 结算薪资加班时长
    public static final String jieSuanTiaoXiuJiaBan = "jieSuanTiaoXiuJiaBan";// 结算调休加班时长
    public static final String jieSuanQiTaJiaBan = "jieSuanQiTaJiaBan";// 结算其他加班时长

}
