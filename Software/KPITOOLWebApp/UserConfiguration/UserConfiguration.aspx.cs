using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using log4net;
using Artexacta.App.User;
using Artexacta.App.User.BLL;
using Artexacta.App.Utilities.SystemMessages;

public partial class User_UserConfiguration : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!User.Identity.IsAuthenticated)
            return;

        Session["LoadPage"] = Page.AppRelativeVirtualPath;

        if (!IsPostBack)
        {
            int userId = 0;

            try
            {
                userId = UserBLL.GetUserIdByUsername(HttpContext.Current.User.Identity.Name);
            }
            catch { }

            if (userId <= 0)
            {
                return;
            }

            ReLoadUserConfigurationValues(userId);
        }
    }

    protected void SaveConfiguration()
    {
        int userId = 0;

        try
        {
            userId = UserBLL.GetUserIdByUsername(HttpContext.Current.User.Identity.Name);
        }
        catch { }

        if (userId <= 0)
        {
            return;
        }

        try
        {
            UserConfiguration theConfig = new UserConfiguration();

            theConfig.UserId = userId;
            theConfig.NumberSavedSearches = Convert.ToInt32(SavedSearchesRadNumericTextBox_T.Value);
            theConfig.TimesToShowToolTips = Convert.ToInt32(DisplayToolTipsRadNumericTextBox_T.Value);


            UserConfigurationBLL.SaveUserConfiguration(theConfig);

            // Force a reload of the configuration parameters
            UserConfiguration theConf = UserConfigurationBLL.GetUserConfigurationData(true, userId);

            SystemMessages.DisplaySystemMessage("La parametros de configuracion ha sido guardados.");
        }
        catch (Exception q)
        {
            log.Error("Failed to load the User configuration data", q);
            SystemMessages.DisplaySystemErrorMessage("Ocurrio un error al guardar los parametros de configuracion");
        }

        ReLoadUserConfigurationValues(userId);
    }

    protected void SaveButton_Click(object sender, EventArgs args)
    {
        if (!IsValid)
        {
            return;
        }

        SaveConfiguration();
    }

    protected void CancelButton_Click(object sender, EventArgs args)
    {
        Response.Redirect("~/MainPage.aspx");
    }

    protected void ReLoadUserConfigurationValues(int userId)
    {
        // Load the configuration values from the database
        try
        {
            UserConfiguration theConfig = UserConfigurationBLL.GetUserConfigurationData(true, userId);

            SavedSearchesRadNumericTextBox_T.Value = Convert.ToDouble(theConfig.NumberSavedSearches);
            DisplayToolTipsRadNumericTextBox_T.Value = Convert.ToDouble(theConfig.TimesToShowToolTips);

        }
        catch (Exception q)
        {
            log.Error("Failed to retrieve User configuration data from database", q);
            SystemMessages.DisplaySystemErrorMessage("Ocurrio un error al obtener los parametros de configuracion");
        }
    }

    protected void ResetToolTipsButton_Click(object sender, EventArgs e)
    {
        int userId = 0;

        try
        {
            userId = UserBLL.GetUserIdByUsername(HttpContext.Current.User.Identity.Name);
        }
        catch { }

        if (userId <= 0)
        {
            return;
        }
        try
        {
            ToolTipsDSTableAdapters.QueriesTableAdapter ta = new ToolTipsDSTableAdapters.QueriesTableAdapter();
            ta.ResetToolTipCountForUser(userId);
            SystemMessages.DisplaySystemMessage("El uso de tooltips ha sido reestablecido.");
        }
        catch (Exception ex)
        {
            log.Error("Failed to reset tooltips use data from database", ex);
            SystemMessages.DisplaySystemErrorMessage("Ocurrio un error al Restablecer el uso de los tooltips");
        }
    }
}