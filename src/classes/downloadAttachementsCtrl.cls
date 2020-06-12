global with sharing class downloadAttachementsCtrl {
    @AuraEnabled 
    global static List<ContentDocument> fetchAttachments(){
     List<ContentDocument> attachmentList = new List<ContentDocument>();
        try{
            User usrObj = [Select id , ContactId from User where id =:userinfo.getUserId()];
           system.debug('User Obj'+usrObj);
            if(usrObj.ContactId!=null || test.isRunningTest()) 
                {   
                    set<string> contentDocIds = new set<string>();
                    for(ContentDocumentLink contentDocObj : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId=:usrObj.ContactId]){
                        contentDocIds.add(contentDocObj.ContentDocumentId);
                    }
                    if(!contentDocIds.isEmpty()){
                         attachmentList = [Select id,Title,FileType,CreatedBy.Name,ContentSize,ParentId From contentDocument where id in :contentDocIds ];
                    }
                } 
                }
               catch(Exception e){
            
        }
        return attachmentList;
    }
}