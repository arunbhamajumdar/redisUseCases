package com.fepoc.cf.api;

import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.server.ServerWebExchange;

import com.fepoc.cf.excp.DuplicateClaimException;

import reactor.core.publisher.Mono;
@Component
public class ClaimFormExceptionHandler {


	
	class ErrorResponse {
		private String message;
		ErrorResponse(String message){
			this.message = message;
		}
		public String getMessage() {
			return message;
		}
		public void setMessage(String message) {
			this.message = message;
		}
		
	}	
}
