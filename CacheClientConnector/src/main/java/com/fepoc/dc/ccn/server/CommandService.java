package com.fepoc.dc.ccn.server;

import static io.grpc.stub.ServerCalls.asyncUnimplementedUnaryCall;

import java.util.UUID;

import org.springframework.stereotype.Service;

import com.fepoc.ac.acn.cmd.CommandReply;
import com.fepoc.ac.acn.cmd.CommandReply.ErrorMap;
import com.fepoc.ac.acn.cmd.CommandReply.State;
import com.fepoc.ac.acn.cmd.CommandReply.State.Builder;
import com.fepoc.ac.acn.cmd.CommletGrpc;
import com.fepoc.dc.ccn.security.Authentication;
@Service
public class CommandService extends CommletGrpc.CommletImplBase{
    /**
     */
    public void connect(com.fepoc.ac.acn.cmd.CommandRequest request,
        io.grpc.stub.StreamObserver<com.fepoc.ac.acn.cmd.CommandReply> responseObserver) {
    	com.fepoc.ac.acn.cmd.CommandReply reply = null;
    	if(Authentication.authenticate(
    			request.getHeader().getLogin().getClient(), 
    			request.getHeader().getLogin().getPassword())) {
	    	System.out.println("Connect.......");
	    	Builder valueBuilder = State.newBuilder();
	    	valueBuilder.setStateCode("accessToken");
	    	valueBuilder.setStateMsg(UUID.randomUUID().toString());
	    	reply =	CommandReply.newBuilder().setState(valueBuilder.build()).build();
    	}
    	else {
	    	Builder errorBuilder = State.newBuilder();
	    	errorBuilder.setStateCode("E0001");
	    	errorBuilder.setStateMsg("Authentication is failed");
			reply =	CommandReply.newBuilder().setState(errorBuilder.build()).build();    		
    	}
      //asyncUnimplementedUnaryCall(CommletGrpc.getConnectMethod(), responseObserver);
		responseObserver.onNext(reply);
		responseObserver.onCompleted();
    	
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
