/*
 * @Purpose     : Trigger for Admitted Venture Object
 * @Author      : Rabaab (Dreamwares)
 * @Created Date: 22-Sept-2018
 */
trigger AdmittedVentureTrigger on Admitted_Venture__c (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        AdmittedVentureTriggerHelper.createAdmittedVentureContactRecords(Trigger.new);
    }
}