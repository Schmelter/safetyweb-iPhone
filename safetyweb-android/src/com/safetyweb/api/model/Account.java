/*
 * Account.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 8, 2010
 * Version: $Id: Account.java 1649 2010-07-21 22:21:00Z dan $
 */

package com.safetyweb.api.model;

/**
 * Represents an account belonging to a child that is retreived from SafetyWeb's API.
 * 
 * @author dhansen
 */
public class Account implements JsonSerializable {

	private String account_id;
	private String service_id;
	private String service_name;
	private String url;
	private String username;
	private String profile_pic;
	private String status;

	public String getAccount_id() {
		return account_id;
	}

	public void setAccount_id(String accountId) {
		account_id = accountId;
	}

	public String getService_id() {
		return service_id;
	}

	public void setService_id(String serviceId) {
		service_id = serviceId;
	}

	public String getService_name() {
		return service_name;
	}

	public void setService_name(String serviceName) {
		service_name = serviceName;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getProfile_pic() {
		return profile_pic;
	}

	public void setProfile_pic(String profilePic) {
		profile_pic = profilePic;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	@Override
	public String toString() {
		return String.format(
			"Account [account_id=%s, profile_pic=%s, service_id=%s, service_name=%s, status=%s, url=%s, username=%s]",
			account_id, profile_pic, service_id, service_name, status, url, username);
	}

}
