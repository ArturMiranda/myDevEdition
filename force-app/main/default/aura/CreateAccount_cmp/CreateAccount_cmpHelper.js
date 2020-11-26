({
	validateAccountForm : function(component) {
        console.log(':: Running validateAccountForm');

		return true;
    },
    closePanel : function(component){
        console.log(':: Running closePanel');

        // Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    successToast : function(component, msg) {
        console.log(':: Running successToast');

        // record is saved successfully
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": "Saved",
            "type": "success",
            "message": msg
        });
        resultsToast.fire();
    },
    warningToast : function(component, objectError) {
        console.log(':: Running warningToast');
        console.log(objectError);

        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'sticky',
            message: objectError.message,
            type: "warning",
            messageTemplate: '{0}. {1}!',
            messageTemplateData: [
                objectError.message, 
                {
                    url: 'https://arttoryusdeveloper.lightning.force.com/'+objectError.recordId,
                    label: 'Click here',
                }
            ]
        });
        toastEvent.fire();
    },
})