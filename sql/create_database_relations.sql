/*
 Navicat Premium Data Transfer

 Source Server         : local mysql
 Source Server Type    : MySQL
 Source Server Version : 50515
 Source Host           : localhost
 Source Database       : relations

 Target Server Type    : MySQL
 Target Server Version : 50515
 File Encoding         : utf-8

 Date: 11/13/2012 14:50:28 PM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `domains`
-- ----------------------------
DROP TABLE IF EXISTS `domains`;
CREATE TABLE `domains` (
  `superdom_id` char(12) NOT NULL DEFAULT '',
  `dom_id` char(12) NOT NULL,
  `dom_name_id` char(12) NOT NULL,
  PRIMARY KEY (`superdom_id`,`dom_name_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
delimiter ;;
CREATE TRIGGER `trigger_before_insert_domains` BEFORE INSERT ON `domains` FOR EACH ROW BEGIN 
	IF NEW.dom_id NOT RLIKE "d[0-9][0-9][0-9][0-9][0-9][0-9]" then
	SET NEW.dom_id = concat( 'd' ,  substr( concat( '000000' , 1 + ifnull( (select max(substr(dom_id,-6)) from domains) , 0) ) , -6 ) ) ;  
	END if;
END;
 ;;
delimiter ;
delimiter ;;
CREATE TRIGGER `trigger_after_insert_domains` AFTER INSERT ON `domains` FOR EACH ROW -- can't just set @domain_id to new.dom_id because we might have duplicate error?  (would still be new.dom_id??)

set @domain_id = ( select dom_id from domains where domains.dom_id = NEW.dom_id );;
 ;;
delimiter ;

-- ----------------------------
--  Table structure for `names`
-- ----------------------------
DROP TABLE IF EXISTS `names`;
CREATE TABLE `names` (
  `name_id` char(12) NOT NULL,
  `name` varchar(500) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`name_id`),
  UNIQUE KEY `name` (`name`(250))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
delimiter ;;
CREATE TRIGGER `trigger_before_insert_names` BEFORE INSERT ON `names` FOR EACH ROW BEGIN 
	IF NEW.name_id NOT RLIKE "n[0-9][0-9][0-9][0-9][0-9][0-9]" then
	SET NEW.name_id = concat( 'n' ,  substr( concat( '000000' , 1 + ifnull( (select max(substr(name_id,-6)) from names) , 0) ) , -6 ) ) ;  
	END if;
	set @name_ID = (select names.name_id from names where names.name = new.name) ;
	IF (select count(*) from names where names.name = new.name) > 0 THEN
		SIGNAL SQLSTATE '22012';
	END IF;
END;
 ;;
delimiter ;
delimiter ;;
CREATE TRIGGER `trigger_after_insert_names` AFTER INSERT ON `names` FOR EACH ROW SET @name_ID = (select name_id from names where new.name_id = names.name_id);
 ;;
delimiter ;

-- ----------------------------
--  View structure for `relations_view`
-- ----------------------------
DROP VIEW IF EXISTS `relations_view`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `relations_view` AS select `names_attr1`.`name` AS `attr1`,`names_dom1`.`name` AS `dom1`,`names_dom2`.`name` AS `dom2`,`names_attr2`.`name` AS `attr2` from ((((`names` `names_attr1` join `relations` on((`names_attr1`.`id` = `relations`.`relations`.`attr1`))) join `names` `names_dom1` on((`names_dom1`.`id` = `relations`.`relations`.`dom1`))) join `names` `names_attr2` on((`names_attr2`.`id` = `relations`.`relations`.`attr2`))) join `names` `names_dom2` on((`names_dom2`.`id` = `relations`.`relations`.`dom2`)));

-- ----------------------------
--  Procedure structure for `domain`
-- ----------------------------
DROP PROCEDURE IF EXISTS `domain`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `domain`(dom_name_in varchar(500))
BEGIN

/* this routine created a "top-level" domain
   ie, a domain with no superdomain.  The more general
	routine creates a new domain with a superdomain */

call name_quiet(dom_name_in) ; 

/* "top-level" domain is just a domain with "" as a super_domain */

call domain_super( dom_name_in, "" ); 

/*

call name_quiet(super_name_in) ; 

set @super_name_id = @name_id;


call name_quiet(dom_name_in) ; 

set @dom_name_id = @name_id;

IF (select count(*) from relations.domains where superdom_id = "" and  name_id = @name_id) = 0 THEN

	insert into  domains (superdom_id, name_id) values ("", @name_id) ;

end if;

set @domain_id = (


select * from domains_view where superdom_id = ""  and name_id = @name_id;

*/

end
 ;;
delimiter ;

