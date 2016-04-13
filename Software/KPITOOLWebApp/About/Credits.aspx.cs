using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using log4net;

public partial class About_Credits : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");
    
    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            PoweredByLiteral.Text = GetText();
        }
    }

    private string GetText()
    {
        StringBuilder stringBuilder = new StringBuilder();
        TextReader tr = null;
        try
        {
            string lang = Artexacta.App.Utilities.LanguageUtilities.GetLanguageFromContext().ToUpper();
            string path = Server.MapPath("~/DataFiles/PoweredBy/" + lang + "/Index.html");

            if (!File.Exists(path))
                return string.Empty;

            tr = new StreamReader(path);
            string line = tr.ReadLine();
            while (line != null)
            {
                stringBuilder.Append(line);
                line = tr.ReadLine();
            }

        }
        catch (Exception ex)
        {
            log.Error("Failed to try to read file", ex);
        }
        finally
        {
            if (tr != null)
                tr.Close();
        }
        return stringBuilder.ToString();
    }
}
