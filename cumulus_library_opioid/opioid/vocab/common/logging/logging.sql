-- http://www.jamediasolutions.com/blog/deterministic-no-sql-or-reads-sql-data-in-its-declaration.html
SET GLOBAL log_bin_trust_function_creators = 1;

-- MySQL application logging procedures 
-- use DATASET;

drop procedure if exists LOG_LINES;
delimiter //
create procedure LOG_LINES(numlines int)
begin
     select numlines into @LOG_LINES; 
end//
delimiter ;

drop procedure if exists user_prefs;
delimiter //
create procedure user_prefs()
begin

   if @DATASET is null then
     select DATASET from log order by idx desc limit 1 into @DATASET;
   end if;
   -- select @DATASET; 

   if @LOG_LINES is null then
     select 50 into @LOG_LINES; 
   end if;
   -- select @LOG_LINES; 

   if @LOG_LEVEL is null then
     select 1 into @LOG_LEVEL; 
   end if;
   -- select @LOG_LEVEL; 

end//
delimiter ;

drop table if exists log;
CREATE TABLE log
(
  event_time   timestamp    default now(),
  entity_name  varchar(100) NOT NULL,
  message      varchar(100) NULL,
  DATASET      varchar(30)  null
)
Engine InnoDB;

ALTER TABLE log add idx smallint UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY;

drop procedure if exists log;
delimiter //
create procedure log(log_entity_name varchar(100), log_message varchar(100))
begin
   call user_prefs; 
   insert into log
   (DATASET, entity_name,     message) select
   @DATASET, log_entity_name, log_message;

   if @LOG_LEVEL > 0 then
    select concat(DATASET, ',', entity_name, ',',message) as '' from log order by idx desc limit 1;
   end if;
end//
delimiter ;

call log('log', 'table created');
call log('log', 'procedure created');

drop procedure if exists DATASET;
delimiter //
create procedure DATASET(dataset varchar(30))
begin
     select dataset into @DATASET; 
     call LOG('DATASET',@DATASET); 
end//

delimiter ;

drop procedure if exists mem;
delimiter //
create procedure mem()
begin
  select
  table_schema,
  ENGINE,
  TABLE_NAME,
  TABLE_ROWS,
  concat( round( TABLE_ROWS / ( 1000 *1000 ) , 2 ) , '' )  million,
  concat( round( data_length / ( 1024 *1024 ) , 2 ) , 'M' )  data_MB,
  concat( round( index_length / ( 1024 *1024 ) , 2 ) , 'M' ) index_MB, 
  TABLE_COLLATION
  from
  information_schema.TABLES
  where
  TABLE_SCHEMA = DATABASE()
  order by
  table_schema, engine, table_name;
end//
delimiter ;
