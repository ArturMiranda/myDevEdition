public with sharing class CustomErrorHandler {
    private static final List<String> ERRORS_TYPES = new List<String>{'REQUIRED_FIELD_MISSING'};
    private static final String UPDATE_FAILED = 'Update failed';
    // Message exceptions delimiters
    public static Map<String, String> substringTypesMap = new Map<String, String>();
    static {
        substringTypesMap.put(',', ', ');
        substringTypesMap.put(';', '; ');
    }

    public class ErrorInterface {
        public String type ;
        public String message;
        public String recordId;
    }
    public static List<ErrorInterface> errInterfaceList = new List<ErrorInterface>();

    public static void catchException(String message, Exception ex){
        System.debug('<<< Running CustomErrorHandler >>> ');
        
        handleMansage(ex);
    }

    private static void handleMansage(Exception ex){
        String typeException = ex.getTypeName();
        String message = ex.getMessage();
        ErrorInterface errInterface = new ErrorInterface();
        Id recordId;

        errInterface.type = typeException;
        System.debug(':: Type: ' + typeException);    
        
        // Get the info according to the type of the exception
        if(typeException.equals('System.DmlException')){
            if(message.contains(UPDATE_FAILED)){// Get the record Id
                recordId = message.substringBetween('id ', substringTypesMap.get(';'));
            }
            errInterface.message = message.substringAfter(substringTypesMap.get(','));
        } else if( typeException.equals('System.NullPointerException') ) {
            errInterface.message = message;    
        } else if(typeException.equals('System.QueryException') ){
            errInterface.message = message;    
        }
 
        // Check for Id record in exception
        if (!String.isEmpty(recordId)) {
            errInterface.recordId = recordId;    
        }

        // Add exceptions records in list interface
        errInterfaceList.add(errInterface);
    }
}