/*
 * QueryStringSigner.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 6, 2010
 * Version: $Id: QueryStringSigner.java 1612 2010-07-19 18:09:12Z dan $
 */

package com.safetyweb.api.auth;

import java.net.URI;
import java.security.SignatureException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;
import java.util.TimeZone;
import java.util.TreeMap;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;

import android.util.Log;

import com.safetyweb.api.Constants;
import com.safetyweb.api.http.IRequest;
import com.safetyweb.api.util.HttpUtils;

/**
 * Signer implementation responsible for signing a SafetyWeb query string request
 * according to the various signature versions and hashing algorithms.
 * 
 * @author dhansen
 */
public class QueryStringSigner implements ISigner {

	/**
	 * SafetyWeb Credentials
	 */
	private final ICredentials credentials;

	/**
	 * Constructs a new QueryStringSigner to sign requests based on the
	 * specified service endpoint (ex: "www.safetyweb.com") and SafetyWeb secret access
	 * key.
	 * 
	 * @param credentials Credentials
	 */
	public QueryStringSigner(ICredentials credentials) {
		this.credentials = credentials;
	}

	/**
	 * Calculate string to sign for signature version 1.
	 * 
	 * @param parameters request parameters
	 * @return String to sign
	 * @throws SignatureException If the string to sign cannot be calculated.
	 */
	private String calculateStringToSignV1(URI endpoint, Map<String, String> parameters) throws SignatureException {
		StringBuilder data = new StringBuilder();
		data.append("GET");
		data.append("\n");
		data.append(endpoint.getHost().toLowerCase());
		/*
		 * Apache HttpClient will omit the port in the Host header for default
		 * port values (i.e. 80 for HTTP and 443 for HTTPS) even if we
		 * explicitly specify it, so we need to be careful that we use the same
		 * value here when we calculate the string to sign and in the Host
		 * header we send in the HTTP request.
		 */
		if (HttpUtils.isUsingNonDefaultPort(endpoint))
			data.append(":" + endpoint.getPort());
		data.append("\n");
		String uri = endpoint.getPath();
		if (uri == null || uri.length() == 0)
			uri = "/";
		data.append(HttpUtils.urlEncode(uri, true));
		data.append("\n");
		Map<String, String> sorted = new TreeMap<String, String>();
		sorted.putAll(parameters);

		Iterator<Map.Entry<String, String>> pairs = sorted.entrySet().iterator();
		while (pairs.hasNext()) {
			Map.Entry<String, String> pair = pairs.next();
			String key = pair.getKey();
			String value = pair.getValue();
			data.append(HttpUtils.urlEncode(key, false));
			data.append("=");
			data.append(HttpUtils.urlEncode(value, false));
			if (pairs.hasNext())
				data.append("&");
		}
		return data.toString();
	}

	/**
	 * Formats date as ISO 8601 timestamp.
	 */
	private String getFormattedTimestamp() {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
		df.setTimeZone(TimeZone.getTimeZone("UTC"));
		return df.format(new Date());
	}

	/**
	 * This signer will add "Signature" parameter to the request. Default
	 * signature version is "1" and default signing algorithm is "HmacSHA256".
	 * 
	 * AccessKeyId SignatureVersion SignatureMethod Timestamp Signature
	 * 
	 * @param request request to be signed.
	 * 
	 * @throws SignatureException
	 */
	public void sign(IRequest request) throws SignatureException {
		sign(request, SignatureVersion.V1, SigningAlgorithm.HmacSHA256);
	}

	/**
	 * This signer will add following authentication parameters to the request:
	 * 
	 * AccessKeyId SignatureVersion SignatureMethod Timestamp Signature
	 * 
	 * @param request request to be signed.
	 * @param version signature version. "1" is recommended.
	 * @param algorithm signature algorithm. "HmacSHA256" is recommended.
	 * @throws SignatureException
	 */
	public void sign(IRequest request, SignatureVersion version, SigningAlgorithm algorithm) throws SignatureException {
		request.addParameter("api_id", credentials.getAccessKeyId());
		request.addParameter("timestamp", getFormattedTimestamp());

		String stringToSign = null;

		if (version.equals(SignatureVersion.V1))
			stringToSign = calculateStringToSignV1(request.getEndpoint(), request.getParameters());
		else
			throw new SignatureException("Invalid Signature Version specified");

		String signatureValue = sign(stringToSign, credentials.getSecretKey(), algorithm);
		Log.w("<-----To Sign----->", stringToSign);
		request.addParameter("signature", signatureValue);
	}

	/**
	 * Computes RFC 2104-compliant HMAC signature.
	 */
	private String sign(String data, String key, SigningAlgorithm algorithm) throws SignatureException {
		try {
			Mac mac = Mac.getInstance(algorithm.toString());
			mac.init(new SecretKeySpec(key.getBytes(), algorithm.toString()));
			byte[] signature = Base64.encodeBase64(mac.doFinal(data.getBytes(Constants.DEFAULT_ENCODING)));
			return new String(signature);
		}
		catch (Exception e) {
			throw new SignatureException("Failed to generate signature: " + e.getMessage(), e);
		}
	}

}
