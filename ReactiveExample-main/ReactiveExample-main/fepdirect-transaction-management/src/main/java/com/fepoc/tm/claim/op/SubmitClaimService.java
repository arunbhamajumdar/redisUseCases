package com.fepoc.tm.claim.op;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.fepoc.claim.domain.DentalClaim;

@Component
public class SubmitClaimService {

	private JdbcTemplate jdbcTemplate;
	public SubmitClaimService(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}
	@Transactional
	public void submit(DentalClaim dentalClaim) {
		
	}
}
