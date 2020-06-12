@isTest
Private class Test_accountListController {
    
    @testsetup
    static void methodName() {
        
        Id p = [select id from profile where name='Community Partners'].id;
       
        Account ac = new Account(name ='TestGrazitti11',recordTypeId='0121I000000W6DP',Related_Stream_s__c='Artificial Intelligence; Blockchain-AI') ;
        insert ac; 
       
        Contact con = new Contact(LastName ='testCon1',AccountId = ac.Id);
        insert con;  
                  
        User user = new User(alias = 'test1531', email='test1235551@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing11', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                ContactId = con.Id,
                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
       
        insert user;
    }
    
    static testMethod void accountListTest(){
        
        Test.startTest();
        
        Account ac = [SELECT Id FROM Account WHERE name='TestGrazitti11' LIMIT 1];
        Contact con = [SELECT Id FROM Contact WHERE accountId =: ac.Id LIMIT 1];
        User user = [SELECT Id FROM User WHERE ContactId =: con.Id LIMIT 1 ];
            
        CDL_Site__c cdlSite = new CDL_Site__c();
        cdlSite.Name = 'TestSite';
        insert cdlSite;
        
        Stream__c streamObj = new Stream__c();
        streamObj.Name = 'TestStream';
        insert streamObj;
        
        Cohort__c cohortObj = new Cohort__c();
        cohortObj.CDL_Site__c = cdlSite.id;
        cohortObj.Stream__c = streamObj.id;
        cohortObj.Cohort_Year__c='2019-2020';
        cohortObj.Status__c='Active';
        cohortObj.Cohort_Num__c = 1;
        insert cohortObj;
            
        Cohort_Contact__c chortObj = new Cohort_Contact__c();
        chortObj.Contact__c =con.Id;
        chortObj.Cohort__c = cohortObj.id;
        insert chortObj;
        
        Admitted_Venture__c addVen = new Admitted_Venture__c();
        addVen.Cohort__c = cohortObj.id;
        addVen.Venture__c = ac.id;
        addVen.Admitted_Venture_Status__c='Admitted';
        insert addVen;
        
        
        
        Test.stopTest();
            
        system.runAs(user) {
            
            Partner_Questionnaire__c objPartnerQuestionaire = new Partner_Questionnaire__c();
            objPartnerQuestionaire.Account_Name__c = ac.Id;        
            insert objPartnerQuestionaire;
        
            accountListController.fetchaccwrapper();
            accountListController.fetchUserId();
            List<Partner_Questionnaire__c> partQuest = new List<Partner_Questionnaire__c>();
            accountListController.updatePartnerQuestions(partQuest);
            currentUserDetailCtrl.fetchUserDetail();
        }

    }  
}