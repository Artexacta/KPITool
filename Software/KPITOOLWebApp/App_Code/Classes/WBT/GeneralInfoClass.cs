using System;

namespace Artexacta.App.WBT
{
    public class GeneralInfoClass
    {
        #region Instance Properties

        public Int32 generalInfoID { get; set; }

        public Int32 surveyID { get; set; }

        public Int32 questionnaireID { get; set; }

        public String testNumber { get; set; }

        public String testerName { get; set; }

        public DateTime? testDate { get; set; }

        public String testLocation { get; set; }

        public String testReplicateNumber { get; set; }

        public Int32? altitude { get; set; }

        public String stoveType { get; set; }

        public String stoveManufacturer { get; set; }

        public String testDescription { get; set; }

        public String potDescription { get; set; }

        public Decimal? airRelativeHumidity { get; set; }

        public Decimal? localBoilingPoint { get; set; }

        public Decimal? atmosphericP { get; set; }

        public Decimal? pitotDeltaP { get; set; }

        public Decimal? hoodFlowRate { get; set; }

        public String testNotes { get; set; }

        public String fuelGeneralDesc { get; set; }

        public Int32? fuelType { get; set; }

        public String fuelDescription { get; set; }

        public Int32? fuelAverageLength { get; set; }

        public String crossSectionalDim { get; set; }

        public Boolean? measuredCalorificValues { get; set; }

        public Decimal? measuredGrossCalVal { get; set; }

        public Decimal? measuredNetCalVal { get; set; }

        public String descOfFireStarter { get; set; }

        public String hp_descFireStarted { get; set; }

        public String hp_descWhenFuelAdded { get; set; }

        public String hp_descHowMuchFuelAdded { get; set; }

        public String hp_deschowOftenFeedFuel { get; set; }

        public String hp_descAirControl { get; set; }

        public String st_descFireStarted { get; set; }

        public String st_descWhenFuelAdded { get; set; }

        public String st_descHowMuchFuelAdded { get; set; }

        public String st_deschowOftenFeedFuel { get; set; }

        public String st_descAirControl { get; set; }

        #endregion Instance Properties
    }

}
