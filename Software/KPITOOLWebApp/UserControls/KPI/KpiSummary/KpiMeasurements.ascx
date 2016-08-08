<%@ Control Language="C#" AutoEventWireup="true" CodeFile="KpiMeasurements.ascx.cs" Inherits="UserControls_KPI_KpiSummary_KpiMeasurements" %>
<div class="table-responsive" style="max-height: 200px;">
    <asp:GridView ID="MeasurementsGridView" runat="server" AutoGenerateColumns="false" CssClass="table table-striped" GridLines="None" 
        OnRowDataBound="MeasurementsGridView_RowDataBound">
        <Columns>
            <asp:BoundField DataField="DateForDisplay" HeaderText="<%$ Resources: KpiDetails,DateLabel %>" />
            <asp:BoundField DataField="Detalle" HeaderText="<%$ Resources:ImportData, CategoryColumn %>" />
            <asp:TemplateField HeaderText="<%$ Resources: KpiDetails,ValueLabel %>">
                <ItemTemplate>
                    <asp:Label ID="ValueLabel" runat="server" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>
            <p class="text-center"><asp:Literal runat="server" Text="<%$ Resources: KpiDetails,MeasurementsEmptyMessage %>"></asp:Literal></p>
        </EmptyDataTemplate>
    </asp:GridView>

    <asp:HiddenField ID="KpiIdHiddenField" runat="server" Value="0" />
    <asp:HiddenField ID="CategoryIdHiddenField" runat="server" Value="" />
    <asp:HiddenField ID="CategoryItemIdHiddenField" runat="server" Value="" />
    <asp:HiddenField ID="UnitHiddenField" runat="server" Value="" />
    <asp:HiddenField ID="CurrencyHiddenField" runat="server" />
    <asp:HiddenField ID="CurrencyUnitHiddenField" runat="server" />
</div>