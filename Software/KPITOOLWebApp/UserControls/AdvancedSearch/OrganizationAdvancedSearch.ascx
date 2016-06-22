<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrganizationAdvancedSearch.ascx.cs" Inherits="UserControls_AdvancedSearch_OrganizationAdvancedSearch" %>

<%@ Register Src="~/UserControls/SearchUserControl/SC_OrganizationSearchItem.ascx" TagName="SC_OrganizationSearchItem" TagPrefix="uc1" %>

<div>

    <uc1:SC_OrganizationSearchItem ID="OrganizationSearch" runat="server"
        ShowAndOrButtons="true"
        SearchColumnKey="organizationID"
        Title="<% $Resources: Organization, TitleOrganization %>" />


</div>
