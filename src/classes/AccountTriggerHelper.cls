/*
 * Name: AccountTriggerHelper
 * Description: Helper class for handling processing of Account Triggers
 * Last Modified Date: 2019-03-22
 */
public with sharing class AccountTriggerHelper{
    static Map<Id, Account> newAccountMap;
    static Map<Id, Account> oldAccountMap;
    
    /* Name: AccountTriggerHelper
     * Description: Constructor of the class
     * Parameters: Trigger.newMap, Trigger.oldMap
     * Return: NA
    */
    public AccountTriggerHelper(Map<Id, Account> newMap, Map<Id, Account> oldMap){
        // Intialize the map variables
        newAccountMap = new Map<Id, Account>();
        oldAccountMap = new Map<Id, Account>();
        
        // Assign values from trigger
        newAccountMap = newMap;
        oldAccountMap = oldMap;
    }
    
     /* Name: findMatchingLeadEmailAddress
     * Description: This method filter contacts where Email is NOT blank and send list to the Batch class
     * Parameters: Contact Map
     * Return: void
    */
    public void findMatchingLeadCompany(Map<Id, Account> accountMap){
        Map<ID, String> accountMapWithoutAbbrv = new Map<ID, String>();
        
        // Fetch all the values from the custom setting Abbreviations To Omit
        Map<String, AbbreviationsToOmit__c> abbreviations = AbbreviationsToOmit__c.getAll();
        
        for(Account acc : accountMap.values()){
            for(String abbre : abbreviations.keyset()){
                String accName =  acc.Name;
                if(accName.containsIgnoreCase(abbre)){
                    accName = acc.Name.removeEnd(abbre).trim();
                    accName = accName.removeEnd('.');
                    accountMapWithoutAbbrv.put(acc.ID, accName);
                    break;
                }
                else{
                    accountMapWithoutAbbrv.put(acc.ID, accName);
                }
            }    
        }
      
        if (accountMapWithoutAbbrv.keyset().size() > 0) {
            Database.executeBatch(new FindAccountMatchOnLead(accountMapWithoutAbbrv), 200);
        }
    }
}