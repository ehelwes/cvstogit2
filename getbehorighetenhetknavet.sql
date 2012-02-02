create procedure "informix".getbehorighetenhetknavet(
p_userid char(10),  
p_system char(10),
p_enhetsid INT)  
  
RETURNING
int, --p_svar
varchar(255,0); --Behoriglista  

--@(#)$Id: getbehorighetenhetknavet.sql,v 1.5 2012/02/02 11:43:14 informix Exp $



  
-- Skapat av: Perre Forsberg
-- Datum: 2005-02-18 (Bygger på getbehorighetenhet  
-- Ändrat:  2004-11-26 Perre Forsberg. Ändrat så att proceduren hanterar 200 st behörigheter.
-- Ändrat:  2008-09-10 B3676 Susanna Lindkvist Fel om fler än 100 behörigheter hämtas. Else-sats saknas
-- Ändrat:  2012-01-31 K6475 Rolf Wasteson Ändrat så att proceduren hanterar 254 st behörigheter.
-- Version: 1  
-- Rutinbeteckning ?? 
-- Felkod 1508-1514 
-- Hämtar behorighetstrangen som är enhetsberoende för en användare
-- och en enhet alt för någon enhet om enhetsid = 0
  
DEFINE p_svar integer;  
DEFINE p_behorighet varchar(255,0);  
DEFINE p_tag integer;  --behorighetsnummer
DEFINE p_pos integer;  --behorighetsposition
DEFINE p_sort integer;  --listposition




define sql_err integer;  
define isam_err integer;  
define error_info char(70);  
  
  
-- Felrutin  
  
on exception set sql_err, isam_err, error_info  
	call error_log(sql_err, isam_err, error_info, p_userid, '1508');
	return 1508,null;
	raise exception sql_err, isam_err, error_info;  
end exception;  
SET LOCK MODE TO WAIT 10;  
  
LET p_svar = 0;  
LET p_behorighet = "F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";  
LET p_tag = 0;	  
LET p_pos = 0;	  
LET p_sort = 0;	  

FOREACH
	SELECT	distinct r.rutinid,
		ro.position
	INTO	p_tag,
		p_pos
	FROM	trutin r,
		trutinobjekt ro,
		tegenskapsrutin t,
		tegenskap g,
		trollegenskap e,
		troll rr,
		tanvkatroll a,
		tanvbehorig b
	WHERE	b.userid = p_userid
	AND 	(p_enhetsid = 0 
		OR (b.enhetsid = p_enhetsid OR b.enhetsid in (select h.enhetsid from tenhethierarkitot h, tanvkat kk where h.enhetunder = p_enhetsid AND h.hierarkityp = kk.hierarkityp AND kk.anvkatid = b.anvkatid ) ) )
	AND	b.anvkatid = a.anvkatid
	AND	a.rollid = e.rollid
	AND	e.rollid = rr.rollid
        AND     ((p_system = "ORGREG" AND rr.orgreg = "J")
                OR (p_system = "KBOK" AND rr.kbok = "J")
                OR (p_system IS NOT NULL AND p_system != "" AND rr.knavet=p_system))
	AND	e.egenskapsid = g.egenskapsid
	AND	(g.giltigfran is NULL OR g.giltigfran <= date(CURRENT))
	AND	(g.giltigtill is NULL OR g.giltigtill >= date(CURRENT))
	AND	e.egenskapsid = t.egenskapsid
	AND	t.rutinid = r.rutinid
	AND	r.rutinid = ro.rutinid
	AND	ro.objekttyp = "F"
	order by 2

	IF(p_pos < 20) THEN
	IF (p_pos = 1) THEN
	    LET p_behorighet[2,2] = "1";
	ELSE 
	IF (p_pos = 2) THEN
	    LET p_behorighet[3,3] = "1";
	ELSE
	IF (p_pos = 3) THEN
	    LET p_behorighet[4,4] = "1";
	ELSE
	IF (p_pos = 4) THEN
	    LET p_behorighet[5,5] = "1";
	ELSE
	IF (p_pos = 5) THEN
	    LET p_behorighet[6,6] = "1";
	ELSE
	IF (p_pos = 6) THEN
	    LET p_behorighet[7,7] = "1";
	ELSE
	IF (p_pos = 7) THEN
	    LET p_behorighet[8,8] = "1";
	ELSE
	IF (p_pos = 8) THEN
	    LET p_behorighet[9,9] = "1";
	ELSE
	IF (p_pos = 9) THEN
	    LET p_behorighet[10,10] = "1";
	ELSE
	IF (p_pos = 10) THEN
	    LET p_behorighet[11,11] = "1";
	ELSE
	IF (p_pos = 11) THEN
	    LET p_behorighet[12,12] = "1";
	ELSE
	IF (p_pos = 12) THEN
	    LET p_behorighet[13,13] = "1";
	ELSE
	IF (p_pos = 13) THEN
	    LET p_behorighet[14,14] = "1";
	ELSE
	IF (p_pos = 14) THEN
	    LET p_behorighet[15,15] = "1";
	ELSE
	IF (p_pos = 15) THEN
	    LET p_behorighet[16,16] = "1";
	ELSE
	IF (p_pos = 16) THEN
	    LET p_behorighet[17,17] = "1";
	ELSE
	IF (p_pos = 17) THEN
	    LET p_behorighet[18,18] = "1";
	ELSE
	IF (p_pos = 18) THEN
	    LET p_behorighet[19,19] = "1";
	ELSE
	IF (p_pos = 19) THEN
	    LET p_behorighet[20,20] = "1";

	END IF; --1
	END IF; --2
	END IF; --2
	END IF; --4
	END IF; --5
	END IF; --6
	END IF; --7
	END IF; --8
	END IF; --9
	END IF; --10
	END IF; --11
	END IF; --12
	END IF; --13
	END IF; --14
	END IF; --15
	END IF; --16
	END IF; --17
	END IF; --18
	END IF; --19

	ELSE
	IF (p_pos < 40) THEN


	IF (p_pos = 20) THEN
	    LET p_behorighet[21,21] = "1";
	ELSE
	IF (p_pos = 21) THEN
	    LET p_behorighet[22,22] = "1";
	ELSE
	IF (p_pos = 22) THEN
	    LET p_behorighet[23,23] = "1";
	ELSE
	IF (p_pos = 23) THEN
	    LET p_behorighet[24,24] = "1";
	ELSE
	IF (p_pos = 24) THEN
	    LET p_behorighet[25,25] = "1";
	ELSE
	IF (p_pos = 25) THEN
	    LET p_behorighet[26,26] = "1";
	ELSE
	IF (p_pos = 26) THEN
	    LET p_behorighet[27,27] = "1";
	ELSE
	IF (p_pos = 27) THEN
	    LET p_behorighet[28,28] = "1";
	ELSE
	IF (p_pos = 28) THEN
	    LET p_behorighet[29,29] = "1";
	ELSE
	IF (p_pos =29) THEN
	    LET p_behorighet[30,30] = "1";
	ELSE
	IF (p_pos = 30) THEN
	    LET p_behorighet[31,31] = "1";
	ELSE
	IF (p_pos = 31) THEN
	    LET p_behorighet[32,32] = "1";
	ELSE
	IF (p_pos = 32) THEN
	    LET p_behorighet[33,33] = "1";
	ELSE
	IF (p_pos = 33) THEN
	    LET p_behorighet[34,34] = "1";
	ELSE
	IF (p_pos = 34) THEN
	    LET p_behorighet[35,35] = "1";
	ELSE
	IF (p_pos = 35) THEN
	    LET p_behorighet[36,36] = "1";
	ELSE
	IF (p_pos = 36) THEN
	    LET p_behorighet[37,37] = "1";
	ELSE
	IF (p_pos = 37) THEN
	    LET p_behorighet[38,38] = "1";
	ELSE
	IF (p_pos = 38) THEN
	    LET p_behorighet[39,39] = "1";
	ELSE
	IF (p_pos = 39) THEN
	    LET p_behorighet[40,40] = "1";
	END IF; --20
	END IF; --21
	END IF; --22
	END IF; --22
	END IF; --24
	END IF; --25
	END IF; --26
	END IF; --27
	END IF; --28
	END IF; --29
	END IF; --30
	END IF; --31
	END IF; --32
	END IF; --33
	END IF; --34
	END IF; --35
	END IF; --36
	END IF; --37
	END IF; --38
	END IF; --39
	ELSE
	IF (p_pos < 60) THEN


	IF (p_pos = 40) THEN
	    LET p_behorighet[41,41] = "1";
	ELSE
	IF (p_pos = 41) THEN
	    LET p_behorighet[42,42] = "1";
	ELSE
	IF (p_pos = 42) THEN
	    LET p_behorighet[43,43] = "1";
	ELSE
	IF (p_pos = 43) THEN
	    LET p_behorighet[44,44] = "1";
	ELSE
	IF (p_pos = 44) THEN
	    LET p_behorighet[45,45] = "1";
	ELSE
	IF (p_pos = 45) THEN
	    LET p_behorighet[46,46] = "1";
	ELSE
	IF (p_pos = 46) THEN
	    LET p_behorighet[47,47] = "1";
	ELSE
	IF (p_pos = 47) THEN
	    LET p_behorighet[48,48] = "1";
	ELSE
	IF (p_pos = 48) THEN
	    LET p_behorighet[49,49] = "1";
	ELSE
	IF (p_pos = 49) THEN
	    LET p_behorighet[50,50] = "1";
	ELSE
	IF (p_pos = 50) THEN
	    LET p_behorighet[51,51] = "1";
	ELSE
	IF (p_pos = 51) THEN
	    LET p_behorighet[52,52] = "1";
	ELSE
	IF (p_pos = 52) THEN
	    LET p_behorighet[53,53] = "1";
	ELSE
	IF (p_pos = 53) THEN
	    LET p_behorighet[54,54] = "1";
	ELSE
	IF (p_pos = 54) THEN
	    LET p_behorighet[55,55] = "1";
	ELSE
	IF (p_pos = 55) THEN
	    LET p_behorighet[56,56] = "1";
	ELSE
	IF (p_pos = 56) THEN
	    LET p_behorighet[57,57] = "1";
	ELSE
	IF (p_pos = 57) THEN
	    LET p_behorighet[58,58] = "1";
	ELSE
	IF (p_pos = 58) THEN
	    LET p_behorighet[59,59] = "1";
	ELSE
	IF (p_pos = 59) THEN
	    LET p_behorighet[60,60] = "1";
	END IF; --40
	END IF; --41
	END IF; --42
	END IF; --42
	END IF; --44
	END IF; --45
	END IF; --46
	END IF; --47
	END IF; --48
	END IF; --49
	END IF; --50
	END IF; --51
	END IF; --52
	END IF; --53
	END IF; --54
	END IF; --55
	END IF; --56
	END IF; --57
	END IF; --58
	END IF; --59
	ELSE
	IF(p_pos < 80) THEN
	IF (p_pos = 60) THEN
	    LET p_behorighet[61,61] = "1";
	ELSE
	IF (p_pos = 61) THEN
	    LET p_behorighet[62,62] = "1";
	ELSE
	IF (p_pos = 62) THEN
	    LET p_behorighet[63,63] = "1";
	ELSE
	IF (p_pos = 63) THEN
	    LET p_behorighet[64,64] = "1";
	ELSE
	IF (p_pos = 64) THEN
	    LET p_behorighet[65,65] = "1";
	ELSE
	IF (p_pos = 65) THEN
	    LET p_behorighet[66,66] = "1";
	ELSE
	IF (p_pos = 66) THEN
	    LET p_behorighet[67,67] = "1";
	ELSE
	IF (p_pos = 67) THEN
	    LET p_behorighet[68,68] = "1";
	ELSE
	IF (p_pos = 68) THEN
	    LET p_behorighet[69,69] = "1";
	ELSE
	IF (p_pos = 69) THEN
	    LET p_behorighet[70,70] = "1";
	ELSE
	IF (p_pos = 70) THEN
	    LET p_behorighet[71,71] = "1";
	ELSE
	IF (p_pos = 71) THEN
	    LET p_behorighet[72,72] = "1";
	ELSE
	IF (p_pos = 72) THEN
	    LET p_behorighet[73,73] = "1";
	ELSE
	IF (p_pos = 73) THEN
	    LET p_behorighet[74,74] = "1";
	ELSE
	IF (p_pos = 74) THEN
	    LET p_behorighet[75,75] = "1";
	ELSE
	IF (p_pos = 75) THEN
	    LET p_behorighet[76,76] = "1";
	ELSE
	IF (p_pos = 76) THEN
	    LET p_behorighet[77,77] = "1";
	ELSE
	IF (p_pos = 77) THEN
	    LET p_behorighet[78,78] = "1";
	ELSE
	IF (p_pos = 78) THEN
	    LET p_behorighet[79,79] = "1";
	ELSE
	IF (p_pos = 79) THEN
	    LET p_behorighet[80,80] = "1";
	END IF; --60
	END IF; --61
	END IF; --62
	END IF; --62
	END IF; --64
	END IF; --65
	END IF; --66
	END IF; --67
	END IF; --68
	END IF; --69
	END IF; --70
	END IF; --71
	END IF; --72
	END IF; --73
	END IF; --74
	END IF; --75
	END IF; --76
	END IF; --77
	END IF; --78
	END IF; --79
	ELSE
	IF (p_pos < 101) THEN
	IF (p_pos = 80) THEN
	    LET p_behorighet[81,81] = "1";
	ELSE
	IF (p_pos = 81) THEN
	    LET p_behorighet[82,82] = "1";
	ELSE
	IF (p_pos = 82) THEN
	    LET p_behorighet[83,83] = "1";
	ELSE
	IF (p_pos = 83) THEN
	    LET p_behorighet[84,84] = "1";
	ELSE
	IF (p_pos = 84) THEN
	    LET p_behorighet[85,85] = "1";
	ELSE
	IF (p_pos = 85) THEN
	    LET p_behorighet[86,86] = "1";
	ELSE
	IF (p_pos = 86) THEN
	    LET p_behorighet[87,87] = "1";
	ELSE
	IF (p_pos = 87) THEN
	    LET p_behorighet[88,88] = "1";
	ELSE
	IF (p_pos = 88) THEN
	    LET p_behorighet[89,89] = "1";
	ELSE
	IF (p_pos = 89) THEN
	    LET p_behorighet[90,90] = "1";
	ELSE
	IF (p_pos = 90) THEN
	    LET p_behorighet[91,91] = "1";
	ELSE
	IF (p_pos = 91) THEN
	    LET p_behorighet[92,92] = "1";
	ELSE
	IF (p_pos = 92) THEN
	    LET p_behorighet[93,93] = "1";
	ELSE
	IF (p_pos = 93) THEN
	    LET p_behorighet[94,94] = "1";
	ELSE
	IF (p_pos = 94) THEN
	    LET p_behorighet[95,95] = "1";
	ELSE
	IF (p_pos = 95) THEN
	    LET p_behorighet[96,96] = "1";
	ELSE
	IF (p_pos = 96) THEN
	    LET p_behorighet[97,97] = "1";
	ELSE
	IF (p_pos = 97) THEN
	    LET p_behorighet[98,98] = "1";
	ELSE
	IF (p_pos = 98) THEN
	    LET p_behorighet[99,99] = "1";
	ELSE
	IF (p_pos = 99) THEN
	    LET p_behorighet[100,100] = "1";
	ELSE
	IF (p_pos = 100) THEN
	    LET p_behorighet[101,101] = "1";
	END IF; --80
	END IF; --81
	END IF; --82
	END IF; --82
	END IF; --84
	END IF; --85
	END IF; --86
	END IF; --87
	END IF; --88
	END IF; --89
	END IF; --90
	END IF; --91
	END IF; --92
	END IF; --93
	END IF; --94
	END IF; --95
	END IF; --96
	END IF; --97
	END IF; --98
	END IF; --99
	END IF; --100
	ELSE
	IF (p_pos < 120) THEN
	IF (p_pos = 101) THEN
	    LET p_behorighet[102,102] = "1";
	ELSE 
	IF (p_pos = 102) THEN
	    LET p_behorighet[103,103] = "1";
	ELSE
	IF (p_pos = 103) THEN
	    LET p_behorighet[104,104] = "1";
	ELSE
	IF (p_pos = 104) THEN
	    LET p_behorighet[105,105] = "1";
	ELSE
	IF (p_pos = 105) THEN
	    LET p_behorighet[106,106] = "1";
	ELSE
	IF (p_pos = 106) THEN
	    LET p_behorighet[107,107] = "1";
	ELSE
	IF (p_pos = 107) THEN
	    LET p_behorighet[108,108] = "1";
	ELSE
	IF (p_pos = 108) THEN
	    LET p_behorighet[109,109] = "1";
	ELSE
	IF (p_pos = 109) THEN
	    LET p_behorighet[110,110] = "1";
	ELSE
	IF (p_pos = 110) THEN
	    LET p_behorighet[111,111] = "1";
	ELSE
	IF (p_pos = 111) THEN
	    LET p_behorighet[112,112] = "1";
	ELSE
	IF (p_pos = 112) THEN
	    LET p_behorighet[113,113] = "1";
	ELSE
	IF (p_pos = 113) THEN
	    LET p_behorighet[114,114] = "1";
	ELSE
	IF (p_pos = 114) THEN
	    LET p_behorighet[115,115] = "1";
	ELSE
	IF (p_pos = 115) THEN
	    LET p_behorighet[116,116] = "1";
	ELSE
	IF (p_pos = 116) THEN
	    LET p_behorighet[117,117] = "1";
	ELSE
	IF (p_pos = 117) THEN
	    LET p_behorighet[118,118] = "1";
	ELSE
	IF (p_pos = 118) THEN
	    LET p_behorighet[119,119] = "1";
	ELSE
	IF (p_pos = 119) THEN
	    LET p_behorighet[120,120] = "1";

	END IF; --101
	END IF; --102
	END IF; --103
	END IF; --104
	END IF; --105
	END IF; --106
	END IF; --107
	END IF; --108
	END IF; --109
	END IF; --110
	END IF; --111
	END IF; --112
	END IF; --113
	END IF; --114
	END IF; --115
	END IF; --116
	END IF; --117
	END IF; --118
	END IF; --119

	ELSE
	IF (p_pos < 140) THEN


	IF (p_pos = 120) THEN
	    LET p_behorighet[121,121] = "1";
	ELSE
	IF (p_pos = 121) THEN
	    LET p_behorighet[122,122] = "1";
	ELSE
	IF (p_pos = 122) THEN
	    LET p_behorighet[123,123] = "1";
	ELSE
	IF (p_pos = 123) THEN
	    LET p_behorighet[124,124] = "1";
	ELSE
	IF (p_pos = 124) THEN
	    LET p_behorighet[125,125] = "1";
	ELSE
	IF (p_pos = 125) THEN
	    LET p_behorighet[126,126] = "1";
	ELSE
	IF (p_pos = 126) THEN
	    LET p_behorighet[127,127] = "1";
	ELSE
	IF (p_pos = 127) THEN
	    LET p_behorighet[128,128] = "1";
	ELSE
	IF (p_pos = 128) THEN
	    LET p_behorighet[129,129] = "1";
	ELSE
	IF (p_pos = 129) THEN
	    LET p_behorighet[130,130] = "1";
	ELSE
	IF (p_pos = 130) THEN
	    LET p_behorighet[131,131] = "1";
	ELSE
	IF (p_pos = 131) THEN
	    LET p_behorighet[132,132] = "1";
	ELSE
	IF (p_pos = 132) THEN
	    LET p_behorighet[133,133] = "1";
	ELSE
	IF (p_pos = 133) THEN
	    LET p_behorighet[134,134] = "1";
	ELSE
	IF (p_pos = 134) THEN
	    LET p_behorighet[135,135] = "1";
	ELSE
	IF (p_pos = 135) THEN
	    LET p_behorighet[136,136] = "1";
	ELSE
	IF (p_pos = 136) THEN
	    LET p_behorighet[137,137] = "1";
	ELSE
	IF (p_pos = 137) THEN
	    LET p_behorighet[138,138] = "1";
	ELSE
	IF (p_pos = 138) THEN
	    LET p_behorighet[139,139] = "1";
	ELSE
	IF (p_pos = 139) THEN
	    LET p_behorighet[140,140] = "1";
	END IF; --120
	END IF; --121
	END IF; --122
	END IF; --122
	END IF; --124
	END IF; --125
	END IF; --126
	END IF; --127
	END IF; --128
	END IF; --129
	END IF; --130
	END IF; --131
	END IF; --132
	END IF; --133
	END IF; --134
	END IF; --135
	END IF; --136
	END IF; --137
	END IF; --138
	END IF; --139
	ELSE
	IF (p_pos < 160) THEN


	IF (p_pos = 140) THEN
	    LET p_behorighet[141,141] = "1";
	ELSE
	IF (p_pos = 141) THEN
	    LET p_behorighet[142,142] = "1";
	ELSE
	IF (p_pos = 142) THEN
	    LET p_behorighet[143,143] = "1";
	ELSE
	IF (p_pos = 143) THEN
	    LET p_behorighet[144,144] = "1";
	ELSE
	IF (p_pos = 144) THEN
	    LET p_behorighet[145,145] = "1";
	ELSE
	IF (p_pos = 145) THEN
	    LET p_behorighet[146,146] = "1";
	ELSE
	IF (p_pos = 146) THEN
	    LET p_behorighet[147,147] = "1";
	ELSE
	IF (p_pos = 147) THEN
	    LET p_behorighet[148,148] = "1";
	ELSE
	IF (p_pos = 148) THEN
	    LET p_behorighet[149,149] = "1";
	ELSE
	IF (p_pos = 149) THEN
	    LET p_behorighet[150,150] = "1";
	ELSE
	IF (p_pos = 150) THEN
	    LET p_behorighet[151,151] = "1";
	ELSE
	IF (p_pos = 151) THEN
	    LET p_behorighet[152,152] = "1";
	ELSE
	IF (p_pos = 152) THEN
	    LET p_behorighet[153,153] = "1";
	ELSE
	IF (p_pos = 153) THEN
	    LET p_behorighet[154,154] = "1";
	ELSE
	IF (p_pos = 154) THEN
	    LET p_behorighet[155,155] = "1";
	ELSE
	IF (p_pos = 155) THEN
	    LET p_behorighet[156,156] = "1";
	ELSE
	IF (p_pos = 156) THEN
	    LET p_behorighet[157,157] = "1";
	ELSE
	IF (p_pos = 157) THEN
	    LET p_behorighet[158,158] = "1";
	ELSE
	IF (p_pos = 158) THEN
	    LET p_behorighet[159,159] = "1";
	ELSE
	IF (p_pos = 159) THEN
	    LET p_behorighet[160,160] = "1";
	END IF; --140
	END IF; --141
	END IF; --142
	END IF; --143
	END IF; --144
	END IF; --145
	END IF; --146
	END IF; --147
	END IF; --148
	END IF; --149
	END IF; --150
	END IF; --151
	END IF; --152
	END IF; --153
	END IF; --154
	END IF; --155
	END IF; --156
	END IF; --157
	END IF; --158
	END IF; --159
	ELSE
	IF(p_pos < 180) THEN
	IF (p_pos = 160) THEN
	    LET p_behorighet[161,161] = "1";
	ELSE
	IF (p_pos = 161) THEN
	    LET p_behorighet[162,162] = "1";
	ELSE
	IF (p_pos = 162) THEN
	    LET p_behorighet[163,163] = "1";
	ELSE
	IF (p_pos = 163) THEN
	    LET p_behorighet[164,164] = "1";
	ELSE
	IF (p_pos = 164) THEN
	    LET p_behorighet[165,165] = "1";
	ELSE
	IF (p_pos = 165) THEN
	    LET p_behorighet[166,166] = "1";
	ELSE
	IF (p_pos = 166) THEN
	    LET p_behorighet[167,167] = "1";
	ELSE
	IF (p_pos = 167) THEN
	    LET p_behorighet[168,168] = "1";
	ELSE
	IF (p_pos = 168) THEN
	    LET p_behorighet[169,169] = "1";
	ELSE
	IF (p_pos = 169) THEN
	    LET p_behorighet[170,170] = "1";
	ELSE
	IF (p_pos = 170) THEN
	    LET p_behorighet[171,171] = "1";
	ELSE
	IF (p_pos = 171) THEN
	    LET p_behorighet[172,172] = "1";
	ELSE
	IF (p_pos = 172) THEN
	    LET p_behorighet[173,173] = "1";
	ELSE
	IF (p_pos = 173) THEN
	    LET p_behorighet[174,174] = "1";
	ELSE
	IF (p_pos = 174) THEN
	    LET p_behorighet[175,175] = "1";
	ELSE
	IF (p_pos = 175) THEN
	    LET p_behorighet[176,176] = "1";
	ELSE
	IF (p_pos = 176) THEN
	    LET p_behorighet[177,177] = "1";
	ELSE
	IF (p_pos = 177) THEN
	    LET p_behorighet[178,178] = "1";
	ELSE
	IF (p_pos = 178) THEN
	    LET p_behorighet[179,179] = "1";
	ELSE
	IF (p_pos = 179) THEN
	    LET p_behorighet[180,180] = "1";
	END IF; --160
	END IF; --161
	END IF; --162
	END IF; --163
	END IF; --164
	END IF; --165
	END IF; --166
	END IF; --167
	END IF; --168
	END IF; --169
	END IF; --170
	END IF; --171
	END IF; --172
	END IF; --173
	END IF; --174
	END IF; --175
	END IF; --176
	END IF; --177
	END IF; --178
	END IF; --179
	ELSE
	IF (p_pos < 200) THEN

	IF (p_pos = 180) THEN
	    LET p_behorighet[181,181] = "1";
	ELSE
	IF (p_pos = 181) THEN
	    LET p_behorighet[182,182] = "1";
	ELSE
	IF (p_pos = 182) THEN
	    LET p_behorighet[183,183] = "1";
	ELSE
	IF (p_pos = 183) THEN
	    LET p_behorighet[184,184] = "1";
	ELSE
	IF (p_pos = 184) THEN
	    LET p_behorighet[185,185] = "1";
	ELSE
	IF (p_pos = 185) THEN
	    LET p_behorighet[186,186] = "1";
	ELSE
	IF (p_pos = 186) THEN
	    LET p_behorighet[187,187] = "1";
	ELSE
	IF (p_pos = 187) THEN
	    LET p_behorighet[188,188] = "1";
	ELSE
	IF (p_pos = 188) THEN
	    LET p_behorighet[189,189] = "1";
	ELSE
	IF (p_pos = 189) THEN
	    LET p_behorighet[190,190] = "1";
	ELSE
	IF (p_pos = 190) THEN
	    LET p_behorighet[191,191] = "1";
	ELSE
	IF (p_pos = 191) THEN
	    LET p_behorighet[192,192] = "1";
	ELSE
	IF (p_pos = 192) THEN
	    LET p_behorighet[193,193] = "1";
	ELSE
	IF (p_pos = 193) THEN
	    LET p_behorighet[194,194] = "1";
	ELSE
	IF (p_pos = 194) THEN
	    LET p_behorighet[195,195] = "1";
	ELSE
	IF (p_pos = 195) THEN
	    LET p_behorighet[196,196] = "1";
	ELSE
	IF (p_pos = 196) THEN
	    LET p_behorighet[197,197] = "1";
	ELSE
	IF (p_pos = 197) THEN
	    LET p_behorighet[198,198] = "1";
	ELSE
	IF (p_pos = 198) THEN
	    LET p_behorighet[199,199] = "1";
	ELSE
	IF (p_pos = 199) THEN
	    LET p_behorighet[200,200] = "1";
	END IF; --180
	END IF; --181
	END IF; --182
	END IF; --183
	END IF; --184
	END IF; --185
	END IF; --186
	END IF; --187
	END IF; --188
	END IF; --189
	END IF; --190
	END IF; --191
	END IF; --192
	END IF; --193
	END IF; --194
	END IF; --195
	END IF; --196
	END IF; --197
	END IF; --198
	END IF; --199
	ELSE
	IF (p_pos < 220) THEN

	IF (p_pos = 200) THEN
	    LET p_behorighet[201,201] = "1";
	ELSE
	IF (p_pos = 201) THEN
	    LET p_behorighet[202,202] = "1";
	ELSE
	IF (p_pos = 202) THEN
	    LET p_behorighet[203,203] = "1";
	ELSE
	IF (p_pos = 203) THEN
	    LET p_behorighet[204,204] = "1";
	ELSE
	IF (p_pos = 204) THEN
	    LET p_behorighet[205,205] = "1";
	ELSE
	IF (p_pos = 205) THEN
	    LET p_behorighet[206,206] = "1";
	ELSE
	IF (p_pos = 206) THEN
	    LET p_behorighet[207,207] = "1";
	ELSE
	IF (p_pos = 207) THEN
	    LET p_behorighet[208,208] = "1";
	ELSE
	IF (p_pos = 208) THEN
	    LET p_behorighet[209,209] = "1";
	ELSE
	IF (p_pos = 209) THEN
	    LET p_behorighet[210,210] = "1";
	ELSE
	IF (p_pos = 210) THEN
	    LET p_behorighet[211,211] = "1";
	ELSE
	IF (p_pos = 211) THEN
	    LET p_behorighet[212,212] = "1";
	ELSE
	IF (p_pos = 212) THEN
	    LET p_behorighet[213,213] = "1";
	ELSE
	IF (p_pos = 213) THEN
	    LET p_behorighet[214,214] = "1";
	ELSE
	IF (p_pos = 214) THEN
	    LET p_behorighet[215,215] = "1";
	ELSE
	IF (p_pos = 215) THEN
	    LET p_behorighet[216,216] = "1";
	ELSE
	IF (p_pos = 216) THEN
	    LET p_behorighet[217,217] = "1";
	ELSE
	IF (p_pos = 217) THEN
	    LET p_behorighet[218,218] = "1";
	ELSE
	IF (p_pos = 218) THEN
	    LET p_behorighet[219,219] = "1";
	ELSE
	IF (p_pos = 219) THEN
	    LET p_behorighet[220,220] = "1";
	END IF; --200
	END IF; --201
	END IF; --202
	END IF; --203
	END IF; --204
	END IF; --205
	END IF; --206
	END IF; --207
	END IF; --208
	END IF; --209
	END IF; --210
	END IF; --211
	END IF; --212
	END IF; --213
	END IF; --214
	END IF; --215
	END IF; --216
	END IF; --217
	END IF; --218
	END IF; --219
	ELSE
	IF (p_pos < 240) THEN

	IF (p_pos = 220) THEN
	    LET p_behorighet[221,221] = "1";
	ELSE
	IF (p_pos = 221) THEN
	    LET p_behorighet[222,222] = "1";
	ELSE
	IF (p_pos = 222) THEN
	    LET p_behorighet[223,223] = "1";
	ELSE
	IF (p_pos = 223) THEN
	    LET p_behorighet[224,224] = "1";
	ELSE
	IF (p_pos = 224) THEN
	    LET p_behorighet[225,225] = "1";
	ELSE
	IF (p_pos = 225) THEN
	    LET p_behorighet[226,226] = "1";
	ELSE
	IF (p_pos = 226) THEN
	    LET p_behorighet[227,227] = "1";
	ELSE
	IF (p_pos = 227) THEN
	    LET p_behorighet[228,228] = "1";
	ELSE
	IF (p_pos = 228) THEN
	    LET p_behorighet[229,229] = "1";
	ELSE
	IF (p_pos = 229) THEN
	    LET p_behorighet[230,230] = "1";
	ELSE
	IF (p_pos = 230) THEN
	    LET p_behorighet[231,231] = "1";
	ELSE
	IF (p_pos = 231) THEN
	    LET p_behorighet[232,232] = "1";
	ELSE
	IF (p_pos = 232) THEN
	    LET p_behorighet[233,233] = "1";
	ELSE
	IF (p_pos = 233) THEN
	    LET p_behorighet[234,234] = "1";
	ELSE
	IF (p_pos = 234) THEN
	    LET p_behorighet[235,235] = "1";
	ELSE
	IF (p_pos = 235) THEN
	    LET p_behorighet[236,236] = "1";
	ELSE
	IF (p_pos = 236) THEN
	    LET p_behorighet[237,237] = "1";
	ELSE
	IF (p_pos = 237) THEN
	    LET p_behorighet[238,238] = "1";
	ELSE
	IF (p_pos = 238) THEN
	    LET p_behorighet[239,239] = "1";
	ELSE
	IF (p_pos = 239) THEN
	    LET p_behorighet[240,240] = "1";
	END IF; --220
	END IF; --221
	END IF; --222
	END IF; --223
	END IF; --224
	END IF; --225
	END IF; --226
	END IF; --227
	END IF; --228
	END IF; --229
	END IF; --230
	END IF; --231
	END IF; --232
	END IF; --233
	END IF; --234
	END IF; --235
	END IF; --236
	END IF; --237
	END IF; --238
	END IF; --239
	ELSE
	IF (p_pos = 240) THEN
	    LET p_behorighet[241,241] = "1";
	ELSE
	IF (p_pos = 241) THEN
	    LET p_behorighet[242,242] = "1";
	ELSE
	IF (p_pos = 242) THEN
	    LET p_behorighet[243,243] = "1";
	ELSE
	IF (p_pos = 243) THEN
	    LET p_behorighet[244,244] = "1";
	ELSE
	IF (p_pos = 244) THEN
	    LET p_behorighet[245,245] = "1";
	ELSE
	IF (p_pos = 245) THEN
	    LET p_behorighet[246,246] = "1";
	ELSE
	IF (p_pos = 246) THEN
	    LET p_behorighet[247,247] = "1";
	ELSE
	IF (p_pos = 247) THEN
	    LET p_behorighet[248,248] = "1";
	ELSE
	IF (p_pos = 248) THEN
	    LET p_behorighet[249,249] = "1";
	ELSE
	IF (p_pos = 249) THEN
	    LET p_behorighet[250,250] = "1";
	ELSE
	IF (p_pos = 250) THEN
	    LET p_behorighet[251,251] = "1";
	ELSE
	IF (p_pos = 251) THEN
	    LET p_behorighet[252,252] = "1";
	ELSE
	IF (p_pos = 252) THEN
	    LET p_behorighet[253,253] = "1";
	ELSE
	IF (p_pos = 253) THEN
	    LET p_behorighet[254,254] = "1";
	ELSE
	IF (p_pos = 254) THEN
	    LET p_behorighet[255,255] = "1";
	END IF; --240
	END IF; --241
	END IF; --242
	END IF; --242
	END IF; --244
	END IF; --245
	END IF; --246
	END IF; --247
	END IF; --248
	END IF; --249
	END IF; --250
	END IF; --251
	END IF; --252
	END IF; --253
	END IF; --254

	END IF; -- >240
	END IF; -- >220
	END IF; -- >200
	END IF; -- >180
	END IF; -- >160
	END IF; -- >140
	END IF; -- >120
	END IF; -- >101
	END IF; -- >80
	END IF; -- >60
	END IF; -- >40
	END IF; -- >20

end foreach;	

	LET p_svar = 0;

	return 	p_svar,
		p_behorighet;
  
-- $Log: getbehorighetenhetknavet.sql,v $
-- Revision 1.5  2012/02/02 11:43:14  informix
-- *** empty log message ***
--
-- Revision 1.2  2008/09/10 09:24:07  informix
-- k-3676
--
-- Revision 1.1  2006/08/24 08:56:35  ovew
-- *** empty log message ***
--
end procedure;


