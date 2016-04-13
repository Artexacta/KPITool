using Artexacta.App.WBT;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_WBT_TestUserControl : System.Web.UI.UserControl
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    private BasicDataClass theData;

    public BasicDataClass Data
    {
        set { theData = value; }
        get { return theData; }
    }

    public string TestIndex 
    {
        set { TestNumberLiteral.Text = value; }
        get { return TestNumberLiteral.Text; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;

        if (theData == null)
            return;


        GeneralInfoClass generalInfo = theData.TestParentObject.GeneralInfo;

        DataNameOfTester.Text = theData.testerName;
        DataTestNumberLiteral.Text = theData.testNumber;
        DataDateLiteral.Text = theData.testDate == null || theData.testDate == DateTime.MinValue ? "-" : theData.testDate.Value.ToShortDateString();
        DataLocationLiteral.Text = generalInfo.testLocation;
        DataStoveTypeLiteral.Text = generalInfo.stoveType;
        DataTypeOfFuelLiteral.Text = generalInfo.fuelGeneralDesc;

        //Initial Test Conditions

        AirTempreatureValue.Text = theData.airTemperature == null ? "-" : theData.airTemperature.ToString();
        WindConditionsValue.Text = theData.windConditions;
        FuelFimensionsValue.Text = theData.fuelDimensions;
        FuelMoistureContentValue.Text = theData.MC == null ? "-" : theData.MC.ToString();

        bool? measuredCalorificValues = generalInfo.measuredCalorificValues;

        GrossCalorificValueValue.Text = (measuredCalorificValues != null && (bool)measuredCalorificValues ? generalInfo.measuredGrossCalVal.ToString() : Artexacta.App.WBT.FuelType.GetHHVByID(Convert.ToInt32(generalInfo.fuelType)).ToString());
        decimal netCaloricValue = (measuredCalorificValues != null && (bool)measuredCalorificValues ? (generalInfo.measuredNetCalVal == null ? 0 : (decimal)generalInfo.measuredNetCalVal) : Convert.ToDecimal(Artexacta.App.WBT.FuelType.GetLHVByID(Convert.ToInt32(generalInfo.fuelType))));
        decimal mc = (theData.MC == null ? 0 : (decimal)theData.MC);
        NetCaloricValueValue.Text = netCaloricValue.ToString();


        EfectiveCaloricValueValue.Text = (netCaloricValue * (1 - mc/(decimal)100) - (mc/(decimal)100 * ((generalInfo.localBoilingPoint == null ? 0 : (decimal)generalInfo.localBoilingPoint) - (theData.airTemperature == null ? 0 : (decimal)theData.airTemperature)) * Convert.ToDecimal(4.2) + 2260)).ToString();

        CharCaloricValueValue.Text = Artexacta.App.WBT.FuelType.GetCharKjByID(Convert.ToInt32(generalInfo.fuelType)).ToString(); 

        DryWeightOfPot1Value.Text = theData.P1 == null ? "-" : theData.P1.ToString();
        DryWeightOfPot2Value.Text = theData.P2 == null ? "-" : theData.P2.ToString();
        DryWeightOfPot3Value.Text = theData.P3 == null ? "-" : theData.P3.ToString();
        DryWeightOfPot4Value.Text = theData.P4 == null ? "-" : theData.P4.ToString();
        WeightOfStoveValue.Text = theData.k == null ? "-" : theData.k.Value.ToString();
        LocalBoilingPointValue.Text = generalInfo.localBoilingPoint == null ? "-" : generalInfo.localBoilingPoint.ToString(); 

        BackgroundConcentrationsCo2Value.Text = theData.CO2_B == null ? "-" : theData.CO2_B.ToString();
        BackgroundConcentrationsCoValue.Text = theData.CO_B == null ? "-" : theData.CO_B.ToString();
        BackgroundConcentrationsPmValue.Text = theData.PM_B == null ? "-" : theData.PM_B.ToString();

        NoteAboutThisTest.Text = theData.testNotes;
        NotesOnTheHighPowerColdStartTest.Text = theData.NOTESHPCST;
        NotesOnTheHighPoweHotStartTest.Text = theData.NOTESHPHST;
        NotesOnTheHighPoweSimmerTest.Text = theData.NOTESLPST;

        
        try
        {
            List<PhotographsClass> thePhotographs = theData.TestParentObject.Photographs;
            var singlePhotograph = thePhotographs.FirstOrDefault(l => l.questionnaireID == theData.questionnaireID);
            if (singlePhotograph != null)
            {
                int potImageId = singlePhotograph.potPhotograph == null ? 0 : singlePhotograph.potPhotograph.Value;
                if (potImageId > 0)
                    PotImage.ImageUrl = "~/ImageResize.aspx?W=250&H=120&ID=" + potImageId.ToString();

                int stoveImageId = singlePhotograph.stovePhotograph == null ? 0 : singlePhotograph.stovePhotograph.Value;
                if (stoveImageId > 0)
                    StoveImage.ImageUrl = "~/ImageResize.aspx?W=250&H=120&ID=" + stoveImageId.ToString();
            }
            
        }
        catch (Exception ex)
        {
            log.Error("Error trying to get The Photograph object for current test", ex);
        }

        ClearColdCalculations();
        LoadColdStartData();
        ClearHotCalculations();
        LoadHotStartData();
        ClearSimmerTestData();
        LoadSimmerTestData();

        ClearColdCalculations();
        LoadColdCalculations();
        ClearHotCalculations();
        LoadHotCalculations();
        ClearSimmerCalculations();
        LoadSimmerCalculations();
    }

    #region ColdStartData

    private void LoadColdStartData()
    {
        try
        {
            List<ColdStartClass> coldStartList = theData.TestParentObject.ColdStart;
            var coldStartData = coldStartList.FirstOrDefault(l => l.questionnaireID == theData.questionnaireID);
            if (coldStartData != null)
            {
                TimeColdStartData.Text = coldStartData.tci == null || coldStartData.tci.Value == TimeSpan.MinValue ? "-" :
                    coldStartData.tci.Value.ToString();
                TimeColdFinishData.Text = coldStartData.tcf == null || coldStartData.tcf.Value == TimeSpan.MinValue ? "-" :
                    coldStartData.tcf.Value.ToString();

                WeighOfFuelColdStartData.Text = coldStartData.fci == null ? "-" : coldStartData.fci.Value.ToString();
                WeighOfFuelColdFinishData.Text = coldStartData.fcf == null ? "-" : coldStartData.fcf.Value.ToString();

                WaterTemperaturePot1ColdStartData.Text = coldStartData.T1ci == null ? "-" : coldStartData.T1ci.Value.ToString();
                WaterTemperaturePot1ColdFinishData.Text = coldStartData.T1cf == null ? "-" : coldStartData.T1cf.Value.ToString();

                WaterTemperaturePot2ColdStartData.Text = coldStartData.T2ci == null ? "-" : coldStartData.T2ci.Value.ToString();
                WaterTemperaturePot2ColdFinishData.Text = coldStartData.T2cf == null ? "-" : coldStartData.T2cf.Value.ToString();

                WaterTemperaturePot3ColdStartData.Text = coldStartData.T3ci == null ? "-" : coldStartData.T3ci.Value.ToString();
                WaterTemperaturePot3ColdFinishData.Text = coldStartData.T3cf == null ? "-" : coldStartData.T3cf.Value.ToString();

                WaterTemperaturePot4ColdStartData.Text = coldStartData.T4ci == null ? "-" : coldStartData.T4ci.Value.ToString();
                WaterTemperaturePot4ColdFinishData.Text = coldStartData.T4cf == null ? "-" : coldStartData.T4cf.Value.ToString();

                WeightOfPot1ColdStartData.Text = coldStartData.P1ci == null ? "-" : coldStartData.P1ci.Value.ToString();
                WeightOfPot1ColdFinishData.Text = coldStartData.P1cf == null ? "-" : coldStartData.P1cf.Value.ToString();

                WeightOfPot2ColdStartData.Text = coldStartData.P2ci == null ? "-" : coldStartData.P2ci.Value.ToString();
                WeightOfPot2ColdFinishData.Text = coldStartData.P2cf == null ? "-" : coldStartData.P2cf.Value.ToString();

                WeightOfPot3ColdStartData.Text = coldStartData.P3ci == null ? "-" : coldStartData.P3ci.Value.ToString();
                WeightOfPot3ColdFinishData.Text = coldStartData.P3cf == null ? "-" : coldStartData.P3cf.Value.ToString();

                WeightOfPot4ColdStartData.Text = coldStartData.P4ci == null ? "-" : coldStartData.P4ci.Value.ToString();
                WeightOfPot4ColdFinishData.Text = coldStartData.P4cf == null ? "-" : coldStartData.P4cf.Value.ToString();

                FireStartingMaterialsColdStartData.Text = coldStartData.TESTFIRESTARTC;

                WeightOfCharcoalStoveColdFinishData.Text = coldStartData.cc == null ? "-" : coldStartData.cc.Value.ToString();
                AverageCo2ColdFinishData.Text = coldStartData.CO2c == null ? "-" : coldStartData.CO2c.Value.ToString();
                AverageCoColdFinishData.Text = coldStartData.COc == null ? "-" : coldStartData.COc.Value.ToString();
                AveragePMColdFinishData.Text = coldStartData.PMc == null ? "-" : coldStartData.PMc.Value.ToString();
                AverageDuctTemperatureColdFinishData.Text = coldStartData.Tcd == null ? "-" : coldStartData.Tcd.Value.ToString();
                TotalCo2ColdFinishData.Text = coldStartData.mCO2_c == null ? "-" : coldStartData.mCO2_c.Value.ToString();

                TotalCoColdStartData.Text = "-";
                TotalCoColdFinishData.Text = coldStartData.mCO_c == null ? "-" : coldStartData.mCO_c.Value.ToString();

                TotalPmColdFinishData.Text = coldStartData.mPM_c == null ? "-" : coldStartData.mCO_c.Value.ToString();
            }
            else
            {
                ClearColdStarData();
            }

        }
        catch (Exception ex)
        {
            log.Error("Error loading Cold Data for test " + TestIndex, ex);
        }
    }

    private void ClearColdStarData()
    {
        TimeColdStartLabel.Text = "";
        TimeColdFinishLabel.Text = "";

        WeighOfFuelColdStartData.Text = "";
        WeighOfFuelColdFinishData.Text = "";

        WaterTemperaturePot1ColdStartData.Text = "";
        WaterTemperaturePot1ColdFinishData.Text = "";

        WaterTemperaturePot2ColdStartData.Text = "";
        WaterTemperaturePot2ColdFinishData.Text = "";

        WaterTemperaturePot3ColdStartData.Text = "";
        WaterTemperaturePot3ColdFinishData.Text = "";

        WaterTemperaturePot4ColdStartData.Text = "";
        WaterTemperaturePot4ColdFinishData.Text = "";

        WeightOfPot1ColdStartData.Text = "";
        WeightOfPot1ColdFinishData.Text = "";

        WeightOfPot2ColdStartData.Text = "";
        WeightOfPot2ColdFinishData.Text = "";

        WeightOfPot3ColdStartData.Text = "";
        WeightOfPot3ColdFinishData.Text = "";

        WeightOfPot4ColdStartData.Text = "";
        WeightOfPot4ColdFinishData.Text = "";

        FireStartingMaterialsColdStartData.Text = ""; ;

        WeightOfCharcoalStoveColdFinishData.Text = "";
        AverageCo2ColdFinishData.Text = "";
        AverageCoColdFinishData.Text = "";
        AveragePMColdFinishData.Text = "";
        AverageDuctTemperatureColdFinishData.Text = "";
        TotalCo2ColdFinishData.Text = "";

        TotalCoColdStartData.Text = "";
        TotalCoColdFinishData.Text = "";

        TotalPmColdFinishData.Text = "";
    }

    #endregion

    #region HotStartData

    private void LoadHotStartData()
    {
        try
        {
            List<HotStartClass> hotStartList = theData.TestParentObject.HotStart;
            var hotStartData = hotStartList.FirstOrDefault(l => l.questionnaireID == theData.questionnaireID);

            if (hotStartData != null)
            {
                TimeHotStartData.Text = hotStartData.thi == null ? "-" : hotStartData.thi.Value.ToString();
                TimeHotFinishData.Text = hotStartData.thi == null ? "-" : hotStartData.thf.Value.ToString();

                WeighOfFuelHotStartData.Text = hotStartData.fhi == null ? "-" : hotStartData.fhi.Value.ToString();
                WeighOfFuelHotFinishData.Text = hotStartData.fhf == null ? "-" : hotStartData.fhf.Value.ToString();

                WaterTemperaturePot1HotStartData.Text = hotStartData.T1hi == null ? "-" : hotStartData.T1hi.Value.ToString();
                WaterTemperaturePot1HotFinishData.Text = hotStartData.T1hf == null ? "-" : hotStartData.T1hf.Value.ToString();

                WaterTemperaturePot2HotStartData.Text = hotStartData.T2hi == null ? "-" : hotStartData.T2hi.Value.ToString();
                WaterTemperaturePot2HotFinishData.Text = hotStartData.T2hf == null ? "-" : hotStartData.T2hf.Value.ToString();

                WaterTemperaturePot3HotStartData.Text = hotStartData.T3hi == null ? "-" : hotStartData.T3hi.Value.ToString();
                WaterTemperaturePot3HotFinishData.Text = hotStartData.T3hf == null ? "-" : hotStartData.T3hf.Value.ToString();

                WaterTemperaturePot4HotStartData.Text = hotStartData.T4hi == null ? "-" : hotStartData.T4hi.Value.ToString();
                WaterTemperaturePot4HotFinishData.Text = hotStartData.T4hf == null ? "-" : hotStartData.T4hf.Value.ToString();

                WeightOfPot1HotStartData.Text = hotStartData.P1hi == null ? "-" : hotStartData.P1hi.Value.ToString();
                WeightOfPot1HotFinishData.Text = hotStartData.P1hf == null ? "-" : hotStartData.P1hf.Value.ToString();

                WeightOfPot1HotStartData.Text = hotStartData.P2hi == null ? "-" : hotStartData.P2hi.Value.ToString();
                WeightOfPot1HotFinishData.Text = hotStartData.P2hf == null ? "-" : hotStartData.P2hf.Value.ToString();

                WeightOfPot1HotStartData.Text = hotStartData.P3hi == null ? "-" : hotStartData.P3hi.Value.ToString();
                WeightOfPot1HotFinishData.Text = hotStartData.P3hf == null ? "-" : hotStartData.P3hf.Value.ToString();

                WeightOfPot1HotStartData.Text = hotStartData.P4hi == null ? "-" : hotStartData.P4hi.Value.ToString();
                WeightOfPot1HotFinishData.Text = hotStartData.P4hf == null ? "-" : hotStartData.P4hf.Value.ToString();

                FireStartingMaterialsHotStartLabel.Text = hotStartData.TESTFIRESTARTH;

                WeightOfCharcoalStoveHotFinishData.Text = hotStartData.ch == null ? "-" : hotStartData.ch.Value.ToString();
                AverageCo2HotFinishData.Text = hotStartData.CO2h == null ? "-" : hotStartData.CO2h.Value.ToString();
                AverageCoHotFinishData.Text = hotStartData.COh == null ? "-" : hotStartData.COh.Value.ToString();
                AveragePMHotFinishData.Text = hotStartData.PMh == null ? "-" : hotStartData.PMh.Value.ToString();
                AverageDuctTemperatureHotFinishData.Text = hotStartData.Thd == null ? "-" : hotStartData.Thd.Value.ToString();
                TotalCo2HotFinishData.Text = hotStartData.mCO2_h == null ? "-" : hotStartData.mCO2_h.Value.ToString();
                TotalCoHotFinishData.Text = hotStartData.mCO_h == null ? "-" : hotStartData.mCO_h.Value.ToString();
                TotalPmHotFinishData.Text = hotStartData.mPM_h == null ? "-" : hotStartData.mPM_h.Value.ToString();
            }
            else
            {
                ClearHotStartData();
            }
        }
        catch (Exception ex)
        {
            log.Error("Error loading Hot Data for test " + TestIndex, ex);
        }
    }

    private void ClearHotStartData()
    {
        TimeHotStartData.Text = "";
        TimeHotFinishData.Text = "";

        WeighOfFuelHotStartData.Text = "";
        WeighOfFuelHotFinishData.Text = "";

        WaterTemperaturePot1HotStartData.Text = "";
        WaterTemperaturePot1HotFinishData.Text = "";

        WaterTemperaturePot2HotStartData.Text = "";
        WaterTemperaturePot2HotFinishData.Text = "";

        WaterTemperaturePot3HotStartData.Text = "";
        WaterTemperaturePot3HotFinishData.Text = "";

        WaterTemperaturePot4HotStartData.Text = "";
        WaterTemperaturePot4HotFinishData.Text = "";

        WeightOfPot1HotStartData.Text = "";
        WeightOfPot1HotFinishData.Text = "";

        WeightOfPot1HotStartData.Text = "";
        WeightOfPot1HotFinishData.Text = "";

        WeightOfPot1HotStartData.Text = "";
        WeightOfPot1HotFinishData.Text = "";

        WeightOfPot1HotStartData.Text = "";
        WeightOfPot1HotFinishData.Text = "";

        FireStartingMaterialsHotStartLabel.Text = "";

        WeightOfCharcoalStoveHotFinishData.Text = "";
        AverageCo2HotFinishData.Text = "";
        AverageCoHotFinishData.Text = "";
        AveragePMHotFinishData.Text = "";
        AverageDuctTemperatureHotFinishData.Text = "";
        TotalCo2HotFinishData.Text = "";
        TotalCoHotFinishData.Text = "";
        TotalPmHotFinishData.Text = "";
    }

    #endregion

    #region SimmerTestData

    private void LoadSimmerTestData()
    {
        try
        {
            List<SimmerClass> simmerList = theData.TestParentObject.Simmer;
            var simmerData = simmerList.FirstOrDefault(l => l.questionnaireID == theData.questionnaireID);

            if (simmerData != null)
            {
                TimeSimmerStartData.Text = simmerData.tsi == null ? "-" : simmerData.tsi.Value.ToString();
                TimeSimmerFinishData.Text = simmerData.tsf == null ? "-" : simmerData.tsf.Value.ToString();

                WeighOfFuelSimmerStartData.Text = simmerData.fsi == null ? "-" : simmerData.fsi.Value.ToString();
                WeighOfFuelSimmerFinishData.Text = simmerData.fsf == null ? "-" : simmerData.fsf.Value.ToString();

                WaterTemperaturePot1SimmerStartData.Text = simmerData.T1si == null ? "-" : simmerData.T1si.Value.ToString();
                WaterTemperaturePot1SimmerFinishData.Text = simmerData.T1sf == null ? "-" : simmerData.T1sf.Value.ToString();

                WaterTemperaturePot2SimmerStartData.Text = simmerData.T2si == null ? "-" : simmerData.T2si.Value.ToString();
                WaterTemperaturePot2SimmerFinishData.Text = simmerData.T2sf == null ? "-" : simmerData.T2sf.Value.ToString();

                WaterTemperaturePot3SimmerStartData.Text = simmerData.T3si == null ? "-" : simmerData.T3si.Value.ToString();
                WaterTemperaturePot3SimmerFinishData.Text = simmerData.T3sf == null ? "-" : simmerData.T3sf.Value.ToString();

                WaterTemperaturePot4SimmerStartData.Text = simmerData.T4si == null ? "-" : simmerData.T4si.Value.ToString();
                WaterTemperaturePot4SimmerFinishData.Text = simmerData.T4sf == null ? "-" : simmerData.T4sf.Value.ToString();

                WeightOfPot1SimmerStartData.Text = simmerData.P1si == null ? "-" : simmerData.P1si.Value.ToString();
                WeightOfPot1SimmerFinishData.Text = simmerData.P1sf == null ? "-" : simmerData.P1sf.Value.ToString();

                WeightOfPot2SimmerStartData.Text = simmerData.P2si == null ? "-" : simmerData.P2si.Value.ToString();
                WeightOfPot2SimmerFinishData.Text = simmerData.P2sf == null ? "-" : simmerData.P2sf.Value.ToString();

                WeightOfPot3SimmerStartData.Text = simmerData.P3si == null ? "-" : simmerData.P3si.Value.ToString();
                WeightOfPot3SimmerFinishData.Text = simmerData.P3sf == null ? "-" : simmerData.P3sf.Value.ToString();

                WeightOfPot4SimmerStartData.Text = simmerData.P4si == null ? "-" : simmerData.P4si.Value.ToString();
                WeightOfPot4SimmerFinishData.Text = simmerData.P4sf == null ? "-" : simmerData.P4sf.Value.ToString();

                FireStartingMaterialsSimmerStartData.Text = simmerData.TESTFIRESTARTS;

                WeightOfCharcoalStoveSimmerFinishData.Text = simmerData.cs == null ? "-" : simmerData.cs.Value.ToString();
                AverageCo2SimmerFinishData.Text = simmerData.CO2s == null ? "-" : simmerData.CO2s.Value.ToString();
                AverageCoSimmerFinishData.Text = simmerData.COs == null ? "-" : simmerData.COs.Value.ToString();
                AveragePMSimmerFinishData.Text = simmerData.PMs == null ? "-" : simmerData.PMs.Value.ToString();
                AverageDuctTemperatureSimmerFinishData.Text = simmerData.Tsd == null ? "-" : simmerData.Tsd.Value.ToString();
                TotalCo2SimmerFinishData.Text = simmerData.mCO2_s == null ? "-" : simmerData.mCO2_s.Value.ToString();
                TotalCoSimmerFinishData.Text = simmerData.mCO_s == null ? "-" : simmerData.mCO_s.Value.ToString();
                TotalPmSimmerFinishData.Text = simmerData.mPM_s == null ? "-" : simmerData.mPM_s.Value.ToString();
            }
            else
            {
                ClearSimmerTestData();
            }
        }
        catch (Exception ex)
        {
            log.Error("Error loading Simmer Data for test " + TestIndex, ex);
        }
    }

    private void ClearSimmerTestData()
    {
        TimeSimmerStartData.Text = "";
        TimeSimmerFinishData.Text = "";

        WeighOfFuelSimmerStartData.Text = "";
        WeighOfFuelSimmerFinishData.Text = "";

        WaterTemperaturePot1SimmerStartData.Text = "";
        WaterTemperaturePot1SimmerFinishData.Text = "";

        WaterTemperaturePot2SimmerStartData.Text = "";
        WaterTemperaturePot2SimmerFinishData.Text = "";

        WaterTemperaturePot3SimmerStartData.Text = "";
        WaterTemperaturePot3SimmerFinishData.Text = "";

        WaterTemperaturePot4SimmerStartData.Text = "";
        WaterTemperaturePot4SimmerFinishData.Text = "";

        WeightOfPot1SimmerStartData.Text = "";
        WeightOfPot1SimmerFinishData.Text = "";

        WeightOfPot2SimmerStartData.Text = "";
        WeightOfPot2SimmerFinishData.Text = "";

        WeightOfPot3SimmerStartData.Text = "";
        WeightOfPot3SimmerFinishData.Text = "";

        WeightOfPot4SimmerStartData.Text = "";
        WeightOfPot4SimmerFinishData.Text = "";

        FireStartingMaterialsSimmerStartData.Text = "";

        WeightOfCharcoalStoveSimmerFinishData.Text = "";
        AverageCo2SimmerFinishData.Text = "";
        AverageCoSimmerFinishData.Text = "";
        AveragePMSimmerFinishData.Text = "";
        AverageDuctTemperatureSimmerFinishData.Text = "";
        TotalCo2SimmerFinishData.Text = "";
        TotalCoSimmerFinishData.Text = "";
        TotalPmSimmerFinishData.Text = "";
    }

    #endregion

    #region Cold Start Calculation

    private void LoadColdCalculations()
    {
        try
        {
            List<ColdStartCalculationsClass> calculationsList = theData.TestParentObject.ColdStartCalculations;
            var calculationData = calculationsList.FirstOrDefault(l => l.questionnaireID == theData.questionnaireID);

            if (calculationData != null)
            {
                FuelConsumedColdStartData.Text = calculationData.fcm == null ? "-" : calculationData.fcm.Value.ToString();
                NetChangeInCarColdStartData.Text = calculationData.deltacc == null ? "-" : calculationData.deltacc.Value.ToString();
                EquivalentDryFuelConsumedColdStartData.Text = calculationData.fcd == null ? "-" : calculationData.fcd.Value.ToString();
                WaterVaporizedColdStartData.Text = calculationData.wcv == null ? "-" : calculationData.wcv.Value.ToString();
                EffectoveMassOfWaterBoiledColdStartData.Text = calculationData.wcr == null ? "-" : calculationData.wcr.Value.ToString();
                TimeToBoilPot1ColdStartData.Text = calculationData.deltatc == null ? "-" : calculationData.deltatc.Value.ToString();
                TempCorrTimeToBoilPot1ColdStartData.Text = calculationData.deltatTc == null ? "-" : calculationData.deltatTc.Value.ToString();
                ThermalEfficiencyColdStartData.Text = calculationData.hc == null ? "-" : calculationData.hc.Value.ToString();
                BurningRateColdStartData.Text = calculationData.rcb == null ? "-" : calculationData.rcb.Value.ToString();
                SpecificFuelConsumptionColdStartData.Text = calculationData.SCc == null ? "-" : calculationData.SCc.Value.ToString();
                TempCorrSpConsumptionColdStartData.Text = calculationData.SCTc == null ? "-" : calculationData.SCTc.Value.ToString();
                TempCorrSpEnergyConsumptionColdStartData.Text = calculationData.SETC == null ? "-" : calculationData.SETC.Value.ToString();
                FirepowerColdStartData.Text = calculationData.FPc == null ? "-" : calculationData.FPc.Value.ToString();
            }
            else
            {
                ClearColdCalculations();
            }
        }
        catch (Exception ex)
        {
            log.Error("Error loading Cold Calculations for test " + TestIndex, ex);
        }
    }

    private void ClearColdCalculations()
    {
        FuelConsumedColdStartData.Text = "";
        NetChangeInCarColdStartData.Text = "";
        EquivalentDryFuelConsumedColdStartData.Text = "";
        WaterVaporizedColdStartData.Text = "";
        EffectoveMassOfWaterBoiledColdStartData.Text = "";
        TimeToBoilPot1ColdStartData.Text = "";
        TempCorrTimeToBoilPot1ColdStartData.Text = "";
        ThermalEfficiencyColdStartData.Text = "";
        BurningRateColdStartData.Text = "";
        SpecificFuelConsumptionColdStartData.Text = "";
        TempCorrSpConsumptionColdStartData.Text = "";
        TempCorrSpEnergyConsumptionColdStartData.Text = "";
        FirepowerColdStartData.Text = "";
        FirepowerColdStartData.Text = "";
    }

    #endregion

    #region Hot Start Calculation

    private void LoadHotCalculations()
    {
        try
        {
            List<HotStartCalculationsClass> calculationsList = theData.TestParentObject.HotStartCalculations;
            var calculationData = calculationsList.FirstOrDefault(l => l.questionnaireID == theData.questionnaireID);

            if (calculationData != null)
            {
                FuelConsumedHotStartData.Text = calculationData.fhm == null ? "-" : calculationData.fhm.Value.ToString();
                NetChangeInCarHotStartData.Text = calculationData.deltach == null ? "-" : calculationData.deltach.Value.ToString();
                EquivalentDryFuelConsumedHotStartData.Text = calculationData.fhd == null ? "-" : calculationData.fhd.Value.ToString();
                WaterVaporizedHotStartData.Text = calculationData.whv == null ? "-" : calculationData.whv.Value.ToString();
                EffectoveMassOfWaterBoiledHotStartData.Text = calculationData.whr == null ? "-" : calculationData.whr.Value.ToString();
                TimeToBoilPot1ColdHotStartData.Text = calculationData.deltath == null ? "-" : calculationData.deltath.Value.ToString();
                TempCorrTimeToBoilPot1HotStartData.Text = calculationData.deltatTh == null ? "-" : calculationData.deltatTh.Value.ToString();
                ThermalEfficiencyHotStartData.Text = calculationData.hh == null ? "-" : calculationData.hh.Value.ToString();
                BurningRateHotStartData.Text = calculationData.rhb == null ? "-" : calculationData.rhb.Value.ToString();
                SpecificFuelConsumptionHotStartData.Text = calculationData.SCh == null ? "-" : calculationData.SCh.Value.ToString();
                TempCorrSpConsumptionHotStartData.Text = calculationData.SCTh == null ? "-" : calculationData.SCTh.Value.ToString();
                TempCorrSpEnergyConsumptionHotStartData.Text = calculationData.SETH == null ? "-" : calculationData.SETH.Value.ToString();
                FirepowerHotStartData.Text = calculationData.FPh == null ? "-" : calculationData.FPh.Value.ToString();
            }
            else
            {
                ClearHotCalculations();
            }
        }
        catch (Exception ex)
        {
            log.Error("Error loading Hot Calculations for test " + TestIndex, ex);
        }
    }

    private void ClearHotCalculations()
    {
        FuelConsumedHotStartData.Text = "";
        NetChangeInCarHotStartData.Text = "";
        EquivalentDryFuelConsumedHotStartData.Text = "";
        WaterVaporizedHotStartData.Text = "";
        EffectoveMassOfWaterBoiledHotStartData.Text = "";
        TimeToBoilPot1ColdHotStartData.Text = "";
        TempCorrTimeToBoilPot1HotStartData.Text = "";
        ThermalEfficiencyHotStartData.Text = "";
        BurningRateHotStartData.Text = "";
        SpecificFuelConsumptionHotStartData.Text = "";
        TempCorrSpConsumptionHotStartData.Text = "";
        TempCorrSpEnergyConsumptionHotStartData.Text = "";
        FirepowerHotStartData.Text = "";
    }

    #endregion

    #region Simmer Calculation

    private void LoadSimmerCalculations()
    {
        try
        {
            List<SimmerCalculationsClass> calculationsList = theData.TestParentObject.SimmerCalculations;
            var calculationData = calculationsList.FirstOrDefault(l => l.questionnaireID == theData.questionnaireID);

            if (calculationData != null)
            {
                FuelConsumedSimmerData.Text = calculationData.fsm == null ? "-" : calculationData.fsm.Value.ToString();
                NetChangeInCarSimmerData.Text = calculationData.deltacs == null ? "-" : calculationData.deltacs.Value.ToString();
                EquivalentDryFuelConsumedSimmerData.Text = calculationData.fsd == null ? "-" : calculationData.fsd.Value.ToString();
                WaterVaporizedSimmerData.Text = calculationData.wsv == null ? "-" : calculationData.wsv.Value.ToString();
                EffectoveMassOfWaterBoiledSimmerData.Text = calculationData.wsr == null ? "-" : calculationData.wsr.Value.ToString();
                TimeToBoilPot1ColdSimmerData.Text = calculationData.deltats == null ? "-" : calculationData.deltats.Value.ToString();
                TempCorrTimeToBoilPot1SimmerData.Text = calculationData.hs == null ? "-" : calculationData.hs.Value.ToString();
                ThermalEfficiencyHotStartData.Text = calculationData.hs == null ? "-" : calculationData.hs.Value.ToString();
                ThermalEfficiencySimmerData.Text = calculationData.rsb == null ? "-" : calculationData.rsb.Value.ToString();
                BurningRateSimmerData.Text = calculationData.SCs == null ? "-" : calculationData.SCs.Value.ToString();
                SpecificFuelConsumptionSimmerData.Text = calculationData.FPs == null ? "-" : calculationData.FPs.Value.ToString();
                TempCorrSpConsumptionSimmerData.Text = calculationData.TDR == null ? "-" : calculationData.TDR.Value.ToString();
                TempCorrSpEnergyConsumptionSimmerData.Text = calculationData.SES == null ? "-" : calculationData.SES.Value.ToString();
                FirepowerSimmerData.Text = calculationData.BF == null ? "-" : calculationData.BF.Value.ToString();
                EnergyBenchmarkToCompleteSimmerData.Text = calculationData.BE == null ? "-" : calculationData.BE.Value.ToString();
            }
            else
            {
                ClearSimmerCalculations();
            }
        }
        catch (Exception ex)
        {
            log.Error("Error loading Hot Calculations for test " + TestIndex, ex);
        }
    }

    private void ClearSimmerCalculations()
    {
        FuelConsumedSimmerData.Text = "";
        NetChangeInCarSimmerData.Text = "";
        EquivalentDryFuelConsumedSimmerData.Text = "";
        WaterVaporizedSimmerData.Text = "";
        EffectoveMassOfWaterBoiledSimmerData.Text = "";
        TimeToBoilPot1ColdSimmerData.Text = "";
        TempCorrTimeToBoilPot1SimmerData.Text = "";
        ThermalEfficiencyHotStartData.Text = "";
        ThermalEfficiencySimmerData.Text = "";
        BurningRateSimmerData.Text = "";
        SpecificFuelConsumptionSimmerData.Text = "";
        TempCorrSpConsumptionSimmerData.Text = "";
        TempCorrSpEnergyConsumptionSimmerData.Text = "";
        FirepowerSimmerData.Text = "";
        EnergyBenchmarkToCompleteSimmerData.Text = "";
    }

    #endregion
}