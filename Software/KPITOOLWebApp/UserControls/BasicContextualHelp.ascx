<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BasicContextualHelp.ascx.cs" Inherits="UserControls_BasicContextualHelp" %>

<a id="HelpLink" runat="server" href="javascript:void(0)"
    tabindex="0" role="button"
    title="<%$ Resources: Glossary, HelpTitle %>">
    <i class="fa fa-question-circle" aria-hidden="true"></i>
</a>
<asp:Label runat="server" ID="ModeHiddenLabel" Text="Tooltip" Visible="false"></asp:Label>
<div class="modal fade" id="modal" runat="server" tabindex="-1" role="dialog" visible="false">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">
                    <asp:Literal ID="HelpTitleLiteral" runat="server" Text="<%$ Resources: Glossary, HelpTitle %>"></asp:Literal>
                    <asp:Literal ID="HelpFileIdLiteral" runat="server"></asp:Literal>
                </h4>
            </div>
            <div class="modal-body">
                <asp:Literal ID="ContentLiteral" runat="server"></asp:Literal>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">
                    <asp:Literal runat="server" Text="<%$ Resources: Glossary, CloseLabel %>"></asp:Literal>
                </button>
            </div>
        </div>
    </div>
</div>
<asp:HiddenField ID="SourceTypeHiddenField" runat="server" Value="Resource" />
<asp:HiddenField ID="HelpFileHiddenField" runat="server" Value="" />
