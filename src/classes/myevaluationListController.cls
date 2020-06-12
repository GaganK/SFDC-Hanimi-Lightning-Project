public class myevaluationListController{
  @AuraEnabled 
    public static List<applicationEvaluationWrapper> fetchAppwrapper(List<string> selectedApplications,List<string> selectedVentures, List<string> selectedStreamPotential,String currentselectedAppType,List<string> selectedFirstSitePreference,
                                                                    List<String> selectedsecondsitepreference,List<String> selectreferal,String searchTerm, String sortField, Boolean sortAsc,List<String> selectInterviewRecommendation,List<String> selectStreamRecommendation,List<String> selectTechStreamRecommendation,List<String> selectSiteReferral,List<String> selectReasonRecommendation){     
         List<Application__c> appList = new List<Application__c>();
         List<applicationEvaluationWrapper> wcList = new List<applicationEvaluationWrapper>();
               String query = 'SELECT Id,One_line_description__c,Venture__r.Website,X2nd_Preference_CDL_Location__c,X1st_Preference_CDL_Location__c,Application_Primary_Contact__r.LinkedIn_URL__c,Venture__r.BillingStreet,Venture__r.BillingCity,Venture__r.BillingState,Venture__r.BillingCountry,Name,Application_URL__c,Required_Evaluations__c,Application_Referral_Name__c,Master_Ranking__c,Ranking__c,Number_of_Co_Founders__c ,Sum_Superstar_Potential__c,Sum_Tech_Review__c,Sum_Business_Review__c,Overall_Score__c,Avg_Score_Superstar_Potential__c,Tech_Specialization__c,Venture__c,Application_Primary_Contact__r.Name,Venture_Overview_Briefly_describe_your__c,Application_Primary_Contact__r.Phone,Application_Primary_Contact__r.Email,Application_Primary_Contact__r.Id,Venture__r.Name,Venture__r.Description_Venture__c,Other_Disqualification_Reason__c,Reason_for_Disqualification__c FROM Application__c where CreatedDate =LAST_N_DAYS:365 ';
               string loggedUserId = Userinfo.getUserId();                                                     
               if(currentselectedAppType == 'Self'){
                    
                    if(String.isNotBlank(loggedUserId)) {
                        query = query + ' AND (Evaluator_1__c = \'' + loggedUserId + '\' OR Evaluator_2__c = \'' + loggedUserId + '\' OR Evaluator_3__c = \'' + loggedUserId + '\')';
                    }
               }                                                        
               /* if(!selectfinalrank.isEmpty()) {
                    integer value;
                query = query + ' AND EvaluatorsRanking__c IN ';
                    for(String includeValue :selectfinalrank)
                        value = integer.valueOf(includeValue);
                        query += '\''+ value + '\'' + ',';
                    query = query.removeEnd(',') ;
                     
                }*/
               if(!selectedApplications.isEmpty()) {
                   if(selectedApplications.size()==1){
                    query = query + ' AND Name Like ';
                        for(String includeValue :selectedApplications)
                            query += '\''+ includeValue + '\'' + ',';
                        query = query.removeEnd(',') ;
                   }else {
                        query += ' AND Name IN : selectedApplications ';
                   }
                     
                }
                if(!selectedFirstSitePreference.isEmpty()) {
                    
                   
                     query = query + ' AND X1st_Preference_CDL_Location__c  IN(';
                    for(String includeValue :selectedFirstSitePreference)
                        query += '\''+ includeValue + '\'' + ',';
                    query = query.removeEnd(',') +')'; 
                }
                if(!selectedsecondsitepreference.isEmpty()) {
                   
                     query = query + ' AND X2nd_Preference_CDL_Location__c  IN(';
                    for(String includeValue :selectedsecondsitepreference)
                        query += '\''+ includeValue + '\'' + ',';
                    query = query.removeEnd(',') +')'; 
                }
                if(!selectedVentures.isEmpty()) {
                    if(selectedVentures.size()==1){
                     query = query + ' AND Venture__r.Name Like '; 
                      for(String includeValue :selectedVentures)
                        query += '\''+ includeValue + '\'' + ',';
                    query = query.removeEnd(',') ;
                    }else {
                        query += ' AND Venture__r.Name IN : selectedVentures ';
                   }
                    
                }
                if(!selectreferal.isEmpty()) {
                    if(selectreferal.size()==1){
                     query = query + ' AND Application_Referral_Name__c Like '; 
                      for(String includeValue :selectreferal)
                        query += '\''+ includeValue + '\'' + ',';
                    query = query.removeEnd(',') ;
                    }else {
                        query += ' AND Application_Referral_Name__c IN : selectreferal ';
                   }
                    
                }
                if(!selectedStreamPotential.isEmpty()) {
                    
                     query = query + ' AND Tech_Specialization__c  INCLUDES(';
                    for(String includeValue :selectedStreamPotential)
                        query += '\''+ includeValue + '\'' + ',';
                    query = query.removeEnd(',') +')'; 
                }
                if(!String.isBlank(searchTerm)) {
                    query += ' AND ( ';
                    String tempSearchTerm = String.escapeSingleQuotes(searchTerm.trim());
                     Set<Id> appIds = getMatchingVentureOverview(tempSearchTerm);
                    searchTerm = '\'%' + tempSearchTerm + '%\'';
                    query += ' Name like ' + searchTerm + ' ';
                    query += ' OR X1st_Preference_CDL_Location__c like ' + searchTerm + ' ';
                    query += ' OR X2nd_Preference_CDL_Location__c like ' + searchTerm + ' ';
                    query += ' OR Venture__r.Name like ' + searchTerm + ' ';
                    query += ' OR Venture__r.Headquarters__c like ' + searchTerm + ' ';
                    query += ' OR Venture__r.Website like ' + searchTerm + ' ';
                    query += ' OR Application_Primary_Contact__r.Name like ' + searchTerm + ' ';
                    query += ' OR Application_Primary_Contact__r.LinkedIn_Profile__c like ' + searchTerm + ' ';
                    query += ' OR Application_Referral_Name__c like ' + searchTerm + ' ';
                    if(!appIds.isEmpty()) {
                        query += ' OR Id IN : appIds ';
                    }       
                    query += ' ) ';
                } 
               /* if(!selectedMaster.isEmpty()) {
                     query = query + ' AND Master_Ranking__c IN :selectedMaster'; 
                     
                }
                if(!selectedComputed.isEmpty()) {
                     query = query + ' AND Ranking__c IN : selectedComputed '; 
                     
                }
                if(!selectedSuperStar.isEmpty()) {
                     query = query + ' AND Sum_Superstar_Potential__c IN :  selectedSuperStar'; 
                }
                if(!selectedTech.isEmpty()) {
                     query = query + ' AND Sum_Tech_Review__c IN : selectedTech'; 
                }
                if(!selectedBiz.isEmpty()) {
                     query = query + ' AND Sum_Business_Review__c IN : selectedBiz '; 
                }
                if(!selectedOverall.isEmpty()) {
                     query = query + ' AND Overall_Score__c IN :  selectedOverall'; 
                }
                  */
             if(!String.isBlank(sortField) && sortField!='EvaluatorsRanking__c' && sortField!='Superstar_Potential__c' && sortField!='Tech_Review__c'
                && sortField!='Business_Review__c') {
             query += ' order by ' + sortField + ' ';
             } else {
             query += ' order by Name ';
            }

            if(sortAsc) {

                query += ' ASC ';
            } else {

                query += ' DESC ';
            }

    query += ' NULLS LAST ';
                 query = query + '  LIMIT 2000 ';
                System.debug('query*****************'+query);

    appList = Database.query(query);
                 system.debug(appList);
    if(!appList.isEmpty()){
        map<string,string> mapToApp = new map<string,string>();
         map<string,Evaluation__c> mapToEvaObj = new map<string,Evaluation__c>();
        map<string,Decimal> mapToevalRanking = new map<string,Decimal>();
        set<string> appidsSet = new set<string>();
        for(Application__c appObj :appList ){
            appidsSet.add(appObj.id);
            
        }
        Map<String,ContentVersion> MapToContentVersion = new  Map<String,ContentVersion>();
        if(!appidsSet.isEmpty()){
        
            for(Evaluation__c evaObj : [select id,Flag__c,Comments__c,Application__c,Other_Flag__c,General_Comments__c,CDL_Evaluator__c,Recommendation_Reasonsing__c,Reason_for_Recommending_Other_Site__c,Tech_Screening_Recommendation__c,Refer_to_Other_Site__c,EvaluatorsRanking__c,Recommend_Interview_2__c,Stream_Recommendation__c,Superstar_Potential__c,Comments_Superstar_Potential__c,Tech_Review__c,Comments_Tech_Review__c,Business_Review__c,Comments_Business_Review__c,Application__r.Overall_Score__c from Evaluation__c where Application__c  in :appidsSet and CDL_Evaluator__c= :loggedUserId]){
                mapToApp.put(evaObj.Application__c+'&&'+evaObj.CDL_Evaluator__c,evaObj.Recommendation_Reasonsing__c);
                mapToEvaObj.put(evaObj.Application__c+'&&'+evaObj.CDL_Evaluator__c,evaObj);
                mapToevalRanking.put(evaObj.Application__c+'&&'+evaObj.CDL_Evaluator__c,evaObj.EvaluatorsRanking__c);
            }
           Set<Id> setCntDocIds = new set<Id>();
            Map<String, String> mapToLinkedId = new  Map<String, String>();
            for(ContentDocumentLink clIterator : [Select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId in :appidsSet]) {
                  setCntDocIds.add(clIterator.ContentDocumentId);
                  mapToLinkedId.put(clIterator.ContentDocumentId,clIterator.LinkedEntityId);
            }
             if(!setCntDocIds.isEmpty()) {
                 for(ContentVersion conVerObj : [SELECT ContentDocumentId,Id,Title FROM ContentVersion WHERE ContentDocumentId IN :setCntDocIds order by lastmodifiedDate Desc limit 1]){
                    if(mapToLinkedId.ContainsKey(conVerObj.ContentDocumentId) && mapToLinkedId.get(conVerObj.ContentDocumentId)!=null)
                        MapToContentVersion.put(mapToLinkedId.get(conVerObj.ContentDocumentId),conVerObj);
                }
             }  
        }
        for(Application__c appObj : appList){
            Evaluation__c evaObj;
            if(mapToEvaObj.containsKey(appObj.id+'&&'+Userinfo.getUserId()) && mapToEvaObj.get(appObj.id+'&&'+Userinfo.getUserId())!=null){
                evaObj = mapToEvaObj.get(appObj.id+'&&'+Userinfo.getUserId());
            }else{
                evaObj = new Evaluation__c ();
            }
            applicationEvaluationWrapper appwrapper = new applicationEvaluationWrapper(mapToApp.get(appObj.id+'&&'+Userinfo.getUserId()),mapToevalRanking.get(appObj.id+'&&'+Userinfo.getUserId()),evaObj,appObj,MapToContentVersion.get(appObj.id),false,sortfield);
           /* appwrapper.appObj = appObj;
            appwrapper.recommendationReasonsing = mapToApp.get(appObj.id+'&&'+Userinfo.getUserId()).Recommendation_Reasonsing__c;
              appwrapper.evalRanking = mapToApp.get(appObj.id+'&&'+Userinfo.getUserId()).EvaluatorsRanking__c;
             appwrapper.contentVersionObj = MapToContentVersion.get(appObj.id);*/
            wcList.add(appwrapper);
        }
        if(sortField=='EvaluatorsRanking__c' || sortField=='Superstar_Potential__c' || sortField=='Tech_Review__c'
                || sortField=='Business_Review__c') {
            wcList.sort();
        }
        List<applicationEvaluationWrapper> appWapperList = new List<applicationEvaluationWrapper>();
        if(!selectInterviewRecommendation.isEmpty()){
            
            for(applicationEvaluationWrapper appEvaWrap : wcList){
                for(string recInterview : selectInterviewRecommendation){
                    if(appEvaWrap.evaObj.Recommend_Interview_2__c == recInterview)
                    {
                        appWapperList.add(appEvaWrap);
                    } 
                }
            }
        }
        if(!selectStreamRecommendation.isEmpty()){
            
            for(applicationEvaluationWrapper appEvaWrap : wcList){
                for(string recInterview : selectStreamRecommendation){
                    if(appEvaWrap.evaObj.Stream_Recommendation__c == recInterview)
                    {
                        appWapperList.add(appEvaWrap);
                    } 
                }
            }
        }
        if(!selectTechStreamRecommendation.isEmpty()){
            
            for(applicationEvaluationWrapper appEvaWrap : wcList){
                for(string recInterview : selectTechStreamRecommendation){
                    if(appEvaWrap.evaObj.Tech_Screening_Recommendation__c == recInterview)
                    {
                        appWapperList.add(appEvaWrap);
                    } 
                }
            }
        }
        if(!selectSiteReferral.isEmpty()){
            
            for(applicationEvaluationWrapper appEvaWrap : wcList){
                for(string recInterview : selectSiteReferral){
                    if(appEvaWrap.evaObj.Refer_to_Other_Site__c == recInterview)
                    {
                        appWapperList.add(appEvaWrap);
                    } 
                }
            }
        }
        if(!selectReasonRecommendation.isEmpty()){
            
            for(applicationEvaluationWrapper appEvaWrap : wcList){
                for(string recInterview : selectReasonRecommendation){
                    if(appEvaWrap.evaObj.Reason_for_Recommending_Other_Site__c == recInterview)
                    {
                        appWapperList.add(appEvaWrap);
                    } 
                }
            }
        }
        if(!appWapperList.isEmpty()){
            wcList.clear();
            wcList=appWapperList;
        }
    }
    
        return wcList; 
    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(string applicationid){
        List<Contact> conList = new List<Contact>();
        Set<String> conSet = new Set<String>();
        for(Application_Contact__c appCon : [Select id, Contact__c,Cofounder_Number__c from Application_Contact__c where Application__c =:applicationid]){
            conSet.add(appCon.Contact__c);
        }
        if(!conSet.isEmpty()){
            conList = [Select id, Name, Email , Hours_Spent_on_Venture_in_Last_30_Days__c,Relevant_Experience__c,Key_Awards_and_Achievements__c,
                        Why_Co_Founder_is_Important_for_Venture__c,Hrs_Expected_on_Venture_for_Next_8_Mths__c,(Select id, Contact__c,Degree__c,Degree_Number__c,GPA__c,Graduation_Year__c,Institute__c,Specialization__c from Education__r) from Contact where id in :conSet];
            
        }
        return conList;
    }
    @AuraEnabled(cacheable=true)
    public static string getEvaluationId(string applicationid){
        string latestEvaluationId='';
        List<Evaluation__c> evalList = new List<Evaluation__c>();
        string currentLoggedInUsr = UserInfo.getUserId();
        evalList = [Select id from Evaluation__c where Application__c=:applicationid and CDL_Evaluator__c=:currentLoggedInUsr order by LastmodifiedDate Desc limit 1];
        if(evalList.size()>0){
            latestEvaluationId = evalList[0].id;
        }
        return latestEvaluationId;
    }
    @AuraEnabled
    public static string fetchUserId() {

        return UserInfo.getUserId();
    }
   @AuraEnabled
    public static List <String> getStreamPotential() {
        List<String> plValues = new List<String>();
         
        //Get the object type from object name. Here I've used custom object Book.
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('Application__c');
         
        //Describe the sObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
         
        //Get the specific field information from field name. Here I've used custom field Genre__c of Book object.
        Schema.DescribeFieldResult objFieldInfo = objDescribe.fields.getMap().get('Tech_Specialization__c').getDescribe();
         
        //Get the picklist field values.
        List<Schema.PicklistEntry> picklistvalues = objFieldInfo.getPicklistValues();
         
        //Add the picklist values to list.
        for(Schema.PicklistEntry plv: picklistvalues) {
            plValues.add(plv.getValue());
        }
        plValues.sort();
        return plValues;
    }
    @AuraEnabled
    public static List<String> getEvalPicklists(String fieldName){
        List<String> options = new List<String>();
 
        Map<string, schema.sobjectfield> evalObj = Schema.SObjectType.Evaluation__c.fields.getMap();
        Schema.DescribeFieldResult objRes = evalObj.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> pList = objRes.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
    
    public class applicationEvaluationWrapper implements Comparable{
         @AuraEnabled
         public string recommendationReasonsing;
         @AuraEnabled
         public decimal evalRanking;
         @AuraEnabled 
         public Evaluation__c evaObj;
          @AuraEnabled 
         public Application__c appObj;
          @AuraEnabled 
         public ContentVersion contentVersionObj;
                  @AuraEnabled 
         public  Boolean isChecked;
         public string sortfield;
        
         Public applicationEvaluationWrapper (String recommendationReasonsing,decimal evalRanking,Evaluation__c evaObj,Application__c appObj,ContentVersion contentVersionObj,boolean isChecked, string sortfield){
            this.recommendationReasonsing = recommendationReasonsing;
            this.evalRanking = evalRanking;
             this.evaObj = evaObj;
            this.appObj = appObj;
            this.contentVersionObj = contentVersionObj;
             this.isChecked=isChecked;
             this.sortfield = sortfield;
            }
            Public Integer compareTo(Object compareTo) {
                applicationEvaluationWrapper appwrap = (applicationEvaluationWrapper)compareTo;
                Integer returnValue = 0;
                system.debug(sortField  + 'sort==');
                system.debug(evaObj  + 'evaObj==' + evaObj.Superstar_Potential__c);
                if(sortField=='EvaluatorsRanking__c') {
                    If (evalRanking == appwrap.evalRanking) {
                        returnValue = 0;
                    }else If (evalRanking > appwrap.evalRanking) {
                        returnValue = 1;
                    } else if (evalRanking < appwrap.evalRanking) {
                        returnValue = -1;
                    }
                } else if(sortField=='Superstar_Potential__c') {
                    If (evaObj.Superstar_Potential__c > appwrap.evaObj.Superstar_Potential__c) {
                        returnValue = 1;
                    } else if (evaObj.Superstar_Potential__c < appwrap.evaObj.Superstar_Potential__c) {
                        returnValue = -1;
                    }
                }else if(sortField =='Tech_Review__c') {
                    If (evaObj.Tech_Review__c > appwrap.evaObj.Tech_Review__c) {
                        returnValue = 1;
                    } else if (evaObj.Tech_Review__c < appwrap.evaObj.Tech_Review__c) {
                        returnValue = -1;
                    }
                } else if(sortField =='Business_Review__c') {
                    If (evaObj.Business_Review__c > appwrap.evaObj.Business_Review__c) {
                        returnValue = 1;
                    } else if (evaObj.Business_Review__c < appwrap.evaObj.Business_Review__c) {
                        returnValue = -1;
                    }
                }
                return returnValue; 
            }
        
    }
    Public static Set<Id> getMatchingVentureOverview(String searchTerm) {

        System.debug('## searchTerm : '+searchTerm);

        Set<Id> applicationIds = new Set<Id>();
        List<Application__c> lstApplication = [Select Id, Venture_Overview_Briefly_describe_your__c FROM Application__c];

        for(Application__c application : lstApplication) {
            
            if(!String.isBlank(application.Venture_Overview_Briefly_describe_your__c) && application.Venture_Overview_Briefly_describe_your__c.contains(searchTerm)) {

                applicationIds.add(application.Id);
            }
        }

        return applicationIds;
    }
    @AuraEnabled
    public Static void saveRecord(List<Application__c> app,List<Evaluation__c> evaList){
      system.debug('************app***********'+app);
     
        try
        {
          if(!app.isEmpty()){      
              update app;
          }
          if(!evaList.isEmpty()){  
              update evaList;
          }
        }catch(exception ex){
            system.debug(ex.getMessage());
        } 
       // return app;
    }
}