package com.induscf.rs.api;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import reactor.core.publisher.Mono;

import java.io.IOException;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.ui.ModelMap;
@RestController
@RequestMapping("/")
public class RedirectController {

	@Autowired
	UrlContent ucontent;
	
	@GetMapping(value="/redirect", 
			produces = {MediaType.TEXT_HTML_VALUE,
						MediaType.APPLICATION_XML_VALUE,
						MediaType.TEXT_PLAIN_VALUE,
						MediaType.TEXT_PLAIN_VALUE,
						"image/svg+xml"
					})
	public Mono<String> redirect(@RequestParam String url){
		try {
			return Mono.just(ucontent.getContent(url, true));
		} catch (IOException e) {
			return Mono.error(e);
		}
	}
	@GetMapping(value="/redirectp/{url}", 
			produces = {MediaType.TEXT_HTML_VALUE,
						MediaType.APPLICATION_XML_VALUE,
						MediaType.TEXT_PLAIN_VALUE,
						MediaType.TEXT_PLAIN_VALUE
					})
	
	public Mono<String> redirectp(@PathVariable("url") String url, @RequestParam Map<String,String> map){
		try {
			String param = map.keySet().stream().map(k->k+"="+map.get(k)).collect(Collectors.joining("&"));
			if(param!=null && !"".equals(param)) {
				url = url+"?"+param;
			}
			System.out.println("redirectp..."+url);
			return Mono.just(ucontent.getContent(url, false));
		} catch (IOException e) {
			return Mono.error(e);
		}
	}	
	@GetMapping(value="/image", produces = "image/*" )
	public Mono<byte[]> image(@RequestParam String url){
		try {
			return Mono.just(ucontent.getBinaryContent(url));
		} catch (IOException e) {
			return Mono.error(e);
		}
	}	
}
