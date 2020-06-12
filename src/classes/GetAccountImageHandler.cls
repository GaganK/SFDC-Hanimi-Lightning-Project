public class GetAccountImageHandler {
    @AuraEnabled
    public static Account accountImageURL(){
            id userId = UserInfo.getUserId();
            User u = [select id, Contact.AccountId from User where id = : userId];
           id accountId =u.Contact.AccountId;
            String imageURL='';
            List<Account> lstAcc=[SELECT Account_Logo__c FROM Account WHERE Id=:accountId];
            return lstAcc[0];
    }
 }