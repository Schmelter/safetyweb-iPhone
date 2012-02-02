/*
 * SignatureVersion.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 6, 2010
 * Version: $Id: SignatureVersion.java 1612 2010-07-19 18:09:12Z dan $
 */

package com.safetyweb.api.auth;

/**
 * Supported signature versions.
 * 
 * @author dhansen
 */
public enum SignatureVersion {

	V1("1");

	private String value;

	private SignatureVersion(String value) {
		this.value = value;
	}

	@Override
	public String toString() {
		return this.value;
	}

}
