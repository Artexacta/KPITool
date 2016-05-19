using Artexacta.App.Categories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Transactions;
using System.Data.SqlClient;
using System.Configuration;
using log4net;
using KPIDSTableAdapters;

namespace Artexacta.App.KPI.BLL
{
    /// <summary>
    /// BLL for handling KPIs
    /// </summary>
    [System.ComponentModel.DataObject]
    public class KPIBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        KPITableAdapter _theAdapter = null;

        protected KPITableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new KPITableAdapter();
                return _theAdapter;
            }
        }

        public KPIBLL()
        {
        }

        private static KPI FillRecord(KPIDS.KPIRow row)
        {
            KPI theNewRecord = new KPI(
                row.kpiID,
                row.name,
                row.IsorganizationIDNull() ? 0 : row.organizationID,
                row.IsareaIDNull() ? 0 : row.areaID,
                row.IsprojectIDNull() ? 0 : row.projectID,
                row.IsactivityIDNull() ? 0 : row.activityID,
                row.IspersonIDNull() ? 0 : row.personID,
                row.unitID,
                row.directionID,
                row.strategyID,
                row.IsstartDateNull() ? DateTime.MinValue : row.startDate,
                row.reportingUnitID,
                row.IstargetPeriodNull() ? 0 : row.targetPeriod,
                row.allowsCategories,
                row.IscurrencyNull() ? "" : row.currency,
                row.IscurrencyUnitIDNull() ? "" : row.currencyUnitID,
                row.kpiTypeID);
            theNewRecord.OrganizationName = row.IsorganizationNameNull() ? "" : row.organizationName;
            theNewRecord.AreaName = row.IsareaNameNull() ? "" : row.areaName;
            theNewRecord.ProjectName = row.IsprojectNameNull() ? "" : row.projectName;
            theNewRecord.ActivityName = row.IsactivityNameNull() ? "" : row.activityName;
            theNewRecord.PersonName = row.IspersonNameNull() ? "" : row.personName;
            return theNewRecord;
        }

        public static KPI GetKPIById(int kpiId)
        {
            if (kpiId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroAreaId);

            KPI theData = null;
            try
            {
                KPITableAdapter localAdapter = new KPITableAdapter();
                KPIDS.KPIDataTable theTable = localAdapter.GetKPIById(kpiId);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    KPIDS.KPIRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error("Ocurrió un error mientras se obtenía el KPI de id: " + kpiId, exc);
                throw exc;
            }

            return theData;
        }

        public List<KPI> GetKPIsByOrganization(int organizationId)
        {
            if (organizationId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroOrganizationId);

            string userName = HttpContext.Current.User.Identity.Name;
            List<KPI> theList = new List<KPI>();
            KPI theData = null;
            try
            {
                KPIDS.KPIDataTable theTable = theAdapter.GetKPIsByOrganization(organizationId, userName);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (KPIDS.KPIRow theRow in theTable)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetKPIsByOrganization para organizationId: " + organizationId.ToString() + " y userName: " + userName, exc);
                throw new ArgumentException("Ocurrió un error al obtener el listado de KPIs de la organización.");
            }

            return theList;
        }

        public List<KPI> GetKPIsByProject(int projectId)
        {
            if (projectId <= 0)
                throw new ArgumentException(Resources.Organization.MessageZeroProjectId);

            string userName = HttpContext.Current.User.Identity.Name;
            List<KPI> theList = new List<KPI>();
            KPI theData = null;
            try
            {
                KPIDS.KPIDataTable theTable = theAdapter.GetKPIsByProject(projectId, userName);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (KPIDS.KPIRow theRow in theTable)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetKPIsByProject para projectId: " + projectId.ToString() + " y userName: " + userName, exc);
                throw new ArgumentException("Ocurrió un error al obtener el listado de KPIs del proyecto.");
            }

            return theList;
        }

        public List<KPI> GetKPIsByActivity(int activityId)
        {
            if (activityId <= 0)
                throw new ArgumentException("The code of activity cannot be zero.");

            string userName = HttpContext.Current.User.Identity.Name;
            List<KPI> theList = new List<KPI>();
            KPI theData = null;
            try
            {
                KPIDS.KPIDataTable theTable = theAdapter.GetKPIsByActivity(activityId, userName);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (KPIDS.KPIRow theRow in theTable)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetKPIsByActivity para activityId: " + activityId.ToString() + " y userName: " + userName, exc);
                throw new ArgumentException("Ocurrió un error al obtener el listado de KPIs de la actividad.");
            }

            return theList;
        }

        public List<KPI> GetKPIsByPerson(int personId)
        {
            if (personId <= 0)
                throw new ArgumentException("The code of person cannot be zero.");

            string userName = HttpContext.Current.User.Identity.Name;
            List<KPI> theList = new List<KPI>();
            KPI theData = null;
            try
            {
                KPIDS.KPIDataTable theTable = theAdapter.GetKPIsByPerson(personId, userName);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (KPIDS.KPIRow theRow in theTable)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetKPIsByPerson para personId: " + personId.ToString() + " y userName: " + userName, exc);
                throw new ArgumentException("Ocurrió un error al obtener el listado de KPIs de la persona.");
            }

            return theList;
        }

        /// <summary>
        /// Create a KPI in the database 
        /// </summary>
        /// <param name="organizationID"></param>
        /// <param name="areaID">Area ID - Pass 0 if no area</param>
        /// <param name="projectID">Project ID - Pass 0 if no project</param>
        /// <param name="activityID">Activity ID - Pass 0 if no activity</param>
        /// <param name="personID">Person ID  - Pass 0 if no person</param>
        /// <param name="kpiName">KPI Name</param>
        /// <param name="unitID">DECIMAL, INT, MONEY, PERCENT or TIME - Pass empty if using a KPI type that is not generic </param>
        /// <param name="direction">MAX or MIN - Pass empty if using a KPI type that is not generic</param>
        /// <param name="strategy">SUM, AVG - Pass empty if using a KPI type that is not generic</param>
        /// <param name="startDate">use DateTime.MinValue if you want to specify that it has no start date</param>
        /// <param name="reportingUnitID">DAY, MONTH, QUART, WEEK or YEAR</param>
        /// <param name="targetPeriod">use null if you don´t have a target</param>
        /// <param name="currency">use "" if type is not MONEY</param>
        /// <param name="currencyUnit">use ""</param>
        /// <param name="kpiTypeID"></param>
        /// <param name="categories">Specifies all the categories and their targets, if any</param>
        /// <param name="target">Only specified if the KPI does not have categories</param>
        /// <param name="currentUser"></param>
        /// <returns></returns>
        public static int CreateKPI(int organizationID, int areaID, int projectID, int activityID, int personID,
            string kpiName, string unitID, string direction, string strategy, DateTime startDate,
            string reportingUnitID, int? targetPeriod, string currency,
            string currencyUnit, string kpiTypeID, Category[] categories, decimal? target, string currentUser)
        {
            int kpiID = 0;

            try
            {
                // Create the TransactionScope to execute the commands, guaranteeing
                // that both commands can commit or roll back as a single unit of work.
                using (TransactionScope scope = new TransactionScope())
                {
                    using (SqlConnection connection =
                        new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
                    {
                        // Opening the connection automatically enlists it in the 
                        // TransactionScope as a lightweight transaction.
                        connection.Open();

                        // Create the SqlCommand object and execute the first command.
                        SqlCommand command1 = new SqlCommand("usp_KPI_InsertKPI", connection);
                        command1.CommandType = System.Data.CommandType.StoredProcedure;

                        // NOTE that we pass zeros to areaID, projectID, activityID, etc., sicne the stored procedure will convert 
                        // these to nulls!

                        command1.Parameters.Add("@userName", System.Data.SqlDbType.VarChar, 50).Value = currentUser;
                        command1.Parameters.Add("@organizationID", System.Data.SqlDbType.Int).Value = organizationID;
                        command1.Parameters.Add("@areaID", System.Data.SqlDbType.Int).Value = areaID;
                        command1.Parameters.Add("@projectID", System.Data.SqlDbType.Int).Value = projectID;
                        command1.Parameters.Add("@activityID", System.Data.SqlDbType.Int).Value = activityID;
                        command1.Parameters.Add("@personID", System.Data.SqlDbType.Int).Value = personID;

                        command1.Parameters.Add("@kpiName", System.Data.SqlDbType.NVarChar, 250).Value = kpiName;

                        // If the KPIs are generic, then we can specify unit, direction and strategy.  Otherwise we 
                        // just pass null to the database since the stored procedure that stores the KPI will get the
                        // correct values from the configuration.
                        if (kpiTypeID == "GENDEC" || kpiTypeID == "GENINT" || kpiTypeID == "GENMON" ||
                            kpiTypeID == "GENPER")
                        {
                            command1.Parameters.Add("@unit", System.Data.SqlDbType.VarChar, 10).Value = unitID;
                            command1.Parameters.Add("@direction", System.Data.SqlDbType.Char, 3).Value = direction;
                            command1.Parameters.Add("@strategy", System.Data.SqlDbType.Char, 3).Value = strategy;
                        }
                        else
                        {
                            command1.Parameters.Add("@unit", System.Data.SqlDbType.VarChar, 10).Value = "NA";
                            command1.Parameters.Add("@direction", System.Data.SqlDbType.Char, 3).Value = "NA";
                            command1.Parameters.Add("@strategy", System.Data.SqlDbType.Char, 3).Value = "NA";
                        }

                        SqlParameter dateParam = new SqlParameter("@startDate", System.Data.SqlDbType.Date);
                        if (startDate == DateTime.MinValue)
                            dateParam.Value = DBNull.Value;
                        else
                            dateParam.Value = startDate;
                        command1.Parameters.Add(dateParam);

                        command1.Parameters.Add("@reportingUnit", System.Data.SqlDbType.Char, 15).Value = reportingUnitID;

                        SqlParameter targetPeriodParam = new SqlParameter("@targetPeriod", System.Data.SqlDbType.Int);
                        if (targetPeriodParam == null)
                            targetPeriodParam.Value = DBNull.Value;
                        else
                            targetPeriodParam.Value = targetPeriod.Value;
                        command1.Parameters.Add(targetPeriodParam);

                        // If we have categories, then set the flag.
                        command1.Parameters.Add("@allowsCategories", System.Data.SqlDbType.Bit).Value =
                            categories != null && categories.Length > 0 ? true : false;

                        SqlParameter currencyParam = new SqlParameter("@currency", System.Data.SqlDbType.Char, 3);
                        if (String.IsNullOrWhiteSpace(currency))
                            currencyParam.Value = DBNull.Value;
                        else
                            currencyParam.Value = currency;
                        command1.Parameters.Add(currencyParam);

                        SqlParameter currencyUnitParam = new SqlParameter("@currencyUnit", System.Data.SqlDbType.Char, 3);
                        if (String.IsNullOrWhiteSpace(currencyUnit))
                            currencyUnitParam.Value = DBNull.Value;
                        else
                            currencyUnitParam.Value = currencyUnit;
                        command1.Parameters.Add(currencyUnitParam);

                        command1.Parameters.Add("@kpiTypeID", System.Data.SqlDbType.VarChar, 10).Value = kpiTypeID;

                        SqlParameter kpiIDParam = new SqlParameter("@kpiID", System.Data.SqlDbType.Int);
                        kpiIDParam.Direction = System.Data.ParameterDirection.Output;
                        command1.Parameters.Add(kpiIDParam);

                        command1.ExecuteNonQuery();

                        // The ID of the KPI just created
                        kpiID = (int)kpiIDParam.Value;

                        // If the KPI has categories, create them
                        if (categories != null && categories.Length > 0)
                        {
                            foreach (Category cat in categories)
                            {
                                SqlCommand command2 = new SqlCommand("usp_KPI_AddKPICategory", connection);
                                command2.CommandType = System.Data.CommandType.StoredProcedure;
                                command2.Parameters.Add("@kpiID", System.Data.SqlDbType.Int).Value = kpiID;
                                command2.Parameters.Add("@categoryID", System.Data.SqlDbType.VarChar, 20).Value = cat.ID;
                                command2.ExecuteNonQuery();
                            }
                        }

                        // If the KPI has  and targets, create them
                        if (categories != null && categories.Length > 0)
                        {
                            foreach (Category cat in categories)
                            {
                                foreach (CategoryItem item in cat.Items)
                                {
                                    if (item.Target == null)
                                        continue;

                                    SqlCommand command2 = new SqlCommand("usp_KPI_AddKPITargetInCategoryItem", connection);
                                    command2.CommandType = System.Data.CommandType.StoredProcedure;
                                    command2.Parameters.Add("@kpiID", System.Data.SqlDbType.Int).Value = kpiID;
                                    command2.Parameters.Add("@target", System.Data.SqlDbType.Decimal).Value = item.Target.Value;
                                    command2.Parameters.Add("@categoryItemID", System.Data.SqlDbType.VarChar, 20).Value = item.ItemID;
                                    command2.Parameters.Add("@categoryID", System.Data.SqlDbType.VarChar, 20).Value = cat.ID;
                                    SqlParameter targetIDParam = new SqlParameter("@targetID", System.Data.SqlDbType.Int);
                                    targetIDParam.Direction = System.Data.ParameterDirection.Output;
                                    command2.Parameters.Add(targetIDParam);
                                    command2.ExecuteNonQuery();
                                }
                            }
                        }
                        else if (target != null)
                        {
                            // Single target without categories

                            SqlCommand command2 = new SqlCommand("usp_KPI_AddKPITargetNoCategories", connection);
                            command2.CommandType = System.Data.CommandType.StoredProcedure;
                            command2.Parameters.Add("@kpiID", System.Data.SqlDbType.Int).Value = kpiID;
                            command2.Parameters.Add("@target", System.Data.SqlDbType.Decimal).Value = target.Value;
                            SqlParameter targetIDParam = new SqlParameter("@targetID", System.Data.SqlDbType.Int);
                            targetIDParam.Direction = System.Data.ParameterDirection.Output;
                            command2.Parameters.Add(targetIDParam);
                            command2.ExecuteNonQuery();
                        }
                    }

                    // The Complete method commits the transaction. If an exception has been thrown,
                    // Complete is not  called and the transaction is rolled back.
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                log.Error("Failed to create a KPI", ex);
                throw ex;
            }

            return kpiID;
        }

        public static void InsertKPIMeasurements(List<KPIMeasurement> measurements)
        {
            try
            {
                // Create the TransactionScope to execute the commands, guaranteeing
                // that both commands can commit or roll back as a single unit of work.
                using (TransactionScope scope = new TransactionScope())
                {
                    using (SqlConnection connection =
                        new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
                    {
                        // Opening the connection automatically enlists it in the 
                        // TransactionScope as a lightweight transaction.
                        connection.Open();

                        foreach (KPIMeasurement item in measurements)
                        {
                            // Create the SqlCommand object and execute the first command.
                            SqlCommand command = new SqlCommand("usp_KPI_InsertMeasurement", connection);
                            command.CommandType = System.Data.CommandType.StoredProcedure;

                            command.Parameters.Add("@kpiID", System.Data.SqlDbType.Int).Value = item.KPIID;
                            command.Parameters.Add("@date", System.Data.SqlDbType.Date).Value = item.Date;
                            command.Parameters.Add("@measurement", System.Data.SqlDbType.Decimal).Value = item.Measurement;
                            command.Parameters.Add("@categoryID", System.Data.SqlDbType.VarChar, 20).Value = item.CategoryID;
                            command.Parameters.Add("@categoryItemID", System.Data.SqlDbType.VarChar, 20).Value = item.CategoryItemID;

                            SqlParameter measurementIDParam = new SqlParameter("@measurementID", System.Data.SqlDbType.Int);
                            measurementIDParam.Direction = System.Data.ParameterDirection.Output;
                            command.Parameters.Add(measurementIDParam);

                            command.ExecuteNonQuery();
                        }
                    }

                    // The Complete method commits the transaction. If an exception has been thrown,
                    // Complete is not  called and the transaction is rolled back.
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                log.Error("Failed to create a KPI", ex);
                throw ex;
            }

        }
    }
}