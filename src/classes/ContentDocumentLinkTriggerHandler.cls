public inherited sharing class ContentDocumentLinkTriggerHandler {
      @future
    public static void onAfterInsert(string contentDocId) {
        String strObjPrefix;
        Set<Id> setCntDocIds = new set<Id>();
        set<Id> setAppIds = new set<Id>();
        map<Id, Application__c> mapApps;
        list<ContentDocumentLink> lstCntLinks = new list<ContentDocumentLink>();
        lstCntLinks = [Select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where id=:contentDocId];
        for(ContentDocumentLink clIterator : lstCntLinks) {
            strObjPrefix = String.valueOf(clIterator.LinkedEntityId).substring(0, 3);
            if(strObjPrefix == Application__c.sObjectType.getDescribe().getKeyPrefix()) {
                setCntDocIds.add(clIterator.ContentDocumentId);
                setAppIds.add(clIterator.LinkedEntityId);
            }
        }
        
        if(!setCntDocIds.isEmpty()) {
            if(!setAppIds.isEmpty()) {
                mapApps = new map<Id, Application__c>([SELECT Id, Name,Application_File_ID__c FROM Application__c WHERE Id IN :setAppIds]);
            }
        }
      
        // Get content version object for current set of files
        map<string, string> mapContentVersions = new map<string, string>();
        for(ContentVersion conVerObj : [SELECT ContentDocumentId,Id,Title FROM ContentVersion WHERE ContentDocumentId IN :setCntDocIds]){
            mapContentVersions.put(conVerObj.ContentDocumentId,conVerObj.id);
        }
 
        Application__c objAcc;
        
        list<Application__c> appList = new list<Application__c>();
        if(!lstCntLinks.isEmpty() && mapApps!=null){
            for(ContentDocumentLink cdlIterator : lstCntLinks) {
              if(mapApps.containsKey(cdlIterator.LinkedEntityId)) {
                    objAcc = mapApps.get(cdlIterator.LinkedEntityId);
                    objAcc.Application_File_ID__c= mapContentVersions.get(cdlIterator.ContentDocumentId);
                    appList.add(objAcc);
                }
                
               
            }
            if(!appList.isEmpty()) {
                update appList;
            }
        }
    }
}