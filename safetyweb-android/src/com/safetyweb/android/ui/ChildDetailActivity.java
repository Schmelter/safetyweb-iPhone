/*
 * ChildDetailActivity.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 6, 2010
 * Version: $Id: ChildDetailActivity.java 1670 2010-07-23 21:55:38Z dan $
 */
package com.safetyweb.android.ui;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import android.app.ListActivity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.res.Resources;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import com.commonsware.cwac.endless.EndlessAdapter;
import com.ocpsoft.pretty.time.PrettyTime;
import com.safetyweb.android.Constants;
import com.safetyweb.android.ui.util.DrawableManager;
import com.safetyweb.android.ui.util.ResourceUtil;
import com.safetyweb.api.SafetyWebClient;
import com.safetyweb.api.auth.BasicCredentials;
import com.safetyweb.api.model.ActivityItem;
import com.safetyweb.api.model.Media;
import com.safetyweb.api.model.Medias;

public class ChildDetailActivity extends ListActivity {

	private static final int RESULTS_PER_PAGE = 20;

	private ActivityHelper activityHelper;
	private SafetyWebClient client;
	private final DrawableManager drawableManager = new DrawableManager();
	private ArrayList<ActivityItem> model;
	private ProgressDialog progressDialog = null;

	private String childId;
	private int offset = 0;
	private String token;

	@Override
	public Object onRetainNonConfigurationInstance() {
		return model;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.child_detail);

		loadActivityHelper();
		loadExtras();
		loadClient();

