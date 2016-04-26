using Artexacta.App.Categories;
using Artexacta.App.KPI;
using Artexacta.App.KPI.BLL;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public class CurrencyUnits
{
    public string Currency { get; set; }
    public string Unit { get; set; }

    public CurrencyUnits()
    {

    } 

    public CurrencyUnits(string currency, string unit)
    {
        Currency = currency;
        Unit = unit;
    }
}

public class KPITest
{
    public string Name { get; set; }
    public string Type { get; set; }
    public string Direction { get; set; }
    public string Strategy { get; set; }

    public KPITest()
    {
    }

    public KPITest(string name, string type, string direction, string strategy)
    {
        Name = name;
        Type = type;
        Direction = direction;
        Strategy = strategy;
    }
}

public partial class Populate_Populate : System.Web.UI.Page
{
    static string[] kpiTypes = { "AVAIL", "COUNT", "GENDEC", "GENINT", "GENMON", "GENPER", "GENTIME", "MTBF",
        "MTTR", "OVEEQUEFF", "PERCEPTION", "PERF", "QUAL", "REVENUE", "SALES", "TTP", "UTIL"};
    static string[] kpiMoneyTypes = { "GENMON", "REVENUE", "SALES" };
    static string[] kpiTimeTypes = { "GENTIME", "MTTR", "TTP" };
    static string[] currencyTypes = { "EUR", "PKR", "USD" };
    static CurrencyUnits[] currencies;
    static string[] currencyUnitsUS = { "BIL", "CRO", "DOL", "EUR", "LAK", "MIL", "RS", "THO" };
    static string[] reportingUnits = { "DAY", "MONTH", "QUART", "WEEK", "YEAR" };
    static string currentUser;
    static string[] organizations;
    static string[] areas;
    static string[] projects;
    static string[] people;
    static string[] activities;
    static List<Category> categories;
    static List<KPITest> kpiTests;
    static Random r = new Random();

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    private void PopulateDatabase()
    {
        currentUser = "ivan";
        organizations = LoadFileIntoArray("Companies.txt");
        areas = LoadFileIntoArray("Areas.txt");
        projects = LoadFileIntoArray("Projects.txt");
        people = LoadFileIntoArray("FullNames.txt");
        activities = LoadFileIntoArray("Actions.txt");

        DeleteDatabaseData();

        categories = new List<Category>();
        CreateCategories();
        CreateCurrencyUnits();
        CreateKPITests();


        CreateOrganizations();
    }

    public void CreateCurrencyUnits()
    {
        List<CurrencyUnits> cu = new List<CurrencyUnits>();
        CurrencyDSTableAdapters.CurrencyUnitsForCurrencyTableAdapter ta =
            new CurrencyDSTableAdapters.CurrencyUnitsForCurrencyTableAdapter();
        CurrencyDS.CurrencyUnitsForCurrencyDataTable table = ta.GetCurrencyUnitsForCurrencies("EN");
        foreach (CurrencyDS.CurrencyUnitsForCurrencyRow row in table)
        {
            cu.Add(new CurrencyUnits(row.currencyID, row.currencyUnitID));
        }

        currencies = cu.ToArray();
    }

    public void CreateKPITests()
    {
        kpiTests = new List<KPITest>();

        string line;
        using (StreamReader sr = new StreamReader(Server.MapPath("KPISet.csv")))
        {
            while ((line = sr.ReadLine()) != null)
            {
                line = line.Trim();

                if (string.IsNullOrEmpty(line))
                    continue;

                string[] parts = line.Split(';');

                kpiTests.Add(new KPITest(parts[0], parts[1], parts[2], parts[3]));
            }
        }
    }

    private void DeleteDatabaseData()
    {
        UtilitiesDSTableAdapters.QueriesTableAdapter ta =
            new UtilitiesDSTableAdapters.QueriesTableAdapter();
        ta.DeleteAllUserData();
    }

