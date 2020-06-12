/*
 * Name: ApplicationTriggerHelper
 * Description: Helper class for handling processing of Application__c Triggers
 * Last Modified Date: 2019-04-25
 */
public with sharing class ApplicationTriggerHelper{
    Map<Id, Application__c> newApplicationMap;
    Map<Id, Application__c> oldApplicationMap;
    List<Application__c> newApplicationList;
    List<Application__c> oldApplicationList;
    
    /* Name: ApplicationTriggerHelper
     * Description: Constructor of the class
     * Parameters: Trigger.newMap, Trigger.oldMap
     * Return: NA
    */
    public ApplicationTriggerHelper(Map<Id, Application__c> newMap, Map<Id, Application__c> oldMap, List<Application__c> newApplicationList, List<Application__c> oldApplicationList){
        // Intialize the map variables
        newApplicationMap = new Map<Id, Application__c>();
        oldApplicationMap = new Map<Id, Application__c>();
        
        // Assign values from trigger
        this.newApplicationMap = newMap;
        this.oldApplicationMap = oldMap;
        this.newApplicationList = newApplicationList;
        this.oldApplicationList = oldApplicationList;
    }
    
    /* Name: linkApplicationWithLead
     * Description: This method links lead with the application record. Lead search is based on the parent account Id
     * Parameters: None
     * Return: Void
    */
    public void linkApplicationWithLead(){
        Map<Id, Application__c> accountIdApplicationMap = new Map<Id, Application__c>();
        Map<Id, Id> accountLeadIdMap = new Map<Id, Id>();
        List<Lead> leads = new List<Lead>();
        
        for(Application__c app : newApplicationList){
            // get applications with linked Account record
            if(app.Venture__c != null){
                accountIdApplicationMap.put(app.Venture__c,app);
            }
        }
        
        // Find leads that has the same account ID linked in field Matching_Account__c 
        if(! accountIdApplicationMap.keyset().isEmpty()){
            leads = [Select Id,Matching_Account__c from Lead where Matching_Account__c in: accountIdApplicationMap.keyset()];
            if(! leads.isEmpty()){
                for(Lead leadRec : leads){
                    accountLeadIdMap.put(leadRec.Matching_Account__c,leadRec.ID );
                }
            }
        }
        
        // Link application record with Lead
        if(! accountLeadIdMap.keyset().isEmpty()){
            for(Application__c app : accountIdApplicationMap.values()){
                app.Related_Lead__c = accountLeadIdMap.get(app.Venture__c);
            }
        }
    }
    
    
    
}