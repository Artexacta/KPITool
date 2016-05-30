<%@ Page Title="KPI" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="KpiForm.aspx.cs" Inherits="Kpi_KpiForm" %>

<%@ Register src="../UserControls/FRTWB/AddDataControl.ascx" tagname="AddDataControl" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">

    <div class="container">
        <div class="tile">
            <div class="t-header">
                <div class="th-title">Create Kpi</div>
            </div>

            <div class="t-body tb-padding">

                <div class="row">
                    <div class="col-sm-6">
                        <label>Kpi Name <span class="label label-danger">Required</span></label>
                        <asp:TextBox ID="KpiNameTextBox" runat="server" CssClass="form-control" placeholder="Enter the Kpi name"></asp:TextBox>
                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="KpiNameTextBox"
                                Display="Dynamic"
                                ValidationGroup="AddKpi"
                                ErrorMessage="You must enter the Kpi Name">
                            </asp:RequiredFieldValidator>
                            
                        </div>

                       <uc1:AddDataControl ID="SelectAddDataControl" runat="server" />

                        <label>KPI Type <span class="label label-danger">Required</span></label>
                        <asp:DropDownList ID="KPITypeCombobox" runat="server" CssClass="form-control m-b-10"
                            DataValueField="KpiTypeID"
                            DataTextField="TypeName" DataSourceID="KPITypeObjectDataSource"
                            OnSelectedIndexChanged="KPITypeCombobox_SelectedIndexChanged" >
                        </asp:DropDownList>
                        <asp:ObjectDataSource ID="KPITypeObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetKPITypes" TypeName="Artexacta.App.KPI.BLL.KPITypeBLL">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="LanguageHiddenField" DefaultValue="ES" Name="language" PropertyName="Value" Type="String" />
                            </SelectParameters>
                        </asp:ObjectDataSource>

                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="KPITypeCombobox"
                                Display="Dynamic"
                                ValidationGroup="AddKpi"
                                ErrorMessage="You must select a Kpi Type">
                            </asp:RequiredFieldValidator>
                        </div>
                        <div class="m-b-10">
                            <label class="checkbox checkbox-inline cr-alt">
                                <asp:CheckBox runat="server" ID="ReportingServicesCheckbox" />
                                <i class="input-helper"></i>
                                Allow Reporting Values unsing Web Services
                            </label>
                        </div>
                        <div id="webServicePanel" class="m-b-10  hidden">
                            <div class="m-b-10">
                                To register the "Time between failures" usign the Web Services you enter them in ISO 8601 format: P[ n ]Y[ n ]M[ n ]DT[ n ]H[ n ]M[ n ]S.  In this representation, the [ n ] is replaced by the value for each of the date and time elements that follow the [ n ]. For example, "P3Y6M4DT12H30M5S" represents a duration of "three years, six months, four days, twelve hours, thirty minutes, and five seconds".
                            </div>
                            <div>
                                <label>Web Service ID <span class="label label-danger">Required</span></label>
                                <asp:TextBox ID="WebServiceIDTextbox" runat="server" CssClass="form-control" placeholder="Enter the Kpi name"></asp:TextBox>
                                <div class="has-error m-b-10">
                                    <asp:CustomValidator runat="server" Display="Dynamic" ValidationGroup="AddKpi" ErrorMessage="You must specify a web service Id" ClientValidationFunction="validateWebService"></asp:CustomValidator>
                                </div>
                            </div>
                        </div>
                        <label>Unit <span class="label label-danger">Required</span></label>
                        <asp:DropDownList ID="UnitCombobox" runat="server" CssClass="form-control m-b-10" Enabled="false">
                            <asp:ListItem Text="Percentage" Value="PERCENTAGE"></asp:ListItem>
                            <asp:ListItem Text="Time Span" Value="TIMESPAN"></asp:ListItem>
                            <asp:ListItem Text="Money" Value="MONEY"></asp:ListItem>
                            <asp:ListItem Text="Integer" Value="INTEGER"></asp:ListItem>
                            <asp:ListItem Text="Decimal" Value="DECIMAL"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:HiddenField runat="server" ID="SelectedUnitHiddenField" />
                        <label>Direction <span class="label label-danger">Required</span></label>
                        <asp:DropDownList ID="DirectionCombobox" runat="server" CssClass="form-control m-b-10">
                            <asp:ListItem Text="Minimize" Value="MINIMIZE"></asp:ListItem>
                            <asp:ListItem Text="Maximize" Value="MAXIMIZE"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:HiddenField runat="server" ID="SelectedDirectionHiddenField" />
                        <label>Grouping Strategy <span class="label label-danger">Required</span></label>
                        <asp:DropDownList ID="GroupingStrategyCombobox" runat="server" CssClass="form-control m-b-10">
                            <asp:ListItem Text="Average over period" Value="AVERAGE_OVER_PERIOD"></asp:ListItem>
                            <asp:ListItem Text="Sum over period" Value="SUM_OVER_PERIOD"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:HiddenField runat="server" ID="SelectedGroupingStrategyHiddenFields" />
                        <label>Reporting Period <span class="label label-danger">Required</span></label>
                        <asp:DropDownList ID="ReportingPeriodCombobox" runat="server" CssClass="form-control m-b-10">
                            <asp:ListItem Text="Year" Value="YEAR"></asp:ListItem>
                            <asp:ListItem Text="Semester" Value="SEMESTER"></asp:ListItem>
                            <asp:ListItem Text="Quarter" Value="QUARTER"></asp:ListItem>
                            <asp:ListItem Text="Month" Value="MONTH"></asp:ListItem>
                            <asp:ListItem Text="Week" Value="WEEK"></asp:ListItem>
                            <asp:ListItem Text="Day" Value="DAY"></asp:ListItem>
                        </asp:DropDownList>
                        <label>Reporting Units <span class="label label-danger">Required</span></label>
                        <div class="row">
                            <div class="col-md-4">
                                <div>
                                    <telerik:RadNumericTextBox CssClass="form-control m-b-10" MinValue="0" NumberFormat-DecimalDigits="0" runat="server" ID="ReportingUnitsValueTextBox"></telerik:RadNumericTextBox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ReportingUnitsValueTextBox"
                                        Display="Dynamic"
                                        ValidationGroup="AddKpi"
                                        ErrorMessage="You must choose the Reporting Units for the Kpi">
                                    </asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <select id="ReportingUnitsCombobox" class="form-control m-b-10">
                                </select>
                                <asp:HiddenField runat="server" ID="ReportingUnitsHiddenfield" />
                                <asp:CustomValidator runat="server" Display="Dynamic" ValidationGroup="AddKpi" ErrorMessage="You must select a reporting unit measurement" ClientValidationFunction="validateReportingUnits"></asp:CustomValidator>

                            </div>
                        </div>
                        <div id="percentagePanel" class="targetPanels">
                            <label>Percentage <span class="label label-danger">Required</span></label>
                            <div>
                                <telerik:RadNumericTextBox runat="server" ID="TargetPercentageTextbox" MaxValue="100" MinValue="0" CssClass="form-control m-b-10"></telerik:RadNumericTextBox>
                            </div>
                        </div>
                        <div id="timespanPanel" class="targetPanels">
                            <div class="row">
                                <div class="col-md-12">
                                    <label>Kpi Target <span class="label label-danger">Required</span></label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-2">
                                    <asp:DropDownList runat="server" ID="TargetTimespanYearsCombobox" CssClass="form-control m-b-10">
                                        <asp:ListItem Text="0 years" Value="0"></asp:ListItem>
                                        <asp:ListItem Text="1 year" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="2 years" Value="2"></asp:ListItem>
                                        <asp:ListItem Text="3 years" Value="3"></asp:ListItem>
                                        <asp:ListItem Text="4 years" Value="4"></asp:ListItem>
                                        <asp:ListItem Text="5 years" Value="5"></asp:ListItem>
                                        <asp:ListItem Text="6 years" Value="6"></asp:ListItem>
                                        <asp:ListItem Text="7 years" Value="7"></asp:ListItem>
                                        <asp:ListItem Text="8 years" Value="8"></asp:ListItem>
                                        <asp:ListItem Text="9 years" Value="9"></asp:ListItem>
                                        <asp:ListItem Text="10 Years" Value="10"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-2">
                                    <asp:DropDownList runat="server" ID="TargetTimespanMonthsCombobox" CssClass="form-control m-b-10">
                                        <asp:ListItem Text="0 months" Value="0"></asp:ListItem>
                                        <asp:ListItem Text="1 month" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="2 months" Value="2"></asp:ListItem>
                                        <asp:ListItem Text="3 months" Value="3"></asp:ListItem>
                                        <asp:ListItem Text="4 months" Value="4"></asp:ListItem>
                                        <asp:ListItem Text="5 months" Value="5"></asp:ListItem>
                                        <asp:ListItem Text="6 months" Value="6"></asp:ListItem>
                                        <asp:ListItem Text="7 months" Value="7"></asp:ListItem>
                                        <asp:ListItem Text="8 months" Value="8"></asp:ListItem>
                                        <asp:ListItem Text="9 months" Value="9"></asp:ListItem>
                                        <asp:ListItem Text="10 months" Value="10"></asp:ListItem>
                                        <asp:ListItem Text="11 months" Value="11"></asp:ListItem>
                                        <asp:ListItem Text="12 months" Value="12"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-2">
                                    <asp:DropDownList runat="server" ID="TargetTimespanDaysCombobox" CssClass="form-control m-b-10">
                                        <asp:ListItem Text="0 days" Value="0"></asp:ListItem>
                                        <asp:ListItem Text="1 day" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="2 days" Value="2"></asp:ListItem>
                                        <asp:ListItem Text="3 days" Value="3"></asp:ListItem>
                                        <asp:ListItem Text="4 days" Value="4"></asp:ListItem>
                                        <asp:ListItem Text="5 days" Value="5"></asp:ListItem>
                                        <asp:ListItem Text="6 days" Value="6"></asp:ListItem>
                                        <asp:ListItem Text="7 days" Value="7"></asp:ListItem>
                                        <asp:ListItem Text="8 days" Value="8"></asp:ListItem>
                                        <asp:ListItem Text="9 days" Value="9"></asp:ListItem>
                                        <asp:ListItem Text="10 days" Value="10"></asp:ListItem>
                                        <asp:ListItem Text="11 days" Value="11"></asp:ListItem>
                                        <asp:ListItem Text="12 days" Value="12"></asp:ListItem>
                                        <asp:ListItem Text="13 days" Value="13"></asp:ListItem>
                                        <asp:ListItem Text="14 days" Value="14"></asp:ListItem>
                                        <asp:ListItem Text="15 days" Value="15"></asp:ListItem>
                                        <asp:ListItem Text="16 days" Value="16"></asp:ListItem>
                                        <asp:ListItem Text="17 days" Value="17"></asp:ListItem>
                                        <asp:ListItem Text="18 days" Value="18"></asp:ListItem>
                                        <asp:ListItem Text="19 days" Value="19"></asp:ListItem>
                                        <asp:ListItem Text="20 days" Value="20"></asp:ListItem>
                                        <asp:ListItem Text="21 days" Value="21"></asp:ListItem>
                                        <asp:ListItem Text="22 days" Value="22"></asp:ListItem>
                                        <asp:ListItem Text="23 days" Value="23"></asp:ListItem>
                                        <asp:ListItem Text="24 days" Value="24"></asp:ListItem>
                                        <asp:ListItem Text="25 days" Value="25"></asp:ListItem>
                                        <asp:ListItem Text="26 days" Value="26"></asp:ListItem>
                                        <asp:ListItem Text="27 days" Value="27"></asp:ListItem>
                                        <asp:ListItem Text="28 days" Value="28"></asp:ListItem>
                                        <asp:ListItem Text="29 days" Value="29"></asp:ListItem>
                                        <asp:ListItem Text="30 days" Value="30"></asp:ListItem>
                                        <asp:ListItem Text="31 days" Value="31"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-2">
                                    <asp:DropDownList runat="server" ID="TargetTimespanHoursCombobox" CssClass="form-control m-b-10">
                                        <asp:ListItem Text="0 hours" Value="0"></asp:ListItem>
                                        <asp:ListItem Text="1 hour" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="2 hours" Value="2"></asp:ListItem>
                                        <asp:ListItem Text="3 hours" Value="3"></asp:ListItem>
                                        <asp:ListItem Text="4 hours" Value="4"></asp:ListItem>
                                        <asp:ListItem Text="5 hours" Value="5"></asp:ListItem>
                                        <asp:ListItem Text="6 hours" Value="6"></asp:ListItem>
                                        <asp:ListItem Text="7 hours" Value="7"></asp:ListItem>
                                        <asp:ListItem Text="8 hours" Value="8"></asp:ListItem>
                                        <asp:ListItem Text="9 hours" Value="9"></asp:ListItem>
                                        <asp:ListItem Text="10 hours" Value="10"></asp:ListItem>
                                        <asp:ListItem Text="11 hours" Value="11"></asp:ListItem>
                                        <asp:ListItem Text="12 hours" Value="12"></asp:ListItem>
                                        <asp:ListItem Text="13 hours" Value="13"></asp:ListItem>
                                        <asp:ListItem Text="14 hours" Value="14"></asp:ListItem>
                                        <asp:ListItem Text="15 hours" Value="15"></asp:ListItem>
                                        <asp:ListItem Text="16 hours" Value="16"></asp:ListItem>
                                        <asp:ListItem Text="17 hours" Value="17"></asp:ListItem>
                                        <asp:ListItem Text="18 hours" Value="18"></asp:ListItem>
                                        <asp:ListItem Text="19 hours" Value="19"></asp:ListItem>
                                        <asp:ListItem Text="20 hours" Value="20"></asp:ListItem>
                                        <asp:ListItem Text="21 hours" Value="21"></asp:ListItem>
                                        <asp:ListItem Text="22 hours" Value="22"></asp:ListItem>
                                        <asp:ListItem Text="23 hours" Value="23"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-2">
                                    <asp:DropDownList runat="server" ID="TargetTimespanMinutesCombobox" CssClass="form-control m-b-10">
                                        <asp:ListItem Text="0 minutes" Value="0"></asp:ListItem>
                                        <asp:ListItem Text="1 minute" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="2 minutes" Value="2"></asp:ListItem>
                                        <asp:ListItem Text="3 minutes" Value="3"></asp:ListItem>
                                        <asp:ListItem Text="4 minutes" Value="4"></asp:ListItem>
                                        <asp:ListItem Text="5 minutes" Value="5"></asp:ListItem>
                                        <asp:ListItem Text="6 minutes" Value="6"></asp:ListItem>
                                        <asp:ListItem Text="7 minutes" Value="7"></asp:ListItem>
                                        <asp:ListItem Text="8 minutes" Value="8"></asp:ListItem>
                                        <asp:ListItem Text="9 minutes" Value="9"></asp:ListItem>
                                        <asp:ListItem Text="10 minutes" Value="10"></asp:ListItem>
                                        <asp:ListItem Text="11 minutes" Value="11"></asp:ListItem>
                                        <asp:ListItem Text="12 minutes" Value="12"></asp:ListItem>
                                        <asp:ListItem Text="13 minutes" Value="13"></asp:ListItem>
                                        <asp:ListItem Text="14 minutes" Value="14"></asp:ListItem>
                                        <asp:ListItem Text="15 minutes" Value="15"></asp:ListItem>
                                        <asp:ListItem Text="16 minutes" Value="16"></asp:ListItem>
                                        <asp:ListItem Text="17 minutes" Value="17"></asp:ListItem>
                                        <asp:ListItem Text="18 minutes" Value="18"></asp:ListItem>
                                        <asp:ListItem Text="19 minutes" Value="19"></asp:ListItem>
                                        <asp:ListItem Text="20 minutes" Value="20"></asp:ListItem>
                                        <asp:ListItem Text="21 minutes" Value="21"></asp:ListItem>
                                        <asp:ListItem Text="22 minutes" Value="22"></asp:ListItem>
                                        <asp:ListItem Text="23 minutes" Value="23"></asp:ListItem>
                                        <asp:ListItem Text="24 minutes" Value="24"></asp:ListItem>
                                        <asp:ListItem Text="25 minutes" Value="25"></asp:ListItem>
                                        <asp:ListItem Text="26 minutes" Value="26"></asp:ListItem>
                                        <asp:ListItem Text="27 minutes" Value="27"></asp:ListItem>
                                        <asp:ListItem Text="28 minutes" Value="28"></asp:ListItem>
                                        <asp:ListItem Text="29 minutes" Value="29"></asp:ListItem>
                                        <asp:ListItem Text="30 minutes" Value="30"></asp:ListItem>
                                        <asp:ListItem Text="31 minutes" Value="31"></asp:ListItem>
                                        <asp:ListItem Text="32 minutes" Value="32"></asp:ListItem>
                                        <asp:ListItem Text="33 minutes" Value="33"></asp:ListItem>
                                        <asp:ListItem Text="34 minutes" Value="34"></asp:ListItem>
                                        <asp:ListItem Text="35 minutes" Value="35"></asp:ListItem>
                                        <asp:ListItem Text="36 minutes" Value="36"></asp:ListItem>
                                        <asp:ListItem Text="37 minutes" Value="37"></asp:ListItem>
                                        <asp:ListItem Text="38 minutes" Value="38"></asp:ListItem>
                                        <asp:ListItem Text="39 minutes" Value="39"></asp:ListItem>
                                        <asp:ListItem Text="40 minutes" Value="40"></asp:ListItem>
                                        <asp:ListItem Text="41 minutes" Value="41"></asp:ListItem>
                                        <asp:ListItem Text="42 minutes" Value="42"></asp:ListItem>
                                        <asp:ListItem Text="43 minutes" Value="43"></asp:ListItem>
                                        <asp:ListItem Text="44 minutes" Value="44"></asp:ListItem>
                                        <asp:ListItem Text="45 minutes" Value="45"></asp:ListItem>
                                        <asp:ListItem Text="46 minutes" Value="46"></asp:ListItem>
                                        <asp:ListItem Text="47 minutes" Value="47"></asp:ListItem>
                                        <asp:ListItem Text="48 minutes" Value="48"></asp:ListItem>
                                        <asp:ListItem Text="49 minutes" Value="49"></asp:ListItem>
                                        <asp:ListItem Text="50 minutes" Value="50"></asp:ListItem>
                                        <asp:ListItem Text="51 minutes" Value="51"></asp:ListItem>
                                        <asp:ListItem Text="52 minutes" Value="52"></asp:ListItem>
                                        <asp:ListItem Text="53 minutes" Value="53"></asp:ListItem>
                                        <asp:ListItem Text="54 minutes" Value="54"></asp:ListItem>
                                        <asp:ListItem Text="55 minutes" Value="55"></asp:ListItem>
                                        <asp:ListItem Text="56 minutes" Value="56"></asp:ListItem>
                                        <asp:ListItem Text="57 minutes" Value="57"></asp:ListItem>
                                        <asp:ListItem Text="58 minutes" Value="58"></asp:ListItem>
                                        <asp:ListItem Text="59 minutes" Value="59"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div id="moneyPanel" class="targetPanels">
                            <div class="row">
                                <div class="col-md-5">
                                    <label>Currency</label>
                                    <asp:DropDownList runat="server" ID="TargetMoneyCurrencyCombobox" CssClass="form-control m-b-10">
                                        <asp:ListItem Text="US Dollars" Value="US_DOLLARS" />
                                        <asp:ListItem Text="Euros" Value="EUROS" />
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-5">
                                    <label>Measured in</label>
                                    <asp:DropDownList runat="server" ID="TargetMoneyMeasuredInCombobox" CssClass="form-control m-b-10">
                                        <asp:ListItem Text="Billions" Value="BILLIONS" />
                                        <asp:ListItem Text="Crores" Value="CRORES" />
                                        <asp:ListItem Text="Millions" Value="MILLIONS" />
                                        <asp:ListItem Text="Lakhs" Value="LAKHS" />
                                        <asp:ListItem Text="Thousands" Value="THOUSANDS" />
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-2">
                                    <span class="label label-danger">Required</span>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <label>Kpi Target <span class="label label-danger">Required</span></label>
                                </div>
                                <div class="col-md-12">
                                    <telerik:RadNumericTextBox Type="Currency" runat="server" ID="TargetMoneyValueTextbox" CssClass="form-control m-b-10"></telerik:RadNumericTextBox>
                                </div>
                            </div>
                        </div>
                        <div id="integerPanel" class="targetPanels">
                            <label>Kpi Target <span class="label label-danger">Required</span></label>
                            <div>
                                <telerik:RadNumericTextBox runat="server" Type="Number" ID="TargetIntegerTextbox" CssClass="form-control m-b-10" NumberFormat-DecimalDigits="0" MinValue="0"></telerik:RadNumericTextBox>
                            </div>
                        </div>
                        <div id="decimalPanel" class="targetPanels">
                            <label>Kpi Target <span class="label label-danger">Required</span></label>
                            <div>
                                <telerik:RadNumericTextBox Type="Number" runat="server" NumberFormat-DecimalDigits="2" CssClass="form-control m-b-10" ID="TargetDecimalTextbox" MinValue="0"></telerik:RadNumericTextBox>
                            </div>
                        </div>
                        <div id="target-validation" class="has-error">
                            <asp:CustomValidator runat="server" Display="Dynamic" ValidationGroup="AddKpi" ClientValidationFunction="validateTarget"></asp:CustomValidator>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <hr />
                        <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary" Text="Save Kpi"
                            ValidationGroup="AddKpi" OnClick="SaveButton_Click">
                        </asp:LinkButton>
                        <asp:LinkButton ID="CancelButton" runat="server" CssClass="btn btn-danger" Text="Cancel" OnClick="CancelButton_Click"></asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="KpiIdHiddenField" runat="server" Value="0" />
    <asp:HiddenField ID="LanguageHiddenField" runat="server" Value="0" />
    <asp:HiddenField ID="ParentPageHiddenField" runat="server" Value="" />

    <script type="text/javascript">
        var unitCombo;
        var directionCombo;
        var kpiCombo;
        var strategyCombo;
        var reportingPeriodCombo;
        var reportingUnitsCombo;
        var webServiceCheckbox;
        $(document).ready(function () {
            unitCombo = $('#<%=UnitCombobox.ClientID%>');
            directionCombo = $('#<%=DirectionCombobox.ClientID%>');
            kpiCombo = $('#<%=KPITypeCombobox.ClientID%>');
            strategyCombo = $('#<%=GroupingStrategyCombobox.ClientID%>');
            reportingPeriodCombo = $('#<%=ReportingPeriodCombobox.ClientID%>');
            reportingUnitsCombo = $('#ReportingUnitsCombobox');
            webServiceCheckbox = $('#<%=ReportingServicesCheckbox.ClientID%>');

            kpiCombo.on('change', updateFormByKpiType);
            reportingPeriodCombo.on('change', updateReportingUnitCombo);
            reportingUnitsCombo.on('change', function () {
                $('#<%=ReportingUnitsHiddenfield.ClientID%>').val($(this).val());
            });
            updateFormByKpiType();
            updateReportingUnitCombo();

            webServiceCheckbox.on('change', webserviceVisibility);
            webserviceVisibility();
            if ($('#<%=SelectedGroupingStrategyHiddenFields.ClientID%>').val() != "") {
                strategyCombo.val($('#<%=SelectedGroupingStrategyHiddenFields.ClientID%>').val());
            }
            if ($('#<%=SelectedDirectionHiddenField.ClientID%>').val() != "") {
                directionCombo.val($('#<%=SelectedDirectionHiddenField.ClientID%>').val());
            }
            strategyCombo.on('change', function () {
                $('#<%=SelectedGroupingStrategyHiddenFields.ClientID%>').val($(this).val());
            });
            directionCombo.on('change', function () {
                $('#<%=SelectedDirectionHiddenField.ClientID%>').val($(this).val());
            });
        });
        function webserviceVisibility() {
            if (webServiceCheckbox.is(':checked')) {
                $('#webServicePanel').removeClass('hidden');
            } else {
                $('#webServicePanel').addClass('hidden');
            }
        }
        function updateReportingUnitCombo() {
            var optionsInReportingCombo = reportingPeriodCombo.children('option');
            var reportingComboVal = reportingPeriodCombo.val();
            var startAdding = false;
            reportingUnitsCombo.html('');
            for (var i = 0; i < optionsInReportingCombo.length; i++) {
                var option = optionsInReportingCombo.eq(i);
                if (option.val() == reportingComboVal) {
                    startAdding = true;
                }
                if (startAdding) {
                    reportingUnitsCombo.append(option.clone());
                }
            }
            var hiddenVal = $('#<%=ReportingUnitsHiddenfield.ClientID%>').val();
            if (hiddenVal != "" && $('#ReportingUnitsCombobox').find('option[value="' + hiddenVal + '"]').length > 0) {
                reportingUnitsCombo.val(hiddenVal);
            } else {
                $('#<%=ReportingUnitsHiddenfield.ClientID%>').val(reportingUnitsCombo.val());
            }

        }
        function updateFormByKpiType() {
            var type = kpiCombo.val();
            $('.targetPanels').hide();
            if (type == "") {
                $('#' + unitCombo.val().toLowerCase() + 'Panel').show();
                return;
            }
            //FYI: type = id;unit;direction;strategy
            var vals = type.split(';');
            unitCombo.val(vals[1]);
            $('#<%=SelectedUnitHiddenField.ClientID%>').val(vals[1]);
            $('#' + unitCombo.val().toLowerCase() + 'Panel').show();
            if (vals[2] != "USER_DEFINED") {
                directionCombo.val(vals[2]);
                $('#<%=SelectedDirectionHiddenField.ClientID%>').val(vals[2]);
            } 
            if (vals[3] != "USER_DEFINED") {
                strategyCombo.val(vals[3]);
                $('#<%=SelectedGroupingStrategyHiddenFields.ClientID%>').val(vals[3]);
            }
            switch (vals[2]) {
                case "USER_DEFINED":
                    directionCombo.prop('disabled', false);
                    break;
                default:
                    directionCombo.prop('disabled', true);
                    break;
            }
            switch (vals[3]) {
                case "USER_DEFINED":
                    strategyCombo.prop('disabled', false);
                    break;
                default:
                    strategyCombo.prop('disabled', true);
                    break;
            }
        }
        function validateReportingUnits(source, arguments) {
            if ($('#<%=ReportingUnitsHiddenfield.ClientID%>').val() == "") {
                     arguments.IsValid = false;
                 } else {
                     arguments.IsValid = true;
                 }
             }
             function validateTarget(source, arguments) {
                 var selectedUnit = unitCombo.val();
                 switch (selectedUnit) {
                     case "PERCENTAGE":
                         if ($('#<%=TargetPercentageTextbox.ClientID%>').val() != "") {
                    arguments.IsValid = true;
                } else {
                    arguments.IsValid = false;
                    source.innerHTML = "Kpi Target percentage is required";
                }
                break;
            case "TIMESPAN":
                var years = parseInt($('#<%=TargetTimespanYearsCombobox.ClientID%>').val());
                    var months = parseInt($('#<%=TargetTimespanMonthsCombobox.ClientID%>').val());
                    var days = parseInt($('#<%=TargetTimespanDaysCombobox.ClientID%>').val());
                    var hours = parseInt($('#<%=TargetTimespanHoursCombobox.ClientID%>').val());
                    var minutes = parseInt($('#<%=TargetTimespanMinutesCombobox.ClientID%>').val());
                    if (years + months + days + hours + minutes > 0) {
                        arguments.IsValid = true;
                    } else {
                        arguments.IsValid = false;
                        source.innerHTML = "You need to select at least one minute in range";
                    }
                    break;
                case "MONEY":
                    if ($('#<%=TargetMoneyValueTextbox.ClientID%>').val() != "") {
                        arguments.IsValid = true;
                    } else {
                        arguments.IsValid = false;
                        source.innerHTML = "You must specify the money amount";

                    }
                    break;
                case "INTEGER":
                    if ($('#<%=TargetIntegerTextbox.ClientID%>').val() != "") {
                        arguments.IsValid = true;
                    } else {
                        arguments.IsValid = false;
                        source.innerHTML = "You must specify an Integer value";
                    }
                    break;
                case "DECIMAL":
                    if ($('#<%=TargetDecimalTextbox.ClientID%>').val() != "") {
                        arguments.IsValid = true;
                    } else {
                        arguments.IsValid = false;
                        source.innerHTML = "You must specify a Decimal value";

                    }
                    break;
            }

        }
        function validateWebService(source, arguments) {
            if ($('#<%=ReportingServicesCheckbox.ClientID%>').is(':checked')) {
                if ($('#<%=WebServiceIDTextbox.ClientID%>').val() == "") {
                    arguments.IsValid = false;
                    return;
                } else {
                    arguments.IsValid = true;
                }
            } else {
                arguments.IsValid = true;
            }
        }
    </script>
</asp:Content>

