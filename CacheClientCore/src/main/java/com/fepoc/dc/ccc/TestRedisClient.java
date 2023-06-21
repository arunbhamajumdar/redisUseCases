package com.fepoc.dc.ccc;

import java.util.Arrays;
import java.util.List;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.connection.ClusterInfo;
import org.springframework.data.redis.connection.RedisClusterConnection;
import org.springframework.data.redis.connection.RedisStringCommands.SetOption;
import org.springframework.data.redis.connection.ReturnType;
import org.springframework.data.redis.core.types.Expiration;
import org.springframework.stereotype.Component;

import com.fepoc.claim.domain.BatchInformation;
import com.fepoc.claim.domain.BillingProvider;
import com.fepoc.claim.domain.ClaimHeaderInformation;
import com.fepoc.claim.domain.DentalClaim;
import com.fepoc.claim.domain.Member;
import com.fepoc.claim.domain.PerformingProvider;
import com.fepoc.claim.domain.Provider;

import io.lettuce.core.cluster.api.sync.RedisAdvancedClusterCommands;

@Component
public class TestRedisClient {
//	@Autowired
	private RedisClusterConnection rconnection;
	
	public void test() {
//		ClusterInfo clusterInfo = rconnection.clusterGetClusterInfo();
//		System.out.println("Cluster Size:"+ clusterInfo.getClusterSize());
//		rconnection.lPush("tasks".getBytes(), "first task".getBytes());
//		rconnection.lPush("tasks".getBytes(), "second task".getBytes());
//		rconnection.exec();
//		byte[] resp = rconnection.lPop("tasks".getBytes());
//		System.out.println("First List Element: "+ new String(resp));
		DentalClaim dclaim = getDentalClaim();
		System.out.println("Caching....");
		System.out.println(dclaim.getClaimHeaderInformation());
		System.out.println(dclaim.getMember());
		System.out.println(dclaim.getProvider().getBillingProvider());
		System.out.println(dclaim.getProvider().getPerformingProvider());
		
		long tm = System.currentTimeMillis();
		String k = createDentalClaim(dclaim);
		System.out.println("Creation time: "+(System.currentTimeMillis()-tm)+" ms.");
//		tm = System.currentTimeMillis();
//		getDentalClaimFromCache(k.getBytes());
//		System.out.println("Getting time: "+(System.currentTimeMillis()-tm)+" ms.");
	}
	
