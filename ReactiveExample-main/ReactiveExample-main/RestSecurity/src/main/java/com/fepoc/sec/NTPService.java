package com.fepoc.sec;

import java.io.IOException;
import java.net.InetAddress;
import java.util.Calendar;
import java.util.Date;

import org.apache.commons.net.ntp.NTPUDPClient;
import org.apache.commons.net.ntp.TimeInfo;

public class NTPService {

	public static void main(String [] args) throws IOException {
		NTPService ntp = new NTPService();
		Date dt = ntp.currentDateTime();
		System.out.println("current date: "+ dt);
		Date fdt = ntp.addTime(dt, 100, Calendar.HOUR);
		System.out.println("future date: "+ fdt);
		Date pdt = ntp.addTime(dt, -2, Calendar.DATE);
		System.out.println("past date: "+ pdt);
	}
	
	public Date currentDateTime() throws IOException {
		String TIME_SERVER = "ntp1.fepoc.com"; // "ntp2.fepoc.com";
		NTPUDPClient timeClient = new NTPUDPClient();
		InetAddress inetAddress = InetAddress.getByName(TIME_SERVER);
		TimeInfo timeInfo = timeClient.getTime(inetAddress);
		long returnTime = timeInfo.getMessage().getTransmitTimeStamp().getTime();
		Date time = new Date(returnTime);
		return time;
	}
	
	public Date addTime(Date dt, int time, int type) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(dt);
		cal.add(type, time);
		return cal.getTime();
	}
}
