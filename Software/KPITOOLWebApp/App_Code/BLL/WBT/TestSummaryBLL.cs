using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Artexacta.App.WBT
{
    /// <summary>
    /// Summary description for TestSummaryBLL
    /// </summary>
    public class TestSummaryBLL
    {
        public TestSummaryBLL()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public static DataTable GetColdStartSummary(int surveyId, string testNumber)
        {
            DataTable theTable = new DataTable();
            using (SqlConnection theConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("usp_WBT_GetColdStartSummary", theConnection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@surveyID", SqlDbType.Int).Value = surveyId;
                    cmd.Parameters.Add("@testnumber", SqlDbType.NVarChar).Value = testNumber;
                    theConnection.Open();

                    using (SqlDataAdapter theAdapter = new SqlDataAdapter())
                    {
                        theAdapter.SelectCommand = cmd;

                        theAdapter.Fill(theTable);
                    }
                }
            }

            theTable = PivotTableTests(theTable, 0);

            return theTable;
        }

        public static DataTable GetHotStartSummary(int surveyId, string testNumber)
        {
            DataTable theTable = new DataTable();
            using (SqlConnection theConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("usp_WBT_GetHotStartSummary", theConnection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@surveyID", SqlDbType.Int).Value = surveyId;
                    cmd.Parameters.Add("@testnumber", SqlDbType.NVarChar).Value = testNumber;
                    theConnection.Open();

                    using (SqlDataAdapter theAdapter = new SqlDataAdapter())
                    {
                        theAdapter.SelectCommand = cmd;

                        theAdapter.Fill(theTable);
                    }
                }
            }

            theTable = PivotTableTests(theTable, 0);

            return theTable;
        }

        public static DataTable GetSimmerSummary(int surveyId, string testNumber)
        {
            DataTable theTable = new DataTable();
            using (SqlConnection theConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("usp_WBT_GetSimmerSummary", theConnection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@surveyID", SqlDbType.Int).Value = surveyId;
                    cmd.Parameters.Add("@testnumber", SqlDbType.NVarChar).Value = testNumber;
                    theConnection.Open();

                    using (SqlDataAdapter theAdapter = new SqlDataAdapter())
                    {
                        theAdapter.SelectCommand = cmd;

                        theAdapter.Fill(theTable);
                    }
                }
            }

            theTable = PivotTableTests(theTable, 0);

            return theTable;
        }

        public static DataTable GetBenchmarkValuesSummary(int surveyId, string testNumber)
        {
            DataTable theTable = new DataTable();
            using (SqlConnection theConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("usp_WBT_GetBenchmarkValuesSummary", theConnection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@surveyID", SqlDbType.Int).Value = surveyId;
                    cmd.Parameters.Add("@testnumber", SqlDbType.NVarChar).Value = testNumber;
                    theConnection.Open();

                    using (SqlDataAdapter theAdapter = new SqlDataAdapter())
                    {
                        theAdapter.SelectCommand = cmd;

                        theAdapter.Fill(theTable);
                    }
                }
            }

            theTable = PivotTableTests(theTable, 0);

            return theTable;
        }

        public static DataTable GetIWAPERFORMANCEMETRICSSummary(int surveyId, string testNumber)
        {
            DataTable theTable = new DataTable();
            using (SqlConnection theConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("usp_WBT_GetIWAPERFORMANCEMETRICSSummary", theConnection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@surveyID", SqlDbType.Int).Value = surveyId;
                    cmd.Parameters.Add("@testnumber", SqlDbType.NVarChar).Value = testNumber;
                    theConnection.Open();

                    using (SqlDataAdapter theAdapter = new SqlDataAdapter())
                    {
                        theAdapter.SelectCommand = cmd;

                        theAdapter.Fill(theTable);
                    }
                }
            }

            theTable = PivotTableTests(theTable, 0);

            return theTable;
        }

        private static DataTable PivotTableTests(DataTable oldTable, int pivotColumnOrdinal)
        {
            DataTable newTable = new DataTable();
            DataRow dr;

            // add pivot column name
            newTable.Columns.Add("Description");
            int colId = 1;
            // add pivot column values in each row as column headers to new Table
            foreach (DataRow row in oldTable.Rows)
            {
                string colName = row[pivotColumnOrdinal].ToString();

                if (colName.Equals("Average") || colName.Equals("St Dev."))
                    newTable.Columns.Add(colName);
                else
                {
                    newTable.Columns.Add("Test " + colId);
                    colId++;
                }
            }
            // loop through columns
            for (int col = 0; col <= oldTable.Columns.Count - 1; col++)
            {
                //pivot column doen't get it's own row (it is already a header)
                if (col == pivotColumnOrdinal)
                    continue;

                // each column becomes a new row
                dr = newTable.NewRow();

                // add the Column Name in the first Column
                dr[0] = oldTable.Columns[col].ColumnName;

                // add data from every row to the pivoted row
                for (int row = 0; row <= oldTable.Rows.Count - 1; row++)
                    dr[row + 1] = oldTable.Rows[row][col];

                //add the DataRow to the new table
                newTable.Rows.Add(dr);
            }
            return newTable;
        }
    }
}