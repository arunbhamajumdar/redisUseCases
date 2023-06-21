package com.fepoc.dc.ccn.server;

import org.springframework.stereotype.Component;

import io.grpc.Metadata;
import io.grpc.ServerCall;
import io.grpc.ServerCallHandler;
import io.grpc.ServerInterceptor;

@Component
public class LogInterceptor implements ServerInterceptor {

    @Override
    public <ReqT, RespT> ServerCall.Listener<ReqT> interceptCall(ServerCall<ReqT, RespT> call, Metadata headers,
                                                                 ServerCallHandler<ReqT, RespT> next) {
        System.out.println("Logging...."+call.getMethodDescriptor().getFullMethodName());
        //log.info(call.getMethodDescriptor().getFullMethodName());
        return next.startCall(call, headers);
    }

}