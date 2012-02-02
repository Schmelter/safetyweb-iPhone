/*
 * SafetyWebServiceClient.java
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

import java.net.URI;
import java.net.URISyntaxException;

import com.safetyweb.api.http.HttpClient;

/**
 * Abstract SafetWeb client for implementations providing high level access.
 * 
 * @author dhansen
 */
public class AbstractSafetyWebClient {

	/**
	 * Low level client for sending requests to SafetyWeb services.
	 */
	protected final HttpClient client;

	/** The client configuration */
	protected final ClientConfiguration clientConfiguration;

	/**
	 * The service endpoint to which this client will send requests.
	 */
	protected URI endpoint;

	/**
	 * Constructs a new AbstractSafetyWebClient object using the specified
	 * configuration.
	 * 
	 * @param clientConfiguration
	 *            The client configuration for this client.
	 */
	public AbstractSafetyWebClient(ClientConfiguration clientConfiguration) {
		this.clientConfiguration = clientConfiguration;
		client = new HttpClient(clientConfiguration);
	}

	/**
	 * Overrides the default endpoint for this client. Callers can use this
	 * method to control which SafetyWeb region they want to work with.
	 * <p>
	 * Callers can pass in just the endpoint (ex: "www.safetyweb.com") or a full URL, including the
	 * protocol (ex: "https://www.safetyweb.com"). If the protocol is not specified here, the
	 * default protocol from this client's {@link ClientConfiguration} will be used, which by
	 * default is HTTPS.
	 * 
	 * @param endpoint
	 *            The endpoint (ex: "www.safetyweb.com") or a full URL,
	 *            including the protocol (ex: "https://www.safetyweb.com") of
	 *            the region specific SafetyWeb endpoint this client will
	 *            communicate
	 *            with.
	 * 
	 * @throws IllegalArgumentException
	 *             If any problems are detected with the specified endpoint.
	 */
	public void setEndpoint(String endpoint) throws IllegalArgumentException {
		/*
		 * If the endpoint doesn't explicitly specify a protocol to use, then
		 * we'll defer to the default protocol specified in the client
		 * configuration.
		 */
		if (endpoint.contains("://") == false)
			endpoint = clientConfiguration.getProtocol().toString() + "://" + endpoint;

		try {
			this.endpoint = new URI(endpoint);
		}
		catch (URISyntaxException e) {
			throw new IllegalArgumentException(e);
		}
	}

}
