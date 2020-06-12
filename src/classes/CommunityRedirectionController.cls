public without sharing class CommunityRedirectionController {

    public Pagereference redirect() {

        List<NetworkMember> communityMemberships = new List<NetworkMember>([SELECT NetworkId, Network.UrlPathPrefix
            FROM NetworkMember
            WHERE Memberid =: UserInfo.getUserId()
            AND Network.Name <> 'CDL']);

        System.debug('## '+UserInfo.getName());
        System.debug('## '+UserInfo.getUserType());

        if(!communityMemberships.isEmpty()) {

            Integer totalCommunities = communityMemberships.size();

            if(totalCommunities == 1) {

                String baseUrl = Site.getBaseSecureUrl().replace(Site.getPathPrefix(),'');

                return new Pagereference(baseUrl + '/' + communityMemberships[0].Network.UrlPathPrefix);
            } else {
                
                // Considering, user will have access to only single community at a time, not handling this as of now.
                return null;
            }
        } else {

            // This will never happen, until user who doesn't have access to any community and try to access this page directly
            return null;
        }
    }
}