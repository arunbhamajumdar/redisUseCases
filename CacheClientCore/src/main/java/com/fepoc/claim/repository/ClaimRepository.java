package com.fepoc.claim.repository;

import java.time.Duration;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;
import java.util.stream.Collectors;

import org.springframework.data.redis.connection.stream.Consumer;
import org.springframework.data.redis.connection.stream.MapRecord;
import org.springframework.data.redis.connection.stream.ObjectRecord;
import org.springframework.data.redis.connection.stream.ReadOffset;
import org.springframework.data.redis.connection.stream.Record;
import org.springframework.data.redis.connection.stream.RecordId;
import org.springframework.data.redis.connection.stream.StreamOffset;
import org.springframework.data.redis.connection.stream.StreamReadOptions;
import org.springframework.data.redis.connection.stream.StreamRecords;
import org.springframework.data.redis.connection.stream.StringRecord;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.StreamOperations;
import org.springframework.data.redis.serializer.JdkSerializationRedisSerializer;
import org.springframework.data.redis.stream.StreamListener;
import org.springframework.data.redis.stream.StreamMessageListenerContainer;
import org.springframework.data.redis.stream.Subscription;
import org.springframework.stereotype.Repository;

import com.fepoc.claim.domain.BatchInformation;
import com.fepoc.claim.domain.BillingProvider;
import com.fepoc.claim.domain.ClaimHeaderInformation;
import com.fepoc.claim.domain.DentalClaim;
import com.fepoc.claim.domain.Member;
import com.fepoc.claim.domain.PerformingProvider;
import com.fepoc.claim.domain.Provider;
import com.fepoc.dc.ccc.KryoSerilizer;

import io.lettuce.core.Range;
import io.lettuce.core.api.async.RedisAsyncCommands;
import io.lettuce.core.cluster.api.async.RedisClusterAsyncCommands;
import io.lettuce.core.codec.StringCodec;
import io.lettuce.core.models.stream.PendingMessages;
import io.lettuce.core.output.StatusOutput;
import io.lettuce.core.protocol.CommandArgs;
import io.lettuce.core.protocol.CommandKeyword;
import io.lettuce.core.protocol.CommandType;
@Repository
public class ClaimRepository implements StreamListener<String, MapRecord<String, Object, Object>>{
	private static final String streamkey = "claimstream";
	private static final String consumerGroup = "claim-autosave";
	private static final String MAX_NUMBER_FETCH = null;
	
	private RedisTemplate<String, byte[]> redisTemplate;
	private HashOperations<String, String, byte[]> hashop;
	private StreamOperations<String, String, String> streamop;
	
	KryoSerilizer<DentalClaim> dcks = 
			new KryoSerilizer<>(Arrays.asList(new Class<?>[] {
				DentalClaim.class, ClaimHeaderInformation.class,
				BatchInformation.class, BillingProvider.class, PerformingProvider.class,
				Member.class, Provider.class}));
	
	private StreamMessageListenerContainer<String, MapRecord<String, Object, Object>> listenerContainer;
	private Subscription subscription;
	
	
	public ClaimRepository(RedisTemplate<String, byte[]> template) {
		this.redisTemplate = template;
		this.hashop = template.opsForHash();
		this.streamop = template.opsForStream();
	}
	public void addStream() {
		this.addStream(streamkey, consumerGroup);
	}
	public void addStream(String streamName, String consumerGroupName) {
		if (!redisTemplate.hasKey(streamName)) {
		    RedisClusterAsyncCommands<String, String> commands = (RedisClusterAsyncCommands<String, String>) redisTemplate.getConnectionFactory()
		            .getConnection().getNativeConnection();
		    CommandArgs<String, String> args = new CommandArgs<>(StringCodec.UTF8)
		            .add(CommandKeyword.CREATE)
		            .add(streamName)
		            .add(consumerGroupName)
		            .add("0")
		            .add("MKSTREAM");
		    commands.dispatch(CommandType.XGROUP, new StatusOutput<>(StringCodec.UTF8), args);
		} else {
		    //creating consumer group
		    redisTemplate.opsForStream().createGroup(streamName, ReadOffset.from("0"), consumerGroupName);
		}
		
	}
	public void register() {
		this.registerListener(streamkey, consumerGroup, "test");
	}
	public void registerListener(String streamName, String consumerGroupName, String consumerName) {
		this.listenerContainer = 
				StreamMessageListenerContainer.create(redisTemplate.getConnectionFactory(),
			    StreamMessageListenerContainer
			                .StreamMessageListenerContainerOptions.builder()
			                .hashKeySerializer(new JdkSerializationRedisSerializer())
			                .hashValueSerializer(new JdkSerializationRedisSerializer())
			             .pollTimeout(Duration.ofMillis(10000))
			                .build());

			Consumer consumer = Consumer.from(consumerGroupName, consumerName);
			this.subscription = listenerContainer.receive(
			        consumer ,
			        StreamOffset.create(streamName, ReadOffset.lastConsumed()),
			        this);		
			this.listenerContainer.start();
	}
	public void saveDentalClaim(DentalClaim dclaim) {
		String key = dclaim.getClaimHeaderInformation().getBatchInformation().getClaimNumber();
		System.out.println("Adding Dental Claim to the stream - "+key);
		byte [] value = dcks.serialize(dclaim);
		Map<byte[], byte[]> map = new HashMap<>();
		map.put(key.getBytes(), value);
		MapRecord<String, byte[], byte[]> record = StreamRecords.rawBytes(map).withStreamKey(streamkey);
		RecordId r = streamop.add(record);
		
		System.out.println(r.getTimestamp()+"-"+r.getSequence());
	}
	
