public with sharing class CustomErrorHandler {
    private static final List<String> ERRORS_TYPES = new List<String>{'REQUIRED_FIELD_MISSING'};

    public class ErrorInterface {
        String type;
        String message;
        String recordId;
    }
    public static List<ErrorInterface> errInterfaceList = new List<ErrorInterface>();

    public static void catchException(String message, Exception ex){
        System.debug('<<< Running CustomErrorHandler >>> ');
        
        handleMansage(ex);
        System.debug(':: Interface: '+ JSON.serialize(errInterfaceList));
    }

    private static void handleMansage(Exception ex){
        String typeException = ex.getTypeName();
        String message = ex.getMessage();
        Id recordId;
        ErrorInterface errInterface = new ErrorInterface();
        
        errInterface.type = typeException;
        System.debug(':: Type: ' + typeException);    
        System.debug(':: message: ' + message);    
        
        if(typeException.equals('System.DmlException')){
            System.debug(':: REQUIRED_FIELD_MISSING');
            if(message.contains('Update failed')){
                recordId = message.substringBetween('id ','; ');
            }
            errInterface.message = message.substringAfter(', ');
        } else if( typeException.equals('System.NullPointerException') ) {
            System.debug(':: NULL REFERENCE ERROR');
            errInterface.message = message;    
        } else if(typeException.equals('System.QueryException') ){
            System.debug(':: Query Exception  ERROR');
            errInterface.message = message;    
        }
 
        if (!String.isEmpty(recordId)) {
            System.debug(':: [['+recordId+']]');
            errInterface.recordId = recordId;    
        }

        errInterfaceList.add(errInterface);
    }
}