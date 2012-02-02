/*
 * SafetWebClient.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 6, 2010
 * Version: $Id: SafetyWebClient.java 1612 2010-07-19 18:09:12Z dan $
 */

package com.safetyweb.api;

import java.net.URI;
import java.net.URISyntaxException;
import java.security.SignatureException;
import java.util.List;

import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.JsonParseException;
import com.safetyweb.api.auth.ICredentials;
import com.safetyweb.api.auth.ISigner;
import com.safetyweb.api.auth.QueryStringSigner;
import com.safetyweb.api.http.DefaultRequest;
import com.safetyweb.api.http.IRequest;
import com.safetyweb.api.model.Account;
import com.safetyweb.api.model.ActivityCount;
import com.safetyweb.api.model.ActivityItem;
import com.safetyweb.api.model.Child;
import com.safetyweb.api.model.Response;

/**
 * SafetyWeb API high level client for end user access.
 * 
 * @author dhansen
 */
public class SafetyWebClient extends AbstractSafetyWebClient {

	/**
	 * The SafetyWeb credentials (access key ID and secret key) to use when
	 * authenticating with SafetyWeb services.
	 */
	private final ICredentials credentials;

	/**
	 * Used to sign the request before sending it to SafetyWeb.
	 */
	private final ISigner signer;

	/**
	 * Constructor for SafetWebClient that automatically handles HTTP client configuration.
	 * 
	 * @param credentials
	 */
	public SafetyWebClient(ICredentials credentials) {
		this(new ClientConfiguration(), credentials);
	}

	/**
	 * Constructor for SafetyWebClient that allows custom configuration of the HTTP client.
	 * 
	 * @param clientConfiguration
	 * @param credentials
	 */
	public SafetyWebClient(ClientConfiguration clientConfiguration, ICredentials credentials) {
		super(clientConfiguration);

		this.credentials = credentials;
		setEndpoint(Constants.API_ENDPOINT);

		signer = new QueryStringSigner(this.credentials);
	}

	/**
	 * Retrieves the counts of level activity for a child (ie number of info, positive, warning,
	 * redflag).
	 * 
	 * @param token Authentication token.
	 * @param childId The id of the child.
	 * @return List of {@link ActivityCount} objects for each activity level.
	 */
	public List<ActivityCount> activityCounts(String token, String childId) {
		IRequest request = createRequest("activity/counts/" + childId);
		request.addParameter("token", token);

		List<ActivityCount> activityCounts = null;

		Response json = fetchJSON(request);
		if (json != null && json.getResult() != null && json.getResult().equals("OK"))
			activityCounts = json.getActivity().getCount();

		return activityCounts;
	}

	/**
	 * Retrieves the details of a specific child's accounts.
	 * 
	 * @param token The authentication token.
	 * @param childId The id of the child.
	 * @return List of {@link ActivityCount} objects.
	 */
	public List<Account> childAccounts(String token, String childId) {
		IRequest request = createRequest("child/" + childId);
		request.addParameter("token", token);

		List<Account> activityCounts = null;

		Response json = fetchJSON(request);
		if (json != null && json.getResult() != null && json.getResult().equals("OK"))
			activityCounts = json.getAccounts().getAccount();

		return activityCounts;
	}

	/**
	 * Retrieves all of the activity for a child.
	 * 
	 * @param token Authentication token.
	 * @param childId The id of the child.
	 * @param offset Starting point for retrieving results (for pagination).
	 * @param count The number of results to return (for pagination).
	 * @return List of {@link ActivityItem} objects.
	 */
	public List<ActivityItem> childActivity(String token, String childId, int offset, int count) {
		IRequest request = createRequest("activity/" + childId);
		request.addParameter("token", token);
		request.addParameter("offset", Integer.toString(offset));
		request.addParameter("number", Integer.toString(count));

		List<ActivityItem> activity = null;

		Response json = fetchJSON(request);
		if (json != null && json.getResult() != null && json.getResult().equals("OK"))
			activity = json.getActivity().getItem();

		return activity;
	}

