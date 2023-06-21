package com.fepoc.cf.util;

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.function.Consumer;

public class ProcessingUtil {
	private static ExecutorService es = Executors.newFixedThreadPool(2);

	public static <T> void processAsync(Consumer<T> consumer) {
		CompletableFuture.runAsync(()->consumer.accept(null), es);
	}
}
