package com.fepoc.cf.api;

import java.time.Duration;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.session.SessionProperties;
import org.springframework.boot.web.servlet.ServletListenerRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.MapReactiveUserDetailsService;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.server.SecurityWebFilterChain;
import org.springframework.security.web.server.WebFilterExchange;
import org.springframework.security.web.server.authentication.RedirectServerAuthenticationSuccessHandler;
import org.springframework.security.web.session.HttpSessionEventPublisher;
import org.springframework.session.ReactiveMapSessionRepository;
import org.springframework.session.ReactiveSessionRepository;
import org.springframework.session.config.annotation.web.server.EnableSpringWebSession;

import reactor.core.publisher.Mono;

@Configuration
@EnableSpringWebSession
@EnableWebFluxSecurity
public class ClaimFormConfiguration {

	@Autowired
	private SessionProperties sessionProperties;
	
//	   @Bean
//	    public MapReactiveUserDetailsService userDetailsService() {
//	        UserDetails user = User.withDefaultPasswordEncoder()
//	            .username("user")
//	            .password("user")
//	            .roles("USER")
//	            .build();
//	        return new MapReactiveUserDetailsService(user);
//	    }
//	    @Bean
//	    public SecurityWebFilterChain springSecurityFilterChain(ServerHttpSecurity http) {
//	    	System.out.println("1......");
//	        http.csrf().disable()
//	            .authorizeExchange()
//	                .anyExchange().authenticated()
//	                .and()
//	            .httpBasic().and()
//	            .formLogin();
//	        return http.build();
//	    }	

    @Bean
    public ReactiveSessionRepository<?> reactiveSessionRepository() {
        ReactiveMapSessionRepository sessionRepository = new ReactiveMapSessionRepository(new ConcurrentHashMap<>());
        int defaultMaxInactiveInterval = (int) sessionProperties.getTimeout().toMillis()/1000;
        sessionRepository.setDefaultMaxInactiveInterval(defaultMaxInactiveInterval);
        return sessionRepository;
    }
    
	@Bean
	public SecurityWebFilterChain securitygWebFilterChain(ServerHttpSecurity http) {
 		http.formLogin().authenticationSuccessHandler(new SuccessHandler());
	    return http
	      .csrf().disable().authorizeExchange()
	      .anyExchange().authenticated()
	      .and()
          .httpBasic().and()
          .formLogin()
          .and().build();
	}	

	class SuccessHandler extends RedirectServerAuthenticationSuccessHandler {

	    @Override
	    public Mono<Void> onAuthenticationSuccess(WebFilterExchange webFilterExchange, Authentication authentication) {
	        webFilterExchange.getExchange().getSession().subscribe(session->session.setMaxIdleTime(Duration.ofMinutes(60)));
	        return super.onAuthenticationSuccess(webFilterExchange, authentication);
	    }
	}	
}
