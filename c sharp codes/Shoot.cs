/*
This clss creates a 3D ball object
A force is apllied to the ball according to how far the player swipes
If the ball hits the back board, it will apply a force to bounce the ball back
The number of shots left will be displayed on the top left corner

Date: Nov 28 2014
Author: Atiq Ullah, Jesse Wang
*/
using UnityEngine;
using System.Collections;

public class Shoot : MonoBehaviour
{
    public GameObject ball;
    private Vector3 throwSpeed = new Vector3(1, 0, 0);
    public Vector3 ballPos;
    private bool thrown = false;
    private GameObject ballClone;
	//first position of the swiping gesture
	private Vector3 fp;
	//last position of the swiping gesture
	private Vector3 lp;
	private float distance;
	private string s;
	private int shotsLeft = 10;
    
    void Start()
    {
        // set gravity
        Physics.gravity = new Vector3(0, 0, -3);
    }
	/*
	Get the starting and ending point of a swipe gesture 
	and calculates the distance
	then throw the ball accordingly
	*/
    void FixedUpdate()
    {
     
	foreach (Touch touch in Input.touches)
	{
		
		if(touch.phase ==TouchPhase.Began)
		{
			fp = touch.position;
		}
		else if(touch.phase == TouchPhase.Ended && !thrown && shotsLeft>0)
		{
			lp = touch.position;
			
			distance = Mathf.Sqrt(Mathf.Abs(lp.x - fp.x) * Mathf.Abs(lp.x - fp.x) + Mathf.Abs(lp.y - fp.y) * Mathf.Abs(lp.y - fp.y));
			thrown = true;
			
			ballClone = Instantiate(ball, ballPos, transform.rotation) as GameObject; 
            throwSpeed.y -= (distance/30);
            throwSpeed.z += (distance/300);

            ballClone.rigidbody.AddForce(throwSpeed, ForceMode.Impulse);
			shotsLeft--;			
		}
	}	
        //Remove the ball and set up for the next throw
        if (ballClone != null && ballClone.transform.position.z < -17)
        {
            Destroy(ballClone);
            thrown = false;
            throwSpeed = new Vector3(1, 0, 0);
            
        }
    }
	
	// if ball hits board, apply a force to bounce the ball back
    void OnCollisionEnter() 
    {
        if(throwSpeed.y < -15)
		{
			throwSpeed.y = 40;
			throwSpeed.x = 0;
			throwSpeed.z = 0;
			ballClone.rigidbody.AddForce(throwSpeed, ForceMode.Impulse);
		}
		else if(throwSpeed.y > -15 && throwSpeed.y < -10)
		{
			throwSpeed.y = 20;
			throwSpeed.x = 0;
			throwSpeed.z = 0;
			ballClone.rigidbody.AddForce(throwSpeed, ForceMode.Impulse);
		}
		
    }
	//display number of balls left
	void OnGUI () {
		GUI.color = Color.black;
		string s = "Number of Shots left:"+shotsLeft;
		GUI.Label (new Rect (10, 90, 300, 200), s);
     }
	 
    void restart()
    {
        Application.LoadLevel(Application.loadedLevel);
    }
}