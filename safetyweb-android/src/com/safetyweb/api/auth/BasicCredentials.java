/*
 * BasicCrendentials.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 6, 2010
 * Version: $Id: BasicCredentials.java 1612 2010-07-19 18:09:12Z dan $
 */

package com.safetyweb.api.auth;

/**
 * Basic implementation of the Credentials interface that allows callers to
 * pass in the SafetyWeb access key and secret access in the constructor.
 */
public class BasicCredentials implements ICredentials {

	private final String accessKey;
	private final String secretKey;

	/**
	 * Constructs a new BasicCredentials object, with the specified SafetyWeb
	 * access key and SafetyWeb secret key.
	 * 
	 * @param accessKey
	 *            The SafetyWeb access key.
	 * @param secretKey
	 *            The SafetyWeb secret access key.
	 */
	public BasicCredentials(String accessKey, String secretKey) {
		this.accessKey = accessKey;
		this.secretKey = secretKey;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.safetyweb.api.auth.ICredentials#getAccessKeyId()
	 */
	public String getAccessKeyId() {
		return accessKey;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.safetyweb.api.auth.ICredentials#getSecretKey()
	 */
	public String getSecretKey() {
		return secretKey;
	}

}
