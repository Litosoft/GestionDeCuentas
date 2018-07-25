Select	MODU_sID 's_idmodu', MODU_sPADRE_ID 's_pad_id',
		MODU_vICONO 'v_icono', MODU_vNOMBRE 'v_nombre', MODU_vDESCRIPCION 'v_descri', MODU_tORDEN 't_orden',
		MODU_vCONTROLADOR 'v_contro', MODU_vMETODO 'v_metodo', MODU_vPARAMETRO 'v_param', MODU_vURL 'v_url',
		MODU_bPOPUP 'b_popup', MODU_bCLICK 'b_clic',
		MODU_tSITUACION 'b_situac'
From	
		SC_INTERNO.AUTH_MODULO
Where
		MODU_cESTADO = 'A'
