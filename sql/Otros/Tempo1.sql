Select	'i_consid' = cn.CONT_sCONTINENTE_ID, 
		's_connom' = cn.CONT_vNOMBRE,
		'i_regsid' = PAIS_sREGION_ID, 
		's_regnom' = re.REGI_vNOMBRE,
		'i_paisid' = PAIS_sPAIS_ID, 
		's_painom' = PAIS_vNOMBRE, 
		's_paiofi' = PAIS_vNOMBREOFICIAL, 
		's_paigen' = PAIS_vGENTILICIO,
		's_paimon' = substring(Monedas, 2, len(Monedas))
From	
		SC_COMUN.SE_PAIS ps
 		Inner Join SC_COMUN.SE_REGION re on (re.REGI_sREGION_ID = ps.PAIS_sREGION_ID and re.REGI_cESTADO = 'A')
		Inner Join SC_COMUN.SE_CONTINENTE cn on (cn.CONT_sCONTINENTE_ID = re.REGI_sCONTINENTE_ID and cn.CONT_cESTADO = 'A')
Cross Apply (
	Select	concat(',', mn.MONE_cISO4217)
	From	SC_COMUN.SE_PAIS_MONEDA pm 
			Left Join SC_COMUN.SE_MONEDA mn on (mn.MONE_sMONEDA_ID = pm.PAMO_sMONEDA_ID and mn.MONE_cESTADO = 'A')
	Where
			pm.PAMO_sPAIS_ID = ps.PAIS_sPAIS_ID and
			pm.PAMO_cESTADO = 'A' 
	FOR XML PATH('')) D (Monedas)