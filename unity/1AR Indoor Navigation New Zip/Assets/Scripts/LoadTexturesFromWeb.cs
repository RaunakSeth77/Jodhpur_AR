using System.Collections;
using System.IO;
using UnityEngine;
using UnityEngine.Networking;
using Unity.SharpZipLib.Zip;

public class LoadTexturesFromWeb : MonoBehaviour
{
    public string zipUrl = "http://localhost:8080/Textures.zip"; // Replace with your ZIP file URL
    public string extractPath = "Assets"; // Path where to extract the ZIP file

    void Start()
    {
        StartCoroutine(DownloadAndExtractZip());
    }

    IEnumerator DownloadAndExtractZip()
    {
        using (UnityWebRequest uwr = UnityWebRequest.Get(zipUrl))
        {
            yield return uwr.SendWebRequest();

            if (uwr.result == UnityWebRequest.Result.ConnectionError || uwr.result == UnityWebRequest.Result.ProtocolError)
            {
                Debug.LogError(uwr.error);
            }
            else
            {
                byte[] zipData = uwr.downloadHandler.data;
                ExtractZip(zipData, extractPath);

                // After extraction, load the textures
                LoadTextures(extractPath);
            }
        }
    }

    void ExtractZip(byte[] zipData, string extractPath)
    {
        using (MemoryStream ms = new MemoryStream(zipData))
        using (ZipInputStream zipStream = new ZipInputStream(ms))
        {
            ZipEntry entry;
            while ((entry = zipStream.GetNextEntry()) != null)
            {
                string entryPath = Path.Combine(extractPath, entry.Name);
                string directoryPath = Path.GetDirectoryName(entryPath);

                if (entry.IsDirectory)
                {
                    Directory.CreateDirectory(entryPath);
                }
                else
                {
                    if (!Directory.Exists(directoryPath))
                    {
                        Directory.CreateDirectory(directoryPath);
                    }

                    using (FileStream fs = File.Create(entryPath))
                    {
                        byte[] buffer = new byte[4096];
                        int bytesRead;
                        while ((bytesRead = zipStream.Read(buffer, 0, buffer.Length)) > 0)
                        {
                            fs.Write(buffer, 0, bytesRead);
                        }
                    }
                }
            }
        }
    }

    void LoadTextures(string path)
    {
        // Example of loading textures from the extracted folder
        string[] filePaths = Directory.GetFiles(path, "*.jpg", SearchOption.AllDirectories);
        foreach (string filePath in filePaths)
        {
            byte[] fileData = File.ReadAllBytes(filePath);
            Texture2D texture = new Texture2D(2, 2);
            texture.LoadImage(fileData); // Load the texture
            Debug.Log("Loaded texture: " + filePath);

            // Here you can apply the texture to a material, a UI element, etc.
        }
    }
}
