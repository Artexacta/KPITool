using Artexacta.App.Permissions.User.BLL;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class Security_DefinepermissionsByUser : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected void Page_Load(object sender, EventArgs e)
    {
        //Make the Search button the default button for the page
        HtmlForm mainform = this.Form;
        if (mainform != null)
        {
            mainform.DefaultButton = SubmitButton.UniqueID;
        }
    }

    protected void BindData()
    {
        log.Debug("Binding the employee Grid view. Function BindData from DefinePermissionsByUser.apsx page");
        EmployeeGridView.DataBind();
    }

    protected void EmployeeGridView_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (EmployeeGridView.SelectedIndex > -1)
        {
            string employeeID = "";
            log.Debug("Getting DataKeys from User GridView. Function EmployeeGridView_SelectedIndexChanged from DefinePermissionsByUser.aspx page");
            DataKey DataKeyData = EmployeeGridView.DataKeys[EmployeeGridView.SelectedIndex];
            employeeID = DataKeyData.Values["UserId"].ToString();
            SelectedUserIdHiddenField.Value = employeeID;
            UserLabel.Text = DataKeyData.Values["FullName"].ToString();
            PermissionPanel.Visible = true;
            SelectLabel.Visible = false;
            ChangingLabel.Visible = true;
        }
    }

    protected void EmployeeGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
    }

    protected void UserObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            log.Error("Function UserObjectDataSource_Selected on page DefinePermissionsByUser.aspx", e.Exception);
            SystemMessages.DisplaySystemMessage("No se pudo obtener información de usuarios desde la base de datos.");
            EmployeeGridView.Visible = false;
            e.ExceptionHandled = true;
        }
    }

    protected void UserPermissionsObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            log.Error("Function UserPermissionsObjectDataSource_Selected on page DefinePermissionsByUser.aspx", e.Exception);
            SystemMessages.DisplaySystemMessage("No se pudo obtener información de permisos de usuarios desde la base de datos.");
            e.ExceptionHandled = true;
        }
    }

    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        FullnameHiddenField.Value = FullnameTextBox.Text.Trim();
        UserNameHiddenField.Value = UserNameTextBox.Text.Trim(); ;
        BindData();
        PermissionPanel.Visible = false;
        EmployeeGridView.Visible = true;
    }

    protected void EmployeeGridView_DataBound(object sender, EventArgs e)
    {
        if (EmployeeGridView.Rows.Count > 0)
        {
            SelectLabel.Visible = true;
            EmployeeGridView.Visible = true;
        }
    }

    protected void ResetButton_Click(object sender, EventArgs e)
    {
        EmployeePermissionsGridView.DataBind();
    }

    protected void SavePermissionsButton_Click(object sender, EventArgs e)
    {
        PermissionUserBLL theBLL = new PermissionUserBLL();
        int permissionID = 0;
        int userId = 0;
        try
        {
            foreach (GridViewRow row in EmployeePermissionsGridView.Rows)
            {
                CheckBox theCheckBox = new CheckBox();
                theCheckBox = (CheckBox)row.Cells[2].FindControl("CheckBox1");

                Label thePermissionIDLabel = new Label();
                thePermissionIDLabel = (Label)row.Cells[1].FindControl("PermissionIDLabel");

                Label theUserIDLabel = new Label();
                theUserIDLabel = (Label)row.Cells[2].FindControl("UserIDLabel");


                permissionID = Convert.ToInt32(thePermissionIDLabel.Text);
                userId = Convert.ToInt32(theUserIDLabel.Text);

                if (theCheckBox.Checked)
                {
                    theBLL.UpdatePermissionForUser(permissionID, true, userId);
                }
                else
                {
                    theBLL.UpdatePermissionForUser(permissionID, false, userId);
                }
            }
            SystemMessages.DisplaySystemMessage("Se grabaron los permisos para el Usuario: " + UserLabel.Text + ".");
        }
        catch (Exception q)
        {
            log.Error("No se pudieron grabar los permisos para el Usuario " + EmployeeGridView.SelectedValue.ToString() + ".", q);
            SystemMessages.DisplaySystemMessage("No se pudieron grabar los permisos para el Usuario " + EmployeeGridView.SelectedValue.ToString() + ".");
        }
    }

    protected void SelectAllLinkButton_Click(object sender, EventArgs e)
    {
        foreach (GridViewRow row in EmployeePermissionsGridView.Rows)
        {
            CheckBox theCheckBox = new CheckBox();
            theCheckBox = (CheckBox)row.Cells[2].FindControl("CheckBox1");
            theCheckBox.Checked = true;
        }
    }

}