using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Artexacta.App.People;
using Artexacta.App.People.BLL;
using Artexacta.App.PermissionObject;
using Artexacta.App.PermissionObject.BLL;
using Artexacta.App.Utilities.SystemMessages;
using log4net;

public partial class Personas_PeopleForm : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    public int PersonId
    {
        set { PersonIdHiddenField.Value = value.ToString(); }
        get
        {
            int personId = 0;
            try
            {
                personId = Convert.ToInt32(PersonIdHiddenField.Value);
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert PersonIdHiddenField.Value to integer value", ex);
            }
            return personId;
        }
    }

    public string ParentPage
    {
        set { ParentPageHiddenField.Value = value; }
        get { return string.IsNullOrEmpty(ParentPageHiddenField.Value) ? "~/MainPage.aspx" : ParentPageHiddenField.Value; }
    }

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;

        DataControl.DataType = UserControls_FRTWB_AddDataControl.AddType.PPL.ToString();
        ProcessSessionParametes();
        LoadPersonData();
    }

    private void ProcessSessionParametes()
    {
        if (Session["ParentPage"] != null && !string.IsNullOrEmpty(Session["ParentPage"].ToString()))
        {
            ParentPage = Session["ParentPage"].ToString();
        }
        Session["ParentPage"] = null;

        if (Session["PersonId"] != null && !string.IsNullOrEmpty(Session["PersonId"].ToString()))
        {
            int personId = 0;
            try
            {
                personId = Convert.ToInt32(Session["PersonId"].ToString());
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert Session['PersonId'] to integer value", ex);
            }
            PersonId = personId;
        }
        Session["PersonId"] = null;
    }

    protected void LoadPersonData()
    {
        if (string.IsNullOrEmpty(PersonIdHiddenField.Value) || PersonIdHiddenField.Value == "0")
        {
            //Insert
            DataControl.OrganizationId = 0;
        }
        else
        {
            PermissionObject theUser = new PermissionObject();
            try
            {
                theUser = PermissionObjectBLL.GetPermissionsByUser(PermissionObject.ObjectType.PERSON.ToString(), Convert.ToInt32(PersonIdHiddenField.Value));
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
                Response.Redirect("~/MainPage.aspx");
            }

            bool readOnly = false;

            if (theUser == null || !theUser.TheActionList.Exists(i => i.ObjectActionID.Equals("OWN") || i.ObjectActionID.Equals("MAN_PEOPLE")))
            {
                readOnly = true;
            }

            DataControl.ReadOnly = readOnly;

            //Update
            People theData = null;

            try
            {
                theData = PeopleBLL.GetPeopleById(Convert.ToInt32(PersonIdHiddenField.Value));
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
            }

            if (theData != null)
            {
                TitleLiteral.Text = theData.Name;
                CodeTextBox.Text = theData.Id;
                NameTextBox.Text = theData.Name;
                DataControl.OrganizationId = theData.OrganizationId;
                DataControl.AreaId = theData.AreaId;
                CodeTextBox.Enabled = !readOnly;
                NameTextBox.Enabled = !readOnly;
                SaveButton.Visible = !readOnly;
                ReqLabel.Visible = !readOnly;
                Req1Label.Visible = !readOnly;
            }
        }
    }


    protected void SaveButton_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
            return;

        People thePerson = new People();

        thePerson.Id = CodeTextBox.Text;
        thePerson.Name = NameTextBox.Text;
        thePerson.OrganizationId = DataControl.OrganizationId;
        thePerson.AreaId = DataControl.AreaId;

        if (PersonId == 0)
        {
            //Insert
            try
            {
                PeopleBLL.InsertPeople(thePerson);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }

            SystemMessages.DisplaySystemMessage(Resources.People.MessageCreatePersonOk);
        }
        else
        {
            //Update
            thePerson.PersonId = PersonId;
            try
            {
                PeopleBLL.UpdatePeople(thePerson);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }

            SystemMessages.DisplaySystemMessage(Resources.People.MessageUpdatePersonOk);
        }
        Response.Redirect("~/Personas/ListaPersonas.aspx");
    }
    protected void CancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Personas/ListaPersonas.aspx");
    }
}