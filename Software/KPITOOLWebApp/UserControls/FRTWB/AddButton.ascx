<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AddButton.ascx.cs" Inherits="UserControls_FRTWB_AddButton" %>
<div class="dropdown">
    <a id="<%= ClientID %>" href="javascript:openOrganizationModal();" style="font-size: 45px; text-decoration: none; color: #000000"><i id="addIcon" runat="server" class="zmdi zmdi-plus-circle-o zmdi-hc-fw"></i></a>
    <ul class="dropdown-menu pull-left add-menu">
        <li role="presentation">
            <a role="menuitem" tabindex="-1" href="#" onclick="return openAddOrganizationModal()" accesskey="O">
                Add Organization 
                <kbd style="margin-left: 20px"><kbd>ALT</kbd> <span class="shift-cmd">+ <kbd>SHIFT</kbd></span> + <kbd>O</kbd></kbd>
            </a>
        </li>
        <li role="presentation">
            <asp:LinkButton ID="ProjectButton" runat="server" role="menuitem" TabIndex="-1" OnClick="ProjectButton_Click" AccessKey="P">
                Add Project
                <kbd style="margin-left: 53px"><kbd>ALT</kbd> <span class="shift-cmd">+ <kbd>SHIFT</kbd></span> + <kbd>P</kbd></kbd>
            </asp:LinkButton>
        </li>
        <li role="presentation">
            <asp:LinkButton ID="ActivityButton" runat="server" role="menuitem" TabIndex="-1" OnClick="ActivityButton_Click" AccessKey="A">
                Add Activity 
                <kbd style="margin-left: 50px"><kbd>ALT</kbd> <span class="shift-cmd">+ <kbd>SHIFT</kbd></span> + <kbd>A</kbd></kbd>
            </asp:LinkButton>
        </li>
        <li role="presentation">
            <asp:HyperLink runat="server" role="menuitem" TabIndex="-1" NavigateUrl="~/Kpi/KpiForm.aspx" AccessKey="K">
                Add KPI  
                <kbd style="margin-left: 74px"><kbd>ALT</kbd> <span class="shift-cmd">+ <kbd>SHIFT</kbd></span> + <kbd>K</kbd></kbd>
            </asp:HyperLink>
        </li>
    </ul>
</div>
<div id="addModal" class="myCustomBg">
    <div class="myCustomModal">
        <div class="modal-header">
            <h4 class="modal-title">Add Organization</h4>
        </div>
        <div class="modal-body">
            <div class="middle-box">
                <div class="form-group">
                    <asp:Label ID="OrganizationNameLb" runat="server" AssociatedControlID="OrganizationName" Text="Organization Name:"></asp:Label>
                    <asp:TextBox ID="OrganizationName" runat="server" CssClass="form-control" MaxLength="100" Text="" />
                    <asp:RequiredFieldValidator ID="OrganizationNameValidator" runat="server" ControlToValidate="OrganizationName"
                        ErrorMessage="The name is required" Display="Dynamic" ValidationGroup="OrganizationValidator" />
                </div>
            </div>
        </div>
        <div class="modal-footer btn-colors">
            <asp:LinkButton ID="AddOrganization" runat="server" CssClass="btn btn-primary" ValidationGroup="OrganizationValidator" OnClick="AddOrganization_Click">Create Organization</asp:LinkButton>
            <a class="btn btn-danger" href="javascript:cerrarOrganizationModal();">Cancel</a>
        </div>
    </div>
</div>
<script type="text/javascript">
    function cerrarOrganizationModal() {
        $(".myCustomBg").css("display", "none");
        $("#<%= OrganizationName.ClientID %>").val("");
    }
    function openOrganizationModal() {
        if ($("#<%= OrganizationsExists.ClientID %>").val() == "false") {
            openAddOrganizationModal();
        } else {
            $("#<%= ClientID %>").attr("href", "#");
            $("#<%= ClientID %>").attr("aria-expanded", "false");
            $("#<%= ClientID %>").attr("data-toggle", "dropdown");
            $("#<%= ClientID %>").addClass("dropdown-toggle");
            $("#<%= ClientID %>").click();
        }
    }
    function openAddOrganizationModal() {
        $("#addModal").css("display", "block");
        $("#<%= OrganizationName.ClientID %>").val("");
        return false;
    }
    $(document).ready(function () {
        var userAgent = navigator.userAgent.toLowerCase();
        if (userAgent.indexOf("chrome") > -1)
            $(".add-menu").addClass("is-chrome");
        else if (userAgent.indexOf("msie") > -1 || navigator.appName == 'Netscape')
            $(".add-menu").addClass("is-ie");
    });
</script>
<asp:HiddenField ID="OrganizationsExists" runat="server" Value="false" />
