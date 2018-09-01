/**
 * Created by Spring on 2018/9/1.
 */
({
   InitAction:function(cmp, event, helper){
      let title = cmp.get("v.title");
      let type = cmp.get("v.type");
      let labelStr = type == 'Report' ? 'QuickLinkReportTitle':'QuickLinkUserManualTitle';
      let labelReference = $A.getReference("$Label.c." + labelStr);
      console.log(labelStr+'--'+labelReference)
      cmp.set("v.titleT", (labelReference == undefined || labelReference == null)?title:labelReference);

      helper.getDataHelper(cmp, event);
   },
})