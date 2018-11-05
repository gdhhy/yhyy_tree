SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for member
-- ----------------------------
DROP TABLE IF EXISTS member;

CREATE TABLE member (
  member_id    bigint      auto_increment primary key ,
  member_no    varchar(20) NOT NULL  comment ' 会员号',
  user_name    varchar(100) COMMENT '用户名',
  real_name    varchar(100) comment '真实姓名',
  id_card      varchar(100) COMMENT '身份证号码',
  phone        varchar(100) COMMENT '电话',
  member_info  json        DEFAULT NULL  COMMENT '会员资料，json格式',
  parent_no    varchar(20) DEFAULT NULL  COMMENT '上级会员号，指向本表member_no',
  cur_level    int(11)     DEFAULT 0  COMMENT '当前层级',
  child_total  int(11)     DEFAULT 0  COMMENT '所有下级数',
  child_depth  int(11)     DEFAULT 0  COMMENT '下级深度',
  direct_count int(11)     DEFAULT 0  COMMENT '直接下级数'
)
  ENGINE = MyISAM
  DEFAULT CHARSET = utf8;

alter table member
  add index ix_memberno (member_no);
alter table member
  add index ix_realname (real_name);
alter table member
  add index ix_idcard (id_card);
alter table member
  add index ix_phone(phone);
alter table member
  add index ix_parent_id (parent_no);
alter table member
  add index ix_user_name (user_name);