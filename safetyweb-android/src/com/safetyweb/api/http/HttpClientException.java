/*
 * SafetyWebClientException.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 6, 2010
 * Version: $Id: HttpClientException.java 1612 2010-07-19 18:09:12Z dan $
 */

package com.safetyweb.api.http;

/**
 * HttpClientException Exception.
 * 
 * @author dhansen
 */
public class HttpClientException extends RuntimeException {
	private static final long serialVersionUID = 1L;

	/**
	 * Creates a new HttpClientException with the specified message.
	 * 
	 * @param message An error message describing why this exception was thrown.
	 */
	public HttpClientException(String message) {
		super(message);
	}

	/**
	 * Creates a new HttpClientException with the specified message, and root
	 * cause.
	 * 
	 * @param message An error message describing why this exception was thrown.
	 * @param t The underlying cause of this exception.
	 */
	public HttpClientException(String message, Throwable t) {
		super(message, t);
	}
}
