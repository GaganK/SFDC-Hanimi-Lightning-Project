@isTest
public class CrossSiteMatchingAndFinalInterviewTest {

    public static testMethod void crossSiteMatchingTest(){
        
        List<User> evaluators = new List<User>();
        List<Application__c> applications = new List<Application__c>();
        List<String> filteredFirstSitePreference = new List<String>();
        List<String> filteredSecondSitePreference = new List<String>();
        List<String> filteredApplicationNumbers = new List<String>();
        List<String> filteredVentures = new List<String>();
        List<String> filteredVentureHeadQuarters = new List<String>();
        List<String> filteredTeamStreamRecommendations = new List<String>();
        List<String> filteredTeamInterviewDecisions = new List<String>();
        List<String> filteredRecommendedByFirstSitePreferences = new List<String>();
        List<String> filteredCrossSiteMatchings = new List<String>();
        List<String> filteredInterviewStatus = new List<String>();
        List<String> filteredLeadInterviewers = new List<String>();
        List<String> filteredGuestInterviewers = new List<String>();
        List<String> filteredPrimaryContacts = new List<String>();
        List<String> filteredInterviewMadalities = new List<String>();
        List<String> filteredInterviewTimeZones = new List<String>();

        Id ventorAccountId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Venture').getRecordTypeId();
        Account venture = new Account(Name = 'Test', RecordTypeId = ventorAccountId, BillingCountry = 'Canada');
        insert venture;
        
        Contact primaryContact = new contact(LastName = 'Broker', AccountId=venture.Id);
        insert primaryContact;
        
        User evaluator1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Test1',
            Email = 'test1EvalutorGreen@amamama.com',
            Username = 'test1EvalutorGreen@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        
        User evaluator2 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Test2',
            Email = 'test2EvalutorGreen@amamama.com',
            Username = 'test1EvalutorGreen@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        
        User evaluator3 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Test3',
            Email = 'test3EvalutorGreen@amamama.com',
            Username = 'test1EvalutorGreen@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
       
        evaluators.add(evaluator1);
        evaluators.add(evaluator2);
        evaluators.add(evaluator3);
        insert evaluators;
        
        Application__c objApplication1 = new Application__c(Venture_Overview_Briefly_describe_your__c = 'Test', 
                                                            Venture__c = venture.Id, 
                                                            X1st_Preference_CDL_Location__c = 'CDL-Montreal (Montreal, CA)', 
                                                            X2nd_Preference_CDL_Location__c ='CDL-Rockies (Calgary, CA)',
                                                            Team_Stream_Recommendation__c = 'Blockchain-AI',
                                                            Team_Interview_Decision__c = 'Yes',
                                                            Recommended_by_First_Site_Preference_for__c = 'CDL - Atlantic',
                                                            Cross_Site_Matching__c = 'CDL - Global;CDL - Oxford',
                                                            Interview_Status__c = 'Guest Interview Scheduled',
                                                            Application_Primary_Contact__c = primaryContact.Id,
                                                            Interview_Modality__c = 'Remote',
                                                            Interview_Timezone__c = 'BST (GMT +1)',
                                                            Tech_Specialization__c = 'Prime',
                                                            Application_Stage__c = 'Applied');
        
        Application__c objApplication2 = new Application__c(Venture_Overview_Briefly_describe_your__c = 'Test', 
                                                            Venture__c = venture.Id, 
                                                            X1st_Preference_CDL_Location__c = 'CDL-Montreal (Montreal, CA)', 
                                                            X2nd_Preference_CDL_Location__c ='CDL-Rockies (Calgary, CA)',
                                                            Team_Stream_Recommendation__c = 'Blockchain-AI',
                                                            Team_Interview_Decision__c = 'Yes',
                                                            Recommended_by_First_Site_Preference_for__c = 'CDL - Atlantic',
                                                            Cross_Site_Matching__c = 'CDL - Global;CDL - Oxford',
                                                            Interview_Status__c = 'Guest Interview Scheduled',
                                                            Application_Primary_Contact__c = primaryContact.Id,
                                                            Interview_Modality__c = 'Remote',
                                                            Interview_Timezone__c = 'BST (GMT +1)',
                                                            Tech_Specialization__c = 'Prime',
                                                            Application_Stage__c = 'Applied');

        applications.add(objApplication1);
        applications.add(objApplication2);

        insert applications;
        
        filteredFirstSitePreference.add(objApplication1.X1st_Preference_CDL_Location__c);
        filteredSecondSitePreference.add(objApplication1.X2nd_Preference_CDL_Location__c);
        filteredVentures.add(venture.Name);
        filteredTeamStreamRecommendations.add(objApplication1.Team_Stream_Recommendation__c);
        filteredTeamInterviewDecisions.add(objApplication1.Team_Interview_Decision__c);
        filteredRecommendedByFirstSitePreferences.add(objApplication1.Recommended_by_First_Site_Preference_for__c);
        filteredCrossSiteMatchings.add(objApplication1.Cross_Site_Matching__c);
        filteredInterviewStatus.add(objApplication1.Interview_Status__c);
        filteredPrimaryContacts.add(primaryContact.LastName);
        filteredInterviewMadalities.add(objApplication1.Interview_Modality__c);
        filteredInterviewTimeZones.add(objApplication1.Interview_Timezone__c);
        String sortField ='Name';
        Boolean sortAsc = true;
        
        Test.startTest();

        CrossSiteMatchingAndFinalInterviewCtrl.FilterWrapper objFilterWrapper = new CrossSiteMatchingAndFinalInterviewCtrl.FilterWrapper();
        objFilterWrapper = CrossSiteMatchingAndFinalInterviewCtrl.getFilters();

        //To validate if filter options are being fetched properly
        system.assertEquals(false,objFilterWrapper.firstSitePreferances.isEmpty());
        
        List<CrossSiteMatchingAndFinalInterviewCtrl.ApplicationWrapper> lstApplicationWrapper = CrossSiteMatchingAndFinalInterviewCtrl.getApplications(venture.Name,filteredFirstSitePreference,filteredSecondSitePreference,filteredApplicationNumbers,filteredVentures,filteredVentureHeadQuarters,filteredTeamStreamRecommendations,filteredTeamInterviewDecisions,filteredRecommendedByFirstSitePreferences,filteredCrossSiteMatchings,filteredInterviewStatus,filteredLeadInterviewers,filteredGuestInterviewers,filteredPrimaryContacts,filteredInterviewMadalities,filteredInterviewTimeZones,sortField,sortAsc);
        //To validate filters
        system.assertEquals(2,lstApplicationWrapper.size());

        CrossSiteMatchingAndFinalInterviewCtrl.updateApplicationValue(objApplication1.Id, 'Lead_Interviewer__c', evaluator2.Id,false,false);
        CrossSiteMatchingAndFinalInterviewCtrl.updateApplicationValue(objApplication1.Id, 'Guest_Interviewer__c', evaluator3.Id,false,false);
        CrossSiteMatchingAndFinalInterviewCtrl.updateApplicationValue(objApplication1.Id, 'Interview_Date_Time__c',String.valueOf(DateTime.now()),false,true);
        CrossSiteMatchingAndFinalInterviewCtrl.updateApplicationValue(objApplication1.Id, 'Post_Interview_Email_Sent__c',String.valueOf(Date.today()),true,false);

        CrossSiteMatchingAndFinalInterviewCtrl.updateApplicationValue(objApplication2.Id, 'Lead_Interviewer__c', evaluator3.Id,false,false);
        CrossSiteMatchingAndFinalInterviewCtrl.updateApplicationValue(objApplication2.Id, 'Guest_Interviewer__c', evaluator2.Id,false,false);

        Application__c objApplicationFetched = [SELECT Lead_Interviewer__c,Guest_Interviewer__c FROM Application__c WHERE Id=: objApplication1.Id];
        //To validate data update
        system.assertEquals(objApplicationFetched.Lead_Interviewer__c,evaluator2.Id);
        system.assertEquals(objApplicationFetched.Guest_Interviewer__c,evaluator3.Id);
        
        Application__c objApplicationFetched2 = [SELECT Lead_Interviewer__r.Name,Guest_Interviewer__r.Name FROM Application__c WHERE Id=: objApplication2.Id];
        filteredLeadInterviewers.add(objApplicationFetched2.Lead_Interviewer__r.Name);
        filteredGuestInterviewers.add(objApplicationFetched2.Guest_Interviewer__r.Name);
        lstApplicationWrapper = CrossSiteMatchingAndFinalInterviewCtrl.getApplications(venture.Name,filteredFirstSitePreference,filteredSecondSitePreference,filteredApplicationNumbers,filteredVentures,filteredVentureHeadQuarters,filteredTeamStreamRecommendations,filteredTeamInterviewDecisions,filteredRecommendedByFirstSitePreferences,filteredCrossSiteMatchings,filteredInterviewStatus,filteredLeadInterviewers,filteredGuestInterviewers,filteredPrimaryContacts,filteredInterviewMadalities,filteredInterviewTimeZones,sortField,sortAsc);
        system.assertEquals(1,lstApplicationWrapper.size());
        
        Test.stopTest();
    }
}