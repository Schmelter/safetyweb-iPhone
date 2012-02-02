/*
 * Medias.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 9, 2010
 * Version: $Id: Medias.java 1649 2010-07-21 22:21:00Z dan $
 */

package com.safetyweb.api.model;

import java.util.List;

/**
 * Represents the media object that belongs to an activity item retrieved from the SafetyWeb
 * activity API call.
 * 
 * @author dhansen
 */
public class Medias implements JsonSerializable {

	List<Media> media;

	public List<Media> getMedia() {
		return media;
	}

	public void setMedia(List<Media> media) {
		this.media = media;
	}

	@Override
	public String toString() {
		return String.format("Medias [getClass()=%s, hashCode()=%s, toString()=%s]", getClass(), hashCode(), super.toString());
	}

}
