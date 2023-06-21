package com.fepoc.claim.domain;
import com.fepoc.dc.ccc.RedisKey;

import io.lettuce.core.codec.CRC16;

public class BatchInformation implements RedisKey{
	private String claimNumber;
	private int slotNo=-1;
	
	public String getClaimNumber() {
		return claimNumber;
	}
	public void setClaimNumber(String claimNumber) {
		this.claimNumber = claimNumber;
		if(claimNumber!=null) {
			this.slotNo = CRC16.crc16(claimNumber.getBytes());
		}
	}
	
	public int getSlotNo() {
		return slotNo;
	}
	public void setSlotNo(int slotNo) {
		this.slotNo = slotNo;
	}
	@Override
	public String key() {
		return "bi:".concat(claimNumber);
	}
}
