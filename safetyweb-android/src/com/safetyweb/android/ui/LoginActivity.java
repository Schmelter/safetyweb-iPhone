/*
 * LoginActivity.java
 * 
 * Copyright (C) 2010 SafetyWeb, LLC.
 * All Rights Reserved.
 * 
 * This source file is proprietary property of SafetyWeb, LLC.
 * 
 * Author: $Author: dan $
 * Created: Jul 6, 2010
 * Version: $Id: LoginActivity.java 1674 2010-07-23 22:32:53Z dan $
 */
package com.safetyweb.android.ui;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.AsyncTask.Status;
import android.util.Log;
import android.view.MenuInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.safetyweb.android.Constants;
import com.safetyweb.api.SafetyWebClient;
import com.safetyweb.api.auth.BasicCredentials;

/**
 * Activity class that is responsible for allowing the user to login and then forwards to the
 * Children activity upon successful login.
 * 
 * TODO Extract login/logout logic into a separate class.
 * 
 * @author dhansen
 */
public class LoginActivity extends Activity {

	private ActivityHelper activityHelper;
	private ProgressDialog progressDialog = null;
	private LoginTask loginTask = null;

	private EditText txtPassword;
	private EditText txtUsername;

	private String rememberedUsername = null;
	private String rememberedPassword = null;
	private boolean rememberedRememberMe;
	private String rememberedToken = null;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.login);

		activityHelper = new ActivityHelper(this);
		activityHelper.registerExitReceiver();

		txtUsername = (EditText) findViewById(R.id.txtUsername);
		txtPassword = (EditText) findViewById(R.id.txtPassword);

		if (!handleIntent()) {
			loadPreferences();

			if (rememberedToken != null)
				startChildrenActivity(rememberedToken);
			else if (rememberedUsername != null && rememberedPassword != null) {
				loginTask = new LoginTask();
				loginTask.execute(rememberedUsername, rememberedPassword);
			}
		}

		buildLoginScreen();
	}

	@Override
	protected void onPause() {
		super.onPause();

		// We don't want any leaked windows!
		if (progressDialog != null && progressDialog.isShowing())
			progressDialog.dismiss();

		if (loginTask != null && loginTask.getStatus() != Status.FINISHED)
			loginTask.cancel(true);
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		activityHelper.unregisterReceivers();
	}

	@Override
	public boolean onCreateOptionsMenu(android.view.Menu menu) {
		super.onCreateOptionsMenu(menu);

		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.icon_menu, menu);
		menu.removeItem(R.id.mitLogout);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(android.view.MenuItem menuItem) {
		return activityHelper.onOptionsItemSelected(menuItem);
	}

	/**
	 * Determines if the intent invoking the activity has an ACTION that requires any logic
	 * handling here, such as exiting the app or logging out.
	 * 
	 * @return True if an ACTION was handled and this activity should not be loaded, else false.
	 */
	private boolean handleIntent() {
		boolean result = false;
		Intent intent = getIntent();

		if (intent != null) {
			String action = intent.getAction();
			if (action != null)
				if (action.equals(Constants.ACTION_LOGOUT))
					logout();
		}

		return result;
	}

	private void buildLoginScreen() {
		buildContentLayout();
		buildLoginText();
		buildLoginButton();
		buildLearnMoreButton();
	}

	private void buildContentLayout() {
		LinearLayout layout = (LinearLayout) findViewById(R.id.llytContent);
		if (layout != null)
			layout.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					hideKeyboard(v);
				}
			});
	}

	private void buildLoginText() {
		txtUsername.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				String username = txtUsername.getText().toString();
				if (username.equals(getString(R.string.username)))
					txtUsername.setText("");
			}
		});

		if (rememberedRememberMe && rememberedUsername != null && rememberedPassword != null) {
			txtUsername.setText(rememberedUsername);
			txtPassword.setText(rememberedPassword);
		}
	}

	private void buildLoginButton() {
		ImageButton button = (ImageButton) findViewById(R.id.btnLogin);
		button.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				hideKeyboard(v);

				TextView lblResult = (TextView) findViewById(R.id.txtResult);
				lblResult.setText("");

				// The class fields don't seem to be set when clicking back after the first login
				// when choosing remember me so forcing a load here always makes sure we're getting
				// what was previously stored;
				loadPreferences();

				String username = txtUsername.getText().toString();
				String password = txtPassword.getText().toString();

				if (rememberedToken != null && username.equals(rememberedUsername) && password.equals(rememberedPassword))
					startChildrenActivity(rememberedToken);
				else {
					loginTask = new LoginTask();
					loginTask.execute(username, password);
				}
			}
		});
	}

	private void buildLearnMoreButton() {
		ImageButton learnMorebutton = (ImageButton) findViewById(R.id.btnLearnMore);
		learnMorebutton.requestFocus();
		learnMorebutton.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				Uri uri = Uri.parse(Constants.LINK_LEARN_MORE);
				Intent intent = new Intent(Intent.ACTION_VIEW, uri, LoginActivity.this, WebViewActivity.class);
				startActivity(intent);
			}
		});
	}

	/**
	 * Restores any saved login credentials to local fields.
	 */
	private void loadPreferences() {
		SharedPreferences preferences = getPreferences(MODE_PRIVATE);
		rememberedRememberMe = preferences.getBoolean(Constants.PREFERENCE_REMEMBER_ME, false);
		rememberedUsername = preferences.getString(Constants.PREFERENCE_USERNAME, null);
		rememberedPassword = preferences.getString(Constants.PREFERENCE_PASSWORD, null);

		long tokenTimeMilliseconds = preferences.getLong(Constants.PREFERENCE_TOKEN_MILLISECONDS, 0);
		if (tokenTimeMilliseconds != 0) {
			long tokenAge = System.currentTimeMillis() - tokenTimeMilliseconds;
			if (tokenAge < Constants.TOKEN_EXPIRE_AGE_MILLISECONDS)
				rememberedToken = preferences.getString(Constants.PREFERENCE_TOKEN, null);
		}
	}

	private void savePreferences(boolean rememberMe, String username, String password, String token) {
		SharedPreferences preferences = getPreferences(MODE_PRIVATE);
		Editor editor = preferences.edit();
		editor.putBoolean(Constants.PREFERENCE_REMEMBER_ME, rememberMe);
		editor.putString(Constants.PREFERENCE_USERNAME, username);
		editor.putString(Constants.PREFERENCE_PASSWORD, password);
		editor.putString(Constants.PREFERENCE_TOKEN, token);
		if (token != null)
			editor.putLong(Constants.PREFERENCE_TOKEN_MILLISECONDS, System.currentTimeMillis());
		editor.commit();

		rememberedUsername = username;
		rememberedPassword = password;
		rememberedToken = token;
	}

	/**
	 * Starts the ChildrenActivity and finishes this one.
	 * 
	 * @param token Authentication token.
	 */
	private void startChildrenActivity(String token) {
		Intent intent = new Intent(LoginActivity.this, ChildrenActivity.class);
		intent.putExtra(Constants.EXTRA_LOGIN_TOKEN, token);
		startActivity(intent);

		// User credentials are always remembered so going back to the login activity in the history
		// is not necessary unless the user explicitly logs out.
		activityHelper.unregisterReceivers();
		finish();
	}

	private void logout() {
		savePreferences(false, null, null, null);
	}

	private void hideKeyboard(View v) {
		InputMethodManager inputManager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
		inputManager.hideSoftInputFromWindow(v.getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
	}

	/**
	 * Class responsible for asynchronously logging in the user and saving the credentials to the
	 * preferences (so they can be accessed later) if the login was successful.
	 * 
	 * @author dhansen
	 */
	private class LoginTask extends AsyncTask<String, Void, Void> {

		private String token = null;
		String username;
		String password;

		@Override
		protected Void doInBackground(String... params) {
			try {
				username = params[0];
				password = params[1];
				token = getClient().login(username, password);
			}
			catch (Exception e) {
				Log.e(getClass().getSimpleName(), "Unable to login", e);
			}

			return null;
		}

		@Override
		protected void onPreExecute() {
			progressDialog = ProgressDialog.show(LoginActivity.this, getString(R.string.please_wait),
				getString(R.string.logging_in), true);
		}

		@Override
		protected void onPostExecute(Void param) {
			progressDialog.dismiss();

			if (token == null) {
				TextView lblResult = (TextView) findViewById(R.id.txtResult);
				lblResult.setText(R.string.invalid_credentials);
			}
			else {
				savePreferences(true, username, password, token);
				startChildrenActivity(token);
			}
		}

		private SafetyWebClient getClient() {
			BasicCredentials credentials = new BasicCredentials(Constants.API_ID, Constants.API_KEY);
			return new SafetyWebClient(credentials);
		}
	}

}
