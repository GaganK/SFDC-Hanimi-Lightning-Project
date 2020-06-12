/*
 * Name: FindContactMatchOnLead
 * Description: This batch class is executed from Contact Trigger. Batch size: 100
 * Last Modified Date: 2019-03-22
 */
global class FindContactMatchOnLead implements Database.Batchable<sObject>{
    
   // Initialize variables
    List<Contact> contactListToProcess = new List<Contact>();
    static Set<String> emailIDs = new Set<String>();
    Set<Id> IDs = new Set<Id>();

    /* Name: FindContactMatchOnLead
     * Description: Constructor of the class
     * Parameters: List<contact>
     * Return: NA
    */
    global FindContactMatchOnLead(List<Contact> contactList){
        contactListToProcess = contactList;
        for(Contact con : contactList){
            emailIDs.add(con.Email);
            IDs.add(con.Id);
        }  
        System.debug('emailIDs List**'+emailIDs);
    }  
    
    // Batch class start method
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID, Email from Contact where ID in: Ids'
        );
    }
    
    /* Name: execute
     * Description: execute method of batch class. It search for
     *              Email on contact with the Email address on Leads, if matches, 
     *              it links contact with the matching lead
     * Parameters: List<contact>
     * Return: NA
    */
    global void execute(Database.BatchableContext bc, List<Contact> scope){
        List<Lead> leadsToUpdate = new List<Lead>();
        
        for(Lead lead : [Select Id, Email,Matching_Contact__c from Lead 
                         where Email != NULL AND Matching_Contact__c = NULL
                         AND status != 'Disqualified']){
                      
            for (Contact contact : scope) {
                if(lead.Email.toLowerCase() == contact.Email.toLowerCase()){
                    lead.Matching_Contact__c = contact.Id;
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