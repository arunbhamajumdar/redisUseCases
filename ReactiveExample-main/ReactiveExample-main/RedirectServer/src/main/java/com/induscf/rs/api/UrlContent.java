package com.induscf.rs.api;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.stream.Collectors;

import org.apache.commons.io.IOUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Service;

@Service
public class UrlContent {
	int i = 0;
	private String sameOrigin = "localhost:8080";
	private String sameOriginRedirectHost = "http://"+sameOrigin+"/redirect?url=";
	private String sameOriginRedirectHostp = "http://"+sameOrigin+"/redirectp/";
	private String sameOriginImageHost = "http://"+sameOrigin+"/image?url=";
	private static List<String> crossOriginHosts = new CopyOnWriteArrayList<>();
	private static ConcurrentMap<String,String> contents = new ConcurrentHashMap<>();
	private static List<String> repeativeList =  new CopyOnWriteArrayList<>();
	
	private String [] crossOriginHost1 = {
		"https://www.google.com", "https://mail.google.com", "https://about.google",
		"https://store.google.com", "https://policies.google.com", "https://google.com",
		"https://www.gstatic.com", "https://fonts.googleapis.com", "https://ajax.googleapis.com",
		"https://mannequin.storage.googleapis.com", "https://ssl.gstatic.com","https://fonts.gstatic.com",
		
		"https://schema.org", "https://www.carefirst.com", "https://www.youtube.com",
		"https://www.instagram.com", "https://www.twiter.com", "https://www.linkedin.com",
		"https://www.facebook.com", "https://member.carefirst.com", "https://individual.carefirst.com",
		
	};
	
