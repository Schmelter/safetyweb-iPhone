/*
 * Activity.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 7, 2010
 * Version: $Id: Activity.java 1649 2010-07-21 22:21:00Z dan $
 */

package com.safetyweb.api.model;

import java.util.List;

/**
 * Represents a child activity retrieved from SafetyWeb's API.
 * 
 * @author dhansen
 */
public class Activity implements JsonSerializable {

	private List<ActivityCount> count;
	private List<ActivityItem> item;

	public List<ActivityCount> getCount() {
		return count;
	}

	public List<ActivityItem> getItem() {
		return item;
	}

	public void setCount(List<ActivityCount> count) {
		this.count = count;
	}

	public void setItem(List<ActivityItem> item) {
		this.item = item;
	}

}
