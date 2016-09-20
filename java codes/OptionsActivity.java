package example.mycompany.myfirstarapp;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.media.AudioManager;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ArrayAdapter;
import android.widget.SeekBar;
import android.widget.SeekBar.OnSeekBarChangeListener;
import android.widget.Spinner;



public class OptionsActivity extends Activity {
	 
	 private SeekBar volumeSeekbar = null;
	
	 private AudioManager audioManager = null; 
	
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_options);
		getActionBar().setDisplayHomeAsUpEnabled(true);
		getWindow().getDecorView().setBackgroundColor(Color.WHITE);
		Spinner spinner = (Spinner) findViewById(R.id.spinner1);
		// Create an ArrayAdapter using the string array and a default spinner layout
		ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this,
		        R.array.basketball_colors_array, android.R.layout.simple_spinner_item);
		// Specify the layout to use when the list of choices appears
		adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
		// Apply the adapter to the spinner
		spinner.setAdapter(adapter);
		 try
	        {
	            volumeSeekbar = (SeekBar)findViewById(R.id.SeekBar01);
	            audioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
	            volumeSeekbar.setMax(audioManager
	                    .getStreamMaxVolume(AudioManager.STREAM_MUSIC));
	            volumeSeekbar.setProgress(audioManager
	                    .getStreamVolume(AudioManager.STREAM_MUSIC));   


	            volumeSeekbar.setOnSeekBarChangeListener(new OnSeekBarChangeListener() 
	            {
	                @Override
	                public void onStopTrackingTouch(SeekBar arg0) 
	                {
	                }

	                @Override
	                public void onStartTrackingTouch(SeekBar arg0) 
	                {
	                }

	                @Override
	                public void onProgressChanged(SeekBar arg0, int progress, boolean arg2) 
	                {
	                    audioManager.setStreamVolume(AudioManager.STREAM_MUSIC,
	                            progress, 0);
	                }
	            });
	        }
	        catch (Exception e) 
	        {
	            e.printStackTrace();
	        }
		 
	}
	

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.options, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		int id = item.getItemId();
		if (id == R.id.action_settings) {
			return true;
		}
		return super.onOptionsItemSelected(item);
	}
}