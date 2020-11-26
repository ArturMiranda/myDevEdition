({
    closePanel : function(component){
        console.log(':: Running closePanel');

        // Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    successToast : function(component, toastParam) {
        console.log(':: Running successToast');

        // record is saved successfully
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": toastParam.title,
            "message": toastParam.message,
            "type": "success"
        });
        resultsToast.fire();
    },
    warningToast : function(component, toastParam) {
        console.log(':: Running warningToast');
        console.log(toastParam);

        var toastEvent = $A.get("e.force:showToast");
        var template, templateData;
        if(toastParam.recordId){
            template = '{0}. {1}!';
            templateData =  [
                toastParam.message, 
                {
                    url: 'https://arttoryusdeveloper.lightning.force.com/'+ toastParam.recordId,
                    label: 'Click here',
                }
            ];
        }

        toastEvent.setParams({
            mode: 'sticky',
            message: toastParam.message,
            type: "warning",
            messageTemplate: template,
            messageTemplateData: templateData
        });
        toastEvent.fire();
    },
})