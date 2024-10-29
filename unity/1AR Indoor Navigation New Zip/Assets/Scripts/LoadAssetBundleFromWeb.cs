using System.Collections;
using UnityEngine;
using UnityEngine.Networking;

public class LoadAssetBundleFromWeb : MonoBehaviour
{
    public string bundleUrl = "http://192.168.29.185:8080/modelbundle"; // Replace with your Asset Bundle URL
    public string assetName = "model"; // Replace with the name of the asset in the bundle
    public Transform parentTransform;

    void Start()
    {
        StartCoroutine(DownloadAndLoadAssetBundle());
    }

    IEnumerator DownloadAndLoadAssetBundle()
    {
        using (UnityWebRequest uwr = UnityWebRequestAssetBundle.GetAssetBundle(bundleUrl))
        {
            yield return uwr.SendWebRequest();

            if (uwr.result == UnityWebRequest.Result.ConnectionError || uwr.result == UnityWebRequest.Result.ProtocolError)
            {
                Debug.LogError(uwr.error);
            }
            else
            {
                AssetBundle bundle = DownloadHandlerAssetBundle.GetContent(uwr);
                if (bundle != null)
                {
                    GameObject model = bundle.LoadAsset<GameObject>(assetName);
                    if (model != null)
                    {
                        GameObject instantiatedModel = Instantiate(model, parentTransform);

                        if (parentTransform != null)
                        {
                            instantiatedModel.transform.SetParent(parentTransform);
                        }
                    }
                    else
                    {
                        Debug.LogError("Failed to load the model from the Asset Bundle.");
                    }
                    bundle.Unload(false);
                }
                else
                {
                    Debug.LogError("Failed to download the Asset Bundle.");
                }
            }
        }
    }
}
