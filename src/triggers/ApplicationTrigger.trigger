/*
 * Name: ApplicationTrigger 
 * Description: 
 * Last Modified Date: 2019-04-25
 */
trigger ApplicationTrigger on Application__c(before insert) {
    ApplicationTriggerHelper helperObj = new ApplicationTriggerHelper(Trigger.newMap, Trigger.oldMap, Trigger.new, Trigger.old);
        
    if(Trigger.isInsert && Trigger.isBefore){
        helperObj.linkApplicationWithLead();
    }
        
}