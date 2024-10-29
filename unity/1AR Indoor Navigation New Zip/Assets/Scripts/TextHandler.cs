using System.Collections;
using System.Collections.Generic;
using Unity.XR.CoreUtils;
using UnityEngine;
using UnityEngine.XR.ARFoundation;


public class TextHandler : MonoBehaviour
{
    [SerializeField] private XROrigin xrOrigin;
    [SerializeField] private GameObject text;
    private ARTrackedImageManager aRTrackedImageManager;
    // Start is called before the first frame update
    void Start()
    {
        aRTrackedImageManager = xrOrigin.GetComponent<ARTrackedImageManager>();
        aRTrackedImageManager.trackedImagePrefab = text;

    }

    public void ChnageText()
    {
        aRTrackedImageManager.trackedImagePrefab=null;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
