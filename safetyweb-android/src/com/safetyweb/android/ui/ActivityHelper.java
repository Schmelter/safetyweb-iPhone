/*
 * ActivityHelper.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 16, 2010
 * Version: $Id: ActivityHelper.java 1614 2010-07-19 18:45:27Z dan $
 */

package com.safetyweb.android.ui;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.util.Log;
import android.view.MenuItem;

import com.safetyweb.android.Constants;
import com.safetyweb.android.ui.menu.MenuItemSelected;

/**
 * Aggregate class for Activities to allow sharing logic between them with out extending the same
 * class since some of them may not be able to do that with Java not allowing multiple inheritance.
 * 
 * @author dhansen
 */
public class ActivityHelper {

	Activity activity;

	BroadcastReceiver logoutReceiver = null;
	BroadcastReceiver exitReceiver = null;

	public ActivityHelper(Activity activity) {
		this.activity = activity;
	}

	public boolean onOptionsItemSelected(MenuItem menuItem) {
		boolean result = false;

		MenuItemSelected menuItemSelected = new MenuItemSelected(menuItem, activity);
		if (menuItemSelected.hasBroadcastIntent()) {
			activity.sendBroadcast(menuItemSelected.getBroadcastIntent());
			result = true;
		}

		if (menuItemSelected.hasIntent()) {
			activity.startActivity(menuItemSelected.getIntent());
			result = true;
		}

		if (menuItemSelected.requiresFinish())
			activity.finish();

		return result;
	}

	public void registerLogoutReceiver() {
		IntentFilter intentFilter = new IntentFilter();
		intentFilter.addAction(Constants.ACTION_LOGOUT);

		logoutReceiver = new BroadcastReceiver() {
			@Override
			public void onReceive(Context context, Intent intent) {
				Log.d(activity.getClass().getSimpleName(), "Logout in progress");
				unregisterReceivers();
				activity.finish();
			}
		};

		activity.registerReceiver(logoutReceiver, intentFilter);
	}

	public void registerExitReceiver() {
		IntentFilter intentFilter = new IntentFilter();
		intentFilter.addAction(Constants.ACTION_EXIT);

		exitReceiver = new BroadcastReceiver() {
			@Override
			public void onReceive(Context context, Intent intent) {
				Log.d(activity.getClass().getSimpleName(), "Exit in progress");
				unregisterReceivers();
				activity.finish();
			}
		};

		activity.registerReceiver(exitReceiver, intentFilter);
	}

	public void unregisterReceivers() {
		if (exitReceiver != null) {
			activity.unregisterReceiver(exitReceiver);
			exitReceiver = null;
		}
		if (logoutReceiver != null) {
			activity.unregisterReceiver(logoutReceiver);
			logoutReceiver = null;
		}
	}

}
