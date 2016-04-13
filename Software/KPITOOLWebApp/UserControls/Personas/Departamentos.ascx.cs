using Artexacta.App.PersonaDepartamento;
using Artexacta.App.PersonaDepartamento.BLL;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

public partial class UserControls_Personas_Departamentos : System.Web.UI.UserControl
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public int PersonaId
    {
        get { return Convert.ToInt32(PersonaIdHiddenField.Value); }
        set { PersonaIdHiddenField.Value = value.ToString(); }
    }

    protected void PersonaDepartamentosObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            SystemMessages.DisplaySystemErrorMessage("Error al cargar los datos de los Departamentos de la Persona.");
            log.Error("Function PersonaDepartamentosObjectDataSource_Selected on page Departamentos.ascx", e.Exception);
            e.ExceptionHandled = true;
        }
    }

    protected void DepartamentoObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            SystemMessages.DisplaySystemErrorMessage("Error al cargar los datos de Departamentos.");
            log.Error("Function DepartamentoObjectDataSource_Selected on page Departamentos.ascx", e.Exception);
            e.ExceptionHandled = true;
        }
    }

    protected void RegistrarLinkButton_Click(object sender, EventArgs e)
    {
        PersonaDepartamento theData = new PersonaDepartamento();
        theData.PersonaId = PersonaId;
        theData.Cargo = CargoTextBox.Text;

        if (DepartamentoIdHiddenField.Value.Equals(""))
        {
            try
            {
                theData.DepartamentoId = Convert.ToInt32(DepartamentoComboBox.SelectedValue);
                PersonaDepartamentoBLL.InsertRecord(theData);
                SystemMessages.DisplaySystemMessage("Se registró correctamente la información.");
            }
            catch
            {
                log.Error("Error al registrar el departamentoId: " + theData.DepartamentoId + " para la personaId: " +
                    theData.PersonaId + " en Departamento.ascx");
                SystemMessages.DisplaySystemErrorMessage("Error al registrar la información.");
            }
        }
        else
        {
            try
            {
                theData.DepartamentoId = Convert.ToInt32(DepartamentoIdHiddenField.Value);
                PersonaDepartamentoBLL.UpdateRecord(theData);
                SystemMessages.DisplaySystemMessage("Se actualizó correctamente la información.");
            }
            catch
            {
                log.Error("Error al actualizar la información del departamentoId: " + theData.DepartamentoId + " para la personaId: " +
                    theData.PersonaId + " en Departamento.ascx");
                SystemMessages.DisplaySystemErrorMessage("Error al actualizar la información.");
            }
        }

        ShowDepartamentoModalHiddenField.Value = "false";
        DepartamentoIdHiddenField.Value = "";
        DepartamentoRadGrid.DataBind();

        CargoTextBox.Text = "";
        DepartamentoComboBox.ClearSelection();
    }

    protected void DepartamentoRadGrid_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            int departamentoId = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["DepartamentoId"]);

            if (e.CommandName.Equals("Edit"))
            {
                e.Canceled = true;
                e.Item.Selected = true;

                string cargo = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["Cargo"].ToString();

                CargoTextBox.Text = cargo;
                DepartamentoComboBox.SelectedValue = departamentoId.ToString();
                DepartamentoComboBox.Enabled = false;
                ShowDepartamentoModalHiddenField.Value = "true";
                DepartamentoIdHiddenField.Value = departamentoId.ToString();
                this.Page.ClientScript.RegisterStartupScript(this.GetType(), "Javascript", "openAddModal();", true);
            }
            else if (e.CommandName.Equals("Delete"))
            {
                try
                {
                    PersonaDepartamentoBLL.DeleteRecord(PersonaId, departamentoId);
                    SystemMessages.DisplaySystemMessage("Se eliminó correctamente la información del cargo.");
                }
                catch (Exception exc)
                {
                    log.Error("Error al eliminar la informacion del departamentoId: " + departamentoId + " para la personaId: " + PersonaId, exc);
                    SystemMessages.DisplaySystemErrorMessage("Error al eliminar la información del cargo seleccionado.");
                }

                DepartamentoRadGrid.DataBind();
            }
        }
    }
}