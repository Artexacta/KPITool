<%@ Control Language="C#" AutoEventWireup="true" CodeFile="KpiStats.ascx.cs" Inherits="UserControls_KPI_KpiSummary_KpiStats" %>
<p id="progressContainer" runat="server">
    <asp:Literal ID="ProgressLiteral" runat="server"></asp:Literal>
    <asp:Literal runat="server" Text="<%$ Resources: KpiStats, ProgressLabel %>"></asp:Literal>
</p>
<p>
    <asp:Label ID="IconLabel" runat="server" Font-Size="18px">
    </asp:Label>
    <asp:Literal ID="TrendLiteral" runat="server"></asp:Literal> 
    <asp:Literal ID="TrendPercentageLiteral" runat="server"></asp:Literal>
    <asp:Literal runat="server" Text="<%$ Resources: KpiStats, FromLastLabel %>"></asp:Literal>
    <asp:Literal ID="PeriodLiteral" runat="server"></asp:Literal>
</p>
<p>
    <asp:Literal runat="server" Text="<%$ Resources: KpiStats, LowestValue %>"></asp:Literal>    
    : 
    <asp:Literal ID="LowestValueLiteral" runat="server"></asp:Literal>
</p>
<p>
    <asp:Literal runat="server" Text="<%$ Resources: KpiStats, HighestValue %>"></asp:Literal>    
    : 
    <asp:Literal ID="HighestValueLiteral" runat="server"></asp:Literal>
</p>
<p>
    <asp:Literal runat="server" Text="<%$ Resources: KpiStats, CurrentValue %>"></asp:Literal>    
    : 
    <asp:Literal ID="CurrentValueLiteral" runat="server"></asp:Literal>
</p>
<p>
    <asp:Literal runat="server" Text="<%$ Resources: KpiStats, AverageLabel %>"></asp:Literal>    
    : 
    <asp:Literal ID="AverageLiteral" runat="server"></asp:Literal>
</p>
<asp:HiddenField ID="KpiIdHiddenField" runat="server" Value="0" />
<asp:HiddenField ID="CategoryIdHiddenField" runat="server" Value="" />
<asp:HiddenField ID="CategoryItemIdHiddenField" runat="server" Value="" />