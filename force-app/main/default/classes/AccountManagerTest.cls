@IsTest

private class AccountManagerTest {

    // Helper method
    static Id createTestRecord() {
        // Create test record
        Account accTest = new Account(
            Name='Test record',
            phone ='(212) 555-5555',
            Type ='Prospect',
            Industry='Manufacturing');

        insert accTest;
        return accTest.Id;
    } 

    @isTest static void testGetaccById() {

        Id recordId = createTestRecord();

        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = 'https://yourInstance.salesforce.com/services/apexrest/Accounts/<Account_ID>/contacts/' + recordId;
        request.httpMethod = 'GET';
        RestContext.request = request;

        // Call the method to test
        Account thisacc = AccountManager.getAccount();

        // Verify results
        System.assert(thisacc != null);
        System.assertEquals('Test record', thisacc.Name);
    }
}