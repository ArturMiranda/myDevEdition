public with sharing class ThrowExceptionsController {
    
    @AuraEnabled
    public static void generateException(String type){
        System.debug('<<< Running generateException >>>');
        
        System.debug(':: type: '+type);
        if(type == 'QueryException'){
            CustomThrowExceptions.queryException(); 
        } else if(type == 'DmlException'){
            CustomThrowExceptions.dmlException();
        } else if(type == 'NullPointerException'){
            CustomThrowExceptions.nullPointerException();
        } else {
            //System.debug(':: Success Test...');
            CustomThrowExceptions.customException();
        }
        
        // Check for exceptions
        if(CustomErrorHandler.errInterfaceList.size() > 0){
            System.debug(':: We have queryException... ');
            // Throw all errors messages
            for(CustomErrorHandler.ErrorInterface errorInterface : CustomErrorHandler.errInterfaceList) {
                System.debug('-> '+ errorInterface.message);
                throw new AuraHandledException(JSON.serialize(errorInterface));
            }
        }
    }
}