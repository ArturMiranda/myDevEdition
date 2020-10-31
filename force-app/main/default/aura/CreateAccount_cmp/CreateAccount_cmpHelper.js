({
	validateAccountForm : function(component) {
		return true;
	},
    closePanel : function(component){
        // Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})