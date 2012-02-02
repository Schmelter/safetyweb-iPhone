/*
 * Protocol.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 6, 2010
 * Version: $Id: Protocol.java 1612 2010-07-19 18:09:12Z dan $
 */

package com.safetyweb.api.http;

/**
 * Represents the communication protocol to use when sending requests to SafetyWeb.
 */
public enum Protocol {

	HTTP("http"), HTTPS("https");

	private final String protocol;

	private Protocol(String protocol) {
		this.protocol = protocol;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Enum#toString()
	 */
	@Override
	public String toString() {
		return protocol;
	}
}
