using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Artexacta.App.Language;
using Artexacta.App.Language.BLL;

public partial class UserControls_LanguageSelector : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
		if (!IsPostBack)
        {
            string language = Artexacta.App.Utilities.LanguageUtilities.GetLanguageFromContext().ToUpper();
            ActualLanguageHiddenField.Value = language;
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
}