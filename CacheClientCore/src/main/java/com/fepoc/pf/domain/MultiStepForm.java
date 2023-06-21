package com.fepoc.pf.domain;

import java.util.List;
import java.util.Objects;
import java.util.concurrent.CopyOnWriteArrayList;

import com.fepoc.dc.ccc.RedisKey;

public class MultiStepForm implements RedisKey{
	protected String id;
	protected String userId;
	protected String userSessionId;
	protected String bizId;
	protected List<Page<?>> pages = new CopyOnWriteArrayList<>(); 
	
	
	public Page<?> findPageById(String pageId){
		return pages.stream()
			.filter(p->Objects.nonNull(pageId)&&pageId.equals(p.getId()))
			.findFirst()
			.orElse(null);
	}
	
	public void addPage(Page<?> page) {
		page.setBizId(bizId);
		page.setUserId(userId);
		page.setUserSessionId(userSessionId);
		pages.add(page);
	}

	@Override
	public String key() {
		return "cf:".concat(id);
	}
}
