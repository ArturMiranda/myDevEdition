@isTest
private class ExtractRecordsTest {
    
    public static Account myAccount;

    // Generate common data entity for all test cases
    static void setup() {
    
        myAccount = new Account(
            Name = 'MyAccount',
            ShippingCity = 'Lisboa',
            ShippingCountry = 'Portugal'
        );
        insert myAccount;

        Opportunity myOpportunity = new Opportunity (
            Name = 'Express Logistics Portable Truck Generators',
            AccountId = myAccount.Id,
            StageName = 'Value Proposition',
            Amount = 80000,
            LeadSource = 'External Referral',
            CloseDate = System.today().addDays(45)        
        );
        insert myOpportunity;
    }

    @isTest static void successTest() { 
        
        setup();

        ExtractRecords.FlowRequest fReq = new ExtractRecords.FlowRequest();
        fReq.email = 'my.user.test@yopmail.com';
        fReq.accountId = myAccount.Id;
        List<ExtractRecords.FlowResult> fResult =  new List<ExtractRecords.FlowResult>();
        fResult = ExtractRecords.ExtractRecords(new List<ExtractRecords.FlowRequest>{fReq} );

        System.assertEquals('OK', fResult.get(0).status, 'The test failed.');
    }

    @isTest static void errorTest() { 
        
        setup();
        
        // Call without set FlowRequest
        List<ExtractRecords.FlowResult> fResult =  new List<ExtractRecords.FlowResult>();
        fResult = ExtractRecords.extractRecords(new List<ExtractRecords.FlowRequest>{} );
        System.assertEquals('KO', fResult.get(0).status, 'The expected result is different the return.');
    }
}