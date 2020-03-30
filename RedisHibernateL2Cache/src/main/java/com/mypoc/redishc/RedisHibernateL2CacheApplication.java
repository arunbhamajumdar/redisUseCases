package com.mypoc.redishc;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

/**
 * Hibernate uses a multi-level caching scheme. 
 * The first level is mandatory and enabled by default, while the second level is optional. The first-level 
 * cache (also known as the L1 cache) is associated with Hibernate's Session 
 * object, which represents a connection between a Java application and a SQL 
 * database. This means that the first-level cache is only available for as 
 * long as the Session exists. Each first-level cache is only accessible by 
 * the Session object with which it is associated. When an entity is queried 
 * from the database for the first time, it is stored in the first-level cache 
 * associated with that Session. Any later queries to this same entity during 
 * the same Session will retrieve the entity from the cache, instead of from 
 * the database.
 * 
 * The second-level cache (also known as the L2 cache) is disabled 
 * by default but can be enabled by modifying Hibernate's configuration settings. 
 * This cache is associated with Hibernate's SessionFactory object and is mainly 
 * used to store data that should persist across Sessions. Before looking in the 
 * second-level cache, applications will always search the first-level cache for 
 * the presence of a given entity.
 * 
 * Hibernate also has a third type of cache: 
 * the query cache, which is used to store the results of a particular database 
 * query. This is useful when you need to run the same query many times with the 
 * same parameters.
 * 
 * There are several different implementations of the second-level cache in 
 * Hibernate, including Ehcache and OSCache. In the rest of this 
 * article, we'll explore another option for second-level caching in Hibernate: 
 * Redisson, which allows using Redis as Hibernate cache.
 * 
 * How to Cache with Hibernate and Redis. 
 * Redisson is a Redis client in Java that contains implementations of many 
 * Java objects and services, including Hibernate caching. 
 * 
 * All four Hibernate cache strategies are supported by Redisson:
 * 
 * 	READ_ONLY: Used only for entities that will not change once inside the cache.
 * 
 * 	NONSTRICT_READ_WRITE: The cache is updated after a transaction modifies the 
 * 	entity in the database. Not able to guarantee strong consistency but can 
 * 	guarantee eventual consistency.
 * 
 * 	READ_WRITE: Guarantees strong consistency by using "soft" locks that maintain 
 * 	control of the entity until the transaction is complete.
 * 
 * 	TRANSACTIONAL: Ensures data integrity by using distributed XA transactions.
 *  
 * Updates are guaranteed to be either committed or rolled back to both the 
 * database and the cache.Redisson provides various Hibernate CacheFactories, 
 * including those with support for local caching. 
 * If you plan to use your Hibernate cache mainly for reading operations or 
 * you don't want to make too many network round trips, local caching is a 
 * smart solution.
 * 
 * The RedissonRegionFactory implements a basic Hibernate cache, while the 
 * RedissonLocalCachedRegionFactory  (available in Redisson PRO edition) 
 * implements a Hibernate cache with support for local caching.
 * 
 * @author Administrator
 *
 */
@SpringBootApplication
@EnableCaching
public class RedisHibernateL2CacheApplication {

	public static void main(String[] args) {
		SpringApplication.run(RedisHibernateL2CacheApplication.class, args);
	}

}
