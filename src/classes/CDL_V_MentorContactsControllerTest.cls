@isTest
public class CDL_V_MentorContactsControllerTest {
	
    private static testMethod void validateSearch() {
	    
	    List<String> filteredSites = new List<String>();
	    List<String> filteredStreams = new List<String>();
	    
	    Stream__c testStream = new Stream__c(Name = 'Prime');
        insert testStream;
        
        CDL_Site__c testSite = new CDL_Site__c(Name = 'CDL - Toronto');
        insert testSite;
        
        Cohort__c objCohort = new Cohort__c(CDL_Site__c = testSite.Id, Stream__c = testStream.Id, Cohort_Year__c = '2019-2020', Status__c='Active', Cohort_Num__c = 1);
        insert objCohort;
        
        
        Admitted_Venture__c objAV = new Admitted_Venture__c(Cohort__c = objCohort.Id,Admitted_Venture_Status__c = 'Admitted');
        insert objAV;
        
        Id ventorAccountId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Venture').getRecordTypeId();
        Account acc = new Account(Name = 'Test', RecordTypeId = ventorAccountId);
        insert acc;
        
        
        Id mentorRecordId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Mentor_Contact').getRecordTypeId();
        
        Contact con = new Contact(AccountId = acc.Id,
            RecordTypeId = mentorRecordId,
            LastName = 'Test',
            Biodata__c = testSite.Name,
            Contact_Type__c = 'Fellow',
            Site_and_Stream__c = 'CDL - Toronto: Health; CDL - Atlantic: Prime');
        insert con;
        
        Interested_Mentor__c objIM = new Interested_Mentor__c(Admitted_Venture__c = objAV.Id,Contact__c = con.Id);
        insert objIM;
        
        Hand_Raised_Mentor__c objHRM = new Hand_Raised_Mentor__c(Contact__c = con.Id, Admitted_Venture__c = objAV.Id);
        insert objHRM;
        
        
        //filteredSites.add(testSite.Name);
        //filteredStreams.add(testStream.Name);
        List<CDL_MentorContactsController.MentorWrapper> lstMentorWrapper = CDL_MentorContactsController.fetchMentorContacts(con.LastName, filteredSites, filteredStreams);
        system.assertEquals(lstMentorWrapper[0].objContact.Id, con.Id);
	}
	
	
	private static testMethod void validateSitesAndStreamOptions() {

	    validateSearch();
	    test.startTest();
	    CDL_MentorContactsController.FilterWrapper objFilterWrapper = CDL_MentorContactsController.fetchSitesAndStreamOptions();
	    system.assertEquals(objFilterWrapper.sites[0].label, 'CDL - Toronto');
	    test.stopTest();
	}
}