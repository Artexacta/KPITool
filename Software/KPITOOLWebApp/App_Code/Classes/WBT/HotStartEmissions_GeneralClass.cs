using System;

namespace Artexacta.App.WBT
{
    public class HotStartEmissions_GeneralClass
    {
        #region Instance Properties

        public Int32 hotStartEmissionsGeneralID { get; set; }

        public Int32 surveyID { get; set; }

        public Int32 questionnaireID { get; set; }

        public String testNumber { get; set; }

        public Decimal? Vh { get; set; }

        public Decimal? CCh { get; set; }

        public Decimal? Ch { get; set; }

        public Decimal? fhe { get; set; }

        public Decimal? CBh { get; set; }

        public Decimal? tmCO2h { get; set; }

        public Decimal? tmCOh { get; set; }

        public Decimal? tmPMh { get; set; }

        #endregion Instance Properties
    }

}
