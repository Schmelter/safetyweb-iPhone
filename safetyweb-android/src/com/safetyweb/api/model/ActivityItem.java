/*
 * ActivityItem.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 7, 2010
 * Version: $Id: ActivityItem.java 1649 2010-07-21 22:21:00Z dan $
 */

package com.safetyweb.api.model;

/**
 * Represents an activity item retrieved from the SafetyWeb activity API call.
 * 
 * @author dhansen
 */
public class ActivityItem implements JsonSerializable {

	private String activity_date;
	private String activity_id;
	private String child_id;
	private String description;
	private String level;
	private String level_id;
	private Medias medias;
	private String service;
	private String service_id;

	public String getActivity_date() {
		return activity_date;
	}

	public String getActivity_id() {
		return activity_id;
	}

	public String getChild_id() {
		return child_id;
	}

	public String getDescription() {
		return description;
	}

	public String getLevel() {
		return level;
	}

	public String getLevel_id() {
		return level_id;
	}

	public String getService() {
		return service;
	}

	public String getService_id() {
		return service_id;
	}

	public void setActivity_date(String activityDate) {
		activity_date = activityDate;
	}

	public void setActivity_id(String activityId) {
		activity_id = activityId;
	}

	public void setChild_id(String childId) {
		child_id = childId;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public void setLevel(String level) {
		this.level = level;
	}

	public void setLevel_id(String levelId) {
		level_id = levelId;
	}

	public void setService(String service) {
		this.service = service;
	}

	public void setService_id(String serviceId) {
		service_id = serviceId;
	}

	public Medias getMedias() {
		return medias;
	}

	public void setMedias(Medias medias) {
		this.medias = medias;
	}

	@Override
	public String toString() {
		return String
			.format(
				"ActivityItem [activity_date=%s, activity_id=%s, child_id=%s, description=%s, level=%s, level_id=%s, medias=%s, service=%s, service_id=%s]",
				activity_date, activity_id, child_id, description, level, level_id, medias, service, service_id);
	}

}
