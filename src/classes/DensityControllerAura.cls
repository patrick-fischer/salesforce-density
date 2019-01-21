/**
 * @Name:        DensityControllerAura
 * @Description: Aura Controller class to handle server side operations of c:density component
 *
 * @author:      Patrick Fischer
 * @version:     1.0
 * Change Log
 *
 * Date         author              Change Description
 * -----------------------------------------------------------------------------------
 * 15/12/2018   Patrick Fischer     Created Class
 */
public with sharing class DensityControllerAura {

    /**
     * To retrieve the active density setting for the currently logged in user.
     * Salesforce encodes the density settings as:
     *   - 'ViewOne' for Comfy Layout view (more spacing)
     *   - 'ViewTwo' for the Compact Layout (less spacing)
     *
     * @return String of density setting 'ViewOne' or 'ViewTwo'
     */
    @AuraEnabled
    public static String getDensityFromUIApi() {

        // Session Id retrieved from Custom VisualForce page
        String sessionId = Page.MySessionIdVFPage.getContent().toString();
        String density = '';

        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setMethod('GET');
        httpRequest.setHeader('Authorization', 'Bearer ' + sessionId);
        httpRequest.setEndpoint(Url.getSalesforceBaseUrl().toExternalForm() + '/services/data/v44.0/ui-api/themes/active');

        try {
            Http http = new Http();
            HttpResponse httpResponse = http.send(httpRequest);
            if (httpResponse.getStatusCode() == 200) {
                // parse the density JSON attribute
                density = (String) ((Map<String, Object>) JSON.deserializeUntyped(httpResponse.getBody())).get('density');
            } else {
                throw new CalloutException(httpResponse.getBody());
            }
        } catch (System.Exception e) {
            throw e;
        }

        System.debug('Current density setting: ' + density);

        return density;
    }

}