    public void CreateCategories()
    {
        List<CategoryItem> items = new List<CategoryItem>();
        items.Add(new CategoryItem("LTU", "Large Taxpayers", 0.0m));
        items.Add(new CategoryItem("RTO", "Other Taxpayers", 0.0m));
        categories.Add(new Category("TAXTYPE", "Taxpayer Type", items));

        items = new List<CategoryItem>();
        items.Add(new CategoryItem("SD", "Sindh", 0.0m));
        items.Add(new CategoryItem("PB", "Punjab", 0.0m));
        items.Add(new CategoryItem("KP", "Khyber Pakhtunkhwa", 0.0m));
        items.Add(new CategoryItem("ICT", "Islamabad Capital Territory", 0.0m));
        items.Add(new CategoryItem("GB", "Gilgit-Baltistan", 0.0m));
        items.Add(new CategoryItem("FATA", "Federally Administered Tribal Areas", 0.0m));
        items.Add(new CategoryItem("BN", "Balochistan", 0.0m));
        items.Add(new CategoryItem("AJK", "Azad Jammu & Kashmir", 0.0m));
        categories.Add(new Category("PROV", "Provinces", items));

        items = new List<CategoryItem>();
        items.Add(new CategoryItem("COLL", "Collection/ Income Management", 0.0m));
        items.Add(new CategoryItem("TIA", "Taxpayer Information and Assistance", 0.0m));
        items.Add(new CategoryItem("AUDIT", "Tax Audits/Tax Control/Tax Intelligence", 0.0m));
        items.Add(new CategoryItem("ARRE", "Revenue Arrears Management", 0.0m));
        items.Add(new CategoryItem("LEGAL", "Legal Affairs", 0.0m));
        items.Add(new CategoryItem("INTERN", "International Taxation", 0.0m));
        items.Add(new CategoryItem("INTAUD", "Internal Audits/Internal Controls", 0.0m));
        items.Add(new CategoryItem("PLANNING", "Planning and Control Management", 0.0m));
        items.Add(new CategoryItem("ICT", "Information and Communications Technologies", 0.0m));
        items.Add(new CategoryItem("HR", "Human Resources", 0.0m));
        items.Add(new CategoryItem("AF", "Administration and Finances", 0.0m));
        items.Add(new CategoryItem("SC", "Social Communications/Inter and intra-government relations/International Relations", 0.0m));
        categories.Add(new Category("AREAS", "Functional areas", items));

        CategoryDSTableAdapters.CategoryTableAdapter ta =
            new CategoryDSTableAdapters.CategoryTableAdapter();

        foreach (Category cat in categories)
        {
            ta.InsertNewCategory(cat.Name, cat.ID);
            foreach (CategoryItem item in cat.Items)
            {
                ta.InsertNewCategoryItem(cat.ID, item.ItemID, item.ItemName);
            }
        }
    }

    private void CreateOrganizations()
    {
        OrganizationDSTableAdapters.PopulateOrganizationsTableAdapter ota =
            new OrganizationDSTableAdapters.PopulateOrganizationsTableAdapter();

        int? organizationID = 0;

        foreach (string organizationName in organizations)
        {
            ota.Insert(currentUser, organizationName, ref organizationID);
            CreateAreas(organizationID.Value);
            CreateProject(organizationID.Value, 0);
            CreatePeople(organizationID.Value);
            CreateActivity(organizationID.Value, 0, 0);
            CreateKPI(organizationID.Value, 0, 0, 0, 0);
        }
    }

    private void CreateAreas(int organizationID)
    {
        OrganizationDSTableAdapters.PopulateOrganizationsTableAdapter ota =
            new OrganizationDSTableAdapters.PopulateOrganizationsTableAdapter();

        int? areaID = 0;
        foreach (string areaName in areas)
        {
            ota.InsertArea(organizationID, areaName, ref areaID);
            CreatePeople(organizationID, areaID.Value);
            CreateProject(organizationID, areaID.Value);
            CreateActivity(organizationID, areaID.Value, 0);
            CreateKPI(organizationID, areaID.Value, 0, 0, 0);
        }
    }

