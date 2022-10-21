<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.MaMymenuDatabase, org.json.JSONObject, org.json.JSONArray" %>
<%@ include file="/acar/cookies.jsp" %> 
<html>
<head>
<title>:: FMS(Fleet Management System) ::</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>
<body>
<%

	MaMymenuDatabase mm_db = MaMymenuDatabase.getInstance();

	String jsonParam = request.getParameter("data").toString();

	JSONObject jsonObject = new JSONObject(jsonParam);
	JSONArray jsonArray = jsonObject.getJSONArray("data");
	
	for(int i=0;i<jsonArray.length();i++){
	    
		JSONObject json = jsonArray.getJSONObject(i);
	    
	    String m_st = json.get("mst").toString();
	   	String m_st2 = json.get("mst2").toString();
	    String m_cd = json.get("mcd").toString();
	    int index = Integer.parseInt(json.get("index").toString());
	    
		mm_db.updateMyMenuByMenuCode(ck_acar_id,m_st,m_st2,m_cd,index);    
	}
%>
<div>
<%=ck_acar_id%>
<%=jsonParam %>
</div>

</body>
</html>