using Artexacta.App.Organization;
using Artexacta.App.Organization.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AddDataControl.DataType = UserControls_FRTWB_AddDataControl.AddType.KPI.ToString();
            //AddDataControl.KPIId = 312;
            DataTypeRadioButtonList.SelectedValue = AddDataControl.DataType;
        }
    }

    protected void DataTypeRadioButtonList_SelectedIndexChanged(object sender, EventArgs e)
    {
        AddDataControl.DataType = DataTypeRadioButtonList.SelectedValue;
        switch (DataTypeRadioButtonList.SelectedValue)
        {
            case "PRJ":
                NameLabel.Text = "Project name";
                break;

            case "ACT":
                NameLabel.Text = "Activity name";
                break;

            case "PPL":
                NameLabel.Text = "People name";
                break;

            case "KPI":
                NameLabel.Text = "KPI name";
                break;
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        int organizationId = AddDataControl.OrganizationId;
        int areaId = AddDataControl.AreaId;
        int projectId = AddDataControl.ProjectId;
    }

}