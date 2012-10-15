DROP procedure fetchpersonnavet;

create procedure fetchpersonnavet(
       p_persnr varchar(12))
	RETURNING
	INTEGER,	--p_svar			1 
	--tbasperson
	char(1),	--p_arskyddad			2
	varchar(12),	--p_persnr			3
	--tKyrkoperson                                  
	VARCHAR(80),	--p_fornamn			4                     
	VARCHAR(80),	--p_tilltalsnamn		5                
	VARCHAR(60),	--p_efternamn           	6
	VARCHAR(40),	--p_mellannamn			7        
	VARCHAR(36),	--p_aviseringsnamn		8
	VARCHAR(50),	--p_fastighet			9
	CHAR(2),	--p_avregistreringsorsak	10
	CHAR(6),	--p_fblkf			11	
	CHAR(6),	--p_kyrkolkf			12
	DATE,		--p_kyrkotillhorighetsdatum	13
	CHAR(3),	--p_medlemstyp			14
	DATE,		--p_andraddatum			15
	-- tadress                                      
	CHAR(2),	--p_adresstyp                   16
	VARCHAR(35),	--p_coadress                    17	
	VARCHAR(35),	--p_adress1                     18
	VARCHAR(35),	--p_adress2                     19
	VARCHAR(35),	--p_adress3                     20
	VARCHAR(9),	--p_postnummer                  21
	VARCHAR(35),	--p_postort                     22
	VARCHAR(35),	--p_land                        23
	varchar(2),	--p_civilstand			24 nytt 20040402 HW
	DATE,		--p_civilstandsdatum		25 nytt 20040402 HW
	CHAR(1),	--p_status			26 nytt 20040402 HW
	varchar(8);	--p_avregisteringsdatum		27 nytt 20050215 Perre

