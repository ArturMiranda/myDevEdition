public with sharing class ModalAccountController {

    @AuraEnabled
    public static List<Account> getData(String swId){
        
        System.debug(':: swId '+ swId);
        return [SELECT Id, Name, Phone, Fax, Type, Industry, NumberOfEmployees   FROM Account Limit 1];
    }


    @AuraEnabled
    public static void saveData(){
        System.debug(':: Running saveData ');
    }


}