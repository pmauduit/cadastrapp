-- Create view proprietaire based on Arcopole Models

CREATE MATERIALIZED VIEW #schema_cadastrapp.proprietaire as 
	SELECT 
		proprietaire.id_proprietaire,
		proprietaire.dnupro,
		proprietaire.lot,
		proprietaire.dnulp,
		proprietaire.ccocif,
		proprietaire.dnuper,
		proprietaire.ccodro_c,
		proprietaire.ccodem_c,
		proprietaire.gdesip,
		proprietaire.gtoper,
		proprietaire.ccoqua_c,
		proprietaire.dnatpr_c,
		proprietaire.ccogrm_c,
		proprietaire.dsglpm,
		proprietaire.dforme,
		proprietaire.ddenom,
		proprietaire.gtyp3,
		proprietaire.gtyp4,
		proprietaire.gtyp5,
		proprietaire.gtyp6,
		proprietaire.dlign3,
		proprietaire.dlign4,
		proprietaire.dlign5,
		proprietaire.dlign6,
		proprietaire.ccopay,
		proprietaire.ccodep1a2,
		proprietaire.ccodira,
		proprietaire.ccocom_adr,
		proprietaire.ccovoi,
		proprietaire.ccoriv,
		proprietaire.dnvoiri,
		proprietaire.dindic,
		proprietaire.ccopos,
		proprietaire.dnirpp,
		proprietaire.dqualp,
		proprietaire.dnomlp,
		proprietaire.dprnlp,
		proprietaire.jdatnss,
		proprietaire.dldnss,
		proprietaire.epxnee,
		proprietaire.dnomcp,
		proprietaire.dprncp,
		proprietaire.dnomus,
		proprietaire.dprnus,
		proprietaire.dformjur,
		proprietaire.dsiren,
		proprietaire.cgocommune,
		proprietaire.comptecommunal,
		proprietaire.app_nom_usage,
		proprietaire.app_nom_naissance,
		prop_ccodro.ccodro, 
		prop_ccodro.ccodro_lib, 
		prop_ccoqua.ccoqua, 
		prop_ccoqua.ccoqua_lib, 
		prop_ccogrm.ccogrm, 
		prop_ccogrm.ccogrm_lib, 
		prop_ccodem.ccodem, 
		prop_ccodem.ccodem_lib, 
		prop_dnatpr.dnatpr, 
		prop_dnatpr.dnatpr_lib 
	FROM dblink('host=#DBHost_arcopole port=#DBPort_arcopole dbname=#DBName_arcopole user=#DBUser_arcopole password=#DBpasswd_arcopole'::text, 
		'select 
			id_prop as id_proprietaire,
			id_prop as dnupro,
			codlot as lot,
			dnulp,
			ccocif,
			dnuper,
			ccodro as ccodro_c,
			ccodem as ccodem_c,
			gdesip,
			gtoper,
			ccoqua as ccoqua_c,
			dnatpr as dnatpr_c,
			ccogrm as ccogrm_c,
			dsglpm,
			dforme,
			REPLACE(rtrim(ddenom),''/'','' '') as ddenom,
			gtyp3,
			gtyp4,
			gtyp5,
			gtyp6,
			dlign3,
			ltrim(dlign4, ''0'') as dlign4,
			dlign5,
			dlign6,
			ccopay,
			ccodepla2 as ccodep1a2,
			ccodira,
			ccomadr as ccocom_adr,
			ccovoi,
			ccoriv,
			ltrim(dnvoiri, ''0'') as dnvoiri,
			dindic,
			ccopos,
			dnirpp,
			dqualp,
			rtrim(dnomlp) as dnomlp,
			rtrim(dprnlp) as dprnlp,
			jdatnss,
			dldnss,
			epxnee,
			rtrim(dnomcp) as dnomcp,
			rtrim(dprncp) as dprncp,
			rtrim(dnomus) as dnomus,
			rtrim(dprnus) as dprnus,
			dformjur,
			''dsiren'' as dsiren,
			substr(id_prop,1,6) as cgocommune,
			id_prop as  comptecommunal,
			(CASE
					WHEN gtoper = ''1'' THEN COALESCE(rtrim(dqualp),'''')||'' ''||COALESCE(rtrim(dnomus),'''')||'' ''||COALESCE(rtrim(dprnus),'''')
					WHEN gtoper = ''2'' THEN rtrim(ddenom)
				END) AS app_nom_usage,
			(CASE
					WHEN gtoper = ''1'' THEN COALESCE(rtrim(dqualp),'''')||'' ''||REPLACE(rtrim(ddenom),''/'','' '')
				END) AS app_nom_naissance
		from #DBSchema_arcopole.dgi_prop'::text) 
	proprietaire(
		id_proprietaire character varying(20), 
		dnupro character varying(12), 
		lot character varying, 
		dnulp character varying(2), 
		ccocif character varying(4), 
		dnuper character varying(6), 
		ccodro_c character varying(1), 
		ccodem_c character varying(1),
		gdesip character varying(1), 
		gtoper character varying(1), 
		ccoqua_c character varying(1), 
		dnatpr_c character varying(3),
		ccogrm_c character varying(2), 
		dsglpm character varying(10), 
		dforme character varying(7), 
		ddenom character varying(60),
		gtyp3 character varying(1), 
		gtyp4 character varying(1), 
		gtyp5 character varying(1), 
		gtyp6 character varying(1), 
		dlign3 character varying(30), 
		dlign4 character varying(36), 
		dlign5 character varying(30), 
		dlign6 character varying(32), 
		ccopay character varying(3), 
		ccodep1a2 character varying(2), 
		ccodira character varying(1), 
		ccocom_adr character varying(3), 
		ccovoi character varying(5), 
		ccoriv character varying(4), 
		dnvoiri character varying(4), 
		dindic character varying(1), 
		ccopos character varying(5), 
		dnirpp character varying(10), 
		dqualp character varying(3), 
		dnomlp character varying(30), 
		dprnlp character varying(15), 
		jdatnss character varying(10), 
		dldnss character varying(58), 
		epxnee character varying(3),
		dnomcp character varying(30), 
		dprncp character varying(15), 
		dnomus character varying(60),
		dprnus character varying(40),
		dformjur character varying(4), 
		dsiren character varying(10),
		cgocommune character varying(6), 
		comptecommunal character varying(15),
		app_nom_usage character varying(120),
		app_nom_naissance character varying(70))
			LEFT JOIN #schema_cadastrapp.prop_ccodro ON proprietaire.ccodro_c::text = prop_ccodro.ccodro::text
			LEFT JOIN #schema_cadastrapp.prop_ccoqua ON proprietaire.ccoqua_c::text = prop_ccoqua.ccoqua::text
			LEFT JOIN #schema_cadastrapp.prop_ccogrm ON proprietaire.ccogrm_c::text = prop_ccogrm.ccogrm::text
			LEFT JOIN #schema_cadastrapp.prop_ccodem ON proprietaire.ccodem_c::text = prop_ccodem.ccodem::text
			LEFT JOIN #schema_cadastrapp.prop_dnatpr ON proprietaire.dnatpr_c::text = prop_dnatpr.dnatpr::text;

ALTER TABLE #schema_cadastrapp.proprietaire OWNER TO #user_cadastrapp;

