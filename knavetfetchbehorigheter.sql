DROP PROCEDURE knavetfetchbehorigheter;

CREATE PROCEDURE knavetfetchbehorigheter
	(p_loginnamn char(10),	
	p_losenord varchar(32,1),
	p_system varchar(10))
	RETURNING 				
	INT,                         	--0,                                                 
	lvarchar,	                --p_behorighetslista, --Perre 2005-02-18
	varCHAR(12),                    --p_userid,                       
	varchar(10),                  	--p_skapaduser,                   
	DATE,		                --p_skapaddatum                   
	DATETIME year to fraction(3),   --p_senastindat,                  
	varchar(12),   			--p_anvandarepersnr,              
	varCHAR(60),                    --p_anvandarenamn,                
        varchar(60),                    --p_tilltalsnamn,         
        varchar(80),                    --p_fnamn,                
        varchar(60),                    --p_enamn,	        
        varchar(10);                    --"OK";		        

--@(#)$Id: knavetfetchbehorigheter.sql,v 1.2 2006/08/24 13:05:31 ovew Exp $
                                                
-- Skapat av: Henric Wollert                    
-- Datum: 2004-05-04                            
-- Version: 1
-- Rutinbeteckning ??
-- hämtar behörigheter för en knavet USER
--Ändrat:2006-06-19 SL Bug 1318 Ändrat så att man ej returnerar null i några fält.


DEFINE p_svar integer;
DEFINE p_appanvappid char(18);
DEFINE p_anvandareid int;
DEFINE p_anvandarenamn char(60);
DEFINE p_anvandarepersnr char(12);
DEFINE p_araktiv char(1);
DEFINE p_behorighetslista lvarchar;		--Perre 2005-02-18 varchar(255) - lvarchar
DEFINE p_behorighetslistahelp1 lvarchar;	--Perre 2005-02-18    -"- 
DEFINE p_senastindat datetime year to fraction(3);
DEFINE p_senastutdat datetime year to fraction(3);
DEFINE p_userid char(10);
DEFINE p_password varchar(32,1);
DEFINE p_passcheck int;

DEFINE p_antal	INTEGER;
DEFINE p_datum	DATE;
DEFINE p_fnamn varchar(80);
DEFINE p_enamn varchar(60);
DEFINE p_tilltalsnamn varchar(60);
DEFINE p_skapaduser varchar(10);
DEFINE p_skapaddatum	DATE;

DEFINE sql_err integer;
DEFINE isam_err integer;
DEFINE error_info char(70);


-- Felrutin

ON EXCEPTION SET sql_err, isam_err, error_info
	CALL error_log(sql_err, isam_err, error_info,p_loginnamn,'4621');
	RETURN 0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,"SQL_ERR";
	RAISE EXCEPTION sql_err, isam_err, error_info;	
END EXCEPTION;
SET LOCK MODE TO WAIT 10;

LET p_svar = 0;
LET p_behorighetslista = " ";
LET p_anvandarenamn = "";
LET p_anvandarepersnr = "";
LET p_araktiv = "";
LET p_senastindat = null;
LET p_userid = NULL;
LET p_fnamn=NULL;
LET p_enamn=NULL;
LET p_tilltalsnamn = NULL;
LET p_skapaduser = NULL;
LET p_skapaddatum=NULL;


LET p_antal=0;

EXECUTE procedure check_userpasswd(p_loginnamn,p_losenord)
INTO 		p_passcheck;

IF(p_passcheck != 0) THEN -- Fel i passwdkontrollen.
		
	IF p_passcheck = 2022 THEN
	--felaktigt användarnamn
	RETURN 0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,"USRNAM_ERR";
	
	ELIF p_passcheck = 2023 THEN
		--felaktigt password
		
		SELECT	COUNT (*)
		INTO	p_antal
		FROM 	tknavetlogin		
		WHERE	userid=p_loginnamn;
		
		IF p_antal=0 THEN
			--denna USER fanns inte registrerad sen tidigare så vi stoppar IN denne...
			INSERT INTO tknavetlogin (userid, datum, antaldygnsinloggningar) 			
			VALUES (p_loginnamn, TODAY, 0);
		END IF;				
			
		SELECT	antaldygnsinloggningar			
		INTO	p_antal
		FROM	tknavetlogin
		WHERE	userid=p_loginnamn
		AND	datum=TODAY;

		IF p_antal > 19 then
			RETURN 0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,"MAXTRY_ERR";
		END IF;		
	
		SELECT	datum
		INTO	p_datum
		FROM 	tknavetlogin	
		WHERE 	userid=p_loginnamn;

		IF p_datum = TODAY then
			UPDATE tknavetlogin		
			SET antaldygnsinloggningar = antaldygnsinloggningar + 1			 
			WHERE userid=p_loginnamn;		
		ELSE
			UPDATE tknavetlogin
			SET antaldygnsinloggningar = 1,				
			datum=TODAY
			WHERE userid=p_loginnamn;
		END IF;	
		
		RETURN 0,null,NULL,null,null,null,NULL,NULL,NULL,NULL,NULL,"PASSWD_ERR";
	END IF;	
END IF;

SELECT 	senasteinloggning
INTO	p_senastindat
FROM	tknavetlogin
WHERE	userid = p_loginnamn;

IF p_senastindat IS NULL THEN
	LET p_senastindat = CURRENT;
END IF;

UPDATE 	tknavetlogin
SET 	senasteinloggning= CURRENT
WHERE 	userid = p_loginnamn;

SELECT	p.anamn,
	p.fnamn,
	p.enamn,
	p.tilltalsnamn,
	p.skapdat,
	a.persnr,
	a.araktiv,
	a.userid,
	a.skapadav
INTO	p_anvandarenamn,
	p_fnamn,
	p_enamn,
	p_tilltalsnamn,
	p_skapaddatum,
	p_anvandarepersnr,
	p_araktiv,
	p_userid,
	p_skapaduser
FROM	tanvandare_ny a, torgperson p
WHERE	a.userid = p_loginnamn
AND	a.persnr = p.persnr;

--Ingen träff
IF (p_userid is null) THEN
	RETURN 0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,"NOUSER_ERR" ; -- Användaren finns ej.
ELSE	

	IF (p_skapaduser IS NULL) THEN
		LET p_skapaduser = "";
	END IF; 
	IF (p_anvandarenamn IS NULL) THEN
		LET p_anvandarenamn = "";
	END IF; 
	IF (p_tilltalsnamn IS NULL) THEN
		LET p_tilltalsnamn = "";
	END IF; 
	IF (p_fnamn IS NULL) THEN
		LET p_fnamn = "";
	END IF; 
	IF (p_enamn IS NULL) THEN
		LET p_enamn = "";
	END IF; 

	IF(p_araktiv != 'J') THEN
		RETURN 0, -- Användaren är ej aktiv
		p_behorighetslista,	
		p_userid,
		p_skapaduser,
		p_skapaddatum,
		p_senastindat,
		p_anvandarepersnr,
  		p_anvandarenamn,
  		p_tilltalsnamn,
  		p_fnamn,
  		p_enamn,		
		"USRNAK_ERR";		
	END IF;
	
			
		EXECUTE PROCEDURE getbehorighetallmanknavet(p_userid,p_system) --Perre 2005-02-18
		into p_svar,p_behorighetslista;
		
		--EXECUTE PROCEDURE getbehorighetenhet(p_userid,p_system,0)
		--into p_svar,p_behorighetslistahelp1;		
		
		
		--LET p_behorighetslista = p_behorighetslista || p_behorighetslistahelp1;



	RETURN 	0,
		p_behorighetslista,	
		trim(p_userid),
		trim(p_skapaduser),
		p_skapaddatum,
		p_senastindat,
		p_anvandarepersnr,
  		trim(p_anvandarenamn),
  		p_tilltalsnamn,
  		p_fnamn,
  		p_enamn,	
		"OK";		

END IF;


-- $Log: knavetfetchbehorigheter.sql,v $
-- Revision 1.2  2006/08/24 13:05:31  ovew
-- k1318
--
-- Revision 1.1  2006/08/24 08:56:37  ovew
-- *** empty log message ***
--
END PROCEDURE;
