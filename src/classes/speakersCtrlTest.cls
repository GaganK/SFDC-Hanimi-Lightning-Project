@isTest (SeeAllData=true)
public class speakersCtrlTest
{
 static testMethod void testMethod1() 
 {
 Account testAccount = new Account();
 testAccount.Name='Test Account123455';
 testAccount.Related_Stream_s__c='Health'; 
 insert testAccount;
 Contact con = new Contact();
 con.Firstname = 'Test Con';
 con.Lastname = 'Last Con';
 con.Speaker__c = true;
 con.Site_Location__c='Ontario';
 con.mailingCountry='Canada';
insert con;
 Contact con1 = new Contact();
 con1.Firstname = 'Test Con1';
 con1.Lastname = 'Last Con1';
 con1.Is_ML_Speaker__c = true;
 con1.Is_Partner__c =true;
 con1.Speaker__c =true;
 con1.Site_Location__c='Ontario';
 con1.mailingCountry='Canada';
insert con1;
string before = 'Testing base 64 encode';            
Blob beforeblob = Blob.valueOf(before);
//Insert contentdocument data
ContentVersion cv = new ContentVersion();
cv.title = 'test content trigger';      
cv.PathOnClient ='test';           
cv.VersionData =beforeblob;
cv.Is_Speaker_Photo__c  = true;     
insert cv;         
ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
ContentDocumentLink newFileShare = new ContentDocumentLink();
newFileShare.contentdocumentid = testcontent.contentdocumentid;
newFileShare.LinkedEntityId = con1.Id;
newFileShare.ShareType = 'V';
insert newFileShare;
 Test.StartTest(); 
   speakersCtrl.getFetchSpeakerMap();
   SlackDetailCtrl.fetchSlackUrlDetail();
 Test.StopTest();
 }
}