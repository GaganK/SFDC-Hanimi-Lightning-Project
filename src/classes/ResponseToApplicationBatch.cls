/*
 * Purpose		: Batch to map all response records to application objects field
 * Developer	: Rabaab (Dreamwares)
 * Date			: 15-May-2018
 */
global class ResponseToApplicationBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc) {
        //Fetching all response records
        return Database.getQueryLocator(
            'SELECT Id, Name, Question_English__c, Response__c, Application__c FROM Response__c WHERE Application__c != null' 
        );
    }
    
    
    global void execute(Database.BatchableContext bc, List<Response__c> responses){
        System.debug('response size: ' + responses.size());
        ResponseToApplicationHelper.mapResponsesToApplication(responses);
    }
    
    global void finish(Database.BatchableContext bc){
    }
}