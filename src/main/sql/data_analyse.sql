update member2 set 银行卡姓名=replace(银行卡姓名,'\\','');
update member2 set 开户地址=replace(开户地址,'\\','');
update member2 set 真实姓名=replace(真实姓名,'\\','');
update member2 set 地址=replace(地址,'\\','');
update member2 set 银行卡号=replace(银行卡号,'\\','');
update member2 set 开户行=replace(开户行,'\\','');
update member2 set 用户名=replace(用户名,'\\','');

update member2 set `开户行`='中国农业银行[北京市，北京市市辖区，山西省吕梁市石楼支行]'  where 会员名称='19152';
update member2 set `开户地址`='中国农业银行[北京市，北京市市辖区，山西省吕梁市石楼支行]'  where 会员名称='19152';
update member2 set `银行卡姓名`='中国农业银行[北京市，北京市市辖区，山西省吕梁市石楼支行]'  where 会员名称='19152';
update member2 set 银行卡姓名=replace(银行卡姓名,char(20),'') where 会员名称='1348734';

update member set info2=replace(info2,char(2),'') where member_id=1318844;

insert into member (member_no,user_name,real_name,phone,id_card,parent_no,cur_level,child_depth,direct_count,child_total,info)

select 会员名称,昵称,姓名 , 电话号码,身份证号,推荐人id,所属等级,深度,直接下线人数,总下线人数,
    CONCAT('{"基本信息":{"用户名":"',`用户名`,'","角色":"',`角色的id 85供货商p配送站87配送站`,'","注册时间":"',`注册时间`,'","QQ ":"',`QQ`,
           '","推荐人Uid":"',`推荐人Uid`,'","是否为体验式营销成员,能获得服务费":"', `是否为体验式营销成员,能获得服务费`,
           '","系统省":"',`系统省`,'","系统市":"',`系统市`,
           '","系统区县":"',`系统区县`,'","系统街道":"',`系统街道`,
           '","系统的代理级别":"',`系统的代理级别`, '","真实姓名":"',`真实姓名`,
           '","地址":"',`地址`,        '","email":"',`Email`,           '","会员级别":"',`会员级别`,
           '","会员类型":"',`会员类型`,           '","层数":"',`层数`,
           '","推荐团队人数":"',`推荐团队人数`,           '","推荐用户名":"',`推荐用户名`,
           '","下级是否有二星店主":"',`下级是否有二星店主`,           '","是否是运营中心":"',`是否是运营中心`,
           '","运营中心所属等级":"',`运营中心所属等级`,           '","运营中心编号":"',`运营中心编号`,
           '","所属运营中心":"',`所属运营中心`,
           '","电话号码归属省":"',`电话号码归属省`,'","电话号码归属市":"',`电话号码归属市`,'","身份证归属地":"',`身份证归属地`,'","认证身份证号":"',`认证身份证号`,
           '","认证姓名":"', `认证姓名`,'","直推人数":"',`直推人数`,'"},',

           '"银行卡":{"银行卡姓名":"',`银行卡姓名`,'","银行卡号":"',`银行卡号`,'","开户行":"',`开户行`,'","卡号":"',`卡号`,'","开户名":"',`开户名`,'","开户地址":"',`开户地址`,'"},',

           '"资金":{"提现联系电话":"',提现联系电话,'","取现总金额":"',取现总金额,'","充值总金额":',充值总金额,',"钱包余额":',`钱包余额`,',"广告费":',`广告费`,
           ',"供货商钱包":',`供货商钱包`,',"预付款":',`预付款`,',"赠送广告费":',`赠送广告费`,
           ',"一次性购物PV":',`一次性购物PV`,',"一次性购物金额":',`一次性购物金额`,',"累计购物PV":',`累计购物PV`,',"累计升级的金额":',`累计升级的金额`,
           ',"累计升级的PV":',`累计升级的PV`,',"累计消费":',`累计消费字段`, ',"pv":',`pv`,'},',

           '"积分":{"积分":',`积分`,',"冻积分":',`冻积分`, ',"不可转冻积分":',`不可转冻积分`,',"活积分":',`活积分`,',"复消积分":',`复消积分`,'}',
           '}')
    memberInfo
from member2;



create table memberWithdrawCount as
  select userid,count(*) cc,sum(money) money from take_cash_log group by userid;

create table memberOrderCount as
  select userid,count(*) cc,sum(pay_join_money) money from xs_order group by userid;

create table memberProductCount as
  select u_id,count(*) cc,sum(pay_money) money from xs_orders_product group by u_id;