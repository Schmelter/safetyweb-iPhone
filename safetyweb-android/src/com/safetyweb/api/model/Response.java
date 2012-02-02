/*
 * Response.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 7, 2010
 * Version: $Id: Response.java 1649 2010-07-21 22:21:00Z dan $
 */

package com.safetyweb.api.model;

/**
 * TODO Type description
 * 
 * @author dhansen
 */
public class Response implements JsonSerializable {

	private Activity activity;
	private Child child;
	private Children children;
	private String number;
	private String offset;
	private Accounts accounts;
	private String result;
	private String token;
	private String total;

	public Accounts getAccounts() {
		return accounts;
	}

	public Activity getActivity() {
		return activity;
	}

	public Child getChild() {
		return child;
	}

	public Children getChildren() {
		return children;
	}

	public String getNumber() {
		return number;
	}

	public String getOffset() {
		return offset;
	}

	public String getResult() {
		return result;
	}

	public String getToken() {
		return token;
	}

	public String getTotal() {
		return total;
	}

	public void setAccounts(Accounts accounts) {
		this.accounts = accounts;
	}

	public void setActivity(Activity activity) {
		this.activity = activity;
	}

	public void setChild(Child child) {
		this.child = child;
	}

	public void setChildren(Children children) {
		this.children = children;
	}

	public void setNumber(String number) {
		this.number = number;
	}

	public void setOffset(String offset) {
		this.offset = offset;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public void setTotal(String total) {
		this.total = total;
	}

	@Override
	public String toString() {
		return String.format(
			"Response [accounts=%s, activity=%s, child=%s, children=%s, number=%s, offset=%s, result=%s, token=%s, total=%s]",
			accounts, activity, child, children, number, offset, result, token, total);
	}

}
