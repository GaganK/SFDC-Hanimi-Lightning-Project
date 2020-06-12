@isTest
public class evaluationSummaryScoreCtrl_Test{
    
    public static testMethod void appEvaTest1(){
        Test.startTest();
        Account a = new Account();
        a.Name = 'Symantic';
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.AllowSave = true;
        Database.SaveResult sr2 = Database.insert(a, dml);
        
        Contact con =new Contact();
        con.LastName='test contact';
        con.AccountId=a.id;
        insert con;
        
        Id AppRecordTypeId = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get('QML').getRecordTypeId();
        
        Application__c app = new Application__c();
        //app.Venture__c = a.Id;
        app.recordTypeId = AppRecordTypeId;
        app.Tech_Specialization__c = 'Prime';
        app.Application_Stage__c='Applied';
        app.Initial_CDL_Site_Preference__c = 'CDL - Rockies (Calgary)';
        app.Evaluator_1__c=userinfo.getUserid();
        app.Evaluator_2__c=userinfo.getUserid();
        app.Evaluator_3__c=userinfo.getUserid();
        app.Venture__c=a.id;
        app.FinalRank__c=26;
        insert app;
        
        Application__c appObj = [Select Id,Name,Evaluator_1__c,Evaluator_2__c,Evaluator_3__c,FinalRank__c,Team_Score__c,Team_Superstar_Potential_Score__c,Team_Tech_Review_Score__c,Team_Business_Review_Score__c,War_Comments__c,Team_Interview_Recommendations__c,
                                         Team_Stream_Recommendation__c,Team_Sub_Stream_Recommendation__c,TechScreening__c,
                                         (select id,CDL_Evaluator__r.Name,Evaluator_Name__c,CDL_Evaluator__c,Refer_to_Other_Site__c,Superstar_Potential__c,Tech_Review__c,Business_Review__c,
                                          Name,EvaluatorsRanking__c,Tech_Screening_Recommendation__c,Recommend_Interview_2__c,
                                          Stream_Recommendation__c from Evaluations__r ORDER BY Name DESC LIMIT 3),
                                         Venture__r.Name,Venture_Overview_Briefly_describe_your__c ,Cohort__r.Name,ShouldCDLInterviewthisVenture__c,
                                         Evaluator_1_Recommendation_Reasonsing__c,Evaluator_2_Recommendation_Reasonsing__c,X1st_Preference_CDL_Location__c,
                                         X2nd_Preference_CDL_Location__c,Evaluator_3_Recommendation_Reasonsing__c,Evaluator_1__r.Name,Avg_Score_Overall__c,
                                         Evaluator_2__r.Name,Owner.Name,Evaluator_3__r.Name,Application_Referral_Name__c,
                                         Application_Primary_Contact__r.LinkedIn_URL__c,Venture__c,Venture__r.Website,Venture__r.BillingStreet,
                                         Venture__r.BillingCity,Venture__r.BillingState,Venture__r.BillingCountry,
                                         Application_Primary_Contact__r.Firstname,Application_Primary_Contact__r.Lastname,
                                         Application_Primary_Contact__r.Email,Application_Primary_Contact__r.Phone,Initial_CDL_Site_Preference__c,
                                         Tech_Specialization__c,Evaluator_1_Score__c,Evaluator_2_Score__c,Evaluator_3_Score__c from Application__c where 
                                         id=:app.Id];
        
        list<Application__c> appList = new list<Application__c>();
        appList.add(app);
        Application__c appupdate = new Application__c();
        appupdate.Id=app.Id;
        appupdate.recordTypeId = AppRecordTypeId;
        appupdate.Tech_Specialization__c = 'Prime';
        appupdate.Application_Stage__c='Applied';
        appupdate.Initial_CDL_Site_Preference__c = 'CDL - Rockies (Calgary)';
        appupdate.Evaluator_1__c=userinfo.getUserid();
        appupdate.Evaluator_2__c=userinfo.getUserid();
        appupdate.Evaluator_3__c=userinfo.getUserid();
        appupdate.Venture__c=a.id;
        appupdate.FinalRank__c=26;
        update appupdate;
        list<Application__c> appupdateList = new list<Application__c>();
        appupdateList.add(appupdate);
        Evaluation__c eval = new Evaluation__c();
        eval.Application__c = app.id;
        eval.CDL_Evaluator__c = userinfo.getUserid();
        eval.CoachabilityPreservance__c='1 = Not very perseverant';
        insert eval;
        list<Evaluation__c> evallist = new list<Evaluation__c>();
        evallist.add(eval);
        List<string>  techSpecList = new List<string> ();
        techSpecList.add('Prime');
        Date selDate = System.today();
        
        list<string> selectedFilterApp = new list<string>();
        selectedFilterApp.add(appObj.Name);
        
        List<string> selectFirstsitepreference = new list<string>();
        selectFirstsitepreference.add(appObj.X1st_Preference_CDL_Location__c);
        
        List<String> selectedsecondsitepreference = new List<String>();
        selectedsecondsitepreference.add(appObj.X2nd_Preference_CDL_Location__c);
        
        
        List<String> selectedVentures= new List<String>();
        selectedVentures.add(appObj.Venture__r.Name);
        
        List<String> selectedStreamPotentialList = new list<string>();
        selectedStreamPotentialList.add(appObj.Tech_Specialization__c);
        
        List<String> selectreferal  = new List<String>();
        selectreferal.add(appObj.Application_Referral_Name__c);
        
        List<String> selectfinalrank  = new List<String>();
        selectfinalrank.add(string.valueof(appObj.FinalRank__c));
        
        List<String> selectinterviewRecommendation  = new List<String>();
        //selectinterviewRecommendation.add(appObj.Tech_Specialization__c);
        List<String> selectstreamRecommendation = new List<String>();
        //selectstreamRecommendation.add(appObj.Tech_Specialization__c);
        List<String> selecttechScreeningRecommendation = new List<String>();
        selecttechScreeningRecommendation.add(appObj.TechScreening__c );
        sObject evaluation = new evaluation__c();

        
        evaluationSummaryScoreCtrl.getAllApplications(appObj.name, selectedFilterApp, selectFirstsitepreference, selectedsecondsitepreference, 
            'Name', True, selectedVentures, selectedStreamPotentialList, selectreferal, selectfinalrank, selectinterviewRecommendation, 
             selectstreamRecommendation, selecttechScreeningRecommendation,'self');
       
       
        evaluationSummaryScoreCtrl.updateApplication(appupdate);      
        evaluationSummaryScoreCtrl.getselectOptions(evaluation,'Evaluator_Type__c');
        evaluationSummaryScoreCtrl.fetchLookUpValues('Suth' ,'User');
        evaluationSummaryScoreCtrl.getApplicationURL(app.id);
        evaluationSummaryScoreCtrl.fetchLookUpValues(userinfo.getname(),'user');
        evaluationSummaryScoreCtrl.getStreamPotential();
        evaluationSummaryScoreCtrl.getContacts(appObj.Id);
        Test.stopTest();
        
    }
}