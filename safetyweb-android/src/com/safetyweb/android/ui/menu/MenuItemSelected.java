/*
 * MenuItem.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 16, 2010
 * Version: $Id: MenuItemSelected.java 1612 2010-07-19 18:09:12Z dan $
 */

package com.safetyweb.android.ui.menu;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.view.MenuItem;

import com.safetyweb.android.Constants;
import com.safetyweb.android.ui.LoginActivity;
import com.safetyweb.android.ui.R;
import com.safetyweb.android.ui.WebViewActivity;

/**
 * Class responsible for detemining what to do when a menu item is selected.
 * 
 * @author dhansen
 */
public class MenuItemSelected {

	private MenuItem menuItem;
	private Context packageContext;
	private Intent intent = null;
	private Intent broadcastIntent = null;
	private boolean menuItemRequiresFinish;

	public MenuItemSelected(MenuItem menuItem, Context packageContext) {
		this.menuItem = menuItem;
		this.packageContext = packageContext;

		createIntent();
	}

	private void createIntent() {
		Uri uri;

		switch (menuItem.getItemId()) {
			case R.id.mitLogout:
				// Finish all activities and forward to the Login Activity.
				broadcastIntent = new Intent(Constants.ACTION_LOGOUT);

				// 2010-07-15 dhansen Currently this URI is just a place holder.
				uri = Uri.parse("content://logout");
				intent = new Intent(Constants.ACTION_LOGOUT, uri, packageContext, LoginActivity.class);
				break;

			case R.id.mitExit:
				broadcastIntent = new Intent(Constants.ACTION_EXIT);
				break;

			case R.id.mitBlog:
				uri = Uri.parse(Constants.LINK_BLOG);
				intent = new Intent(Intent.ACTION_VIEW, uri, packageContext, WebViewActivity.class);
				break;

			case R.id.mitAbout:
				uri = Uri.parse(Constants.LINK_ABOUT);
				intent = new Intent(Intent.ACTION_VIEW, uri, packageContext, WebViewActivity.class);
				break;

			case R.id.mitPrivacy:
				uri = Uri.parse(Constants.LINK_PRIVACY);
				intent = new Intent(Intent.ACTION_VIEW, uri, packageContext, WebViewActivity.class);
				break;

			case R.id.mitTerms:
				uri = Uri.parse(Constants.LINK_TERMS);
				intent = new Intent(Intent.ACTION_VIEW, uri, packageContext, WebViewActivity.class);
				break;
		}
	}

	public Intent getIntent() {
		return intent;
	}

	public boolean hasIntent() {
		return intent != null;
	}

	public Intent getBroadcastIntent() {
		return broadcastIntent;
	}

	public boolean hasBroadcastIntent() {
		return broadcastIntent != null;
	}

	public boolean requiresFinish() {
		return menuItemRequiresFinish;
	}

}
