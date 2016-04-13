using System;

namespace Artexacta.App.WBT
{
    public class ColdStartClass
    {
        #region Instance Properties

        public Int32 coldStartID { get; set; }

        public Int32 surveyID { get; set; }

        public Int32 questionnaireID { get; set; }

        public String testNumber { get; set; }

        public TimeSpan? tci { get; set; }

        public Int32? fci { get; set; }

        public Decimal? T1ci { get; set; }

        public Decimal? T2ci { get; set; }

        public Decimal? T3ci { get; set; }

        public Decimal? T4ci { get; set; }

        public Int32? P1ci { get; set; }

        public Int32? P2ci { get; set; }

        public Int32? P3ci { get; set; }

        public Int32? P4ci { get; set; }

        public String TESTFIRESTARTC { get; set; }

        public TimeSpan? tcf { get; set; }

        public Int32? fcf { get; set; }

        public Decimal? T1cf { get; set; }

        public Decimal? T2cf { get; set; }

        public Decimal? T3cf { get; set; }

        public Decimal? T4cf { get; set; }

        public Int32? P1cf { get; set; }

        public Int32? P2cf { get; set; }

        public Int32? P3cf { get; set; }

        public Int32? P4cf { get; set; }

        public Decimal? cc { get; set; }

        public Decimal? CO2c { get; set; }

        public Decimal? COc { get; set; }

        public Decimal? PMc { get; set; }

        public Decimal? Tcd { get; set; }

        public Decimal? mCO2_c { get; set; }

        public Decimal? mCO_c { get; set; }

        public Decimal? mPM_c { get; set; }

        #endregion Instance Properties
    }

}