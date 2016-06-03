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
        PeopleSearchControl.Config = new PeopleSearch();
        PeopleSearchControl.OnSearch += new UserControls_SearchUserControl_SearchControl.OnSearchDelegate(PeopleSearchControl_OnSearch);
    }

    void PeopleSearchControl_OnSearch()
    {
        log.Debug("Binding RadGrid on Search");
    }

    protected string GetOwnerInfo(Object obj)
    {
        return "N/A";
    }

    protected void PersonaObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            SystemMessages.DisplaySystemErrorMessage("Error al obtener el listado de Personas.");
            e.ExceptionHandled = true;
        }
    }

    protected void PeopleRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {

    }
    protected void PeopleRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {

    }
}