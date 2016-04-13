using Artexacta.App.Persona.BLL;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

public partial class Personas_ListaPersonas : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected void Page_Load(object sender, EventArgs e)
    {
        PersonaSearchControl.Config = new PersonaSearch();
        PersonaSearchControl.OnSearch += new UserControls_SearchUserControl_SearchControl.OnSearchDelegate(PersonaSearchControl_OnSearch);
    }

    void PersonaSearchControl_OnSearch()
    {
        log.Debug("Binding RadGrid on Search");
        log.Debug(PersonaSearchControl.Sql);
    }

    protected void PersonaObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            SystemMessages.DisplaySystemErrorMessage("Error al obtener el listado de Personas.");
            log.Error("Function PersonaObjectDataSource_Selected on page ListaPersonas.aspx", e.Exception);
            e.ExceptionHandled = true;
        }
    }

    protected void NewButton_Click(object sender, EventArgs e)
    {
        Session["PERSONAID"] = 0;
        Response.Redirect("~/Personas/RegistroPersonas.aspx");
    }

    protected void PersonaRadGrid_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            int personaId = (int)e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PersonaId"];

            switch (e.CommandName)
            {
                case "Edit":
                    Session["PERSONAID"] = personaId;
                    Response.Redirect("~/Personas/RegistroPersonas.aspx");
                    break;

                case "Delete":
                    try
                    {
                        PersonaBLL.DeleteRecord(personaId);
                        SystemMessages.DisplaySystemMessage("Se eliminó correctamente la información de la Persona.");
                    }
                    catch
                    {
                        SystemMessages.DisplaySystemErrorMessage("Error al eliminar la información de la Persona.");
                    }

                    PersonaRadGrid.DataBind();
                    break;
            }
        }
        else if (e.Item is GridCommandItem && e.CommandName == RadGrid.ExportToExcelCommandName)
        {
            PersonaRadGrid.MasterTableView.GetColumn("EditCommandColumn").Visible = false;
            PersonaRadGrid.MasterTableView.GetColumn("DeleteCommandColumn").Visible = false;
        }
    }

}