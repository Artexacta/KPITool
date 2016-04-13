using System;
using System.Collections.Generic;
using System.Web;

namespace Artexacta.App.WBT
{
    public class BasicDataClass
    {
        #region Instance Properties

        public Test TestParentObject { get; set; }

        public Int32 basicDataID { get; set; }

        public Int32 surveyID { get; set; }

        public Int32 questionnaireID { get; set; }

        public String testNumber { get; set; }

        public String testerName { get; set; }

        public DateTime? testDate { get; set; }

        public Decimal? airTemperature { get; set; }

        public String windConditions { get; set; }

        public String fuelDimensions { get; set; }

        public Decimal? MC { get; set; }

        public Int32? P1 { get; set; }

        public Int32? P2 { get; set; }

        public Int32? P3 { get; set; }

        public Int32? P4 { get; set; }

        public Int32? k { get; set; }

        public Decimal? CO2_B { get; set; }

        public Decimal? CO_B { get; set; }

        public Decimal? PM_B { get; set; }

        public String testNotes { get; set; }

        public String NOTESHPCST { get; set; }

        public String NOTESHPHST { get; set; }

        public String NOTESLPST { get; set; }

        #endregion Instance Properties
    }

}