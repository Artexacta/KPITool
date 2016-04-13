<%@ Page Title="KPI" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="KpiDataEntry.aspx.cs" Inherits="Kpi_KpiDataEntry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">

    <asp:Panel ID="KpiInsertPanel" runat="server" CssClass="container">
        <div class="tile">
            <div class="t-header">
                <div class="th-title">
                    Kpi Data Entry -
                    <asp:Literal runat="server" ID="NameLiteral"></asp:Literal>
                </div>
            </div>
            <div class="t-body tb-padding">
                <div class="row">
                    <div class="col-sm-6">

                        <div>
                            <label>KPI Type</label>
                        </div>
                        <div>
                            <asp:Label runat="server" ID="KpiTypeLabel"></asp:Label>
                        </div>

                        <asp:Panel ID="webServicePanel" CssClass="m-b-10" runat="server">
                            <div>
                                <label>Web Service ID</label>
                                <asp:Label runat="server" ID="WebServiceIdLael"></asp:Label>
                            </div>
                        </asp:Panel>
                        <div>
                            <label>Reporting Period</label>
                        </div>
                        <div>
                            <asp:Label runat="server" ID="ReportingPeriodLabel"></asp:Label>
                        </div>
                        <asp:HiddenField runat="server" ID="TypeValueHiddenField" />
                        <div>
                            <label>Starting Date</label>
                        </div>
                        <div>
                            <asp:Label ID="lblStartingDate" runat="server" />
                        </div>
                    </div>
                </div>
                <div class="row" id="valueRow">
                    <div class="col-md-12">
                        <div>
                            <label>Value Date <span class="label label-danger">Required</span></label>
                            <div>
                                <telerik:RadDatePicker runat="server" ID="ValueDatePicker" MaxValue="100" MinValue="0" CssClass="form-control m-b-10"></telerik:RadDatePicker>
                            </div>
                            <div class="has-error m-b-10">
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="ValueDatePicker"
                                    Display="Dynamic"
                                    ValidationGroup="AddKpiData"
                                    ErrorMessage="You must enter the Kpi Value Date">
                                </asp:RequiredFieldValidator>
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
                                    <label>Report new Value <span class="label label-danger">Required</span></label>
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
                                <div class="col-md-12">
                                    <label>Report new Value <span class="label label-danger">Required</span></label>
                                </div>
                                <div class="col-md-12">
                                    <telerik:RadNumericTextBox Type="Currency" runat="server" ID="TargetMoneyValueTextbox" CssClass="form-control m-b-10"></telerik:RadNumericTextBox>
                                    <asp:Label runat="server" ID="MeasuredInLabel"></asp:Label>
                                    of
                                    <asp:Label runat="server" ID="CurrencyLabel"></asp:Label>
                                </div>
                            </div>
                        </div>
                        <div id="integerPanel" class="targetPanels">
                            <label>Report new Value <span class="label label-danger">Required</span></label>
                            <div>
                                <telerik:RadNumericTextBox runat="server" Type="Number" ID="TargetIntegerTextbox" CssClass="form-control m-b-10" NumberFormat-DecimalDigits="0" MinValue="0"></telerik:RadNumericTextBox>
                            </div>
                        </div>
                        <div id="decimalPanel" class="targetPanels">
                            <label>Report new Value <span class="label label-danger">Required</span></label>
                            <div>
                                <telerik:RadNumericTextBox Type="Number" runat="server" NumberFormat-DecimalDigits="2" CssClass="form-control m-b-10" ID="TargetDecimalTextbox" MinValue="0"></telerik:RadNumericTextBox>
                            </div>
                        </div>
                        <div id="target-validation" class="has-error">
                            <asp:CustomValidator runat="server" Display="Dynamic" ValidationGroup="AddKpiData" ClientValidationFunction="validateTarget"></asp:CustomValidator>
                        </div>
                    </div>
                </div>
                <div class="row" id="saveButtonRow">
                    <div class="col-sm-12">
                        <hr />
                        <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary" Text="Save Value"
                            ValidationGroup="AddKpiData" OnClick="SaveButton_Click">
                        </asp:LinkButton>
                    </div>
                </div>
                <div class="row hidden" id="importFilePanel">
                    <div class="col-md-12">
                        <div class="well">
                            To load values   from an Excel file you must have at least two columns in the Excel file named "Date" and "Value".  If the values are a time span they must be in ISO 8601 format: durations are represented by the format P[ n ]Y[ n ]M[ n ]DT[ n ]H[ n ]M[ n ]S. For example P1Y2M10DT2H30M. In these representations, the [ n ] is replaced by the value for each of the date and time elements that follow the [ n ]. Leading zeros are not required.   You can <a href="#">[download a sample Excel for numeric values]</a> and a <a href="#">[Sample Excel for time spans]</a>.
                        </div>
                        <div>
                            <div class="form-group">
                                <asp:Label ID="ValuesExistLabel" runat="server" Text="Género" />
                                <div>
                                    <asp:RadioButton Text="Replace old value with new one" Value="replace" runat="server" Checked="true" GroupName="UploadValues" />
                                </div>
                                <div>
                                    <asp:RadioButton Text="Add new value to the old one" Value="add" runat="server" GroupName="UploadValues" />
                                </div>
                            </div>
                        </div>
                        <div>
                            <asp:FileUpload runat="server" ID="fileUpload" />
                        </div>
                    </div>
                </div>
                <div class="row hidden" id="subirArchivoRow">
                    <div class="col-sm-12">
                        <hr />
                        <asp:LinkButton ID="UploadFileButton" runat="server" CssClass="btn btn-primary" Text="Upload File"
                            CausesValidation="false" OnClick="UploadFileButton_Click">
                        </asp:LinkButton>
                    </div>
                </div>
                <div class="row" id="valuesFromExcel">
                    <div class="col-md-12">
                        <div class="pull-right">
                            <a href="javascript:void(0)" id="valuesFromExcelLink" class="btn btn-default">Upload values from an excel file
                            </a>
                        </div>
                    </div>
                </div>
                <div class="row hidden" id="valuesManually">
                    <div class="col-md-12">
                        <div class="pull-right">
                            <a href="javascript:void(0)" id="valuesManuallyLink" class="btn btn-default">Enter values manually
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="KpiValuesPanel" runat="server" CssClass="container">
        <div class="row">
            <div class="col-md-12">
                <div class="tile">
                    <div class="t-header">
                        <div class="th-title">Kpi Values</div>
                    </div>
                    <div class="t-body tb-padding">
                        <asp:Repeater ID="KpiDataRepeater" runat="server"
                            OnItemCommand="KpisRepeaterData_ItemCommand">
                            <ItemTemplate>
                                <div class="row">
                                    <div class="col-md-1">
                                        <asp:LinkButton ID="EditKpi" data-id='<%# Eval("DateId") %>' data-kpiId='<%# Eval("Kpi.ObjectId") %>' runat="server" CssClass="viewBtn" OnClick="EditKpiData_Click"><i class="zmdi zmdi-edit zmdi-hc-fw"></i></asp:LinkButton>
                                    </div>
                                    <div class="col-md-1">
                                        <asp:LinkButton ID="DeleteKpi" data-id='<%# Eval("DateId") %>' data-kpiId='<%# Eval("Kpi.ObjectId") %>' CommandArgument='<%# Eval("DateId") %>' CommandName="DeleteKpiData" runat="server" CssClass="viewBtn"><i class="zmdi zmdi-minus-circle-outline zmdi-hc-fw"></i></asp:LinkButton>
                                    </div>
                                     <div class="col-md-2">
                                        <p style="font-size: 14px; padding-top: 2px;">
                                            <%# Eval("DateId") %>
                                        </p>
                                    </div>
                                    <div class="col-md-6">
                                        <p style="font-size: 14px; padding-top: 2px;">
                                            <%# Eval("ValueForDisplay") %>
                                        </p>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Panel ID="EmptyMessageContaienr" runat="server" CssClass="row" Visible='<%# KpiDataRepeater.Items.Count == 0 %>'>
                                    <div class="col-md-12 text-center">
                                        -- There are no Kpi values registered. --
                                    </div>
                                </asp:Panel>
                            </FooterTemplate>
                        </asp:Repeater>

                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>
    <asp:HiddenField ID="KpiDataIdHiddenField" runat="server" Value="" />
    <asp:HiddenField ID="KpiIdHiddenField" runat="server" Value="0" />
    <asp:HiddenField ID="ParentPageHiddenField" runat="server" Value="" />
    <script type="text/javascript">
        $(document).ready(function () {
            updateFormByKpiType();
            $('#valuesFromExcelLink').on('click', function () {
                $('#valuesFromExcel').addClass('hidden');
                $('#saveButtonRow').addClass('hidden');
                $('#valueRow').addClass('hidden');
                $('#subirArchivoRow').removeClass('hidden');
                $('#valuesManually').removeClass('hidden');
                $('#importFilePanel').removeClass('hidden');
            });
            $('#valuesManuallyLink').on('click', function () {
                $('#valuesFromExcel').removeClass('hidden');
                $('#saveButtonRow').removeClass('hidden');
                $('#valueRow').removeClass('hidden');
                $('#valuesManually').addClass('hidden');
                $('#importFilePanel').addClass('hidden');
                $('#subirArchivoRow').addClass('hidden');
            });
        });


        function updateFormByKpiType() {
            var type = $('#<%=TypeValueHiddenField.ClientID%>').val();
            $('.targetPanels').hide();
            if (type == "") {
                return;
            }
            //FYI: type = id;unit;direction;strategy
            var vals = type.split(';');
            $('#' + vals[1].toLowerCase() + 'Panel').show();
        }

        function validateTarget(source, arguments) {
            var type = $('#<%=TypeValueHiddenField.ClientID%>').val();
            var vals = type.split(';');
            var selectedUnit = vals[1];
            switch (selectedUnit) {
                case "PERCENTAGE":
                    if ($('#<%=TargetPercentageTextbox.ClientID%>').val() != "") {
                        arguments.IsValid = true;
                    } else {
                        arguments.IsValid = false;
                        source.innerHTML = "Report new Value percentage is required";
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
    </script>
</asp:Content>

