/*
 * ActivityCount.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 7, 2010
 * Version: $Id: ActivityCount.java 1649 2010-07-21 22:21:00Z dan $
 */

package com.safetyweb.api.model;

/**
 * Reprensents the activity counts for a child that is retreived from SafetyWeb's API.
 * 
 * @author dhansen
 */
public class ActivityCount implements JsonSerializable {
	private String child_id;
	private String level_id;
	private String total;

	public String getChild_id() {
		return child_id;
	}

	public void setChild_id(String childId) {
		child_id = childId;
	}

	public String getLevel_id() {
		return level_id;
	}

	public void setLevel_id(String levelId) {
		level_id = levelId;
	}

	public String getTotal() {
		return total;
	}

	public void setTotal(String total) {
		this.total = total;
	}

	@Override
	public String toString() {
		return String.format("ActivityCount [child_id=%s, level_id=%s, total=%s]", child_id, level_id, total);
	}

}
