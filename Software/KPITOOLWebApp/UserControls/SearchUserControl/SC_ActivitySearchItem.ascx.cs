using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Artexacta.App.PermissionObject;

public partial class UserControls_SearchUserControl_SC_ActivitySearchItem : AbstractSearchItem
{
    public string TypeControl { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        rbtnOperation.Visible = ShowAndOrButtons;
        lblSpace.Visible = !ShowAndOrButtons;
        lblTitle.Text = this._title;
        SearchDataControl.DataType = UserControls_FRTWB_SearchDataControl.AddType.ACT.ToString();
    }

    public override string GetValue()
    {
        string sentence = "";

        if (!string.IsNullOrEmpty(SearchDataControl.OrganizationId.ToString()))
        {
            if (SearchDataControl.OrganizationId > 0)
                sentence = "@organizationID " + SearchDataControl.OrganizationId.ToString();
        }

        if (!string.IsNullOrEmpty(SearchDataControl.AreaId.ToString()))
        {
            if (SearchDataControl.AreaId > 0)
                sentence += " and @areaID " + SearchDataControl.AreaId.ToString();
        }

        if (!string.IsNullOrEmpty(SearchDataControl.ProjectId.ToString()))
        {
            if (SearchDataControl.ProjectId > 0)
                sentence += " and @projectID " + SearchDataControl.ProjectId.ToString();
        }

        return sentence;
    }

    public override string GetOperation()
    {
        return rbtnOperation.SelectedValue;
    }

}