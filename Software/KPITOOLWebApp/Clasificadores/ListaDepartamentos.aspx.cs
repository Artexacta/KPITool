using Artexacta.App.Departamento;
using Artexacta.App.Departamento.BLL;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Clasificadores_ListaDepartamentos : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void DepartamentoObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            SystemMessages.DisplaySystemErrorMessage("Error al obtener el listado de Departmentos.");
            log.Error("Function DepartamentoObjectDataSource_Selected on page ListaDepartamentos.aspx", e.Exception);
            e.ExceptionHandled = true;
        }
    }
    protected void DepartamentoGridView_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (DepartamentoGridView.SelectedDataKey == null)
        {
            return;
        }

        int idDpto = (int)DepartamentoGridView.SelectedDataKey.Value;
        if (OperationHiddenField.Value == "EDIT")
        {
            Departamento dpto = DepartamentoBLL.GetRecordById(idDpto);
            SelectedDpto.Value = idDpto.ToString();
            EditTextbox.Text = dpto.Nombre;
            EditTextbox.DataBind();
            this.ClientScript.RegisterStartupScript(this.GetType(), "Javascript", "openEditModal();", true);
        }
        else if (OperationHiddenField.Value == "DELETE")
        {
            try
            {
                DepartamentoBLL.DeleteRecord(idDpto);
                DepartamentoGridView.DataBind();
            }
            catch (Exception q)
            {
                log.Error("Error al eliminar el Departamento: " + q.Message);
                SystemMessages.DisplaySystemMessage("Error al eliminar el departamento.");
            }
        }
    }

    protected void EditImageButton_Click(object sender, EventArgs e)
    {
        OperationHiddenField.Value = "EDIT";
    }

    protected void DeleteImageButton_Click(object sender, EventArgs e)
    {
        OperationHiddenField.Value = "DELETE";
    }
    protected void saveEdit_Click(object sender, EventArgs e)
    {
        Departamento editDpto = new Departamento();
        editDpto.DepartamentoId = Convert.ToInt32(SelectedDpto.Value);
        editDpto.Nombre = EditTextbox.Text;
        try
        {
            DepartamentoBLL.UpdateRecord(editDpto);
            DepartamentoGridView.DataBind();
        }
        catch (Exception q)
        {
            log.Error("Error al actualizar el Departamento: " + q.Message);
            SystemMessages.DisplaySystemMessage("Error al actualizar el departamento.");
        }
    }
    protected void saveDepartment_Click(object sender, EventArgs e)
    {
        Departamento newDpto = new Departamento();
        newDpto.Nombre = NombreTextbox.Text;
        try
        {
            DepartamentoBLL.InsertRecord(newDpto);
            DepartamentoGridView.DataBind();
        }
        catch (Exception q)
        {
            log.Error("Error al insertar el Departamento: " + q.Message);
            SystemMessages.DisplaySystemMessage("Error al insertar el departamento.");
        }
    }
}