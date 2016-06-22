using Artexacta.App.Permissions.Role.BLL;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class Security_DefinePermissionsByRol : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        HtmlForm mainform = this.Form;
        if (mainform != null)
        {
            mainform.DefaultButton = SavePermissionsButton.UniqueID;
        }
        if (!IsPostBack)
        {
            RoleDropDownList.DataBind();
        }
    }

    protected void RoleDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        RoleLabel.Text = RoleDropDownList.SelectedValue.ToString();
    }

    protected void RoleDropDownList_DataBound(object sender, EventArgs e)
    {
        RoleLabel.Text = RoleDropDownList.SelectedValue.ToString();
    }

    protected void RoleObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            log.Error("Function RoleObjectDataSource_Selected on page DefineGenericPermissionsByRole.aspx", e.Exception);
            SystemMessages.DisplaySystemMessage(Resources.SecurityData.MessageErrorGetRoles);
            e.ExceptionHandled = true;
        }
    }

    protected void PermissionObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            log.Error("Function PermissionObjectDataSource_Selected on page DefineGenericPermissionsByRole.aspx", e.Exception);
            SystemMessages.DisplaySystemMessage(Resources.SecurityData.MessageErrorGetPermissions);
            e.ExceptionHandled = true;
        }
    }

    protected void AddNewRoleLinkButton_Click(object sender, EventArgs e)
    {
        Session["NRPOSTBACKPAGE"] = "~/Security/DefinePermissionsByRol.aspx";
        Response.Redirect("~/Security/NewRole.aspx");
    }

    protected void ResetPermissionsButton_Click(object sender, EventArgs e)
    {
        RolePermissionGridView.DataBind();
    }

    protected void SavePermissionsButton_Click(object sender, EventArgs e)
    {
        PermissionRoleBLL theBLL = new PermissionRoleBLL();
        int permissionID = 0;
        try
        {
            foreach (GridViewRow row in RolePermissionGridView.Rows)
            {
                CheckBox theCheckBox = new CheckBox();
                theCheckBox = (CheckBox)row.Cells[0].FindControl("CheckBox1");

                Label thePermissionIDLabel = new Label();
                thePermissionIDLabel = (Label)row.Cells[2].FindControl("Label1");
                permissionID = Convert.ToInt32(thePermissionIDLabel.Text);
                if (theCheckBox.Checked)
                {
                    theBLL.UpdatePermissionForRole(permissionID, true, RoleDropDownList.Text);
                }
                else
                {
                    theBLL.UpdatePermissionForRole(permissionID, false, RoleDropDownList.Text);
                }
            }

            SystemMessages.DisplaySystemMessage(Resources.SecurityData.MessageRegisterPermissionsToRol);
        }
        catch (Exception q)
        {
            log.Error("No se pudieron grabar los permisos para el Rol " + RoleDropDownList.Text + ".", q);
            SystemMessages.DisplaySystemMessage(Resources.SecurityData.MessageErrorRegisterPermissionsToRol);
        }
    }

    protected void SelectAllLinkButton_Click(object sender, EventArgs e)
    {
        foreach (GridViewRow row in RolePermissionGridView.Rows)
        {
            CheckBox theCheckBox = new CheckBox();
            theCheckBox = (CheckBox)row.Cells[1].FindControl("CheckBox1");
            theCheckBox.Checked = true;
        }
    }

}