    private void CreatePeople(int organizationID)
    {
        CreatePeople(organizationID, 0);
    }

    private void CreatePeople(int organizationID, int areaID)
    {
        PeopleDSTableAdapters.PopulatePeopleTableAdapter pta =
            new PeopleDSTableAdapters.PopulatePeopleTableAdapter();

        int numberOfPeople = r.Next(0, 10);
        int? personID = 0;
        for (int i = 0; i < numberOfPeople; i++)
        {
            pta.Insert(
                currentUser,
                organizationID,
                areaID,   // If this is zero the database will set it to zero
                people[r.Next(0, people.Length)] + " " + i.ToString(), // Randon name
                r.Next(1, 999999999).ToString(),  // Random ID
                ref personID);

            CreateKPI(organizationID, areaID, 0, 0, personID.Value);
        }
    }

    private void CreateProject(int organizationID, int areaID)
    {
        ProjectDSTableAdapters.PopulateProjectsTableAdapter pta =
            new ProjectDSTableAdapters.PopulateProjectsTableAdapter();

        int numberOfProjects = r.Next(0, 10);
        int? projectID = 0;
        for (int i = 0; i < numberOfProjects; i++)
        {
            pta.Insert(
                currentUser,
                organizationID,
                areaID,
                projects[r.Next(0, projects.Length)] + " " + i.ToString(),
                ref projectID);

            CreateActivity(organizationID, areaID, projectID.Value);
            CreateKPI(organizationID, areaID, projectID.Value, 0, 0);
        }
    }

    private void CreateActivity(int organizationID, int areaID, int projectID)
    {
        ActivityDSTableAdapters.PopulateActivitiesTableAdapter pta =
            new ActivityDSTableAdapters.PopulateActivitiesTableAdapter();

        int numberOfActivitites = r.Next(0, 10);
        int? activityID = 0;
        for (int i = 0; i < numberOfActivitites; i++)
        {
            pta.Insert(
                currentUser,
                organizationID,
                areaID,
                projectID,
                activities[r.Next(0, activities.Length)] + " " + i.ToString(),
                ref activityID);

            CreateKPI(organizationID, areaID, projectID, activityID.Value, 0);
        }
    }

