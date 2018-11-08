#p_schema_name 数据库名
#p_table_name 表名
#替换目标表的字符字段中的双引号、回车换行、tab字符为空串‘’
CREATE PROCEDURE `updateNonJsonChar`(in p_schema_name varchar(50), in p_table_name varchar(50))
  BEGIN
    declare v_column_name varchar(100);
    declare v_data_type varchar(100);

    declare done int default 0;

    DECLARE cur1 CURSOR FOR
      select COLUMN_NAME, data_type from INFORMATION_SCHEMA.Columns WHERE table_schema = p_schema_name and table_name = p_table_name;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur1;

    FETCH cur1
    INTO v_column_name, v_data_type;

    WHILE done = 0 DO
      if v_data_type = 'varchar' or v_data_type = 'text' then
        set @v_sql = concat('update ', p_schema_name, '.', p_table_name, ' set ', v_column_name,
                            ' = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(', v_column_name, ', CHAR(10),''), CHAR(13),''), CHAR(92),''), char(34),''), CHAR(9),''), CHAR(8),'');');
        -- select @v_sql;
        prepare stmt from @v_sql;
        EXECUTE stmt;
        deallocate prepare stmt;
      end if;

      FETCH cur1
      INTO v_column_name, v_data_type;
    END WHILE;

    CLOSE cur1;
  end

  #     update member set info2 = REPLACE(REPLACE(REPLACE(REPLACE(info, CHAR(10),''), CHAR(13),''),   CHAR(9),''), CHAR(8),'');