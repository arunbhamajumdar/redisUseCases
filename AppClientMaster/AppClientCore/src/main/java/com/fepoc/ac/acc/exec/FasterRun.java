package com.fepoc.ac.acc.exec;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
*
* @author Administrator
*/
public class FasterRun<E, R> {
  
  private  ExecutorService es;

  public FasterRun<E,R> newRun() {
	  es = Executors.newFixedThreadPool(2);
	  return this;
  }
  public List<R> populate(List<E> values, Function<E,R> function) {
	  List<CompletableFuture<R>> rlist = new CopyOnWriteArrayList<>();
      populate(rlist, es, values, function);
      List<R> slist = rlist.stream()
    		  .map(CompletableFuture::join)
    		  .collect(Collectors.toList());
      return slist;
  }
  private void populate(List<CompletableFuture<R>> rlist, 
          ExecutorService es, List<E> values, Function<E,R> function) {
      List<CompletableFuture<R>> list = values
      .stream()
      .map(a->
      {
          return CompletableFuture.supplyAsync(()->{
              return function.apply(a);
          }, es);
      }).collect(Collectors.toList());
      rlist.addAll(list);
  }
  
  public void down() {
      es.shutdown();	  
  }
}  
