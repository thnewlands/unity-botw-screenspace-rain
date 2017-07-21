using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TranslatePosition : MonoBehaviour {

    public Vector3 direction;

	void Update () {
        transform.position += direction;
	}
}
