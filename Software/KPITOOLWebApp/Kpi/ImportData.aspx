<%@ Page Title="KPI Data Entry" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" 
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
                <asp:Literal ID="TitleLabel" runat="server" Text="KPI Data Entry" />
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
                        <p><asp:Label ID="KPITypeLabel" runat="server" Text="KPI Type:" Font-Bold="true" /></p>
                    </div>
                    <div class="col-md-10">
                        <p><asp:Label ID="KPIType" runat="server" /></p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">
                        <p><asp:Label ID="ReportingPeriodLabel" runat="server" Text="Reporting Period:" Font-Bold="true" /></p>
                    </div>
                    <div class="col-md-10">
                        <p><asp:Label ID="ReportingPeriod" runat="server" /></p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">
                        <p><asp:Label ID="StartingDateLabel" runat="server" Text="Starting Date:" Font-Bold="true" /></p>
                    </div>
                    <div class="col-md-10">
                        <p><asp:Label ID="StartingDate" runat="server" /></p>
                    </div>
                </div>

                <div id="pnlUploadFile" runat="server" class="p-l-10 p-r-10" style="border: 1px solid #e8e8e8; " visible="false">
                    <div class="row">
                        <div class="col-md-12 m-t-10 m-b-10">
                            <asp:Literal ID="DataDescriptionLabel" runat="server" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <p><asp:Label ID="UploadDataText" runat="server" Text="When values exist for dates specified in the Excel file:" /></p>
                        </div>
                        <div class="col-md-3">
                            <asp:RadioButtonList ID="TypeRadioButtonList" runat="server">
                                <asp:ListItem Text="Replace old value with new one" Value="R" Selected="True" />
                                <asp:ListItem Text="Add new value to the old one" Value="A" />
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-4">
                            <asp:FileUpload ID="FileUpload" runat="server" />
                            <div class="has-error m-b-10">
                                <asp:RequiredFieldValidator ID="FileUploadRequiredValidator" runat="server" Display="Dynamic" 
                                    ControlToValidate="FileUpload" ErrorMessage="You must select a file." ValidationGroup="UploadData" />
                                <asp:Label ID="ValidateFile" runat="server" />
                            </div>
                        </div>
                        <div class="col-md-2">
                            <asp:LinkButton ID="UploadDataButton" runat="server" CssClass="btn btn-primary" ValidationGroup="UploadData" Text="Upload data" OnClick="UploadDataButton_Click" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12" style="text-align: right; ">
                            <p><asp:LinkButton ID="EnterDataButton" runat="server" Text="Enter values manually" OnClick="EnterDataButton_Click" /></p>
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
                                <p><asp:Label ID="UploadDataLabel" runat="server" Text="The following data are going to be registered:" /></p>
                                <div class="table-responsive">
                                    <asp:GridView ID="DataGridView" runat="server" Width="100%" GridLines="None" AutoGenerateColumns="False" 
                                        CssClass="table table-striped table-bordered table-hover" OnRowDataBound="DataGridView_RowDataBound">
                                        <HeaderStyle CssClass="rgHeader head" />
                                        <FooterStyle CssClass="foot" />
                                        <AlternatingRowStyle CssClass="altRow" />
                                        <EmptyDataRowStyle CssClass="gridNoData" />
                                        <Columns>
                                            <asp:BoundField HeaderText="Date" DataField="Date" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-Width="200px" />
                                            <asp:BoundField HeaderText="Category" DataField="Detalle" ItemStyle-Width="300px" />
                                            <asp:TemplateField HeaderText="Value">
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
                                <asp:LinkButton ID="SaveUploadDataButton" runat="server" Text="Save uploaded data" CssClass="btn btn-primary" OnClick="SaveUploadDataButton_Click" />
                                <asp:LinkButton ID="CancelUploadDataButton" runat="server" CausesValidation="False" Text="Cancel" CssClass="btn btn-danger" OnClick="CancelUploadDataButton_Click" />
                            </div>
                        </div>
                    </div>
                </div>
                
                <div id="pnlEnterData" runat="server" class="p-t-15 p-l-10 p-r-10" style="border: 1px solid #e8e8e8; ">
                    <div class="row">
                        <div class="col-md-2 m-t-5">
                            <p><asp:Label ID="ValueDateLabel" runat="server" Text="Value Date:" Font-Bold="true" /></p>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="DateTextBox" runat="server" CssClass="form-control" TextMode="Date" />
                            <div class="has-error m-b-10">
                                <asp:RequiredFieldValidator ID="DateRequiredFieldValidator" runat="server" ControlToValidate="DateTextBox"
                                    Display="Dynamic" ValidationGroup="EnterData" ErrorMessage="You must enter the date." ForeColor="Red">
                                </asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="col-md-7 p-l-0 p-t-5">
                            <span class="label label-danger">Required</span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-2 m-t-5">
                            <p><asp:Label ID="ReportValueLabel" runat="server" Text="Report new value:" Font-Bold="true" /></p>
                        </div>
                        <div class="col-md-10">
                            <asp:Repeater ID="EnterDataRepeater" runat="server" OnItemDataBound="EnterDataRepeater_ItemDataBound">
                                <ItemTemplate>
                                    <div class="row rowData">
                                        <div id="pnlDetalle" runat="server" class="col-md-2 m-t-5">
                                            <asp:Label ID="DetalleLabel" runat="server" Text='<%# Bind("Detalle") %>' />
                                            <asp:HiddenField ID="CategoriesLabel" runat="server" Value='<%# Bind("Categories") %>' />
                                        </div>
                                        <div id="pnlDataDecimal" runat="server" class="col-md-10 p-l-0 p-r-0">
                                            <div class="row">
                                                <div class="col-md-3 p-l-0 p-r-0">
                                                    <asp:TextBox ID="ValueTextBox" runat="server" CssClass="form-control dataText" TextMode="Number" />
                                                </div>
                                                <%--<div class="col-md-7 p-t-5">
                                                    <span class="label label-danger">Required</span>
                                                </div>--%>
                                            </div>
                                            <div class="row">
                                                <div class="has-error m-b-10">
                                                    <asp:Label ID="ValueRequiredFileValidator" runat="server" CssClass="valueErrorLabel" ForeColor="Red" />
                                                </div>
                                            </div>
                                        </div>
                                        <div id="pnlDataTime" runat="server" class="col-md-10 p-l-0 p-r-0">
                                            <div class="row">
                                                <div class="col-md-2 p-l-0">
                                                    <asp:DropDownList runat="server" ID="YearsCombobox" CssClass="form-control m-b-10 comboYear">
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
                                                        <asp:ListItem Text="10 years" Value="10"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                                <div class="col-md-2 p-l-0">
                                                    <asp:DropDownList runat="server" ID="MonthsCombobox" CssClass="form-control m-b-10 comboMonth">
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
                                                    </asp:DropDownList>
                                                </div>
                                                <div class="col-md-2 p-l-0">
                                                    <asp:DropDownList runat="server" ID="DaysCombobox" CssClass="form-control m-b-10 comboDay">
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
                                                <div class="col-md-2 p-l-0">
                                                    <asp:DropDownList runat="server" ID="HoursCombobox" CssClass="form-control m-b-10 comboHour">
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
                                                <div class="col-md-2 p-l-0">
                                                    <asp:DropDownList runat="server" ID="MinutesCombobox" CssClass="form-control m-b-10 comboMinute">
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
                                                <%--<div class="col-md-1 p-l-0 p-r-0 p-t-5">
                                                    <span class="label label-danger">Required</span>
                                                </div>--%>
                                            </div>
                                            <div class="row">
                                                <div class="has-error m-b-10">
                                                    <asp:Label ID="TimeRequiredFileValidator" runat="server" CssClass="timeErrorLabel" ForeColor="Red" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                                <FooterTemplate>
                                    <asp:Label ID="lblEmptyData" runat="server" Visible='<%# ((Repeater)Container.NamingContainer).Items.Count == 0 %>' Text="There are no data to register" />
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
                        <div class="col-md-6 p-t-10 p-b-10">
                            <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary" Text="Insert new value"
                                ValidationGroup="EnterData" OnClientClick="return VerifiyData()" OnClick="SaveButton_Click">
                            </asp:LinkButton>
                        </div>
                        <div class="col-md-6 p-t-10" style="text-align: right; ">
                            <p><asp:LinkButton ID="UploadFileButton" runat="server" Text="Upload values from an Excel file" OnClick="UploadFileButton_Click" /></p>
                        </div>
                    </div>
                </div>

                <div id="pnlMeasurement" runat="server" class="row">
                    <div class="col-md-12 m-t-20">
                        <div class="table-responsive">
                            <asp:GridView ID="KpiMeasurementGridView" runat="server" Width="100%" GridLines="None" AutoGenerateColumns="False" AllowPaging="true" PageSize="10" 
                                CssClass="table table-striped table-bordered table-hover" OnRowDataBound="KpiMeasurementGridView_RowDataBound" OnRowCommand="KpiMeasurementGridView_RowCommand" 
                                OnPageIndexChanging="KpiMeasurementGridView_PageIndexChanging">
                                <HeaderStyle CssClass="rgHeader head" />
                                <FooterStyle CssClass="foot" />
                                <AlternatingRowStyle CssClass="altRow" />
                                <EmptyDataRowStyle CssClass="gridNoData" />
                                <PagerStyle CssClass="gridPager" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Delete" ItemStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="DeleteButton" runat="server" Text="<i class='fa fa-minus-circle'></i>" CommandName="DeleteData" ToolTip="Delete" 
                                                CssClass="text-danger" CommandArgument='<%# Eval("MeasurementID") %>' OnClientClick="return confirm('¿Are you sure to delete the measurement?')" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="Date" DataField="Date" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-Width="200px" />
                                    <asp:BoundField HeaderText="Category" DataField="Detalle" ItemStyle-Width="300px" />
                                    <asp:TemplateField HeaderText="Value">
                                        <ItemTemplate>
                                            <asp:Label ID="ValueLabel" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <p class="text-center">There are no measurements registered for this KPI</p>
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
                <asp:HyperLink ID="ReturnLink" runat="server" NavigateUrl="~/Kpi/KpiList.aspx" Text="Back to KPI list"
                    CssClass="btn btn-info">
                </asp:HyperLink>
            </div>
        </div>
    </div>

    <script type="text/javascript">
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
                        $("#<%= RequiredFieldValidatorLabel.ClientID %>").text("You must select a time for at least one item.");
                        dataOK = false;
                    } else {
                        $("#<%= RequiredFieldValidatorLabel.ClientID %>").text("");
                    }

                } else {
                    var regexInt = new RegExp('^[0-9]{1,21}$');
                    var regexDecimal = new RegExp('^[0-9]{1,17}([\.\,][0-9]{1,3})*$');

                    $(".rowData").each(function () {
                        var value = $(this).find('input.dataText').val();
                        if (value != "") {
                            if ($("#<%= UnitIdHiddenField.ClientID %>").val() == "INT" && !regexInt.test(value)) {
                                $(this).find('span.valueErrorLabel').text("The value must be integer.");
                                dataOK = false;
                                noData = false;

                            } else if ($("#<%= UnitIdHiddenField.ClientID %>").val() != "TIME" && $("#<%= UnitIdHiddenField.ClientID %>").val() != "INT" && !regexDecimal.test(value)) {
                                $(this).find('span.valueErrorLabel').text("The value must be decimal with point as separator.");
                                dataOK = false;
                                noData = false;

                            } else {
                                $(this).find('span.valueErrorLabel').text("");
                            }
                            noData = false;
                        }
                    });

                    if (noData) {
                        $("#<%= RequiredFieldValidatorLabel.ClientID %>").text("You must enter a value for at least one item.");
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