	public String createDentalClaim(DentalClaim dclaim) {
		long exp = 20*60*1000;
		KryoSerilizer<ClaimHeaderInformation> hdks = 
				new KryoSerilizer<>(Arrays.asList(new Class<?>[] {ClaimHeaderInformation.class,
					BatchInformation.class}));
		KryoSerilizer<BillingProvider> bpks = 
				new KryoSerilizer<>(Arrays.asList(new Class<?>[] {BillingProvider.class}));
		KryoSerilizer<PerformingProvider> ppks = 
				new KryoSerilizer<>(Arrays.asList(new Class<?>[] {PerformingProvider.class}));
		KryoSerilizer<Member> memks = 
				new KryoSerilizer<>(Arrays.asList(new Class<?>[] {Member.class}));
		
		int slotNo = dclaim.getSlotNo();
		String slk = "cs:{".concat(String.valueOf(slotNo)).concat("}:").concat(dclaim.getClaimHeaderInformation().getBatchInformation().key()).concat(":");
		byte [] slkb = slk.getBytes();
		byte [] memk = slk.concat(dclaim.getMember().key()).concat(":").getBytes();
		byte [] hdk = slk.concat(dclaim.getClaimHeaderInformation().getBatchInformation().key()).concat(":").getBytes();
		
		String prk = slk.concat(dclaim.getProvider().key()).concat(":");
		byte [] prkb = prk.getBytes();
		byte [] bprk = prk.concat(dclaim.getProvider().getBillingProvider().key()).getBytes();
		byte [] pprk = prk.concat(dclaim.getProvider().getPerformingProvider().key()).getBytes();
		rconnection.openPipeline();
		rconnection.set(hdk, hdks.serialize(dclaim.getClaimHeaderInformation()), Expiration.milliseconds(exp), SetOption.SET_IF_ABSENT);
		rconnection.set(memk, memks.serialize(dclaim.getMember()), Expiration.milliseconds(exp), SetOption.SET_IF_ABSENT);
		rconnection.set(bprk, bpks.serialize(dclaim.getProvider().getBillingProvider()), Expiration.milliseconds(exp), SetOption.SET_IF_ABSENT);
		rconnection.set(pprk, ppks.serialize(dclaim.getProvider().getPerformingProvider()), Expiration.milliseconds(exp), SetOption.SET_IF_ABSENT);
		rconnection.hSet(prkb, "billing".getBytes(), bprk);
		rconnection.hSet(prkb, "performing".getBytes(), pprk);
		
		rconnection.hSet(slkb, "header".getBytes(), hdk);
		rconnection.hSet(slkb, "member".getBytes(), memk);
		rconnection.hSet(slkb, "provider".getBytes(), prkb);
		
		List<Object> outputs = rconnection.closePipeline();
		outputs.stream().forEach(System.out::println);
		return slk;
	}
	public DentalClaim getDentalClaimFromCache(byte[] keysAndArgs) {
		System.out.println("From Cache:");
		String scriptSha = "18be73661f03c82780425522c19019f8846b68a0";
				//         "9c494037a02d4111682e7cfdae01eb66ed96cf25"; 
				//         "4c4112d560a3645e43a06933adf5fd21ac1e72c8";
		ReturnType returnType = ReturnType.MULTI;
		int numKeys=1;
		List<?> result = rconnection.evalSha(scriptSha, returnType, numKeys, keysAndArgs);
		KryoSerilizer<ClaimHeaderInformation> hdks = 
				new KryoSerilizer<>(Arrays.asList(new Class<?>[] {ClaimHeaderInformation.class,
					BatchInformation.class}));
		KryoSerilizer<BillingProvider> bpks = 
				new KryoSerilizer<>(Arrays.asList(new Class<?>[] {BillingProvider.class}));
		KryoSerilizer<PerformingProvider> ppks = 
				new KryoSerilizer<>(Arrays.asList(new Class<?>[] {PerformingProvider.class}));
		KryoSerilizer<Member> memks = 
				new KryoSerilizer<>(Arrays.asList(new Class<?>[] {Member.class}));
		ClaimHeaderInformation s = null;
		Member m = null;
		BillingProvider bp = null;
		PerformingProvider pp = null;
		try {
			s = hdks.deserialize((byte[])result.get(0));
			m = memks.deserialize((byte[])result.get(1));
			bp = bpks.deserialize((byte[])result.get(2));
			pp = ppks.deserialize((byte[])result.get(3));
			System.out.println(s);
			System.out.println(m);
			System.out.println(bp);
			System.out.println(pp);
		}
		catch(Exception ex) {			
		}
		return null;
	}

	public DentalClaim getDentalClaim() {
		DentalClaim dclaim = new DentalClaim();
		ClaimHeaderInformation claimHeaderInformation = new ClaimHeaderInformation();
		BatchInformation batchInformation = new BatchInformation();
		batchInformation.setClaimNumber(getRandomNumberString());
		claimHeaderInformation.setBatchInformation(batchInformation );
		dclaim.setClaimHeaderInformation(claimHeaderInformation );
		Member member = new Member();	
		member.setId(getRandomNumberString());
		dclaim.setMember(member );
		Provider provider = new Provider();
		BillingProvider billingProvider = new BillingProvider();
		billingProvider.setId(getRandomNumberString());
		provider.setBillingProvider(billingProvider );
		PerformingProvider performingProvider = new PerformingProvider();
		performingProvider.setId(getRandomNumberString());
		provider.setPerformingProvider(performingProvider );
		dclaim.setProvider(provider );
		return dclaim;
	}

	public static String getRandomNumberString() {
	    Random rnd = new Random();
	    int number = rnd.nextInt(999999);

	    // this will convert any number sequence into 6 character.
	    return String.format("%06d", number);
	}
}
