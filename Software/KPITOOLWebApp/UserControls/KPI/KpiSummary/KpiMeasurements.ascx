<%@ Control Language="C#" AutoEventWireup="true" CodeFile="KpiMeasurements.ascx.cs" Inherits="UserControls_KPI_KpiSummary_KpiMeasurements" %>
<div class="table-responsive" style="max-height: 200px;">
    <asp:GridView ID="MeasurementsGridView" runat="server"
        DataSourceID="MeasurementsDataSource"
        OnDataBound="MeasurementsGridView_DataBound"
        CssClass="table table-striped"
        GridLines="None"
        AutoGenerateColumns="false">
        <Columns>
            <asp:BoundField DataField="DateForDisplay" HeaderText="<%$ Resources: KpiDetails,DateLabel %>" />
            <asp:BoundField DataField="MeasurementForDisplay" HeaderText="<%$ Resources: KpiDetails,ValueLabel %>" />
        </Columns>
        <EmptyDataTemplate>
            <p class="text-center">
                <asp:Literal runat="server" Text="<%$ Resources: KpiDetails,MeasurementsEmptyMessage %>"></asp:Literal>
            </p>
        </EmptyDataTemplate>
    </asp:GridView>
    <asp:HiddenField ID="KpiIdHiddenField" runat="server" Value="0" />
    <asp:HiddenField ID="CategoryIdHiddenField" runat="server" Value="" />
    <asp:HiddenField ID="CategoryItemIdHiddenField" runat="server" Value="" />
    <asp:HiddenField ID="UnitHiddenField" runat="server" Value="" />
    <asp:ObjectDataSource ID="MeasurementsDataSource" runat="server"
        TypeName="Artexacta.App.KPI.BLL.KpiMeasurementBLL"
        SelectMethod="GetKpiMeasurementsByKpiId"
        OnSelected="MeasurementsDataSource_Selected">
        <SelectParameters>
            <asp:ControlParameter ControlID="KpiIdHiddenField" Name="kpiId" PropertyName="Value" Type="Int32" />
            <asp:ControlParameter ControlID="CategoryIdHiddenField" Name="categoryId" PropertyName="Value" Type="String" />
            <asp:ControlParameter ControlID="CategoryItemIdHiddenField" Name="categoryItemId" PropertyName="Value" Type="String" />
            <asp:ControlParameter ControlID="UnitHiddenField" Name="unit" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
</div>