-- ----------------------------
--  Procedure structure for `domain_super`
-- ----------------------------
DROP PROCEDURE IF EXISTS `domain_super`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `domain_super`(IN dom_name_in VARCHAR(500), IN super_name_in VARCHAR(500))
    DETERMINISTIC
BEGIN

/*
 *		call domain_super( dom_name_in, super_name_in )
 *
 *	to specify between domains with the same name (and name_id) 
 *		you have to specify the superdomain of the superdomain (?)
 *		via a call like call domain_super( dom_name_in, super_name_in, super_super_name_in ) (??)
 *
 */

-- register the super_name, get corresponding namd_id:

call name_quiet(super_name_in) ; 
set @super_name_id = @name_id;

-- select * from names where nid = @super_name_id;

/*
	Search existing domains for out superdom by name.
 	none, one, or multiple domains might be found.
*/

set @n = ( select count(*) from domains where dom_name_id = @super_name_id );

select @n;

set @superdom_id = ( select dom_id from domains where dom_name_id = @super_name_id );

select @superdom_id;


select * from domains where dom_id = @superdom_id;

select * from domains_view where dom_id = @superdom_id;

select  concat(   @n, ' domain(s) found for name "', super_name_in, '".'  ) as message ; 

select * from domains_view where dom_id = @superdom_id;

if @n >= 2 THEN

	-- if superdomain asked for leads to multiple then we need to stop and ask for more specificity (eg, domain of superdomain).

SET @msg =  concat( 'Multiple ( ' ,   @n, ' ) domains found for name "', super_name_in, '".'  )   ; 
 
SIGNAL SQLSTATE '10000'
      SET MESSAGE_TEXT =  @msg  ;

ELSEIF  @n = 1 then

	-- if just exactly one superdomain by name; we're assuming its the one the user meant.

   set @pass = 1;
ELSE 

	-- create a new (top-level) domain that will serve as out superdomain:

	insert into  domains (superdom_id, dom_name_id) values ("", @super_name_id) ;

	-- trigger_after_insert_domains will set @domain_id to the new dom_id

	set @superdom_id = @domain_id;

END IF;


/* okay.  now have @superdom_id set to the created/found domain ID we want as our superdomain. */

call name_quiet(dom_name_in) ; 

set @dom_name_id = @name_id;

select * from names where nid = @dom_name_id;


set @n2 = ( select count(*) from domains where superdom_id = @superdom_id and  dom_name_id = @dom_name_id );

select @n2;

if @n2 = 0 THEN
	select "gronk";

insert into  domains (superdom_id, dom_name_id) values (@superdom_id, @dom_name_id) ;

set @dom_id = @domain_id;

select  * from domains_view where  dom_id = @dom_id;

else
	select "grink";

set @dom_id = (select dom_id from domains where superdom_id = @superdom_id and  dom_name_id = @dom_name_id) ;

-- end if


select * from domains_view where superdom_id = @superdom_id and  dom_name_id = @dom_name_id  ;
select * from domains_view where dom_id = @dom_id  ;


 

end if;

-- IF (select count(*) from domains where superdom_id = @superdom_id and  dom_name_id = @dom_name_id) = 0 THEN


-- else


end
 ;;
delimiter ;

-- ----------------------------
--  Procedure structure for `names`
-- ----------------------------
DROP PROCEDURE IF EXISTS `names`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `names`(IN name_in VARCHAR(500))
BEGIN 

	/*
	This procedure is:
	(1) an insert into table "names"
	(1b)   the insert triggers on table names (sets variable @name_id to id of inserted name)
	(2)  a handler for the possible duplicate key insertion exception
			that then does nothing: duplicate insertions are the same as new insertions.
	(3)  for non-quiet version, returns a selection set of the row that was inserted.

	*/

	DECLARE CONTINUE HANDLER FOR SQLSTATE '22012' BEGIN END; 

	insert into relations.names set name = name_in ; 
	 
	select * from names where name_id = @name_ID; 

END
 ;;
delimiter ;

-- ----------------------------
--  Procedure structure for `names_quiet`
-- ----------------------------
DROP PROCEDURE IF EXISTS `names_quiet`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `names_quiet`(IN name_in VARCHAR(500))
BEGIN 

	/*
	This procedure is:
	(1) an insert into table "names"
	(1b)   the insert triggers on table names (sets variable @name_id to id of inserted name)
	(2)  a handler for the possible duplicate key insertion exception
			that then does nothing: duplicate insertions are the same as new insertions.
	(3)  for non-quiet version, returns a selection set of the row that was inserted.

	*/

	DECLARE CONTINUE HANDLER FOR SQLSTATE '22012' BEGIN END; 

	insert into relations.names set name = name_in ; 
	 

	-- select * from names where nid = @name_ID; 

END
 ;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
