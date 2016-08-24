<%@ Page Title="KPI" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="KpiForm.aspx.cs" Inherits="Kpi_KpiForm" %>

<%@ Register Src="../UserControls/FRTWB/AddDataControl.ascx" TagName="AddDataControl" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">

    <div class="container">
        <div class="tile">
            <div class="t-header">
                <div class="th-title">
                    <asp:Label ID="TitleLabel" runat="server" Text="<% $Resources: Kpi, LabelCreateKpi %>"></asp:Label>
                </div>
            </div>

            <div class="t-body tb-padding">

                <div class="row">
                    <div class="col-sm-6">
                        <label>
                            <asp:Label ID="NameLabel" runat="server" Text="<% $Resources: Kpi, LabelName %>"></asp:Label>
                            <span class="label label-danger" id="spRequired1" runat="server">
                                <asp:Label ID="RequiredLabel" runat="server" Text="<% $Resources: Glossary, RequiredLabel %>"></asp:Label></span>
                        </label>
                        <asp:TextBox ID="KpiNameTextBox" runat="server" CssClass="form-control" placeholder="<% $Resources: Kpi, LabelEnterNameKpi %>"></asp:TextBox>
                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="KpiNameTextBox"
                                Display="Dynamic"
                                ValidationGroup="AddData"
                                ErrorMessage="<% $Resources: Kpi, MessageNameRequired %>">
                            </asp:RequiredFieldValidator>

                        </div>

                        <uc1:AddDataControl ID="DataControl" runat="server" />

                        <label>
                            <asp:Label ID="TypeLabel" runat="server" Text="<% $Resources: Kpi, LabelType %>"></asp:Label>
                            <span class="label label-danger" id="spRequired2" runat="server">
                                <asp:Label ID="ReqLabel" runat="server" Text="<% $Resources: Glossary, RequiredLabel %>"></asp:Label></span></label>
                        <asp:DropDownList ID="KPITypeCombobox" runat="server" CssClass="form-control m-b-10" DataSourceID="KPITypeObjectDataSource"
                            DataTextField="TypeName" DataValueField="KpiTypeID" AppendDataBoundItems="true" OnSelectedIndexChanged="KPITypeCombobox_SelectedIndexChanged"
                            AutoPostBack="true">
                            <asp:ListItem Text="<% $Resources: Kpi, LabelSelectType %>" Value="" />
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
                                ErrorMessage="<% $Resources: Kpi, MessageTypeRequired %>">
                            </asp:RequiredFieldValidator>
                        </div>
                        <div id="divKpiTypeDescription" runat="server" visible="false" style="border: 1px solid #e8e8e8; padding: 2px 2px 2px 2px;">
                            <asp:Literal ID="TypeKpiLiteral" runat="server"></asp:Literal>
                        </div>
                        <div style="padding-top: 5px">&nbsp;</div>
                        <div class="m-b-10" runat="server" visible="false">
                            <label class="checkbox checkbox-inline cr-alt">
                                <asp:CheckBox runat="server" ID="ReportingServicesCheckbox" />
                                <i class="input-helper"></i>
                                <asp:Label ID="WSLabel" runat="server" Text="<% $Resources: Kpi, LabelUsingWS %>"></asp:Label>
                            </label>
                        </div>
                        <div id="webServicePanel" class="m-b-10 hidden" runat="server" visible="false">
                            <div class="m-b-10">
                                <asp:Literal ID="WSLiteral" runat="server" Text="<% $Resources: Kpi, MessageWS %>"></asp:Literal>
                            </div>
                            <div>
                                <label>
                                    <asp:Label ID="WSIdLabel" runat="server" Text="<% $Resources: Kpi, LabelWebServiceID %>"></asp:Label>
                                    <span class="label label-danger">
                                        <asp:Label ID="Req1Label" runat="server" Text="<% $Resources: Glossary, RequiredLabel %>"></asp:Label></span></label>
                                <asp:TextBox ID="WebServiceIDTextbox" runat="server" CssClass="form-control" placeholder="<% $Resources: Kpi, MessageEnterWS %>"></asp:TextBox>
                                <div class="has-error m-b-10">
                                    <asp:CustomValidator runat="server" Display="Dynamic" ValidationGroup="AddKpi"
                                        ErrorMessage="<% $Resources: Kpi, MessageWSRequired %>"
                                        ClientValidationFunction="validateWebService"></asp:CustomValidator>
                                </div>
                            </div>
                        </div>

                        <%--Report Unit--%>
                        <label>
                            <asp:Label ID="UnitTitleLabel" runat="server" Text="<% $Resources: Kpi, LabelUnit %>"></asp:Label>
                            <span class="label label-danger" id="spRequired3" runat="server">
                                <asp:Label ID="Req2Label" runat="server" Text="<% $Resources: Glossary, RequiredLabel %>"></asp:Label></span></label>
                        <asp:DropDownList ID="UnitCombobox" runat="server" CssClass="form-control m-b-10"
                            DataSourceID="UnitObjectDataSource" DataTextField="Name" DataValueField="UnitID" AppendDataBoundItems="true">
                            <asp:ListItem Text="<% $Resources: Kpi, LabelSelectUnit %>" Value="" />
                        </asp:DropDownList>
                        <asp:ObjectDataSource ID="UnitObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
                            SelectMethod="GetUnits" TypeName="Artexacta.App.Unit.BLL.UnitBLL" OnSelected="UnitObjectDataSource_Selected">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="LanguageHiddenField" Name="language" PropertyName="Value" Type="String" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                        <asp:HiddenField runat="server" ID="SelectedUnitHiddenField" />

                        <%--Direction--%>
                        <label>
                            <asp:Label ID="DirectionLabel" runat="server" Text="<% $Resources: Kpi, LabelDirection %>"></asp:Label>
                            <span class="label label-danger" id="spRequired4" runat="server">
                                <asp:Label ID="Req3Label" runat="server" Text="<% $Resources: Glossary, RequiredLabel %>"></asp:Label></span></label>
                        <asp:DropDownList ID="DirectionCombobox" runat="server" CssClass="form-control m-b-10" DataSourceID="DirectionObjectDataSource"
                            DataTextField="Name" DataValueField="DirectionID" AppendDataBoundItems="true">
                            <asp:ListItem Text="<% $Resources: Kpi, LabelSelectDirection %>" Value="" />
                        </asp:DropDownList>
                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator ID="DirectionRequiredFieldValidator" runat="server" ControlToValidate="DirectionCombobox"
                                Display="Dynamic"
                                ValidationGroup="AddData"
                                ErrorMessage="<% $Resources: Kpi, MessageDirectionRequired %>">
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
                        <label>
                            <asp:Label ID="StrategyLabel" runat="server" Text="<% $Resources: Kpi, LabelStrategy %>"></asp:Label>
                            <span class="label label-danger" id="spRequired5" runat="server">
                                <asp:Label ID="Req4Label" runat="server" Text="<% $Resources: Glossary, RequiredLabel %>"></asp:Label></span></label>
                        <asp:DropDownList ID="StrategyCombobox" runat="server" CssClass="form-control m-b-10" DataSourceID="StrategyObjectDataSource"
                            DataTextField="Name" DataValueField="StrategyID" AppendDataBoundItems="true">
                            <asp:ListItem Text="<% $Resources: Kpi, LabelSelectStrategy %>" Value="" />
                        </asp:DropDownList>
                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator ID="StrategyRequiredFieldValidator" runat="server" ControlToValidate="StrategyCombobox"
                                Display="Dynamic"
                                ValidationGroup="AddData"
                                ErrorMessage="<% $Resources: Kpi, MessageStrategyRequired %>">
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
                        <label>
                            <asp:Label ID="ReportingLabel" runat="server" Text="<% $Resources: Kpi, LabelReportingPeriod %>"></asp:Label>
                            <span class="label label-danger" id="spRequired6" runat="server">
                                <asp:Label ID="Req5Label" runat="server" Text="<% $Resources: Glossary, RequiredLabel %>"></asp:Label></span></label>
                        <asp:DropDownList ID="ReportingPeriodCombobox" runat="server" CssClass="form-control m-b-10" DataSourceID="PeriodObjectDataSource"
                            DataTextField="Name" DataValueField="ReportingUnitID" AppendDataBoundItems="true" onChange="LoadReportingPeriod();">
                            <asp:ListItem Text="<% $Resources: Kpi, LabelSelectReporting %>" Value="" />
                        </asp:DropDownList>
                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator ID="ReportingPeriodRequiredFieldValidator" runat="server" ControlToValidate="ReportingPeriodCombobox"
                                Display="Dynamic"
                                ValidationGroup="AddData"
                                ErrorMessage="<% $Resources: Kpi, MessageReportingRequired %>">
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
                                    <label>
                                        <asp:Label ID="CurrencyLabel" runat="server" Text="<% $Resources: Kpi, LabelCurrency %>"></asp:Label>
                                        <span class="label label-danger" id="spRequired7" runat="server">
                                            <asp:Label ID="Req6Label" runat="server" Text="<% $Resources: Glossary, RequiredLabel %>"></asp:Label></span></label>
                                    <asp:DropDownList runat="server" ID="CurrencyCombobox" CssClass="form-control m-b-10"
                                        DataSourceID="CurrencyObjectDataSource" DataTextField="Name" DataValueField="CurrencyID"
                                        AppendDataBoundItems="true" AutoPostBack="true" OnSelectedIndexChanged="CurrencyCombobox_SelectedIndexChanged">
                                        <asp:ListItem Text="<% $Resources: Kpi, LabelSelectCurrency %>" Value="" />
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
                                    <label>
                                        <asp:Label ID="MeasureLabel" runat="server" Text="<% $Resources: Kpi, LabelMeasureCurrency %>"></asp:Label></label>
                                    <asp:DropDownList runat="server" ID="MeasuredInCombobox" CssClass="form-control m-b-10" DataSourceID="MeasuredObjectDataSource"
                                        DataTextField="Name" DataValueField="CurrencyUnitID" AppendDataBoundItems="true"
                                        OnSelectedIndexChanged="MeasuredInCombobox_SelectedIndexChanged" AutoPostBack="true">
                                        <asp:ListItem Text="<% $Resources: Kpi, LabelSelectMeasure %>" Value="" />
                                    </asp:DropDownList>
                                    <asp:ObjectDataSource ID="MeasuredObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
                                        SelectMethod="GetCurrencyUnitsByCurrency" TypeName="Artexacta.App.Currency.BLL.CurrencyUnitBLL">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="LanguageHiddenField" Name="language" PropertyName="Value" Type="String" />
                                            <asp:ControlParameter ControlID="SelectedCurrencyHiddenField" Name="currencyID" PropertyName="Value" Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    <asp:HiddenField runat="server" ID="SelectedMeasureHiddenField" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-5">
                                    <div class="has-error m-b-10">
                                        <asp:RequiredFieldValidator ID="CurrencyRequiredFieldValidator" runat="server" ControlToValidate="CurrencyCombobox"
                                            Display="Dynamic"
                                            ErrorMessage="<% $Resources: Kpi, MessageCurrencyRequired %>">
                                        </asp:RequiredFieldValidator>

                                    </div>
                                </div>
                                <div class="col-md-5">
                                    <div class="has-error m-b-10">
                                        <asp:RequiredFieldValidator ID="MeasuredRequiredFieldValidator" runat="server" ControlToValidate="MeasuredInCombobox"
                                            Display="Dynamic"
                                            ErrorMessage="<% $Resources: Kpi, MessageMeasureRequired %>">
                                        </asp:RequiredFieldValidator>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%--Target Period--%>
                        <label>
                            <asp:Label ID="TargetPeriodLabel" runat="server" Text="<% $Resources: Kpi, LabelTargetPeriod %>"></asp:Label>
                        </label>
                        <div class="row">
                            <div class="col-md-2">
                                <asp:TextBox ID="TargetPeriodTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="col-md-2 col-md-offset-1">
                                <asp:Label ID="UnitLabel" runat="server" Text=""></asp:Label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="has-error m-b-10">
                                    <%-- <asp:RequiredFieldValidator ID="TargetRequiredFieldValidator" runat="server" ControlToValidate="TargetPeriodTextBox"
                                        Display="Dynamic"
                                        ValidationGroup="AddData"
                                        ErrorMessage="<% $Resources: Kpi, MessageTargetPeriodRequired %>">
                                    </asp:RequiredFieldValidator>--%>
                                    <asp:CustomValidator ID="TargetPeriodCustomValidator" runat="server"
                                        ErrorMessage="<% $Resources: Kpi, MessageTargetPeriodRequired %>"
                                        Display="Dynamic"
                                        ValidationGroup="AddData"
                                        OnServerValidate="TargetPeriodCustomValidator_ServerValidate">
                                    </asp:CustomValidator>
                                    <asp:RangeValidator ID="TargetRangeValidator" runat="server"
                                        ErrorMessage="<% $Resources: Kpi, ErrorFormatTargetPeriod %>"
                                        ControlToValidate="TargetPeriodTextBox"
                                        Display="Dynamic"
                                        MinimumValue="0"
                                        MaximumValue="999999999"
                                        ValidationGroup="AddData"
                                        Type="Integer"></asp:RangeValidator>
                                </div>
                            </div>
                        </div>

                        <%--Starting Date--%>
                        <label>
                            <asp:Label ID="SDLabel" runat="server" Text="<% $Resources: Kpi, LabelStartingDate %>"></asp:Label></label>
                        <div class="row">
                            <div class="col-md-4">
                                <div class="input-group date" id="datePicker">
                                    <asp:TextBox ID="StartingDateTextBox" runat="server" CssClass="form-control" />
                                    <span id="pnlDate" runat="server" class="input-group-addon">
                                        <span class="fa fa-calendar"></span>
                                    </span>
                                </div>
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
                                    <asp:CustomValidator ID="StartingDateCustomValidator2" runat="server"
                                        ErrorMessage="<% $Resources: Kpi, MessageStartingDateRequired %>"
                                        Display="Dynamic"
                                        ValidationGroup="AddData"
                                        OnServerValidate="StartingDateCustomValidator2_ServerValidate">
                                    </asp:CustomValidator>
                                    <asp:RangeValidator ID="DateRangeValidator" runat="server"
                                        ErrorMessage="<% $Resources: Kpi, MessageStartingDateFormat %>"
                                        Display="Dynamic"
                                        ValidationGroup="AddData"
                                        Type="Date"
                                        ControlToValidate="StartingDateTextBox"></asp:RangeValidator>
                                </div>
                            </div>
                        </div>

                        <%--Allow Multiple Categories--%>
                        <div class="m-b-10" style="padding-top: 10px">
                            <label class="checkbox checkbox-inline cr-alt">
                                <asp:CheckBox runat="server" ID="categoryCheckBox" />
                                <i class="input-helper"></i>
                                <asp:Label ID="RCLabel" runat="server" Text="<% $Resources: Kpi, LabelReportingByCategories %>"></asp:Label>
                            </label>
                        </div>

                        <%--Single Target--%>
                        <div id="SingleTargetPanel" runat="server" class="m-b-10">
                            <label>
                                <asp:Label ID="TargetLabel" runat="server" Text="<% $Resources: Kpi, LabelTarget %>"></asp:Label></label>
                            <div id="NumericSingleTargetPanel" runat="server">
                                <div class="row">
                                    <div class="col-md-2">
                                        <asp:TextBox ID="SingleTargetTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div class="col-md-3 col-md-offset-1">
                                        <asp:Label ID="UnitTargetLabel" runat="server" Text=""></asp:Label>
                                    </div>
                                </div>
                                <div class="has-error m-b-10">
                                    <asp:CustomValidator ID="FormatTargetCustomValidator" runat="server"
                                        ErrorMessage="<% $Resources: Kpi, ErrorFormatTarget %>"
                                        Display="Dynamic"
                                        ControlToValidate="SingleTargetTextBox"
                                        ValidationGroup="AddData"
                                        OnServerValidate="FormatTargetCustomValidator_ServerValidate"></asp:CustomValidator>
                                    <asp:RangeValidator ID="SingleTargetRangeValidator" runat="server"
                                        ErrorMessage="<% $Resources: Kpi, ErrorFormatTarget %>"
                                        Display="Dynamic"
                                        ControlToValidate="SingleTargetTextBox"
                                        MinimumValue="0"
                                        MaximumValue="999999999"
                                        ValidationGroup="AddData"></asp:RangeValidator>
                                </div>
                            </div>
                            <div id="TimeSingleTargetPanel" runat="server" style="display: none">
                                <div class="row">
                                    <div class="col-md-2">
                                        <asp:DropDownList runat="server" ID="YearsSingleCombobox" CssClass="form-control m-b-10">
                                            <asp:ListItem Text="<% $Resources: Kpi, label0Years %>" Value="0"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label1Year %>" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label2Years %>" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label3Years %>" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label4Years %>" Value="4"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label5Years %>" Value="5"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label6Years %>" Value="6"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label7Years %>" Value="7"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label8Years %>" Value="8"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label9Years %>" Value="9"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label10Years %>" Value="10"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-md-2">
                                        <asp:DropDownList runat="server" ID="MonthsSingleCombobox" CssClass="form-control m-b-10">
                                            <asp:ListItem Text="<% $Resources: Kpi, label0Months %>" Value="0"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label1Month %>" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label2Months %>" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label3Months %>" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label4Months %>" Value="4"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label5Months %>" Value="5"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label6Months %>" Value="6"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label7Months %>" Value="7"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label8Months %>" Value="8"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label9Months %>" Value="9"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label10Months %>" Value="10"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label11Months %>" Value="11"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-md-2">
                                        <asp:DropDownList runat="server" ID="DaysSingleCombobox" CssClass="form-control m-b-10">
                                            <asp:ListItem Text="<% $Resources: Kpi, label0Days %>" Value="0"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label1Day %>" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label2Days %>" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label3Days %>" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label4Days %>" Value="4"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label5Days %>" Value="5"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label6Days %>" Value="6"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label7Days %>" Value="7"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label8Days %>" Value="8"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label9Days %>" Value="9"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label10Days %>" Value="10"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label11Days %>" Value="11"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label12Days %>" Value="12"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label13Days %>" Value="13"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label14Days %>" Value="14"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label15Days %>" Value="15"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label16Days %>" Value="16"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label17Days %>" Value="17"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label18Days %>" Value="18"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label19Days %>" Value="19"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label20Days %>" Value="20"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label21Days %>" Value="21"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label22Days %>" Value="22"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label23Days %>" Value="23"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label24Days %>" Value="24"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label25Days %>" Value="25"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label26Days %>" Value="26"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label27Days %>" Value="27"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label28Days %>" Value="28"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label29Days %>" Value="29"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label30Days %>" Value="30"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-md-2">
                                        <asp:DropDownList runat="server" ID="HoursSingleCombobox" CssClass="form-control m-b-10">
                                            <asp:ListItem Text="<% $Resources: Kpi, label0Hours %>" Value="0"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label1Hour %>" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label2Hours %>" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label3Hours %>" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label4Hours %>" Value="4"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label5Hours %>" Value="5"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label6Hours %>" Value="6"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label7Hours %>" Value="7"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label8Hours %>" Value="8"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label9Hours %>" Value="9"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label10Hours %>" Value="10"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label11Hours %>" Value="11"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label12Hours %>" Value="12"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label13Hours %>" Value="13"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label14Hours %>" Value="14"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label15Hours %>" Value="15"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label16Hours %>" Value="16"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label17Hours %>" Value="17"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label18Hours %>" Value="18"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label19Hours %>" Value="19"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label20Hours %>" Value="20"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label21Hours %>" Value="21"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label22Hours %>" Value="22"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label23Hours %>" Value="23"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-md-2">
                                        <asp:DropDownList runat="server" ID="MinutesSingleCombobox" CssClass="form-control m-b-10">
                                            <asp:ListItem Text="<% $Resources: Kpi, label0Minutes %>" Value="0"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label1Minute %>" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label2Minutes %>" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label3Minutes %>s" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label4Minutes %>" Value="4"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label5Minutes %>" Value="5"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label6Minutes %>" Value="6"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label7Minutes %>" Value="7"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label8Minutes %>" Value="8"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label9Minutes %>" Value="9"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label10Minutes %>" Value="10"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label11Minutes %>" Value="11"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label12Minutes %>" Value="12"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label13Minutes %>" Value="13"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label14Minutes %>" Value="14"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label15Minutes %>" Value="15"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label16Minutes %>" Value="16"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label17Minutes %>" Value="17"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label18Minutes %>" Value="18"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label19Minutes %>" Value="19"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label20Minutes %>" Value="20"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label21Minutes %>" Value="21"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label22Minutes %>" Value="22"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label23Minutes %>" Value="23"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label24Minutes %>" Value="24"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label25Minutes %>" Value="25"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label26Minutes %>" Value="26"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label27Minutes %>" Value="27"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label28Minutes %>" Value="28"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label29Minutes %>" Value="29"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label30Minutes %>" Value="30"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label31Minutes %>" Value="31"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label32Minutes %>" Value="32"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label33Minutes %>" Value="33"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label34Minutes %>" Value="34"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label35Minutes %>" Value="35"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label36Minutes %>" Value="36"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label37Minutes %>" Value="37"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label38Minutes %>" Value="38"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label39Minutes %>" Value="39"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label40Minutes %>" Value="40"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label41Minutes %>" Value="41"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label42Minutes %>" Value="42"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label43Minutes %>" Value="43"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label44Minutes %>" Value="44"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label45Minutes %>" Value="45"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label46Minutes %>" Value="46"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label47Minutes %>" Value="47"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label48Minutes %>" Value="48"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label49Minutes %>" Value="49"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label50Minutes %>" Value="50"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label51Minutes %>" Value="51"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label52Minutes %>" Value="52"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label53Minutes %>" Value="53"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label54Minutes %>" Value="54"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label55Minutes %>" Value="55"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label56Minutes %>" Value="56"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label57Minutes %>" Value="57"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label58Minutes %>" Value="58"></asp:ListItem>
                                            <asp:ListItem Text="<% $Resources: Kpi, label59Minutes %>" Value="59"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%--Multiple Targets--%>
                        <div id="MultipleTargetPanel" runat="server" style="border: thin; display: none">
                            <div class="row" id="pnlCategorySelect" runat="server">
                                <div class="col-md-4">
                                    <label>
                                        <asp:Label ID="CatLabel" runat="server" Text="<% $Resources: Kpi, LabelSelectCategories %>"></asp:Label></label>
                                    <asp:DropDownList ID="CategoryComboBox" runat="server" CssClass="form-control m-b-10" AppendDataBoundItems="True"
                                        DataSourceID="CategoryObjectDataSource" DataTextField="Name" DataValueField="ID">
                                        <asp:ListItem Text="<% $Resources: Kpi, LabelSelectCategory %>" Value="" />
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-1" style="text-align: left">
                                    <br />
                                    <asp:LinkButton ID="AddCategory" runat="server" CssClass="viewBtn" OnClick="AddCategory_Click"
                                        CausesValidation="false" ToolTip="<% $Resources: Kpi, LabelAddCategory %>"><i class="zmdi zmdi-plus-circle-o zmdi-hc-fw"></i></asp:LinkButton>
                                </div>
                            </div>
                            <div class="row">
                                <asp:Repeater ID="CategoriesRepeater" runat="server" OnItemCommand="CategoriesRepeater_ItemCommand" OnItemDataBound="CategoriesRepeater_ItemDataBound">
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
                                    <label>
                                        <asp:Label ID="CTLabel" runat="server" Text="<% $Resources: Kpi, LabelCategoryTargets %>"></asp:Label></label>
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
                                                        <asp:TextBox ID="TargetTextBox" runat="server"></asp:TextBox>
                                                    </div>
                                                    <div class="col-md-2 col-md-offset-1">
                                                        <asp:Label ID="UnitTargetLabel" runat="server" Text=""></asp:Label>
                                                    </div>
                                                    <div class="col-md-4 col-md-offset-1">
                                                        <asp:RangeValidator ID="TargetRangeValidator" runat="server"
                                                            ErrorMessage="<% $Resources: Kpi, ErrorFormatTarget %>"
                                                            Display="Dynamic"
                                                            ControlToValidate="TargetTextBox"
                                                            MinimumValue="0"
                                                            MaximumValue="999999999"
                                                            Type="Double"></asp:RangeValidator>
                                                    </div>
                                                </div>
                                                <div id="timeTarget" runat="server" style="display: none">
                                                    <div class="col-md-2">
                                                        <asp:DropDownList runat="server" ID="YearsCombobox" CssClass="form-control m-b-10">
                                                            <asp:ListItem Text="<% $Resources: Kpi, label0Years %>" Value="0"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label1Year %>" Value="1"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label2Years %>" Value="2"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label3Years %>" Value="3"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label4Years %>" Value="4"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label5Years %>" Value="5"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label6Years %>" Value="6"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label7Years %>" Value="7"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label8Years %>" Value="8"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label9Years %>" Value="9"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label10Years %>" Value="10"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div class="col-md-2">
                                                        <asp:DropDownList runat="server" ID="MonthsCombobox" CssClass="form-control m-b-10">
                                                            <asp:ListItem Text="<% $Resources: Kpi, label0Months %>" Value="0"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label1Month %>" Value="1"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label2Months %>" Value="2"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label3Months %>" Value="3"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label4Months %>" Value="4"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label5Months %>" Value="5"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label6Months %>" Value="6"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label7Months %>" Value="7"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label8Months %>" Value="8"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label9Months %>" Value="9"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label10Months %>" Value="10"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label11Months %>" Value="11"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div class="col-md-2">
                                                        <asp:DropDownList runat="server" ID="DaysCombobox" CssClass="form-control m-b-10">
                                                            <asp:ListItem Text="<% $Resources: Kpi, label0Days %>" Value="0"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label1Day %>" Value="1"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label2Days %>" Value="2"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label3Days %>" Value="3"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label4Days %>" Value="4"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label5Days %>" Value="5"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label6Days %>" Value="6"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label7Days %>" Value="7"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label8Days %>" Value="8"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label9Days %>" Value="9"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label10Days %>" Value="10"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label11Days %>" Value="11"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label12Days %>" Value="12"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label13Days %>" Value="13"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label14Days %>" Value="14"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label15Days %>" Value="15"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label16Days %>" Value="16"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label17Days %>" Value="17"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label18Days %>" Value="18"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label19Days %>" Value="19"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label20Days %>" Value="20"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label21Days %>" Value="21"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label22Days %>" Value="22"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label23Days %>" Value="23"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label24Days %>" Value="24"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label25Days %>" Value="25"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label26Days %>" Value="26"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label27Days %>" Value="27"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label28Days %>" Value="28"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label29Days %>" Value="29"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label30Days %>" Value="30"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div class="col-md-2">
                                                        <asp:DropDownList runat="server" ID="HoursCombobox" CssClass="form-control m-b-10">
                                                            <asp:ListItem Text="<% $Resources: Kpi, label0Hours %>" Value="0"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label1Hour %>" Value="1"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label2Hours %>" Value="2"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label3Hours %>" Value="3"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label4Hours %>" Value="4"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label5Hours %>" Value="5"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label6Hours %>" Value="6"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label7Hours %>" Value="7"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label8Hours %>" Value="8"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label9Hours %>" Value="9"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label10Hours %>" Value="10"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label11Hours %>" Value="11"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label12Hours %>" Value="12"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label13Hours %>" Value="13"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label14Hours %>" Value="14"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label15Hours %>" Value="15"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label16Hours %>" Value="16"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label17Hours %>" Value="17"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label18Hours %>" Value="18"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label19Hours %>" Value="19"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label20Hours %>" Value="20"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label21Hours %>" Value="21"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label22Hours %>" Value="22"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label23Hours %>" Value="23"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div class="col-md-2">
                                                        <asp:DropDownList runat="server" ID="MinutesCombobox" CssClass="form-control m-b-10">
                                                            <asp:ListItem Text="<% $Resources: Kpi, label0Minutes %>" Value="0"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label1Minute %>" Value="1"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label2Minutes %>" Value="2"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label3Minutes %>s" Value="3"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label4Minutes %>" Value="4"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label5Minutes %>" Value="5"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label6Minutes %>" Value="6"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label7Minutes %>" Value="7"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label8Minutes %>" Value="8"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label9Minutes %>" Value="9"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label10Minutes %>" Value="10"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label11Minutes %>" Value="11"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label12Minutes %>" Value="12"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label13Minutes %>" Value="13"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label14Minutes %>" Value="14"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label15Minutes %>" Value="15"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label16Minutes %>" Value="16"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label17Minutes %>" Value="17"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label18Minutes %>" Value="18"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label19Minutes %>" Value="19"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label20Minutes %>" Value="20"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label21Minutes %>" Value="21"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label22Minutes %>" Value="22"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label23Minutes %>" Value="23"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label24Minutes %>" Value="24"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label25Minutes %>" Value="25"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label26Minutes %>" Value="26"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label27Minutes %>" Value="27"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label28Minutes %>" Value="28"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label29Minutes %>" Value="29"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label30Minutes %>" Value="30"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label31Minutes %>" Value="31"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label32Minutes %>" Value="32"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label33Minutes %>" Value="33"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label34Minutes %>" Value="34"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label35Minutes %>" Value="35"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label36Minutes %>" Value="36"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label37Minutes %>" Value="37"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label38Minutes %>" Value="38"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label39Minutes %>" Value="39"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label40Minutes %>" Value="40"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label41Minutes %>" Value="41"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label42Minutes %>" Value="42"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label43Minutes %>" Value="43"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label44Minutes %>" Value="44"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label45Minutes %>" Value="45"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label46Minutes %>" Value="46"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label47Minutes %>" Value="47"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label48Minutes %>" Value="48"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label49Minutes %>" Value="49"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label50Minutes %>" Value="50"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label51Minutes %>" Value="51"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label52Minutes %>" Value="52"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label53Minutes %>" Value="53"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label54Minutes %>" Value="54"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label55Minutes %>" Value="55"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label56Minutes %>" Value="56"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label57Minutes %>" Value="57"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label58Minutes %>" Value="58"></asp:ListItem>
                                                            <asp:ListItem Text="<% $Resources: Kpi, label59Minutes %>" Value="59"></asp:ListItem>
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
                        <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary" Text="<% $Resources: Glossary, GenericSaveLabel %>"
                            ValidationGroup="AddData" OnClick="SaveButton_Click">
                        </asp:LinkButton>
                        <asp:LinkButton ID="CancelButton" runat="server" CssClass="btn btn-danger" Text="<% $Resources: Kpi, ButtonBack %>"
                            OnClick="CancelButton_Click" CausesValidation="false"></asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="KpiIdHiddenField" runat="server" Value="0" />
    <asp:HiddenField ID="ParentPageHiddenField" runat="server" Value="" />
    <asp:HiddenField ID="LanguageHiddenField" runat="server" Value="" />
    <asp:HiddenField ID="ReadOnlyHiddenField" runat="server" Value="" />
    <asp:ObjectDataSource ID="CategoryObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="GetCategories" TypeName="Artexacta.App.Categories.BLL.CategoryBLL" OnSelected="CategoryObjectDataSource_Selected"></asp:ObjectDataSource>

    <script type="text/javascript">
        var lang = <%= Resources.ImportData.Language %>
        $(function () {
            $('#datePicker').datetimepicker({
                format: 'L',
                locale: lang
            });
        });

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

            if (ddlPeriod.selectedIndex > 0)
                txt.innerText = ddlPeriod.options[ddlPeriod.selectedIndex].innerHTML;
            else
                txt.innerText = "";
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

