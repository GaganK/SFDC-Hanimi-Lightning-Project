@isTest
public class downloadAttachementsCtrl_Test {
    @isTest static void fetchAttachments_Test()
    {
        Id p = [select id from profile where name='Partner Community User'].id;

                   Account account = new Account();
            account.Online_Submission__c = true;
            account.Name = 'Test Account';
            account.RecordTypeId
              = [select Id from RecordType where sObjectType = 'Account' and Name = 'Venture Account' limit 1].Id;
            account.Phone = '(416) 509-6410';
            account.BillingStreet = '139 The WestWay';
            account.BillingCity = 'Etobicoke';
            account.BillingStateCode = 'ON';
            account.BillingPostalCode = 'M9P 2B6';
            account.BillingCountryCode = 'CA';
            account.NumberOfEmployees = 100;
            account.Industry_Multi__c = 'Apps';
            account.Website = 'www.test.com';
            insert account;
            Contact con = new Contact();
            con.AccountId = account.Id;
            con.Online_Submission__c = true;
            con.RecordTypeId
              = [select Id from RecordType where sObjectType = 'Contact' and Name = 'Venture Contact' limit 1].Id;
            con.Salutation = 'Mr.';
            con.FirstName = 'Test';
            con.LastName = 'Tester';
            con.Gender__c = 'Male';
            con.Phone ='(416) 509-6410';
            con.Email = 'test@test.com';
            con.MailingStreet = '139 The WestWay';
            con.MailingCity = 'Etobicoke';
            con.MailingStateCode = 'ON';
            con.MailingPostalCode = 'M9P 2B6';
            con.MailingCountryCode = 'CA';
            con.Preferred_Language__c = 'English';
            con.Skype_ID__c = 'skypeID';
            con.Twitter_ID__c = 'twitterID';
            con.LinkedIn_Profile__c = 'linkedInID';
            con.Facebook_Page__c = 'faceBookID';
            con.Crunchbase_Profile__c = 'crunchBaseID';
            con.Hacker_News_Link__c = 'hackerNewsID';
            con.GitHub_Page__c = 'gitHubID';
            con.Other_Profile_URL__c = 'otherProfileID';
            insert con;

        User user = new User(alias = 'test123', email='test123@noemail.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p, country='United States',IsActive =true,
        ContactId = con.Id,
        timezonesidkey='America/Los_Angeles', username='tester@noemail.com');

        insert user;
        //system.runAs(user) {

         ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert contentVersionInsert;
 
       ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionInsert.Id LIMIT 1];
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = contentVersionSelect.ContentDocumentId;
        cDe.LinkedEntityId = con.Id; // you can use objectId,GroupId etc
        cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
        cDe.Visibility = 'InternalUsers';
        insert cDe;
        
         ContentVersion contentVersionInsert1 = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test1.jpg',
            VersionData = Blob.valueOf('Test Content1 Data'),
            IsMajorVersion = true
        );
        insert contentVersionInsert1;
          Id AppRecordTypeId = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get('QML').getRecordTypeId();
         Application__c app = new Application__c();
         app.Venture__c = account.Id;
        app.recordTypeId = AppRecordTypeId;
        app.Evaluator_1__c = userinfo.getUserid();
         app.Tech_Specialization__c = 'Prime';
         app.Initial_CDL_Site_Preference__c = 'CDL - Rockies (Calgary)';
         insert app;
       ContentVersion contentVersionSelect1 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionInsert1.Id LIMIT 1];
        ContentDocumentLink cDe1 = new ContentDocumentLink();
        cDe1.ContentDocumentId = contentVersionSelect1.ContentDocumentId;
        cDe1.LinkedEntityId = app.Id; // you can use objectId,GroupId etc
        cDe1.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
        cDe1.Visibility = 'InternalUsers';
        insert cDe1;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        downloadAttachementsCtrl.fetchAttachments();
        System.assertEquals(documents.size(), 2);
        
    }
    //}
}