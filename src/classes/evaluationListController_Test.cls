@isTest(SeeAllData=false)
public class evaluationListController_Test{
    
     public static testMethod void evaluationTest1(){
         Test.startTest();
         List<application__c> applicationList = new list<application__c>();
         List<Evaluation__c> evaluationList = new list<Evaluation__c >();
         System.runAs(new user(ID = UserInfo.getUserID())) {
         Account a = new Account();
         a.Name = 'Symantic';
         Database.DMLOptions dml = new Database.DMLOptions();
         dml.DuplicateRuleHeader.AllowSave = true;
         Database.SaveResult sr2 = Database.insert(a, dml);

         Id AppRecordTypeId = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get('QML').getRecordTypeId();

         Application__c app = new Application__c();
         app.Venture__c = a.Id;
        app.recordTypeId = AppRecordTypeId;
        app.Evaluator_1__c = userinfo.getUserid();
         app.Tech_Specialization__c = 'Prime';
         app.Initial_CDL_Site_Preference__c = 'CDL - Rockies (Calgary)';
         app.Application_Referral_Name__c = 'XXX';
         app.X1st_Preference_CDL_Location__c = 'CDL-Atlantic (Halifax, CA)';
         app.X2nd_Preference_CDL_Location__c = 'CDL-West (Vancouver, CA)';
         insert app;
         applicationList.add(app);
         
         Evaluation__c eval = new Evaluation__c();
         eval.Application__c = app.id;
         eval.CDL_Evaluator__c = userinfo.getUserid();
         eval.Stream_Recommendation__c = 'Prime';
         eval.Recommend_Interview_2__c = '1- Yes';
         eval.Tech_Screening_Recommendation__c = 'yes';
         eval.Reason_for_Recommending_Other_Site__c  ='good';
         insert eval;
         evaluationList.add(eval);
         
         ContentVersion cv= new ContentVersion();
         cv.title='ABC';
        cv.PathOnClient ='test';
        Blob b=Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        insert cv;
        
          List<string>  techSpecList = new List<string> ();
          techSpecList.add('Prime');
          Date selDate = System.today();
         evaluationListController.getevaluations('CDL - Rockies (Calgary)',techSpecList,'','',selDate);
        evaluationListController.getInitialCDLSitePref();
        evaluationListController.getAnalysisStats(app.id);
        evaluationListController.getStreamPotential();
        evaluationListController.getApplicationOwner();
        evaluationListController.getApplicationStage();
        evaluationListController.getApplicationStage();
        evaluationListController.getContacts(app.id);
        Application__c appObj =[Select id,Name,Venture__c,Venture__r.name,Tech_Specialization__c,X1st_Preference_CDL_Location__c,
                                X2nd_Preference_CDL_Location__c,Application_Referral_Name__c
                                 from Application__c where id=:app.id ];
        List<string> selectedApplications = new List<string>();
        selectedApplications.add(appObj.Name);
        List<string> selectedVentures = new List<string>();        
        List<string> selectedStreamPotential = new List<string>();
         string currentselectedAppType = 'My Application';
         list<string>  selectedFirstSitePreference = new list<string>();         
         List<String> selectedsecondsitepreference = new list<string>();         
         List<String> selectreferal = new list<string>();
         String searchTerm = appObj.Name;
         String sortField = 'Name';
         Boolean sortAsc = true;
         List<String> selectInterviewRecommendation = new List<String>();
         List<String> selectStreamRecommendation = new List<String>();
         List<String> selectTechStreamRecommendation = new List<String>();
         List<String> selectSiteReferral = new List<String>();
         List<String> selectReasonRecommendation = new List<String>();
       //  selectedsecondsitepreference.add(appObj.X1st_Preference_CDL_Location__c);
       //  selectedFirstSitePreference.add(appObj.X2nd_Preference_CDL_Location__c);
         selectedVentures.add(appObj.Venture__r.name);
         selectSiteReferral.add(appObj.Application_Referral_Name__c);
         selectStreamRecommendation.add(eval.Stream_Recommendation__c);
         selectedStreamPotential.add(appObj.Tech_Specialization__c);
         selectreferal.add(appObj.Application_Referral_Name__c);
         selectInterviewRecommendation.add(eval.Recommend_Interview_2__c);
         selectTechStreamRecommendation.add(eval.Tech_Screening_Recommendation__c);
         selectReasonRecommendation.add(eval.Reason_for_Recommending_Other_Site__c);
         
         myevaluationListController.fetchAppwrapper(selectedApplications ,selectedVentures ,selectedStreamPotential ,
                                currentselectedAppType,selectedFirstSitePreference,selectedsecondsitepreference,selectreferal,
                                searchTerm,sortField,sortAsc,selectInterviewRecommendation,selectStreamRecommendation,
                                selectTechStreamRecommendation,selectSiteReferral,selectReasonRecommendation);
          myevaluationListController.getContacts(app.id);
          myevaluationListController.getEvaluationId(app.id);
        //  myevaluationListController.getApplicationURL(app.id);
        myevaluationListController.getStreamPotential();
        myevaluationListController.fetchUserId();
        myevaluationListController.getEvalPicklists('Stream_Recommendation__c');
        myevaluationListController.saveRecord(applicationList,evaluationList);
        
                myevaluationListController.applicationEvaluationWrapper appClas = new myevaluationListController.applicationEvaluationWrapper('test',1.0,eval,app,cv,true);
                
                interviewEvaluationCtrl.applicationEvaluationWrapper apintClas = new interviewEvaluationCtrl.applicationEvaluationWrapper();

        interviewEvaluationCtrl.fetchAppwrapper();
        interviewEvaluationCtrl.getContacts(app.id);
        //interviewEvaluationCtrl.getStreamPotential();
        interviewEvaluationCtrl.fetchUserId();
        }
         Test.stopTest();
        
     }
}