/*
 * Media.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 9, 2010
 * Version: $Id: Media.java 1649 2010-07-21 22:21:00Z dan $
 */

package com.safetyweb.api.model;

/**
 * TODO Type description
 * 
 * @author dhansen
 */
public class Media implements JsonSerializable {

	private String thumbnail;
	private String type;
	private String url;

	public String getThumbnail() {
		return thumbnail;
	}

	public void setThumbnail(String thumbnail) {
		this.thumbnail = thumbnail;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	@Override
	public String toString() {
		return String.format("Media [thumbnail=%s, type=%s, url=%s]", thumbnail, type, url);
	}

}