	@SuppressWarnings("unchecked")
	public void autosaveListener() {
		TimerTask tt = new TimerTask() {

			@Override
			public void run() {
				System.out.println(redisTemplate.keys("*"));
				System.out.println("Listening to Stream - "+ streamkey);
				 List<ObjectRecord<String, byte[]>> messages = 
						 streamop.read(byte[].class, StreamReadOptions.empty().count(2),
						 StreamOffset.latest(streamkey));		
				 System.out.println("Found "+ messages.size() +" records.");
				messages.stream().forEach(a->{
					save(a.getStream(), a.getValue());					
				});
			}

		};
		Timer timer = new Timer();
		timer.scheduleAtFixedRate(tt, 100, 60*1000);
	}
	private void save(String id, byte[] value) {
		hashop.put("DentalClaim", 
				id, value);
	}
	private void saveStream(String id, byte[] value) {
		ObjectRecord<String, byte[]> record = 
				StreamRecords.objectBacked(value).withStreamKey(streamkey);
		streamop.add(record );
	}	
	public void deleteDentalClaim(String claimNumber) {
		hashop.delete("DentalClaim", claimNumber);
	}
	
	public void update(DentalClaim dclaim) {
		hashop.put("DentalClaim", 
				dclaim.getClaimHeaderInformation().getBatchInformation().getClaimNumber(), 
				dcks.serialize(dclaim));
	}
	
	public DentalClaim getDentalClaimByClaimNumber(String claimNumber) {
		return dcks.deserialize(hashop.get("DentalClaim", claimNumber));
	}
	
	public List<DentalClaim> getAllDentalClaim(){
		return hashop.values("DentalClaim").stream().map(a->dcks.deserialize(a)).collect(Collectors.toList());
	}

	public void save(DentalClaim dclaim) {
		String key = dclaim.getClaimHeaderInformation().getBatchInformation().getClaimNumber();
		byte [] value = dcks.serialize(dclaim);
		save(key, value);
	}

	public void flush() {
		redisTemplate.getConnectionFactory().getConnection().flushAll();
	}
	@Override
	public void onMessage(MapRecord<String, Object, Object> message) {
		System.out.println("---->"+message.getId().getValue());
	}
	
	
	public void readMessage() {
		// Check for any previously unacknowledged messages that were delivered to this consumer.
		System.out.println("STREAM - Checking for previously unacknowledged messages for " + this.getClass().getSimpleName() + " event stream listener.");
		String offset = "0";
		while ((offset = processUnacknowledgedMessage(offset)) != null) {
			System.out.println("STREAM - Finished processing one unacknowledged message for " + this.getClass().getSimpleName() + " event stream listener: " + offset);
		}
		System.out.println("STREAM - Finished checking for previously unacknowledged messages for " + this.getClass().getSimpleName() + " event stream listener.");
		
	}
	public String processUnacknowledgedMessage(String offset) {
        List<MapRecord<String, Object, Object>> messages = redisTemplate.opsForStream().read(Consumer.from(consumerGroup, "test"),
                        StreamReadOptions.empty().noack().count(1),
                        StreamOffset.create(streamkey, ReadOffset.from(offset)));
        String lastMessageId = null;
        for (MapRecord message : messages) {
        	System.out.println(String.format("STREAM - Processing event(%s) from stream(%s) during startup: %s", message.getId(), message.getStream(), message.getValue()));
                processRecord(message);
                System.out.println(String.format("STREAM - Finished processing event(%s) from stream(%s) during startup.", message.getId(), message.getStream()));
                redisTemplate.opsForStream().acknowledge(consumerGroup, message);
                lastMessageId = message.getId().getValue();
        }
        return lastMessageId;
}
	private void processRecord(MapRecord message) {
		// TODO Auto-generated method stub
		
	}
	public void stopListener() {
		this.listenerContainer.stop();
	}
	
}
