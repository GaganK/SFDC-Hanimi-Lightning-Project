public class currentUserDetailCtrl{
    @AuraEnabled
    public static User fetchUserDetail() {
        User userObj = new User();
        userObj  =  [SELECT ID, ContactId,Email FROM User where id=:userinfo.getuserId() LIMIT 1];
        return userObj;
    }
}