/*
 * @Purpose     : Test class for Admitted Venture Object Trigger
 * @Author      : Rabaab (Dreamwares)
 * @Created Date: 24-Sept-2018
 */
@isTest
public class AdmittedVentureTriggerTest {
    private static Integer maxCount = 3;
    private static Integer contactsCount = 5;
    
    /*
     * @Purpose : Test method for trigger 
     */
    public static testMethod void testAdmittedVentureTrigger(){
        Test.startTest();
        
        Contact[] contacts = createContactRecords();
        Account[] accounts = createVentureRecords();
        Application__c[] applications = createApplicationRecords(accounts);
        Application_Contact__c[] applicationContacts = createApplicationContactRecords(applications, contacts);
        Match__c[] matches = createMatchRecords(applications);
        Admitted_Venture__c[] admittedVentures = createAdmittedVentureRecords(applications, matches);
        
        Test.stopTest();
        
        Integer expectedCount = admittedVentures.size() * contacts.size();
        Integer actualCount = [SELECT count() FROM Admitted_Venture_Contact__c];
        System.assertEquals(expectedCount, actualCount);
    }
    
    /*
     * @Purpose : Negative test method for trigger 
     */
    public static testMethod void negativeTest(){
        Test.startTest();
        
        Contact[] contacts = createContactRecords();
        Account[] accounts = createVentureRecords();
        Application__c[] applications = createApplicationRecords(accounts);
        Match__c[] matches = createMatchRecords(applications);
        Admitted_Venture__c[] admittedVentures = createAdmittedVentureRecords(applications, matches);
        
        Test.stopTest();
        
        Integer expectedCount = 0;
        Integer actualCount = [SELECT count() FROM Admitted_Venture_Contact__c];
        System.assertEquals(expectedCount, actualCount);
    }
    
    /*
     * @Purpose : Creates contact records
     */
    private static Contact[] createContactRecords(){
        //Get Venture Conatct record type id
        Id ventureConatctId = [SELECT Id 
                               FROM RecordType
                               WHERE Name='Venture Contact'
                             LIMIT 1].Id;
        Contact[] contacts = new List<Contact>();
        for(Integer index=0; index<contactsCount; index ++){
            contacts.add(new Contact(LastName = 'Test' + index, RecordTypeId = ventureConatctId));
        }
        insert contacts;
        return contacts;
    }
    
    /*
     * @Purpose : Creates venture records
     */
    private static Account[] createVentureRecords(){
        //Get Venture Account record type id
        Id ventureAccountId = [SELECT Id 
                               FROM RecordType
                               WHERE Name='Venture Account'
                               LIMIT 1].Id;
        Account[] accounts = new List<Account>();
        for(Integer index=0; index<maxCount; index ++){
            accounts.add(new Account(Name = 'Test' + index, RecordTypeId = ventureAccountId));
        }
        insert accounts;
        return accounts;
    }
    
    /*
     * @Purpose : Creates application records
     */
    private static Application__c[] createApplicationRecords(Account[] accounts){
        Application__c[] applications = new List<Application__c>();
        for(Account account : accounts){
            applications.add(new Application__c(Venture__c = account.Id, Application_Stage__c = 'Applied'));
        }
        insert applications;
        
        return applications;
    }
    
    /*
     * @Purpose : Creates application contact records
     */
    private static Application_Contact__c[] createApplicationContactRecords(Application__c[] applications, Contact[] contacts){
        Application_Contact__c[] applicationContacts = new List<Application_Contact__c>();
        for(Application__c application : applications){
            Integer index = 0;
            for(Contact contact : contacts){
                if(index == 0){
                    applicationContacts.add(new Application_Contact__c(Application__c = application.Id, Contact__c = contact.Id, Primary_Contact__c = true));
                    index ++;
                    continue;
                }
                applicationContacts.add(new Application_Contact__c(Application__c = application.Id, Contact__c = contact.Id));
                index ++;
            }
        }
        insert applicationContacts;
        
        return applicationContacts;
    }
    
    /*
     * @Purpose : Creates match records
     */
    private static Match__c[] createMatchRecords(Application__c[] applications){
        //Creating cdl site record
        CDL_Site__c cdlSite = new CDL_Site__c(Name = 'Test Site');
        insert cdlSite;
        
        //Creating stream record
        Stream__c stream = new Stream__c(Name = 'Test Stream');
        insert stream;
        
        //Creating cohort record
        Cohort__c cohort = new Cohort__c(CDL_Site__c = cdlSite.Id, Stream__c = stream.Id, Cohort_Year__c = '2019-2020', Status__c = 'Active');
        insert cohort;
        
        Match__c[] matches = new List<Match__c>();
        for(Application__c application : applications){
           matches.add(new Match__c(Application__c = application.Id, Cohort__c = cohort.Id));
        }
        insert matches;
        
        return matches;
    }
    
    /*
     * @Purpose : Creates match records
     */
    private static Admitted_Venture__c[] createAdmittedVentureRecords(Application__c[] applications, Match__c[] matches){
        Admitted_Venture__c[] admittedVentures = new List<Admitted_Venture__c>();
        Integer index = 0;
        for(Application__c application : applications){
            admittedVentures.add(new Admitted_Venture__c(Admitted_Venture_Status__c = 'Admitted', 
                                                         Related_Application__c = application.Id,
                                                         Venture__c = application.Venture__c,
                                                         Cohort__c = matches[index].Cohort__c));
            index ++;
        }
        insert admittedVentures;
        return admittedVentures;
    }
}