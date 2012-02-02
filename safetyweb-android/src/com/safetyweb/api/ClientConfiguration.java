/*
 * ClientConfiguration.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 6, 2010
 * Version: $Id: ClientConfiguration.java 1612 2010-07-19 18:09:12Z dan $
 */

package com.safetyweb.api;

import org.apache.http.HttpVersion;

import com.safetyweb.api.http.Protocol;

/**
 * Client configuration options such as proxy settings, user agent string, max
 * retry attempts, etc.
 */
public class ClientConfiguration {

	/**
	 * The default HTTP user agent header for SafetyWeb clients.
	 */
	public static final String DEFAULT_USER_AGENT = "SafetyWeb Java Client";

	/**
	 * The protocol to use when connecting to SafetyWeb Services.
	 * <p>
	 * The default configuration is to use HTTPS for all requests for increased security.
	 */
	private Protocol protocol = Protocol.HTTPS;

	/** The HTTP user agent header passed with all HTTP requests. */
	private String userAgent = DEFAULT_USER_AGENT;

	/**
	 * The HTTP version, as specified in RFC 2616, to be used for all HTTP requests. The default is
	 * 1.1.
	 */
	private HttpVersion httpVersion = HttpVersion.HTTP_1_1;

	/**
	 * The character set for content sent and received through all HTTP requests. The default is
	 * "UTF-8"
	 */
	private String contentCharset = Constants.DEFAULT_ENCODING;

	/**
	 * The timeout until a connection is etablished. A value of zero means the timeout is not
	 * used. The default is 20.
	 */
	private int connectionTimeout = 20 * 1000;

	/**
	 * The default socket timeout in milliseconds which is the timeout for waiting for data. A
	 * timeout value of zero is interpreted as an infinite timeout.
	 */
	private int socketTimeout = 20 * 1000;

	/**
	 * Returns the HTTP version, as specified in RFC 2616, to be used for all HTTP requests.
	 * 
	 * @return HTTP version.
	 */
	public HttpVersion getHttpVersion() {
		return httpVersion;
	}

	/**
	 * Sets the HTTP version, as specified in RFC 2616, to be used for all HTTP requests.
	 * 
	 * @param httpVersion
	 */
	public void setHttpVersion(HttpVersion httpVersion) {
		this.httpVersion = httpVersion;
	}

	/**
	 * Returns the character set for content sent and received through all HTTP requests.
	 * 
	 * @return Character set string.
	 */
	public String getContentCharset() {
		return contentCharset;
	}

	/**
	 * Sets he character set for content sent and received through all HTTP requests.
	 * 
	 * @param contentCharset
	 */
	public void setContentCharset(String contentCharset) {
		this.contentCharset = contentCharset;
	}

	/**
	 * Gets the timeout until a connection is etablished. A value of zero means the timeout is not
	 * used.
	 * 
	 * @return The current timeout in milliseconds.
	 */
	public int getConnectionTimeout() {
		return connectionTimeout;
	}

	/**
	 * Sets the timeout until a connection is etablished. A value of zero means the timeout is not
	 * used.
	 * 
	 * @param connectionTimeout Timeout in milliseconds.
	 */
	public void setConnectionTimeout(int connectionTimeout) {
		this.connectionTimeout = connectionTimeout;
	}

	/**
	 * Returns the default user agent string
	 * 
	 * @return User agent.
	 */
	public static String getDefaultUserAgent() {
		return DEFAULT_USER_AGENT;
	}

	/**
	 * Gets the default socket timeout in milliseconds which is the timeout for waiting
	 * for data. A timeout value of zero is interpreted as an infinite timeout.
	 * 
	 * @return Socket timeout in milliseconds.
	 */
	public int getSocketTimeout() {
		return socketTimeout;
	}

	/**
	 * Sets the default socket timeout in milliseconds which is the timeout for waiting
	 * for data. A timeout value of zero is interpreted as an infinite timeout.
	 * 
	 * @param socketTimeout Socket timeout in milliseconds.
	 */
	public void setSocketTimeout(int socketTimeout) {
		this.socketTimeout = socketTimeout;
	}

	/**
	 * Returns the protocol (i.e. HTTP or HTTPS) to use when connecting to
	 * SafetyWeb Services.
	 * <p>
	 * The default configuration is to use HTTPS for all requests for increased security.
	 * <p>
	 * Individual clients can also override this setting by explicitly including the protocol as
	 * part of the endpoint URL when calling {@link SafetyWebClient#setEndpoint(String)}.
	 * 
	 * @return The protocol to use when connecting to SafetyWeb Services.
	 */
	public Protocol getProtocol() {
		return protocol;
	}

	/**
	 * Returns the HTTP user agent header to send with all requests.
	 * 
	 * @return The user agent string to use when sending requests.
	 */
	public String getUserAgent() {
		return userAgent;
	}

	/**
	 * Sets the protocol (i.e. HTTP or HTTPS) to use when connecting to
	 * SafetyWeb Services.
	 * <p>
	 * The default configuration is to use HTTPS for all requests for increased security.
	 * <p>
	 * Individual clients can also override this setting by explicitly including the protocol as
	 * part of the endpoint URL when calling {@link SafetyWebClient#setEndpoint(String)}.
	 * 
	 * @param protocol
	 *            The protocol to use when connecting to SafetyWeb Services.
	 */
	public void setProtocol(Protocol protocol) {
		this.protocol = protocol;
	}

	/**
	 * Sets the HTTP user agent header to send with all requests.
	 * 
	 * @param userAgent
	 *            The user agent string to use when sending requests.
	 */
	public void setUserAgent(String userAgent) {
		this.userAgent = userAgent;
	}

	/**
	 * Sets the protocol (i.e. HTTP or HTTPS) to use when connecting to SafetyWeb Services, and
	 * returns the updated ClientConfiguration object so that
	 * additional calls may be chained together.
	 * <p>
	 * The default configuration is to use HTTPS for all requests for increased security.
	 * <p>
	 * Individual clients can also override this setting by explicitly including the protocol as
	 * part of the endpoint URL when calling {@link SafetyWebClient#setEndpoint(String)}.
	 * 
	 * @param protocol
	 *            The protocol to use when connecting to SafetyWeb Services.
	 * 
	 * @return The updated ClientConfiguration object with the new max HTTP
	 *         connections setting.
	 */
	public ClientConfiguration withProtocol(Protocol protocol) {
		setProtocol(protocol);
		return this;
	}

	/**
	 * Sets the HTTP user agent header used in requests and returns the updated
	 * ClientConfiguration object.
	 * 
	 * @param userAgent
	 *            The user agent string to use when sending requests.
	 * 
	 * @return The updated ClientConfiguration object.
	 */
	public ClientConfiguration withUserAgent(String userAgent) {
		setUserAgent(userAgent);
		return this;
	}
}
