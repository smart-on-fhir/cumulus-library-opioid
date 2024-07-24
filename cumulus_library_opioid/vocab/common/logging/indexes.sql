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

drop procedure if exists create_index;
delimiter //
create procedure create_index( tablename varchar(100), indexcols varchar(100) )
begin
	call log( concat(tablename,':', indexcols), 'index begin');

	select concat('alter table ', tablename, ' add  index (', indexcols, ')') into @idx;
	prepare stmt from @idx; execute stmt;

	select concat('show index from ', tablename) into @show;
	prepare stmt from @show; execute stmt;

	call log( concat(tablename,':', indexcols), 'index done');
end//
delimiter ;

drop procedure if exists to_ascii;
delimiter //
create procedure to_ascii( tablename varchar(100))
begin
	select concat('alter table ', tablename, ' convert to CHARSET ascii collate ascii_general_ci') into @idx;
	prepare stmt from @idx; execute stmt;

	call log(tablename, 'to_ascii');
end//
delimiter ;


drop procedure if exists utf8_unicode;
delimiter //
create procedure utf8_unicode( tablename varchar(100))
begin
	select concat('alter table ', tablename, ' convert to CHARSET utf8 collate utf8_unicode_ci') into @idx;
	prepare stmt from @idx; execute stmt;

	call log(tablename, 'utf8_unicode_ci');
end//
delimiter ;

drop procedure if exists utf8_general;
delimiter //
create procedure utf8_general( tablename varchar(100))
begin
	select concat('alter table ', tablename, ' convert to CHARSET utf8 collate utf8_general_ci') into @idx;
	prepare stmt from @idx; execute stmt;

	call log(tablename, 'utf8_general_ci');
end//
delimiter ;
