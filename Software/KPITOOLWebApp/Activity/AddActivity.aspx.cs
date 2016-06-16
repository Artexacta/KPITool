using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Artexacta.App.Activities.BLL;
using Artexacta.App.Activities;

public partial class Activity_AddActivity : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    public int ActivityId
    {
        set { ActivityIdHiddenField.Value = value.ToString(); }
        get
        {
            int activityId = 0;
            try
            {
                activityId = Convert.ToInt32(ActivityIdHiddenField.Value);
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert ActivityIdHiddenField.Value to integer value", ex);
            }
            return activityId;
        }
    }

    private Artexacta.App.FRTWB.Activity currentObject;

    public string ParentPage
    {
        set { ParentPageHiddenField.Value = value; }
        get { return string.IsNullOrEmpty(ParentPageHiddenField.Value) ? "~/MainPage.aspx" : ParentPageHiddenField.Value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;

        AddDataControl.DataType = UserControls_FRTWB_AddDataControl.AddType.ACT.ToString();
        ProcessSessionParametes();
        LoadActivityData();
    }

    private void ProcessSessionParametes()
    {
        if (Session["ParentPage"] != null && !string.IsNullOrEmpty(Session["ParentPage"].ToString()))
        {
            ParentPage = Session["ParentPage"].ToString();
        }
        Session["ParentPage"] = null;

        if (Session["ActivityId"] != null && !string.IsNullOrEmpty(Session["ActivityId"].ToString()))
        {
            int activityId = 0;
            try
            {
                activityId = Convert.ToInt32(Session["ActivityId"].ToString());
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert Session['ActivityId'] to integer value", ex);
            }
            ActivityId = activityId;
        }
        Session["ActivityId"] = null;
    }

    private void LoadActivityData()
    {
        int activityId = ActivityId;
        if (activityId <= 0)
            return;

        Activity theClass = null;

        try
        {
            theClass = ActivityBLL.GetActivityById(activityId);
        }
        catch
        {
            SystemMessages.DisplaySystemErrorMessage("Error to get the activity information.");
            return;
        }

        if (theClass != null)
        {
            TitleLiteral.Text = theClass.Name;
            ActivityNameTextBox.Text = theClass.Name;
            AddDataControl.OrganizationId = theClass.OrganizationID;
            AddDataControl.AreaId = theClass.AreaID;
            AddDataControl.ProjectId = theClass.ProjectID;
        }
    }


    protected void SaveButton_Click(object sender, EventArgs e)
    {
        Activity theClass = new Activity();

        theClass.Name = ActivityNameTextBox.Text;
        theClass.OrganizationID = AddDataControl.OrganizationId;
        theClass.AreaID = AddDataControl.AreaId;
        theClass.ProjectID = AddDataControl.ProjectId;

        if (ActivityId == 0)
        {
            //Insert
            try
            {
                ActivityBLL.InsertActivity(theClass);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }
            SystemMessages.DisplaySystemMessage("The activity was created successfully.");
        }
        else
        {
            // Update
            theClass.ActivityID = ActivityId;
            try
            {
                ActivityBLL.UpdateActivity(theClass);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }
            SystemMessages.DisplaySystemMessage("The activity was updated successfully.");
        }
        Response.Redirect(ParentPage);
    }

    protected void CancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect(ParentPage);
    }
}