({
    doInit: function(component, event, helper) {
        // Prepare a new record from template
        component.find("AccountRecordCreator").getNewRecord(
            "Account", // sObject type (objectApiName)
            null,      // recordTypeId
            false,     // skip cache?
            $A.getCallback(function() {
                var rec = component.get("v.newAccount");
                var error = component.get("v.newAccountError");
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                    return;
                }
                console.log("Record template initialized: " + rec.apiName);
            })
        );
    },

    handleSaveAccount: function(component, event, helper) {
        if(helper.validateAccountForm(component)) {
            component.set("v.simpleNewAccount.AccountId", component.get("v.recordId"));
            component.find("AccountRecordCreator").saveRecord(function(saveResult) {
                if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                    // record is saved successfully
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Saved",
                        "message": "The record was saved."
                    });
                    resultsToast.fire();
					helper.closePanel(component);
                } else if (saveResult.state === "INCOMPLETE") {
                    // handle the incomplete state
                    console.log("User is offline, device doesn't support drafts.");
                } else if (saveResult.state === "ERROR") {
                    // handle the error state
                    console.log('Problem saving Account, error: ' + JSON.stringify(saveResult.error));
                } else {
                    console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                }
            });
        }
    },
    
    throwExceptions : function(component, event, helper) {
        // record is saved successfully
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": "Exceptions",
            "message": "Quase lá...",
            "type": "warning"
        });
        resultsToast.fire();
    },
    
    dataToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'sticky',
            message: 'This is a required message',
            messageTemplate: 'Record {0} created! See it {1}!',
            messageTemplateData: ['Salesforce', {
                url: 'http://www.salesforce.com/',
                label: 'here',
                }
            ]
        });
        toastEvent.fire();
    }
})