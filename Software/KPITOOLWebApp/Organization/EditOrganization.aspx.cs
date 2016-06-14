﻿using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Artexacta.App.Organization.BLL;
using Artexacta.App.Organization;
using Artexacta.App.Area.BLL;
using Artexacta.App.Area;

public partial class Organization_EditOrganization : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    public int OrganizationId
    {
        set { OrganizationIdHiddenField.Value = value.ToString(); }
        get
        {
            int id = 0;
            try
            {
                id = Convert.ToInt32(OrganizationIdHiddenField.Value);
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert OrganizationIdHiddenField.Value to integer value", ex);
            }
            return id;
        }
    }

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ProcessSessionParametes();

            int organizationId = this.OrganizationId;

            if (organizationId <= 0)
            {
                Response.Redirect("~/MainPage.aspx");
                return;
            }

            Organization organization = null;
            try
            {
                organization = OrganizationBLL.GetOrganizationById(organizationId);
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
                return;
            }

            if (organization != null)
            {
                OrganizationNameLit.Text = organization.Name;
                OrganizationNameTextBox.Text = organization.Name;
                AreasGridView.DataBind();
            }
        }
    }

    private void ProcessSessionParametes()
    {
        if (Session["OrganizationId"] != null && !string.IsNullOrEmpty(Session["OrganizationId"].ToString()))
        {
            int id = 0;
            try
            {
                id = Convert.ToInt32(Session["OrganizationId"].ToString());
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert Session['OrganizationId'] to integer value", ex);
            }
            OrganizationId = id;
        }
        Session["OrganizationId"] = null;
    }


    protected void DeleteArea_Click(object sender, EventArgs e)
    {
        LinkButton btnClick = (LinkButton)sender;
        int areaId = Convert.ToInt32(btnClick.Attributes["data-id"]);

        try
        {
            AreaBLL.DeleteArea(areaId);
        }
        catch (Exception ex)
        {
            SystemMessages.DisplaySystemErrorMessage(ex.Message);
            return;
        }

        AreasGridView.DataBind();

        SystemMessages.DisplaySystemMessage(Resources.Organization.MessageDeleteAreaOk);
    }
    protected void AddArea_Click(object sender, EventArgs e)
    {
        try
        {
            AreaBLL.InsertArea(OrganizationId, AreaName.Text);
        }
        catch (Exception ex)
        {
            SystemMessages.DisplaySystemErrorMessage(ex.Message);
            return;
        }

        AreasGridView.DataBind();

        SystemMessages.DisplaySystemMessage("New Area was added to current Organization");
    }

    protected void SaveOrganizationButton_Click(object sender, EventArgs e)
    {
        //Create the organizacion in the database
        if (OrganizationId == 0)
        {
            try
            {
                OrganizationBLL.InsertOrganization(OrganizationNameTextBox.Text);
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
                return;
            }
            SystemMessages.DisplaySystemMessage(Resources.Organization.MessageCreateOk);
        }
        else
        {
            try
            {
                OrganizationBLL.UpdateOrganization(OrganizationId, OrganizationNameTextBox.Text);
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
                return;
            }
            SystemMessages.DisplaySystemMessage(Resources.Organization.MessageUpdateOk);
        }

        Response.Redirect("~/MainPage.aspx");
    }
    protected void AreasObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            e.ExceptionHandled = true;
            SystemMessages.DisplaySystemErrorMessage(Resources.Organization.MessageErrorCargarAreas);
        }
    }

    protected void AreasGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Actualizar")
        {
            int areaId = 0;
            try
            {
                areaId = Convert.ToInt32(e.CommandArgument);
            }
            catch (Exception ex)
            {
                log.Error("Error getting object id", ex);
            }

            if (areaId <= 0)
            {
                SystemMessages.DisplaySystemErrorMessage("Could not complete the requested action");
                return;
            }

            GridViewRow oItem = (GridViewRow)((LinkButton)e.CommandSource).NamingContainer;

            if (oItem == null)
            {
                SystemMessages.DisplaySystemErrorMessage("Could not complete the requested action");
                return;
            }

            TextBox nameTextBox = (TextBox)oItem.Cells[2].FindControl("NameTextBox");

            if (nameTextBox == null)
            {
                SystemMessages.DisplaySystemErrorMessage("Could not complete the requested action");
                return;
            }

            try
            {
                AreaBLL.UpdateArea(areaId, nameTextBox.Text);
            }
            catch
            {
                SystemMessages.DisplaySystemErrorMessage("Error al actualizar el area.");
                return;
            }

            Session["OrganizationId"] = OrganizationIdHiddenField.Value;
            Response.Redirect("~/Organization/EditOrganization.aspx");
        }
        else if (e.CommandName == "Eliminar")
        {
            int areaId = 0;

            try
            {
                areaId = Convert.ToInt32(e.CommandArgument);
            }
            catch (Exception ex)
            {
                log.Error("Error getting object id", ex);
            }

            if (areaId <= 0)
            {
                SystemMessages.DisplaySystemErrorMessage("Could not complete the requested action");
                return;
            }

            try
            {
                AreaBLL.DeleteArea(areaId);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }

            Session["OrganizationId"] = OrganizationIdHiddenField.Value;
            Response.Redirect("~/Organization/EditOrganization.aspx");
        }

    }

    protected void AreasGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            LinkButton buttonDelete = (LinkButton)e.Row.Cells[1].FindControl("DeleteArea");
            if (buttonDelete != null)
                buttonDelete.OnClientClick = String.Format("return confirm('{0}')", Resources.Organization.MessageDeleteArea);
        }
    }
}