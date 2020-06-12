@isTest
public class evaluationSummaryRankingCtrl_Test{
    
     public static testMethod void appEvaTest12(){
         Test.startTest();
         Account a = new Account();
         a.Name = 'Symantic12';
         Database.DMLOptions dml = new Database.DMLOptions();
         dml.DuplicateRuleHeader.AllowSave = true;
         Database.SaveResult sr2 = Database.insert(a, dml);

         Id AppRecordTypeId = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get('QML').getRecordTypeId();

         Application__c app = new Application__c();
         //app.Venture__c = a.Id;
        app.recordTypeId = AppRecordTypeId;
         app.Tech_Specialization__c = 'Prime';
         app.Initial_CDL_Site_Preference__c = 'CDL - Rockies (Calgary)';
         insert app;
         list<Application__c> appList = new list<Application__c>();
         appList.add(app);
         Evaluation__c eval = new Evaluation__c();
         eval.Application__c = app.id;
         eval.CDL_Evaluator__c = userinfo.getUserid();
         insert eval;
          List<string>  techSpecList = new List<string> ();
          techSpecList.add('Prime');
          Date selDate = System.today();
        evaluationSummaryRankingCtrl.getAllApplications(techSpecList );
        evaluationSummaryRankingCtrl.updateApplication(appList);
        Application__c objObject = new Application__c();
        
        evaluationSummaryRankingCtrl.getselectOptions(objObject,'Tech_Specialization__c');
        evaluationSummaryRankingCtrl.fetchLookUpValues('Suth' ,'User');
        evaluationSummaryRankingCtrl.getStreamPotential();
         Test.stopTest();
        
     }
}