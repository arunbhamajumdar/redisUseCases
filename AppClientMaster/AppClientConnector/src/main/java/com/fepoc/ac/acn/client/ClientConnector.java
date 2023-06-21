package com.fepoc.ac.acn.client;
import static io.grpc.stub.ServerCalls.asyncUnimplementedUnaryCall;

import java.util.concurrent.Executor;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import com.fepoc.ac.acn.cmd.CommandHeader;
import com.fepoc.ac.acn.cmd.CommandReply;
import com.fepoc.ac.acn.cmd.CommandRequest;
import com.fepoc.ac.acn.cmd.CommletGrpc;
import com.fepoc.ac.acn.cmd.CommletGrpc.CommletBlockingStub;
import com.fepoc.ac.acn.cmd.CommletGrpc.CommletStub;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;

import io.grpc.CallCredentials;
import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import io.grpc.netty.NettyChannelBuilder;
@Component
public class ClientConnector {
	
	@Value("${cache.client.hosts}") 
	private String hosts;
    /**
     */
    public void connect() {
    	System.out.println(hosts);
    	String [] address = hosts.split(",")[0].split(":");
    	ManagedChannel grpcChannel = ManagedChannelBuilder
    			.forAddress(address[0], Integer.parseInt(address[1]))
    			.usePlaintext()
    			.build();
    	
    	CommletStub client = CommletGrpc.newStub(grpcChannel)
//    			.withCallCredentials(new CallCredentials() {
//
//					@Override
//					public void applyRequestMetadata(RequestInfo requestInfo, Executor appExecutor,
//							MetadataApplier applier) {
//						
//					}
//
//					@Override
//					public void thisUsesUnstableApi() {
//						
//					}})
    			;
    	CommandHeader header = CommandHeader.getDefaultInstance();
		CommandRequest req = CommandRequest.newBuilder().setHeader(header ).build();
		client.connect(req, new io.grpc.stub.StreamObserver<com.fepoc.ac.acn.cmd.CommandReply>() {

			@Override
			public void onNext(CommandReply value) {
				System.out.println("Got something back "+value);
			}

			@Override
			public void onError(Throwable t) {
				System.out.println("Got error back "+t.getMessage());
			}

			@Override
			public void onCompleted() {
				System.out.println("Got completed back ");
			}
			
		});
    }

    /**
     */
    public void get(com.fepoc.ac.acn.cmd.CommandRequest request,
        io.grpc.stub.StreamObserver<com.fepoc.ac.acn.cmd.CommandReply> responseObserver) {
      asyncUnimplementedUnaryCall(CommletGrpc.getGetMethod(), responseObserver);
    }

    /**
     */
    public void put(com.fepoc.ac.acn.cmd.CommandRequest request,
        io.grpc.stub.StreamObserver<com.fepoc.ac.acn.cmd.CommandReply> responseObserver) {
      asyncUnimplementedUnaryCall(CommletGrpc.getPutMethod(), responseObserver);
    }

    /**
     */
    public void validate(com.fepoc.ac.acn.cmd.CommandRequest request,
        io.grpc.stub.StreamObserver<com.fepoc.ac.acn.cmd.CommandReply> responseObserver) {
      asyncUnimplementedUnaryCall(CommletGrpc.getValidateMethod(), responseObserver);
    }
}
