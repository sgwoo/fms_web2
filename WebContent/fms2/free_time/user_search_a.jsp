<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@ page import="java.util.*, acar.util.*, acar.free_time.*, acar.common.*, org.json.simple.*" %>
<%
	response.setContentType("text/html; charset=utf-8");	// ajax �ѱ� ���ڵ� ����

	String name = request.getParameter("name")==null?"":request.getParameter("name"); // �˻��� �̸��� �����´�.
		
	CommonDataBase c_db = CommonDataBase.getInstance();	// DB
	
	Vector vt = new Vector();
	
	if (!name.equals("")) {
		vt = c_db.getUserSearchList("EMP_Y", name); 
	}

	JSONObject jsonObj = new JSONObject();	// ajax return �� jsonObject
	
	jsonObj.put("vt",vt);
	
	out.print(jsonObj);	// return vector
	out.flush();	
%>