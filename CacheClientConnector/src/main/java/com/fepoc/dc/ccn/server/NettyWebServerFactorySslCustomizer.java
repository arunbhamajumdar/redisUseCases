package com.fepoc.dc.ccn.server;

import java.io.File;
import java.io.IOException;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLException;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.embedded.netty.NettyReactiveWebServerFactory;
import org.springframework.boot.web.embedded.netty.SslServerCustomizer;
import org.springframework.boot.web.server.Http2;
import org.springframework.boot.web.server.Ssl;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.stereotype.Component;
import io.grpc.services.HealthStatusManager;
import io.netty.handler.ssl.ClientAuth;
import io.netty.handler.ssl.SslContext;
import io.netty.handler.ssl.SslContextBuilder;
import io.grpc.Metadata;
import io.grpc.Server;
import io.grpc.ServerCall;
import io.grpc.ServerCall.Listener;
import io.grpc.ServerCallHandler;
import io.grpc.ServerInterceptor;
import io.grpc.health.v1.HealthCheckResponse.ServingStatus;
import io.grpc.netty.GrpcSslContexts;
import io.grpc.netty.NettyServerBuilder;

@Component
public class NettyWebServerFactorySslCustomizer 
  implements WebServerFactoryCustomizer<NettyReactiveWebServerFactory> {
	
	@Value("${server.port}") private int port;
	@Value("${cert.chain.filepath}") private String certChainFilePath;
	@Value("${cert.private.filepath}") private String privateKeyFilePath;
	@Value("${cert.trust.filepath}") private String trustCertCollectionFilePath;
	
    @Override
    public void customize(NettyReactiveWebServerFactory serverFactory) {
        try {
        	 HealthStatusManager health = new HealthStatusManager();        	 
        	 Server server = NettyServerBuilder.forPort(port)
//        	.sslContext(getSslContextBuilder().build())
        	.intercept(new LogInterceptor())
			.addService(new CommandService())	
			.executor(Executors.newFixedThreadPool(20))
			.build().start();
			
			System.out.println("Listening on port " + port);
		    Runtime.getRuntime().addShutdownHook(new Thread() {
		      @Override
		      public void run() {
		        server.shutdown();
		        try {
		          if (!server.awaitTermination(30, TimeUnit.SECONDS)) {
		            server.shutdownNow();
		            server.awaitTermination(5, TimeUnit.SECONDS);
		          }
		        } catch (InterruptedException ex) {
		          server.shutdownNow();
		        }
		      }
		    });
		    health.setStatus("", ServingStatus.SERVING);			
			server.awaitTermination();
		} catch (IOException | InterruptedException e) {
			System.err.println(e.getMessage());
		}
    }

	private SslContextBuilder getSslContextBuilder() {
        SslContextBuilder sslClientContextBuilder = SslContextBuilder.forServer(new File(certChainFilePath),
                new File(privateKeyFilePath));
        if (trustCertCollectionFilePath != null) {
            sslClientContextBuilder.trustManager(new File(trustCertCollectionFilePath));
            sslClientContextBuilder.clientAuth(ClientAuth.REQUIRE);
        }
        return GrpcSslContexts.configure(sslClientContextBuilder);
    }


}