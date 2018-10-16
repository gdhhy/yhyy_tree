
insert into member (member_id,member_no,user_name,real_name,phone,id_card,parent_no,cur_level,child_depth,direct_count,child_total,member_info)

select userID,云科号,用户名,姓名 , 手机号码,身份证号码,推荐人云科号,所在层级,下级层数,直接下级人数,全部下级人数,
    CONCAT('{"基本信息":{"性别":"',`性别`,'","等级":"',`等级`,'","注册时间":"',`注册时间`,'","邮箱":"',`邮箱`,'","推荐人姓名":"',`推荐人姓名`,'","会员认证":"', ifnull(`会员认证`,''),
           '","归属省份":"',`归属省份`,'","归属城市":"',`归属城市`,'","运营商":"',`运营商`,
           '","注册填写省份":"',`注册填写省份`,'","注册填写城市":"',`注册填城市`,'","注册填写县级":"',`注册填县级`,'","注册填写省份":"',`注册填写省份`,'","注册填写省份":"',
           `注册填写省份`,'","运营商":"',`运营商`,'"},',
           '"资金":{"银行名称":"',银行名称,'","银行卡号":"',银行卡号,'","云科盾":',云科盾,',"用户余额（云科金盾）":',`用户余额(云科金盾)`,
           ',"云积分（共享积分）":',`云积分(共享积分)`,',"充值金额":',`充值金额`,',"提现金额":',`提现金额`,',"出款手续费":',`出款手续费`,',"出款金额":',`出款金额`,
           ',"获得下线补贴金额":',`获得下线升级补贴金额`,',"获得补贴次数":',`获得补贴次数`,',"获得下线升级补贴/消费分润共享积分":',`获得下线升级补贴/消费分润共享积分`,
           ',"区域/行业服务商分润共享积分":',`区域/行业服务商分润共享积分`,'}}')
memberInfo
from 导出_userinfo_all;
##线上充值记录
SELECT
	a.userID,
	b.inviteCode as "云科号",
	b.userName AS "用户名",
	ifnull(c.realName,"null") as "姓名",
	ifnull(b.mobile,"null") as "手机号码",
	ifnull(c.idCardNo,"null") as "身份证号码",
	a.amount as "交易金额",
	a.createTime as "订单时间",
	CASE a.payType WHEN 1 THEN "支付宝" WHEN 2 THEN "微信" WHEN 3 THEN "先锋快捷支付" WHEN 4 THEN "国美支付" WHEN 10 THEN "支付宝扫码" WHEN 11 THEN "微信扫码" ELSE a.payType END as "支付类型",
	ifnull(a.resMessage,"null") as "resMessage",
	ifnull(a.bankcard,"null") as "bankcard",
 	CASE a.status WHEN 1 THEN "未支付" WHEN 2 THEN "支付成功" WHEN 3 THEN "支付失败" end as "支付状态"
FROM rechargeOrder a
LEFT JOIN `user` b ON a.userid = b.userid
LEFT JOIN bankcardmanagement c ON a.userid = c.userid;


##线下转账记录
SELECT
	a.linetransferid AS "转账流水号",
CASE
		a.type
		WHEN 1 THEN
		"本人转账"
		WHEN 2 THEN
		"他人转账"
	END AS "转账类型",
	a.userid,
	b.invitecode AS "云科号",
	b.username AS "用户名",
	ifnull( a.realname, "null" ) AS "真实姓名",
	ifnull( CASE c.idCardNo WHEN '' THEN c.otheridcardno ELSE c.idCardNo END, "null" ) AS "身份证号",
	ifnull( CASE WHEN b.companyid IS NULL THEN b.mobile ELSE d.mobile END, "null" ) AS "手机号码",
	ifnull( a.bankname, "null" ) AS "银行名称",
	a.amount AS "金额",
	a.remark,
CASE
		a.`STATUS`
		WHEN 1 THEN
		"待审核"
		WHEN 2 THEN
		"拒绝"
		WHEN 3 THEN
		"审核通过"
		WHEN 4 THEN
		"审核通过"
	END AS "审核状态",
	ifnull(a.optime, "null" ) AS "审核时间",
	ifnull( a.opreason, "null" ) AS "拒绝原因",
	a.createtime AS "创建时间"
FROM
	linetransfer a
	LEFT JOIN `user` b ON a.userid = b.userid
	LEFT JOIN bankcardmanagement c ON a.userid = c.userid
	LEFT JOIN company d ON b.companyid = d.companyid
	LEFT JOIN region r ON a.regionid = r.regionid
ORDER BY
	a.createtime DESC

	##云科金盾(余额)提现记录
SELECT
	i.id AS "提现流水号",
	i.userid,
	u.invitecode AS "云科号",
	u.username AS "用户名称",
	ifnull( CASE WHEN b.idCardNo IS NULL THEN b.otheridcardno ELSE b.idCardNo END, "null" ) AS "身份证号",
	ifnull( CASE WHEN u.companyid IS NULL THEN u.mobile ELSE c.mobile END, "null" ) AS "手机号码",
	i.amount AS "出款金额",
	i.witamount AS "提现金额",
	i.pouamount AS "提现手续",
	i.bankinfo AS "银行卡信息",
	i.acctno AS "出款账户",
	i.acctname AS "账户名称",
CASE
		i.`status`
		WHEN 1 THEN
		"未处理"
		WHEN 2 THEN
		"已处理"
		WHEN 3 THEN
		"被拒绝"
	END AS "提现状态",#	CASE i.outstatus WHEN 1 THEN "未出款" WHEN 2 THEN "已出款" END as "出款状态", #这个状态没用
	ifnull( i.remark, "null" ) AS "拒绝原因",
	i.createtime AS "提现时间"
FROM
	moneywithdraw i
	LEFT JOIN `user` u ON i.userid = u.userid
	LEFT JOIN bankcardmanagement b ON i.userid = b.userid
	LEFT JOIN company c ON u.companyid = c.companyid
	LEFT JOIN region r ON u.liveAddress = r.regionid #WHERE i.createtime >= '2018-04-04 00:00:00' AND i.createtime <= '2018-07-13 23:59:59'

ORDER BY
	i.createtime DESC
