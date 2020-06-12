@isTest
Private class Test_myMatchVentureListController {
    static testMethod void accountListTest(){
   
        Id p = [select id from profile where name='Community Partners'].id;
           
            Account ac = new Account(name ='TestGrazitti11',recordTypeId='0121I000000W6DP',Related_Stream_s__c='Artificial Intelligence; Blockchain-AI',Technology_Area__c='AI') ;
            insert ac; 
           
            Contact con = new Contact(LastName ='testCon11',AccountId = ac.Id);
            insert con;  
                      
            User user = new User(alias = 'test311', email='test12355511@noemail.com',
                    emailencodingkey='UTF-8', lastname='Testing111', languagelocalekey='en_US',
                    localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                    ContactId = con.Id,
                    timezonesidkey='America/Los_Angeles', username='tester1@noemail.com',Day_1_Stream__c='Prime');
           
            insert user;
                      //Create Document
            ContentVersion cv = new ContentVersion();
            cv.Title = 'Test Document';
            cv.PathOnClient = 'TestDocument.pdf';
            cv.VersionData = Blob.valueOf('Test Content');
            cv.IsMajorVersion = true;
            Insert cv;
             
            //Get Content Documents
            Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
             
            //Create ContentDocumentLink 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = con.Id;
            cdl.ContentDocumentId = conDocId;
            cdl.shareType = 'V';
            Insert cdl;
             currentUserDetailCtrl.fetchUserDetail();
            system.runAs(user) {
                Test.startTest(); 
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
            addVen.Day_1_Stream__c = 'Prime';
            addVen.Admitted_Venture_Status__c='Admitted';
            insert addVen;
            Session__c sessObj = new Session__c();
            sessObj.Cohort__c = cohortObj.id;
            sessObj.Session_Type__c ='Session 1';
            insert sessObj;
            Session__c sessObj1 = new Session__c();
            sessObj1.Cohort__c = cohortObj.id;
            sessObj1.Session_Type__c ='Session 2';
            insert sessObj1;
            Session__c sessObj2 = new Session__c();
            sessObj2.Cohort__c = cohortObj.id;
            sessObj2.Session_Type__c ='Session 3';
            insert sessObj2;
            Session__c sessObj3 = new Session__c();
            sessObj3.Cohort__c = cohortObj.id;
            sessObj3.Session_Type__c ='Session 4';
            insert sessObj3;
  
           /* Session_Attendee__c regObj= new Session_Attendee__c();
            regObj.Admitted_Venture_Raised_For__c = addVen.id;
            regObj.Contact__c = con.Id;
            regObj.Session__c = sessObj.id;
            insert regObj;
            Session_Attendee__c regObj1= new Session_Attendee__c();
            regObj1.Admitted_Venture_Raised_For__c = addVen.id;
            regObj1.Contact__c = con.Id;
            regObj1.Session__c = sessObj1.id;
            insert regObj1;
            Session_Attendee__c regObj2= new Session_Attendee__c();
            regObj2.Admitted_Venture_Raised_For__c = addVen.id;
            regObj2.Contact__c = con.Id;
            regObj2.Session__c = sessObj2.id;
            insert regObj2;
            Session_Attendee__c regObj3= new Session_Attendee__c();
            regObj3.Admitted_Venture_Raised_For__c = addVen.id;
            regObj3.Contact__c = con.Id;
            regObj3.Session__c = sessObj3.id;
            insert regObj3;
            Hand_Raised_Mentor__c handRaisedObj = new Hand_Raised_Mentor__c();
            handRaisedObj.Registration__c = regObj.id;
            handRaisedObj.Admitted_Venture__c = addVen.id;
            handRaisedObj.Contact__c=con.Id;
            insert handRaisedObj;
            Hand_Raised_Mentor__c handRaisedObj1 = new Hand_Raised_Mentor__c();
            handRaisedObj1.Registration__c = regObj1.id;
            handRaisedObj1.Admitted_Venture__c = addVen.id;
            handRaisedObj1.Contact__c=con.Id;
            insert handRaisedObj1;
            Hand_Raised_Mentor__c handRaisedObj2 = new Hand_Raised_Mentor__c();
            handRaisedObj2.Registration__c = regObj2.id;
            handRaisedObj2.Admitted_Venture__c = addVen.id;
            handRaisedObj2.Contact__c=con.Id;
            insert handRaisedObj2;
            Hand_Raised_Mentor__c handRaisedObj3 = new Hand_Raised_Mentor__c();
            handRaisedObj3.Registration__c = regObj3.id;
            handRaisedObj3.Admitted_Venture__c = addVen.id;
            handRaisedObj3.Contact__c=con.Id;
            insert handRaisedObj3;*/
            List<string> admitVentWrap = new List<string>();
            admitVentWrap.add(addVen.id+'&&2');
              List<string> techList = new List<string>();
              techList.add('AI');
                myMatchVentureListController.fetchventurewrapper('test','',false,new List<string>(),techList,true);
                myMatchVentureListController.saveAdmit(admitVentWrap);
                myMatchVentureListController.getStreamList();
                myMatchVentureListController.getSiteList();
                myMatchVentureListController.getRankingList();
                myMatchVentureListController.fetchConInfowrapper(con.Id);
            Test.stopTest();
            }

    }  
}