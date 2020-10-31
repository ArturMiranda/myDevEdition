@RestResource(urlMapping='/Accounts/*/contacts/')
global with sharing class AccountManager{

    @httpGet
    global static Account getAccount(){
        System.debug('<<< Running getAccount method >>>');

        RestRequest request = RestContext.request;
        //grab the case from the end of the url
        List<String> urlParameters = request.requestURI.split('/');
        String accId = urlParameters.get(2);
        Account result = [SELECT Id, Name, (SELECT Id, Name FROM Contacts) FROM Account WHERE Id =: accId ];

        System.debug('<<< getAccount reponse: '+ JSON.serialize(result));
        return result;
    }
}