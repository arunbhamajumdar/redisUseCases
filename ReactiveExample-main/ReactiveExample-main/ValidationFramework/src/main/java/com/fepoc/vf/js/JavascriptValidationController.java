package com.fepoc.vf.js;

import java.io.Reader;
import java.util.List;
import java.util.stream.Stream;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;

import org.springframework.stereotype.Component;

import com.fepoc.vf.ValidationInterface;
import com.fepoc.vf.ValidationResponse;
import com.fepoc.vf.metadata.edit.BaseEditFunction;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Component
public class JavascriptValidationController<T extends BaseEditFunction> implements ValidationInterface<T>{

	
	private ScriptEngine nashorn;
	private static JavascriptValidationController<? extends BaseEditFunction> engine;
	
	private JavascriptValidationController() {}
	
	@SuppressWarnings("unchecked")
	public static <T extends BaseEditFunction> JavascriptValidationController<T> getInstance() {
		if(engine==null) {
			engine = new JavascriptValidationController<T>();
			engine.init();
		}
		return (JavascriptValidationController<T>) engine;
	}
	
	@Override
	public <E> Mono<ValidationResponse<T>> validate(List<E> elist) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public <E> Flux<ValidationResponse<T>> validate(Stream<E> elist) {
		// TODO Auto-generated method stub
		return null;
	}
	
	

	
	private void init() {
		ScriptEngineManager scriptEngineManager = new ScriptEngineManager();
	    nashorn = scriptEngineManager.getEngineByName("nashorn");	
	}
	
	public void loadJsFile(Reader reader) throws ScriptException {
		nashorn.eval(reader);
	}
	public void execute(String function) {
		
	      try {
	         nashorn.eval(function);
	         
	      } catch(ScriptException e) {
	         System.out.println("Error executing script: "+ e.getMessage());
	      }
	}


}
