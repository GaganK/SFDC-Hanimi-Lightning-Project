/*
 * Name: FindAccountMatchOnLead
 * Description: This batch class is executed from Account Trigger. Batch size: 200
 * Last Modified Date: 2019-03-22
 */
global class FindAccountMatchOnLead implements Database.Batchable<sObject> {
    
    // Initialize variables
    List<Account> accountListToProcess = new List<Account>();
    Set<String> accountNameSet = new Set<String>();
    Map<ID, String> accountMapToProcess = new Map<Id, String>();
    SET<Id> accIds = new Set<Id>();

    /* Name: FindAccountMatchOnLead
     * Description: Constructor of the class
     * Parameters: List<Account>
     * Return: NA
    */
    global FindAccountMatchOnLead( Map<ID, String> accountMap){
        accountMapToProcess = accountMap;
        accIds = accountMap.keyset();
    }  
    
    // Batch class start method
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID, Name from Account where ID in: accIds'
        );
    }
    
    /* Name: execute
     * Description: execute method of batch class. It search for
     *              Name on Account with the Company Name on Leads, if matches, 
     *              it links Account with the matching lead
     * Parameters: List<Account>
     * Return: NA
    */
    global void execute(Database.BatchableContext bc, List<Account> scope){
        List<Lead> leadsToUpdate = new List<Lead>();
        Map<String, AbbreviationsToOmit__c> abbreviations = AbbreviationsToOmit__c.getAll();
       
        for(Lead lead : [Select Company,Matching_Account__c from Lead 
                         where Matching_Account__c = NULL
                        AND  status != 'Disqualified']){
            for (Account account : scope) {
                if(lead.Company.containsIgnoreCase(accountMapToProcess.get(account.Id))){
                    lead.Matching_Account__c = account.Id;
                    leadsToUpdate.add(lead);
                }
            }
        }
        if(! leadsToUpdate.isEmpty()){
            update leadsToUpdate;
        }          
    }    
    
    // Batch class finish method
    global void finish(Database.BatchableContext bc){
       
    }    
}