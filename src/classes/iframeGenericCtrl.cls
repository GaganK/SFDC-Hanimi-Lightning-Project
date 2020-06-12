global without sharing class iframeGenericCtrl {
    @AuraEnabled(cacheable=true)
    global static string getpublicAccess(string conDocumentId){
        string conDocId = conDocumentId;
        System.debug('contentDocumentId'+conDocumentId);
        System.debug('conDocId'+conDocId );
        List<ContentDistribution> contentList = new List<ContentDistribution>();
        contentList = [select DistributionPublicUrl from ContentDistribution where ContentDocumentId =:conDocId];
        string publicUrl = '';
        if(!contentList.isEmpty()){
            publicUrl  = contentList[0].DistributionPublicUrl;
        }
        return publicUrl;
    }
}