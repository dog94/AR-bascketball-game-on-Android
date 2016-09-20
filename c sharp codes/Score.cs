/*
This Class determines if the ball gets in the hoop and updates the score
Date: Nov 28 2014
Author: Jesse Wang
*/

using UnityEngine;
using System.Collections;
public class Score : MonoBehaviour {
	public int points = 0;
	public AudioClip audio;
	private bool shot = true;
	
	//increment the score when the ball gets in
	void OnTriggerEnter()
	{
		if(shot == true)
		{
			points++;
			shot = false;
		}
		AudioSource.PlayClipAtPoint(audio, transform.position);
	}
	
	//make sure the ball exits the net
	void OnTriggerExit()
	{
		shot = true;
	}
	
	//display score
	void OnGUI () {
		GUI.color = Color.black;
		string s = "Score: "+ points.ToString();
		GUI.Label (new Rect (10, 40, 300, 300), s);
     }
}
