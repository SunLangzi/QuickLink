/**
 * Created by Spring on 2018/9/1.
 */
({
  getDataHelper:function(cmp, event){

    const server = cmp.find('serviceAction');

    const action = cmp.get('c.getDataService');

    server.callServer(
        action, // Action
        {
          'parameter':JSON.stringify({
            'CmpId': cmp.get('v.componentID'),
            'Type': cmp.get('v.type')
          })
        }, // Action parameters
        false, // Toogles cache
        $A.getCallback(response => { // Success callback

            let entity = response.Entity;
            let msg = response.Msg;
            let status = response.Status;

            if(status == 'ERROR'){
              console.log('error------'+msg);
              return;
            }

            cmp.set('v.resultList', entity);
        }),
        $A.getCallback(errors => { // Error callback
            cmp.set('v.response', errors[0].message);
        }),
        false, // Keep built-in error handling
        false// Toggles background
    );



  }
})