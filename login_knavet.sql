DROP PROCEDURE login_knavet;

CREATE PROCEDURE login_knavet(p_loginnamn char(10),p_behoriguppg char(1),p_rutin char(10),p_enhetsid INT,p_losenord varchar(32,1),p_system varchar(10))
	returning 
	int, 
	varchar(255,0),
	int,
	char(12),
	char(60),
	char(12),
	char(1),
	datetime year to fraction(3),
	datetime year to fraction(3),
	int,
	datetime year to fraction(3); --Sessionsid

--@(#)$Id: login_knavet.sql,v 1.3 2010/03/15 10:15:01 informix Exp $

-- Kontrollerar login namn/lösenord, ej sessionshantering.

DEFINE p_svar integer;

DEFINE p_appanvappid char(18);
DEFINE p_anvandareid int;
DEFINE p_anvandarenamn char(60);
DEFINE p_anvandarepersnr char(12);
DEFINE p_araktiv char(1);
DEFINE p_behorighetslista varchar(255,0);
DEFINE p_behorighetslistahelp1 varchar(255,0);
DEFINE p_behorighetslistahelp2 varchar(255,0);
DEFINE p_senastindat datetime year to fraction(3);
DEFINE p_senastutdat datetime year to fraction(3);
DEFINE p_antaltillhor int;
DEFINE 	p_inloggad char(1); 	
DEFINE	p_sessionsid datetime year to fraction(3);	
DEFINE	p_senasteaktivitet datetime year to fraction(3);
DEFINE p_sessiontimeouttime     INTERVAL MINUTE TO MINUTE; 
DEFINE p_userid char(10);
DEFINE p_password varchar(32,1);
DEFINE p_passcheck int;
DEFINE p_antal integer;

DEFINE sql_err integer;
DEFINE isam_err integer;
DEFINE error_info char(70);


-- Felrutin

ON EXCEPTION SET sql_err, isam_err, error_info
	CALL error_log(sql_err, isam_err, error_info,p_loginnamn,'1001');
	RETURN 1001,null,null,null,null,null,null,null,null,null,null;
	RAISE EXCEPTION sql_err, isam_err, error_info;	
END EXCEPTION;
SET LOCK MODE TO WAIT 10;

LET p_svar = 0;
LET p_behorighetslista = " ";
LET p_enhetsid = 0;
LET p_anvandarenamn = "";
LET p_anvandarepersnr = "";
LET p_araktiv = "";
LET p_senastindat = null;
LET p_senastutdat = null;
LET p_antaltillhor = 0;
LET p_sessiontimeouttime = "20";
LET p_inloggad = NULL;
LET p_sessionsid = CURRENT;
LET p_userid = NULL;

execute procedure check_userpasswd(p_loginnamn,p_losenord)
into p_passcheck;

IF(p_passcheck != 0) THEN -- Fel i passwdkontrollen.
	return p_passcheck,null,null,null,null,null,null,null,null,null,null;
END IF;

-- Om fel lösenord returnera 1003

SELECT 	inloggad,
	senasteaktivitet,
	senasteinloggadenhetid,
	senasteinloggaddatum,	
	senasteutloggaddatum	
INTO	p_inloggad, 	
	p_senasteaktivitet,
	p_enhetsid,
	p_senastindat,
	p_senastutdat  
FROM 	tanvappdata_ny
WHERE	userid = p_loginnamn;

SELECT	p.anamn,
	a.persnr,
	a.araktiv,
	a.userid
INTO	p_anvandarenamn,
	p_anvandarepersnr,
	p_araktiv,
	p_userid
FROM	tanvandare_ny a, torgperson p
WHERE	a.userid = p_loginnamn
and	a.persnr = p.persnr;

--Ingen träff
IF (p_userid is null) THEN
	RETURN 1004,null,null,null,null,null,null,null,null,null,null; -- Användaren finns ej.
ELSE	

IF (p_araktiv != 'J') THEN
	RETURN 1007, -- Användaren är ej aktiv
	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL;
END IF;

Select count(*)   
into p_antal
from tanvbehorig b, tanvkat a, tanvkatroll ar, troll r, trollegenskap re, tegenskap e, tegenskapsrutin er
where b.userid = p_loginnamn
and b.anvkatid = a.anvkatid
and a.anvkatid = ar.anvkatid
and ar.rollid = r.rollid
and r.rollid = re.rollid
and re.egenskapsid = e.egenskapsid
and e.egenskapsid = er.egenskapsid
and er.rutinid = 400;

IF(p_antal < 1) then
	RETURN 1004,null,null,null,null,null,null,null,null,null,null; -- Användaren finns ej.
end if;   


	IF (p_behoriguppg = 'J' OR p_behoriguppg = 'j') THEN
		EXECUTE PROCEDURE getbehorighetallman(p_userid,p_system)
		into p_svar,p_behorighetslista;
	ELSE
		LET p_behorighetslista = "";
	END IF;
		
	IF (p_anvandarenamn IS NULL) THEN
		LET p_anvandarenamn = "";
	END IF; 
	IF (p_anvandarepersnr IS NULL) THEN
		LET p_anvandarepersnr = "";
	END IF; 
	IF (p_araktiv IS NULL) THEN
		LET p_araktiv = "";
	END IF; 

	RETURN 
	p_svar,
	p_behorighetslista,
	p_enhetsid,
	p_loginnamn,
	p_anvandarenamn,
	p_anvandarepersnr,
	p_araktiv,
	p_senastindat,
	p_senastutdat,
	p_antaltillhor, 
	p_sessionsid;
END IF;

-- $Log: login_knavet.sql,v $
-- Revision 1.3  2010/03/15 10:15:01  informix
-- Lagt till kontroll om användaren är aktiv eller inte (kz-2329) samt rensat bort lite bortkommenterad kod.
--
-- Revision 1.2  2006/08/24 13:05:31  ovew
-- k1318
--
-- Revision 1.1  2006/08/24 08:56:39  ovew
-- knavet1.2 051220
--
END PROCEDURE;
