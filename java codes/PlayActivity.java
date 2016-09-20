package example.mycompany.myfirstarapp;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.TimerTask;
import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.StrictMode;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

public class PlayActivity extends Activity {
	Button start;
	EditText txt;
	ListView show;
	@Override
	protected void onCreate(Bundle savedInstanceState) {

		StrictMode.setThreadPolicy(new StrictMode.ThreadPolicy.Builder()
				.detectDiskReads().detectDiskWrites().detectNetwork()
				.penaltyLog().build());
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_play);

		txt = (EditText) findViewById(R.id.editText1);
		show = (ListView) findViewById(R.id.listView1);
		start = (Button) findViewById(R.id.startgamebutton);
		start.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				

				
				PlayActivity.this.Start(v);
			}
		});
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.play, menu);
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
	// Route called when the user presses "connect"
	
		public void openSocket(View view) {
			Global app = (Global) getApplication();
			
			if (app.sock != null && app.sock.isConnected() && !app.sock.isClosed()) {
				Toast.makeText(getApplicationContext(), "socket already open", Toast.LENGTH_LONG).show();
				return;
			}
			
			// open the socket.  SocketConnect is a new subclass
		    // (defined below).  This creates an instance of the subclass
			// and executes the code in it.
			
			String getInput = txt.getText().toString();
			String name = ((Global) PlayActivity.this.getApplication()).getPlayerName();

			if (!getInput.equals(name)) {
				((Global) PlayActivity.this.getApplication()).setName(name);
			}

			
			
			new SocketConnect().execute((Void) null);
		}

		//  Called when the user wants to send a message
		
		public void sendMessage(View view) {
			Global app = (Global) getApplication();
			
//			String getInput = txt.getText().toString();
//			String name = ((Global) PlayActivity.this.getApplication()).getPlayerName();
//
//			if (!getInput.equals(name)) {
//				((Global) PlayActivity.this.getApplication()).setName(name);
//			}
//			
//			
//			String msg = ((Global)getApplication()).getPlayerName();
			
			EditText et = (EditText) findViewById(R.id.editText1);
			String msg = et.getText().toString();
			
			// Create an array of bytes.  First byte will be the
			// message length, and the next ones will be the message
			
			byte buf[] = new byte[msg.length() + 1];
			buf[0] = (byte) msg.length(); 
			System.arraycopy(msg.getBytes(), 0, buf, 1, msg.length());

			// Now send through the output stream of the socket
			
			OutputStream out;
			try {
				out = app.sock.getOutputStream();
				try {
					out.write(buf, 0, msg.length() + 1);
				} catch (IOException e) {
					e.printStackTrace();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		// Called when the user closes a socket
		
		public void closeSocket(View view) {
			Global app = (Global) getApplication();
			Socket s = app.sock;
			try {
				s.getOutputStream().close();
				s.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		// Construct an IP address from the four boxes
		
		public String getConnectToIP() {
			String addr = "";
			EditText text_ip;
			text_ip = (EditText) findViewById(R.id.ip1);
			addr += text_ip.getText().toString();
			text_ip = (EditText) findViewById(R.id.ip2);
			addr += "." + text_ip.getText().toString();
			text_ip = (EditText) findViewById(R.id.ip3);
			addr += "." + text_ip.getText().toString();
			text_ip = (EditText) findViewById(R.id.ip4);
			addr += "." + text_ip.getText().toString();
			return addr;
		}

		// Gets the Port from the appropriate field.
		
		public Integer getConnectToPort() {
			
			return 50002;
		}


	    // This is the Socket Connect asynchronous thread.  Opening a socket
		// has to be done in an Asynchronous thread in Android.  Be sure you
		// have done the Asynchronous Tread tutorial before trying to understand
		// this code.
		
		public class SocketConnect extends AsyncTask<Void, Void, Socket> {

			// The main parcel of work for this thread.  Opens a socket
			// to connect to the specified IP.

			protected Socket doInBackground(Void... voids) {
				Socket s = null;
				String ip = getConnectToIP();
				Integer port = getConnectToPort();

				try {
					s = new Socket();
					s.bind(null);
					s.connect((new InetSocketAddress(ip, port)), 1000);
				} catch (UnknownHostException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				return s;
			}
			

			// After executing the doInBackground method, this is 
			// automatically called, in the UI (main) thread to store
			// the socket in this app's persistent storage

			protected void onPostExecute(Socket s) {
				Global myApp = (Global) PlayActivity.this
						.getApplication();
				myApp.sock = s;
				
				String msg;
				if (myApp.sock.isConnected()) {
					msg ="Connection opened successfully";
				} else {
					msg = "Connection could not be opened";
				}
				Toast t = Toast.makeText(getApplicationContext(), msg, Toast.LENGTH_LONG);
				t.show();
			}
			
		
		}

		// This is a timer Task.  Be sure to work through the tutorials
		// on Timer Tasks before trying to understand this code.
		
		public class TCPReadTimerTask extends TimerTask {
			public void run() {
				Global app = (Global) getApplication();
				if (app.sock != null && app.sock.isConnected()
						&& !app.sock.isClosed()) {
					
					try {
						InputStream in = app.sock.getInputStream();

						// See if any bytes are available from the Middleman
						
						int bytes_avail = in.available();
						if (bytes_avail > 0) {
							
							// If so, read them in and create a sring
							
							byte buf[] = new byte[bytes_avail];
							in.read(buf);

							final String s = new String(buf, 0, bytes_avail, "US-ASCII");
			
							// As explained in the tutorials, the GUI can not be
							// updated in an asyncrhonous task.  So, update the GUI
							// using the UI thread.
							
							runOnUiThread(new Runnable() {
								public void run() {
//									EditText et = (EditText) findViewById(R.id.RecvdMessage);
//									et.setText(s);
									((Global)getApplication()).setName(s);
								}
							});
							
						}
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
		}
	public void Start(View view) {

		Intent intent = new Intent(this,
				com.qualcomm.QCARUnityPlayer.QCARPlayerNativeActivity.class);
		startActivity(intent);
	}
}
