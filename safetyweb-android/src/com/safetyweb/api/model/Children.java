/*
 * Children.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 7, 2010
 * Version: $Id: Children.java 1649 2010-07-21 22:21:00Z dan $
 */

package com.safetyweb.api.model;

import java.util.List;

/**
 * Represents the children object that is retreived from the SafetyWeb API.
 * 
 * @author dhansen
 */
public class Children implements JsonSerializable {

	private List<Child> child;

	public List<Child> getChild() {
		return child;
	}

	public void setChild(List<Child> child) {
		this.child = child;
	}

	@Override
	public String toString() {
		return String.format("Children [child=%s]", child);
	}

}
