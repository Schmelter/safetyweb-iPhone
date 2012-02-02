/*
 * ActivityLevel.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 7, 2010
 * Version: $Id: ActivityLevel.java 1649 2010-07-21 22:21:00Z dan $
 */

package com.safetyweb.api.model;

import java.util.EnumSet;
import java.util.HashMap;
import java.util.Map;

/**
 * TODO Type description
 * 
 * @author dhansen
 */
public enum ActivityLevel implements JsonSerializable {

	INFO("0"), POSITIVE("1"), WARNING("2"), REDFLAG("3");

	private String levelId;

	private static final Map<String, ActivityLevel> lookup = new HashMap<String, ActivityLevel>();

	static {
		for (ActivityLevel a : EnumSet.allOf(ActivityLevel.class))
			lookup.put(a.getLevelId(), a);
	}

	private ActivityLevel(String levelId) {
		this.levelId = levelId;
	}

	public String getLevelId() {
		return levelId;
	}

	public static ActivityLevel get(String levelId) {
		return lookup.get(levelId);
	}

}
