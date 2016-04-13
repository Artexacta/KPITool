using SearchComponent;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.WBT
{

    /// <summary>
    /// Summary description for PersonaSearch
    /// </summary>
    public class TestHeaderSearch : ConfigColumns
    {
        public TestHeaderSearch()
            : base()
        {
            Column col = new Column("[g1].[testNumber]", "testnumber", Column.ColumnType.String);
            col.AppearInStandardSearch = true;
            col.DisplayHelp = true;
            col.Description = "The test number";
            this.Cols.Add(col);

            col = new Column("surveyId", "surveyId", Column.ColumnType.Numeric);
            col.AppearInStandardSearch = false;
            col.DisplayHelp = true;
            col.Description = "Survey Id";
            this.Cols.Add(col);

            col = new Column("testerName", "tester", Column.ColumnType.String);
            col.AppearInStandardSearch = true;
            col.DisplayHelp = true;
            col.Description = "Tester Name";
            this.Cols.Add(col);

            col = new Column("testDate", "testDate", Column.ColumnType.Date);
            col.AppearInStandardSearch = false;
            col.DisplayHelp = false;
            col.Description = "Test Date";
            this.Cols.Add(col);

            col = new Column("testLocation", "location", Column.ColumnType.String);
            col.AppearInStandardSearch = true;
            col.DisplayHelp = true;
            col.Description = "Test Location";
            this.Cols.Add(col);

            col = new Column("altitude", "altitude", Column.ColumnType.Numeric);
            col.AppearInStandardSearch = false;
            col.DisplayHelp = true;
            col.Description = "Altitude";
            this.Cols.Add(col);

            col = new Column("stoveType", "stove", Column.ColumnType.String);
            col.AppearInStandardSearch = true;
            col.DisplayHelp = true;
            col.Description = "Stove Type";
            this.Cols.Add(col);

            col = new Column("stoveManufacturer", "manufacturer", Column.ColumnType.String);
            col.AppearInStandardSearch = true;
            col.DisplayHelp = true;
            col.Description = "Stove Manufacturer";
            this.Cols.Add(col);


        }
    }
}