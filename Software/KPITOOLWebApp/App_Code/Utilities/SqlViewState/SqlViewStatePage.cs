using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.IO;
using System.Globalization;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Web.UI.HtmlControls;
using Artexacta.App.ViewStateSql.BLL;
using Artexacta.App.ViewStateSql;
using Artexacta.App.Configuration;

/// <summary>
/// Summary description for SqlViewStatePage
/// </summary>
public class SqlViewStatePage : Page
{
    protected bool IsDesignMode
    {
        get { return (this.Context == null); }
    }

    public SqlViewStatePage()
        : base()
    {
        if (this.IsDesignMode)
            return;
    }

    protected override object LoadPageStateFromPersistenceMedium()
    {
        Guid viewStateGuid;
        object theViewState = null;

        if (this.IsDesignMode)
            return null;
        
        viewStateGuid = this.GetViewStateGuid();
        ViewStateSql obj = ViewStateSqlBLL.GetViewStateSql(viewStateGuid);

        if (obj == null)
            return theViewState;

        using (MemoryStream stream = new MemoryStream(obj.Value)) {
            theViewState = this.GetLosFormatter().Deserialize(stream);
        }
        return theViewState;
    }

    protected override void SavePageStateToPersistenceMedium(object viewState)
    {
        Guid viewStateGuid;
        HtmlInputHidden control;
        byte[] viewStateArray = null;

        if (this.IsDesignMode)
            return;
        
        viewStateGuid = this.GetViewStateGuid();

        using (MemoryStream stream = new MemoryStream())
        {
            this.GetLosFormatter().Serialize(stream, viewState);
            viewStateArray = stream.ToArray();
        }

        ViewStateSql obj = new ViewStateSql(viewStateGuid, viewStateArray, Artexacta.App.Configuration.Configuration.GetViewStateExpirationForDataBase());
        ViewStateSqlBLL.Insert(obj);

        control = this.FindControl("__VIEWSTATEGUID") as HtmlInputHidden;

        if (control == null)
            ClientScript.RegisterHiddenField("__VIEWSTATEGUID", viewStateGuid.ToString());
        else
            control.Value = viewStateGuid.ToString();
    }

    #region Needded by page
    private string GetMacKeyModifier()
    {
        int value = this.TemplateSourceDirectory.GetHashCode() + this.GetType().Name.GetHashCode();

        if (this.ViewStateUserKey != null)
            return string.Concat(value.ToString(NumberFormatInfo.InvariantInfo), this.ViewStateUserKey);
        
        return value.ToString(NumberFormatInfo.InvariantInfo);
    }

    private LosFormatter GetLosFormatter()
    {
        if (this.EnableViewStateMac)
            return new LosFormatter(true, this.GetMacKeyModifier());

        return new LosFormatter();
    }

    private Guid GetViewStateGuid()
    {
        string viewStateKey;
        viewStateKey = this.Request.Form["__VIEWSTATEGUID"];

        if (viewStateKey == null || viewStateKey.Length < 1)
        {
            viewStateKey = this.Request.QueryString["__VIEWSTATEGUID"];
            if (viewStateKey == null || viewStateKey.Length < 1)
                return Guid.NewGuid();
        }

        try
        {
            return new Guid(viewStateKey);
        }
        catch (FormatException)
        {
            return Guid.NewGuid();
        }
    }
    #endregion
}