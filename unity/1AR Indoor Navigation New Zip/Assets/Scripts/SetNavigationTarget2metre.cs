using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.UI;

public class SetNavigationTarget2metre : MonoBehaviour
{
    [SerializeField]
    private TMP_Dropdown navigationTargetDropDown;

    [SerializeField]
    private List<Target> navigationTargetObjects = new List<Target>();
    private NavMeshPath path;
    private LineRenderer line;

    [SerializeField]
    private Slider yOffset;
    private Vector3 targetPosition = Vector3.zero;
    private bool lineToggle = true;

    [SerializeField]
    private float maxLineLength = 4f;

    void Start()
    {
        path = new NavMeshPath();
        line = GetComponent<LineRenderer>();
        line.enabled = lineToggle;
    }

    void Update()
    {
        if (lineToggle && targetPosition != Vector3.zero)
        {
            if (NavMesh.CalculatePath(transform.position, targetPosition, NavMesh.AllAreas, path))
            {
                SetClampedPath();
            }
            else
            {
                line.positionCount = 0;
            }
        }
    }

    private void SetClampedPath()
    {
        if (path.corners.Length == 0)
        {
            line.positionCount = 0;
            return;
        }

        if (yOffset.value != 0)
        {
            for (int i = 0; i < path.corners.Length; i++)
            {
                path.corners[i] += new Vector3(0, yOffset.value, 0);
            }
        }

        float cumulativeDistance = 0f;
        line.positionCount = 1;
        line.SetPosition(0, path.corners[0]);

        for (int i = 0; i < path.corners.Length - 1; i++)
        {
            float segmentDistance = Vector3.Distance(path.corners[i], path.corners[i + 1]);
            if (cumulativeDistance + segmentDistance > maxLineLength)
            {
                float remainingDistance = maxLineLength - cumulativeDistance;
                Vector3 direction = (path.corners[i + 1] - path.corners[i]).normalized;
                line.positionCount++;
                line.SetPosition(
                    line.positionCount - 1,
                    path.corners[i] + direction * remainingDistance
                );
                break;
            }
            else
            {
                line.positionCount++;
                line.SetPosition(line.positionCount - 1, path.corners[i + 1]);
                cumulativeDistance += segmentDistance;
            }
        }
    }

    public void SetCurrentNavigationTarget(int selectedValue)
    {
        targetPosition = Vector3.zero;
        if (
            navigationTargetDropDown != null
            && selectedValue >= 0
            && selectedValue < navigationTargetDropDown.options.Count
        )
        {
            string selectedText = navigationTargetDropDown.options[selectedValue].text;
            SetNavigationTarget(selectedText);
        }
    }

    public void ToggleVisibility()
    {
        lineToggle = !lineToggle;
        line.enabled = lineToggle;
    }

    public void SetNavigationTargetFromFlutter(string selectedText)
    {
        SetNavigationTarget(selectedText);
        setToggleVisibility("true");
    }

    private void SetNavigationTarget(string selectedText)
    {
        targetPosition = Vector3.zero;
        if (!string.IsNullOrEmpty(selectedText))
        {
            Target currentTarget = navigationTargetObjects.Find(x => x.Name.Equals(selectedText));
            if (currentTarget != null && currentTarget.PositionObject != null)
            {
                targetPosition = currentTarget.PositionObject.transform.position;
            }
            else
            {
                Debug.LogWarning($"Target not found or invalid: {selectedText}");
            }
        }
        else
        {
            Debug.LogWarning("Selected text is null or empty");
        }
    }

    public void SetYOffset(string yOffsetValue)
    {
        if (float.TryParse(yOffsetValue, out float yOffsetFloat))
        {
            yOffset.value = yOffsetFloat;
        }
    }

    public void setToggleVisibility(string args)
    {
        lineToggle = !lineToggle;
        line.enabled = lineToggle;
    }
}
