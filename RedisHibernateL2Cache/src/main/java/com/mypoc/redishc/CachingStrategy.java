package com.mypoc.redishc;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.function.BiConsumer;
import java.util.function.Function;
import org.redisson.api.map.MapLoader;
import org.redisson.api.map.MapWriter;

public class CachingStrategy {

	/**
	 * In read-through caching, the application first queries the cache to see 
	 * if the information it needs is inside. If not, it retrieves the information 
	 * from the database and uses it to update the cache.
	 * 
	 * @param conn
	 * @param sqlKey
	 * @param sqlValue
	 * @return
	 */
	public <K,V> MapLoader<K, V> readThroughCache(
			Connection conn, 
			String sqlKey, 
			Function<ResultSet, K> ksupplier, 				//result.getString(1)
			String sqlValue,
			BiConsumer<PreparedStatement, K> params,	// preparedStatement.setString(1, key);
			Function<ResultSet, V> vsupplier 				//result.getString(1)
			) {
		MapLoader<K, V> mapLoader = new MapLoader<K, V>() {
		    @Override
		    public Iterable<K> loadAllKeys() {
		        List<K> list = new ArrayList<K>();
		        try(Statement statement = conn.createStatement()) {
		            ResultSet result = statement.executeQuery(sqlKey);
		            while (result.next()) {
		                list.add(ksupplier.apply(result));
		            }
		        } catch (SQLException e) {
					e.printStackTrace();
				}
		        return list;
		    }
		    @Override
		    public V load(K key) {
		        try(PreparedStatement preparedStatement = conn.prepareStatement(sqlValue)) {
		        	params.accept(preparedStatement, key);		            
		            ResultSet result = preparedStatement.executeQuery();
		            if (result.next()) {
		                return vsupplier.apply(result);
		            }
		        } catch (SQLException e) {
					e.printStackTrace();
				}
	            return null;
		    }
		};		
		return mapLoader;
	}
	
	/**
	 * Cache update method will not return until both the cache and 
	 * the database have been updated by MapWriter object.
	 * 
	 * @param <K>
	 * @param <V>
	 * @param conn
	 * @param insertSql
	 * @param kvParam
	 * @param deleteSql
	 * @param kParam
	 * @return
	 */
	public <K,V> MapWriter<K, V> writeThroughCache(Connection conn,
			String insertSql,			// "INSERT INTO student (id, name) values (?, ?)"
			BiConsumer<PreparedStatement, Entry<K, V>> kvParam,
			String deleteSql,
			BiConsumer<PreparedStatement, K> kParam
			) {
		MapWriter<K, V> mapWriter = new MapWriter<K, V>() {
		    @Override
		    public void write(Map<K, V> map) {
		        try(PreparedStatement preparedStatement = conn.prepareStatement(insertSql)) {
		            for (Entry<K, V> entry : map.entrySet()) {
		            	kvParam.accept(preparedStatement, entry);
		                //preparedStatement.setString(1, entry.getKey());
		                //preparedStatement.setString(2, entry.getValue());
		                preparedStatement.addBatch();
		            }
		            preparedStatement.executeBatch();
		        } catch (SQLException e) {
					e.printStackTrace();
				}
		    }
		    @Override
		    public void delete(Collection<K> keys) {
		        try(PreparedStatement preparedStatement = conn.prepareStatement(deleteSql)) {
		            for (K key : keys) {
		            	kParam.accept(preparedStatement, key);
		                //preparedStatement.setString(1, key);
		                preparedStatement.addBatch();
		            }
		            preparedStatement.executeBatch();
		        } catch (SQLException e) {
					e.printStackTrace();
				}
		    }
		};
		return mapWriter;
	}
	

}
