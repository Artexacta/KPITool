<%@ Control Language="C#" AutoEventWireup="true" CodeFile="TestUserControl.ascx.cs" Inherits="UserControls_WBT_TestUserControl" %>

<div class="row">
    <div class="col-lg-12">
        <div class="ibox float-e-margins border-bottom  border-right">
            <div class="ibox-title">
                <h5>
                    <asp:Literal runat="server" Text="<%$ Resources: Test, TestTitle %>"></asp:Literal>
                    -
                    <asp:Literal runat="server" Text="<%$ Resources: Test, VersionLabel %>"></asp:Literal>
                    -
                    <asp:Literal runat="server" Text="<%$ Resources: Test, TestLabel %>"></asp:Literal>
                    <asp:Literal ID="TestNumberLiteral" runat="server"></asp:Literal>
                </h5>
                <div class="ibox-tools">
                    <a class="collapse-link">
                        <i class="fa fa-chevron-down"></i>
                    </a>
                </div>
            </div>
            <div class="ibox-content" style="display: none;">
                <h2 class="m-t-none m-b-none">Data and Calculation Form
                </h2>
                <em class="m-t-none m-b">Shaded cells and arrows require user input; unshaded cells automatically display outputs 
                </em>
                <div class="row">
                    <div class="col-lg-7">

                        <h4 class="m-t-none m-b">Qualitative data
                        </h4>
                        <div class="form-horizontal" style="clear: both">
                            <div class="form-group">
                                <label class="col-lg-4">Name(s) of Tester(s)</label>
                                <div class="col-lg-8">
                                    <asp:Literal ID="DataNameOfTester" runat="server" Text="Alex. Fischer"></asp:Literal>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-lg-4">Test Number</label>
                                <div class="col-lg-8">
                                    <asp:Literal ID="DataTestNumberLiteral" runat="server" Text="1"></asp:Literal>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-lg-4">Date</label>
                                <div class="col-lg-8">
                                    <asp:Literal ID="DataDateLiteral" runat="server" Text="04/04/2015"></asp:Literal>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-lg-4">Location</label>
                                <div class="col-lg-8">
                                    <asp:Literal ID="DataLocationLiteral" runat="server" Text="FU - BECT"></asp:Literal>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-lg-4">Stove type/model</label>
                                <div class="col-lg-8">
                                    <asp:Literal ID="DataStoveTypeLiteral" runat="server" Text="Envirofit Econofire"></asp:Literal>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-lg-4">Type of fuel</label>
                                <div class="col-lg-8">
                                    <asp:Literal ID="DataTypeOfFuelLiteral" runat="server" Text="wood"></asp:Literal>
                                </div>
                            </div>
                        </div>

                        <div style="margin: 15px 0px; overflow: hidden; display:none;">
                            <span class="label pull-left">efficiency</span>
                            <span class="label pull-left badge-info">emissions</span>
                            <span class="label pull-left badge-danger">error, missing input</span>
                        </div>

                    </div>

                    <div class="col-lg-5">
                        <asp:Image ID="StoveImage" runat="server" ImageUrl="~/Images/logo.png" AlternateText="" />
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <h4 class="m-t-none m-b">Initial Test Conditions</h4>
                        <div class="table-responsive">
                            <table class="table initial-test-condition">
                                <colgroup>
                                    <col class="row-text-left" />
                                    <col span="2" />
                                    <col class="table-rigth-border" />
                                    <col span="4" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>Data</th>
                                        <th>Value</th>
                                        <th>Units</th>
                                        <th>Label</th>

                                        <th colspan="2">Data</th>
                                        <th>Value</th>
                                        <th>Units</th>
                                        <th>Label</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Air temperature</td>
                                        <td>
                                            <asp:Literal ID="AirTempreatureValue" runat="server" Text="27.9"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="AirTempreatureUnits" runat="server" Text="ºC"></asp:Literal>
                                        </td>
                                        <td></td>

                                        <td colspan="2" class="text-left">Dry weight of Pot # 1 (grams)
                                        </td>
                                        <td>
                                            <asp:Literal ID="DryWeightOfPot1Value" runat="server" Text="611"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="DryWeightOfPot1Units" runat="server" Text="g"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="DryWeightOfPot1Label" runat="server" Text="P1"></asp:Literal>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Wind conditions</td>
                                        <td colspan="2">
                                            <asp:Literal ID="WindConditionsValue" runat="server" Text="No Wind"></asp:Literal>
                                        </td>
                                        <td></td>

                                        <td colspan="2" class="cell-text-left">Dry weight of Pot # 2 (grams)
                                        </td>
                                        <td>
                                            <asp:Literal ID="DryWeightOfPot2Value" runat="server" Text=""></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="DryWeightOfPot2Units" runat="server" Text="g"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="DryWeightOfPot2Label" runat="server" Text="P2"></asp:Literal>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Fuel dimensions</td>
                                        <td colspan="2">
                                            <asp:Literal ID="FuelFimensionsValue" runat="server" Text="≤ 2 cm Ø"></asp:Literal>
                                        </td>
                                        <td></td>

                                        <td colspan="2" class="cell-text-left">Dry weight of Pot # 3 (grams)
                                        </td>
                                        <td>
                                            <asp:Literal ID="DryWeightOfPot3Value" runat="server" Text=""></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="DryWeightOfPot3Units" runat="server" Text="g"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="DryWeightOfPot3Label" runat="server" Text="P3"></asp:Literal>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Fuel moisture content (wet basis) </td>
                                        <td>
                                            <asp:Literal ID="FuelMoistureContentValue" runat="server" Text="12%"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="FuelMoistureContentUnits" runat="server" Text="%"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="FuelMoistureContentLabel" runat="server" Text="MC"></asp:Literal>
                                        </td>

                                        <td colspan="2">Dry weight of Pot # 4 (grams)
                                        </td>
                                        <td>
                                            <asp:Literal ID="DryWeightOfPot4Value" runat="server" Text=""></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="DryWeightOfPot4Units" runat="server" Text="g"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="DryWeightOfPot4Label" runat="server" Text="P4"></asp:Literal>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Gross calorific value (dry fuel)</td>
                                        <td>
                                            <asp:Literal ID="GrossCalorificValueValue" runat="server" Text="20,817"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="GrossCalorificValueUnits" runat="server" Text="kJ/jg"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="GrossCalorificValueLabel" runat="server" Text="HHV"></asp:Literal>
                                        </td>

                                        <td colspan="2">Weight of STOVE
                                        </td>
                                        <td>
                                            <asp:Literal ID="WeightOfStoveValue" runat="server" Text="2681"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="WeightOfStoveUnits" runat="server" Text="g"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="WeightOfStoveLabel" runat="server" Text="k"></asp:Literal>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Net calorific value (dry fuel)</td>
                                        <td>
                                            <asp:Literal ID="NetCaloricValueValue" runat="server" Text="19,497"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="NetCaloricValueUnits" runat="server" Text="kJ/jg"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="NetCaloricValueLabel" runat="server" Text="LHV"></asp:Literal>
                                        </td>

                                        <td colspan="2">Local boiling point
                                        </td>
                                        <td>
                                            <asp:Literal ID="LocalBoilingPointValue" runat="server" Text="99.8"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="LocalBoilingPointUnits" runat="server" Text="ºC"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="LocalBoilingPointLabel" runat="server" Text="T<sub>b</sub>"></asp:Literal>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Effective calorific value</td>
                                        <td colspan="3"></td>

                                        <td class="cell-text-left">Background concentrations
                                        </td>
                                        <td>CO2
                                        </td>
                                        <td>
                                            <asp:Literal ID="BackgroundConcentrationsCo2Value" runat="server" Text="0.5"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="BackgroundConcentrationsCo2Units" runat="server" Text="ppm"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="BackgroundConcentrationsCo2Label" runat="server" Text="CO2,b"></asp:Literal>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>&nbsp;&nbsp;&nbsp;(accounting for fuel moisture)</td>
                                        <td>
                                            <asp:Literal ID="EfectiveCaloricValueValue" runat="server" Text="19,497"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="EfectiveCaloricValueUnits" runat="server" Text="kJ/jg"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="EfectiveCaloricValueLabel" runat="server" Text="EHV"></asp:Literal>
                                        </td>

                                        <td></td>
                                        <td>CO
                                        </td>
                                        <td>
                                            <asp:Literal ID="BackgroundConcentrationsCoValue" runat="server" Text="0.6"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="BackgroundConcentrationsCoUnits" runat="server" Text="ppm"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="BackgroundConcentrationsCoLabel" runat="server" Text="CO,b"></asp:Literal>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Char caloric value</td>
                                        <td>
                                            <asp:Literal ID="CharCaloricValueValue" runat="server" Text="29,500"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="CharCaloricValueUnits" runat="server" Text="kJ/jg"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="CharCaloricValueLabel" runat="server" Text=""></asp:Literal>
                                        </td>

                                        <td></td>
                                        <td>PM
                                        </td>
                                        <td>
                                            <asp:Literal ID="BackgroundConcentrationsPmValue" runat="server" Text="0.7"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="BackgroundConcentrationsPmUnits" runat="server" Text="ug/m3"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:Literal ID="BackgroundConcentrationsPmLabel" runat="server" Text="PM,b"></asp:Literal>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </div>

                <div class="row">
                    <div class="col-lg-8">
                        <h4 class="m-t-none m-b">Notes about this test:
                        </h4>

                        <asp:Literal ID="NoteAboutThisTest" runat="server"></asp:Literal>
                    </div>
                    <div class="col-lg-4">
                        <asp:Image ID="PotImage" runat="server" AlternateText="" ImageUrl="~/Images/logo.png" />
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <h4 class="m-t-none m-b-none">Notes on the High Power - Cold Start Test.
                        </h4>
                        <em class="em m-b">Add description only if it differs from "General Information" sheet</em>

                        <asp:Literal ID="NotesOnTheHighPowerColdStartTest" runat="server"></asp:Literal>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <h4 class="m-t-none m-b">Notes on the High Power - Hot Start Test
                        </h4>

                        <asp:Literal ID="NotesOnTheHighPoweHotStartTest" runat="server"></asp:Literal>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <h4 class="m-t-none m-b">Notes on the Low Power - Simmer Test
                        </h4>

                        <asp:Literal ID="NotesOnTheHighPoweSimmerTest" runat="server"></asp:Literal>
                    </div>
                </div>
            </div>
        </div>

    </div>

