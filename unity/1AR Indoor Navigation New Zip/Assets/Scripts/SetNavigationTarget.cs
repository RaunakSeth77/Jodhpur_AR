// MoveTo.cs
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.AI;
using TMPro;
using System.Collections.Generic;
using UnityEngine.UI;

public class SetNavigationTarget : MonoBehaviour
{

    [SerializeField]
    private TMP_Dropdown navigationTargetDropDown;
    [SerializeField]
    private List<Target> navigationTargetObjects = new List<Target>();


    //public Transform goal;

    private NavMeshPath path;
    private LineRenderer line;
    [SerializeField]
    private Slider yOffset;
    //[SerializeField] GameObject XROrigin;

    private Vector3 targetPosition= Vector3.zero;

    private bool lineToggle = true;



    void Start()
    {
        path=new NavMeshPath();
        line=transform.GetComponent<LineRenderer>();
        line.enabled = lineToggle;
    }

    private void Update()
    {
        
        if(lineToggle && targetPosition != Vector3.zero)
        {
            NavMesh.CalculatePath(transform.position, targetPosition,NavMesh.AllAreas,path);
            line.positionCount=path.corners.Length;
            Vector3[] calculatedPathandOffset = AddLineOffset();
            line.SetPositions(calculatedPathandOffset);
            
        }
        //if((Input.touchCount>0) && (Input.GetTouch(0).phase == TouchPhase.Began))
        //{
          //  lineToggle=!lineToggle;
        //}
        //if (lineToggle)
        //{
            //NavMesh.CalculatePath(transform.position, goal.transform.position, NavMesh.AllAreas, path);
            //line.positionCount=path.corners.Length;
            //line.SetPositions(path.corners);
          //  line.enabled=true;
           
        //}


    }

    private Vector3[] AddLineOffset()
    {
        if (yOffset.value == 0)
        {
            return path.corners;
        }
        Vector3[] calculatedLine=new Vector3[path.corners.Length];
        for(int i=0;i<path.corners.Length;i++)
        {
            calculatedLine[i] = path.corners[i] + new Vector3(0,yOffset.value,0);
        }
        return calculatedLine;
    }

    public void SetCurrentNavigationTarget(int selectedValue)
    {
        targetPosition = Vector3.zero;
        string selectedText = navigationTargetDropDown.options[selectedValue].text;
        Target currentTarget = navigationTargetObjects.Find(x=>x.Name.Equals(selectedText));
        if(currentTarget!=null)
        {
            targetPosition=currentTarget.PositionObject.transform.position;
        }
    }

    public void ToggleVisibilty()
    {
        lineToggle = !lineToggle;
        line.enabled=lineToggle;
    }
}