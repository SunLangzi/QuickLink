/**************************************************************************************************
 *@Author Spring
 *@Date 2018-09-01
 *@Description
 *
 *@Test {}
 *@See {}
 *@Schedule{}
 *@Modify[
 * {时间:2018-09-01,修改人:Spring ,描述:init}
 *]
 *************************************************************************************************/
public class ResponseBody {
	@AuraEnabled
	public String Status{get;set;}
	@AuraEnabled
	public String Msg{get;set;}
	@AuraEnabled
	public Object Entity{get;set;}
	
	public ResponseBody(String Status, String Msg, Object Entity){
		this.Status = Status;
		this.Msg = Msg;
		this.Entity = Entity;
	}

}