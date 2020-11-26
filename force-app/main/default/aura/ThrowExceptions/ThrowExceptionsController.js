({
    doInit: function(component, event, helper) {
        console.log(':: Running doInit');
    },
    success : function(component, event, helper) {
        console.log(':: Running success');
        var toastParam = {
            title: "Success",
            message: "This test has been completed successfully!"
        }
        helper.successToast(component, toastParam);
    },
    neutralSuccess : function(component, event, helper) {
        console.log(':: Running neutralSuccess');
        var toastParam = {
            title: "Neutral, no error",
            message: "This test performed without errors!"
        }
        helper.successToast(component, toastParam);
    },
    simpleHandler : function(component, event, helper) {
        console.log(':: Running simpleHandler');
        
        // record is saved successfully
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": "Simple Exceptions Handler",
            "message": "Quase lá...",
            "type": "warning"
        });
        resultsToast.fire();
    },
    complexHandler : function(component, event, helper) {
        console.log(':: Running complexHandler');
        
        let buttonType = event.getSource().get("v.name");
        // Create the action
        var action = component.get("c.generateException");
        action.setParams({type: buttonType});

        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log(response);
            
            if (state === "SUCCESS") {
                var toastParam = {
                    title: "Success - Complex Handler",
                    message: "Test performed successfully!!!"
                }
                helper.successToast(component, toastParam);
            }
            else {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        let objectError = JSON.parse(errors[0].message);
                        helper.warningToast(component, objectError);
                    }
                } else {
                    console.log(":: Unknown error");
                }
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    }
})