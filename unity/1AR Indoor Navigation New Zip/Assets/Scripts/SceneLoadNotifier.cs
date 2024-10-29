using FlutterUnityIntegration;
using UnityEngine;

public class SceneLoadNotifier : MonoBehaviour
{
    void Start()
    {
        NotifySceneLoaded();
    }

    private void NotifySceneLoaded()
    {
        UnityMessageManager.Instance.SendMessageToFlutter("SceneLoaded");
    }

    void OnMessage(string message)
    {
        if (message == "BackToPreviousScreen")
        {
            NotifySceneLoaded();
        }
    }
}
