
insert into member (member_no,user_name,real_name,phone,id_card,parent_no,
                    cur_level,child_depth,direct_count,child_total,member_info)

select 用户ID ,昵称,姓名 , 手机号,证件号,推荐人id,所属等级,深度,直接下线人数,总下线人数,
    CONCAT('{"基本信息":{"性别":"',`性别`,'","实名时间":"',`实名时间`,'","注册时间":"',`注册时间`,
           '","店铺ID":"',`店铺ID`, '","店铺名称":"',`店铺名称`,'","省":"', `省`,
           '","市":"',`市`, '","县":"',`县`, '"},',

           '"银行卡":{"银行类型":"',`银行类型`,'","银行卡号":"',`银行卡号`,'","银行所属地":"',`银行所属地`,'"},',

           '"收货":{"收货人姓名":"',`收货人姓名`,'","电话":"',`电话`,'","收货人填写的省":"',`收货人填写的省`,
           '","收货人填写的市":"', `收货人填写的市`, '","收货人填写的省":"',`收货人填写的县`,
           '","收货人填写的地址":"',`收货人填写的地址`,'"},',

           '"资金":{"累计奖金":"',累计奖金,'","未提现奖金":"',未提现奖金,
           '","已发放推荐奖励的本金":"',已发放推荐奖励的本金, '","被推荐时间":"',`被推荐时间`,
           '","累计本金":',`累计本金`, ',"本金余额":',`本金余额`,',"累计租金":',`累计租金`,
           ',"租金余额":',`租金余额`, ',"头条购买数量":"',`头条购买数量`,'","行业购买数量":"',`行业购买数量`,
           '","可用余额":',`可用余额`,',"冻结余额":',`冻结余额`,
           ',"累计积分":',`累计积分`,',"积分余额":',`积分余额`, '}',

           '}')
    memberInfo
from member_six;


insert into member (member_no,user_name,real_name,phone,id_card,parent_no,
                    cur_level,child_depth,direct_count,child_total,member_info)
select 用户ID ,昵称,姓名 , 手机号,证件号,推荐人id,所属等级,深度,直接下线人数,总下线人数,
    CONCAT('{"基本信息":{"性别":"',`性别`, '","注册时间":"',`注册时间`,
           '","店铺ID":"',`店铺ID`, '","店铺名称":"',`店铺名称`, '"},',

           '"银行卡":{"银行类型":"',`银行类型`,'","银行卡号":"',`银行卡号`,
           '","银行所属地":"',`银行所属地`,'"},',

           '"收货":{"收货人姓名":"',`收货人姓名`,'","电话":"',`电话`,
           '","收货人填写的地址":"',`收货人填写的地址`,'"},',

           '"资金":{"累计奖金":"',累计奖金,
           '","累计本金":',`累计本金`, ',"本金余额":',`本金余额`,
           ',"租金余额":',`租金余额`,
           '","可用余额":',`可用余额`,',"冻结余额":',`冻结余额`,
           ',"累计积分":',`累计积分`,',"积分余额":',`积分余额`, '}',
           '}') as  memberInfo
from member_six;
update member_six set 店铺名称= replace (店铺名称,'"','');
UPDATE member_six SET  收货人填写的地址 = REPLACE(REPLACE(收货人填写的地址, CHAR(10), ''), CHAR(13), '');
UPDATE member_six SET  收货人姓名 = REPLACE(REPLACE(收货人姓名, CHAR(10), ''), CHAR(13), '');
UPDATE member_six SET  收货人姓名 = REPLACE(收货人姓名, '"', '');
UPDATE member_six SET  收货人姓名 = REPLACE(收货人姓名, char(8), '');
UPDATE member_six SET  电话 = REPLACE(REPLACE(电话, CHAR(10), ''), CHAR(13), '');
update member_six set 电话= replace (电话,'\t','');
update member_six set 银行卡号= replace (银行卡号,'\t','');

call updateNull2EmtpyString ('xingliao','member_six');
call updateNonJsonChar ('xingliao','member_six');