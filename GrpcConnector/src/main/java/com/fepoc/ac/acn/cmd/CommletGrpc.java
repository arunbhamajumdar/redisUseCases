package com.fepoc.ac.acn.cmd;

import static io.grpc.MethodDescriptor.generateFullMethodName;
import static io.grpc.stub.ClientCalls.asyncBidiStreamingCall;
import static io.grpc.stub.ClientCalls.asyncClientStreamingCall;
import static io.grpc.stub.ClientCalls.asyncServerStreamingCall;
import static io.grpc.stub.ClientCalls.asyncUnaryCall;
import static io.grpc.stub.ClientCalls.blockingServerStreamingCall;
import static io.grpc.stub.ClientCalls.blockingUnaryCall;
import static io.grpc.stub.ClientCalls.futureUnaryCall;
import static io.grpc.stub.ServerCalls.asyncBidiStreamingCall;
import static io.grpc.stub.ServerCalls.asyncClientStreamingCall;
import static io.grpc.stub.ServerCalls.asyncServerStreamingCall;
import static io.grpc.stub.ServerCalls.asyncUnaryCall;
import static io.grpc.stub.ServerCalls.asyncUnimplementedStreamingCall;
import static io.grpc.stub.ServerCalls.asyncUnimplementedUnaryCall;

/**
 * <pre>
 * The Command service definition.
 * </pre>
 */
@javax.annotation.Generated(
    value = "by gRPC proto compiler (version 1.28.1)",
    comments = "Source: command/command.proto")
public final class CommletGrpc {

  private CommletGrpc() {}

  public static final String SERVICE_NAME = "command.Commlet";

  // Static method descriptors that strictly reflect the proto.
  private static volatile io.grpc.MethodDescriptor<com.fepoc.ac.acn.cmd.CommandRequest,
      com.fepoc.ac.acn.cmd.CommandReply> getConnectMethod;

