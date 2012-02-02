/*
 * Accounts.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 8, 2010
 * Version: $Id: Accounts.java 1649 2010-07-21 22:21:00Z dan $
 */

package com.safetyweb.api.model;

import java.util.List;

/**
 * Represents the collection of accounts belonging to a child retreived from SafetyWeb's API.
 * 
 * @author dhansen
 */
public class Accounts implements JsonSerializable {

	List<Account> account;

	public List<Account> getAccount() {
		return account;
	}

	public void setAccount(List<Account> account) {
		this.account = account;
	}

	@Override
	public String toString() {
		return String.format("Accounts [account=%s]", account);
	}

}
