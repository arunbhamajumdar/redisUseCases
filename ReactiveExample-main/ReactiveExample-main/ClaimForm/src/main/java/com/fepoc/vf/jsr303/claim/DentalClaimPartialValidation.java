package com.fepoc.vf.jsr303.claim;

import com.fepoc.claim.domain.DentalClaim;
import com.fepoc.vf.jsr303.PartialValidator;

public class DentalClaimPartialValidation extends PartialValidator<DentalClaim>{

	public DentalClaimPartialValidation(DentalClaim dentalClaim) {
		super(dentalClaim);
	}

}
