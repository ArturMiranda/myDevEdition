public with sharing class CaseManagerHandler {

    public static final String SUCCESS_STATUS = 'OK';
    private static final Set<String> REQUIRED_PARAM = new Set<String>{'method'};
    public static Map<String, Object> serviceErros;
    
    /**
    * @author Artur Junior
	* @date Creation 00/00/0000
    */
    public class ClassDataModel {
        public String method ;
        public String Id ;

        public ClassDataModel() {}
    }

    public static Case myCase = new Case();

    public static Map<String, Object> requestHandler(Map<String, Object> restParams){                  
        ClassDataModel objClassDataModel = (ClassDataModel) JSON.deserialize(JSON.serialize(restParams), ClassDataModel.class);
        Map<String, Object> response = new Map<String, Object>();
        serviceErros = new Map<String, Object>();

        System.debug('<<< objClassDataModel >>> '+ objClassDataModel);

        Boolean isValidParam = validateParameters(restParams);
		if(isValidParam){
			myCase = getCaseById(objClassDataModel.Id);
        }
		
        // Validation response
        if(serviceErros.isEmpty()){// Success
            //response.put('data', myCase);
            response.put('status', SUCCESS_STATUS);
            response.put('description', 'Request has been processed successfully');
        } else {// Error
            response.put('status', 'ERROR');
            response.put('description', 'Bad Request');
            response.put('errors', serviceErros);
        }

        return response;
    }

    private static Case getCaseById(String caseId){

        Case result = [SELECT CaseNumber, Subject, Status, Origin, Priority FROM Case WHERE Id =: caseId ];
        return result;
    }

    public static Boolean validateParameters(Map<String, Object> restParams){
		
        for (String param : REQUIRED_PARAM) {
            if (restParams.get(param) == null) {
                serviceErros.put(param, 'The parameter "' + param + '" is required.');
                //throw new CustomRestException('The parameter [' + param + '] is required.');
            }
        }
		
        if(serviceErros.isEmpty()){
			return false;
		} else {
			return true;
		}
    }

}