using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.XR.CoreUtils;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;
using System.Linq;
using System.Xml.Serialization;

public class QrCodeRecenterUsingArImageTrackedManager : MonoBehaviour

{
    [SerializeField]
    private ARSession session;
    [SerializeField]
    private XROrigin sessionOrigin;
    [SerializeField]
    private ARCameraManager cameraManager;

    [SerializeField]
    private GameObject QrCodeRecenterTargets;

    [SerializeField]
    ARTrackedImageManager m_TrackedImageManager;
    private bool isScanningEnabled = true;

    private void Awake()
    {
        if (m_TrackedImageManager == null)
        {
            m_TrackedImageManager = GetComponent<ARTrackedImageManager>();
        }
    }
    void Start()
    {
        Debug.Log("AR session started.");
    }
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            SetQrCodeRecenterTarget("OfficeOfAccounts");
            EnableScanning();
        }
        //Debug.Log(TrackingState.Tracking);
    }
    void OnEnable()
    {
        m_TrackedImageManager.trackedImagesChanged += OnChanged;
        Debug.Log("ARTrackedImageManager enabled.");
    }

    void OnDisable()
    {
        m_TrackedImageManager.trackedImagesChanged -= OnChanged;
        Debug.Log("ARTrackedImageManager disabled.");
    }
    void OnChanged(ARTrackedImagesChangedEventArgs eventArgs)
    {
        foreach (ARTrackedImage newImage in eventArgs.added)
        {
            Debug.Log($"New tracked image added: {newImage.referenceImage.name}");
            HandleTrackedImage(newImage);
        }

        foreach (ARTrackedImage updatedImage in eventArgs.updated)
        {
            Debug.Log($"Tracked image updated: {updatedImage.referenceImage.name}");
            HandleTrackedImage(updatedImage);
        }

        foreach (ARTrackedImage removedImage in eventArgs.removed)
        {
            Debug.Log($"Tracked image removed: {removedImage.referenceImage.name}");
            // Handle removed event if necessary
        }
    }
    private void HandleTrackedImage(ARTrackedImage trackedImage)
    {
        if (isScanningEnabled)
        {
            switch (trackedImage.trackingState)
            {
                case TrackingState.None:
                    Debug.Log($"{trackedImage.referenceImage.name} is not being tracked.");
                    break;
                case TrackingState.Limited:
                    Debug.Log($"{trackedImage.referenceImage.name} is being tracked with limited quality.");
                    break;
                case TrackingState.Tracking:
                    Debug.Log($"{trackedImage.referenceImage.name} is actively being tracked.");
                    SetQrCodeRecenterTarget(trackedImage.referenceImage.name);
                    DisableScanning();
                    break;
            }
        }
    }
    private void SetQrCodeRecenterTarget(string targetText)
    {
        GameObject targetObject = QrCodeRecenterTargets.GetComponentsInChildren<Transform>().FirstOrDefault(t => t.name.Equals(targetText, System.StringComparison.OrdinalIgnoreCase))?.gameObject;



        //Rest Postiion and rotation of AR Session
        if (targetObject != null)
        {

            session.Reset();

            //Add Offset for recentering
            sessionOrigin.transform.position = targetObject.transform.position;
            sessionOrigin.transform.rotation = targetObject.transform.rotation;
        }
    }


    private void DisableScanning()
    {
        isScanningEnabled = false;
        m_TrackedImageManager.enabled = false;
        Debug.Log("Scanning disabled.");
    }

    public void EnableScanning()
    {
        isScanningEnabled = true;
        m_TrackedImageManager.enabled = true;
        Debug.Log("Scanning enabled.");
    }
    public void RescanQRCode()
    {
        EnableScanning();
        ResetARSession();
        Debug.Log("QR Code rescanning initiated.");
    }
    private void ResetARSession()
    {
        session.Reset();
        Debug.Log("AR session reset.");
    }


}
