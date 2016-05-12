using Artexacta.App.Country;
using Artexacta.App.Country.BLL;
using Artexacta.App.User;
using Artexacta.App.User.BLL;
using log4net;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Services;
using Telerik.Web.UI;

/// <summary>
/// Summary description for ComboBoxWebServices
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ComboBoxWebServices : System.Web.Services.WebService {

    private static readonly ILog log = LogManager.GetLogger("Standard");

    public ComboBoxWebServices () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public RadComboBoxData GetUsuarios(RadComboBoxContext context)
    {
        string filter = context.Text;
        int? start = context.NumberOfItems;
        int? numItems = Convert.ToInt32(ConfigurationManager.AppSettings["radComboPageSize"]);

        RadComboBoxData returnData = new RadComboBoxData();

        List<RadComboBoxItemData> result = new List<RadComboBoxItemData>();
        RadComboBoxData comboData = new RadComboBoxData();

        try
        {
            int? totalRows = 0;
            int? itemsPerRequest = numItems;
            int? itemOffset = start;
            int? endOffset = itemOffset + itemsPerRequest;

            List<User> lista = null;
            //lista = UserBLL.GetUsersForAutoComplete(start, numItems, filter, ref totalRows);

            if (endOffset > totalRows)
            {
                endOffset = totalRows;
            }

            result = new List<RadComboBoxItemData>((int)(endOffset - itemOffset));

            foreach (User theUser in lista)
            {
                RadComboBoxItemData itemData = new RadComboBoxItemData();
                itemData.Text = theUser.FullName;
                itemData.Value = theUser.UserId.ToString();
                result.Add(itemData);
            }

            if (lista.Count == 0)
            {
                comboData.Message = Resources.Glossary.ComboBoxNoMatchesText;
            }
            else
            {
                string format = "";

                format = Resources.Glossary.ItemsLoadedFromWebServiceMessage;

                comboData.Message = String.Format(format, endOffset.ToString(), totalRows.ToString());
            }
        }
        catch (Exception q)
        {
            log.Error("Failed to load data for auto complete", q);

            comboData.Message = Resources.Glossary.ErrorLoadingDataFromWebServiceMessage;
        }

        comboData.Items = result.ToArray();
        return comboData;
    }

    [WebMethod]
    public RadComboBoxData GetCountry(RadComboBoxContext context)
    {
        string filter = context.Text;
        int? start = context.NumberOfItems;
        int? numItems = 20;
        string idiomaId = Artexacta.App.Utilities.LanguageUtilities.GetLanguageFromContext().ToUpper();

        RadComboBoxData returnData = new RadComboBoxData();

        List<RadComboBoxItemData> result = new List<RadComboBoxItemData>();
        RadComboBoxData comboData = new RadComboBoxData();

        try
        {
            int? totalRows = 0;
            int? itemsPerRequest = numItems;
            int? itemOffset = start;
            int? endOffset = itemOffset + itemsPerRequest;

            List<Country> lista = null;
            lista = CountryBLL.GetCountryForAutocomplete(start, numItems, filter, idiomaId, ref totalRows);

            if (endOffset > totalRows)
            {
                endOffset = totalRows;
            }

            result = new List<RadComboBoxItemData>((int)(endOffset - itemOffset));

            foreach (Country theData in lista)
            {
                RadComboBoxItemData itemData = new RadComboBoxItemData();
                itemData.Text = theData.Nombre;
                itemData.Value = theData.countryId;
                result.Add(itemData);
            }

            if (lista.Count == 0)
            {
                comboData.Message = "No hay coincidencias";
            }
            else
            {
                string format = "";

                format = Resources.Glossary.ItemsLoadedFromWebServiceMessage; ;

                comboData.Message = String.Format(format, endOffset.ToString(), totalRows.ToString());
            }

        }
        catch (Exception q)
        {
            log.Error("Failed to load data for auto complete", q);

            comboData.Message = Resources.Glossary.ErrorLoadingDataFromWebServiceMessage;
        }

        comboData.Items = result.ToArray();
        return comboData;
    }

}
