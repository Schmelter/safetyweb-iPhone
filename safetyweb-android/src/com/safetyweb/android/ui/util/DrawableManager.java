/*
 * DrawableManager.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 8, 2010
 * Version: $Id: DrawableManager.java 1612 2010-07-19 18:09:12Z dan $
 */

package com.safetyweb.android.ui.util;

import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

import android.graphics.drawable.Drawable;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.ImageView;

/**
 * Utility class responsible fetching image urls and converting them to drawable's that may be used
 * for widgets such as the imageView.
 * 
 * @author dhansen
 */
public class DrawableManager {

	private final Map<String, Drawable> drawableMap = Collections.synchronizedMap(new HashMap<String, Drawable>());

	public Drawable fetchDrawable(String url) {
		Drawable drawable = null;

		if (drawableMap.containsKey(url))
			drawable = drawableMap.get(url);
		else {
			Log.d(getClass().getSimpleName(), "image url:" + url);

			try {
				InputStream is = fetch(url);
				drawable = Drawable.createFromStream(is, "src");

				if (drawable != null) {
					drawableMap.put(url, drawable);

					Log.d(getClass().getSimpleName(), "got a thumbnail drawable: " + drawable.getBounds() + ", "
							+ drawable.getIntrinsicHeight() + "," + drawable.getIntrinsicWidth() + ", "
							+ drawable.getMinimumHeight() + "," + drawable.getMinimumWidth());
				}
				else
					Log.d(getClass().getSimpleName(), "failed to create drawable from stream for url: " + url);
			}
			catch (MalformedURLException e) {
				Log.e(getClass().getSimpleName(), "fetchDrawable failed", e);
			}
			catch (IOException e) {
				Log.e(getClass().getSimpleName(), "fetchDrawable failed", e);
			}
		}

		return drawable;
	}

	/**
	 * Asynchronously fetches an image from a url and sets it as the supplied imageView's drawable.
	 * 
	 * @param urlString The image url to fetch.
	 * @param imageView The imageView with the drawable to set.
	 * @param pendingResId The resource identifier of the the drawable used while the fetch is
	 *            pending.
	 */
	public void fetchDrawableAsync(final String urlString, final ImageView imageView, final int pendingResId) {
		if (drawableMap.containsKey(urlString))
			imageView.setImageDrawable(drawableMap.get(urlString));
		else {
			imageView.setImageResource(pendingResId);

			final Handler handler = new Handler() {
				@Override
				public void handleMessage(Message message) {
					Drawable drawable = (Drawable) message.obj;
					if (drawable != null)
						imageView.setImageDrawable(drawable);
				}
			};

			Thread thread = new Thread() {
				@Override
				public void run() {
					Drawable drawable = fetchDrawable(urlString);
					Message message = handler.obtainMessage(1, drawable);
					handler.sendMessage(message);
				}
			};

			thread.start();
		}
	}

	private InputStream fetch(String url) throws MalformedURLException, IOException {
		DefaultHttpClient httpClient = new DefaultHttpClient();
		HttpGet request = new HttpGet(url);
		HttpResponse response = httpClient.execute(request);
		return response.getEntity().getContent();
	}

}
