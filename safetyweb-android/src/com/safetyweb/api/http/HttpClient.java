/*
 * HttpClient.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 6, 2010
 * Version: $Id: HttpClient.java 1612 2010-07-19 18:09:12Z dan $
 */

package com.safetyweb.api.http;

import java.io.IOException;

import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.conn.ClientConnectionManager;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.apache.http.params.HttpProtocolParams;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.util.Log;

import com.safetyweb.api.ClientConfiguration;

/**
 * Internal HTTP client class for using by the higher level SafetyWeb client implementations.
 * 
 * @author dhansen
 */
public class HttpClient {

	private final DefaultHttpClient httpClient;

	public HttpClient(ClientConfiguration clientConfiguration) {
		final HttpParams params = new BasicHttpParams();

		HttpProtocolParams.setUserAgent(params, clientConfiguration.getUserAgent());
		HttpProtocolParams.setVersion(params, clientConfiguration.getHttpVersion());
		HttpProtocolParams.setContentCharset(params, clientConfiguration.getContentCharset());

		HttpConnectionParams.setStaleCheckingEnabled(params, false);
		HttpConnectionParams.setConnectionTimeout(params, clientConfiguration.getConnectionTimeout());
		HttpConnectionParams.setSoTimeout(params, clientConfiguration.getSocketTimeout());
		HttpConnectionParams.setSocketBufferSize(params, 8192);

		SchemeRegistry schemeRegistry = new SchemeRegistry();
		schemeRegistry.register(new Scheme("http", PlainSocketFactory.getSocketFactory(), 80));
		schemeRegistry.register(new Scheme("https", SSLSocketFactory.getSocketFactory(), 443));

		ClientConnectionManager manager = new ThreadSafeClientConnManager(params, schemeRegistry);
		httpClient = new DefaultHttpClient(manager, params);
	}

	public String fetch(IRequest request) {
		return fetch(request.toStringUrl());
	}

	public String fetch(String url) {
		String body = null;
		HttpGet get = new HttpGet(url);

		try {
			ResponseHandler<String> handler = new BasicResponseHandler();
			body = httpClient.execute(get, handler);
		}
		catch (ClientProtocolException e) {
			Log.e(getClass().getSimpleName(), "Unable to fetch url: " + url, e);
		}
		catch (IOException e) {
			Log.e(getClass().getSimpleName(), "Unable to fetch url: " + url, e);
		}

		return body;
	}

	public JSONObject fetchJSON(IRequest request) throws JSONException {
		String body = fetch(request);
		return (JSONObject) new JSONTokener(body).nextValue();
	}

}
