-- Create view proprietebatie based on Arcopole Models

CREATE MATERIALIZED VIEW #schema_cadastrapp.proprietebatie AS
	SELECT 
		proprietebatie.id_local,
		proprietebatie.parcelle,
		proprietebatie.comptecommunal , 
		proprietebatie.dnupro,
		proprietebatie.cgocommune,
		proprietebatie.ccopre,
		proprietebatie.ccosec,
		proprietebatie.dnupla,
		proprietebatie.jdatat,
		proprietebatie.dnvoiri,
		proprietebatie.dindic,
		proprietebatie.natvoi,
		proprietebatie.dvoilib,
		proprietebatie.ccoriv,
		proprietebatie.dnubat,
		proprietebatie.descr,
		proprietebatie.dniv,
		proprietebatie.dpor,
		proprietebatie.invar,
		proprietebatie.ccoaff,
		proprietebatie.ccoeva,
		proprietebatie.ccostn,
		proprietebatie.cconlc,
		proprietebatie.dcapec,
		proprietebatie.dvltrt,
		proprietebatie.ccolloc,
		proprietebatie.gnextl,
		proprietebatie.jandeb,
		proprietebatie.janimp,
		proprietebatie.fcexb,
		proprietebatie.pexb,
		proprietebatie.mvltieomx,
		proprietebatie.bateom  
	FROM dblink('host=#DBHost_arcopole dbname=#DBName_arcopole user=#DBUser_arcopole password=#DBpasswd_arcopole'::text,
		'select 
			l.id_local,
			p.codparc as parcelle,
			l.dnupro as comptecommunal , 
			l.dnupro,
			p.codcomm as cgocommune,
			substr(p.codparc,7,3) as ccopre,
			substr(p.codparc,10,2) ccosec ,
			p.dnupla,
			l.jdatat,
			inv.dnvoiri,inv.dindic,
			v.nature as natvoi,
			inv.dvoilib,
			inv.ccoriv,
			inv.dnubat,
			inv.NDESC as descr,
			inv.dniv,
			inv.dpor,
			inv.invar,
			pev.ccoaff,
			l.ccoeva,
			suf.ccostn,
			l.cconlc,
			pev.dcapec,
			l.dvltrt,
			sufex.ccolloc,
			pevx.gnextl,
			pevx.jandeb,
			pevx.janimp,
			pevx.FCEXBA2 as fcexb,
			pevx.pexb,
			pevtax.BAOMEC  as mvltieomx,
			pevtax.bateom  
		from #DBSchema_arcopole.dgi_local l
			left join #DBSchema_arcopole.dgi_invar inv on l.id_local=inv.invar
			left join #DBSchema_arcopole.dgi_nbati p on inv.codparc=p.codparc
			left join #DBSchema_arcopole.dgi_voie v on v.id_voie=inv.id_voie
			left join #DBSchema_arcopole.dgi_pev pev on pev.codlot=inv.codlot and pev.invar=inv.invar
			left join #DBSchema_arcopole.dgi_suf suf on suf.codlot=l.codlot and suf.CODPARC=p.CODPARC
			left join #DBSchema_arcopole.dgi_exosuf sufex on sufex.id_suf=suf.id_suf and sufex.CODPARC=suf.CODPARC
			left join #DBSchema_arcopole.dgi_exopev pevx on pevx.id_pev=pev.id_pev
			left join #DBSchema_arcopole.dgi_taxpev as pevtax on pevtax.id_pev=pev.id_pev'::text) 
	proprietebatie(
		id_local character varying(16),
		parcelle character varying(19),
		comptecommunal character varying(12), 
		dnupro character varying(12), 
		cgocommune character varying(6),
		ccopre character varying(3),
		ccosec character varying(2),
		dnupla character varying(4),
		jdatat character varying(8),
		dnvoiri character varying(4),
		dindic character varying(1),
		natvoi character varying(4),
		dvoilib character varying(30),
		ccoriv character varying(4),
		dnubat character varying(2),
		descr character varying(2),
		dniv character varying(2),
		dpor character varying(5),
		invar character varying(16),
		ccoaff character varying(1),
		ccoeva character varying(1),
		ccostn character varying(1),
		cconlc character varying(2),
		dcapec character varying(2),
		dvltrt character varying(9),
		ccolloc character varying(2),
		gnextl character varying(2),
		jandeb character varying(4),
		janimp character varying(4),
		fcexb character varying(9),
		pexb character varying(5),
		mvltieomx character varying(9),
		bateom  character varying(9));


ALTER TABLE #schema_cadastrapp.proprietebatie OWNER TO #user_cadastrapp;

