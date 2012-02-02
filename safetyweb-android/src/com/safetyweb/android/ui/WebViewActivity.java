/*
 * WebViewActivity.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 10, 2010
 * Version: $Id: WebViewActivity.java 1612 2010-07-19 18:09:12Z dan $
 */

package com.safetyweb.android.ui;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.view.MenuInflater;
import android.webkit.WebView;

/**
 * Activity class responsible for rendering external web pages mostly likely at www.safetyweb.com.
 * 
 * @author Rob
 */
public class WebViewActivity extends Activity {

	private ActivityHelper activityHelper;
	private WebView wbvBrowser;

	@Override
	public boolean onCreateOptionsMenu(android.view.Menu menu) {
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.icon_menu, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(android.view.MenuItem menuItem) {
		boolean result = activityHelper.onOptionsItemSelected(menuItem);
		finish();
		return result;
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.web_view);

		activityHelper = new ActivityHelper(this);

		Uri uri = getIntent().getData();
		wbvBrowser = (WebView) findViewById(R.id.wbvBrowser);
		wbvBrowser.getSettings().setJavaScriptEnabled(true);
		wbvBrowser.loadUrl(uri.toString());
	}

}
