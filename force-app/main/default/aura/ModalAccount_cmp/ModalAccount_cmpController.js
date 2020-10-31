({
    doInit : function(component, event, helper){
        console.log(':: recodrId: '+component.get('v.recordId'));
        var action = component.get("c.getData");
        action.setParams({"swId": component.get("v.recordId")});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if(state == "SUCCESS"){
				$A.get("e.force:closeQuickAction").fire();
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
                    "title": "Success!",
                    "message": "Successfully performed."
				});
                console.log(':: retrieve data: '+ response.getReturnValue());
                component.set('v.Account', response.getReturnValue());
                var fields = {'Name':'my name','Industry':'my Industry','ola':'hello'};
                component.set('v.fields', fields);
				toastEvent.fire();
			} else {
				component.set("v.messageError", true);
			}
		});
		$A.enqueueAction(action);
    },
	activeModal : function(component, event, helper) {
        console.log(':: Running activeModal >>>');
        var cmpTarget = component.find('modal-background');
        console.log(':: '+ cmpTarget);
        $A.util.addClass(cmpTarget, 'slds-backdrop_open');
        var modal = component.find('modalId');
        console.log(':: '+ modal);
        $A.util.addClass(modal, 'slds-fade-in-open');
   },
   closeModal : function(component, event, helper) {
        console.log(':: Running closeModal >>>');
        var cmpTarget = component.find('modal-background');
        $A.util.removeClass(cmpTarget, 'slds-backdrop_open');
        var modal = component.find('modalId');
        $A.util.removeClass(modal, 'slds-fade-in-open');
   },
   submitRequest : function(component, event, helper) {
        console.log(':: Running submitRequest >>>');
   }
	
})