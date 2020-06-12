@isTest
public class ApplicationTriggerHelper_Test{
    
     public static testMethod void unitTest1(){
         Test.startTest();
         AbbreviationsToOmit__c abbre = new AbbreviationsToOmit__c();
         abbre.Name = 'Ltd';
         insert abbre;
         
         Lead  l = new Lead();
         l.Company = 'Symantic';
         l.lastname = 'test';
         l.Status = 'Applied';
         l.Tech_Specialization__c = 'Prime';
         insert l;
         Stream__c streamObj = new Stream__c();
         streamObj.Name = 'Prime';
         insert streamObj;
         Question__c qstObj = new Question__c();
         qstObj.Question_English__c = 'Test Question';
         insert qstObj;
         Stream_Question__c streamQuestObj = new Stream_Question__c();
         streamQuestObj.Stream__c = streamObj.id;
         streamQuestObj.Question__c = qstObj.id;
         streamQuestObj.Question_Sequence__c =1;
         insert streamQuestObj;
         
         Account a = new Account();
         a.Name = 'Symantic';
         Database.DMLOptions dml = new Database.DMLOptions();
         dml.DuplicateRuleHeader.AllowSave = true;
         Database.SaveResult sr2 = Database.insert(a, dml);
        l.Matching_Account__c = a.id;
        update l;
         
         Application__c app = new Application__c();
         app.Venture__c = a.Id;
         insert app;
        
         Test.stopTest();
        
     }
}