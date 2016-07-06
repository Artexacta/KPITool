using Artexacta.App.KPI;
using Artexacta.App.KPI.BLL;
using Artexacta.App.ObjectAction;
using Artexacta.App.PermissionObject;
using Artexacta.App.PermissionObject.BLL;
using Artexacta.App.User;
using Artexacta.App.User.BLL;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Kpi_ShareKpi : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ProcessSessionParameteres();
            if (!string.IsNullOrEmpty(KPIIdHiddenField.Value))
                LoadData();
            else
                Response.Redirect("~/Kpi/KpiList.aspx");

            UserTextBox.Attributes.Add("onchange", "UserTextBox_OnChange()");
            ObjectTypeIdHiddenField.Value = PermissionObject.ObjectType.KPI.ToString();
        }
    }

    private void ProcessSessionParameteres()
    {
        if (!string.IsNullOrEmpty(Request["ID"]))
        {
            KPIIdHiddenField.Value = Request["ID"].ToString();
        }
        else if (Session["KPIID"] != null && !string.IsNullOrEmpty(Session["KPIID"].ToString()))
        {
            int kpiId = 0;
            try
            {
                kpiId = Convert.ToInt32(Session["KPIID"].ToString());
            }
            catch
            {
                log.Error("no se pudo realizar la conversion de la session kpiId:" + Session["KPIID"]);
            }

            KPIIdHiddenField.Value = kpiId.ToString();
            Session["KPIID"] = null;
        }
    }

    private void LoadData()
    {
        //-- verify is user is OWNER
        PermissionObject theUser = new PermissionObject();
        try
        {
            theUser = PermissionObjectBLL.GetPermissionsByUser(PermissionObject.ObjectType.KPI.ToString(), Convert.ToInt32(KPIIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            Response.Redirect("~/Kpi/KpiList.aspx");
        }

        if (theUser == null || !theUser.TheActionList.Exists(i => i.ObjectActionID.Equals("OWN")))
        {
            SystemMessages.DisplaySystemWarningMessage(Resources.ShareData.UserNotOwnKpi);
            Response.Redirect("~/Kpi/KpiList.aspx");
        }

        //-- show Data
        KPI theData = null;
        try
        {
            theData = KPIBLL.GetKPIById(Convert.ToInt32(KPIIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            Response.Redirect("~/Kpi/KpiList.aspx");
        }

        if (theData != null)
        {
            KPINameLiteral.Text = theData.Name;
        }
    }

    protected void ObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            SystemMessages.DisplaySystemErrorMessage(e.Exception.Message);
            e.ExceptionHandled = true;
        }
    }

    protected void PermissionsGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string userName = DataBinder.Eval(e.Row.DataItem, "UserName").ToString();
            if (userName.Equals(HttpContext.Current.User.Identity.Name))
            {
                LinkButton deleteButton = (LinkButton)e.Row.FindControl("DeleteButton");
                deleteButton.Visible = false;

                LinkButton editButton = (LinkButton)e.Row.FindControl("EditButton");
                editButton.Visible = false;
            }
        }
    }

    protected void PermissionsGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string userName = e.CommandArgument.ToString();
        if (e.CommandName.Equals("DeleteData"))
        {
            if (string.IsNullOrEmpty(userName))
            {
                try
                {
                    PermissionObjectBLL.DeleteObjectPublic(PermissionObject.ObjectType.KPI.ToString(), Convert.ToInt32(KPIIdHiddenField.Value));
                    SystemMessages.DisplaySystemMessage(Resources.ShareData.DeleteObjectPublicOk);
                }
                catch (Exception exc)
                {
                    SystemMessages.DisplaySystemErrorMessage(exc.Message);
                    return;
                }
            }
            else
            {
                try
                {
                    PermissionObjectBLL.DeleteObjectPermissions(PermissionObject.ObjectType.KPI.ToString(), Convert.ToInt32(KPIIdHiddenField.Value), userName);
                    SystemMessages.DisplaySystemMessage(Resources.ShareData.DeleteObjectPermissionsOk);
                }
                catch (Exception exc)
                {
                    SystemMessages.DisplaySystemErrorMessage(exc.Message);
                    return;
                }
            }

            PermissionsGridView.DataBind();
            ObjectActionComboBox.DataBind();
        }
    }

    protected void SaveUserButton_Click(object sender, EventArgs e)
    {
        ShowInviteUserModal.Value = "true";
        if (EveryoneCheckBox.Checked)
        {
            try
            {
                PermissionObjectBLL.InsertObjectPublic(PermissionObject.ObjectType.KPI.ToString(), Convert.ToInt32(KPIIdHiddenField.Value), ObjectActionIdHiddenField.Value);
                SystemMessages.DisplaySystemMessage(Resources.ShareData.InsertObjectPublicOk);
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
                return;
            }
        }
        else
        {
            try
            {
                PermissionObjectBLL.InsertObjectPermissions(PermissionObject.ObjectType.KPI.ToString(),
                    Convert.ToInt32(KPIIdHiddenField.Value), Convert.ToInt32(UserInvitedIdHiddenField.Value), ObjectActionIdHiddenField.Value);
                SystemMessages.DisplaySystemMessage(Resources.ShareData.InsertObjectPermissionsOk + UserTextBox.Text);
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
                return;
            }
        }

        EveryoneCheckBox.Checked = false;
        UserTextBox.Text = "";
        UserInvitedIdHiddenField.Value = "";
        ObjectActionIdHiddenField.Value = "";
        ObjectActionComboBox.DataBind();
        ShowInviteUserModal.Value = "false";
        PermissionsGridView.DataBind();
    }

    [WebMethod]
    public static bool VerifiyUser(int kpiId, int userId)
    {
        User theUser = UserBLL.GetUserById(userId);
        PermissionObject theData = PermissionObjectBLL.GetPermissionsByUser(PermissionObject.ObjectType.KPI.ToString(), kpiId, theUser.Username);
        if (theData == null)
            return false;
        else
            return true;
    }

    [WebMethod]
    public static bool VerifiyActualUser(int userId)
    {
        User theData = UserBLL.GetUserByUsername(HttpContext.Current.User.Identity.Name);
        if (theData != null && theData.UserId == userId)
            return true;
        else
            return false;
    }

}