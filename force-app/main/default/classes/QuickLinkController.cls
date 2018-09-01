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
public with sharing class QuickLinkController {
	
	@AuraEnabled
	public static ResponseBody getDataService(String parameter) {
		
		try {
			
			Map<String, Object> parameterMap = (Map<String, Object>) JSON.deserializeUntyped(parameter);
			
			String cmpId = String.valueOf(parameterMap.get('CmpId'));
			String type = String.valueOf(parameterMap.get('Type'));
			
			if (cmpId == null || type == null) {
				return new ResponseBody('ERROR', '', 'ERROR~~');
			}
			
			Set<String> folderSet = new Set<String>();
			Set<String> targetSet = new Set<String>();
			
			List<QuickLinkConfig__mdt> quickLinkConfigList = getQuickLinkConfig(cmpId, type);
			for (QuickLinkConfig__mdt obj : quickLinkConfigList) {
				if (obj.Folder__c != null) {
					folderSet.add(obj.Folder__c);
				} else {
					targetSet.add(obj.TargetName__c);
				}
			}
			
			List<Object> entityList;
			
			if (type == 'Report') {
				entityList = getReport(targetSet, folderSet);
			} else {
				entityList = getContentDocument(folderSet);
			}
			
			return new ResponseBody('SUCCESS', '', entityList);
		
		} catch (Exception e) {
			throw new AuraHandledException('ERROR');
		}
	
	}
	
	public static List<QuickLinkConfig__mdt> getQuickLinkConfig(String label, String type) {
		return [
			SELECT
				DeveloperName,
				Folder__c,
				Id,
				TargetName__c,
				Type__c
			FROM QuickLinkConfig__mdt
			WHERE ComponentName__c = :label
			AND Type__c = :type
		];
	}
	
	public static List<Report> getReport(Set<String> nameSet, Set<String> folderNameSet) {
		return [
			SELECT
				DeveloperName,
				FolderName,
				Id,
				Name
			FROM Report
			WHERE DeveloperName IN:nameSet
			OR FolderName IN:folderNameSet
			ORDER BY Name
		];
	}
	
	public static List<ContentDocument> getContentDocument(Set<String> folderName) {
		Set<Id> docIds = new Set<Id>();
		for (ContentWorkspaceDoc obj : [
			SELECT ContentDocumentId
			FROM ContentWorkspaceDoc
			WHERE ContentWorkspaceId IN (
				SELECT Id
				FROM ContentWorkspace
				WHERE Name IN:folderName
			)
		]) {
			docIds.add(obj.ContentDocumentId);
		}
		
		return [
			SELECT Id,
				Title
			FROM ContentDocument
			WHERE Id IN:docIds
			ORDER BY Title
		];
	}
}