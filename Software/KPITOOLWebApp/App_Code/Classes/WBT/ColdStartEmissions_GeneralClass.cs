using System;

namespace Artexacta.App.WBT
{
    public class ColdStartEmissions_GeneralClass
    {
        #region Instance Properties

        public Int32 coldStartEmissionsGeneralID { get; set; }

        public Int32 surveyID { get; set; }

        public Int32 questionnaireID { get; set; }

        public String testNumber { get; set; }

        public Decimal? Vc { get; set; }

        public Decimal? CCc { get; set; }

        public Decimal? Cc { get; set; }

        public Decimal? fce { get; set; }

        public Decimal? CBc { get; set; }

        public Decimal? tmCO2c { get; set; }

        public Decimal? tmCOc { get; set; }

        public Decimal? tmPMc { get; set; }

        #endregion Instance Properties
    }

}