</div>

<div class="row">
    <div class="col-lg-12">
        <div class="ibox float-e-margins border-bottom  border-right">
            <div class="ibox-title">
                <h5>Test Data
                </h5>
                <div class="ibox-tools">
                    <a class="collapse-link">
                        <i class="fa fa-chevron-down"></i>
                    </a>
                </div>
            </div>
            <div class="ibox-content" style="display: none;">
                <div class="table-responsive">
                    <table class="table table-bordered table-test-calculations">
                        <thead>
                            <tr>
                                <th colspan="2">Test #
                                    <asp:Literal ID="TestNumber2Literal" runat="server" Text="1"></asp:Literal>
                                </th>
                                <th colspan="4">Cold Start
                                </th>
                                <th colspan="4">Hot Start High Power (Optional)
                                </th>
                                <th colspan="4">Simmer Test
                                </th>
                            </tr>
                            <tr>
                                <th rowspan="2">Measurements
                                </th>
                                <th rowspan="2">Units
                                </th>
                                <th colspan="2">Start
                                </th>
                                <th colspan="2">Finish: when Port#1 boils
                                </th>
                                <th colspan="2">Start
                                </th>
                                <th colspan="2">Finish: when Port#1 boils
                                </th>
                                <th colspan="2">Start
                                </th>
                                <th colspan="2">Finish: when Port#1 boils
                                </th>
                            </tr>
                            <tr>
                                <th>Data</th>
                                <th>Label</th>
                                <th>Data</th>
                                <th>Label</th>
                                <th>Data</th>
                                <th>Label</th>
                                <th>Data</th>
                                <th>Label</th>
                                <th>Data</th>
                                <th>Label</th>
                                <th>Data</th>
                                <th>Label</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Time (in 24 hour form)</td>
                                <td>hr:min</td>
                                <td>
                                    <asp:Literal ID="TimeColdStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TimeColdStartLabel" runat="server" Text="t<sub>ci</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TimeColdFinishData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TimeColdFinishLabel" runat="server" Text="t<sub>cf</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TimeHotStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TimeHotStartLabel" runat="server" Text="t<sub>hi</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TimeHotFinishData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TimeHotFinishLabel" runat="server" Text="t<sub>hf</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TimeSimmerStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TimeSimmerStartLabel" runat="server" Text="t<sub>si</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TimeSimmerFinishData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TimeSimmerFinishLabel" runat="server" Text="t<sub>sf</sub>"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td>Weight of fuel</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="WeighOfFuelColdStartData" runat="server" Text="1887"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeighOfFuelColdStartLabel" runat="server" Text="f<sub>ci</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeighOfFuelColdFinishData" runat="server" Text="1607"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeighOfFuelColdFinishLabel" runat="server" Text="t<sub>cf</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeighOfFuelHotStartData" runat="server" Text="1607"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeighOfFuelHotStartLabel" runat="server" Text="f<sub>hi</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeighOfFuelHotFinishData" runat="server" Text="1334"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeighOfFuelHotFinishLabel" runat="server" Text="f<sub>hf</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeighOfFuelSimmerStartData" runat="server" Text="1334"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeighOfFuelSimmerStartLabel" runat="server" Text="f<sub>si</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeighOfFuelSimmerFinishData" runat="server" Text="1169"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeighOfFuelSimmerFinishLabel" runat="server" Text="f<sub>sf</sub>"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td>Water temperature, Pot # 1</td>
                                <td>ºC</td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot1ColdStartData" runat="server" Text="27.9"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot1ColdStartLabel" runat="server" Text="T1<sub>ci</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot1ColdFinishData" runat="server" Text="1607"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot1ColdFinishLabel" runat="server" Text="T1<sub>cf</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot1HotStartData" runat="server" Text="1607"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot1HotStartLabel" runat="server" Text="T1<sub>hi</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot1HotFinishData" runat="server" Text="1334"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot1HotFinishLabel" runat="server" Text="T1<sub>hf</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot1SimmerStartData" runat="server" Text="1334"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot1SimmerStartLabel" runat="server" Text="T1<sub>si</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot1SimmerFinishData" runat="server" Text="1169"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot1SimmerFinishLabel" runat="server" Text="T1<sub>sf</sub>"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td>Water temperature, Pot # 2</td>
                                <td>ºC</td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot2ColdStartData" runat="server" Text="1887"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot2ColdStartLabel" runat="server" Text="T2<sub>ci</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot2ColdFinishData" runat="server" Text="1607"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot2ColdFinishLabel" runat="server" Text="T2<sub>cf</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot2HotStartData" runat="server" Text="1607"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot2HotStartLabel" runat="server" Text="T2<sub>hi</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot2HotFinishData" runat="server" Text="1334"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot2HotFinishLabel" runat="server" Text="T2<sub>hf</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot2SimmerStartData" runat="server" Text="1334"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot2SimmerStartLabel" runat="server" Text="T2<sub>si</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot2SimmerFinishData" runat="server" Text="1169"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot2SimmerFinishLabel" runat="server" Text="T2<sub>sf</sub>"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td>Water temperature, Pot # 3</td>
                                <td>ºC</td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot3ColdStartData" runat="server" Text="1887"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot3ColdStartLabel" runat="server" Text="T3<sub>ci</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot3ColdFinishData" runat="server" Text="1607"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot3ColdFinishLabel" runat="server" Text="T3<sub>cf</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot3HotStartData" runat="server" Text="1607"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot3HotStartLabel" runat="server" Text="T3<sub>hi</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot3HotFinishData" runat="server" Text="1334"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot3HotFinishLabel" runat="server" Text="T3<sub>hf</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot3SimmerStartData" runat="server" Text="1334"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot3SimmerStartLabel" runat="server" Text="T3<sub>si</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot3SimmerFinishData" runat="server" Text="1169"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot3SimmerFinishLabel" runat="server" Text="T3<sub>sf</sub>"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td>Water temperature, Pot # 4</td>
                                <td>ºC</td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot4ColdStartData" runat="server" Text="1887"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot4ColdStartLabel" runat="server" Text="T4<sub>ci</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot4ColdFinishData" runat="server" Text="1607"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot4ColdFinishLabel" runat="server" Text="T4<sub>cf</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot4HotStartData" runat="server" Text="1607"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot4HotStartLabel" runat="server" Text="T4<sub>hi</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot4HotFinishData" runat="server" Text="1334"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot4HotFinishLabel" runat="server" Text="T4<sub>hf</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot4SimmerStartData" runat="server" Text="1334"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot4SimmerStartLabel" runat="server" Text="T4<sub>si</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot4SimmerFinishData" runat="server" Text="1169"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WaterTemperaturePot4SimmerFinishLabel" runat="server" Text="T4<sub>sf</sub>"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td>Weight of Pot # 1 with water</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="WeightOfPot1ColdStartData" runat="server" Text="1887"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot1ColdStartLabel" runat="server" Text="P1<sub>ci</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot1ColdFinishData" runat="server" Text="1607"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot1ColdFinishLabel" runat="server" Text="P1<sub>cf</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot1HotStartData" runat="server" Text="1607"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot1HotStartLabel" runat="server" Text="P1<sub>hi</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot1HotFinishData" runat="server" Text="1334"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot1HotFinishLabel" runat="server" Text="P1<sub>hf</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot1SimmerStartData" runat="server" Text="1334"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot1SimmerStartLabel" runat="server" Text="P1<sub>si</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot1SimmerFinishData" runat="server" Text="1169"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot1SimmerFinishLabel" runat="server" Text="P1<sub>sf</sub>"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td>Weight of Pot # 2 with water</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="WeightOfPot2ColdStartData" runat="server" Text="1887"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot2ColdStartLabel" runat="server" Text="P2<sub>ci</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot2ColdFinishData" runat="server" Text="1607"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot2ColdFinishLabel" runat="server" Text="P2<sub>cf</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot2HotStartData" runat="server" Text="1607"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot2HotStartLabel" runat="server" Text="P2<sub>hi</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot2HotFinishData" runat="server" Text="1334"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot2HotFinishLabel" runat="server" Text="P2<sub>hf</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot2SimmerStartData" runat="server" Text="1334"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot2SimmerStartLabel" runat="server" Text="P2<sub>si</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot2SimmerFinishData" runat="server" Text="1169"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot2SimmerFinishLabel" runat="server" Text="P2<sub>sf</sub>"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td>Weight of Pot # 3 with water</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="WeightOfPot3ColdStartData" runat="server" Text="1887"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot3ColdStartLabel" runat="server" Text="P3<sub>cl</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot3ColdFinishData" runat="server" Text="1607"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot3ColdFinishLabel" runat="server" Text="P3<sub>cf</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot3HotStartData" runat="server" Text="1607"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot3HotStartLabel" runat="server" Text="P3<sub>nl</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot3HotFinishData" runat="server" Text="1334"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot3HotFinishLabel" runat="server" Text="P3<sub>cf</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot3SimmerStartData" runat="server" Text="1334"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot3SimmerStartLabel" runat="server" Text="P3<sub>si</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot3SimmerFinishData" runat="server" Text="1169"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot3SimmerFinishLabel" runat="server" Text="P3<sub>sf</sub>"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td>Weight of Pot # 4 with water</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="WeightOfPot4ColdStartData" runat="server" Text="1887"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot4ColdStartLabel" runat="server" Text="P4<sub>ci</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot4ColdFinishData" runat="server" Text="1607"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot4ColdFinishLabel" runat="server" Text="P4<sub>cf</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot4HotStartData" runat="server" Text="1607"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot4HotStartLabel" runat="server" Text="P4<sub>hi</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot4HotFinishData" runat="server" Text="1334"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot4HotFinishLabel" runat="server" Text="P4<sub>hf</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot4SimmerStartData" runat="server" Text="1334"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot4SimmerStartLabel" runat="server" Text="P4<sub>si</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot4SimmerFinishData" runat="server" Text="1169"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfPot4SimmerFinishLabel" runat="server" Text="P4<sub>sf</sub>"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td>Fire-starting materials (if any)</td>
                                <td>--</td>
                                <td colspan="2">
                                    <asp:Literal ID="FireStartingMaterialsColdStartData" runat="server" Text="9 gr diary paper"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="FireStartingMaterialsColdFinishData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="FireStartingMaterialsColdFinishLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="FireStartingMaterialsHotStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="FireStartingMaterialsHotStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="FireStartingMaterialsHotFinishData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="FireStartingMaterialsHotFinishLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="FireStartingMaterialsSimmerStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="FireStartingMaterialsSimmerStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="FireStartingMaterialsSimmerFinishData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="FireStartingMaterialsSimmerFinishLabel" runat="server" Text=""></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td>Weight of charcoal+stove</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="WeightOfCharcoalStoveColdStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfCharcoalStoveColdStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfCharcoalStoveColdFinishData" runat="server" Text="2709"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfCharcoalStoveColdFinishLabel" runat="server" Text="C<sub>c</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfCharcoalStoveHotStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfCharcoalStoveHotStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfCharcoalStoveHotFinishData" runat="server" Text="2737"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfCharcoalStoveHotFinishLabel" runat="server" Text="C<sub>h</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfCharcoalStoveSimmerStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfCharcoalStoveSimmerStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfCharcoalStoveSimmerFinishData" runat="server" Text="2730"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="WeightOfCharcoalStoveSimmerFinishLabel" runat="server" Text="C<sub>s</sub>"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td>Average CO2</td>
                                <td>ppm</td>
                                <td>
                                    <asp:Literal ID="AverageCo2ColdStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCo2ColdStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCo2ColdFinishData" runat="server" Text="10.0"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCo2ColdFinishLabel" runat="server" Text="CO2<sub>c</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCo2HotStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCo2HotStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCo2HotFinishData" runat="server" Text="4.0"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCo2HotFinishLabel" runat="server" Text="CO2<sub>h</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCo2SimmerStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCo2SimmerStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCo2SimmerFinishData" runat="server" Text="14.0"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCo2SimmerFinishLabel" runat="server" Text="CO2<sub>s</sub>"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td>Average CO</td>
                                <td>ppm</td>
                                <td>
                                    <asp:Literal ID="AverageCoColdStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCoColdStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCoColdFinishData" runat="server" Text="11.0"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCoColdFinishLabel" runat="server" Text="CO<sub>c</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCoHotStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCoHotStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCoHotFinishData" runat="server" Text="5.0"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCoHotFinishLabel" runat="server" Text="CO<sub>h</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCoSimmerStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCoSimmerStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCoSimmerFinishData" runat="server" Text="16"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageCoSimmerFinishLabel" runat="server" Text="CO<sub>s</sub>"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td>Average PM</td>
                                <td>ug/m3</td>
                                <td>
                                    <asp:Literal ID="AveragePMColdStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AveragePMColdStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AveragePMColdFinishData" runat="server" Text="12.0"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AveragePMColdFinishLabel" runat="server" Text="PM<sub>c</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AveragePMHotStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AveragePMHotStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AveragePMHotFinishData" runat="server" Text="6.0"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AveragePMHotFinishLabel" runat="server" Text="PM<sub>h</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AveragePMSimmerStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AveragePMSimmerStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AveragePMSimmerFinishData" runat="server" Text="16.0"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AveragePMSimmerFinishLabel" runat="server" Text="PM<sub>s</sub>"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td>Average Duct Temperature</td>
                                <td>ºC</td>
                                <td>
                                    <asp:Literal ID="AverageDuctTemperatureColdStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageDuctTemperatureColdStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageDuctTemperatureColdFinishData" runat="server" Text="13.0"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageDuctTemperatureColdFinishLabel" runat="server" Text="T<sub>cd</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageDuctTemperatureHotStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageDuctTemperatureHotStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageDuctTemperatureHotFinishData" runat="server" Text="7.0"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageDuctTemperatureHotFinishLabel" runat="server" Text="T<sub>hd</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageDuctTemperatureSimmerStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageDuctTemperatureSimmerStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageDuctTemperatureSimmerFinishData" runat="server" Text="17.0"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="AverageDuctTemperatureSimmerFinishLabel" runat="server" Text="T<sub>sd</sub>"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td>Total CO2 (if available)</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="TotalCo2ColdStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCo2ColdStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCo2ColdFinishData" runat="server" Text="14.0"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCo2ColdFinishLabel" runat="server" Text="m<sub>CO2,c</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCo2HotStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCo2HotStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCo2HotFinishData" runat="server" Text="8.0"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCo2HotFinishLabel" runat="server" Text="m<sub>CO2,h</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCo2SimmerStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCo2SimmerStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCo2SimmerFinishData" runat="server" Text="18.0"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCo2SimmerFinishLabel" runat="server" Text="m<sub>CO2,s</sub>"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td>Total CO (if available)</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="TotalCoColdStartData" runat="server" Text=" 2,481.0000"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCoColdStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCoColdFinishData" runat="server" Text="15.0"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCoColdFinishLabel" runat="server" Text="m<sub>CO,c</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCoHotStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCoHotStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCoHotFinishData" runat="server" Text="1334"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCoHotFinishLabel" runat="server" Text="m<sub>CO,h</sub>"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCoSimmerStartData" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCoSimmerStartLabel" runat="server" Text=""></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCoSimmerFinishData" runat="server" Text="1169"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalCoSimmerFinishLabel" runat="server" Text="m<sub>CO,</sub>"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td>Total PM (if available)</td>
                                <td>g</td>
                                <td></td>
                                <td></td>
                                <td>
                                    <asp:Literal ID="TotalPmColdFinishData" runat="server" Text="16.000"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalPmColdFinishLabel" runat="server" Text="m<sub>PM,c</sub>"></asp:Literal>
                                </td>
                                <td></td>
                                <td></td>
                                <td>
                                    <asp:Literal ID="TotalPmHotFinishData" runat="server" Text="1334"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalPmHotFinishLabel" runat="server" Text="m<sub>PM,h</sub>"></asp:Literal>
                                </td>
                                <td></td>
                                <td></td>
                                <td>
                                    <asp:Literal ID="TotalPmSimmerFinishData" runat="server" Text="1169"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="TotalPmSimmerFinishLabel" runat="server" Text="m<sub>PM,s</sub>"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="14" style="border-left-width: 0px;border-right-width: 0px;"></td>
                            </tr>
                            <tr>
                                <th rowspan="2">Calculations/Results</th>
                                <th rowspan="2">Units</th>
                                <th colspan="2">Cold Start</th>
                                <th colspan="2">Hot Start</th>
                                <th colspan="8">Simmer Test (Calculations Differ From High Power Test)</th>
                            </tr>
                            <tr>
                                <th>Data</th>
                                <th>Label</th>
                                <th>Data</th>
                                <th>Label</th>
                                <th colspan="5">Calculations/Results</th>
                                <th>Units</th>
                                <th>Data</th>
                                <th>Label</th>
                            </tr>
                            <tr>
                                <td>Fuel consumed (moist)</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="FuelConsumedColdStartData" runat="server" Text="280"></asp:Literal>
                                </td>
                                <td>f<sub>cm</sub></td>
                                <td>
                                    <asp:Literal ID="FuelConsumedHotStartData" runat="server" Text="273"></asp:Literal>
                                </td>
                                <td>f<sub>hm</sub></td>
                                <td colspan="5">Net change in char during test phase</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="FuelConsumedSimmerData" runat="server" Text="165.000"></asp:Literal>
                                </td>
                                <td>f<sub>hm</sub></td>
                            </tr>
                            <tr>
                                <td>Net change in char during test </td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="NetChangeInCarColdStartData" runat="server" Text="28"></asp:Literal>
                                </td>
                                <td>Δc<sub>c</sub></td>
                                <td>
                                    <asp:Literal ID="NetChangeInCarHotStartData" runat="server" Text="56"></asp:Literal>
                                </td>
                                <td>Δc<sub>h</sub></td>
                                <td colspan="5">Net change in char during test phase</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="NetChangeInCarSimmerData" runat="server" Text="21.000"></asp:Literal>
                                </td>
                                <td>Δc<sub>s</sub></td>
                            </tr>
                            <tr>
                                <td>Equivalent dry fuel consumed</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="EquivalentDryFuelConsumedColdStartData" runat="server" Text="199.6262447"></asp:Literal>
                                </td>
                                <td>f<sub>cd</sub></td>
                                <td>
                                    <asp:Literal ID="EquivalentDryFuelConsumedHotStartData" runat="server" Text="141.211"></asp:Literal>
                                </td>
                                <td>f<sub>hd</sub></td>
                                <td colspan="5">Equivalent dry fuel consumed</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="EquivalentDryFuelConsumedSimmerData" runat="server" Text="110.828"></asp:Literal>
                                </td>
                                <td>f<sub>sd</sub></td>
                            </tr>
                            <tr>
                                <td>Water vaporized from all pots</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="WaterVaporizedColdStartData" runat="server" Text="199.6262447"></asp:Literal>
                                </td>
                                <td>w<sub>cv</sub></td>
                                <td>
                                    <asp:Literal ID="WaterVaporizedHotStartData" runat="server" Text="141.211"></asp:Literal>
                                </td>
                                <td>w<sub>hv</sub></td>
                                <td colspan="5">Water vaporized</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="WaterVaporizedSimmerData" runat="server" Text="110.828"></asp:Literal>
                                </td>
                                <td>w<sub>sv</sub></td>
                            </tr>
                            <tr>
                                <td>Effective mass of water boiled</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="EffectoveMassOfWaterBoiledColdStartData" runat="server" Text="2,481"></asp:Literal>
                                </td>
                                <td>w<sub>cr</sub></td>
                                <td>
                                    <asp:Literal ID="EffectoveMassOfWaterBoiledHotStartData" runat="server" Text="2,476"></asp:Literal>
                                </td>
                                <td>w<sub>hr</sub></td>
                                <td colspan="5">Water vaporized</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="EffectoveMassOfWaterBoiledSimmerData" runat="server" Text="110.828"></asp:Literal>
                                </td>
                                <td>w<sub>sr</sub></td>
                            </tr>
                            <tr>
                                <td>Time to boil Pot # 1</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="TimeToBoilPot1ColdStartData" runat="server" Text="17"></asp:Literal>
                                </td>
                                <td>Δt<sub>c</sub></td>
                                <td>
                                    <asp:Literal ID="TimeToBoilPot1ColdHotStartData" runat="server" Text="18"></asp:Literal>
                                </td>
                                <td>Δt<sub>h</sub></td>
                                <td colspan="5">Time of simmer (should be ~45 minutes)</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="TimeToBoilPot1ColdSimmerData" runat="server" Text="450.000"></asp:Literal>
                                </td>
                                <td>Δt<sub>s</sub></td>
                            </tr>
                            <tr>
                                <td>Temp-corr time to boil Pot # 1</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="TempCorrTimeToBoilPot1ColdStartData" runat="server" Text="17.73"></asp:Literal>
                                </td>
                                <td>Δt<sup>T</sup><sub>c</sub></td>
                                <td>
                                    <asp:Literal ID="TempCorrTimeToBoilPot1HotStartData" runat="server" Text="18.60"></asp:Literal>
                                </td>
                                <td>Δt<sup>T</sup><sub>h</sub></td>
                                <td colspan="5">Thermal efficiency</td>
                                <td>%</td>
                                <td>
                                    <asp:Literal ID="TempCorrTimeToBoilPot1SimmerData" runat="server" Text="0.057"></asp:Literal>
                                </td>
                                <td>h<sub>s</sub></td>
                            </tr>
                            <tr>
                                <td>Thermal efficiency</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="ThermalEfficiencyColdStartData" runat="server" Text="20.50%"></asp:Literal>
                                </td>
                                <td>h<sub>c</sub></td>
                                <td>
                                    <asp:Literal ID="ThermalEfficiencyHotStartData" runat="server" Text="0.276104"></asp:Literal>
                                </td>
                                <td>h<sub>h</sub></td>
                                <td colspan="5">Burning rate</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="ThermalEfficiencySimmerData" runat="server" Text="2.463"></asp:Literal>
                                </td>
                                <td>r<sub>sb</sub></td>
                            </tr>
                            <tr>
                                <td>Burning rate</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="BurningRateColdStartData" runat="server" Text="20.50%"></asp:Literal>
                                </td>
                                <td>r<sub>cb</sub></td>
                                <td>
                                    <asp:Literal ID="BurningRateHotStartData" runat="server" Text="0.276104"></asp:Literal>
                                </td>
                                <td>r<sub>hb</sub></td>
                                <td colspan="5">Specific fuel consumption </td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="BurningRateSimmerData" runat="server" Text="2.463"></asp:Literal>
                                </td>
                                <td>SC<sub>s</sub></td>
                            </tr>
                            <tr>
                                <td>Specific fuel consumption</td>
                                <td>g/liter boiled</td>
                                <td>
                                    <asp:Literal ID="SpecificFuelConsumptionColdStartData" runat="server" Text=" 80.4620"></asp:Literal>
                                </td>
                                <td>SC<sub>c</sub></td>
                                <td>
                                    <asp:Literal ID="SpecificFuelConsumptionHotStartData" runat="server" Text="61.07066203"></asp:Literal>
                                </td>
                                <td>SC<sub>h</sub></td>
                                <td colspan="5">Firepower</td>
                                <td>watts</td>
                                <td>
                                    <asp:Literal ID="SpecificFuelConsumptionSimmerData" runat="server" Text="800.302"></asp:Literal>
                                </td>
                                <td>FP<sub>s</sub></td>
                            </tr>
                            <tr>
                                <td>Temp-corr sp consumption </td>
                                <td>g/liter</td>
                                <td>
                                    <asp:Literal ID="TempCorrSpConsumptionColdStartData" runat="server" Text="83.93116394"></asp:Literal>
                                </td>
                                <td>SC<sup>T</sup><sub>c</sub></td>
                                <td>
                                    <asp:Literal ID="TempCorrSpConsumptionHotStartData" runat="server" Text="63.08952689"></asp:Literal>
                                </td>
                                <td>SC<sup>T</sup><sub>h</sub></td>
                                <td colspan="5">Turn down ratio</td>
                                <td>--</td>
                                <td>
                                    <asp:Literal ID="TempCorrSpConsumptionSimmerData" runat="server" Text="4.768"></asp:Literal>
                                </td>
                                <td>TDR</td>
                            </tr>
                            <tr>
                                <td>Temp-corr sp energy consumpt.</td>
                                <td>kJ/liter</td>
                                <td>
                                    <asp:Literal ID="TempCorrSpEnergyConsumptionColdStartData" runat="server" Text="1,636.41"></asp:Literal>
                                </td>
                                <td>SE<sup>T</sup><sub>C</sub></td>
                                <td>
                                    <asp:Literal ID="TempCorrSpEnergyConsumptionHotStartData" runat="server" Text="1,230"></asp:Literal>
                                </td>
                                <td>SE<sup>T</sup><sub>H</sub></td>
                                <td colspan="5">Specific Energy Consumption</td>
                                <td>kJ/liter</td>
                                <td>
                                    <asp:Literal ID="TempCorrSpEnergyConsumptionSimmerData" runat="server" Text="892.162"></asp:Literal>
                                </td>
                                <td>SE<sub>s</sub></td>
                            </tr>
                            <tr>
                                <td>Firepower</td>
                                <td>watts</td>
                                <td>
                                    <asp:Literal ID="FirepowerColdStartData" runat="server" Text="3815.80"></asp:Literal>
                                </td>
                                <td>FP<sub>c</sub></td>
                                <td>
                                    <asp:Literal ID="FirepowerHotStartData" runat="server" Text="2730"></asp:Literal>
                                </td>
                                <td>FP<sub>h</sub></td>
                                <td colspan="5">Fuel Benchmark to Complete 5L WBT</td>
                                <td>g</td>
                                <td>
                                    <asp:Literal ID="FirepowerSimmerData" runat="server" Text="892.162"></asp:Literal>
                                </td>
                                <td>BF</td>
                            </tr>
                            <tr>
                                <td colspan="6"></td>
                                <td colspan="5">Energy Benchmark to Complete 5L WBT</td>
                                <td>kJ</td>
                                <td>
                                    <asp:Literal ID="EnergyBenchmarkToCompleteSimmerData" runat="server" Text="11,626.97"></asp:Literal>
                                </td>
                                <td>BF</td>
                            </tr>
                        </tbody>

                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
