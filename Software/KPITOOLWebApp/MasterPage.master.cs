using Artexacta.App.LoginSecurity;
using Artexacta.App.User.BLL;
using Artexacta.App.Utilities.VersionUtilities;
using log4net;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterPage : System.Web.UI.MasterPage
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected void Page_Load(object sender, EventArgs e)
    {
        log.Debug("############# Master Page starting Page Load #############");
        //BuildFeedbackIframeCode();

        if (!IsPostBack)
        {
            log.Debug("Page is not Postback");

            // Verify the integrity of the system
            Artexacta.App.Utilities.VersionUtilities.VersionUtilities.verifySystemVersionIntegrity();

            log.Debug("Application version is ok");

            /* 
             * Perform security validations for the page
             */

            int userID = 0;

            if (LoginSecurity.IsUserAuthenticated())
            {
                try
                {
                    userID = Artexacta.App.User.BLL.UserBLL.GetUserIdByUsername(HttpContext.Current.User.Identity.Name);
                }
                catch (Exception q)
                {
                    log.Error("Failed to get the ID of the current user", q);
                }
            }
            else
            {
                Response.Redirect("~/Authentication/Login.aspx");
            }

            CurrentUserIDHiddenField.Value = userID.ToString();

            bool userIsAdministrator = LoginSecurity.IsUserAdministrator();
            bool currentPageRoleManagement = IsCurrentPageUserOrRoleManagement();

            if (log.IsDebugEnabled)
            {
                if (userIsAdministrator)
                    log.Debug("Current user IS administrator");
                else
                    log.Debug("Current user IS NOT administrator");

                if (currentPageRoleManagement)
                    log.Debug("Current page IS Role Management");
                else
                    log.Debug("Current page IS NOT Role Management");
            }

            if (userIsAdministrator && currentPageRoleManagement)
            {
                // If the current page is the Role Management or the User Management pages then
                // the administrator user is sufficient for access to those pages.
                // Do nothing. We don't perform any further security checks.
                log.Debug("Current user is Admin and page is Role Management.  No further security checks required");
            }
            else
            {
                log.Debug("Determining if user has access to page");

                // Verify that the user has sufficient access permissions for the page.
                if (!IsUserAuthorizedPage())
                {
                    // Transfer the user to a page that tells him that he is not authorized to 
                    // see that page.
                    Response.Redirect("~/Authentication/NotAuthorized.aspx");
                }
            }

            // lblUseName.Text = HttpContext.Current.User.Identity.Name;

            LoginStatus1.LogoutText = "<i class='zmdi zmdi-run'></i> <span class='hidden-xs'>" + Resources.InitMasterPage.Logout;
            LoadMainMenuScript();
            ConstructMenu();
            ConstructFeedbackIFrame();
        }
        else
        {
            // Verify that the user has been authenticated.
            LoginSecurity.EnsureUserAuthentication();
        }

        //BuildFeedbackIframeCode();
        //LoadCalendarItems(CurrentUserIDHiddenField.Value);

        log.Debug("############# Master Page ending Page Load #############");
    }

    public void ConstructFeedbackIFrame()
    {
        bool feedbackEnabled = false;
        try
        {
            feedbackEnabled = Convert.ToBoolean(ConfigurationManager.AppSettings["FeedbackEnabled"]);
        }
        catch (Exception q)
        {
            log.Warn("Either feedbackEnabled is not defined in the web.config or has an invalid value.", q);
            feedbackEnabled = false;
        }
        if (!feedbackEnabled)
        {
            string code = "<p>" + Resources.InitMasterPage.NoFeedback + "</p>";

            FeedbackIframeCode.Text = code;
            return;
        }


        string usernameLogged = HttpContext.Current.User.Identity.Name;
        Artexacta.App.User.User objUser = null;
        try
        {
            objUser = UserBLL.GetUserByUsername(usernameLogged);
        }
        catch
        {
            log.Info("Could not load user, dealing with an anonymous user here.");
            objUser = null;
        }

        try
        {
            string username = (objUser == null ? Artexacta.App.Configuration.Configuration.GetAnonymousUser() : objUser.Username);
            string email = (objUser == null ? Artexacta.App.Configuration.Configuration.GetAnonymousEmail() : objUser.Email);
            string application = Artexacta.App.Configuration.Configuration.GetApplicationName();
            string applicationKey = Artexacta.App.Configuration.Configuration.GetApplicationKey();
            string applicationVersion = VersionUtilities.getApplicationVersionstring();

            string lang = Artexacta.App.Utilities.LanguageUtilities.GetLanguageFromContext();
            string page = Request.Url.OriginalString;
            string context = "";

            string feedbackUrl = Artexacta.App.Configuration.Configuration.GetFeedbackUrl() + "?" +
                (string.IsNullOrEmpty(application) ? "" : "appName=" + application + "&") +
                (string.IsNullOrEmpty(applicationVersion) ? "" : "appVersion=" + applicationVersion + "&") +
                (string.IsNullOrEmpty(applicationKey) ? "" : "appKey=" + applicationKey + "&") +
                (string.IsNullOrEmpty(username) ? "" : "username=" + username + "&") +
                (string.IsNullOrEmpty(email) ? "" : "email=" + email + "&") +
                (string.IsNullOrEmpty(page) ? "" : "page=" + page + "&") +
                (string.IsNullOrEmpty(lang) ? "" : "lang=" + lang + "&") +
                (string.IsNullOrEmpty(context) ? "" : "context=" + context);

            if (feedbackUrl.EndsWith("&"))
                feedbackUrl = feedbackUrl.Substring(0, feedbackUrl.Length - 1);

            string code = "<iframe src=\"" + feedbackUrl + "\" scrolling=\"auto\" " +
                "style=\"width:600px; height:400px; border:solid 1px #fff \"></iframe>";

            FeedbackIframeCode.Text = code;
        }
        catch (Exception err)
        {
            log.Error("Error forming the iframe code for the feedback call", err);
        }
    }

    private void ConstructMenu()
    {
        List<Artexacta.App.Menu.Menu> theMenu;
        List<Artexacta.App.Menu.Menu> theVisibleMenu;
        theMenu = Artexacta.App.Menu.MenuBLL.MenuBLL.ReadMenuFromXMLConfiguration();

        List<string> theClases = new List<string>();

        // We have to construct the set of "menu classes" for the user.  These will determine what
        // menus the user has access to.

        if (!LoginSecurity.IsUserAuthenticated())
        {
            Response.Redirect("~/Authentication/Login.aspx");
        }

        theClases.Add("CHANGEPASS");

        if (LoginSecurity.IsUserAuthorizedPermission("MANAGE_SECURITY"))
            theClases.Add("SECURITY");

        if (LoginSecurity.IsUserAuthorizedPermission("ADMIN_CLASIFICADORES"))
            theClases.Add("CLASIFICADORES");

        if (LoginSecurity.IsUserAuthorizedPermission("ADMIN_TESTS"))
            theClases.Add("TESTS");

        if (LoginSecurity.IsUserAuthorizedPermission("MANAGE_CATEGORIES"))
            theClases.Add("CATEGORY");

        theVisibleMenu = Artexacta.App.Menu.MenuBLL.MenuBLL.RecursiveConstructionOfVisibleMenus(theMenu, theClases);
        string visibleXML = Artexacta.App.Menu.MenuBLL.MenuBLL.GetMenuXML(theVisibleMenu, 0);
        sideMenu.Text = visibleXML;
        //MainRadMenu.LoadXml(visibleXML);
    }

    /// <summary>
    /// In the HTML header places the script tag and the script loading
    /// </summary>
    private void LoadMainMenuScript()
    {
        StringBuilder scriptText = new StringBuilder("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/jquery.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/bootstrap.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/jquery.mCustomScrollbar.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/functions.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<link rel=\"icon\" href=\"");
        scriptText.Append(ResolveUrl("~/Images/favicon.png"));
        scriptText.Append("\" type=\"image/png\" >\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/aehelper.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/toastr.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/highcharts.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/highcharts-more.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/exporting.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/jquery.sparkline.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/jquery.flot.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/jquery.flot.pie.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/jquery.flot.tooltip.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/jquery.easypiechart.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/bootstrap-tour.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/bootstrap3-typeahead.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        JqueryAndMainMenuScript.Text = scriptText.ToString();
    }

    private bool IsUserAuthorizedPage()
    {
        string currentPage = Page.Request.AppRelativeCurrentExecutionFilePath;

        // The following is a list of all the pages that are open to 
        // authenticated users.  These users do not need specific permissions
        // to access the page. 
        string[] openPages = {
             "~/MainPage.aspx",
             "~/Security/EditUser.aspx",
             "~/Test/TestUserControlForTest.aspx",
             "~/About/VersionInformation.aspx",
             "~/About/Credits.aspx",
             "~/Security/ChangePassword.aspx",
             "~/UserConfiguration/UserConfiguration.aspx",
             "~/Authentication/UserIsLocked.aspx",
             "~/Authentication/UserIsUnlocked.aspx",
             "~/Authentication/UserNotApproved.aspx",
             "~/Test/TestUpload.aspx",
             "~/Test/TestTooltip.aspx",
             "~/ResetSystem.aspx",
             "~/Test/TestAddData.aspx",
             "~/Test/TestVisitKpi.aspx",

             "~/Organization/EditOrganization.aspx",
             "~/Organization/OrganizationDetails.aspx",
             "~/Organization/ShareOrganization.aspx"

             ,"~/Project/ProjectForm.aspx"
             ,"~/Project/ProjectDetails.aspx"
             ,"~/Project/ProjectList.aspx"

             ,"~/Activity/AddActivity.aspx"
             ,"~/Activity/DetailActivity.aspx"
             ,"~/Activity/ActivitiesList.aspx"

             ,"~/Personas/ListaPersonas.aspx"

             ,"~/Kpi/KpiForm.aspx"
             ,"~/Kpis/KpiDetails.aspx"
             ,"~/Kpis/KpiDashboard.aspx"
             ,"~/Kpi/KpiList.aspx"
             ,"~/Kpi/KpiDataEntry.aspx"
        };

        for (int i = 0; i < openPages.Length; i++)
        {
            if (currentPage.Equals(openPages[i]))
                return true;
        }

        // SECURITY pages
        string[] securityPages = new string[] {
             "~/Security/AssignRoles.aspx",
             "~/Security/AssignRolesByUser.aspx",
             "~/Security/DefinePermissionsByRol.aspx",
             "~/Security/DefinePermissionsByUser.aspx",
             "~/Security/NewRole.aspx",
             "~/Security/UserList.aspx",
             "~/Security/CreateUser.aspx",
             "~/Security/UserIsLocked.aspx",
             "~/Security/UserIsUnlocked.aspx",
             "~/Bitacora/ListaEventosBitacora.aspx"
        };

        for (int i = 0; i < securityPages.Length; i++)
        {
            if (currentPage.Equals(securityPages[i]) &&
                LoginSecurity.IsUserAuthorizedPermission("MANAGE_SECURITY"))
                return true;
        }

        //CATEGORIES pages
        string[] categoriesPages = new string[]{
            "~/Category/CategoriesList.aspx",
            "~/Category/CategoryDetails.aspx"
        };

        for (int i = 0; i < categoriesPages.Length; i++)
        {
            if (currentPage.Equals(categoriesPages[i]) &&
                LoginSecurity.IsUserAuthorizedPermission("MANAGE_CATEGORIES"))
                return true;
        }

        //CLASIFICADORES pages
        string[] clasificadoresPages = new string[]{
            "~/Clasificadores/ListaDepartamentos.aspx"
        };

        for (int i = 0; i < clasificadoresPages.Length; i++)
        {
            if (currentPage.Equals(clasificadoresPages[i]) &&
                LoginSecurity.IsUserAuthorizedPermission("ADMIN_CLASIFICADORES"))
                return true;
        }

        // PERSONAS pages
        string[] personasPages = new string[]{
            "~/Seguimiento/SeguimientoCampana.aspx"
        };

        for (int i = 0; i < personasPages.Length; i++)
        {
            if (currentPage.Equals(personasPages[i]) &&
                LoginSecurity.IsUserAuthorizedPermission("ADMIN_TESTS"))
                return true;
        }

        // Nothing else worked.  The user should not be allowed to access the page.
        return false;
    }

    private bool IsCurrentPageUserOrRoleManagement()
    {
        string currentPage = Page.Request.CurrentExecutionFilePath;
        if (!String.IsNullOrEmpty(currentPage))
        {
            if (currentPage.EndsWith("Security/DefinePermissionsByRole.aspx") ||
                currentPage.EndsWith("Security/DefinePermissionsByUser.aspx"))
                return true;
            else
                return false;
        }
        else
        {
            return false;
        }
    }

    protected void LoginStatus1_LoggingOut(object sender, LoginCancelEventArgs e)
    {
        string loggedOutUser = HttpContext.Current.User.Identity.Name;
        Session["LoggedOutUser"] = loggedOutUser;
    }

}
