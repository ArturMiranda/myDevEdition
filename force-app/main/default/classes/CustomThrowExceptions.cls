public with sharing class CustomThrowExceptions {
    
    public static void insertMerchandise() {
        try {
            // Insert Account without required fields
            Account acc = new Account();
            insert acc;
        } catch(DmlException e) {
            // Something happened that prevents the insertion
            // of Employee custom objects, so throw a more
            // specific exception.
            System.debug('DmlException caught: ' + e.getMessage());    
            CustomErrorHandler.catchException('Error: Account item could not be inserted.', e);
            throw new CustomException('Account item could not be inserted.', e);
        } catch(SObjectException e) {
            System.debug('SObjectException caught: ' + e.getMessage());    
        } catch(Exception e) {
            System.debug('Exception caught: ' + e.getMessage());    
        }
    }

    public static void nullException(){
        try {
            String s;
            Boolean b = s.contains('abc'); // Causes a NullPointerException
        } catch(NullPointerException npe) {
            System.debug('The following exception has occurred: ' + npe.getMessage());
            CustomErrorHandler.catchException('Error: NullPointerException...', npe);
        }
    }

    public static void queryException(){
        try {
            // This statement doesn't cause an exception, even though 
            // we don't have a Account with name='XYZ'.
            // The list will just be empty.
            List<Account> lm = [SELECT Name FROM Account WHERE Name = 'XYZ'];
            // lm.size() is 0 
            System.debug(lm.size());
            
            // However, this statement causes a QueryException because 
            // we're assiging the return value to a Account object
            // but no Account is returned.
            Account m = [SELECT Name FROM Account WHERE Name = 'XYZ' LIMIT 1];
        } catch(QueryException qe) {
            System.debug('The following exception has occurred: ' + qe.getMessage());
            CustomErrorHandler.catchException('Error: QueryException...', qe);    
        }
    }

    public static void queryUpdate(){
        try {
            List<Account> lm = [SELECT Name FROM Account Order by CreatedDate DESC LIMIT 1];

            update new Account(Id=lm.get(0).Id, Name=null );
        } catch(DmlException de) {
            System.debug('The following exception has occurred: ' + de.getMessage());
            CustomErrorHandler.catchException('Error: DmlException...', de);    
        } catch(Exception e) {
            System.debug('Exception caught: ' + e.getMessage()); 
            CustomErrorHandler.catchException('Error: Exception...', e);       
        }
    }

    public static void mainProcessing() {
        try {
            insertMerchandise();
        } catch(CustomException err) {
            System.debug(':: Message: ' + err.getMessage());    
            System.debug(':: Cause: ' + err.getCause());    
            System.debug(':: Line number: ' + err.getLineNumber());    
            System.debug(':: Stack trace: ' + err.getStackTraceString());    
            System.debug(':: Type: ' + err.getTypeName());    
        }
    }
}