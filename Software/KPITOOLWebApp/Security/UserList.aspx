<%@ Page Title="<%$ Resources:UserData, PageTitleList %>" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="UserList.aspx.cs" Inherits="Security_UserList" %>

<%@ Register Src="../UserControls/SearchUserControl/SearchControl.ascx" TagName="SearchControl" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="ibox float-e-margins">
        <div class="ibox-title">
            <h5><asp:Literal ID="TitleLabel" runat="server" Text="<%$ Resources:UserData, PageTitleList %>" /></h5>
            <div class="ibox-tools">
                <a class="collapse-link">
                    <i class="fa fa-chevron-up"></i>
                </a>
            </div>
        </div>
        <div class="ibox-content">
            <div class="row">
                <div class="col-md-12">
                    <p>
                        <asp:LinkButton ID="NewButton" runat="server" Text="<%$ Resources:UserData, NewButton %>" CssClass="btn btn-primary "
                            OnClick="NewButton_Click"></asp:LinkButton>
                    </p>
                </div>
                <div class="col-md-12">
                    <div class="row">
                        <div class="col-md-6">
                            <uc1:SearchControl ID="UserSearchControl" runat="server" Title="<%$ Resources:UserData, SearchLabel %>" DisplayHelp="true"
                                DisplayContextualHelp="true" CssSearch="CSearch" CssSearchError="CSearchErrorPanel"
                                CssSearchHelp="CSearchHelpPanel" ImageErrorUrl="~/Images/neutral/exclamation.png"
                                ImageHelpUrl="~/Images/neutral/Help.png" />
                            <div style="clear: both; margin-bottom: 10px; "></div>
                        </div>
                    </div>
                </div>
                <div class="col-md-12">
                    <div class="table-responsive">
                        <asp:GridView ID="UserGridView" runat="server" AutoGenerateColumns="False" DataSourceID="UserObjectDataSource"
                            DataKeyNames="Username" OnRowDataBound="UserGridView_RowDataBound" OnSelectedIndexChanged="UserGridView_SelectedIndexChanged"
                            CssClass="table table-striped table-bordered table-hover" GridLines="None">
                            <HeaderStyle CssClass="rgHeader head" />
                            <FooterStyle CssClass="foot" />
                            <AlternatingRowStyle CssClass="altRow" />
                            <EmptyDataRowStyle CssClass="gridNoData" />
                            <RowStyle CssClass="" />
                            <Columns>
                                <asp:TemplateField HeaderText="<%$ Resources:UserData, EditColumn %>" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="50px" 
                                    ItemStyle-VerticalAlign="Middle" HeaderStyle-VerticalAlign="Middle">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="EditImageButton" runat="server" CommandName="Select" CssClass="text-success img-buttons" Text="<i class='fa fa-pencil'></i>"
                                            OnClick="EditImageButton_Click" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="<%$ Resources:UserData, DeleteColumn %>" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="50px" 
                                    ItemStyle-VerticalAlign="Middle" HeaderStyle-VerticalAlign="Middle">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="DeleteImageButton" runat="server" CommandName="Select" CssClass="text-danger img-buttons" Text="<i class='fa fa-trash-o'></i>"
                                            OnClick="DeleteImageButton_Click" OnClientClick="<%$ Resources:UserData, ConfirmDeleteUser %>" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="<%$ Resources:UserData, UnlockColumn %>" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="50px" 
                                    ItemStyle-VerticalAlign="Middle" HeaderStyle-VerticalAlign="Middle">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="BlockImageButton" runat="server" CausesValidation="False" CommandName="Select" CssClass="text-warning img-buttons"
                                            Text="<i class='fa fa-unlock-alt'></i>" OnClick="BlockImageButton_Click" OnClientClick="<%$ Resources:UserData, ConfirmUnlockUser %>" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="<%$ Resources:UserData, RestorePasswordColumn %>" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="60px" 
                                    ItemStyle-VerticalAlign="Middle" HeaderStyle-VerticalAlign="Middle">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="ResetImageButton" runat="server" CausesValidation="False" CommandName="Select" CssClass="text-primary img-buttons"
                                            Text="<i class='fa fa-refresh'></i>" OnClick="ResetImageButton_Click" OnClientClick="<%$ Resources:UserData, ConfirmResetPassword %>" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="UserName" HeaderText="<%$ Resources:UserData, UserNameColumn %>" ItemStyle-Width="150px" ItemStyle-VerticalAlign="Middle" 
                                    HeaderStyle-VerticalAlign="Middle">
                                </asp:BoundField>
                                <asp:BoundField DataField="FullName" HeaderText="<%$ Resources:UserData, FullNameColumn %>" ItemStyle-Width="200px" ItemStyle-VerticalAlign="Middle" 
                                    HeaderStyle-VerticalAlign="Middle">
                                </asp:BoundField>
                                <asp:BoundField DataField="Email" HeaderText="<%$ Resources:UserData, EmailColumn %>" ItemStyle-Width="120px" ItemStyle-VerticalAlign="Middle" 
                                    HeaderStyle-VerticalAlign="Middle">
                                </asp:BoundField>
                                <asp:CheckBoxField DataField="IsOnline" HeaderText="<%$ Resources:UserData, ConnectedColumn %>" ControlStyle-CssClass="i-checks" Visible="false" 
                                    ItemStyle-Width="80px" ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" HeaderStyle-VerticalAlign="Middle">
                                </asp:CheckBoxField>
                                <asp:CheckBoxField DataField="IsAproved" HeaderText="<%$ Resources:UserData, ApprovedColumn %>" ControlStyle-CssClass="i-checks" 
                                    ItemStyle-Width="80px" ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" HeaderStyle-VerticalAlign="Middle">
                                </asp:CheckBoxField>
                                <asp:CheckBoxField DataField="IsBlocked" HeaderText="<%$ Resources:UserData, LockedColumn %>" ControlStyle-CssClass="i-checks"  
                                    ItemStyle-Width="80px" ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" HeaderStyle-VerticalAlign="Middle">
                                </asp:CheckBoxField>
                            </Columns>
                            <EmptyDataTemplate>
                                <asp:Label ID="EmptyRowUser" runat="server" Text="<%$ Resources:UserData, EmptyRowUser %>"></asp:Label>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                    <div class="clear">
                    </div>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            $(document).ready(function () {
                $("#modal_chSearch").html('<i class="fa fa-question-circle"></i>');
                $('.i-checks').find('input:checkbox').each(function () {
                    var attr = $(this).attr('checked');
                    if (typeof attr == typeof undefined || attr != 'checked') {
                        $(this).removeClass("icheckbox_square-green");
                        $(this).removeClass("iradio_square-green");
                    } else {
                        $(this).addClass("icheckbox_square-green");
                        $(this).addClass("iradio_square-green");
                    }
                });
            });
        </script>
    </div>

    <asp:HiddenField ID="UsernameHiddenField" runat="server" />
    <asp:HiddenField ID="OperationHiddenField" runat="server" />

    <asp:ObjectDataSource ID="UserObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetUsersListForSearch" TypeName="Artexacta.App.User.BLL.UserBLL" 
        OnSelected="UserObjectDataSource_Selected">
        <SelectParameters>
            <asp:ControlParameter ControlID="UserSearchControl" Name="whereSql" PropertyName="Sql" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

</asp:Content>

