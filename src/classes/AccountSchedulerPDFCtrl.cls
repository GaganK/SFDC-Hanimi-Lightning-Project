public class AccountSchedulerPDFCtrl {
    @AuraEnabled 
    public static string fetchContentDocument(){
   id userId = UserInfo.getUserId();
    User u = [select id, Contact.AccountId from User where id = : userId];
   //string ParentId ='0014g000002QiQD';
  string ParentId =u.ContactId;
     set<string> ContentDocumentIds = new set<string>();
      set<string> finalContentDocIds = new set<string>();
      String scheduleRecId ='';
         for(ContentDocumentLink conLink : [Select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId = : ParentId]){
                ContentDocumentIds.add(conLink.ContentDocumentId);          
            }
        for(ContentVersion conVersion : [Select id,VersionData, ContentDocumentId,IsLatest from ContentVersion where ContentDocumentId in : ContentDocumentIds and IsLatest=true and Is_Schedule_File__c =true limit 1]){
           scheduleRecId = conVersion.ContentDocumentId;
          }
          return scheduleRecId ;
          
    }
}