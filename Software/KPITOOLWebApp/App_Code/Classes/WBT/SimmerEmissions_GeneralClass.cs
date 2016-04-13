using System;

namespace Artexacta.App.WBT
{
    public class SimmerEmissions_GeneralClass
    {
        #region Instance Properties

        public Int32 simmerEmissionsGeneralID { get; set; }

        public Int32 surveyID { get; set; }

        public Int32 questionnaireID { get; set; }

        public String testNumber { get; set; }

        public Decimal? Vs { get; set; }

        public Decimal? CCs { get; set; }

        public Decimal? Cs { get; set; }

        public Decimal? fse { get; set; }

        public Decimal? CBs { get; set; }

        public Decimal? tmCO2s { get; set; }

        public Decimal? tmCOs { get; set; }

        public Decimal? tmPMs { get; set; }

        #endregion Instance Properties
    }

}
