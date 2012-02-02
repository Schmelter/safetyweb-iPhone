/*
 * ChildrenActivity.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 6, 2010
 * Version: $Id: ChildrenActivity.java 1637 2010-07-20 23:04:17Z dan $
 */
package com.safetyweb.android.ui;

import java.util.ArrayList;

import android.app.ListActivity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.AsyncTask.Status;
import android.util.Log;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.safetyweb.android.Constants;
import com.safetyweb.android.ui.util.DrawableManager;
import com.safetyweb.api.SafetyWebClient;
import com.safetyweb.api.auth.BasicCredentials;
import com.safetyweb.api.model.ActivityCount;
import com.safetyweb.api.model.ActivityLevel;
import com.safetyweb.api.model.Child;

public class ChildrenActivity extends ListActivity {

	private ActivityHelper activityHelper;
	private SafetyWebClient client;
	private final DrawableManager drawableManager = new DrawableManager();
	private GetChildrenTask getChildrenTask = null;
	private ArrayList<Child> model;
	private ProgressDialog progressDialog = null;

	private String token;

	@Override
	public Object onRetainNonConfigurationInstance() {
		return model;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.children);

		init();

		model = (ArrayList<Child>) getLastNonConfigurationInstance();
		if (model == null) {
			getChildrenTask = new GetChildrenTask();
			getChildrenTask.execute();
		}
		else
			setListAdapter(new ChildrenListAdapter(this, R.layout.child_row, model));
	}

	@Override
	protected void onPause() {
		super.onPause();

		if (progressDialog != null && progressDialog.isShowing())
			progressDialog.dismiss();

		if (getChildrenTask != null && getChildrenTask.getStatus() != Status.FINISHED)
			getChildrenTask.cancel(true);
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		activityHelper.unregisterReceivers();
	}

	@Override
	public boolean onCreateOptionsMenu(android.view.Menu menu) {
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.icon_menu, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(android.view.MenuItem menuItem) {
		return activityHelper.onOptionsItemSelected(menuItem);
	}

	private void init() {
		activityHelper = new ActivityHelper(this);
		activityHelper.registerLogoutReceiver();
		activityHelper.registerExitReceiver();

		BasicCredentials credentials = new BasicCredentials(Constants.API_ID, Constants.API_KEY);
		client = new SafetyWebClient(credentials);
		token = getIntent().getExtras().getString(Constants.EXTRA_LOGIN_TOKEN);
	}

	@Override
	public void onListItemClick(ListView l, View v, int position, long id) {
		Child child = (Child) l.getItemAtPosition(position);

		Intent intent = new Intent(ChildrenActivity.this, ChildDetailActivity.class);
		intent.putExtra(Constants.EXTRA_LOGIN_TOKEN, token);
		intent.putExtra(Constants.EXTRA_CHILD_ID, child.getChild_id());
		startActivity(intent);
	}

	private class ChildrenListAdapter extends ArrayAdapter<Child> {

		public ChildrenListAdapter(Context context, int textViewResourceId, ArrayList<Child> items) {
			super(context, textViewResourceId, items);
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			View row = convertView;
			ChildWrapper wrapper = null;

			if (row == null) {
				row = getLayoutInflater().inflate(R.layout.child_row, null);
				wrapper = new ChildWrapper(row);
				row.setTag(wrapper);
			}
			else {
				wrapper = (ChildWrapper) row.getTag();

				if (wrapper == null) {
					wrapper = new ChildWrapper(row);
					row.setTag(wrapper);
				}
			}

			wrapper.populateFrom(getItem(position));

			return row;
		}
	}

	private class ChildWrapper {

		private View row;

		public ChildWrapper(View row) {
			this.row = row;
		}

		public void populateFrom(Child child) {
			buildImgProfilePic(child);
			buildTxtRealName(child);
			buildTxtActivityLevel(child);
		}

		private void buildImgProfilePic(Child c) {
			ImageView imageView = (ImageView) row.findViewById(R.id.imgProfilePic);

			if (c.hasProfilePic())
				drawableManager.fetchDrawableAsync(c.getProfile_pic(), imageView, R.drawable.default_profile);
			else
				imageView.setImageResource(R.drawable.default_profile);
		}

		private void buildTxtRealName(Child c) {
			TextView tvRealName = (TextView) row.findViewById(R.id.txtRealName);
			if (tvRealName != null)
				tvRealName.setText(c.getFirst_name() + " " + c.getLast_name());
		}

		private void buildTxtActivityLevel(Child c) {
			int referenceId = 0;
			for (ActivityCount activityCount : c.getActivityCounts()) {
				ActivityLevel al = ActivityLevel.get(activityCount.getLevel_id());
				switch (al) {
					case POSITIVE:
						referenceId = R.id.txtPositive;
						break;

					case WARNING:
						referenceId = R.id.txtWarning;
						break;

					case REDFLAG:
						referenceId = R.id.txtRedflag;
						break;
				}

				if (referenceId != 0) {
					TextView tvActivityLevel = (TextView) row.findViewById(referenceId);
					if (tvActivityLevel != null)
						tvActivityLevel.setText(activityCount.getTotal());
				}
			}
		}
	}

	private class GetChildrenTask extends AsyncTask<Void, Void, Void> {

		private ArrayList<Child> children = null;

		@Override
		protected Void doInBackground(Void... params) {
			try {
				children = new ArrayList<Child>(client.children(token));

				for (Child child : children)
					child.setActivityCounts(client.activityCounts(token, child.getChild_id()));
			}
			catch (Exception e) {
				Log.e(getClass().getSimpleName(), "Unable to load children", e);
			}

			return null;
		}

		@Override
		protected void onPreExecute() {
			progressDialog = ProgressDialog.show(ChildrenActivity.this, getString(R.string.please_wait),
				getString(R.string.retrieving_data), true);
		}

		@Override
		protected void onPostExecute(Void param) {
			progressDialog.dismiss();

			if (children != null) {
				model = children;
				setListAdapter(new ChildrenListAdapter(ChildrenActivity.this, R.layout.child_row, model));
			}
		}
	}

}
