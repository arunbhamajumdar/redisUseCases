package com.fepoc.cf.form;

import java.util.UUID;

import com.fepoc.cf.api.ClaimRequestForm;
import com.fepoc.cf.form.dental.DentalClaimForm;
import com.fepoc.claim.domain.BatchInformation;
import com.fepoc.claim.domain.BillingProvider;
import com.fepoc.claim.domain.ClaimHeaderInformation;
import com.fepoc.claim.domain.DentalClaim;
import com.fepoc.claim.domain.Member;
import com.fepoc.claim.domain.PerformingProvider;
import com.fepoc.claim.domain.Provider;

public class ClaimFormFactory {
	private static ClaimFormFactory instance;
	
	private ClaimFormFactory() {}
	public static ClaimFormFactory getInstance() {
		if(instance == null) {
			instance = new ClaimFormFactory();
		}
		return instance;
	}
	@SuppressWarnings("unchecked")
	public <E extends BaseClaimForm> E newForm(ClaimRequestForm claimForm, String sessionId) {
		E e = null;
		switch(claimForm.getFormType()) {
		case Dental:
			e = (E) buildDentalClaimForm(buildDentalClaim(), sessionId);			
			break;
		default:
			break;
			
		}
		return e;
	}
	
	private DentalClaimForm buildDentalClaimForm(DentalClaim dentalClaim, String sessionId) {
		DentalClaimForm dentalClaimForm = new DentalClaimForm(dentalClaim);
		dentalClaimForm.setBizId(UUID.randomUUID().toString());
		dentalClaimForm.setSessionId(sessionId);
		dentalClaimForm.getPages().stream().forEach(a->{
			a.setBizId(dentalClaimForm.getBizId());
			a.setUserSessionId(dentalClaimForm.getSessionId());
		});
		dentalClaimForm.getHeader().getPageFagments().stream().forEach(p->{
			p.getPageStatus().setStatusDescription("New Dental Form");
			p.getPageStatus().setStatusCode("N0001");
		});
		//build dental claim here
		return dentalClaimForm;
	}
	private DentalClaim buildDentalClaim() {
		DentalClaim dentalClaim = new DentalClaim();
		ClaimHeaderInformation header = new ClaimHeaderInformation();
		BatchInformation batchInformation = new BatchInformation();
		header.setBatchInformation(batchInformation );
		//build dental claim here
		dentalClaim.setClaimHeaderInformation(header );
		dentalClaim.setMember(new Member());
		
		Provider provider = new Provider();
		provider.setBillingProvider(new BillingProvider());
		provider.setPerformingProvider(new PerformingProvider());
		dentalClaim.setProvider(provider);
		return dentalClaim;
	}

}
