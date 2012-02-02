/*
 * ObjectRegistry.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 8, 2010
 * Version: $Id: ObjectRegistry.java 1612 2010-07-19 18:09:12Z dan $
 */

package com.safetyweb.android.ui.util;

import java.util.HashMap;
import java.util.Map;

/**
 * This class is responsible for storing objects shared between Activities.
 * It can be removed when the shared objects implement parcelable and are passed activities via
 * the intent.
 * 
 * @author dhansen
 */
public class ObjectRegistry {

	private static final Map<String, Object> objects = new HashMap<String, Object>();

	private ObjectRegistry() {
	}

	public static void put(String key, Object value) {
		objects.put(key, value);
	}

	public static Object get(String key) {
		return objects.get(key);
	}

	public static Object remove(String key) {
		return objects.remove(key);
	}
}
