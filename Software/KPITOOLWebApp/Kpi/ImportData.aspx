<%@ Page Title="<%$ Resources:ImportData, PageTitle %>" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" 
    CodeFile="ImportData.aspx.cs" Inherits="Kpi_ImportData" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" Runat="Server">
    <div class="row">
        <div class="col-md-1">
            <div class="page-header">
                <app:AddButton ID="TheAddButton" runat="server" />
            </div>
        </div>
        <div class="col-md-11">
            <h1 class="text-center">
                <asp:Literal ID="TitleLabel" runat="server" Text="<%$ Resources:ImportData, PageTitle %>" />
            </h1>
        </div>
    </div>
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <h3>
                    <asp:Literal ID="SubtitleLabel" runat="server" />
                </h3>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="tile">
            <div class="t-header">
            </div>
            <div class="t-body tb-padding" style="padding-top: 0; ">
                <div class="row">
                    <div class="col-md-2">
                        <p><asp:Label ID="KPITypeLabel" runat="server" Text="<%$ Resources:ImportData, KPITypeLabel %>" Font-Bold="true" /></p>
                    </div>
                    <div class="col-md-10">
                        <p><asp:Label ID="KPIType" runat="server" /></p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">
                        <p><asp:Label ID="ReportingPeriodLabel" runat="server" Text="<%$ Resources:ImportData, ReportingPeriodLabel %>" Font-Bold="true" /></p>
                    </div>
                    <div class="col-md-10">
                        <p><asp:Label ID="ReportingPeriod" runat="server" /></p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">
                        <p><asp:Label ID="StartingDateLabel" runat="server" Text="<%$ Resources:ImportData, StartingDateLabel %>" Font-Bold="true" /></p>
                    </div>
                    <div class="col-md-10">
                        <p><asp:Label ID="StartingDate" runat="server" /></p>
                    </div>
                </div>

                <div id="pnlUploadFile" runat="server" class="p-l-10 p-r-10" style="border: 1px solid #e8e8e8; ">
                    <div class="row">
                        <div class="col-md-12 m-t-10 m-b-10">
                            <asp:Literal ID="DataDescriptionLabel" runat="server" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-2">
                            <p><asp:Label ID="UploadDataText" runat="server" Text="<%$ Resources:ImportData, UploadDataText %>" /></p>
                        </div>
                        <div class="col-md-4">
                            <asp:RadioButtonList ID="TypeRadioButtonList" runat="server">
                                <asp:ListItem Text="<%$ Resources:ImportData, TypeUploadItemReplace %>" Value="R" Selected="True" />
                                <asp:ListItem Text="<%$ Resources:ImportData, TypeUploadItemAdd %>" Value="A" />
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-4">
                            <asp:FileUpload ID="FileUpload" runat="server" />
                            <div class="has-error m-b-10">
                                <asp:RequiredFieldValidator ID="FileUploadRequiredValidator" runat="server" Display="Dynamic" 
                                    ControlToValidate="FileUpload" ErrorMessage="<%$ Resources:ImportData, FileUploadRequired %>" ValidationGroup="UploadData" />
                                <asp:Label ID="ValidateFile" runat="server" />
                            </div>
                        </div>
                        <div class="col-md-2">
                            <asp:LinkButton ID="UploadDataButton" runat="server" CssClass="btn btn-primary" ValidationGroup="UploadData" Text="<%$ Resources:ImportData, UploadDataButton %>" OnClick="UploadDataButton_Click" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12" style="text-align: right; ">
                            <p><asp:LinkButton ID="EnterDataButton" runat="server" Text="<%$ Resources:ImportData, EnterDataButton %>" OnClick="EnterDataButton_Click" /></p>
                        </div>
                    </div>
                    <div id="pnlErrorData" runat="server" visible="false" class="row p-t-10 p-b-10 m-l-0 m-r-0">
                        <div class="col-md-12">
                            <asp:Label ID="ErrorFileLabel" runat="server" CssClass="fieldLabel" />
                            <br />
                            <ul>
                                <asp:Repeater ID="ErrorFileRepeater" runat="server">
                                    <ItemTemplate>
                                        <li><asp:Label ID="TextLabel" runat="server" Text="<%# this.GetDataItem().ToString() %>" CssClass="fieldLabel" /></li>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </ul>
                        </div>
                    </div>

                    <div id="pnlData" runat="server" visible="false" class="p-t-10 p-b-10 m-l-0 m-r-0">
                        <div class="row">
                            <div class="col-md-12">
                                <p><asp:Label ID="UploadDataLabel" runat="server" Text="<%$ Resources:ImportData, UploadDataLabel %>" /></p>
                                <div class="table-responsive">
                                    <asp:GridView ID="DataGridView" runat="server" Width="100%" GridLines="None" AutoGenerateColumns="False" 
                                        CssClass="table table-striped table-bordered table-hover" OnRowDataBound="DataGridView_RowDataBound">
                                        <HeaderStyle CssClass="rgHeader head" />
                                        <FooterStyle CssClass="foot" />
                                        <AlternatingRowStyle CssClass="altRow" />
                                        <EmptyDataRowStyle CssClass="gridNoData" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="<%$ Resources:ImportData, DateColumn %>">
                                                <ItemTemplate>
                                                    <asp:Label ID="DateLabel" runat="server" Text='<%# Eval("DateForDisplay") %>' />
                                                    <span class="p-t-5 p-l-5 text-warning">
                                                        <asp:Label ID="ImageUpdate" runat="server" Text="<i class='fa fa-warning'></i>" ToolTip="<%$ Resources:ImportData, ImageAlert %>" />
                                                    </span>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField HeaderText="<%$ Resources:ImportData, CategoryColumn %>" DataField="Detalle" ItemStyle-Width="300px" />
                                            <asp:TemplateField HeaderText="<%$ Resources:ImportData, ValueColumn %>">
                                                <ItemTemplate>
                                                    <asp:Label ID="ValueLabel" runat="server" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 m-t-20">
                                <asp:LinkButton ID="SaveUploadDataButton" runat="server" Text="<%$ Resources:ImportData, SaveUploadDataButton %>" 
                                    CssClass="btn btn-primary" OnClick="SaveUploadDataButton_Click" />
                                <asp:LinkButton ID="CancelUploadDataButton" runat="server" CausesValidation="False" Text="<%$ Resources:ImportData, CancelButton %>" 
                                    CssClass="btn btn-danger" OnClick="CancelUploadDataButton_Click" />
                            </div>
                        </div>
                    </div>
                </div>
                
                <div id="pnlEnterData" runat="server" class="p-t-15 p-l-10 p-r-10" style="border: 1px solid #e8e8e8; " visible="false">
                    <div class="row">
                        <div class="col-md-2 m-t-5">
                            <p><asp:Label ID="ValueDateLabel" runat="server" Text="<%$ Resources:ImportData, ValueDateLabel %>" Font-Bold="true" /></p>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="DateTextBox" runat="server" CssClass="form-control" TextMode="Date" data-polyfill="desktop" />
                            <div class="has-error m-b-10">
                                <asp:RequiredFieldValidator ID="DateRequiredFieldValidator" runat="server" ControlToValidate="DateTextBox"
                                    Display="Dynamic" ValidationGroup="EnterData" ErrorMessage="<%$ Resources:ImportData, RequiereDateValue %>" ForeColor="Red">
                                </asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="col-md-7 p-l-0 p-t-5">
                            <span class="label label-danger"><asp:Literal ID="RequiredLabel" runat="server" Text="<%$ Resources:ImportData, RequiredLabel %>" /></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-2 m-t-5">
                            <p><asp:Label ID="ReportValueLabel" runat="server" Text="<%$ Resources:ImportData, ReportValueLabel %>" Font-Bold="true" /></p>
                        </div>
                        <div class="col-md-10">
                            <asp:Repeater ID="EnterDataRepeater" runat="server" OnItemDataBound="EnterDataRepeater_ItemDataBound">
                                <ItemTemplate>
                                    <div class="row rowData">
                                        <div id="pnlDetalle" runat="server" class="col-md-2 m-t-5">
                                            <asp:Label ID="DetalleLabel" runat="server" Text='<%# Bind("ItemsList") %>' CssClass="dataDetalle" />
                                            <asp:HiddenField ID="CategoriesLabel" runat="server" Value='<%# Bind("CategoriesList") %>' />
                                        </div>
                                        <div id="pnlDataDecimal" runat="server" class="col-md-10">
                                            <div class="row">
                                                <div class="col-md-3">
                                                    <asp:TextBox ID="ValueTextBox" runat="server" CssClass="form-control dataText" TextMode="Number" />
                                                </div>
                                                <div class="p-t-5 text-warning">
                                                    <asp:Label ID="ImageUpdate" runat="server" Text="<i class='fa fa-warning'></i>" CssClass="imageUpdate" 
                                                        style="display: none; " ToolTip="<%$ Resources:ImportData, ImageAlert %>" />
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-8 has-error m-b-10">
                                                    <asp:Label ID="ValueRequiredFileValidator" runat="server" CssClass="valueErrorLabel" ForeColor="Red" />
                                                </div>
                                            </div>
                                        </div>
                                        <div id="pnlDataTime" runat="server" class="col-md-10 p-l-0 p-r-0">
                                            <div class="row">
                                                <div class="col-md-2 p-l-0">
                                                    <asp:DropDownList runat="server" ID="YearsCombobox" CssClass="form-control m-b-10 comboYear" 
                                                        DataSourceID="YearsObjectDataSource" DataTextField="Value" DataValueField="Id">
                                                    </asp:DropDownList>
                                                </div>
                                                <div class="col-md-2 p-l-0">
                                                    <asp:DropDownList runat="server" ID="MonthsCombobox" CssClass="form-control m-b-10 comboMonth" 
                                                        DataSourceID="MonthsObjectDataSource" DataTextField="Value" DataValueField="Id">
                                                    </asp:DropDownList>
                                                </div>
                                                <div class="col-md-2 p-l-0">
                                                    <asp:DropDownList runat="server" ID="DaysCombobox" CssClass="form-control m-b-10 comboDay" 
                                                        DataSourceID="DaysObjectDataSource" DataTextField="Value" DataValueField="Id">
                                                    </asp:DropDownList>
                                                </div>
                                                <div class="col-md-2 p-l-0">
                                                    <asp:DropDownList runat="server" ID="HoursCombobox" CssClass="form-control m-b-10 comboHour" 
                                                        DataSourceID="HoursObjectDataSource" DataTextField="Value" DataValueField="Id">
                                                    </asp:DropDownList>
                                                </div>
                                                <div class="col-md-2 p-l-0">
                                                    <asp:DropDownList runat="server" ID="MinutesCombobox" CssClass="form-control m-b-10 comboMinute" 
                                                        DataSourceID="MinutesObjectDataSource" DataTextField="Value" DataValueField="Id">
                                                    </asp:DropDownList>
                                                </div>
                                                <div class="p-t-5 text-warning">
                                                    <asp:Label ID="ImageTimeUpdate" runat="server" Text="<i class='fa fa-warning'></i>" CssClass="imageTimeUpdate" 
                                                        style="display: none; " ToolTip="<%$ Resources:ImportData, ImageAlert %>" />
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="has-error m-b-10">
                                                    <asp:Label ID="TimeRequiredFileValidator" runat="server" CssClass="timeErrorLabel" ForeColor="Red" />
                                                </div>
                                            </div>

                                            <asp:ObjectDataSource ID="YearsObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" 
                                                SelectMethod="GetYears" TypeName="Artexacta.App.Utilities.DataTime.DataTimeUtilities">
                                            </asp:ObjectDataSource>
                                            <asp:ObjectDataSource ID="MonthsObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" 
                                                SelectMethod="GetMonths" TypeName="Artexacta.App.Utilities.DataTime.DataTimeUtilities">
                                            </asp:ObjectDataSource>
                                            <asp:ObjectDataSource ID="DaysObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" 
                                                SelectMethod="GetDays" TypeName="Artexacta.App.Utilities.DataTime.DataTimeUtilities">
                                            </asp:ObjectDataSource>
                                            <asp:ObjectDataSource ID="HoursObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" 
                                                SelectMethod="GetHours" TypeName="Artexacta.App.Utilities.DataTime.DataTimeUtilities">
                                            </asp:ObjectDataSource>
                                            <asp:ObjectDataSource ID="MinutesObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" 
                                                SelectMethod="GetMinutes" TypeName="Artexacta.App.Utilities.DataTime.DataTimeUtilities">
                                            </asp:ObjectDataSource>
                                        </div>
                                        <asp:HiddenField ID="MeasurementIDsHiddenField" runat="server" />
                                    </div>
                                </ItemTemplate>
                                <FooterTemplate>
                                    <asp:Label ID="lblEmptyData" runat="server" Visible='<%# ((Repeater)Container.NamingContainer).Items.Count == 0 %>' Text="<%$ Resources:ImportData, lblEmptyData %>" />
                                </FooterTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="has-error m-b-10">
                                <asp:Label ID="RequiredFieldValidatorLabel" runat="server" ForeColor="Red" />
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-2">
                            <p><asp:Label ID="EnterDataText" runat="server" Text="<%$ Resources:ImportData, EnterDataText %>" Font-Bold="true" /></p>
                        </div>
                        <div class="col-md-10">
                            <asp:RadioButtonList ID="TypeRadioButtonList1" runat="server">
                                <asp:ListItem Text="<%$ Resources:ImportData, TypeUploadItemReplace %>" Value="R" Selected="True" />
                                <asp:ListItem Text="<%$ Resources:ImportData, TypeUploadItemAdd %>" Value="A" />
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 p-t-10 p-b-10">
                            <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary" Text="<%$ Resources:ImportData, SaveButton %>"
                                ValidationGroup="EnterData" OnClientClick="return VerifiyData()" OnClick="SaveButton_Click">
                            </asp:LinkButton>
                        </div>
                        <div class="col-md-6 p-t-10" style="text-align: right; ">
                            <p><asp:LinkButton ID="UploadFileButton" runat="server" Text="<%$ Resources:ImportData, UploadFileButton %>" OnClick="UploadFileButton_Click" /></p>
                        </div>
                    </div>
                </div>

                <div id="pnlMeasurement" runat="server" class="row">
                    <div class="col-md-12 m-t-20">
                        <div class="table-responsive">
                            <asp:GridView ID="KpiMeasurementGridView" runat="server" Width="100%" GridLines="None" AutoGenerateColumns="False" AllowPaging="true" PageSize="10" 
                                PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="5" CssClass="table table-striped table-bordered table-hover" 
                                OnRowDataBound="KpiMeasurementGridView_RowDataBound" OnRowCommand="KpiMeasurementGridView_RowCommand" 
                                OnPageIndexChanging="KpiMeasurementGridView_PageIndexChanging">
                                <HeaderStyle CssClass="rgHeader head" />
                                <FooterStyle CssClass="foot" />
                                <AlternatingRowStyle CssClass="altRow" />
                                <EmptyDataRowStyle CssClass="gridNoData" />
                                <PagerStyle CssClass="gridPager" />
                                <Columns>
                                    <asp:TemplateField HeaderText="<%$ Resources:ImportData, DeleteColumn %>" ItemStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="DeleteButton" runat="server" Text="<i class='fa fa-minus-circle'></i>" CommandName="DeleteData" ToolTip="Delete" 
                                                CssClass="text-danger" CommandArgument='<%# Eval("MeasurementID") %>' OnClientClick="<%$ Resources:ImportData, ConfirmDeleteMeasurement %>" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="<%$ Resources:ImportData, DateColumn %>" DataField="DateForDisplay" ItemStyle-Width="200px" />
                                    <asp:BoundField HeaderText="<%$ Resources:ImportData, CategoryColumn %>" DataField="Detalle" ItemStyle-Width="300px" />
                                    <asp:TemplateField HeaderText="<%$ Resources:ImportData, ValueColumn %>">
                                        <ItemTemplate>
                                            <asp:Label ID="ValueLabel" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <p class="text-center"><asp:Literal ID="NoDataRows" runat="server" Text="<%$ Resources:ImportData, NoDataRows %>" /></p>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <asp:HyperLink ID="ReturnLink" runat="server" NavigateUrl="~/Kpi/KpiList.aspx" Text="<%$ Resources:ImportData, ReturnLink %>"
                    CssClass="btn btn-info">
                </asp:HyperLink>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function ValueTextBox_OnChange(valueTextBox, measurementIDsHiddenField, valueRequiredFileValidator, imageUpdate, detalle, categories) {
            var value = $("#" + valueTextBox).val();
            if (value != "") {
                var regexInt = new RegExp('^[0-9]{1,21}$');
                var regexDecimal = new RegExp('^[0-9]{1,17}([\.\,][0-9]{1,3})*$');
                var regexPercent = new RegExp('^([1-9]{1,2}([\.\,][0-9]{1,3})*|10|20|30|40|50|60|70|80|90|100)$');

                if ($("#<%= UnitIdHiddenField.ClientID %>").val() == "INT" && !regexInt.test(value)) {
                    $("#" + valueRequiredFileValidator).text(<%= Resources.ImportData.ValueRequireIntegerData %>);

                } else if ($("#<%= UnitIdHiddenField.ClientID %>").val() == "PERCENT" && !regexPercent.test(value)) {
                    $("#" + valueRequiredFileValidator).text(<%= Resources.ImportData.ValueRequirePercentData %>);

                } else if (($("#<%= UnitIdHiddenField.ClientID %>").val() == "DECIMAL" || $("#<%= UnitIdHiddenField.ClientID %>").val() == "MONEY") && !regexDecimal.test(value)) {
                    $("#" + valueRequiredFileValidator).text(<%= Resources.ImportData.ValueRequireDecimalData %>);

                } else {
                    $("#" + valueRequiredFileValidator).text("");
                    var date = $("#<%= DateTextBox.ClientID %>").val();

                    if (date != "") {
                        var param = JSON.stringify({ 'kpiId': $("#<%= KPIIdHiddenField.ClientID %>").val(), 'date': date, 'detalle': detalle, 'categories': categories });
                        var data;
                        $.ajax({
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            url: "ImportData.aspx/VerifiyData",
                            data: param,
                            dataType: "json",
                            async: false,
                            success: function (msg) {
                                data = msg.d;
                            },
                            error: function (XMLHttpRequest, textStatus, errorThrown) {
                                alert(textStatus + ": " + jQuery.parseJSON(XMLHttpRequest.responseText).Message);
                            },
                            failure: function () {
                                alert(<%= Resources.ImportData.VerifiyDataFail %>);
                            }
                        });

                        if (data != "") {
                            $("#" + measurementIDsHiddenField).val(data);
                            $("#" + imageUpdate).show();
                        }
                    } else {
                        $("#" + valueRequiredFileValidator).text("");
                        $("#" + measurementIDsHiddenField).val("");
                        $("#" + imageUpdate).hide();
                    }
                }
            } else {
                $("#" + valueRequiredFileValidator).text("");
                $("#" + measurementIDsHiddenField).val("");
                $("#" + imageUpdate).hide();
            }
        }

        function TimeComboBox_OnChange(yearsCombobox, monthsCombobox, daysCombobox, hoursCombobox, minutesCombobox, measurementIDsHiddenField,
            imageTimeUpdate, detalle, categories) {
            var year = $("#" + yearsCombobox).val();
            var month = $("#" + monthsCombobox).val();
            var day = $("#" + daysCombobox).val();
            var hour = $("#" + hoursCombobox).val();
            var minute = $("#" + minutesCombobox).val();

            if (year + month + day + hour + minute > 0) {
                var date = $("#<%= DateTextBox.ClientID %>").val();

                if (date != "") {
                    var param = JSON.stringify({ 'kpiId': $("#<%= KPIIdHiddenField.ClientID %>").val(), 'date': date, 'detalle': detalle, 'categories': categories });
                    var data;
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "ImportData.aspx/VerifiyData",
                        data: param,
                        dataType: "json",
                        async: false,
                        success: function (msg) {
                            data = msg.d;
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                            alert(textStatus + ": " + jQuery.parseJSON(XMLHttpRequest.responseText).Message);
                        },
                        failure: function () {
                            alert(<%= Resources.ImportData.VerifiyDataFail %>);
                        }
                    });

                    if (data != "") {
                        $("#" + measurementIDsHiddenField).val(data);
                        $("#" + imageTimeUpdate).show();
                    }
                } else {
                    $("#" + measurementIDsHiddenField).val("");
                    $("#" + imageTimeUpdate).hide();
                }
            } else {
                $("#" + measurementIDsHiddenField).val("");
                $("#" + imageTimeUpdate).hide();
            }
        }

        function DateTextBox_OnChange() {
            if ($("#<%= UnitIdHiddenField.ClientID %>").val() == "TIME") {
                $(".rowData").each(function () {
                    $(this).find('select.comboYear')[0].selectedIndex = 0;
                    $(this).find('select.comboMonth')[0].selectedIndex = 0;
                    $(this).find('select.comboDay')[0].selectedIndex = 0;
                    $(this).find('select.comboHour')[0].selectedIndex = 0;
                    $(this).find('select.comboMinute')[0].selectedIndex = 0;
                    $(this).find('span.imageTimeUpdate').hide();
                });
            } else {
                $(".rowData").each(function () {
                    $(this).find('input.dataText').val("");
                    $(this).find('span.imageUpdate').hide();
                });
            }
        }

        function VerifiyData() {
            if (Page_ClientValidate("EnterData")) {
                var dataOK = true;
                var noData = true;
                if ($("#<%= UnitIdHiddenField.ClientID %>").val() == "TIME") {
                    $(".rowData").each(function () {
                        var year = $(this).find('select.comboYear').val();
                        var month = $(this).find('select.comboMonth').val();
                        var day = $(this).find('select.comboDay').val();
                        var hour = $(this).find('select.comboHour').val();
                        var minute = $(this).find('select.comboMinute').val();

                        if (year + month + day + hour + minute > 0) {
                            noData = false;
                        }
                    });

                    if (noData) {
                        $("#<%= RequiredFieldValidatorLabel.ClientID %>").text(<%= Resources.ImportData.RequiereTimeSelected %>);
                        dataOK = false;
                    } else {
                        $("#<%= RequiredFieldValidatorLabel.ClientID %>").text("");
                    }

                } else {
                    $(".rowData").each(function () {
                        var value = $(this).find('input.dataText').val();
                        if (value != "") {
                            noData = false;
                            if ($(this).find('span.valueErrorLabel').text() != "") {
                                dataOK = false;
                            }
                        }
                    });

                    if (noData) {
                        $("#<%= RequiredFieldValidatorLabel.ClientID %>").text(<%= Resources.ImportData.RequireValueEntered %>);
                        dataOK = false;
                    } else {
                        $("#<%= RequiredFieldValidatorLabel.ClientID %>").text("");
                    }
                }

                return dataOK;

            } else {
                return false;
            }
        }
    </script>

    <asp:HiddenField ID="KPIIdHiddenField" runat="server" />
    <asp:HiddenField ID="UnitIdHiddenField" runat="server" />

</asp:Content>

