package com.fepoc.domain;

import java.lang.ref.SoftReference;
import java.lang.ref.WeakReference;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;
import java.util.UUID;
import java.util.WeakHashMap;

public class TestWeakReference extends TimerTask{
	
	Timer timer = new Timer();
	//WeakHashMap<String,SoftReference<Date>> wh = new WeakHashMap<>();
	Map<String,WeakReference<Date>> wh = new HashMap<>();

	public static void main(String [] args) {
		TestWeakReference twr = new TestWeakReference();
		twr.timerTest();
	}
	public void timerTest() {
		timer.scheduleAtFixedRate(this, 100l, 100l);
	}
	public void testWeakHashMap() {
		for(int i=0; i<5000; i++) {
//			SoftReference<Date> sr = new SoftReference<>(new Date());
			WeakReference<Date> sr = new WeakReference<>(new Date());
			wh.put(UUID.randomUUID().toString(), sr);
		}
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@Override
	public void run() {
		testWeakHashMap();
		System.out.println("Size: "+wh.size());
	}
}
