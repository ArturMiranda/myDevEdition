public with sharing class ExtractRecords {

    @InvocableMethod(label='ExtractRecords' description='Extract records')
    public static List<FlowResult> doExtractRecords(List<FlowRequest> fRequest){

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
        List<Opportunity_Query_Mapping__mdt> oppFields = Opportunity_Query_Mapping__mdt.getall().values();
        Map<Integer, String> headerMap = new Map<Integer, String>();
        Map<Integer, String> flieldMap = new Map<Integer, String>();
        List<Integer> fieldOrder = new List<Integer>();
        for(Opportunity_Query_Mapping__mdt f : oppFields){
            if(f.Active__c){
                headerMap.put(Integer.ValueOf(f.Index__c), f.Name__c);
                flieldMap.put(Integer.ValueOf(f.Index__c), f.API_Name__c);
                fieldOrder.add(Integer.ValueOf(f.Index__c));
            }
        }

        fieldOrder.sort();

        List<String> headerList = new List<String>();
        List<String> flieldList = new List<String>();
        for(Integer i : fieldOrder){
            headerList.add(headerMap.get(i));
            flieldList.add(flieldMap.get(i));
        }

        String soqlQuery = 'SELECT '+ flieldList.toString().remove('(').remove(')') +' FROM Opportunity WHERE AccountId = \''+ accountId + '\'';
        String header = headerList.toString().remove('(').remove(')');
        List<SObject> objectList = Database.query(soqlQuery);

        String recordsLinesStr = '';
        for(SObject sobj: objectList) {
            String recordString = '';
            for(String field: flieldList) {
                if(field.contains('.')){
                    String[] parts = field.split('\\.',0);
                    recordString += '"'+sobj.getSObject(parts[0]).get(parts[1])+'",';
                } else {
                    recordString += '"'+sobj.get(field)+'",';
                }
            }
            recordsLinesStr += recordString.removeEnd(',') + '\n';
        }
        
        String csvRecords = header +'\n'+ recordsLinesStr;

        return csvRecords;
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