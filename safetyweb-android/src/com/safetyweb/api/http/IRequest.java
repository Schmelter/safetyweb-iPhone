/*
 * IRequest.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 6, 2010
 * Version: $Id: IRequest.java 1612 2010-07-19 18:09:12Z dan $
 */

package com.safetyweb.api.http;

import java.net.URI;
import java.util.Map;

/**
 * Represents a request being sent to a SafetyWeb Service, including the
 * parameters being sent as part of the request, the endpoint to which the
 * request should be sent, etc.
 * <p>
 * This class is only intended for internal use inside the SafetyWeb client libraries. Callers
 * shouldn't ever interact directly with objects of this class.
 */
public interface IRequest {

	/**
	 * Adds the specified header to this request.
	 * 
	 * @param name The name of the header to add.
	 * @param value The header's value.
	 */
	public void addHeader(String name, String value);

	/**
	 * Adds the specified request parameter to this request.
	 * 
	 * @param name The name of the request parameter.
	 * @param value The value of the request parameter.
	 */
	public void addParameter(String name, String value);

	/**
	 * Returns the service endpoint (ex: "https://www.safetyweb.com") to which
	 * this request should be sent.
	 * 
	 * @return The service endpoint to which this request should be sent.
	 */
	public URI getEndpoint();

	/**
	 * Returns a map of all the headers included in this request.
	 * 
	 * @return A map of all the headers included in this request.
	 */
	public Map<String, String> getHeaders();

	/**
	 * Returns the HTTP method name used by this request, defaults to GET.
	 * 
	 * @return String HTTP method.
	 */
	public String getMethodName();

	/**
	 * Returns a map of all parameters in this request.
	 * 
	 * @return A map of all parameters in this request.
	 */
	public Map<String, String> getParameters();

	/**
	 * Returns the path to the resource being requested.
	 * 
	 * @return The path to the resource being requested.
	 */
	public String getResourcePath();

	/**
	 * Sets the service endpoint (ex: "https://www.safetyweb.com") to which this
	 * request should be sent.
	 * 
	 * @param endpoint The service endpoint to which this request should be sent.
	 */
	public void setEndpoint(URI endpoint);

	/**
	 * Sets the path to the resource being requested.
	 * 
	 * @param path The path to the resource being requested.
	 */
	public void setResourcePath(String path);

	/**
	 * Returns the request as a URL string usable in an HTTP GET request.
	 * 
	 * @return The string url.
	 */
	public String toStringUrl();

}
