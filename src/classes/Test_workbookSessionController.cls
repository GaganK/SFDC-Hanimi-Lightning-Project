@isTest
Private class Test_workbookSessionController {
    static testMethod void accountListTest(){
        Id p = [select id from profile where name='Community Partners'].id;
           
            Account ac = new Account(name ='TestGrazitti1111',recordTypeId='0121I000000W6DP',Related_Stream_s__c='Artificial Intelligence; Blockchain-AI') ;
            insert ac; 
           
            Contact con = new Contact(LastName ='testCon111',AccountId = ac.Id);
            insert con;  
                      
            User user = new User(alias = 'test3111', email='test123555111@noemail.com',
                    emailencodingkey='UTF-8', lastname='Testing11', languagelocalekey='en_US',
                    localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                    ContactId = con.Id,
                    timezonesidkey='America/Los_Angeles', username='tester11@noemail.com');
           
            insert user;
            
            system.runAs(user) {
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
            insert cohortObj;
            /*Cohort_Contact__c chortObj = new Cohort_Contact__c();
            chortObj.Contact__c =con.Id;
            chortObj.Cohort__c = cohortObj.id;
            insert chortObj;*/
            Admitted_Venture__c addVen = new Admitted_Venture__c();
            addVen.Cohort__c = cohortObj.id;
            addVen.Venture__c = ac.id;
            addVen.Admitted_Venture_Status__c='Admitted';
            insert addVen;
                workbookSessionController.fetchaccwrapper();
                workbookSessionController.fetchUserId();
                 List<Partner_Questionnaire__c> partQuest = new List<Partner_Questionnaire__c>();
                workbookSessionController.updatePartnerQuestions(partQuest);
                currentUserDetailCtrl.fetchUserDetail();
            }

    }  
}