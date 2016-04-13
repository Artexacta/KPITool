using System;

namespace Artexacta.App.WBT
{
    public class IWAPERFORMANCEMETRICS_GeneralClass
    {
        #region Instance Properties

        public Int32 iwaPerfMetricsGeneralID { get; set; }

        public Int32 surveyID { get; set; }

        public Int32 questionnaireID { get; set; }

        public String testNumber { get; set; }

        public Decimal? highPowerThermalEfficiency { get; set; }

        public Int32? highPowerThermalEfficiencyTier { get; set; }

        public Decimal? lowPowerSpecificFuelConsumption { get; set; }

        public Int32? lowPowerSpecificFuelConsumptionTier { get; set; }

        #endregion Instance Properties
    }

}
