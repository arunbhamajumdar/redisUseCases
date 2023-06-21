package com.fepoc.sec;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("\test")
public class SecurityRestController {

	@RequestMapping(method = RequestMethod.GET, produces = MediaType.TEXT_PLAIN_VALUE)
	public String helloSecurity() {
		return "OK";
	}
}
