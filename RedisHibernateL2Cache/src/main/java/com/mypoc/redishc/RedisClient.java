package com.mypoc.redishc;

import java.util.concurrent.ConcurrentMap;

import org.redisson.api.RedissonClient;

import lombok.Getter;
import lombok.NonNull;
import lombok.Setter;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.redisson.api.RMapCache;
import org.redisson.api.RScript;
import org.redisson.api.RedissonClient;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.TimeUnit;

@Slf4j
public class RedisClient {

  private static int expiryInSecond=3600;

  @Getter
  private final transient RedissonClient redisson;

  @Getter
  @Setter
  private int expiryInSeconds;

  public RedisClient(RedissonClient redisson) {
    this(redisson, expiryInSecond);
  }

  @SneakyThrows
  public RedisClient(@NonNull RedissonClient redisson, int expiryInSeconds) {
    this.redisson = redisson;

    if (expiryInSeconds >= 0) {
      this.expiryInSeconds = expiryInSeconds;
    }
  }

  public long nextTimestamp(final List<Object> keys) {
    return redisson.getScript().eval(RScript.Mode.READ_WRITE,
                                     "redis.call('setnx', KEYS[1], ARGV[1]); " +
                                     "return redis.call('incr', KEYS[1]);",
                                     RScript.ReturnType.INTEGER, keys, System.currentTimeMillis());
  }

  public long dbSize() {
    return redisson.getKeys().count();
  }

  public boolean exists(final String region, final Object key) {
    return getCache(region).containsKey(key);
  }

  @SuppressWarnings("unchecked")
  public <T> T get(final String region, final Object key) {
    T cacheItem = (T) getCache(region).get(key);
    return cacheItem;
  }

  public boolean isExpired(final String region, final Object key) {
    return exists(region, key);
  }

  public Set<Object> keysInRegion(final String region) {
    return getCache(region).keySet();
  }

  public long keySizeInRegion(final String region) {
    return getCache(region).size();
  }


  public Map<Object, Object> getAll(final String region) {
    return getCache(region);
  }

  public void set(final String region, final Object key, Object value) {
    set(region, key, value, expiryInSeconds);
  }

  public void set(final String region, final Object key, Object value, final long timeoutInSeconds) {
    set(region, key, value, timeoutInSeconds, TimeUnit.SECONDS);
  }

  public void set(final String region, final Object key, Object value, final long timeout, final TimeUnit unit) {
    RMapCache<Object, Object> cache = getCache(region);
    if (timeout > 0L) {
      cache.fastPut(key, value, timeout, unit);
    } else {
      cache.fastPut(key, value);
    }
  }

  public void expire(final String region) {
    getCache(region).clearExpire();
  }

  public void del(final String region, final Object key) {
    getCache(region).fastRemove(key);
  }

  public void mdel(final String region, final Collection<?> keys) {
    getCache(region).fastRemove(keys.toArray(new Object[keys.size()]));
  }

  public void deleteRegion(final String region) {
    getCache(region).clear();
  }

  public void flushDb() {
    redisson.getKeys().flushdb();
  }

  public boolean isShutdown() {
    return redisson.isShutdown();
  }

  public void shutdown() {
    redisson.shutdown();
  }

  private final ConcurrentMap<String, RMapCache<Object, Object>> caches = new ConcurrentHashMap<String, RMapCache<Object, Object>>();

  private RMapCache<Object, Object> getCache(final String region) {
    RMapCache<Object, Object> cache = caches.get(region);
    if (cache == null) {
      cache = redisson.getMapCache(region);
      RMapCache<Object, Object> concurrent = caches.putIfAbsent(region, cache);
      if (concurrent != null) {
        cache = concurrent;
      }
    }
    return cache;
  }
  
  public RedissonClient getRedisson() {
	  return redisson;
  }
}