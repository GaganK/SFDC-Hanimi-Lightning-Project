@isTest
Private class CDLV_myMatchVentureListController_Test {
    static testMethod void testVentures() {
            Test.startTest();
            Id p = [select id from profile where name='Venture Portal Users'].id;
            Id partnerAccountrecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Partner_Account').getRecordTypeId();
           // Id contactrecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Mentor_Contact').getRecordTypeId();
            
            Account ac = new Account(name ='TestGrazitti11',recordTypeId=partnerAccountrecTypeId,
                                     Related_Stream_s__c='Artificial Intelligence; Blockchain-AI',Technology_Area__c='AI') ;
            insert ac; 
           
            Contact con = new Contact(LastName ='testCon11',AccountId = ac.Id,Industry_Area_Focuses__c ='health'
                                                 );
            insert con;  
                      
            User user = new User(alias = 'test311', email='test1235551@noemail.com',
                    emailencodingkey='UTF-8', lastname='Testing11', languagelocalekey='en_US',
                    localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                    ContactId = con.Id,
                    timezonesidkey='America/Los_Angeles', username='tester1@noemail.com',Day_1_Stream__c='Prime');
           
            insert user;
           Venture_Mentor__c  venMentor = new Venture_Mentor__c(Account__c =con.AccountId, Contact__c = con.Id,ranking__c = '1');
           insert venMentor; 
           
            system.runas(user) {
           
                user userObj = [SELECT id,Contact.Name,ContactId,Contact.Title,Contact.Account.Name,Contact.Accountid,Contact.Account.Website,
                                Contact.Biodata__c,Contact.Industry_Area_Focuses__c FROM User where id =: user.id];
                     
                List<string> selectedMentors = new List<string>();     
                selectedMentors.add(userObj.contact.Name);
                List<string> selectedIndustryArea = new List<string>();  
                selectedIndustryArea.add(userObj.contact.Industry_Area_Focuses__c);
                List<String> selectedFilterCompany = new List<string>();  
                selectedFilterCompany.add(userObj.contact.Account.Name);  
                List<string> admitMentWrap = new list<string>(); 
                admitMentWrap.add(userObj.contactid+'&&'+'2');
                CDLV_myMatchVentureListController.fetchmentorwrapper(userObj.contact.Name,'Name',true,
                                              selectedMentors,selectedIndustryArea,true,selectedFilterCompany);
                CDLV_myMatchVentureListController.saveAdmit(admitMentWrap);
                CDLV_myMatchVentureListController.getRankingList();
            }
            Test.stopTest();
    }
}