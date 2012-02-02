/*
 * ISigner.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 6, 2010
 * Version: $Id: ISigner.java 1612 2010-07-19 18:09:12Z dan $
 */

package com.safetyweb.api.auth;

import java.security.SignatureException;

import com.safetyweb.api.http.IRequest;

/**
 * Represents a class with the ability to sign an HTTP request before it can be sent to the
 * SafetyWeb service API.
 * 
 * @author dhansen
 */
public interface ISigner {

	public void sign(IRequest request) throws SignatureException;

	public void sign(IRequest request, SignatureVersion version, SigningAlgorithm algorithm) throws SignatureException;

}