	public String getContent(String surl, boolean hostOnly) throws IOException{
		String ourl = surl;
		int n = surl.indexOf("/", "https://".length()+1);
		String baseUrl = n>-1?surl.substring(0, n):surl;
		if(hostOnly) {
			ourl = URLDecoder.decode(surl,"UTF-8"); //.split(" ")[0]
		}
		System.out.println(ourl);
		setUrl(ourl);
		Document document = Jsoup.connect(ourl).ignoreContentType(true).get();
		setUrlList(document.html());
		
//		Element scele = document.selectFirst("head").appendElement("script");
//		scele.attr("type", "text/javascript");
//		scele.html("window.onmessage = function(event){\nevent.source.postMessage(document.body.innerHTML, event.origin);\n};\n");

//		Element metaele = document.selectFirst("head").appendElement("meta");
//		metaele.attr("http-equiv", "refresh");
//		metaele.attr("content", "0; URL='http://"+sameOrigin+"'");
		replaceMeta(document, baseUrl);
		replaceScript(document, baseUrl);
		replaceStyle(document, "url('", "')", baseUrl);
		replaceStyle(document, "url(", ")", baseUrl);
		replaceFormAction(document, baseUrl);
		replaceAHref(document, baseUrl);
		replaceLinks(document, baseUrl);
		replaceImage(document, baseUrl);
		replaceInputImage(document, baseUrl);
	    return document.html();
	}
	private String modifyURL(String html) {
		String[] fragments = html.split("https://");
		try(StringWriter sw = new StringWriter()){
			boolean first = true;
			for(String fr: fragments) {
				if(first) {
					sw.write(fr);
					first = false;
				}
				else {
					if(!fr.startsWith(sameOrigin)) {
						sw.write(sameOriginRedirectHost+"https://"+fr);
					}
					else {
						sw.write(fr);
					}
				}
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	public byte[] getBinaryContent(String surl) throws IOException{
		URL url = new URL(URLDecoder.decode(surl,"UTF-8").split(" ")[0]);
		return IOUtils.toByteArray(url);
//		URLConnection yc = url.openConnection();
//		String result = null;
//        try(BufferedReader in = new BufferedReader(new InputStreamReader(
//                                    yc.getInputStream()))){
//        	
//        }
//        return result;
	}
	private void replaceImage(Document document, String baseUrl) {
	    Elements imgs = document.select("img");
	    imgs.forEach(a->{
	    	
	    	try {
	    			String img = a.attr("src");
	    			if(img.trim().endsWith(".svg")) {
	    				a.attr("src", baseUrl(sameOriginRedirectHost, baseUrl)+URLEncoder.encode(cors(img, baseUrl),"UTF-8"));
	    			}
	    			else {
	    				a.attr("src", baseUrl(sameOriginImageHost, baseUrl)+URLEncoder.encode(cors(img, baseUrl),"UTF-8"));
	    			}
					String srcset = a.attr("srcset");
					if(srcset!=null && !"".equals(srcset.trim())) {
						String[] srcsets = srcset.split(",");
						StringBuilder sb = new StringBuilder();
						for(String s: srcsets) {
							if(!"".equals(sb.toString())) {
								sb.append(", ");
							}
							sb.append(baseUrl(sameOriginImageHost, baseUrl)+URLEncoder.encode(cors(s, baseUrl),"UTF-8"));
						}
						a.attr("srcset", sb.toString());
					}
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				System.err.println("1..."+e.getMessage());
			}
	    });
	}
	private void replaceInputImage(Document document, String baseUrl) {
	    Elements imgs = document.select("input");
	    imgs.forEach(a->{
	    	
	    	try {
	    		String type = a.attr("type");
	    		if(type.startsWith("image")) {
					a.attr("src", baseUrl(sameOriginImageHost, baseUrl)+URLEncoder.encode(cors(a.attr("src"), baseUrl),"UTF-8"));
	    		}
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				System.err.println("1..."+e.getMessage());
			}
	    });
	}	
	private void replaceMeta(Document document, String baseUrl) {
	    Elements metas = document.select("meta");
	    metas.forEach(a->{
	    	
	    	try {
	    		if(a.attr("content").endsWith(".png") || a.attr("content").startsWith("https://")) {
					a.attr("content", baseUrl(sameOriginImageHost, baseUrl)+URLEncoder.encode(cors(a.attr("content"), baseUrl),"UTF-8"));
	    		}
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				System.err.println("2..."+e.getMessage());
			}
	    });
	}
	private void replaceAHref(Document document, String baseUrl) {
	    Elements links = document.select("a");
	    links.forEach(a->{
	    	
	    	try {
	    		if(!"#".equals(a.attr("href"))) {
					a.attr("href", baseUrl(sameOriginRedirectHost, baseUrl)+URLEncoder.encode(cors(a.attr("href"), baseUrl),"UTF-8"));
					a.attr("target","myframe");
	    		}
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				System.err.println("3..."+e.getMessage());
			}
	    });
	}
	private void replaceFormAction(Document document, String baseUrl) {
	    Elements links = document.select("form");
	    links.forEach(a->{
	    	
	    	try {
				a.attr("action", baseUrl(sameOriginRedirectHostp, baseUrl)+URLEncoder.encode(cors(a.attr("action"), baseUrl),"UTF-8"));
				a.attr("target","myframe");
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				System.err.println("3..."+e.getMessage());
			}
	    });
	}
	private void replaceScript(Document document, String baseUrl) {
		Element scele = document.selectFirst("head").appendElement("script");
		scele.attr("type", "text/javascript");
	    Elements links = document.select("script");
		StringBuilder script = new StringBuilder();
	    links.forEach(a->{
	    	
	    	try {
	    		String src = a.attr("src");
	    		if(src!=null && !"".equals(src.trim())) {
	    			a.attr("src", baseUrl(sameOriginRedirectHost, baseUrl)+URLEncoder.encode(cors(src, baseUrl),"UTF-8"));
	    			a.attr("defer", true);
//	    			if(src.contains("application.js")) {
//						String ahref = baseUrl(sameOriginRedirectHost, baseUrl)+URLEncoder.encode(cors(src, baseUrl),"UTF-8");
//						System.out.println("----->"+ahref);
//						try {
//							Element ele = document.selectFirst("head");
//							ele.attr("type", "text/javascript");
//							if(!contents.containsKey(ahref) && !repeativeList.contains(ahref)) {
//								repeativeList.add(ahref);
//								Document doc1 = Jsoup.connect(ahref).ignoreContentType(true).get();
//								Element ele1 = doc1.selectFirst("script");
//								ele.appendText(ele1.html());
//								contents.putIfAbsent(ahref, doc1.html());
//							}
//							else if(contents.containsKey(ahref)){
//								ele.html(contents.get(ahref));								
//							}
//						} catch (IOException e) {
//							// TODO Auto-generated catch block
//							//e.printStackTrace();
//							System.err.println(e.getMessage());
//						}
//	    			}
	    		}
				String html = replaceUrl(a.html(), baseUrl, "https://", "\"");
				html = replaceUrl(html, baseUrl, "/", ".svg\"");
				a.html(html);
				
				i++;
				script.append(
						"\njsLink"+i+" = document.createElement(\"script\");\r\n" + 
						"\njsLink"+i+".src = \""+a.attr("src")+"\"; \r\n" + 
						"\njsLink"+i+".srcdoc = \""+html+"\"; \r\n" + 
						"\njsLink"+i+".type = \"text/javascript\"; \r\n" + 
						"\nself.document.head.appendChild(jsLink"+i+");");
				
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				System.err.println("4..."+e.getMessage());
			}
	    });

		scele.append(script.toString());
	}	
	private String replaceUrl(String html, String baseUrl, String st, String en) {
		StringWriter sw = new StringWriter();
		try(BufferedReader br = new BufferedReader(new StringReader(html))){
			String line;
			while((line=br.readLine())!=null) {
				if(line.contains(st)) {
					int p0 = 0;
					while(true) {
						int p1 = line.indexOf(st, p0);
						if(p1>-1) {
							int p2 = line.indexOf(en,p1+st.length());
							if(p2>-1) {
								String s = line.substring(p1, p2);
								String s1 = baseUrl(sameOriginRedirectHost, baseUrl)+URLEncoder.encode(cors(s, baseUrl),"UTF-8");
								sw.write(line.substring(0, p1));
								sw.write(s1);
								sw.write(line.substring(p2));
								p0 = p2+en.length();
							}
							else {
								p0 = p1 + st.length();
							}
						}
						else {
							sw.write(line.substring(p0));
							break;
						}
					}
				}
				else {
					sw.write(line);
				}
				sw.write("\n");
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return sw.toString();
	}
	private void replaceStyle(Document document, String start, String end, String baseUrl) {
	    Elements links = document.select("style");
	    links.forEach(a->{
			int p = 0;
    		if(a.data().contains(start)) {
    			String as = a.data();
    			while(true) {
	    			int si = as.indexOf(start, p);
	    			if(si>-1) {
	    				int ei = as.indexOf(end, si+start.length());
	    				if(ei>-1) {
	    					try {
		    					String s1 = as.substring(si+start.length(),ei);
		    					if(!s1.startsWith("data:")) {
									String s = baseUrl(sameOriginImageHost, baseUrl)+URLEncoder.encode(cors(s1, baseUrl),"UTF-8");
									p = si+start.length()+s.length()+end.length();
									as = as.substring(0, si+start.length()).concat(s).concat(as.substring(ei));
		    					}
		    					else {
		    						break;
		    					}
							} catch (UnsupportedEncodingException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
								System.err.println("5..."+e.getMessage());
								break;
							}
	    				}
	    				else {
	    					break;
	    				}
	    			}
	    			else {
	    				break;
	    			}
    			}
    			a.text(as);
    		}
	    });
	}		
	private void replaceLinks(Document document, String baseUrl) {
//		Element scele = document.selectFirst("head").appendElement("script");
//		scele.attr("type", "text/javascript");
	    Elements links = document.select("link");
//	    i = 0;
	    links.forEach(a->{
	    	
	    	try {
	    		String type = a.attr("type");
	    		if(type.startsWith("image")) {
					a.attr("href", baseUrl(sameOriginImageHost, baseUrl)+URLEncoder.encode(cors(a.attr("href"), baseUrl),"UTF-8"));
					a.attr("target","myframe");
	    		}
	    		else {
					//a.attr("href", baseUrl(sameOriginRedirectHost, baseUrl)+URLEncoder.encode(cors(a.attr("href"), baseUrl),"UTF-8"));
					String ahref = baseUrl(sameOriginRedirectHost, baseUrl)+URLEncoder.encode(cors(a.attr("href"), baseUrl),"UTF-8");
					try {
						if(!contents.containsKey(ahref) && !repeativeList.contains(ahref)) {
							if("text/css".equals(type)) {
								repeativeList.add(ahref);
								Document doc1 = Jsoup.connect(ahref).ignoreContentType(true).get();
								Element ele = document.selectFirst("head").appendElement("style");
								ele.html(doc1.html());								
								contents.putIfAbsent(ahref, doc1.html());
								a.remove();
							}
						}
						else if(contents.containsKey(ahref)){
							if("text/css".equals(type)) {
								Element ele = document.selectFirst("head").appendElement("style");
								ele.html(contents.get(ahref));	
								a.remove();
							}
						}
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
//					a.attr("target","myframe");
//	    			if("text/css".equals(type)) {
//	    				StringBuilder script = new StringBuilder();
//	    				i++;
//	    				script.append(
//	    						"\nvar cssLink"+i+" = document.createElement(\"link\");\r\n" + 
//	    						"\ncssLink"+i+".href = \""+a.attr("href")+"\"; \r\n" + 
//	    						"\ncssLink"+i+".rel = \"stylesheet\"; \r\n" + 
//	    						"\ncssLink"+i+".type = \"text/css\"; \r\n" + 
//	    						"\nparent.frames['myframe'].document.head.appendChild(cssLink"+i+");");
//	    				scele.append(script.toString());
//	    			}					
	    		}
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				System.err.println("6..."+e.getMessage());
			}
	    });
	}
	private String baseUrl(String str, String baseUrl) {
		return str;
//		MessageFormat msg = new MessageFormat(str);
//		Object [] param = new Object[] {baseUrl};
//		return msg.format(param );
	}
	private String cors(String curl, String baseUrl) {
		for(String cs: crossOriginHosts) {
			if(curl.trim().startsWith(cs)) {
				return curl;
			}
			else if(curl.trim().startsWith(cs.substring("https:".length()))) {
				return "https:".concat(curl);
			}
		}
		if(!baseUrl.endsWith("/")&&!curl.startsWith("/")) {
			curl = "/"+curl;
		}
		return baseUrl.concat(curl);
	}
	private void setUrlList(String html) {
		try(BufferedReader br = new BufferedReader(new StringReader(html))){
			String line;
			while((line=br.readLine())!=null) {
				setUrl(line);
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	private void setUrl(String line) {
		String st = "//";
		String en = "/";
		if(line.contains(st)) {
			//System.out.println(line);
			int p1 = line.indexOf(st);
			int p2 = line.indexOf(en,p1+st.length());
			int p3 = line.indexOf(" ",p1+st.length());
			int p4 = line.indexOf("\"",p1+st.length());
			int p5 = -1;
			if(p2>-1 && p3>-1 && p4>-1) {
				p5 = Math.min(Math.min(p2, p3), p4);
			}
			else if(p2>-1 && p3>-1) {
				p5 = Math.min(p2, p3);
			}
			else if(p2>-1 && p4>-1) {
				p5 = Math.min(p2, p4);
			}
			else if(p4>-1 && p3>-1) {
				p5 = Math.min(p4, p3);
			}
			else if(p2>-1) {
				p5 = p2;
			}
			else if(p3>-1) {
				p5 = p3;
			}
			else if(p4>-1) {
				p5 = p4;
			}
			if(p5>-1) {
				String s = line.substring(p1, p5);
				s = s.startsWith("//")?"https:"+s:"https://"+s;
				if(!crossOriginHosts.contains(s)) {
					crossOriginHosts.add(s);
				}
			}
		}	
	}	
}
