using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using log4net;
using System.Configuration;
using Artexacta.App.Configuration;

namespace Artexacta.App.Utilities.VersionUtilities.BLL
{
    /// <summary>
    /// Summary description for VersionBLL
    /// </summary>
    public class VersionBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public VersionBLL()
        {
        }

        /// <summary>
        /// Get an application version component.
        /// </summary>
        /// <param name="component">A version component that should be one of: majorVersionNumber, minorVersionNumber or releaseNumber</param>
        /// <returns>The version for the component</returns>
        public int getApplicationVersionComponent(string component)
        {
            if (component == null || component.Length == 0)
            {
                // Cannot do anything without a version component
                throw new ArgumentException(Resources.Configuration.MensajeErrorMetodo);
            }

            if (component != "majorVersionNumber" && component != "minorVersionNumber" &&
                component != "releaseNumber")
            {
                throw new ArgumentOutOfRangeException(Resources.Configuration.MensajeErrorVersion);
            }

            try
            {
                string configString = ConfigurationManager.AppSettings.Get(component);
                if (configString == null || configString.Length == 0)
                {
                    string mensaje = "";

                    mensaje = "No se encontró un archivo de configuración valida del componente " + component + " en el archivo de configuración del sistema.";

                    throw new Exception(mensaje);
                }

                return Int32.Parse(configString);
            }
            catch (Exception e)
            {
                log.Error("Failed to get the application component " + component, e);
                throw e;
            }
        }

        public int getDatabaseMajorVersion()
        {
            System.Data.IDbConnection dbConnection = null;

            try
            {
                dbConnection = new System.Data.SqlClient.SqlConnection(Configuration.Configuration.GetDBConnectionString());
                string queryString = "usp_GetVersionMajor";
                System.Data.IDbCommand dbCommand = new System.Data.SqlClient.SqlCommand();

                dbConnection.Open();

                dbCommand.CommandText = queryString;
                dbCommand.CommandType = System.Data.CommandType.StoredProcedure;
                dbCommand.Connection = dbConnection;

                System.Data.IDataParameter dbParam_number = new System.Data.SqlClient.SqlParameter();
                dbParam_number.ParameterName = "@smiMajor";
                dbParam_number.Direction = System.Data.ParameterDirection.Output;
                dbParam_number.DbType = System.Data.DbType.Int16;
                dbCommand.Parameters.Add(dbParam_number);

                dbCommand.ExecuteNonQuery();
                System.Data.IDataParameter dbParam_result =
                    (System.Data.IDataParameter)dbCommand.Parameters["@smiMajor"];
                string returnValue = dbParam_result.Value.ToString();
                dbConnection.Close();
                dbConnection.Dispose();

                return Int32.Parse(returnValue);
            }
            catch (Exception e)
            {
                if (dbConnection != null)
                {
                    dbConnection.Close();
                    dbConnection.Dispose();
                }

                // Log the exception
                log.Error("Failed to get database major version", e);
                throw e;
            }
        }

        public int getDatabaseMinorVersion()
        {
            System.Data.IDbConnection dbConnection = null;
            try
            {
                dbConnection = new System.Data.SqlClient.SqlConnection(
                    Configuration.Configuration.GetDBConnectionString());
                string queryString = "usp_GetVersionMinor";
                System.Data.IDbCommand dbCommand = new System.Data.SqlClient.SqlCommand();
                dbConnection.Open();

                dbCommand.CommandText = queryString;
                dbCommand.CommandType = System.Data.CommandType.StoredProcedure;
                dbCommand.Connection = dbConnection;

                System.Data.IDataParameter dbParam_number = new System.Data.SqlClient.SqlParameter();
                dbParam_number.ParameterName = "@smiMinor";
                dbParam_number.Direction = System.Data.ParameterDirection.Output;
                dbParam_number.DbType = System.Data.DbType.Int16;
                dbCommand.Parameters.Add(dbParam_number);

                dbCommand.ExecuteNonQuery();

                System.Data.IDataParameter dbParam_result =
                    (System.Data.IDataParameter)dbCommand.Parameters["@smiMinor"];
                string returnValue = dbParam_result.Value.ToString();
                dbConnection.Close();
                dbConnection.Dispose();

                return Int32.Parse(returnValue);
            }
            catch (Exception e)
            {
                if (dbConnection != null)
                {
                    dbConnection.Close();
                    dbConnection.Dispose();
                }

                // Log the exception
                log.Error("Failed to get database minor version", e);
                throw e;
            }
        }

        public int getDatabaseReleaseVersion()
        {
            System.Data.IDbConnection dbConnection = null;
            try
            {
                dbConnection = new System.Data.SqlClient.SqlConnection(
                    Configuration.Configuration.GetDBConnectionString());
                string queryString = "usp_GetVersionRelease";
                System.Data.IDbCommand dbCommand = new System.Data.SqlClient.SqlCommand();
                dbConnection.Open();

                dbCommand.CommandText = queryString;
                dbCommand.CommandType = System.Data.CommandType.StoredProcedure;
                dbCommand.Connection = dbConnection;

                System.Data.IDataParameter dbParam_number = new System.Data.SqlClient.SqlParameter();
                dbParam_number.ParameterName = "@smiRelease";
                dbParam_number.Direction = System.Data.ParameterDirection.Output;
                dbParam_number.DbType = System.Data.DbType.Int16;
                dbCommand.Parameters.Add(dbParam_number);

                dbCommand.ExecuteNonQuery();
                System.Data.IDataParameter dbParam_result =
                    (System.Data.IDataParameter)dbCommand.Parameters["@smiRelease"];
                string returnValue = dbParam_result.Value.ToString();
                dbConnection.Close();
                dbConnection.Dispose();

                return Int32.Parse(returnValue);
            }
            catch (Exception e)
            {
                if (dbConnection != null)
                {
                    dbConnection.Close();
                    dbConnection.Dispose();
                }

                // Log the exception
                log.Error("Failed to get database release version", e);
                throw e;
            }
        }
    }
}