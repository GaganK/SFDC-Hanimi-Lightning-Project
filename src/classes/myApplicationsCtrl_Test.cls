@isTest
public class myApplicationsCtrl_Test{ 
    
    public static testMethod void appTest1(){
        
        List<User> lstuser = new List<User>();
        List<String> lst1stPreference = new List<String>();
        List<String> lst2ndPreference = new List<String>();
        List<String> filteredEvaluator1 = new List<String>();
        List<String> filteredEvaluator2 = new List<String>();
        List<String> filteredStreamPotentials = new List<String>();
        List<String> filteredEvaluator3 = new List<String>();
        List<String> applicationIds = new List<String>();
        List<String> ventureNames = new List<String>();
        List<String> applicationNumbers = new List<String>();
        List<String> ventureHeadquarters = new List<String>();

        
        Test.startTest();
        Id ventorAccountId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Venture').getRecordTypeId();
        Account acc = new Account(Name = 'Test', RecordTypeId = ventorAccountId);
        insert acc;
        
        
        
        User u = new User(
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
        
        User u1 = new User(
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
        
        User u2 = new User(
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
        
       
        lstuser.add(u);
        lstuser.add(u1);
        lstuser.add(u2);
        insert lstuser;
        
        Application__c objApplication = new Application__c(Venture_Overview_Briefly_describe_your__c = 'Test', Venture__c = acc.Id, X1st_Preference_CDL_Location__c = 'CDL-Montreal (Montreal, CA)', X2nd_Preference_CDL_Location__c ='CDL-Rockies (Calgary, CA)',Tech_Specialization__c = 'Prime',
                                                           Evaluator_1__c =u.Id , Evaluator_2__c = u1.Id, Evaluator_3__c=u2.id, Application_Stage__c = 'Applied');
        insert objApplication;
        
        
        
        lst1stPreference.add(objApplication.X1st_Preference_CDL_Location__c);
        lst2ndPreference.add(objApplication.X2nd_Preference_CDL_Location__c);
        
        filteredEvaluator1.add(u.Id);
        filteredEvaluator2.add(u1.Id);
        filteredEvaluator3.add(u2.Id);
        filteredStreamPotentials.add(objApplication.Application_Stage__c);
        String sortField ='Name';
        Boolean sortAsc = true;
        applicationIds.add(objApplication.Id);
        
        myApplicationsCtrl.getApplications(acc.Name,lst1stPreference,lst2ndPreference,filteredEvaluator1,filteredEvaluator2,filteredEvaluator3,filteredStreamPotentials,applicationNumbers,ventureNames,ventureHeadquarters,sortField,sortAsc);
        myApplicationsCtrl.updateEvaluator(objApplication.Id, 'Evaluator_2__c', u1.Id);
        myApplicationsCtrl.copyEvaluatorToAllApplication('Evaluator_2__c', u1.Id,applicationIds,acc.Name,lst1stPreference,lst2ndPreference,filteredEvaluator1,filteredEvaluator2,filteredEvaluator3,filteredStreamPotentials,applicationNumbers,ventureNames,ventureHeadquarters,sortField,sortAsc);
        myApplicationsCtrl.getFilters();
        myApplicationsCtrl.fetchLookUpValues('Test');
        
        
    }
}