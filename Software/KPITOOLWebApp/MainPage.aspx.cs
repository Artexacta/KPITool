using Artexacta.App.Seguimiento;
using Artexacta.App.Utilities.SystemMessages;
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
using Artexacta.App.Project.BLL;
using Artexacta.App.Project;
using Artexacta.App.Activities.BLL;
using Artexacta.App.Activities;
using Artexacta.App.KPI.BLL;
using Artexacta.App.KPI;
using Artexacta.App.People.BLL;
using Artexacta.App.People;
using Artexacta.App.Utilities.Quantity;
using Artexacta.App.User.BLL;

public partial class MainPage : SqlViewStatePage
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
    }

}