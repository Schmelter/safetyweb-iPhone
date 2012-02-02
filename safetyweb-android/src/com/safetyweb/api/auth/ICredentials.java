/*
 * Credentials.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 6, 2010
 * Version: $Id: ICredentials.java 1612 2010-07-19 18:09:12Z dan $
 */

package com.safetyweb.api.auth;

/**
 * Provides access to the SafetyWeb credentials used for accessing SafetyWeb
 * services: SafetyWeb
 * access key ID and secret access key. These credentials are used to securely
 * sign requests to SafetyWeb services.
 * <p>
 * A basic implementation of this interface is provided in
 * {@link BasicCredentials}, but callers are free to provide their own
 * implementation, for example, to load SafetyWeb credentials from an encrypted
 * file.
 * <p>
 */
public interface ICredentials {

	/**
	 * Returns the SafetWeb access key ID for this credentials object.
	 * 
	 * @return The SafetyWeb access key ID for this credentials object.
	 */
	public String getAccessKeyId();

	/**
	 * Returns the SafetyWeb secret access key for this credentials object.
	 * 
	 * @return The SafetyWeb secret access key for this credentials object.
	 */
	public String getSecretKey();

}
