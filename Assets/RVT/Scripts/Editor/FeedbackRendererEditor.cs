﻿using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(FeedbackRenderer))]
public class FeedbackRendererEditor : Editor
{
    public override void OnInspectorGUI()
    {
        if (Application.isPlaying)
        {
            var renderer = (FeedbackRenderer)target;
            Util.DrawTexture(renderer.TargetTexture, "Feedback Texture");
        }
        else
        {
            base.OnInspectorGUI();
        }
    }
}