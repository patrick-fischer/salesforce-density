/**
 * @Name:        DensityControllerAuraTest
 * @Description: Test Class to cover the functionality of DensityControllerAura
 *
 * @author:      Patrick Fischer
 * @version:     1.0
 * Change Log
 *
 * Date         author              Change Description
 * -----------------------------------------------------------------------------------
 * 21/01/2019   Patrick Fischer     Created Class
 */
@IsTest
public with sharing class DensityControllerAuraTest {

    /**
     * @MethodTested: getDensityFromUIApi()
     * @Scenario: Retrieve the current density setting for a user
     * @ExpectedResult: Successfully fetch the density settings
     */
    private static testMethod void getDensityFromUIApiSuccess() {

        Test.setMock(HttpCalloutMock.class, new MockHttpResponse200());

        Test.startTest();
        String density = DensityControllerAura.getDensityFromUIApi();
        Test.stopTest();

        System.assertEquals('ViewOne', density, 'Expecting Density to be set to ViewOne');
    }

    /**
     * @MethodTested: getDensityFromUIApi()
     * @Scenario: Retrieve the current density setting for a user
     * @ExpectedResult: Throw Error due to Callout Failure
     */
    private static testMethod void getDensityFromUIApi404Failure() {

        Test.setMock(HttpCalloutMock.class, new MockHttpResponse404());

        String errorType, density;
        Test.startTest();
        try {
            density = DensityControllerAura.getDensityFromUIApi();
        } catch (Exception e) {
            errorType = e.getTypeName();
        }
        Test.stopTest();

        System.assertEquals('System.CalloutException', errorType, 'Expecting a System Callout Exception due to 404 Error Code');
        System.assertEquals(null, density, 'Expecting Density to be set to null');
    }

    /**
     * Inner class MockHttpResponse200 to test callout failures with Http Mock Response
     */
    public class MockHttpResponse200 implements HttpCalloutMock {

        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"density":"ViewOne"}');
            res.setStatusCode(200);
            return res;
        }
    }

    /**
     * Inner class MockHttpResponse404 to test callout failures with Http Mock Response
     */
    public class MockHttpResponse404 implements HttpCalloutMock {

        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('failure');
            res.setStatusCode(404);
            return res;
        }
    }
}