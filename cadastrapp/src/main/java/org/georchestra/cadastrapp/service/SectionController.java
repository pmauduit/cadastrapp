package org.georchestra.cadastrapp.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;

@Path("/getSection")
public class SectionController extends CadController {
	
	final static Logger logger = LoggerFactory.getLogger(SectionController.class);


	@GET
	@Produces("application/json")
	/**
	 * 
	 * @param ccoinsee
	 * @param ccopre_partiel
	 * @param ccosec_partiel
	 * @return
	 * @throws SQLException
	 */
	public List<Map<String, Object>> getSectionList(
			@Context HttpHeaders headers,
			@QueryParam("ccoinsee") String ccoinsee,
			@QueryParam("ccopre_partiel") String ccopre_partiel,
			@QueryParam("ccosec_partiel") String ccosec_partiel) throws SQLException {

		List<Map<String, Object>> sections = null;

		
		// Create query
		StringBuilder queryBuilder = new StringBuilder();

		queryBuilder.append("select ");

		queryBuilder.append("ccoinsee, ccopre, ccosec, geo_section");

		queryBuilder.append(" from ");
		queryBuilder.append(databaseSchema);
		queryBuilder.append(".section");

		// Special case when code commune on 5 characters is given
		// Convert 350206 to 35%206 for query
		if(ccoinsee!= null && 5 == ccoinsee.length()){
			ccoinsee = ccoinsee.substring(0, 2) + "%" +ccoinsee.substring(2);    			
		} 	
		
		queryBuilder.append(createLikeClauseRequest("ccoinsee", ccoinsee));
		queryBuilder.append(createLikeClauseRequest("ccopre", ccopre_partiel));
		queryBuilder.append(createLikeClauseRequest("ccosec", ccosec_partiel));
		queryBuilder.append(addAuthorizationFiltering(headers));
		queryBuilder.append(finalizeQuery());
					
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
		sections = jdbcTemplate.queryForList(queryBuilder.toString());

		return sections;
	}


}
