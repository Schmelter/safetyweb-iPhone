/*
 * Constants.java
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

package com.safetyweb.android;

/**
 * Android application constants.
 * 
 * @author dhansen
 */
public class Constants {

	public static final String API_ID = "59a0466d76db208dd32aa70ed2ee370c";
	public static final String API_KEY = "8ec1ec06a517b5ac3b8ff942f859f91957314681";

	public static final String EXTRA_LOGIN_TOKEN = "com.safetyweb.app.LoginToken";
	public static final String EXTRA_CHILD_ID = "com.safetyweb.app.ChildId";

	public static final String LINK_LEARN_MORE = "http://www.safetyweb.com/iphoneoffer";
	public static final String LINK_BLOG = "http://blog.safetyweb.com";
	public static final String LINK_ABOUT = "http://www.safetyweb.com/about";
	public static final String LINK_PRIVACY = "http://www.safetyweb.com/privacy";
	public static final String LINK_TERMS = "http://www.safetyweb.com/terms";

	public static final String PREFERENCE_REMEMBER_ME = "rememberMe";
	public static final String PREFERENCE_USERNAME = "username";
	public static final String PREFERENCE_PASSWORD = "password";
	public static final String PREFERENCE_TOKEN = "token";
	public static final String PREFERENCE_TOKEN_MILLISECONDS = "tokenMilliseconds";

	public static final String ACTION_LOGOUT = "com.safetyweb.app.ACTION_LOGOUT";
	public static final String ACTION_EXIT = "com.safetyweb.app.ACTION_EXIT";

	public static final String URL_SERVICE_ICON_DIR = "http://www.safetyweb.com/i/icons/favicons";

	/**
	 * The SafetyWeb API doc claims the token is good for 12 hours. Setting it to less here to make
	 * sure the user is forced to get a new token before it expires. This way the expiration doesn't
	 * happen while they're using the app.
	 */
	public static final long TOKEN_EXPIRE_AGE_MILLISECONDS = 60 * 60 * 8 * 1000; // 8 hours

	/**
	 * Private default constructor prevents this class from being instantiated.
	 */
	private Constants() {
	}

}
