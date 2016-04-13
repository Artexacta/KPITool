using Artexacta.App.Persona;
using Artexacta.App.Persona.BLL;
using Artexacta.App.User;
using Artexacta.App.Utilities.SystemMessages;
using Artexacta.MSCRRHH.Utilities.Bitacora;
using log4net;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

public partial class Personas_RegistroPersonas : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");
    private static Artexacta.MSCRRHH.Utilities.Bitacora.Bitacora theBitacora = new Bitacora();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ProcessSessionParameteres();
            if (!string.IsNullOrEmpty(PersonaIdHiddenField.Value))
            {
                cargarDatos();
            }
        }
    }

    private void ProcessSessionParameteres()
    {
        int personaId = 0;
        if (Session["PERSONAID"] != null && !string.IsNullOrEmpty(Session["PERSONAID"].ToString()))
        {
            try
            {
                personaId = Convert.ToInt32(Session["PERSONAID"]);
            }
            catch
            {
                log.Error("no se pudo realizar la conversion de la session personaId:" + Session["PERSONAID"]);
            }

            if (personaId > 0)
            {
                PersonaIdHiddenField.Value = personaId.ToString();
            }
        }
        else
        {
            Response.Redirect("~/Personas/ListaPersonas.aspx");
        }
        Session["PERSONAID"] = null;
    }

    private void cargarDatos()
    {
        Persona theData = null;
        try
        {
            theData = PersonaBLL.GetRecordById(Convert.ToInt32(PersonaIdHiddenField.Value));
        }
        catch
        {
            log.Error("Error al obtener la información de la Persona en RegistroPersonas.aspx");
        }

        if (theData == null)
        {
            SystemMessages.DisplaySystemErrorMessage("Error al obtener la información de la Persona.");
            Response.Redirect("~/Personas/ListaPersonas.aspx");
        }

        NombreTextBox.Text = theData.Nombre;
        EmailTextBox.Text = theData.Email;

        if (theData.FechaNacimiento != DateTime.MinValue)
            FechaRadDatePicker.SelectedDate = theData.FechaNacimiento;

        if (!string.IsNullOrEmpty(theData.EstadoCivil))
            EstadoCivilComboBox.SelectedValue = theData.EstadoCivil;

        if (!string.IsNullOrEmpty(theData.Genero))
            GeneroRadioButtonList.SelectedValue = theData.Genero;

        SalarioTextBox.Value = Convert.ToDouble(theData.Salario);

        if (!string.IsNullOrEmpty(theData.PaisId))
        {
            RadComboBoxItem itemCombo = new RadComboBoxItem(theData.PaisForDisplay, theData.PaisId);
            PaisRadComboBox.Items.Add(itemCombo);
            PaisRadComboBox.SelectedValue = itemCombo.Value;
        }

        PersonaDepartamentoControl.PersonaId = theData.PersonaId;
        PersonaDepartamentoControl.Visible = true;
    }

    protected void SaveLinkButton_Click(object sender, EventArgs e)
    {
        Persona theData = new Persona();

        theData.Nombre = NombreTextBox.Text;
        theData.Email = EmailTextBox.Text;

        if (FechaRadDatePicker.SelectedDate != null)
            theData.FechaNacimiento = Convert.ToDateTime(FechaRadDatePicker.SelectedDate);
        else
            theData.FechaNacimiento = DateTime.MinValue;

        if (!string.IsNullOrEmpty(PaisRadComboBox.SelectedValue))
            theData.PaisId = PaisRadComboBox.SelectedValue;
        else
            theData.PaisId = "";

        if (!string.IsNullOrEmpty(EstadoCivilComboBox.SelectedValue))
            theData.EstadoCivil = EstadoCivilComboBox.SelectedValue;
        else
            theData.EstadoCivil = "";

        if (!string.IsNullOrEmpty(GeneroRadioButtonList.SelectedValue))
            theData.Genero = GeneroRadioButtonList.SelectedValue;
        else
            theData.Genero = "";

        theData.Salario = Convert.ToDecimal(SalarioTextBox.Text.Trim().Replace(',', '.'), CultureInfo.InvariantCulture);

        if (PersonaIdHiddenField.Value.Equals("") || PersonaIdHiddenField.Value.Equals("0"))
        {
            try
            {
                theData.PersonaId = PersonaBLL.InsertRecord(theData);
                SystemMessages.DisplaySystemMessage("Se registró correctamente la información.");
                Artexacta.App.User.User user = new User();
                user = Artexacta.App.User.BLL.UserBLL.GetUserByUsername(HttpContext.Current.User.Identity.Name);
                theBitacora.RecordTrace(Bitacora.TraceType.RegisterPerson, user.Username, "Seguridad", user.UserId.ToString(), "Se registro a la Persona " + theData.Nombre);
            }
            catch
            {
                log.Error("Error al insertar nueva Persona en RegistroPersona.aspx");
                SystemMessages.DisplaySystemErrorMessage("Ocurrió un error al registrar la persona.");
                return;
            }

            Session["PERSONAID"] = theData.PersonaId;
            Response.Redirect("~/Personas/RegistroPersonas.aspx");
        }
        else
        {
            theData.PersonaId = Convert.ToInt32(PersonaIdHiddenField.Value);
            try
            {
                PersonaBLL.UpdateRecord(theData);
                SystemMessages.DisplaySystemMessage("Se actualizó correctamente la información.");
            }
            catch
            {
                log.Error("Error al actualizar el dato Persona en RegistroPersona.aspx");
                SystemMessages.DisplaySystemErrorMessage("Ocurrió un error al actualizar la información de la persona.");
                return;
            }

            Response.Redirect("~/Personas/ListaPersonas.aspx");
        }
    }

    protected void CancelLinkButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Personas/ListaPersonas.aspx");
    }

    [WebMethod]
    public static bool verificarExisteEmail(string email, int personaId)
    {
        bool existcodigo = false;
        Persona theData = null;
        try
        {
            theData = PersonaBLL.GetRecordByEmail(email);
            if (theData == null)
            {
                existcodigo = true;
            }
            else
            {
                if (theData.PersonaId == personaId)
                    existcodigo = true;
                else
                    existcodigo = false;
            }
        }
        catch
        {
            log.Error("Error al validar existencia de email en RegistroPersonas.aspx");
            existcodigo = false;
        }

        return existcodigo;
    }

}