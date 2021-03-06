DROP PROCEDURE knavetfetchanvandareenheter;

CREATE PROCEDURE knavetfetchanvandareenheter
	(p_loginnamn char(10),	
	p_losenord varchar(32,1),
	p_system varchar(10))
	RETURNING 
		INT,
	 	lvarchar, 
	 	INT,
	  varchar(255),
	  varchar(10),
	  varchar(12);

--@(#)$Id: knavetfetchanvandareenheter.sql,v 1.2 2006/08/24 13:05:31 ovew Exp $

{

(p_userid char(10),
	p_system CHAR(5))
-- Skapat av: Henric wollert
-- Datum: 2004-05-06
-- Andrat: 2006-01-03 Perre Forsberg  p_orgnr
-- Version: 1
-- Rutinbeteckning ??
-- H�mtar alla enheter en anv�ndare �r beh�rig i kbok/knavet
}

DEFINE p_svar integer;
DEFINE p_svaret integer;

DEFINE p_enhetsid int;
DEFINE p_Namn varchar(255);
DEFINE p_behorighetslista lvarchar;
DEFINE p_sortnyck char(20);
DEFINE p_passcheck INTEGER;
DEFINE p_antal	INTEGER;
DEFINE p_orgnr varchar(12);

DEFINE sql_err integer;
DEFINE isam_err integer;
DEFINE error_info char(70);


-- Felrutin

ON EXCEPTION SET sql_err, isam_err, error_info
	CALL error_log(sql_err, isam_err, error_info,'knavbehor',4631);
	RETURN 0,null,null,NULL,"SQL_ERR",NULL;
	RAISE EXCEPTION sql_err, isam_err, error_info;	
END EXCEPTION;
SET LOCK MODE TO WAIT 10;

LET p_svar = 0;
LET p_behorighetslista = NULL;
LET p_enhetsid = 0;
LET p_Namn = 0;
LET p_sortnyck = null;
LET p_passcheck=0;
LET p_antal=0;
LET p_orgnr = "";

EXECUTE procedure check_userpasswd(p_loginnamn,p_losenord)
INTO 		p_passcheck;

IF p_passcheck = 2022 THEN
	RETURN 0,NULL,NULL,NULL,"USRNAM_ERR",NULL;
ELIF p_passcheck=2023 THEN
	
	SELECT	antaldygnsinloggningar			
	INTO	p_antal
	FROM	tknavetlogin
	WHERE	userid=p_loginnamn
	AND	datum=TODAY;

	IF p_antal > 19 then
		RETURN 0,NULL,NULL,NULL,"MAXTRY_ERR",NULL;	
	END IF;
	
	RETURN 0,NULL,NULL,NULL,"PASSWD_ERR",NULL;	
END IF;





Foreach  
{ Prestandaforbettring
SELECT	distinct e.enhetsid,
	e.namn,
	e.sortnyck
INTO	p_enhetsid,
	p_Namn,
	p_sortnyck
FROM	tenhet e,	
	troll rr,
	tanvkatroll a,
	tanvkat ak,
	tanvbehorig b
WHERE	b.userid = p_loginnamn
AND	b.anvkatid = ak.anvkatid
AND 	(b.enhetsid = e.enhetsid OR
	ak.anvkatid is not null AND ak.anvkatid != "" AND
 e.enhetsid in (select h.enhetunder from tenhethierarkitot h, tanvkat kk where h.enhetsid = b.enhetsid AND h.hierarkityp = kk.hierarkityp AND kk.anvkatid = b.anvkatid ) )
AND	b.anvkatid = a.anvkatid
AND	a.rollid = rr.rollid
AND	rr.knavet = p_system
order by e.sortnyck
}
SELECT  e.enhetsid,
        trim(e.namn),
        e.sortnyck,
	e.orgnr
INTO	p_enhetsid,
	p_Namn,
	p_sortnyck,
	p_orgnr
FROM    tenhet e,
        troll rr,
        tanvkatroll a,
        tanvbehorig b
WHERE   b.userid = p_loginnamn
AND     b.anvkatid = a.anvkatid
AND     a.rollid = rr.rollid
AND     rr.knavet = p_system
AND     b.enhetsid = e.enhetsid
UNION
SELECT  e.enhetsid,
        trim(e.namn),
        e.sortnyck,
        e.orgnr
FROM    tenhet e,
        troll rr,
        tanvkatroll a,
        tanvbehorig b,
        tenhethierarkitot h,
        tanvkat kk
WHERE   b.userid = p_loginnamn
AND     b.anvkatid = a.anvkatid
AND     a.rollid = rr.rollid
AND     rr.knavet = p_system
AND     b.anvkatid is not null
AND     e.enhetsid = h.enhetunder
AND     h.enhetsid = b.enhetsid
AND     h.hierarkityp = kk.hierarkityp
AND     kk.anvkatid = b.anvkatid
ORDER BY e.sortnyck


  
	EXECUTE PROCEDURE getbehorighetenhetknavet(p_loginnamn,p_system,p_enhetsid)
	INTO p_svaret,p_behorighetslista;
	

RETURN p_svar,p_behorighetslista,p_enhetsid,p_namn,"OK",p_orgnr with resume;
END Foreach;

--Ingen tr�ff
IF (p_enhetsid = 0) THEN
	RETURN 4632,NULL,NULL,NULL,NULL,NULL;
END IF;

-- $Log: knavetfetchanvandareenheter.sql,v $
-- Revision 1.2  2006/08/24 13:05:31  ovew
-- k1318
--
-- Revision 1.1  2006/08/24 08:56:36  ovew
-- *** empty log message ***
--

END PROCEDURE;
