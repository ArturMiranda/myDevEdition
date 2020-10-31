/*
fonte: https://trailhead.salesforce.com/en/content/learn/modules/apex_integration_services/apex_integration_webservices
*/

@RestResource(urlMapping='/Case/*')
global with sharing class CaseManager {

    @httpGet
    global static void getCaseById(){
        System.debug('<<< Running CaseManager.getCaseById() >>> ');
        // Url test: /services/apexrest/Case/5005J000003knfUQAQ

        RestRequest request = RestContext.request;
        List<String> urlParameters = request.requestURI.split('/');
        String codPod = urlParameters.get(2);
        
        RestContext.response.addHeader('Content-Type', 'application/json');
        Map<String, String> params = RestContext.request.params;
        params.put('method','GET');
        params.put('Id',codPod);
        System.debug(':: params: '+ JSON.serialize(params) );
        Map<String, Object> response = CaseManagerHandler.requestHandler(params);
        System.debug(':: response: '+ JSON.serialize(response) );
		
        if(response.get('status') == CaseManagerHandler.SUCCESS_STATUS){
            RestContext.response.statusCode = 200;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(response));
        } else {
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(response));
        }
        
        System.debug('<<< CaseManager.getCaseById() has finished >>> ');
    }

    @httpPost
    global static Id createCase(String subject, String status, String origin, String priority){

        Case myCase = new Case (Subject=subject, Status=status, Origin=origin, Priority=priority);
        insert myCase;

        return myCase.Id;
    }

    @HttpDelete
    global static void deleteCase() {

        RestRequest request = RestContext.request;
        String caseId = request.requestURI.substring( request.requestURI.lastIndexOf('/')+1 );
        Case thisCase = [SELECT Id FROM Case WHERE Id = :caseId];

        delete thisCase;
    }

    @HttpPut
    global static Id upsertCase(String subject, String status,
        String origin, String priority, String id) {
        Case thisCase = new Case(
                Id=id,
                Subject=subject,
                Status=status,
                Origin=origin,
                Priority=priority);
        // Match case by Id, if present.
        // Otherwise, create new case.
        upsert thisCase;
        // Return the case ID.
        return thisCase.Id;
    }

    @HttpPatch
    global static Id updateCaseFields() {
        RestRequest request = RestContext.request;
        String caseId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Case thisCase = [SELECT Id FROM Case WHERE Id = :caseId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Case sObject
            thisCase.put(fieldName, params.get(fieldName));
        }

        update thisCase;
        return thisCase.Id;
    }    
}