	/**
	 * Retrieves all children of a user identified by the token received after logging in.
	 * 
	 * @param token Authentication token
	 * @return List of {@link Child} objects.
	 */
	public List<Child> children(String token) {
		IRequest request = createRequest("children");
		request.addParameter("token", token);

		List<Child> children = null;

		Response response = fetchJSON(request);
		if (response != null && response.getResult() != null && response.getResult().equals("OK"))
			children = response.getChildren().getChild();

		return children;
	}

	private URI convertResourceToEndpoint(String resourcePath) {
		try {
			StringBuilder uri = new StringBuilder(endpoint.getScheme());
			uri.append("://");
			uri.append(endpoint.getAuthority());
			uri.append("/api/v");
			uri.append(Constants.API_VERSION);
			uri.append("/");
			uri.append(resourcePath);

			return new URI(uri.toString());
		}
		catch (URISyntaxException e) {
			throw new SafetyWebClientException("Can't turn API method name into a URI: " + e.getMessage(), e);
		}
	}

	private IRequest createRequest(String resourcePath) {
		DefaultRequest request = new DefaultRequest(convertResourceToEndpoint(resourcePath));
		request.addParameter("type", "json");
		request.setResourcePath(resourcePath);

		return request;
	}

	private Response fetchJSON(IRequest request) {
		Response json = null;

		try {
			signer.sign(request);
			String rawResponse = client.fetch(request);
			if (rawResponse != null) {
				rawResponse = rawResponseFilter(rawResponse);

				Gson gson = new Gson();
				json = gson.fromJson(rawResponse, Response.class);
			}
			else
				Log.w(getClass().getSimpleName(), "null response received for the request: " + request.toString());
		}
		catch (SignatureException e) {
			Log.e(getClass().getSimpleName(), "Failed to sign the request: " + request.toString(), e);
		}
		catch (JsonParseException e) {
			Log.e(getClass().getSimpleName(), "Error parsing JSON response for request: " + request.toString(), e);
		}

		return json;
	}

	/**
	 * This method is responsible for fixing inconsistencies in SafetyWeb's JSON responses that
	 * would otherwise not be parsable by GSON.
	 * 
	 * @param rawResponse
	 * @return The filtered raw response that should be parsable by GSON.
	 */
	private String rawResponseFilter(String rawResponse) {
		// Sometimes fields that are expected to be strings, but have no value are actually sent
		// back as empty objects instead of empty strings, but this breaks the parser which is
		// expecting to deserialize to strings.
		rawResponse = rawResponse.replace("{}", "\"\"");

		// SafetyWeb's API sends back single object for media if there is only one, but it will
		// send back an array if there is more. This functionality is not compatible with the
		// JSON deserialization process. It must always receive the same type to be
		// deserialized. Therefore we have this regex to always ensure an array of media objects
		// is in the JSON response before it's conversion to native Java objects.
		if (rawResponse.contains("medias"))
			rawResponse = rawResponse.replaceAll("(?msu)\"media\"\\s*:\\s*(\\{.*?\\})\\s*\\}", "\"media\":[$1]}");

		// Same issue as above with the media, but this is with the child value of children.
		if (rawResponse.contains("children"))
			rawResponse = rawResponse.replaceAll("(?msu)\"child\"\\s*:\\s*(\\{.*?\\})\\s*\\}", "\"child\":[$1]}");

		return rawResponse;
	}

	/**
	 * Attempts to authenticate a user for accessing the SafetyWeb API.
	 * 
	 * @param username
	 * @param password
	 * @return The authentication token.
	 * @throws SafetyWebClientException
	 */
	public String login(String username, String password) throws SafetyWebClientException {
		IRequest request = createRequest("login");
		request.addParameter("username", username);
		request.addParameter("password", password);

		String token = null;

		Response json = fetchJSON(request);
		if (json != null && json.getResult() != null && json.getResult().equals("OK"))
			token = json.getToken();

		return token;
	}

	/**
	 * Determines if the API is available, working, and the credentials are valid.
	 * 
	 * @return Was the ping successful?
	 */
	public boolean ping() {
		IRequest request = createRequest("ping");
		boolean success = false;

		Response json = fetchJSON(request);
		if (json != null && json.getResult() != null && json.getResult().equals("OK"))
			success = true;

		return success;
	}

}
