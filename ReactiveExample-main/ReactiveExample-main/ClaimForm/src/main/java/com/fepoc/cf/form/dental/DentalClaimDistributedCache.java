package com.fepoc.cf.form.dental;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;

import com.fepoc.cf.api.ClaimRequestForm;
import com.fepoc.cf.form.BaseClaimForm;
import com.fepoc.cf.form.ClaimFormFactory;
import com.fepoc.claim.domain.BaseClaim;
import com.fepoc.pf.domain.Page;
import com.fepoc.pf.domain.PageFragment;

import reactor.core.publisher.Mono;

@Component
public class DentalClaimDistributedCache {
	private static ConcurrentMap<String, ConcurrentMap<String, BaseClaimForm>> claimFormCache = new ConcurrentHashMap<>();
	private static ConcurrentMap<String, ConcurrentMap<String, Object>> claimCache = new ConcurrentHashMap<>();
	
	public Mono<Page<?>> getNextPage(Page<? extends BaseClaimForm> page, ServerWebExchange session) {
		//page.getNextRequestedPage();
		return session.getSession().flatMap(a->{
			String sessionId = a.getId();
			updateCacheForPage(Arrays.asList(new Page<?>[] {page}), sessionId, 
					(BaseClaimForm)claimFormCache.get(sessionId));
			
			if(claimFormCache.containsKey(sessionId)) {
				return Mono.just(associateBizObject(
						((BaseClaimForm)claimFormCache.get(sessionId)
						.get(page.getBizId()))
						.getPages()
						.get(page.getNextRequestedPage())));
			}
			else {
				return Mono.empty();
			}
		});
	}
	
	public <E extends BaseClaimForm> void updateCacheForPage(List<Page<?>> pages, String sessionId, E e) {
		Map<String, Object> map = bizObjectMap(pages);
		claimCache.putIfAbsent(sessionId, new ConcurrentHashMap<>());
		//map.entrySet().stream().forEach(k->claimCache.get(sessionId).put(k.getKey(), k.getValue()));
		claimCache.get(sessionId).putAll(map);
		
		if(e!=null) {
			//dissociate business object from pages before caching
			dissociateBizFromForm(pages);
			claimFormCache.putIfAbsent(sessionId, new ConcurrentHashMap<>());
			claimFormCache.get(sessionId).put(e.getBizId(), e);		
		}
	}
	public <E extends BaseClaimForm> Mono<Page<?>> prepareNewClaimForm(ClaimRequestForm claimForm, ServerWebExchange session) {
		return session.getSession().flatMap(a->{
			
			String sessionId = a.getId();
			E e = ClaimFormFactory.getInstance().newForm(claimForm, sessionId);
			
			updateCacheForPage(e.getPages(), sessionId, e);
			
			
			//cache e; requires caching strategy
			return Mono.just(associateBizObject(e.getHeader()));
		});
	}

	@SuppressWarnings("unchecked")
	private Page<?> associateBizObject(Page<?> page) {
		Map<String, ?> claimMap = claimCache.values().stream()
				.flatMap(a->a.entrySet().stream())
				.collect(Collectors.toMap(s->s.getKey(), v->v.getValue(), (key1, key2)->{
					return key1;
				}));
		associatePageFragments(page.getPageFagments(), claimMap );
		return page;
	}

	private Map<String, Object> bizObjectMap(List<Page<?>> pages) {
		List<PageFragment<?>> result = new ArrayList<>();
		pages.stream().forEach(m->getAllPageFragments(m.getPageFagments(), result ));
		return result.stream().filter(p->p!=null && p.getEbizObject()!=null)
				.collect(
				Collectors.toMap(
						(PageFragment<?> p)->p.getBizId(), 
						(PageFragment<?> p1)->p1.getEbizObject()));
	}
	private void getAllPageFragments(List<PageFragment<?>> fragments, List<PageFragment<?>> result){
		if(Objects.nonNull(fragments)) {
			result.addAll(fragments);
			fragments.stream().filter(a->a!=null)
			.forEach(m->getAllPageFragments(m.getInternalFragments(), result ));
		}
	}	
	private void dissociateBizFromForm(List<Page<?>> pages) {
		pages.stream().forEach(m->dissociatePageFragments(m.getPageFagments()));
	}	
	private void dissociatePageFragments(List<PageFragment<?>> fragments){
		if(Objects.nonNull(fragments)) {
			fragments.stream().filter(a->a!=null)
			.forEach(m->{
				m.setEbizObject(null);
				dissociatePageFragments(m.getInternalFragments());
				});
		}
	}
	@SuppressWarnings("unchecked")
	private void associatePageFragments(List<PageFragment<?>> fragments, Map<String, ?> claimMap){
		if(Objects.nonNull(fragments)) {
			fragments.stream().filter(a->a!=null)
			.forEach(m->{
				m.setEbizObject(claimMap.get(m.getBizId()));
				associatePageFragments(
						m.getInternalFragments(), claimMap);
				});
		}
	}	
	public Mono<? extends Page<?>> saveClaim(Page<? extends BaseClaimForm> page, ServerWebExchange session) {
		return session.getSession().flatMap(a->{
		//cache page; get claim and save claim
		//use page.getBizId() get claim from cache
		
		//returning empty for now
		return getNextPage(page, session);
		});
	}

	/**
	 * Page Ids are unique and can be retrieved without session information
	 * @param pageId
	 * @return
	 */
	public Mono<Page<?>> retrievePage(String pageId) {
		Page<?> pg = claimFormCache.values().stream()
				.<BaseClaimForm>flatMap(b->b.values().stream())
				.map(p->p.getPages().stream().filter(q->q.getId().equals(pageId)).findFirst().orElse(null))
				.filter(b->b!=null)
				.findFirst().orElse(null);
		associateBizObject(pg);
		return pg == null? Mono.empty(): Mono.just(pg);
	}

}
