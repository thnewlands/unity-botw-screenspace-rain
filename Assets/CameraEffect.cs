using UnityEngine;
using System.Collections;

//so that we can see changes we make without having to run the game
[ExecuteInEditMode]
//require component camera
public class CameraEffect : MonoBehaviour
{
    public Material mat;
    private Camera cam;
    void Start()
    {
        cam = GetComponent<Camera>();
        cam.depthTextureMode = DepthTextureMode.DepthNormals;
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Matrix4x4 MV = cam.cameraToWorldMatrix;
        mat.SetMatrix("_CameraMV", MV);
        Graphics.Blit(source, destination, mat);
    }
}