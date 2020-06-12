/*
CreatedDate - 20/Feb/202
Purpose - Test class to cover CDL_MentorContactsController
Classname - CDL_MentorContactsControllerTest

*/


@isTest
private class CDL_MentorContactsControllerTest {

	private static testMethod void validateSearch() {
	    
	    List<String> filteredSites = new List<String>();
	    List<String> filteredStreams = new List<String>();
	    
	    Stream__c testStream = new Stream__c(Name = 'Health', Active__c = true);
        insert testStream;
        
        CDL_Site__c testSite = new CDL_Site__c(Name = 'CDL - Toronto', Active__c = true);
        insert testSite;
        
        Cohort__c objCohort = new Cohort__c(CDL_Site__c = testSite.Id, Stream__c = testStream.Id, Cohort_Year__c = '2019-2020', Status__c='Active', Cohort_Num__c = 1);
        insert objCohort;
        
        Admitted_Venture__c objAV = new Admitted_Venture__c(Cohort__c = objCohort.Id,Admitted_Venture_Status__c = 'Admitted');
        insert objAV;
        
        Id ventorAccountId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Venture').getRecordTypeId();
        Account account = new Account(Name = 'Test', RecordTypeId = ventorAccountId);
        insert account;
        
        Id mentorRecordId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Mentor_Contact').getRecordTypeId();
        
        Contact mentor = new Contact(AccountId = account.Id, RecordTypeId = mentorRecordId, LastName = 'Test', Biodata__c = testSite.Name, Contact_Type__c = 'Fellow;Associate', Site_and_Stream__c = 'CDL - Toronto: Health');
        insert mentor;
        
        Hand_Raised_Mentor__c objHRM = new Hand_Raised_Mentor__c(Contact__c = mentor.Id, Admitted_Venture__c = objAV.Id);
        insert objHRM;
        
        filteredStreams.add(testStream.Name);
        List<CDL_MentorContactsController.MentorWrapper> lstMentorWrapper = CDL_MentorContactsController.fetchMentorContacts(mentor.LastName, filteredSites, filteredStreams);
        system.assertEquals(lstMentorWrapper[0].objContact.Id, mentor.Id);

        filteredSites.add(testSite.Name);
        lstMentorWrapper = CDL_MentorContactsController.fetchMentorContacts(mentor.LastName, filteredSites, filteredStreams);
        system.assertEquals(lstMentorWrapper[0].objContact.Id, mentor.Id);
	}
	
	private static testMethod void validateSitesAndStreamOptions() {
	    validateSearch();
	    test.startTest();
	    CDL_MentorContactsController.FilterWrapper objFilterWrapper = CDL_MentorContactsController.fetchSitesAndStreamOptions();
	    system.assertEquals(objFilterWrapper.sites[0].label, 'CDL - Toronto');
	    test.stopTest();
	}
}