﻿using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Web;
using log4net;
using Artexacta.App.Configuration;

namespace Artexacta.App.WBT
{
    public class GeneralInfoBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public GeneralInfoBLL() { }

        private static GeneralInfoClass FillRecord(TestDS.WBTGeneralInfoRow row)
        {
            GeneralInfoClass obj = new GeneralInfoClass();

            // Insert here the code to recover the object from row


            obj.generalInfoID = row.generalInfoID;

            obj.surveyID = row.surveyID;

            obj.questionnaireID = row.questionnaireID;

            obj.testNumber = row.testNumber;

            obj.testerName = row.testerName;

            obj.testDate = row.IstestDateNull() ? (DateTime?)null : row.testDate;

            obj.testLocation = row.testLocation;

            obj.testReplicateNumber = row.IstestReplicateNumberNull() ? "" : row.testReplicateNumber;

            obj.altitude = row.IsaltitudeNull() ? (int?)null : row.altitude;

            obj.stoveType = row.IsstoveTypeNull() ? "" : row.stoveType;

            obj.stoveManufacturer = row.IsstoveManufacturerNull() ? "" : row.stoveManufacturer;

            obj.testDescription = row.IstestDescriptionNull() ? "" : row.testDescription;

            obj.potDescription = row.IspotDescriptionNull() ? "" : row.potDescription;

            obj.airRelativeHumidity = row.IsairRelativeHumidityNull() ? (decimal?)null : row.airRelativeHumidity;

            obj.localBoilingPoint = row.IslocalBoilingPointNull() ? (decimal?)null : row.localBoilingPoint;

            obj.atmosphericP = row.IsatmosphericPNull() ? (decimal?)null : row.atmosphericP;

            obj.pitotDeltaP = row.IspitotDeltaPNull() ? (decimal?)null : row.pitotDeltaP;

            obj.hoodFlowRate = row.IshoodFlowRateNull() ? (decimal?)null : row.hoodFlowRate;

            obj.testNotes = row.IstestNotesNull() ? "" : row.testNotes;

            obj.fuelGeneralDesc = row.IsfuelGeneralDescNull() ? "" : row.fuelGeneralDesc;

            obj.fuelType = row.IsfuelTypeNull() ? (int?)null : row.fuelType;

            obj.fuelDescription = row.IsfuelDescriptionNull() ? "" : row.fuelDescription;

            obj.fuelAverageLength = row.IsfuelAverageLengthNull() ? (int?)null : row.fuelAverageLength;

            obj.crossSectionalDim = row.IscrossSectionalDimNull() ? "" : row.crossSectionalDim;

            obj.measuredCalorificValues = row.IsmeasuredCalorificValuesNull() ? (bool?)null : row.measuredCalorificValues;

            obj.measuredGrossCalVal = row.IsmeasuredGrossCalValNull() ? (decimal?)null : row.measuredGrossCalVal;

            obj.measuredNetCalVal = row.IsmeasuredNetCalValNull() ? (decimal?)null : row.measuredNetCalVal;

            obj.descOfFireStarter = row.IsdescOfFireStarterNull() ? "" : row.descOfFireStarter;

            obj.hp_descFireStarted = row.Ishp_descFireStartedNull() ? "" : row.hp_descFireStarted;

            obj.hp_descWhenFuelAdded = row.Ishp_descWhenFuelAddedNull() ? "" : row.hp_descWhenFuelAdded;

            obj.hp_descHowMuchFuelAdded = row.Ishp_descHowMuchFuelAddedNull() ? "" : row.hp_descHowMuchFuelAdded;

            obj.hp_deschowOftenFeedFuel = row.Ishp_deschowOftenFeedFuelNull() ? "" : row.hp_deschowOftenFeedFuel;

            obj.hp_descAirControl = row.Ishp_descAirControlNull() ? "" : row.hp_descAirControl;

            obj.st_descFireStarted = row.Isst_descFireStartedNull() ? "" : row.st_descFireStarted;

            obj.st_descWhenFuelAdded = row.Isst_descWhenFuelAddedNull() ? "" : row.st_descWhenFuelAdded;

            obj.st_descHowMuchFuelAdded = row.Isst_descHowMuchFuelAddedNull() ? "" : row.st_descHowMuchFuelAdded;

            obj.st_deschowOftenFeedFuel = row.Isst_deschowOftenFeedFuelNull() ? "" : row.st_deschowOftenFeedFuel;

            obj.st_descAirControl = row.Isst_descAirControlNull() ? "" : row.st_descAirControl;

            return obj;
        }

        public static GeneralInfoClass getGeneralInfoByTestNumber(string testNumber)
        {
            if (string.IsNullOrWhiteSpace(testNumber))
                throw new ArgumentException("Test Number cannot be empty");

            GeneralInfoClass obj = null;
            try
            {
                TestDSTableAdapters.WBTGeneralInfoTableAdapter adapter = new TestDSTableAdapters.WBTGeneralInfoTableAdapter();
                TestDS.WBTGeneralInfoDataTable theTable = adapter.GetGeneralInfoByTestNumber(testNumber);

                if (theTable == null || theTable.Rows.Count <= 0)
                    return null;

                obj = FillRecord(theTable[0]);
            }
            catch (Exception q)
            {
                log.Error("Error gettint GeneralInfo with test number " + testNumber, q);
                throw q;
            }

            return obj;
        }
    }
}