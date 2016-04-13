using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Artexacta.App.LoginSecurity;
using Artexacta.App.User.BLL;

public partial class UserControls_ToolTipManager_ToolTipManager : System.Web.UI.UserControl
{

    public string NoApplyToSelector
    {
        set { ExcludeSelectorLabel.Text = value; }
        get { return string.IsNullOrEmpty(ExcludeSelectorLabel.Text) ? ExcludeSelectorLabel.Text : "," + ExcludeSelectorLabel.Text; }
    }

    public string ShouldDisplayToolTipWS
    {
        set { ShouldDisplayToolTipWSHiddenLabel.Text = value; }
        get { return ShouldDisplayToolTipWSHiddenLabel.Text; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;

        int userId = 0;
        if (LoginSecurity.IsUserAuthenticated())
        {
            try 
	        {
                userId = UserBLL.GetUserIdByUsername(HttpContext.Current.User.Identity.Name);
	        }
	        catch (Exception)
	        {
		
	        }
                    
        }
        UserIdHiddenLabel.Text = userId.ToString();
    }

    protected string GetShouldDisplayToolTipWS()
    {
        return ResolveClientUrl(ShouldDisplayToolTipWS);
    }

    protected string GetCurrentPage()
    {
        string url = Request.Url.AbsolutePath;
        string appPath = Request.ApplicationPath;
        return url.Replace(appPath + "/", "");
    }
}