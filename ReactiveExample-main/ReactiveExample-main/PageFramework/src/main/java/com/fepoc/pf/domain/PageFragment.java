package com.fepoc.pf.domain;

import java.util.List;
import java.util.UUID;
import java.util.concurrent.CopyOnWriteArrayList;

public class PageFragment<E> implements Cloneable{
	private E ebizObject;
	private List<PageFragment<?>> internalFragments = new CopyOnWriteArrayList<>();;
	private PageFragementStatus<E> pageStatus = new PageFragementStatus<>();
	private String bizId;
	
	public PageFragment() {
		bizId = UUID.randomUUID().toString();
	}
	public PageFragment(E e) {
		this();
		this.ebizObject = e;
	}

	public E getEbizObject() {
		return ebizObject;
	}

	@SuppressWarnings("unchecked")
	public void setEbizObject(Object ebizObject) {
		this.ebizObject = (E)ebizObject;
	}

	public List<PageFragment<?>> getInternalFragments() {
		return internalFragments;
	}

	public void setInternalFragments(List<PageFragment<?>> internalFragments) {
		this.internalFragments = internalFragments;
	}

	public PageFragementStatus<E> getPageStatus() {
		return pageStatus;
	}

	public void setPageStatus(PageFragementStatus<E> pageStatus) {
		this.pageStatus = pageStatus;
	}

	public String getMessage() {
		StringBuilder sb = new StringBuilder();
		pageStatus.getMessage(sb);
		return sb.toString();
	}
	public String getBizId() {
		return bizId;
	}
	public void setBizId(String bizId) {
		this.bizId = bizId;
	}
	
	public PageFragment<E> clone() throws CloneNotSupportedException{
		@SuppressWarnings("unchecked")
		PageFragment<E> pf = (PageFragment<E>) super.clone();
		pf.setPageStatus(pageStatus);
		return pf;
	}
	
}


