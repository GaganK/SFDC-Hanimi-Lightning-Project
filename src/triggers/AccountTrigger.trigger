/*
 * Name: AccountTrigger
 * Description: 
 * Last Modified By: Megha Raheja
 * Last Modified Date: 2019-03-22
 */
trigger AccountTrigger on Account (after insert) {
    AccountTriggerHelper helperObj = new AccountTriggerHelper(Trigger.newMap, Trigger.oldMap);
        
    if(Trigger.isInsert && Trigger.isAfter){
        helperObj.findMatchingLeadCompany(Trigger.newMap);
    }
        
}