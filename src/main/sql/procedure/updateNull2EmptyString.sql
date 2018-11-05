#p_schema_name 数据库名
#p_table_name 表名
#把p_table_name中null的值替换未空串‘’。
CREATE   PROCEDURE `updateNull2EmtpyString`(in p_schema_name varchar(50), in p_table_name varchar(50))
  BEGIN
    declare v_column_name varchar(100);
    declare v_data_type varchar(100);

    declare done int default 0;

    DECLARE cur1 CURSOR FOR
      select COLUMN_NAME, data_type from INFORMATION_SCHEMA.Columns WHERE table_schema = p_schema_name and table_name = p_table_name and column_default is null;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur1;

    FETCH cur1
    INTO v_column_name, v_data_type;
    WHILE done = 0 DO

      if v_data_type = 'varchar' or v_data_type = 'text' then
        set @v_sql = concat('update ', p_schema_name, '.', p_table_name, ' set ', v_column_name, ' = '''' where ', v_column_name, ' is null');
      elseif (v_data_type = 'int' or v_data_type = 'decimal' or v_data_type = 'double') then
        set @v_sql = concat('update ', p_schema_name, '.', p_table_name, ' set ', v_column_name, ' = 0 where ', v_column_name, ' is null');
      else
        set @v_sql = '';
      end if;

      prepare stmt from @v_sql; -- 预处理需要执行的动态SQL，其中stmt是一个变量
      EXECUTE stmt; -- 执行SQL语句
      deallocate prepare stmt; -- 释放掉预处理段

      FETCH cur1
      INTO v_column_name, v_data_type;
    END WHILE;

    CLOSE cur1;
  end