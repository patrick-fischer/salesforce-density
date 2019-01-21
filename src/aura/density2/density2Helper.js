({
    initialiseDensity : function(cmp, event, helper) {
        let action = cmp.get('c.getDensityFromUIApi'); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                console.log('Response: ' + response.getReturnValue());
                cmp.set('v.density', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
});