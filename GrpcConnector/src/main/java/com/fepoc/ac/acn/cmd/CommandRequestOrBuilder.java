// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: command/command.proto

package com.fepoc.ac.acn.cmd;

public interface CommandRequestOrBuilder extends
    // @@protoc_insertion_point(interface_extends:command.CommandRequest)
    com.google.protobuf.MessageOrBuilder {

  /**
   * <code>.command.CommandHeader header = 1;</code>
   * @return Whether the header field is set.
   */
  boolean hasHeader();
  /**
   * <code>.command.CommandHeader header = 1;</code>
   * @return The header.
   */
  com.fepoc.ac.acn.cmd.CommandHeader getHeader();
  /**
   * <code>.command.CommandHeader header = 1;</code>
   */
  com.fepoc.ac.acn.cmd.CommandHeaderOrBuilder getHeaderOrBuilder();

  /**
   * <code>.command.CommandBody body = 2;</code>
   * @return Whether the body field is set.
   */
  boolean hasBody();
  /**
   * <code>.command.CommandBody body = 2;</code>
   * @return The body.
   */
  com.fepoc.ac.acn.cmd.CommandBody getBody();
  /**
   * <code>.command.CommandBody body = 2;</code>
   */
  com.fepoc.ac.acn.cmd.CommandBodyOrBuilder getBodyOrBuilder();
}
