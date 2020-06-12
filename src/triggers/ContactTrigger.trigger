/*
 * Name: ContactTrigger
 * Description: 
 * Last Modified By: Megha Raheja
 * Last Modified Date: 2019-03-22
 */
trigger ContactTrigger on Contact (after insert) {
    ContactTriggerHelper helperObj = new ContactTriggerHelper(Trigger.newMap, Trigger.oldMap);
        
    if(Trigger.isInsert && Trigger.isAfter){
        helperObj.findMatchingLeadEmailAddress(Trigger.newMap);
    }
        
}