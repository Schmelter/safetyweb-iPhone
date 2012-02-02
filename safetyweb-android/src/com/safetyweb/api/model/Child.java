/*
 * Child.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 7, 2010
 * Version: $Id: Child.java 1649 2010-07-21 22:21:00Z dan $
 */

package com.safetyweb.api.model;

import java.util.Collections;
import java.util.List;

/**
 * Represents a child as retrieved from SafetyWeb's API.
 * 
 * @author dhansen
 */
public class Child implements JsonSerializable {

	private List<Account> accounts;
	private String child_id;
	private String first_name;
	private String last_name;
	private String profile_pic;
	private List<ActivityCount> activityCounts;

	private String accountProfilePic = null;
	private boolean accountsHasBeenSet;

	/**
	 * Retrieves a profile pic from one of the child's accounts if it has a pic available.
	 * 
	 * @return The first profile pic url found or null if none found.
	 */
	public synchronized String getProfilePicFromAccounts() {
		List<Account> accounts = getAccounts();

		if (accountProfilePic == null && accounts != null) {
			Collections.shuffle(accounts);
			for (Account account : accounts) {
				String picUrl = account.getProfile_pic();
				if (picUrl != null && !picUrl.equals(""))
					accountProfilePic = picUrl;
			}
		}

		return accountProfilePic;
	}

	public String getProfile_pic() {
		return profile_pic;
	}

	public void setProfile_pic(String profilePic) {
		profile_pic = profilePic;
	}

	public boolean hasProfilePic() {
		String profilePic = getProfile_pic();
		return profilePic != null && !profilePic.equals("");
	}

	public boolean hasAccountsBeenSet() {
		return accountsHasBeenSet;
	}

	public List<Account> getAccounts() {
		return accounts;
	}

	public List<ActivityCount> getActivityCounts() {
		return activityCounts;
	}

	public String getChild_id() {
		return child_id;
	}

	public String getFirst_name() {
		return first_name;
	}

	public String getLast_name() {
		return last_name;
	}

	public synchronized void setAccounts(List<Account> accounts) {
		accountsHasBeenSet = true;
		this.accounts = accounts;
	}

	public void setActivityCounts(List<ActivityCount> activityCount) {
		this.activityCounts = activityCount;
	}

	public void setChild_id(String childId) {
		child_id = childId;
	}

	public void setFirst_name(String firstName) {
		first_name = firstName;
	}

	public void setLast_name(String lastName) {
		last_name = lastName;
	}

	@Override
	public String toString() {
		return String
			.format(
				"Child [accounts=%s, accountsHasBeenSet=%s, activityCounts=%s, child_id=%s, first_name=%s, last_name=%s, profile_pic=%s, profile_pic_url=%s]",
				accounts, accountsHasBeenSet, activityCounts, child_id, first_name, last_name, profile_pic, accountProfilePic);
	}

}
