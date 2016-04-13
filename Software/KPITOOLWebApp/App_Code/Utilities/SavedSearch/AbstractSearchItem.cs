using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for AbstractSearchItem
/// </summary>
public abstract class AbstractSearchItem : System.Web.UI.UserControl
{
    protected string _searchColumnKey;
    protected bool _appearOperation = true;
    protected string _title = "";

    public string Title
    {
        get { return _title; }
        set { _title = value; }
    }

    public bool ShowAndOrButtons
    {
        get { return _appearOperation; }
        set { _appearOperation = value; }
    }

    public string SearchColumnKey
    {
        get { return _searchColumnKey; }
        set { _searchColumnKey = value; }
    }

    public abstract string GetValue();

    /// <summary>
    /// Returns AND or OR
    /// </summary>
    /// <returns></returns>
    public abstract string GetOperation();
}