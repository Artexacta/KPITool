using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Bitacora_ListaEventosBitacora : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected void Page_Load(object sender, EventArgs e)
    {
        SearchBitacora.Config = new Artexacta.MSCRRHH.Bitacora.EventoBitacoraSearch();
        SearchBitacora.OnSearch += SearchBitacora_OnSearch;

        if (!IsPostBack)
        {
            SearchBitacora.Query = enlaceRapidoBusqueda.SelectedValue;
        }
    }

    void SearchBitacora_OnSearch()
    {

    }

    

    protected void Pager_PageChanged(int row)
    {
        ;
    }

    protected void enlaceRapidoBusqueda_SelectedIndexChanged(object sender, EventArgs e)
    {
        SearchBitacora.Query = enlaceRapidoBusqueda.SelectedValue;

        BitacoraGridView.DataBind();
    }

    protected void BitacoraDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            log.Error("Ocurrio un error al tratar de obtener la lista de eventos", e.Exception);
            SystemMessages.DisplaySystemErrorMessage("Ocurrio un error al obtener la lista de Eventos");
            e.ExceptionHandled = true;
        }
        int totalRows = 0;
        try
        {
            totalRows = Convert.ToInt32(e.OutputParameters["totalRows"]);
        }
        catch (Exception ex)
        {
            log.Error("Failed to get OuputParameter 'totalRows'", ex);
        }
        Pager.TotalRows = totalRows;
        if (totalRows == 0)
        {
            Pager.Visible = false;
            return;
        }
        Pager.Visible = true;
        Pager.BuildPagination();
    }
}