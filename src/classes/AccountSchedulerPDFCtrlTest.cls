@isTest
public class AccountSchedulerPDFCtrlTest {
    public static testMethod void AccountSchedulerPDFCtrl_Test(){
        Id p = [select id from profile where name='Community Partners'].id;
           
            Account ac = new Account(name ='TestGrazitti1aa1',recordTypeId='0121I000000W6DP',Related_Stream_s__c='Artificial Intelligence; Blockchain-AI') ;
            insert ac; 
           
            Contact con = new Contact(LastName ='testCoaan1',AccountId = ac.Id);
            insert con;  
                      
            User user = new User(alias = 'test1531', email='test1235551@noemail.com',
                    emailencodingkey='UTF-8', lastname='Testing11', languagelocalekey='en_US',
                    localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                    ContactId = con.Id,
                    timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
           
            insert user;
            
          
            string before = 'Testing base 64 encode';            
            Blob beforeblob = Blob.valueOf(before);
            //Insert contentdocument data
            ContentVersion cv = new ContentVersion();
            cv.title = 'test content trigger';      
            cv.PathOnClient ='test';           
            cv.VersionData =beforeblob;
            cv.Is_Schedule_File__c  = true;     
            insert cv;         
            ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
            ContentDocumentLink newFileShare = new ContentDocumentLink();
            newFileShare.contentdocumentid = testcontent.contentdocumentid;
            newFileShare.LinkedEntityId = con.Id;
            newFileShare.ShareType = 'V';
            insert newFileShare;
              system.runAs(user) {
            test.startTest();
            iframeGenericCtrl.getpublicAccess(testcontent.contentdocumentid);
            AccountSchedulerPDFCtrl.fetchContentDocument();
            test.stopTest();
        }
    }
}