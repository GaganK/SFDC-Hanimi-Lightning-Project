@isTest
Private class Test_myPreferenceVentureListController {
    static testMethod void accountListTest(){
        Id p = [select id from profile where name='Community Partners'].id;
           
            Account ac = new Account(name ='TestGrazii11',recordTypeId='0121I000000W6DP',Related_Stream_s__c='Artificial Intelligence; Blockchain-AI') ;
            insert ac; 
           
            Contact con = new Contact(LastName ='test1Con11',AccountId = ac.Id);
            insert con;  
                      
            User user = new User(alias = 'test011', email='test125511@noemail.com',
                    emailencodingkey='UTF-8', lastname='Testing111', languagelocalekey='en_US',
                    localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                    ContactId = con.Id,
                    timezonesidkey='America/Los_Angeles', username='tester01@noemail.com');
           
            insert user;
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
            /*Cohort_Contact__c chortObj = new Cohort_Contact__c();
            chortObj.Contact__c =con.Id;
            chortObj.Cohort__c = cohortObj.id;
            insert chortObj;*/
            Admitted_Venture__c addVen = new Admitted_Venture__c();
            addVen.Cohort__c = cohortObj.id;
            addVen.Venture__c = ac.id;
            addVen.Admitted_Venture_Status__c='Admitted';
            insert addVen;
            Interested_Mentor__c  intMentObj = new Interested_Mentor__c ();
            intMentObj.Admitted_Venture__c = addVen.id;
            intMentObj.Contact__c = con.Id;
            intMentObj.Ranking__c = '1';
            intMentObj.Is_Match__c =true;
            insert intMentObj;
            system.runAs(user) {
   

                myPreferenceVentureListController.fetchventurewrapper('test','',false,new List<string>(),new List<string>());
                myPreferenceVentureListController.getStreamList();
                myPreferenceVentureListController.getSiteList();
                myPreferenceVentureListController.getRankingList();
                myPreferenceVentureListController.fetchConInfowrapper(con.Id);
            }

    }  
}