using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Artexacta.App.Language;
using Artexacta.App.Language.BLL;
using log4net;

public partial class UserControls_LanguageSelector : System.Web.UI.UserControl
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    //public string CssClass
    //{
    //    set { ddlLanguages.CssClass = value; }
    //    get { return ddlLanguages.CssClass; }
    //}

    protected void Page_Load(object sender, EventArgs e)
    {
		if (!IsPostBack)
        {
            string language = Artexacta.App.Utilities.LanguageUtilities.GetLanguageFromContext().ToUpper();
            SelectedLanguage.Text = language;
            Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        }
    }
    protected void languagesRepeater_ItemDataBound ( object sender, RepeaterItemEventArgs e )
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            Label LanguageLinkButton = (Label)e.Item.FindControl("LanguageLinkButton");
            string languageID = DataBinder.Eval(e.Item.DataItem, "LanguageId").ToString();

            if (languageID.ToUpper() == ActualLanguageHiddenField.Value)
            {
                LanguageLinkButton.CssClass += " selected";
            }
            else
            {
                LanguageLinkButton.Attributes.Add("onclick", "LanguageSelector_ChangeLanguage('" + languageID.ToLower() + "');");
            }
        }
    }

    protected void odsLanguages_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception == null)
            return;
        e.ExceptionHandled = true;
        log.Error("Error getting language list", e.Exception);
    }

    //protected void ddlLanguages_SelectedIndexChanged(object sender, EventArgs e)
    //{
    //    string language = ddlLanguages.SelectedValue.ToLower();
    //    Artexacta.App.Utilities.LanguageUtilities.ChangeLanguageFromContext(language);

    //    Response.Redirect(Page.Request.AppRelativeCurrentExecutionFilePath);
    //}
    
    //protected void ddlLanguages_DataBound(object sender, EventArgs e)
    //{
    //    string languageSelected = Artexacta.App.Utilities.LanguageUtilities.GetLanguageFromContext();

    //    foreach (ListItem item in ddlLanguages.Items)
    //    {
    //        item.Selected = false;
    //    }

    //    foreach (ListItem item in ddlLanguages.Items)
    //    {
    //        if (item.Value.ToLower() == languageSelected.ToLower())
    //            item.Selected = true;
    //    }
    //}

    protected void LanguagesRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "SelectLanguage")
        {
            string language = e.CommandArgument.ToString().ToLower();
            Artexacta.App.Utilities.LanguageUtilities.ChangeLanguageFromContext(language);

            Response.Redirect(Page.Request.AppRelativeCurrentExecutionFilePath);
        }
    }
}