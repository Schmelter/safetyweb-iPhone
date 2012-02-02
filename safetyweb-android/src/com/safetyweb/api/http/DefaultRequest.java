/*
 * DefaultRequest.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 6, 2010
 * Version: $Id: DefaultRequest.java 1612 2010-07-19 18:09:12Z dan $
 */

package com.safetyweb.api.http;

import java.net.URI;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.apache.http.NameValuePair;
import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.message.BasicNameValuePair;

import com.safetyweb.api.Constants;

/**
 * Default implementation of the {@linkplain com.safetyweb.api.http.IRequest} interface.
 * <p>
 * This class is only intended for internal use inside the SafetyWeb client libraries. Callers
 * shouldn't ever interact directly with objects of this class.
 * 
 * @author dhansen
 */
public class DefaultRequest implements IRequest {

	/** The service endpoint to which this request should be sent */
	private URI endpoint;

	/** Map of the headers included in this request */
	private Map<String, String> headers = new HashMap<String, String>();

	/** Map of the parameters being sent as part of this request */
	private Map<String, String> parameters = new HashMap<String, String>();

	/** The resource path being requested */
	private String resourcePath;

	public DefaultRequest(URI endpoint) {
		this.endpoint = endpoint;
	}

	/**
	 * @see com.safetyweb.api.http.IRequest#addHeader(java.lang.String, java.lang.String)
	 */
	public void addHeader(String name, String value) {
		headers.put(name, value);
	}

	/**
	 * @see com.safetyweb.api.http.IRequest#addParameter(java.lang.String, java.lang.String)
	 */
	public void addParameter(String name, String value) {
		parameters.put(name, value);
	}

	/**
	 * @see com.safetyweb.api.http.IRequest#getEndpoint()
	 */
	public URI getEndpoint() {
		return endpoint;
	}

	/**
	 * @see com.safetyweb.api.http.IRequest#getHeaders()
	 */
	public Map<String, String> getHeaders() {
		return headers;
	}

	/**
	 * @see com.safetyweb.api.http.IRequest#getMethodName()
	 */
	public String getMethodName() {
		return "GET";
	}

	/**
	 * @see com.safetyweb.api.http.IRequest#getParameters()
	 */
	public Map<String, String> getParameters() {
		return parameters;
	}

	/**
	 * @see com.safetyweb.api.http.IRequest#getResourcePath()
	 */
	public String getResourcePath() {
		return resourcePath;
	}

	/**
	 * @see com.safetyweb.api.http.IRequest#setEndpoint(java.net.URI)
	 */
	public void setEndpoint(URI endpoint) {
		this.endpoint = endpoint;
	}

	/**
	 * @see com.safetyweb.api.http.IRequest#setResourcePath(java.lang.String)
	 */
	public void setResourcePath(String resourcePath) {
		this.resourcePath = resourcePath;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();

		builder.append(getMethodName() + " ");
		builder.append(getEndpoint().toString() + " ");

		builder.append("/" + (getResourcePath() != null ? getResourcePath() : "") + " ");

		if (!getParameters().isEmpty()) {
			builder.append("Parameters: (");
			for (String key : getParameters().keySet()) {
				String value = getParameters().get(key);
				builder.append(key + ": " + value + ", ");
			}
			builder.append(") ");
		}

		if (!getHeaders().isEmpty()) {
			builder.append("Headers: (");
			for (String key : getHeaders().keySet()) {
				String value = getHeaders().get(key);
				builder.append(key + ": " + value + ", ");
			}
			builder.append(") ");
		}

		return builder.toString();
	}

	public String toStringUrl() {
		StringBuilder data = new StringBuilder();
		data.append(endpoint.toString());
		data.append("?");

		Map<String, String> sorted = new TreeMap<String, String>();
		sorted.putAll(parameters);

		Iterator<Map.Entry<String, String>> pairs = sorted.entrySet().iterator();
		List<NameValuePair> nvp = new ArrayList<NameValuePair>(sorted.size());

		while (pairs.hasNext()) {
			Map.Entry<String, String> pair = pairs.next();
			String key = pair.getKey().toString();
			String value = pair.getValue().toString();
			nvp.add(new BasicNameValuePair(key, value != null ? value : ""));
		}

		data.append(URLEncodedUtils.format(nvp, Constants.DEFAULT_ENCODING));

		return data.toString();
	}
}