  @io.grpc.stub.annotations.RpcMethod(
      fullMethodName = SERVICE_NAME + '/' + "connect",
      requestType = com.fepoc.ac.acn.cmd.CommandRequest.class,
      responseType = com.fepoc.ac.acn.cmd.CommandReply.class,
      methodType = io.grpc.MethodDescriptor.MethodType.UNARY)
  public static io.grpc.MethodDescriptor<com.fepoc.ac.acn.cmd.CommandRequest,
      com.fepoc.ac.acn.cmd.CommandReply> getConnectMethod() {
    io.grpc.MethodDescriptor<com.fepoc.ac.acn.cmd.CommandRequest, com.fepoc.ac.acn.cmd.CommandReply> getConnectMethod;
    if ((getConnectMethod = CommletGrpc.getConnectMethod) == null) {
      synchronized (CommletGrpc.class) {
        if ((getConnectMethod = CommletGrpc.getConnectMethod) == null) {
          CommletGrpc.getConnectMethod = getConnectMethod =
              io.grpc.MethodDescriptor.<com.fepoc.ac.acn.cmd.CommandRequest, com.fepoc.ac.acn.cmd.CommandReply>newBuilder()
              .setType(io.grpc.MethodDescriptor.MethodType.UNARY)
              .setFullMethodName(generateFullMethodName(SERVICE_NAME, "connect"))
              .setSampledToLocalTracing(true)
              .setRequestMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.fepoc.ac.acn.cmd.CommandRequest.getDefaultInstance()))
              .setResponseMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.fepoc.ac.acn.cmd.CommandReply.getDefaultInstance()))
              .setSchemaDescriptor(new CommletMethodDescriptorSupplier("connect"))
              .build();
        }
      }
    }
    return getConnectMethod;
  }

  private static volatile io.grpc.MethodDescriptor<com.fepoc.ac.acn.cmd.CommandRequest,
      com.fepoc.ac.acn.cmd.CommandReply> getGetMethod;

  @io.grpc.stub.annotations.RpcMethod(
      fullMethodName = SERVICE_NAME + '/' + "get",
      requestType = com.fepoc.ac.acn.cmd.CommandRequest.class,
      responseType = com.fepoc.ac.acn.cmd.CommandReply.class,
      methodType = io.grpc.MethodDescriptor.MethodType.UNARY)
  public static io.grpc.MethodDescriptor<com.fepoc.ac.acn.cmd.CommandRequest,
      com.fepoc.ac.acn.cmd.CommandReply> getGetMethod() {
    io.grpc.MethodDescriptor<com.fepoc.ac.acn.cmd.CommandRequest, com.fepoc.ac.acn.cmd.CommandReply> getGetMethod;
    if ((getGetMethod = CommletGrpc.getGetMethod) == null) {
      synchronized (CommletGrpc.class) {
        if ((getGetMethod = CommletGrpc.getGetMethod) == null) {
          CommletGrpc.getGetMethod = getGetMethod =
              io.grpc.MethodDescriptor.<com.fepoc.ac.acn.cmd.CommandRequest, com.fepoc.ac.acn.cmd.CommandReply>newBuilder()
              .setType(io.grpc.MethodDescriptor.MethodType.UNARY)
              .setFullMethodName(generateFullMethodName(SERVICE_NAME, "get"))
              .setSampledToLocalTracing(true)
              .setRequestMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.fepoc.ac.acn.cmd.CommandRequest.getDefaultInstance()))
              .setResponseMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.fepoc.ac.acn.cmd.CommandReply.getDefaultInstance()))
              .setSchemaDescriptor(new CommletMethodDescriptorSupplier("get"))
              .build();
        }
      }
    }
    return getGetMethod;
  }

  private static volatile io.grpc.MethodDescriptor<com.fepoc.ac.acn.cmd.CommandRequest,
      com.fepoc.ac.acn.cmd.CommandReply> getPutMethod;

  @io.grpc.stub.annotations.RpcMethod(
      fullMethodName = SERVICE_NAME + '/' + "put",
      requestType = com.fepoc.ac.acn.cmd.CommandRequest.class,
      responseType = com.fepoc.ac.acn.cmd.CommandReply.class,
      methodType = io.grpc.MethodDescriptor.MethodType.UNARY)
  public static io.grpc.MethodDescriptor<com.fepoc.ac.acn.cmd.CommandRequest,
      com.fepoc.ac.acn.cmd.CommandReply> getPutMethod() {
    io.grpc.MethodDescriptor<com.fepoc.ac.acn.cmd.CommandRequest, com.fepoc.ac.acn.cmd.CommandReply> getPutMethod;
    if ((getPutMethod = CommletGrpc.getPutMethod) == null) {
      synchronized (CommletGrpc.class) {
        if ((getPutMethod = CommletGrpc.getPutMethod) == null) {
          CommletGrpc.getPutMethod = getPutMethod =
              io.grpc.MethodDescriptor.<com.fepoc.ac.acn.cmd.CommandRequest, com.fepoc.ac.acn.cmd.CommandReply>newBuilder()
              .setType(io.grpc.MethodDescriptor.MethodType.UNARY)
              .setFullMethodName(generateFullMethodName(SERVICE_NAME, "put"))
              .setSampledToLocalTracing(true)
              .setRequestMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.fepoc.ac.acn.cmd.CommandRequest.getDefaultInstance()))
              .setResponseMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.fepoc.ac.acn.cmd.CommandReply.getDefaultInstance()))
              .setSchemaDescriptor(new CommletMethodDescriptorSupplier("put"))
              .build();
        }
      }
    }
    return getPutMethod;
  }

  private static volatile io.grpc.MethodDescriptor<com.fepoc.ac.acn.cmd.CommandRequest,
      com.fepoc.ac.acn.cmd.CommandReply> getValidateMethod;

  @io.grpc.stub.annotations.RpcMethod(
      fullMethodName = SERVICE_NAME + '/' + "validate",
      requestType = com.fepoc.ac.acn.cmd.CommandRequest.class,
      responseType = com.fepoc.ac.acn.cmd.CommandReply.class,
      methodType = io.grpc.MethodDescriptor.MethodType.UNARY)
  public static io.grpc.MethodDescriptor<com.fepoc.ac.acn.cmd.CommandRequest,
      com.fepoc.ac.acn.cmd.CommandReply> getValidateMethod() {
    io.grpc.MethodDescriptor<com.fepoc.ac.acn.cmd.CommandRequest, com.fepoc.ac.acn.cmd.CommandReply> getValidateMethod;
    if ((getValidateMethod = CommletGrpc.getValidateMethod) == null) {
      synchronized (CommletGrpc.class) {
        if ((getValidateMethod = CommletGrpc.getValidateMethod) == null) {
          CommletGrpc.getValidateMethod = getValidateMethod =
              io.grpc.MethodDescriptor.<com.fepoc.ac.acn.cmd.CommandRequest, com.fepoc.ac.acn.cmd.CommandReply>newBuilder()
              .setType(io.grpc.MethodDescriptor.MethodType.UNARY)
              .setFullMethodName(generateFullMethodName(SERVICE_NAME, "validate"))
              .setSampledToLocalTracing(true)
              .setRequestMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.fepoc.ac.acn.cmd.CommandRequest.getDefaultInstance()))
              .setResponseMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.fepoc.ac.acn.cmd.CommandReply.getDefaultInstance()))
              .setSchemaDescriptor(new CommletMethodDescriptorSupplier("validate"))
              .build();
        }
      }
    }
    return getValidateMethod;
  }

  /**
   * Creates a new async stub that supports all call types for the service
   */
  public static CommletStub newStub(io.grpc.Channel channel) {
    io.grpc.stub.AbstractStub.StubFactory<CommletStub> factory =
      new io.grpc.stub.AbstractStub.StubFactory<CommletStub>() {
        @java.lang.Override
        public CommletStub newStub(io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
          return new CommletStub(channel, callOptions);
        }
      };
    return CommletStub.newStub(factory, channel);
  }

  /**
   * Creates a new blocking-style stub that supports unary and streaming output calls on the service
   */
  public static CommletBlockingStub newBlockingStub(
      io.grpc.Channel channel) {
    io.grpc.stub.AbstractStub.StubFactory<CommletBlockingStub> factory =
      new io.grpc.stub.AbstractStub.StubFactory<CommletBlockingStub>() {
        @java.lang.Override
        public CommletBlockingStub newStub(io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
          return new CommletBlockingStub(channel, callOptions);
        }
      };
    return CommletBlockingStub.newStub(factory, channel);
  }

  /**
   * Creates a new ListenableFuture-style stub that supports unary calls on the service
   */
  public static CommletFutureStub newFutureStub(
      io.grpc.Channel channel) {
    io.grpc.stub.AbstractStub.StubFactory<CommletFutureStub> factory =
      new io.grpc.stub.AbstractStub.StubFactory<CommletFutureStub>() {
        @java.lang.Override
        public CommletFutureStub newStub(io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
          return new CommletFutureStub(channel, callOptions);
        }
      };
    return CommletFutureStub.newStub(factory, channel);
  }

  /**
   * <pre>
   * The Command service definition.
   * </pre>
   */
  public static abstract class CommletImplBase implements io.grpc.BindableService {

    /**
     */
    public void connect(com.fepoc.ac.acn.cmd.CommandRequest request,
        io.grpc.stub.StreamObserver<com.fepoc.ac.acn.cmd.CommandReply> responseObserver) {
      asyncUnimplementedUnaryCall(getConnectMethod(), responseObserver);
    }

    /**
     */
    public void get(com.fepoc.ac.acn.cmd.CommandRequest request,
        io.grpc.stub.StreamObserver<com.fepoc.ac.acn.cmd.CommandReply> responseObserver) {
      asyncUnimplementedUnaryCall(getGetMethod(), responseObserver);
    }

    /**
     */
    public void put(com.fepoc.ac.acn.cmd.CommandRequest request,
        io.grpc.stub.StreamObserver<com.fepoc.ac.acn.cmd.CommandReply> responseObserver) {
      asyncUnimplementedUnaryCall(getPutMethod(), responseObserver);
    }

    /**
     */
    public void validate(com.fepoc.ac.acn.cmd.CommandRequest request,
        io.grpc.stub.StreamObserver<com.fepoc.ac.acn.cmd.CommandReply> responseObserver) {
      asyncUnimplementedUnaryCall(getValidateMethod(), responseObserver);
    }

    @java.lang.Override public final io.grpc.ServerServiceDefinition bindService() {
      return io.grpc.ServerServiceDefinition.builder(getServiceDescriptor())
          .addMethod(
            getConnectMethod(),
            asyncUnaryCall(
              new MethodHandlers<
                com.fepoc.ac.acn.cmd.CommandRequest,
                com.fepoc.ac.acn.cmd.CommandReply>(
                  this, METHODID_CONNECT)))
          .addMethod(
            getGetMethod(),
            asyncUnaryCall(
              new MethodHandlers<
                com.fepoc.ac.acn.cmd.CommandRequest,
                com.fepoc.ac.acn.cmd.CommandReply>(
                  this, METHODID_GET)))
          .addMethod(
            getPutMethod(),
            asyncUnaryCall(
              new MethodHandlers<
                com.fepoc.ac.acn.cmd.CommandRequest,
                com.fepoc.ac.acn.cmd.CommandReply>(
                  this, METHODID_PUT)))
          .addMethod(
            getValidateMethod(),
            asyncUnaryCall(
              new MethodHandlers<
                com.fepoc.ac.acn.cmd.CommandRequest,
                com.fepoc.ac.acn.cmd.CommandReply>(
                  this, METHODID_VALIDATE)))
          .build();
    }
  }

  /**
   * <pre>
   * The Command service definition.
   * </pre>
   */
  public static final class CommletStub extends io.grpc.stub.AbstractAsyncStub<CommletStub> {
    private CommletStub(
        io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
      super(channel, callOptions);
    }

    @java.lang.Override
    protected CommletStub build(
        io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
      return new CommletStub(channel, callOptions);
    }

    /**
     */
    public void connect(com.fepoc.ac.acn.cmd.CommandRequest request,
        io.grpc.stub.StreamObserver<com.fepoc.ac.acn.cmd.CommandReply> responseObserver) {
      asyncUnaryCall(
          getChannel().newCall(getConnectMethod(), getCallOptions()), request, responseObserver);
    }

    /**
     */
    public void get(com.fepoc.ac.acn.cmd.CommandRequest request,
        io.grpc.stub.StreamObserver<com.fepoc.ac.acn.cmd.CommandReply> responseObserver) {
      asyncUnaryCall(
          getChannel().newCall(getGetMethod(), getCallOptions()), request, responseObserver);
    }

    /**
     */
    public void put(com.fepoc.ac.acn.cmd.CommandRequest request,
        io.grpc.stub.StreamObserver<com.fepoc.ac.acn.cmd.CommandReply> responseObserver) {
      asyncUnaryCall(
          getChannel().newCall(getPutMethod(), getCallOptions()), request, responseObserver);
    }

    /**
     */
    public void validate(com.fepoc.ac.acn.cmd.CommandRequest request,
        io.grpc.stub.StreamObserver<com.fepoc.ac.acn.cmd.CommandReply> responseObserver) {
      asyncUnaryCall(
          getChannel().newCall(getValidateMethod(), getCallOptions()), request, responseObserver);
    }
  }

  /**
   * <pre>
   * The Command service definition.
   * </pre>
   */
  public static final class CommletBlockingStub extends io.grpc.stub.AbstractBlockingStub<CommletBlockingStub> {
    private CommletBlockingStub(
        io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
      super(channel, callOptions);
    }

    @java.lang.Override
    protected CommletBlockingStub build(
        io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
      return new CommletBlockingStub(channel, callOptions);
    }

    /**
     */
    public com.fepoc.ac.acn.cmd.CommandReply connect(com.fepoc.ac.acn.cmd.CommandRequest request) {
      return blockingUnaryCall(
          getChannel(), getConnectMethod(), getCallOptions(), request);
    }

    /**
     */
    public com.fepoc.ac.acn.cmd.CommandReply get(com.fepoc.ac.acn.cmd.CommandRequest request) {
      return blockingUnaryCall(
          getChannel(), getGetMethod(), getCallOptions(), request);
    }

    /**
     */
    public com.fepoc.ac.acn.cmd.CommandReply put(com.fepoc.ac.acn.cmd.CommandRequest request) {
      return blockingUnaryCall(
          getChannel(), getPutMethod(), getCallOptions(), request);
    }

    /**
     */
    public com.fepoc.ac.acn.cmd.CommandReply validate(com.fepoc.ac.acn.cmd.CommandRequest request) {
      return blockingUnaryCall(
          getChannel(), getValidateMethod(), getCallOptions(), request);
    }
  }

  /**
   * <pre>
   * The Command service definition.
   * </pre>
   */
  public static final class CommletFutureStub extends io.grpc.stub.AbstractFutureStub<CommletFutureStub> {
    private CommletFutureStub(
        io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
      super(channel, callOptions);
    }

    @java.lang.Override
    protected CommletFutureStub build(
        io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
      return new CommletFutureStub(channel, callOptions);
    }

    /**
     */
    public com.google.common.util.concurrent.ListenableFuture<com.fepoc.ac.acn.cmd.CommandReply> connect(
        com.fepoc.ac.acn.cmd.CommandRequest request) {
      return futureUnaryCall(
          getChannel().newCall(getConnectMethod(), getCallOptions()), request);
    }

    /**
     */
    public com.google.common.util.concurrent.ListenableFuture<com.fepoc.ac.acn.cmd.CommandReply> get(
        com.fepoc.ac.acn.cmd.CommandRequest request) {
      return futureUnaryCall(
          getChannel().newCall(getGetMethod(), getCallOptions()), request);
    }

    /**
     */
    public com.google.common.util.concurrent.ListenableFuture<com.fepoc.ac.acn.cmd.CommandReply> put(
        com.fepoc.ac.acn.cmd.CommandRequest request) {
      return futureUnaryCall(
          getChannel().newCall(getPutMethod(), getCallOptions()), request);
    }

    /**
     */
    public com.google.common.util.concurrent.ListenableFuture<com.fepoc.ac.acn.cmd.CommandReply> validate(
        com.fepoc.ac.acn.cmd.CommandRequest request) {
      return futureUnaryCall(
          getChannel().newCall(getValidateMethod(), getCallOptions()), request);
    }
  }

  private static final int METHODID_CONNECT = 0;
  private static final int METHODID_GET = 1;
  private static final int METHODID_PUT = 2;
  private static final int METHODID_VALIDATE = 3;

  private static final class MethodHandlers<Req, Resp> implements
      io.grpc.stub.ServerCalls.UnaryMethod<Req, Resp>,
      io.grpc.stub.ServerCalls.ServerStreamingMethod<Req, Resp>,
      io.grpc.stub.ServerCalls.ClientStreamingMethod<Req, Resp>,
      io.grpc.stub.ServerCalls.BidiStreamingMethod<Req, Resp> {
    private final CommletImplBase serviceImpl;
    private final int methodId;

    MethodHandlers(CommletImplBase serviceImpl, int methodId) {
      this.serviceImpl = serviceImpl;
      this.methodId = methodId;
    }

    @java.lang.Override
    @java.lang.SuppressWarnings("unchecked")
    public void invoke(Req request, io.grpc.stub.StreamObserver<Resp> responseObserver) {
      switch (methodId) {
        case METHODID_CONNECT:
          serviceImpl.connect((com.fepoc.ac.acn.cmd.CommandRequest) request,
              (io.grpc.stub.StreamObserver<com.fepoc.ac.acn.cmd.CommandReply>) responseObserver);
          break;
        case METHODID_GET:
          serviceImpl.get((com.fepoc.ac.acn.cmd.CommandRequest) request,
              (io.grpc.stub.StreamObserver<com.fepoc.ac.acn.cmd.CommandReply>) responseObserver);
          break;
        case METHODID_PUT:
          serviceImpl.put((com.fepoc.ac.acn.cmd.CommandRequest) request,
              (io.grpc.stub.StreamObserver<com.fepoc.ac.acn.cmd.CommandReply>) responseObserver);
          break;
        case METHODID_VALIDATE:
          serviceImpl.validate((com.fepoc.ac.acn.cmd.CommandRequest) request,
              (io.grpc.stub.StreamObserver<com.fepoc.ac.acn.cmd.CommandReply>) responseObserver);
          break;
        default:
          throw new AssertionError();
      }
    }

    @java.lang.Override
    @java.lang.SuppressWarnings("unchecked")
    public io.grpc.stub.StreamObserver<Req> invoke(
        io.grpc.stub.StreamObserver<Resp> responseObserver) {
      switch (methodId) {
        default:
          throw new AssertionError();
      }
    }
  }

  private static abstract class CommletBaseDescriptorSupplier
      implements io.grpc.protobuf.ProtoFileDescriptorSupplier, io.grpc.protobuf.ProtoServiceDescriptorSupplier {
    CommletBaseDescriptorSupplier() {}

    @java.lang.Override
    public com.google.protobuf.Descriptors.FileDescriptor getFileDescriptor() {
      return com.fepoc.ac.acn.cmd.CommandProto.getDescriptor();
    }

    @java.lang.Override
    public com.google.protobuf.Descriptors.ServiceDescriptor getServiceDescriptor() {
      return getFileDescriptor().findServiceByName("Commlet");
    }
  }

  private static final class CommletFileDescriptorSupplier
      extends CommletBaseDescriptorSupplier {
    CommletFileDescriptorSupplier() {}
  }

  private static final class CommletMethodDescriptorSupplier
      extends CommletBaseDescriptorSupplier
      implements io.grpc.protobuf.ProtoMethodDescriptorSupplier {
    private final String methodName;

    CommletMethodDescriptorSupplier(String methodName) {
      this.methodName = methodName;
    }

    @java.lang.Override
    public com.google.protobuf.Descriptors.MethodDescriptor getMethodDescriptor() {
      return getServiceDescriptor().findMethodByName(methodName);
    }
  }

  private static volatile io.grpc.ServiceDescriptor serviceDescriptor;

  public static io.grpc.ServiceDescriptor getServiceDescriptor() {
    io.grpc.ServiceDescriptor result = serviceDescriptor;
    if (result == null) {
      synchronized (CommletGrpc.class) {
        result = serviceDescriptor;
        if (result == null) {
          serviceDescriptor = result = io.grpc.ServiceDescriptor.newBuilder(SERVICE_NAME)
              .setSchemaDescriptor(new CommletFileDescriptorSupplier())
              .addMethod(getConnectMethod())
              .addMethod(getGetMethod())
              .addMethod(getPutMethod())
              .addMethod(getValidateMethod())
              .build();
        }
      }
    }
    return result;
  }
}
