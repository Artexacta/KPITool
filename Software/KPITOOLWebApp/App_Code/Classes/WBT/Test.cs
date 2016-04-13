using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.WBT
{
    /// <summary>
    /// Summary description for Test
    /// </summary>
    public class Test
    {
        public int TestIndex { get; set; }
        public string TestNumber { get; set; }
        private GeneralInfoClass _generalInfo;
        private GeneralTestCalculationsClass _generalTestCalculations;
        private List<BasicDataClass> _basicData;

        public GeneralTestCalculationsClass GeneralTestCalculations
        {
            get {
                if (_generalTestCalculations == null)
                {
                    try
                    {
                        _generalTestCalculations = GeneralTestCalculationsBLL.getGeneralTestCalculationsByTestNumber(TestNumber);
                    }
                    catch (Exception q)
                    {
                        throw q;
                    }
                }
                return _generalTestCalculations;
            }
        }
        

        public GeneralInfoClass GeneralInfo
        {
            get {
                if (_generalInfo == null)
                {
                    try
                    {
                        _generalInfo = GeneralInfoBLL.getGeneralInfoByTestNumber(TestNumber);
                    }
                    catch (Exception q)
                    {
                        throw q;
                    }
                }
                return _generalInfo;
            }
        }

        public List<BasicDataClass> BasicData
        {
            get
            {
                if (_basicData == null)
                {
                    try
                    {
                        _basicData = BasicDataBLL.getBasicDataByTestNumber(TestNumber);
                        foreach (var item in _basicData)
                        {
                            item.TestParentObject = this;
                        }
                    }
                    catch (Exception q)
                    {
                        throw q;
                    }
                }
                return _basicData;
            }
        }

        public List<ColdStartClass> ColdStart
        {
            get
            {
                List<ColdStartClass> obj = null;
                try
                {
                    obj = ColdStartBLL.getColdStartByTestNumber(TestNumber);
                }
                catch (Exception q)
                {
                    throw q;
                }
                return obj;
            }
        }

        public List<HotStartClass> HotStart
        {
            get
            {
                List<HotStartClass> obj = null;
                try
                {
                    obj = HotStartBLL.getHotStartByTestNumber(TestNumber);
                }
                catch (Exception q)
                {
                    throw q;
                }
                return obj;
            }
        }

        public List<SimmerClass> Simmer
        {
            get
            {
                List<SimmerClass> obj = null;
                try
                {
                    obj = SimmerBLL.getSimmerByTestNumber(TestNumber);
                }
                catch (Exception q)
                {
                    throw q;
                }
                return obj;
            }
        }

        public List<ColdStartCalculationsClass> ColdStartCalculations
        {
            get
            {
                List<ColdStartCalculationsClass> obj = null;
                try
                {
                    obj = ColdStartCalculationsBLL.getColdStartCalculationsByTestNumber(TestNumber);
                }
                catch (Exception q)
                {
                    throw q;
                }
                return obj;
            }
        }

        public List<HotStartCalculationsClass> HotStartCalculations
        {
            get
            {
                List<HotStartCalculationsClass> obj = null;
                try
                {
                    obj = HotStartCalculationsBLL.getHotStartCalculationsByTestNumber(TestNumber);
                }
                catch (Exception q)
                {
                    throw q;
                }
                return obj;
            }
        }

        public List<SimmerCalculationsClass> SimmerCalculations
        {
            get
            {
                List<SimmerCalculationsClass> obj = null;
                try
                {
                    obj = SimmerCalculationsBLL.getSimmerCalculationsByTestNumber(TestNumber);
                }
                catch (Exception q)
                {
                    throw q;
                }
                return obj;
            }
        }

        public List<ColdStartEmissions_GeneralClass> ColdStartEmissions_General
        {
            get
            {
                List<ColdStartEmissions_GeneralClass> obj = null;
                try
                {
                    obj = ColdStartEmissions_GeneralBLL.getColdStartEmissions_GeneralByTestNumber(TestNumber);
                }
                catch (Exception q)
                {
                    throw q;
                }
                return obj;
            }
        }

        public List<HotStartEmissions_GeneralClass> HotStartEmissions_General
        {
            get
            {
                List<HotStartEmissions_GeneralClass> obj = null;
                try
                {
                    obj = HotStartEmissions_GeneralBLL.getHotStartEmissions_GeneralByTestNumber(TestNumber);
                }
                catch (Exception q)
                {
                    throw q;
                }
                return obj;
            }
        }

        public List<SimmerEmissions_GeneralClass> SimmerEmissions_General
        {
            get
            {
                List<SimmerEmissions_GeneralClass> obj = null;
                try
                {
                    obj = SimmerEmissions_GeneralBLL.getSimmerEmissions_GeneralByTestNumber(TestNumber);
                }
                catch (Exception q)
                {
                    throw q;
                }
                return obj;
            }
        }

        public List<IWAPERFORMANCEMETRICS_GeneralClass> IWAPERFORMANCEMETRICS_General
        {
            get
            {
                List<IWAPERFORMANCEMETRICS_GeneralClass> obj = null;
                try
                {
                    obj = IWAPERFORMANCEMETRICS_GeneralBLL.getIWAPERFORMANCEMETRICS_GeneralByTestNumber(TestNumber);
                }
                catch (Exception q)
                {
                    throw q;
                }
                return obj;
            }
        }

        public List<PhotographsClass> Photographs
        {
            get
            {
                List<PhotographsClass> obj = null;
                try
                {
                    obj = PhotographsBLL.getPhotographsByTestNumber(TestNumber);
                }
                catch (Exception q)
                {
                    throw q;
                }
                return obj;
            }
        }


        public Test(int testIndex, string testNumber)
        {
            TestIndex = testIndex;
            TestNumber = testNumber;
            _generalTestCalculations = null;
            _generalInfo = null;
            _basicData = null;
        }
    }
}