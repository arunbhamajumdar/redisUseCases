// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: command/command.proto

package com.fepoc.ac.acn.cmd;

public interface CommandHeaderOrBuilder extends
    // @@protoc_insertion_point(interface_extends:command.CommandHeader)
    com.google.protobuf.MessageOrBuilder {

  /**
   * <code>.command.CommandHeader.Login login = 1;</code>
   * @return Whether the login field is set.
   */
  boolean hasLogin();
  /**
   * <code>.command.CommandHeader.Login login = 1;</code>
   * @return The login.
   */
  com.fepoc.ac.acn.cmd.CommandHeader.Login getLogin();
  /**
   * <code>.command.CommandHeader.Login login = 1;</code>
   */
  com.fepoc.ac.acn.cmd.CommandHeader.LoginOrBuilder getLoginOrBuilder();

  /**
   * <code>bytes accessToken = 2;</code>
   * @return The accessToken.
   */
  com.google.protobuf.ByteString getAccessToken();

  /**
   * <code>string application = 3;</code>
   * @return The application.
   */
  java.lang.String getApplication();
  /**
   * <code>string application = 3;</code>
   * @return The bytes for application.
   */
  com.google.protobuf.ByteString
      getApplicationBytes();

  public com.fepoc.ac.acn.cmd.CommandHeader.AuthorizeCase getAuthorizeCase();
}
