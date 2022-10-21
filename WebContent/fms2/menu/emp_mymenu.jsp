<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, org.json.simple.JSONObject, org.json.simple.JSONArray" %>
<%@ include file="/acar/cookies.jsp" %> 

<%	

		MaMymenuDatabase mm_db = MaMymenuDatabase.getInstance();
		Vector menus2 = mm_db.getXmlMyMenuList(ck_acar_id);
		int menu_size2 = menus2.size();
		
		JSONObject resultObj = new JSONObject();
		Collection<JSONObject> items = new ArrayList<JSONObject>();
		
		for(int i=0;i<menu_size2;i++){
			JSONObject jObj = new JSONObject();
			Hashtable menu2 = (Hashtable)menus2.elementAt(i);
			
			jObj.put("mst",menu2.get("M_ST"));
			jObj.put("mst2",menu2.get("M_ST2"));
			jObj.put("mcd",menu2.get("M_CD"));
			jObj.put("mnm",menu2.get("M_NM"));
			jObj.put("mnm1",menu2.get("M_NM1"));
			jObj.put("mnm2",menu2.get("M_NM2"));
			jObj.put("url",menu2.get("URL"));
			jObj.put("authRw",menu2.get("AUTH_RW"));
			
			items.add(jObj);
		}		
		
		resultObj.put("data",items);
		
		response.getWriter().print(resultObj);
		
%>	

