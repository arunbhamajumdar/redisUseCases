package com.fepoc.cf.form;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.fepoc.claim.domain.BaseClaim;
import com.fepoc.claim.domain.BatchInformation;
import com.fepoc.claim.domain.BillingProvider;
import com.fepoc.claim.domain.ClaimHeaderInformation;
import com.fepoc.claim.domain.Member;
import com.fepoc.claim.domain.PatientDetails;
import com.fepoc.claim.domain.PerformingProvider;
import com.fepoc.claim.domain.Provider;
import com.fepoc.claim.domain.SubmittedContractHolder;
import com.fepoc.pf.domain.Page;
import com.fepoc.pf.domain.PageFragment;

public abstract class BaseClaimForm {
	protected String bizId;
	protected String sessionId;
	
	protected Page<ClaimHeaderInformation> header;
	protected Page<Member> member;
	protected Page<Provider> provider;
	protected List<Page<?>> pages;
	
	public BaseClaimForm(BaseClaim baseClaim) {
		initClaimForm(baseClaim);
	}

	private void initClaimForm(BaseClaim baseClaim) {
		pages = new ArrayList<>();
		addHeaderPage(baseClaim);
		addMemberPage(baseClaim);
		addProviderPage(baseClaim);
				
		
	}
	private void addProviderPage(BaseClaim baseClaim) {
		provider = new Page<Provider>();
		provider.setTitle("Provider Page");
		PageFragment<BillingProvider> billingProvider = new PageFragment<>(baseClaim.getProvider().getBillingProvider());
		PageFragment<PerformingProvider> performingProvider = new PageFragment<>(baseClaim.getProvider().getPerformingProvider());
		provider.getPageFagments().add(billingProvider);
		provider.getPageFagments().add(performingProvider);
		pages.add(provider);
	}

	private void addMemberPage(BaseClaim baseClaim) {
		member = new Page<Member>();
		PageFragment<PatientDetails> patientDetails = new PageFragment<>(baseClaim.getMember().getPatientDetails());
		PageFragment<SubmittedContractHolder> submittedContractDetails = new PageFragment<>(baseClaim.getMember().getSubmittedContractHolder());
		member.getPageFagments().add(patientDetails);
		member.getPageFagments().add(submittedContractDetails);
		member.setTitle("Member Page");
		pages.add(member);
	}

	private void addHeaderPage(BaseClaim baseClaim) {
		setHeader(new Page<ClaimHeaderInformation>());
		PageFragment<BatchInformation> batchInformation = new PageFragment<>(baseClaim.getClaimHeaderInformation().getBatchInformation());
		getHeader().getPageFagments().add(batchInformation);
		getHeader().setTitle("Header Page");
		pages.add(header);
	}

	public Page<ClaimHeaderInformation> getHeader() {
		return header;
	}

	public void setHeader(Page<ClaimHeaderInformation> header) {
		this.header = header;
	}

	public String getBizId() {
		return bizId;
	}

	public void setBizId(String bizId) {
		this.bizId = bizId;
	}

	public String getSessionId() {
		return sessionId;
	}

	public void setSessionId(String sessionId) {
		this.sessionId = sessionId;
	}

	public Page<Member> getMember() {
		return member;
	}

	public void setMember(Page<Member> member) {
		this.member = member;
	}

	public Page<Provider> getProvider() {
		return provider;
	}

	public void setProvider(Page<Provider> provider) {
		this.provider = provider;
	}

	public List<Page<?>> getPages() {
		return pages;
	}

	public void setPages(List<Page<?>> pages) {
		this.pages = pages;
	}
	
}