    private void CreateKPI(int organizationID, int areaID, int projectID, int activityID, int personID)
    {
        int kpisToGenerate = r.Next(0, 10);

        for (int i = 0; i < kpisToGenerate; i++)
        {
            KPITest theTest = kpiTests[r.Next(0, kpiTests.Count)];  // Randomply select a test KPI
            bool hasTarget = (r.Next(0, 10) > 6) ? true : false;  // 60% of the time the KPI has a target
            bool hasCategories = (r.Next(0, 10) > 8) ? true : false;  // 80% of the time the KPI doesn not have a target
            int noCategories = r.Next(1, 4);
            List<Category> cat = new List<Category>();
            decimal? target = null;
            if (hasCategories)
            {
                for (int j = 0; j < noCategories; j++)
                {
                    List<CategoryItem> items = new List<CategoryItem>();
                    foreach (CategoryItem catItem in categories[j].Items)
                    {
                        decimal? cattarget = null;
                        if (hasTarget)
                            cattarget = (Decimal)(r.NextDouble() * 500);
                        items.Add(new CategoryItem(catItem.ItemID, catItem.ItemName, cattarget));
                    }
                    cat.Add(new Category(categories[j].ID, categories[j].ID, items));
                }
            } 

            if(hasTarget && !hasCategories) 
                target = (Decimal)(r.NextDouble() * 500);

            DateTime startDate = DateTime.MinValue;

            if (hasTarget)
                startDate = DateTime.Today.Subtract(new TimeSpan(r.Next(5, 350), 0, 0, 0, 0));

            string unitID = "";
            switch (theTest.Type)
            {
                case "GENINT": unitID = "INT"; break;
                case "GENPER": unitID = "PERCENT"; break;
                case "GENTIME": unitID = "TIME"; break;
                case "GENDEC": unitID = "DECIMAL"; break;
                default:
                   unitID = ""; break;
            }

            string reportUnit = reportingUnits[r.Next(0, reportingUnits.Length)];

            int currencyIndex = r.Next(0, currencies.Length);
            int kpiID = KPIBLL.CreateKPI(organizationID, 
                areaID, 
                projectID, 
                activityID, 
                personID,
                theTest.Name,
                unitID,
                theTest.Direction,
                theTest.Strategy,
                startDate,
                reportUnit,
                hasTarget ? r.Next(0,350) : 0,
                currencies[currencyIndex].Currency,
                currencies[currencyIndex].Unit,
                theTest.Type,
                cat.ToArray(),
                target,
                currentUser);

            if (r.Next(0,10) > 3)
            {
                List<KPIMeasurement> measurements = new List<KPIMeasurement>();

                // 30% of the time, lets generate data for the KPI
                int reportPeriods = r.Next(0, 70);   // Generate MAX 70 reports

                for (int j = 0; j < reportPeriods; j++)
                {
                    if(hasCategories)
                    {
                        foreach (Category catX in cat)
                        {
                            foreach (CategoryItem catXItem in catX.Items)
                            {
                                measurements.Add(
                                    new KPIMeasurement(
                                        kpiID,
                                        DateTime.Today.Subtract(new TimeSpan(r.Next(0, 300), 0, 0, 0)),
                                        GenerateMeasurement(theTest.Type),
                                        catX.ID,
                                        catXItem.ItemID));
                            }
                        }
                    } else
                    {
                        measurements.Add(
                            new KPIMeasurement(
                                kpiID,
                                DateTime.Today.Subtract(new TimeSpan(r.Next(0, 300), 0, 0, 0)),
                                GenerateMeasurement(theTest.Type), 
                                "", 
                                ""));
                    }
                }

                KPIBLL.InsertKPIMeasurements(measurements);
            }
        }
    }

    public decimal GenerateMeasurement(string kpiType)
    {
        decimal measurement = 0;
        if (kpiTimeTypes.Contains(kpiType)) {
            // Need to generate a random TimeSpan and convert it to Ticks
            measurement = Convert.ToDecimal((new TimeSpan(r.Next(0, 100), r.Next(0, 10), r.Next(0, 60), r.Next(0, 60))).Ticks);
        }
        else {
            measurement = Convert.ToDecimal(r.Next(0, 300));
        }

        return measurement;
    }

    private string[] LoadFileIntoArray(string fileName)
    {
        List<string> dataRead = new List<string>();

        try
        {
            string line;
            using (StreamReader sr = new StreamReader(Server.MapPath(fileName)))
            {
                while ((line = sr.ReadLine()) != null)
                {
                    line = line.Trim();

                    if (string.IsNullOrEmpty(line))
                        continue;

                    if (line.StartsWith("\"") && line.EndsWith("\"") && line.Length > 2)
                    {
                        // Line if of the form "X".  Remove the quotes.
                        line = line.Substring(1, line.Length - 2);

                        // We may have spaces that result... for exampe "X    "  
                        line = line.Trim();
                    }

                    if (string.IsNullOrEmpty(line))
                        continue;

                    dataRead.Add(line);
                }
            }
        }
        catch (Exception e)
        {
            throw e;
        }

        return dataRead.ToArray();
    }

    private void AddItemToMessage(string message, StringBuilder text)
    {
        if (text.Length == 0)
            text.Append(message);
        else
            text.Append("\n" + message);
    }

    protected void PopulateButton_Click(object sender, EventArgs e)
    {
        PopulateDatabase();
    }
}