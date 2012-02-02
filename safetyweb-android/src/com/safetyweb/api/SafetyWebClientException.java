/*
 * SafetyWebClientException.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author$
 * Created: Jul 6, 2010
 * Version: $Id$
 */

package com.safetyweb.api;

/**
 * SafetyWebClient Exception.
 * 
 * @author dhansen
 */
public class SafetyWebClientException extends RuntimeException {
	private static final long serialVersionUID = 1L;

	/**
	 * Creates a new SafetyWebClientException with the specified message.
	 * 
	 * @param message An error message describing why this exception was thrown.
	 */
	public SafetyWebClientException(String message) {
		super(message);
	}

	/**
	 * Creates a new SafetyWebClientException with the specified message, and root
	 * cause.
	 * 
	 * @param message An error message describing why this exception was thrown.
	 * @param t The underlying cause of this exception.
	 */
	public SafetyWebClientException(String message, Throwable t) {
		super(message, t);
	}
}
