/*
 * ResourceUtil.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 8, 2010
 * Version: $Id: ResourceUtil.java 1670 2010-07-23 21:55:38Z dan $
 */

package com.safetyweb.android.ui.util;

import java.util.HashMap;
import java.util.Map;

import com.safetyweb.android.Constants;
import com.safetyweb.android.ui.R;
import com.safetyweb.api.model.ActivityLevel;

/**
 * Utility methods for retrieving information about Android application resources.
 * 
 * @author dhansen
 */
public class ResourceUtil {

	/**
	 * Private constructor for static class.
	 */
	private ResourceUtil() {
	}

	public static int activityLevelToDrawableId(String activityLevelId) {
		int referenceId;

		ActivityLevel al = ActivityLevel.get(activityLevelId);
		switch (al) {
			case POSITIVE:
				referenceId = R.drawable.positive;
				break;

			case WARNING:
				referenceId = R.drawable.warning;
				break;

			case REDFLAG:
				referenceId = R.drawable.redflag;
				break;

			case INFO:
				referenceId = R.drawable.info;
				break;

			default:
				referenceId = R.drawable.info;
		}

		return referenceId;
	}

	public static int activityLevelToColorId(String activityLevelId) {
		int color;

		ActivityLevel al = ActivityLevel.get(activityLevelId);
		switch (al) {
			case POSITIVE:
				color = R.color.level_positive;
				break;

			case WARNING:
				color = R.color.level_warning;
				break;

			case REDFLAG:
				color = R.color.level_redflag;
				break;

			case INFO:
				color = R.color.level_info;
				break;

			default:
				color = R.color.level_unknown;
		}

		return color;
	}

	public static int serviceProviderToDrawableId(String serviceProviderId) {
		int drawableId = R.drawable.transparent;
		if (serviceProviderMapping.containsKey(serviceProviderId))
			drawableId = serviceProviderMapping.get(serviceProviderId).intValue();

		return drawableId;
	}

	private static Map<String, Integer> serviceProviderMapping;
	static {
		serviceProviderMapping = new HashMap<String, Integer>();
		serviceProviderMapping.put("1", R.drawable.favicon_myspace);
		serviceProviderMapping.put("2", R.drawable.favicon_photobucket);
		serviceProviderMapping.put("3", R.drawable.favicon_gravatar);
		serviceProviderMapping.put("4", R.drawable.favicon_flickr);
		serviceProviderMapping.put("5", R.drawable.favicon_twitter);
		serviceProviderMapping.put("6", R.drawable.favicon_hi5);
		serviceProviderMapping.put("7", R.drawable.favicon_facebook);
		serviceProviderMapping.put("8", R.drawable.favicon_bebo);
		serviceProviderMapping.put("9", R.drawable.favicon_friendster);
		serviceProviderMapping.put("10", R.drawable.favicon_linkedin);
		serviceProviderMapping.put("11", R.drawable.favicon_match);
		serviceProviderMapping.put("12", R.drawable.favicon_metroflog);
		serviceProviderMapping.put("13", R.drawable.favicon_myyearbook);
		serviceProviderMapping.put("14", R.drawable.favicon_plaxo);
		serviceProviderMapping.put("15", R.drawable.favicon_amazon);
		serviceProviderMapping.put("16", R.drawable.favicon_flixster);
		serviceProviderMapping.put("17", R.drawable.favicon_tigerdirect);
		serviceProviderMapping.put("18", R.drawable.favicon_blackplanet);
		serviceProviderMapping.put("19", R.drawable.favicon_dailymotion);
		serviceProviderMapping.put("20", R.drawable.favicon_stumbleupon);
		serviceProviderMapping.put("21", R.drawable.favicon_tagged);
		serviceProviderMapping.put("22", R.drawable.favicon_wordpress);
		serviceProviderMapping.put("23", R.drawable.favicon_lastfm);
		serviceProviderMapping.put("24", R.drawable.favicon_pandora);
		serviceProviderMapping.put("25", R.drawable.favicon_hotels);
		serviceProviderMapping.put("26", R.drawable.favicon_nba);
		serviceProviderMapping.put("27", R.drawable.favicon_nytimes);
		serviceProviderMapping.put("28", R.drawable.favicon_ebay);
		serviceProviderMapping.put("29", R.drawable.favicon_vox);
		serviceProviderMapping.put("30", R.drawable.favicon_walmart);
		serviceProviderMapping.put("31", R.drawable.favicon_latimes);
		serviceProviderMapping.put("32", R.drawable.favicon_washingtonpost);
		serviceProviderMapping.put("33", R.drawable.favicon_classmates);
		serviceProviderMapping.put("34", R.drawable.favicon_ilike);
		serviceProviderMapping.put("35", R.drawable.favicon_slide);
		serviceProviderMapping.put("36", R.drawable.favicon_migente);
		serviceProviderMapping.put("37", R.drawable.favicon_livejournal);
		serviceProviderMapping.put("38", R.drawable.favicon_ecademy);
		serviceProviderMapping.put("39", R.drawable.favicon_eventful);
		serviceProviderMapping.put("40", R.drawable.favicon_tribe);
		serviceProviderMapping.put("41", R.drawable.favicon_yelp);
		serviceProviderMapping.put("42", R.drawable.favicon_friendfeed);
		serviceProviderMapping.put("43", R.drawable.favicon_perfspot);
		serviceProviderMapping.put("44", R.drawable.favicon_raptr);
		serviceProviderMapping.put("45", R.drawable.favicon_youtube);
		serviceProviderMapping.put("46", R.drawable.favicon_formspring);
		serviceProviderMapping.put("47", R.drawable.favicon_safetyweb);
	}

	public static String serviceProviderIconUrl(String serviceName) {
		return Constants.URL_SERVICE_ICON_DIR + "/" + serviceName + ".gif";
	}
}
