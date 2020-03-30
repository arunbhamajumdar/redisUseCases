package com.mypoc.redishc;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Map.Entry;
import java.util.function.BiConsumer;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.Supplier;

import org.redisson.api.MapOptions;
import org.redisson.api.MapOptions.WriteMode;
import org.redisson.api.RLocalCachedMap;
import org.redisson.api.RMap;
import org.redisson.api.RMapCache;
import org.redisson.api.RedissonClient;
import org.redisson.api.map.MapLoader;
import org.redisson.api.map.MapWriter;

public class TestCachingStrategy {
	private RedisClient client;

	public <K,V> void testReadThroughCaching() {
		CachingStrategy cstrategy = new CachingStrategy();
		Connection conn=null;
		String sqlKey=null;
		String sqlValue=null;
		Function<ResultSet, String> ksupplier=null;
		BiConsumer<PreparedStatement, String> params=null;
		Function<ResultSet, String> vsupplier=null;
		MapLoader<String, String> mapLoader = cstrategy.readThroughCache(conn, sqlKey, ksupplier, sqlValue, params, vsupplier);
		MapOptions<String, String> options = MapOptions.<String, String>defaults()
                .loader(mapLoader);
		RedissonClient redisson = client.getRedisson();
		RMap<String, String> rmap = redisson.getMap("test", options);
		//or
		RMapCache<String, String> rmapc = redisson.getMapCache("test", options);
		//or with boost up to 45x times 
		//RLocalCachedMap<String, String> rlmapc = redisson.getLocalCachedMap("test", options);
		//or with boost up to 45x times 
		//RLocalCachedMapCache<String, String> map = redisson.getLocalCachedMapCache("test", options);	
	}
	
	public <K,V> void testWriteThroughCache() {
		CachingStrategy cstrategy = new CachingStrategy();
		Connection conn=null;
		String insertSql=null;
		BiConsumer<PreparedStatement, Entry<String,String>> kvParam=null;
		String deleteSql=null;
		BiConsumer<PreparedStatement, String> kParam=null;
		MapWriter<String, String> mapWriter = cstrategy.writeThroughCache(conn, insertSql, kvParam, deleteSql, kParam);
		MapOptions<String, String> options = MapOptions.<String, String>defaults()
                .writer(mapWriter)
                .writeMode(WriteMode.WRITE_THROUGH);
		RedissonClient redisson = client.getRedisson();
		RMap<String, String> map = redisson.getMap("test", options);
		//or
		//RMapCache<K, V> map = redisson.getMapCache("test", options);
		//or with boost up to 45x times 
		//RLocalCachedMap<K, V> map = redisson.getLocalCachedMap("test", options);
		//or with boost up to 45x times 
		//RLocalCachedMapCache<K, V> map = redisson.getLocalCachedMapCache("test", options);
	}
	
	/**
	 * The MapWriter interface is also used to asynchronously commit updates to 
	 * the Map object (cache) and the external storage (database). All Map updates 
	 * are accumulated in batches and asynchronously written with defined delay.
	 * writeBehindDelay — delay of batched write or delete operation. The default 
	 * value is 1000 milliseconds.
	 * writeBehindBatchSize — size of batch. Each batch contains Map Entry write or 
	 * delete commands. The default value is 50.
	 * 
	 * @param <K>
	 * @param <V>
	 */
	public <K,V> void testWriteBehindCache() {
		CachingStrategy cstrategy = new CachingStrategy();
		Connection conn=null;
		String insertSql=null;
		BiConsumer<PreparedStatement, Entry<String,String>> kvParam=null;
		String deleteSql=null;
		BiConsumer<PreparedStatement, String> kParam=null;
		MapWriter<String, String> mapWriter = cstrategy.writeThroughCache(conn, insertSql, kvParam, deleteSql, kParam);
		MapOptions<String, String> options = MapOptions.<String, String>defaults()
                .writer(mapWriter)
                .writeMode(WriteMode.WRITE_BEHIND)
                .writeBehindDelay(5000)
                .writeBehindBatchSize(100);
		RedissonClient redisson = client.getRedisson();
		RMap<String, String> map = redisson.getMap("test", options);
		//or
		RMapCache<String, String> mapc = redisson.getMapCache("test", options);
		//or with boost up to 45x times 
		//RLocalCachedMap<K, V> maplc = redisson.getLocalCachedMap("test", options);
		//or with boost up to 45x times 
		//RLocalCachedMapCache<K, V> map = redisson.getLocalCachedMapCache("test", options);
	}	
}
