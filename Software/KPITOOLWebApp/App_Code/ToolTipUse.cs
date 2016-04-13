using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using log4net;

/// <summary>
/// Summary description for ToolTipUse
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ToolTipUse : System.Web.Services.WebService {

    private static readonly ILog log = LogManager.GetLogger("Standard");
    public ToolTipUse () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    //[WebMethod]
    //public void RegisterToolTipUse(string page, string control, string userID)
    //{
    //    int uid = 0;
    //    try
    //    {
    //        uid = Convert.ToInt32(userID);
    //    }
    //    catch { }

    //    if (uid == 0 || String.IsNullOrEmpty(page) || String.IsNullOrEmpty(control))
    //    {
    //        log.Debug("Got User ID = 0 or empty pages or controls");
    //        return;
    //    }

    //    // If the control does not end in _T then we don't control it.  It always displays 
    //    // it's tooltip
    //    if (!control.EndsWith("_T") && !control.EndsWith("_T_text"))
    //        return;

    //    if (log.IsDebugEnabled)
    //    {
    //        log.Debug("Called RegisterToolTipUse with page: " + page +
    //            ", control: " + control + ", and userID: " + userID);
    //    }

    //    try
    //    {
    //        ToolTipsDSTableAdapters.QueriesTableAdapter ta = new ToolTipsDSTableAdapters.QueriesTableAdapter();
    //        ta.AddToolTipReferenceCount(uid, page, control);
    //    }
    //    catch (Exception q)
    //    {
    //        log.Error("Failed to save tooltip reference count", q);
    //    }
    //}

    [WebMethod]
    public bool ShouldDisplayToolTip(string page, string control, string userID)
    {
        int uid = 0;
        try
        {
            uid = Convert.ToInt32(userID);
        }
        catch { }

        if (uid == 0 || String.IsNullOrEmpty(page) || String.IsNullOrEmpty(control))
        {
            log.Debug("Got User ID = 0 or empty pages or controls");
            return false;
        }

        if (log.IsDebugEnabled)
        {
            log.Debug("Called ShouldDisplayToolTip with page: " + page +
                ", control: " + control + ", and userID: " + userID);
        }

        // If the control does not end in _T then we don't control it.  It always displays 
        // it's tooltip
        if (!control.EndsWith("_T") && !control.EndsWith("_T_text"))
            return true;

        try
        {
            bool? result = false;
            ToolTipsDSTableAdapters.QueriesTableAdapter ta = new ToolTipsDSTableAdapters.QueriesTableAdapter();
            ta.ShouldDisplayToolTip(uid, page, control, ref result);

            bool allow = result == null ? false : result.Value;

            if (allow)
            {
                ToolTipsDSTableAdapters.QueriesTableAdapter theAdapter = new ToolTipsDSTableAdapters.QueriesTableAdapter();
                theAdapter.AddToolTipReferenceCount(uid, page, control);
            }

            return allow;
        }
        catch (Exception q)
        {
            log.Error("Failed to determine if a tooltip should be displayed", q);
        }

        return true;
    }
    
}
