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
                <div class="row">
                    <div class="col-md-12 m-t-10 m-b-10">
                        <p>To load values from an Excel file you must have at least two columns int the Excel file named "Date" and "Value". If the values are a time span they must be in ISO 8601 format: durations are represented by the format P[n]Y[n]M[n]DT[n]H[n]M[n]S. In these representations the [n] is replaced by the value for each date and time elements that follow the [n]. Leading zeros are not required.<br />
                            For example: P1Y2M10TD2H30M11S (1 year, 2 months, 10 days, 2 horas, 30 minutos and 11 seconds).
                        </p>
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
                    <div class="col-md-12">
                        <div class="form-group">
                            <asp:LinkButton ID="RegisterDataButton" runat="server" Text="Enter values manually" />
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

    <asp:HiddenField ID="KPIIdHiddenField" runat="server" />

</asp:Content>

