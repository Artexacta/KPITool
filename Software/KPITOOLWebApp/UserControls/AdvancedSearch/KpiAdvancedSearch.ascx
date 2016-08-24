<%@ Control Language="C#" AutoEventWireup="true" CodeFile="KpiAdvancedSearch.ascx.cs" Inherits="UserControls_AdvancedSearch_KpiAdvancedSearch" %>
<%@ Register Src="../SearchUserControl/SC_TextSearchItem.ascx" TagName="SC_TextSearchItem" TagPrefix="uc1" %>
<%@ Register Src="../SearchUserControl/SC_KpiSearchItem.ascx" TagName="SC_KpiSearchItem" TagPrefix="uc3" %>

<div style="width: 400px">
    <div>
        <uc3:SC_KpiSearchItem ID="SC_KpiSearchItem1" runat="server" />
    </div>
    <div style="clear: both">

       <%-- <uc1:SC_TextSearchItem ID="SC_TextSearchItem1"
            runat="server"
            Title="<% $Resources: Activity, LabelName %>"
            SearchColumnKey="name"
            ShowAndOrButtons="true" />--%>

    </div>
</div>
