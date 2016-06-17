<%@ Control Language="C#" AutoEventWireup="true" CodeFile="KpiMeasurements.ascx.cs" Inherits="UserControls_KPI_KpiSummary_KpiMeasurements" %>
<div class="table-responsive" style="max-height: 200px;">
    <asp:GridView ID="MeasurementsGridView" runat="server"
        DataSourceID="MeasurementsDataSource"
        OnDataBound="MeasurementsGridView_DataBound"
        CssClass="table table-striped"
        GridLines="None"
        AutoGenerateColumns="false">
        <Columns>
            <asp:BoundField DataField="DateForDisplay" HeaderText="Date" />
            <asp:BoundField DataField="Measurement" HeaderText="Value" />
        </Columns>
    </asp:GridView>
    <asp:HiddenField ID="KpiIdHiddenField" runat="server" Value="0" />
    <asp:HiddenField ID="CategoryIdHiddenField" runat="server" Value="" />
    <asp:HiddenField ID="CategoryItemIdHiddenField" runat="server" Value="" />
    <asp:ObjectDataSource ID="MeasurementsDataSource" runat="server"
        TypeName="Artexacta.App.KPI.BLL.KpiMeasurementBLL"
        SelectMethod="GetKpiMeasurementsByKpiId">
        <SelectParameters>
            <asp:ControlParameter ControlID="KpiIdHiddenField" Name="kpiId" PropertyName="Value" Type="Int32" />
            <asp:ControlParameter ControlID="CategoryIdHiddenField" Name="categoryId" PropertyName="Value" Type="String" />
            <asp:ControlParameter ControlID="CategoryItemIdHiddenField" Name="categoryItemId" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
</div>