<%@ Page Title="KPI" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="KpiForm.aspx.cs" Inherits="Kpi_KpiForm" %>

<%@ Register Src="../UserControls/FRTWB/AddDataControl.ascx" TagName="AddDataControl" TagPrefix="uc1" %>

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
                                ValidationGroup="AddData"
                                ErrorMessage="You must enter the Kpi Name">
                            </asp:RequiredFieldValidator>

                        </div>

                        <uc1:AddDataControl ID="DataControl" runat="server" />

                        <label>KPI Type <span class="label label-danger">Required</span></label>
                        <asp:DropDownList ID="KPITypeCombobox" runat="server" CssClass="form-control m-b-10" DataSourceID="KPITypeObjectDataSource"
                            DataTextField="TypeName" DataValueField="KpiTypeID" AppendDataBoundItems="true" OnSelectedIndexChanged="KPITypeCombobox_SelectedIndexChanged"
                            AutoPostBack="true">
                            <asp:ListItem Text="[Select a KPI Type]" Value="" />
                        </asp:DropDownList>
                        <asp:ObjectDataSource ID="KPITypeObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
                            SelectMethod="GetKPITypes" TypeName="Artexacta.App.KPI.BLL.KPITypeBLL" OnSelected="KPITypeObjectDataSource_Selected">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="LanguageHiddenField" Name="language" PropertyName="Value" Type="String" />
                            </SelectParameters>
                        </asp:ObjectDataSource>

                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="KPITypeCombobox"
                                Display="Dynamic"
                                ValidationGroup="AddData"
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

                        <%--Report Unit--%>
                        <label>Unit <span class="label label-danger">Required</span></label>
                        <asp:DropDownList ID="UnitCombobox" runat="server" CssClass="form-control m-b-10"
                            DataSourceID="UnitObjectDataSource" DataTextField="Name" DataValueField="UnitID" AppendDataBoundItems="true">
                            <asp:ListItem Text="[Select a Unit]" Value="" />
                        </asp:DropDownList>
                        <asp:ObjectDataSource ID="UnitObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
                            SelectMethod="GetUnits" TypeName="Artexacta.App.Unit.BLL.UnitBLL" OnSelected="UnitObjectDataSource_Selected">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="LanguageHiddenField" Name="language" PropertyName="Value" Type="String" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                        <asp:HiddenField runat="server" ID="SelectedUnitHiddenField" />

                        <%--Direction--%>
                        <label>Direction <span class="label label-danger">Required</span></label>
                        <asp:DropDownList ID="DirectionCombobox" runat="server" CssClass="form-control m-b-10" DataSourceID="DirectionObjectDataSource"
                            DataTextField="Name" DataValueField="DirectionID" AppendDataBoundItems="true">
                            <asp:ListItem Text="[Select a Direction]" Value="" />
                        </asp:DropDownList>
                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator ID="DirectionRequiredFieldValidator" runat="server" ControlToValidate="DirectionCombobox"
                                Display="Dynamic"
                                ValidationGroup="AddData"
                                ErrorMessage="You must select a Direction">
                            </asp:RequiredFieldValidator>
                        </div>
                        <asp:ObjectDataSource ID="DirectionObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
                            SelectMethod="GetDirections" TypeName="Artexacta.App.Direction.BLL.DirectionBLL" OnSelected="DirectionObjectDataSource_Selected">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="LanguageHiddenField" Name="language" PropertyName="Value" Type="String" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                        <asp:HiddenField runat="server" ID="SelectedDirectionHiddenField" />

                        <%--Accumulation Strategy--%>
                        <label>Accumulation Strategy <span class="label label-danger">Required</span></label>
                        <asp:DropDownList ID="StrategyCombobox" runat="server" CssClass="form-control m-b-10" DataSourceID="StrategyObjectDataSource"
                            DataTextField="Name" DataValueField="StrategyID" AppendDataBoundItems="true">
                            <asp:ListItem Text="[Select a Strategy]" Value="" />
                        </asp:DropDownList>
                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator ID="StrategyRequiredFieldValidator" runat="server" ControlToValidate="StrategyCombobox"
                                Display="Dynamic"
                                ValidationGroup="AddData"
                                ErrorMessage="You must select a Accumulation Strategy">
                            </asp:RequiredFieldValidator>
                        </div>
                        <asp:ObjectDataSource ID="StrategyObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
                            SelectMethod="GetReportingUnit" TypeName="Artexacta.App.Strategy.BLL.StrategyBLL" OnSelected="StrategyObjectDataSource_Selected">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="LanguageHiddenField" Name="language" PropertyName="Value" Type="String" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                        <asp:HiddenField runat="server" ID="SelectedStrategyHiddenFields" />

                        <%--Reporting Period--%>
                        <label>Reporting Period <span class="label label-danger">Required</span></label>
                        <asp:DropDownList ID="ReportingPeriodCombobox" runat="server" CssClass="form-control m-b-10" DataSourceID="PeriodObjectDataSource"
                            DataTextField="Name" DataValueField="ReportingUnitID" AppendDataBoundItems="true" onChange="LoadReportingPeriod();">
                            <asp:ListItem Text="[Select a Reporting Period]" Value="" />
                        </asp:DropDownList>
                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator ID="ReportingPeriodRequiredFieldValidator" runat="server" ControlToValidate="ReportingPeriodCombobox"
                                Display="Dynamic"
                                ValidationGroup="AddData"
                                ErrorMessage="You must select a Reporting Period">
                            </asp:RequiredFieldValidator>
                        </div>
                        <asp:ObjectDataSource ID="PeriodObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetReportingUnit" TypeName="Artexacta.App.ReportingUnit.BLL.ReportingUnitBLL">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="LanguageHiddenField" Name="language" PropertyName="Value" Type="String" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                        <asp:HiddenField runat="server" ID="ReportingPeriodHiddenfield" />

                        <%--Currency--%>
                        <div id="CurrencyPanel" runat="server" style="display: none">
                            <div class="row">
                                <div class="col-md-5">
                                    <label>Currency <span class="label label-danger">Required</span></label>
                                    <asp:DropDownList runat="server" ID="CurrencyCombobox" CssClass="form-control m-b-10"
                                        DataSourceID="CurrencyObjectDataSource" DataTextField="Name" DataValueField="CurrencyID"
                                        AppendDataBoundItems="true" AutoPostBack="true" OnSelectedIndexChanged="CurrencyCombobox_SelectedIndexChanged">
                                        <asp:ListItem Text="[Select a Currency]" Value="" />
                                    </asp:DropDownList>
                                    <asp:ObjectDataSource ID="CurrencyObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
                                        SelectMethod="GetCurrencys" TypeName="Artexacta.App.Currency.BLL.CurrencyBLL" OnSelected="CurrencyObjectDataSource_Selected">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="LanguageHiddenField" Name="language" PropertyName="Value" Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    <asp:HiddenField runat="server" ID="SelectedCurrencyHiddenField" />
                                </div>
                                <div class="col-md-5">
                                    <label>Measured in</label>
                                    <asp:DropDownList runat="server" ID="MeasuredInCombobox" CssClass="form-control m-b-10" DataSourceID="MeasuredObjectDataSource"
                                        DataTextField="Name" DataValueField="CurrencyUnitID" AppendDataBoundItems="true"
                                        OnSelectedIndexChanged="MeasuredInCombobox_SelectedIndexChanged" AutoPostBack="true">
                                        <asp:ListItem Text="[Select a Measured]" Value="" />
                                    </asp:DropDownList>
                                    <asp:ObjectDataSource ID="MeasuredObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
                                        SelectMethod="GetCurrencyUnitsByCurrency" TypeName="Artexacta.App.Currency.BLL.CurrencyUnitBLL">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="LanguageHiddenField" Name="language" PropertyName="Value" Type="String" />
                                            <asp:ControlParameter ControlID="SelectedCurrencyHiddenField" Name="currencyID" PropertyName="Value" Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-5">
                                    <div class="has-error m-b-10">
                                        <asp:RequiredFieldValidator ID="CurrencyRequiredFieldValidator" runat="server" ControlToValidate="CurrencyCombobox"
                                            Display="Dynamic"
                                            ErrorMessage="You must select a Currency">
                                        </asp:RequiredFieldValidator>

                                    </div>
                                </div>
                                <div class="col-md-5">
                                    <div class="has-error m-b-10">
                                        <asp:RequiredFieldValidator ID="MeasuredRequiredFieldValidator" runat="server" ControlToValidate="MeasuredInCombobox"
                                            Display="Dynamic"
                                            ErrorMessage="You must select a Measured">
                                        </asp:RequiredFieldValidator>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%--Target Period--%>
                        <label>Target Period<span class="label label-danger">Required</span></label>
                        <div class="row">
                            <div class="col-md-2">
                                <telerik:RadNumericTextBox MinValue="0" NumberFormat-DecimalDigits="0"
                                    runat="server" ID="TargetPeriodTextBox">
                                </telerik:RadNumericTextBox>
                            </div>
                            <div class="col-md-2 col-md-offset-1">
                                <asp:Label ID="UnitLabel" runat="server" Text=""></asp:Label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="has-error m-b-10">
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TargetPeriodTextBox"
                                        Display="Dynamic"
                                        ValidationGroup="AddData"
                                        ErrorMessage="You must choose the Target Period for the Kpi">
                                    </asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>

                        <%--Starting Date--%>
                        <label>Starting Date</label>
                        <div class="row">
                            <div class="col-md-4">
                                <telerik:RadDatePicker ID="StartingDatePicker" runat="server"></telerik:RadDatePicker>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="has-error m-b-10">
                                    <asp:CustomValidator ID="StartingDateCustomValidator" runat="server"
                                        ErrorMessage="<% $Resources: Kpi, MessageStartingDateRequired %>"
                                        Display="Dynamic"
                                        ValidationGroup="AddData"
                                        OnServerValidate="StartingDateCustomValidator_ServerValidate">
                                    </asp:CustomValidator>
                                </div>
                            </div>
                        </div>

                        <%--Allow Multiple Categories--%>
                        <div class="m-b-10" style="padding-top: 10px">
                            <label class="checkbox checkbox-inline cr-alt">
                                <asp:CheckBox runat="server" ID="categoryCheckBox" />
                                <i class="input-helper"></i>
                                KPI Allows Reporting by Categories
                            </label>
                        </div>

                        <%--Single Target--%>
                        <div id="SingleTargetPanel" runat="server" class="m-b-10">
                            <label>KPI Target</label>
                            <div id="NumericSingleTargetPanel" runat="server">
                                <div class="row">
                                    <div class="col-md-2">
                                        <telerik:RadNumericTextBox MinValue="0" NumberFormat-DecimalDigits="0"
                                            runat="server" ID="SingleTargetTextBox">
                                            <EnabledStyle HorizontalAlign="Right" />
                                        </telerik:RadNumericTextBox>
                                    </div>
                                    <div class="col-md-3 col-md-offset-1">
                                        <asp:Label ID="UnitTargetLabel" runat="server" Text=""></asp:Label>
                                    </div>
                                </div>
                            </div>
                            <div id="TimeSingleTargetPanel" runat="server" style="display: none">
                                <div class="row">
                                    <div class="col-md-2">
                                        <asp:DropDownList runat="server" ID="YearsSingleCombobox" CssClass="form-control m-b-10">
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
                                        <asp:DropDownList runat="server" ID="MonthsSingleCombobox" CssClass="form-control m-b-10">
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
                                        <asp:DropDownList runat="server" ID="DaysSingleCombobox" CssClass="form-control m-b-10">
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
                                        <asp:DropDownList runat="server" ID="HoursSingleCombobox" CssClass="form-control m-b-10">
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
                                        <asp:DropDownList runat="server" ID="MinutesSingleCombobox" CssClass="form-control m-b-10">
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
                        </div>

                        <%--Multiple Targets--%>
                        <div id="MultipleTargetPanel" runat="server" style="border: thin; display: none">
                            <div class="row">
                                <table>
                                    <tr>
                                        <td>
                                            <label>Select the Categories</label>
                                            <asp:DropDownList ID="CategoryComboBox" runat="server" CssClass="form-control m-b-10" AppendDataBoundItems="True"
                                                DataSourceID="CategoryObjectDataSource" DataTextField="Name" DataValueField="ID">
                                                <asp:ListItem Text="[Select a Category]" Value="" />
                                            </asp:DropDownList></td>
                                        <td>
                                            <asp:LinkButton ID="AddCategory" runat="server" CssClass="viewBtn" OnClick="AddCategory_Click"
                                                CausesValidation="false"><i class="zmdi zmdi-plus-circle-o zmdi-hc-fw"></i></asp:LinkButton></td>
                                    </tr>
                                </table>
                            </div>
                            <div class="row">
                                <asp:Repeater ID="CategoriesRepeater" runat="server" OnItemCommand="CategoriesRepeater_ItemCommand">
                                    <ItemTemplate>
                                        <div class="col-md-3">
                                            <asp:LinkButton ID="RemoveButton" runat="server" CommandName="Remove" CommandArgument='<%# Eval("ID") %>' CausesValidation="false"
                                                OnClientClick="return confirm('Are you sure you want to delete the category? All the data would be zero.')">
                                                     <i class="fa fa-minus-circle"></i>
                                            </asp:LinkButton>
                                            <asp:Label ID="CategoryLabel" runat="server" Text='<%# Eval("Name") %>' Style="margin: 0 5px;" />
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                            <div class="row" style="padding-top: 20px">
                                <div class="col-sm-12">
                                    <label>Category Targets</label>
                                    <asp:Repeater ID="targetsRepeater" runat="server" OnItemDataBound="targetsRepeater_ItemDataBound">
                                        <ItemTemplate>
                                            <div class="row">
                                                <asp:HiddenField ID="IDHiddenField" runat="server" Value='<%# Eval("TargetID") %>' />
                                                <asp:HiddenField ID="ValueHiddenField" runat="server" Value='<%# Eval("Target") %>' />
                                                <div class="col-md-2">
                                                    <asp:Label ID="ItemsLabel" runat="server" Text='<%# Eval("Detalle") %>' Style="margin: 0 5px;" />
                                                </div>
                                                <div id="numericTarget" runat="server" style="display: none">
                                                    <div class="col-md-2">
                                                        <telerik:RadNumericTextBox MinValue="0" NumberFormat-DecimalDigits="0"
                                                            runat="server" ID="TargetTextBox">
                                                            <EnabledStyle HorizontalAlign="Right" />
                                                        </telerik:RadNumericTextBox>
                                                    </div>
                                                    <div class="col-md-3 col-md-offset-1">
                                                        <asp:Label ID="UnitTargetLabel" runat="server" Text=""></asp:Label>
                                                    </div>
                                                </div>
                                                <div id="timeTarget" runat="server" style="display: none">
                                                    <div class="col-md-2">
                                                        <asp:DropDownList runat="server" ID="YearsCombobox" CssClass="form-control m-b-10">
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
                                                        <asp:DropDownList runat="server" ID="MonthsCombobox" CssClass="form-control m-b-10">
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
                                                        <asp:DropDownList runat="server" ID="DaysCombobox" CssClass="form-control m-b-10">
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
                                                        <asp:DropDownList runat="server" ID="HoursCombobox" CssClass="form-control m-b-10">
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
                                                        <asp:DropDownList runat="server" ID="MinutesCombobox" CssClass="form-control m-b-10">
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
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="has-error m-b-10">
                                <asp:CustomValidator ID="TargetCustomValidator" runat="server"
                                    ErrorMessage="<% $Resources: Kpi, MessageTargetRequired %>"
                                    Display="Dynamic"
                                    ValidationGroup="AddData"
                                    OnServerValidate="TargetCustomValidator_ServerValidate">
                                </asp:CustomValidator>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <hr />
                        <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary" Text="Save Kpi"
                            ValidationGroup="AddData" OnClick="SaveButton_Click">
                        </asp:LinkButton>
                        <asp:LinkButton ID="CancelButton" runat="server" CssClass="btn btn-danger" Text="Cancel"
                            OnClick="CancelButton_Click" CausesValidation="false"></asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="KpiIdHiddenField" runat="server" Value="0" />
    <asp:HiddenField ID="ParentPageHiddenField" runat="server" Value="" />
    <asp:HiddenField ID="LanguageHiddenField" runat="server" Value="" />
    <asp:ObjectDataSource ID="CategoryObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="GetCategories" TypeName="Artexacta.App.Categories.BLL.CategoryBLL" OnSelected="CategoryObjectDataSource_Selected"></asp:ObjectDataSource>

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
            strategyCombo = $('#<%=StrategyCombobox.ClientID%>');
            reportingPeriodCombo = $('#<%=ReportingPeriodCombobox.ClientID%>');
            reportingUnitsCombo = $('#ReportingUnitsCombobox');
            webServiceCheckbox = $('#<%=ReportingServicesCheckbox.ClientID%>');
            allowCategoriesCheckbox = $('#<%=categoryCheckBox.ClientID%>');

            //kpiCombo.on('change', updateFormByKpiType);
            reportingPeriodCombo.on('change', updateReportingUnitCombo);
            reportingUnitsCombo.on('change', function () {
                $('#<%=ReportingPeriodHiddenfield.ClientID%>').val($(this).val());
            });
            //updateFormByKpiType();
            updateReportingUnitCombo();

            webServiceCheckbox.on('change', webserviceVisibility);
            webserviceVisibility();

            allowCategoriesCheckbox.on('change', categoriesVisibility);
            categoriesVisibility();

            if ($('#<%=SelectedStrategyHiddenFields.ClientID%>').val() != "") {
                strategyCombo.val($('#<%=SelectedStrategyHiddenFields.ClientID%>').val());
            }
            if ($('#<%=SelectedDirectionHiddenField.ClientID%>').val() != "") {
                directionCombo.val($('#<%=SelectedDirectionHiddenField.ClientID%>').val());
            }
            strategyCombo.on('change', function () {
                $('#<%=SelectedStrategyHiddenFields.ClientID%>').val($(this).val());
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
        function categoriesVisibility() {
            var singlePanel = document.getElementById("<%= SingleTargetPanel.ClientID %>");
            var multiplePanel = document.getElementById("<%= MultipleTargetPanel.ClientID %>");

            if (allowCategoriesCheckbox.is(':checked')) {
                multiplePanel.style.display = "block";
                singlePanel.style.display = "none";
            } else {
                singlePanel.style.display = "block";
                multiplePanel.style.display = "none";
            }
        }
        function LoadReportingPeriod() {
            var ddlPeriod = document.getElementById("<%=ReportingPeriodCombobox.ClientID %>");
            var txt = document.getElementById("<%= UnitLabel.ClientID %>");
            txt.innerText = ddlPeriod.options[ddlPeriod.selectedIndex].innerHTML;
        }
        function LoadCurrency() {
            var ddlCurrency = document.getElementById("<%=CurrencyCombobox.ClientID %>");
            var ddlMeasured = document.getElementById("<%=MeasuredInCombobox.ClientID %>");
            var labTarget = document.getElementById("<%=UnitTargetLabel.ClientID %>");

            var txtCurrency = ddlCurrency.options[ddlCurrency.selectedIndex].innerHTML;
            var txtMeasured = ddlMeasured.options[ddlMeasured.selectedIndex].innerHTML;

            document.getElementById("<%=UnitTargetLabel.ClientID %>").innerText = txtMeasured.concat(" of ", txtCurrency);
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
            var hiddenVal = $('#<%=ReportingPeriodHiddenfield.ClientID%>').val();
            if (hiddenVal != "" && $('#ReportingUnitsCombobox').find('option[value="' + hiddenVal + '"]').length > 0) {
                reportingUnitsCombo.val(hiddenVal);
            } else {
                $('#<%=ReportingPeriodHiddenfield.ClientID%>').val(reportingUnitsCombo.val());
            }

        }

        function validateReportingUnits(source, arguments) {
            if ($('#<%=ReportingPeriodHiddenfield.ClientID%>').val() == "") {
                arguments.IsValid = false;
            } else {
                arguments.IsValid = true;
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

