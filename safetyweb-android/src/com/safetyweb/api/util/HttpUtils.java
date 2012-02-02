/*
 * HttpUtils.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 6, 2010
 * Version: $Id: HttpUtils.java 1612 2010-07-19 18:09:12Z dan $
 */

package com.safetyweb.api.util;

import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URLEncoder;

import com.safetyweb.api.Constants;

/**
 * Various Http related utilities for convenience.
 * 
 * @author dhansen
 */
public class HttpUtils {

	/**
	 * Returns true if the specified URI is using a non-standard port (i.e. any
	 * port other than 80 for HTTP URIs or any port other than 443 for HTTPS
	 * URIs).
	 * 
	 * @param uri
	 * 
	 * @return True if the specified URI is using a non-standard port, otherwise
	 *         false.
	 */
	public static boolean isUsingNonDefaultPort(URI uri) {
		String scheme = uri.getScheme().toLowerCase();
		int port = uri.getPort();

		if (port <= 0)
			return false;
		if (scheme.equals("http") && port == 80)
			return false;
		if (scheme.equals("https") && port == 443)
			return false;

		return true;
	}

	public static String urlEncode(String value, boolean path) {
		try {
			String encoded = URLEncoder.encode(value, Constants.DEFAULT_ENCODING).replace("+", "%20").replace("*", "%2A")
				.replace("%7E", "~");

			if (path)
				encoded = encoded.replace("%2F", "/");

			return encoded;
		}
		catch (UnsupportedEncodingException ex) {
			throw new RuntimeException(ex);
		}
	}

}