--@(#)$Id: fetchpersonnavet.sql,v 1.6 2012/10/15 14:45:50 idersv Exp $
	                                                                     
-- Skapat av: Henric wollert                    
-- Datum: 2003-10-02                            
-- Version: 1                                   
-- Rutinbeteckning ??                           
-- Beskr: SP för person och adress uppgifter åt knavet 
-- Tabeller: tbasperson, tkyrkoperson, tadress.
-- Sökbegr: Personnummer.
-- Retur: 23 parametrar.
--Ändrat:2006-06-19 SL Bug 1318 Ändrat så att man ej returnerar null i några fält, förutom datumfältet civilståndsdatum,
--kyrkotillhorighetsdatum och avregisteringsdatum.
-- Ändrat av: Susanna Lindkvist 
-- Datum: 2008-05-25     Kug  2978      

--Returparametrar
DEFINE p_svar				INTEGER;		--1  
DEFINE p_arskyddad			char(1);		--2  
DEFINE p_persnr_ut			varchar(12);    	--3  
DEFINE p_fornamn			VARCHAR(80);    	--4  
DEFINE p_tilltalsnamn			VARCHAR(80);    	--5  
DEFINE p_efternamn           		VARCHAR(60);    	--6  
DEFINE p_mellannamn			VARCHAR(40);    	--7  
DEFINE p_aviseringsnamn			VARCHAR(36);    	--8  
DEFINE p_fastighet			VARCHAR(50);    	--9  
DEFINE p_avregistreringsorsak		CHAR(2);        	--10 
DEFINE p_fblkf				CHAR(6);		--11	
DEFINE p_kyrkolkf			CHAR(6);		--12 
DEFINE p_kyrkotillhorighetsdatum	DATE;	        	--13 
DEFINE p_medlemstyp			CHAR(3);		--14 
DEFINE p_andraddatum			DATE;	        	--15 
DEFINE p_adresstyp              	CHAR(2);	     	--16 
DEFINE p_coadress               	VARCHAR(35);         	--17	
DEFINE p_adress1                	VARCHAR(35);         	--18 
DEFINE p_adress2                	VARCHAR(35);         	--19 
DEFINE p_adress3                	VARCHAR(35);         	--20 
DEFINE p_postnummer             	VARCHAR(9);          	--21 
DEFINE p_postort                	VARCHAR(35);         	--22 
DEFINE p_land                   	VARCHAR(35);         	--23 
DEFINE p_civilstand			varchar(2); 		--24 nytt 20040402 HW
DEFINE p_civilstandsdatum		DATE;			--25 nytt 20040402 HW
DEFINE p_status				CHAR(1);		--26 nytt 20040402 HW
DEFINE p_avregisteringsdatum		VarCHAR(8);		--27 nytt 20050215 Perre
DEFINE p_kontroll			INTEGER;		-- 20051216 Perre			
	
--tempvariabler
DEFINE p_personid			INTEGER;
DEFINE p_skapaddatum			DATE;	
DEFINE p_sortnr				INTEGER;

-- Felrutin                   
DEFINE sql_err integer;       
DEFINE isam_err integer;      
DEFINE error_info char(70);   

ON exception set sql_err, isam_err, error_info
	call error_log(sql_err, isam_err, error_info,'fetchpersonnavet',3061);
	return       3061, -- SQL fel i fetchpersonnavet.
	" ",	--2 	
	p_persnr,--3         
	" ",    --4         
	" ",    --5         
	" ",    --6         
	" ",    --7         
	" ",    --8           
	" ",    --9         
	" ",    --10        
	" ",    --11        
	" ",    --12        
	" ",    --13        
	" ",    --14        
	" ",    --15        
	" ",    --16          
	" ",    --17        
	" ",    --18        
	" ",    --19          
	" ",    --20        
	" ",    --21        
	" ",    --22        
	" ",  	--23
	" ",	--24
	NULL,	--25
	" ",	--26                                
	NULL;	--27                                
	                
	raise exception sql_err, isam_err, error_info;
END exception;

SET LOCK MODE TO WAIT 10;
SET ISOLATION TO DIRTY READ;
SET LOCK MODE TO WAIT 10;

--Returparametrar
LET p_svar			=0;
LET p_arskyddad			=" ";

LET p_fornamn			=" ";
LET p_tilltalsnamn		=" ";	
LET p_efternamn           	=" ";
LET p_mellannamn		=" ";
LET p_aviseringsnamn		=" ";
LET p_fastighet			=" ";
LET p_avregistreringsorsak	=" ";
LET p_fblkf			=" ";
LET p_kyrkolkf			=" ";
LET p_kyrkotillhorighetsdatum	= NULL;
LET p_medlemstyp		=" ";
LET p_andraddatum		=NULL;
LET p_adresstyp              	=" ";
LET p_coadress               	=" ";
LET p_adress1                	=" ";
LET p_adress2                	=" ";
LET p_adress3                	=" ";
LET p_postnummer             	=" ";
LET p_postort                	=" ";
LET p_land                   	=" ";
LET p_civilstandsdatum		=NULL;
LET p_civilstand		=" ";	
LET p_avregisteringsdatum       =NULL; -- Perre 20050215
LET p_status                   	=" ";

--tempvariabler
LET p_personid			=0;
LET p_skapaddatum		=" ";	
LET p_sortnr			=0;
LET p_kontroll = 0;

LET p_persnr_ut=p_persnr;			


SELECT	bp.arskyddad,			
	bp.persnr,
	bp.personid,			
	kp.fornamn,			
	kp.tilltalsnamn,		
	kp.efternamn,           	
	kp.mellannamn,		
	kp.aviseringsnamn,		
	kp.fastighet,			
	kp.avregistreringsorsak,	
	kp.fblkf,			
	kp.kyrkolkf,			
	kp.kyrkotillhorighetsdatum,	
	kp.medlemstyp,		
	kp.andraddatum,		
        kp.skapaddatum,
        kp.civilstand,
        kp.civilstandsdatum,
	kp.avregisteringsdatum
INTO	p_arskyddad,			        
        p_persnr,
        p_personid,			
        p_fornamn,			
        p_tilltalsnamn,		        
        p_efternamn,           	        
        p_mellannamn,		        
        p_aviseringsnamn,		
        p_fastighet,			
        p_avregistreringsorsak,	        
        p_fblkf,			        
        p_kyrkolkf,			
        p_kyrkotillhorighetsdatum,	
        p_medlemstyp,		        
        p_andraddatum,
        p_skapaddatum,
        p_civilstand,		--nytt 20040402 HW
        p_civilstandsdatum,     --nytt 20040402 HW
        p_avregisteringsdatum   --nytt 20050215 Perre
FROM	tbasperson bp,
	tkyrkoperson kp
WHERE	bp.personid = kp.personid
AND	bp.persnr = p_persnr;

IF(p_arskyddad is NULL) THEN 
	LET p_arskyddad	=" ";
END IF;

IF(p_tilltalsnamn is NULL) THEN 
	LET p_tilltalsnamn = " "; 
END IF;
IF(p_fornamn is NULL) THEN 
	LET p_fornamn = " "; 
END IF;
IF(p_efternamn is NULL) THEN 
	LET p_efternamn = " "; 
END IF;
IF(p_fastighet is NULL) THEN 
	LET p_fastighet = " "; 
END IF;
IF(p_mellannamn is NULL) THEN 
	LET p_mellannamn = " "; 
END IF;
IF(p_aviseringsnamn is NULL) THEN 
	LET p_aviseringsnamn = " ";
END IF;
IF(p_avregistreringsorsak is NULL) THEN 
	LET p_avregistreringsorsak = " "; 
END IF;
IF(p_kyrkotillhorighetsdatum is NULL) THEN 
	LET p_kyrkotillhorighetsdatum = " ";
END IF;
IF(p_fblkf is NULL) THEN 
	LET p_fblkf = " ";
END IF;
IF(p_kyrkolkf is NULL) THEN 
	LET p_kyrkolkf = " "; 
END IF;

IF(p_medlemstyp is NULL) THEN 
	LET p_medlemstyp = " "; 
END IF;

IF(p_civilstand is NULL) THEN 
	LET p_civilstand = " "; 
END IF;

IF ( (DBINFO("SQLCA.sqlerrd2") != 1) OR (p_avregistreringsorsak in ('GN','GS','AS','TA')) ) THEN 
	RETURN	0, --Ingen träff i fetchpersonnavet. 
		" ",		--2 
		p_persnr_ut,    --3 
		" ",    	--4 
		" ",    	--5 
		" ",    	--6 
		" ",    	--7 
		" ",    	--8 
		" ",    	--9 
		" ",    	--10
		" ",    	--11
		" ",    	--12
		" ",   		--13
		" ",    	--14
		" ",    	--15
		" ",    	--16
		" ",    	--17
		" ",    	--18
		" ",    	--19
		" ",    	--20
		" ",    	--21
		" ",    	--22
		" ",  		--23
		" ",		--24
		NULL,		--25
		"E",		--26         
		NULL;		--27

ELIF (p_arskyddad = 'J') THEN
	RETURN	p_svar,		--1
		p_arskyddad,	--2 	  
		p_persnr,    	--3       
		" ",    	--4       
		" ",    	--5       
		" ",    	--6       
		" ",    	--7       
		" ",    	--8       
		" ",    	--9       
		" ",    	--10      
		" ",    	--11      
		" ",    	--12      
		" ",   		--13      
		" ",    	--14      
		" ",    	--15      
		" ",    	--16      
		" ",    	--17      
		" ",    	--18      
		" ",    	--19      
		" ",    	--20      
		" ",    	--21      
		" ",    	--22      
		" ",  		--23
		" ",		--24
		NULL,		--25
		"S",		--26      	
		NULL;		--27

ELIF (p_avregistreringsorsak='AV') THEN           
	
	IF p_andraddatum IS NULL THEN
		LET p_andraddatum = p_skapaddatum;
	END IF;	
	
	RETURN	p_svar,			        --1     
		p_arskyddad,		        --2 	
		p_persnr,			--3     
		p_fornamn,		        --4             
		p_tilltalsnamn,		        --5     
		p_efternamn,           	        --6     
		p_mellannamn,		        --7     
		p_aviseringsnamn,		--8     
		p_fastighet,		        --9     
		p_avregistreringsorsak,	        --10    
		p_fblkf,		        --11    
		p_kyrkolkf,		        --12    
		p_kyrkotillhorighetsdatum,      --13    
		p_medlemstyp,		        --14    
		p_andraddatum,		        --15    
		" ",                    	--16    
		" ",                     	--17    
		" ",                      	--18    
		" ",                      	--19    
		" ",                      	--20    
		" ",                   		--21    
		" ",                      	--22    
		" ",                         	--23
		" ",				--24
		NULL,				--25
		"T",				--26         
		p_avregisteringsdatum;		--27
ELSE
	
	IF (p_avregistreringsorsak = 'PA') THEN           
		LET p_avregistreringsorsak = " ";
	ELIF (p_avregistreringsorsak = 'OB') THEN           
		LET p_avregistreringsorsak = "AN";
	ELIF p_andraddatum IS NULL THEN
		LET p_andraddatum = p_skapaddatum;
	END IF;	

	FOREACH
		SELECT	FIRST 3 
			a.coadress, 
		        a.adress1,
		        a.adress2,
		        a.adress3,
		        a.postnummer,
		        a.postort,
		        a.land,	        
		        a.adresstyp,
		        k.sortnr	        
		INTO	p_coadress,   	
		        p_adress1,    
			p_adress2,    
		        p_adress3,    
		        p_postnummer, 
		        p_postort,    
		        p_land,       
		        p_adresstyp,
		        p_sortnr	        
		FROM    tadress a,
			tkoder k
		WHERE	a.personid = p_personid
		AND 	a.adresstyp = k.kod 	
		AND 	k.kodtyp = 'PERSADR'
		AND 	k.kod != 'T1'
		ORDER BY k.sortnr

		IF(p_adresstyp is NULL OR p_adresstyp= '') THEN 
			LET p_adresstyp = " "; 
		END IF;	
		IF(p_coadress is NULL OR p_coadress= '') THEN 
			LET p_coadress = " "; 
		END IF;	
		IF(p_adress1 is NULL OR p_adress1 = '') THEN 
			LET p_adress1 = " "; 
		END IF;	
		IF(p_adress2 is NULL) THEN 
			LET p_adress2 = " "; 
		END IF;	
		IF(p_adress3 is NULL OR p_adress3 = '') THEN 
			LET p_adress3 = " "; 
		END IF;	
		IF(p_postnummer is NULL) THEN 
			LET p_postnummer = " ";
		END IF;	
		IF(p_postort is NULL) 
			THEN LET p_postort = " "; 		
		END IF;
		IF(p_land is NULL OR p_land ='') THEN 
			LET p_land = " "; 
		END IF;
		LET p_kontroll = 1;		

	RETURN	p_svar,			        --1     
		p_arskyddad,		        --2 	
		p_persnr,			--3     
		p_fornamn,		        --4             
		p_tilltalsnamn,		        --5     
		p_efternamn,           	        --6     
		p_mellannamn,		        --7     
		p_aviseringsnamn,		--8     
		p_fastighet,		        --9     
		p_avregistreringsorsak,	        --10    
		p_fblkf,		        --11    
		p_kyrkolkf,		        --12    
		p_kyrkotillhorighetsdatum,      --13    
		p_medlemstyp,		        --14    
		p_andraddatum,		        --15    
		p_adresstyp,                    --16    
		p_coadress,                     --17    
		p_adress1,                      --18    
		p_adress2,                      --19    
		p_adress3,                      --20    
		p_postnummer,                   --21    
		p_postort,                      --22    
		p_land, 			--23
		p_civilstand,		   	--24
		p_civilstandsdatum,		--25
		"T",				--26
		p_avregisteringsdatum  		--27
			WITH resume;
	
	END FOREACH;
	IF ( p_kontroll = 0 ) THEN

	RETURN	p_svar,			        --1     
		p_arskyddad,		        --2 	
		p_persnr,			--3     
		p_fornamn,		        --4             
		p_tilltalsnamn,		        --5     
		p_efternamn,           	        --6     
		p_mellannamn,		        --7     
		p_aviseringsnamn,		--8     
		p_fastighet,		        --9     
		p_avregistreringsorsak,	        --10    
		p_fblkf,		        --11    
		p_kyrkolkf,		        --12    
		p_kyrkotillhorighetsdatum,      --13    
		p_medlemstyp,		        --14    
		p_andraddatum,		        --15    
		" ",				--16    
		" ",				--17    
		" ",				--18    
		" ",				--19    
		" ",				--20    
		" ",				--21    
		" ",				--22    
		" ",				--23
		p_civilstand,		   	--24
		p_civilstandsdatum,		--25
		"T",				--26
		p_avregisteringsdatum; 		--27

	END IF;

	
END IF;                         
        	
-- $Log: fetchpersonnavet.sql,v $
-- Revision 1.6  2012/10/15 14:45:50  idersv
-- bugg6833 - la till resterande avregistreringsorsaker
--
-- Revision 1.5  2012/09/20 09:15:08  idersv
-- Kugg 6833 -Samtliga avregistreringsorsaker, övriga delar
--
-- Revision 1.4  2012/09/17 12:40:08  idalbe
-- justerat fastighetsfältet till 50 tecken, k6684
--
-- Revision 1.3  2008/05/26 12:47:16  informix
-- *** empty log message ***
--
-- Revision 1.2  2006/08/24 13:05:31  ovew
-- k1318
--
-- Revision 1.1  2006/08/24 08:56:34  ovew
-- knavet1.2 051220
--
END PROCEDURE;  
