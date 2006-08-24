DROP PROCEDURE knavetfetchrutinnamn;

CREATE PROCEDURE knavetfetchrutinnamn
	(p_rutinid integer)
	RETURNING 
		INT,
	 	lvarchar,
	  INT, 
	  varchar(255);

--@(#)$Id: knavetfetchrutinnamn.sql,v 1.1 2006/08/24 08:56:38 ovew Exp $

{

(p_userid char(10),
	p_system CHAR(5))
-- Skapat av: Perre Forsberg
-- Datum: 2006-01-03
-- Version: 1
-- Rutinbeteckning ??
-- Hämtar rutinnamnet för ett givet rutinid
--Ändrat:2006-06-19 SL Bug 1318 Ändrat så att man ej returnerar null i några fält.
}

DEFINE p_svar integer;

DEFINE p_namn varchar(255);
DEFINE p_behorighetslista lvarchar;

DEFINE sql_err integer;
DEFINE isam_err integer;
DEFINE error_info char(70);


-- Felrutin

ON EXCEPTION SET sql_err, isam_err, error_info
	CALL error_log(sql_err, isam_err, error_info,'knavrnamn',4661);
	RETURN 4661,null,null,null;
	RAISE EXCEPTION sql_err, isam_err, error_info;	
END EXCEPTION;
SET LOCK MODE TO WAIT 10;

LET p_svar = 0;
LET p_behorighetslista = NULL;
LET p_namn = null;

foreach
 select first 1 trim(r.rutinnamn)
 into p_namn
 from trutin r, trutinobjekt o
 where r.rutinid = p_rutinid
 and r.rutinid = o.rutinid
 and o.objekttyp in ('B','F')
end foreach

--Ingen träff
IF (p_namn is null) THEN
	RETURN 4662,NULL,NULL,NULL;
END IF;

return 0, "", p_rutinid, p_namn;

-- $Log: knavetfetchrutinnamn.sql,v $
-- Revision 1.1  2006/08/24 08:56:38  ovew
-- *** empty log message ***
--
END PROCEDURE;
