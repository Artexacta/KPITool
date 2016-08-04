<%@ WebHandler Language="C#" Class="TourHandler" %>

using System;
using System.Web;
using log4net;

public class TourHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        ILog log = LogManager.GetLogger("Standard");
        string strUserId = context.Request.Params["userId"];
        string tourId = context.Request.Params["tourId"];

        int userId = 0;
        try
        {
            userId = Convert.ToInt32(strUserId);
        }
        catch (Exception ex)
        {
            log.Error("Error trying to convert request param to integer value", ex);
        }

        try
        {
            Artexacta.App.Tour.TourBLL.SetUserTourStatus(userId, tourId);
        }
        catch (Exception ex)
        {
            log.Error("Error trying to convert request param to integer value", ex);
        }

    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}