		model = (ArrayList<ActivityItem>) getLastNonConfigurationInstance();
		if (model == null) {
			GetChildDetail getChildDetail = new GetChildDetail();
			getChildDetail.execute(client, token, childId);
		}
		else {
			offset += model.size();
			setListAdapter(new ChildDetailEndlessAdapter(client, token, childId, model));
		}
	}

	@Override
	protected void onPause() {
		super.onPause();

		if (progressDialog != null && progressDialog.isShowing())
			progressDialog.dismiss();
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		activityHelper.unregisterReceivers();
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.icon_menu, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem menuItem) {
		return activityHelper.onOptionsItemSelected(menuItem);
	}

	private void loadActivityHelper() {
		activityHelper = new ActivityHelper(this);
		activityHelper.registerLogoutReceiver();
		activityHelper.registerExitReceiver();
	}

	private void loadClient() {
		BasicCredentials credentials = new BasicCredentials(Constants.API_ID, Constants.API_KEY);
		client = new SafetyWebClient(credentials);
	}

	private void loadExtras() {
		Bundle extras = getIntent().getExtras();
		token = extras.getString(Constants.EXTRA_LOGIN_TOKEN);
		childId = extras.getString(Constants.EXTRA_CHILD_ID);
	}

	private class GetChildDetail extends AsyncTask<Object, Void, Void> {

		private SafetyWebClient client;
		private String childId;
		private String token;

		@Override
		protected Void doInBackground(Object... params) {
			client = (SafetyWebClient) params[0];
			token = (String) params[1];
			childId = (String) params[2];
			List<ActivityItem> activityItems = client.childActivity(token, childId, offset, RESULTS_PER_PAGE);
			if (activityItems != null)
				model = new ArrayList<ActivityItem>(activityItems);
			return null;
		}

		@Override
		protected void onPreExecute() {
			progressDialog = ProgressDialog.show(ChildDetailActivity.this, getString(R.string.please_wait),
				getString(R.string.retrieving_data), true);
		}

		@Override
		protected void onPostExecute(Void param) {
			progressDialog.dismiss();

			if (model != null) {
				offset += model.size();
				setListAdapter(new ChildDetailEndlessAdapter(client, token, childId, model));
			}
		}
	}

	private class ChildDetailEndlessAdapter extends EndlessAdapter {

		private ArrayList<ActivityItem> activities = null;
		private SafetyWebClient client;
		private String childId;
		private String token;

		ChildDetailEndlessAdapter(SafetyWebClient client, String token, String childId, ArrayList<ActivityItem> items) {
			super(new ChildDetailAdapter(ChildDetailActivity.this, R.layout.child_detail_row, items));
			this.activities = items;
			this.client = client;
			this.childId = childId;
			this.token = token;
		}

		@SuppressWarnings("unchecked")
		@Override
		protected void appendCachedData() {
			ArrayAdapter<ActivityItem> a = (ArrayAdapter<ActivityItem>) getWrappedAdapter();

			if (activities != null)
				for (ActivityItem item : activities)
					a.add(item);
		}

		@Override
		protected boolean cacheInBackground() {
			List<ActivityItem> activityItems = client.childActivity(token, childId, offset, RESULTS_PER_PAGE);
			if (activityItems != null) {
				offset += activities.size();
				activities = new ArrayList<ActivityItem>(activityItems);
			}
			else
				activities = null;

			return activities == null || activities.size() < RESULTS_PER_PAGE ? false : true;
		}

		@Override
		protected View getPendingView(ViewGroup parent) {
			View row = getLayoutInflater().inflate(R.layout.child_detail_row, null);

			View child = row.findViewById(R.id.llytChildDetailRow);
			child.setVisibility(View.GONE);

			child = row.findViewById(R.id.llytLoading);
			child.setVisibility(View.VISIBLE);

			return row;
		}

		@Override
		protected void rebindPendingView(int position, View row) {
			View child = row.findViewById(R.id.llytChildDetailRow);
			child.setVisibility(View.VISIBLE);

			View loading = row.findViewById(R.id.llytLoading);
			loading.setVisibility(View.GONE);
			loading.clearAnimation();
		}
	}

	private class ChildDetailAdapter extends ArrayAdapter<ActivityItem> {
		public ChildDetailAdapter(Context context, int textViewResourceId, ArrayList<ActivityItem> items) {
			super(context, textViewResourceId, items);
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			View row = convertView;
			ActivityItemWrapper wrapper = null;

			if (row == null) {
				row = getLayoutInflater().inflate(R.layout.child_detail_row, null);
				wrapper = new ActivityItemWrapper(row);
				row.setTag(wrapper);
			}
			else {
				wrapper = (ActivityItemWrapper) row.getTag();

				if (wrapper == null) {
					wrapper = new ActivityItemWrapper(row);
					row.setTag(wrapper);
				}
			}

			wrapper.populateFrom(getItem(position));

			return row;
		}
	}

	private class ActivityItemWrapper {

		private View row;

		private TextView txtDescription = null;
		private ImageView imgServiceIcon = null;
		private TextView txtDate = null;
		private FrameLayout flytActivityLevel = null;
		private ImageView imgActivityLevel = null;
		private Map<Integer, ImageView> imgPhotos = new HashMap<Integer, ImageView>();
		Resources res = getResources();

		public ActivityItemWrapper(View row) {
			this.row = row;
		}

		public void populateFrom(ActivityItem activityItem) {
			buildDescriptionText(activityItem);
			buildDateText(activityItem);
			buildActivityLevelFrame(activityItem);
			buildActivityLevelImage(activityItem);
			buildImageList(activityItem);
			buildServiceIcon(activityItem);
		}

		private void buildDescriptionText(ActivityItem activity) {
			TextView description = getTxtDescription();
			if (description != null)
				description.setText(activity.getDescription());
		}

		private void buildServiceIcon(ActivityItem activity) {
			ImageView serviceIcon = getImgServiceIcon();
			if (serviceIcon != null) {
				int iconId = ResourceUtil.serviceProviderToDrawableId(activity.getService_id());
				if (iconId != R.drawable.transparent)
					serviceIcon.setImageResource(iconId);
				else {
					// We don't have the service image locally so attempt to load it from the web.
					String iconUrl = ResourceUtil.serviceProviderIconUrl(activity.getService());
					drawableManager.fetchDrawableAsync(iconUrl, serviceIcon, R.drawable.transparent);
				}
			}
		}

		private void buildDateText(ActivityItem activity) {
			TextView txtDate = getTxtDate();
			if (txtDate != null) {
				String date = activity.getActivity_date();

				try {
					DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
					df.setTimeZone(TimeZone.getTimeZone("UTC"));
					Date d = df.parse(activity.getActivity_date());
					PrettyTime p = new PrettyTime();
					date = p.format(d);
				}
				catch (ParseException e) {
					Log.e(getClass().getSimpleName(), "Unable to parse date", e);
				}

				txtDate.setText(date);
			}
		}

		private void buildActivityLevelFrame(ActivityItem activity) {
			FrameLayout flytActivityLevel = getFlytActivityLevel();
			if (flytActivityLevel != null) {
				int color = res.getColor(ResourceUtil.activityLevelToColorId(activity.getLevel_id()));
				flytActivityLevel.setBackgroundColor(color);
			}
		}

		private void buildActivityLevelImage(ActivityItem activity) {
			ImageView imgActivityLevel = getImgActivityLevel();
			if (imgActivityLevel != null) {
				int resId = ResourceUtil.activityLevelToDrawableId(activity.getLevel_id());
				imgActivityLevel.setImageResource(resId);
			}
		}

		private void buildImageList(ActivityItem activity) {
			int countDrawablesFetched = 0;

			int[] imageResourceIds = new int[3];
			imageResourceIds[0] = R.id.imgOne;
			imageResourceIds[1] = R.id.imgTwo;
			imageResourceIds[2] = R.id.imgThree;

			Medias medias = activity.getMedias();
			if (medias != null) {
				List<Media> mediaList = medias.getMedia();
				if (mediaList != null && !mediaList.isEmpty())
					for (Media media : mediaList) {
						String type = media.getType();
						String url = media.getThumbnail();

						if (type != null && type.equals("image") && url != null && !url.equals("")) {
							ImageView imageView = getImage(imageResourceIds[countDrawablesFetched]);
							if (imageView != null)
								drawableManager.fetchDrawableAsync(url, imageView, R.drawable.loader);

							++countDrawablesFetched;
						}

						if (countDrawablesFetched == imageResourceIds.length)
							break;
					}
			}

			// For each imageView that wasn't replaced to with a fetched drawable we need to make
			// sure it is blank or else it may display a previously fetched image from another row
			// do to the listView recycling issues we're having.
			for (int i = countDrawablesFetched; i < imageResourceIds.length; i++) {
				ImageView imageView = getImage(imageResourceIds[i]);
				if (imageView != null)
					imageView.setImageResource(R.drawable.transparent);
			}
		}

		private TextView getTxtDescription() {
			if (txtDescription == null)
				txtDescription = (TextView) row.findViewById(R.id.txtDescription);

			return txtDescription;
		}

		private ImageView getImgServiceIcon() {
			if (imgServiceIcon == null)
				imgServiceIcon = (ImageView) row.findViewById(R.id.imgServiceIcon);

			return imgServiceIcon;
		}

		private TextView getTxtDate() {
			if (txtDate == null)
				txtDate = (TextView) row.findViewById(R.id.txtDate);

			return txtDate;
		}

		private FrameLayout getFlytActivityLevel() {
			if (flytActivityLevel == null)
				flytActivityLevel = (FrameLayout) row.findViewById(R.id.flytActivityLevel);

			return flytActivityLevel;
		}

		private ImageView getImgActivityLevel() {
			if (imgActivityLevel == null)
				imgActivityLevel = (ImageView) row.findViewById(R.id.imgActivityLevel);

			return imgActivityLevel;
		}

		private ImageView getImage(int imageResourceId) {
			Integer key = new Integer(imageResourceId);
			ImageView foundImage = null;

			if (!imgPhotos.containsKey(key)) {
				ImageView image = (ImageView) row.findViewById(imageResourceId);

				if (image != null) {
					foundImage = image;
					imgPhotos.put(key, image);
				}
			}
			else
				foundImage = imgPhotos.get(key);

			return foundImage;
		}
	}
}
