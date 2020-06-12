/*
 * @Purpose     : Helper for Admitted Venture Object Trigger
 * @Author      : Rabaab (Dreamwares)
 * @Created Date: 22-Sept-2018
 */
public class AdmittedVentureTriggerHelper {
    /*
     * @Purpose : Creates Admitted Venture Contact Records for the given Admitted Venture Records
     * @Params  : Admitted Venture Records
     * @Returns : -
     */
    public static void createAdmittedVentureContactRecords(Admitted_Venture__c[] admittedVentures){
        //checking if admittedVentures is null or empty
        if(admittedVentures == null || admittedVentures.isEmpty()){
            return;
        }
        //List of Admitted Venture Records to be inserted.
        Admitted_Venture_Contact__c[] admittedVentureContactRecords = new List<Admitted_Venture_Contact__c>();
        
        //Creating set of application id's for which application contacts have to be fetched.
        Set<Id> applicationIds = createApplicationIdsSet(admittedVentures);
        
        Application_Contact__c[] applicationContacts = [SELECT Id, Application__c, Contact__c, Primary_Contact__c 
                                                        FROM Application_Contact__c
                                                        WHERE Application__c IN : applicationIds];
        
        //If application contacts are not present then return
        if(applicationContacts== null || applicationContacts.isEmpty()){
            return;
        }
        
        //Creating map of Application Id to Application Contact records
        Map<Id, Application_Contact__c[]> applicationIdToApplicationContactsMap = createApplicationToContactsMap(applicationContacts);
        
        //Creating Admitted Venture Contact Records for each Admitted Venture and it's related application contacts
        for(Admitted_Venture__c admittedVenture : admittedVentures){
            if(admittedVenture.Related_Application__c == null 
               || !applicationIdToApplicationContactsMap.containsKey(admittedVenture.Related_Application__c)){
                continue;
            }
            for(Application_Contact__c applicationContact : applicationIdToApplicationContactsMap.get(admittedVenture.Related_Application__c)){
                admittedVentureContactRecords.add(new Admitted_Venture_Contact__c(Admitted_Venture__c = admittedVenture.Id, 
                                                                                  Contact__c = applicationContact.Contact__c,
                                                                                  Primary_Contact__c = applicationContact.Primary_Contact__c));
            }
        }
        
        insert admittedVentureContactRecords;
    }
    
    /*
     * @Purpose : Creates set of Application Id's for the given list of Admitted Ventures
     * @Params  : Admitted Venture Records
     * @Returns : Set of Application Ids
     */
    private static Set<Id> createApplicationIdsSet(Admitted_Venture__c[] admittedVentures){
        Set<Id> applicationIds = new Set<Id>();
        
        for(Admitted_Venture__c admittedVenture : admittedVentures){
            if(admittedVenture.Related_Application__c != null){
                applicationIds.add(admittedVenture.Related_Application__c);
            }
        }
        return applicationIds;
    }
    
    /*
     * @Purpose : Creates map of Application Id to Application Contact records.
     * @Params  : Application contact records
     * @Returns : Map of Id to Application Contacts
     */
    private static Map<Id, Application_Contact__c[]> createApplicationToContactsMap(Application_Contact__c[] applicationContacts){
        Map<Id, Application_Contact__c[]> applicationIdToApplicationContactsMap = new Map<Id, Application_Contact__c[]>();
        for(Application_Contact__c applicationContact : applicationContacts){
            Application_Contact__c[] appContactsList;
            if(applicationIdToApplicationContactsMap.containsKey(applicationContact.Application__c)){
                appContactsList = applicationIdToApplicationContactsMap.get(applicationContact.Application__c);
            }else{
                appContactsList = new List<Application_Contact__c>(); 
                applicationIdToApplicationContactsMap.put(applicationContact.Application__c, appContactsList );
            }
            appContactsList.add(applicationContact);
        }
        return applicationIdToApplicationContactsMap;
    }
}