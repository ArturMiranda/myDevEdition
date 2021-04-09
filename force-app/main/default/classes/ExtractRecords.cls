public with sharing class ExtractRecords {

    @InvocableMethod(label='ExtractRecords' description='Extract records')
    public static List<FlowResult> extractRecords(List<FlowRequest> fRequest){

        FlowResult fResult = new FlowResult();
        try {
            String emailRecipient = fRequest.get(0).email;
            String accountId = fRequest.get(0).accountId;

            String strRecords = getStringRecords(accountId);
            send(emailRecipient, strRecords);
            fResult.status = 'OK';
        } catch(Exception ex){
            System.debug('Error: '+ex.getStackTraceString());
            fResult.status = 'KO';
        }

        return new List<FlowResult>{fResult};
    }

    public class FlowRequest {
        @InvocableVariable
        public String email;

        @InvocableVariable
        public String accountId;
    }

    public class FlowResult {
        @InvocableVariable
        public String status;
    }

    private static String getStringRecords(Id accountId){
        String header = 'Name, Account, StageName, Amount, ExpectedRevenue, FiscalYear,  LeadSource,  CloseDate \n';
        String recordsStr = '' ;

        List<Opportunity> oppList = [SELECT Id, Name, Account.Name, StageName, Amount, ExpectedRevenue, FiscalYear,  LeadSource,  CloseDate FROM Opportunity  WHERE AccountId =: accountId];

        for(Opportunity opp: oppList) {
            String recordString = '"'+opp.Name+'","'+opp.Account.Name+'","'+opp.StageName+'","'+opp.Amount+'","'+opp.ExpectedRevenue+'","'+opp.FiscalYear+'","'+opp.LeadSource+'","'+opp.CloseDate +'"\n';
            recordsStr = recordsStr + recordString;
        }

        return header + recordsStr;
    }

    private static void send(String emailRecipient, String strRecords){
        
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(strRecords);
        string csvname = 'Opportunity_List.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] toAddresses = new list<string> {emailRecipient};
        String subject = 'Opportunity List';
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        email.setPlainTextBody('Opportunity list extracted in ' + System.now());
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
}