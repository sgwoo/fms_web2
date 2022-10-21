<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@ page import="java.util.*, acar.util.*, acar.free_time.*, acar.common.*, org.json.simple.*" %>
<%
	response.setContentType("text/html; charset=utf-8");	// ajax 한글 인코딩 설정

	String name = request.getParameter("name")==null?"":request.getParameter("name"); // 검색할 이름을 가져온다.
		
	CommonDataBase c_db = CommonDataBase.getInstance();	// DB
	
	Vector vt = new Vector();
	
	if (!name.equals("")) {
		vt = c_db.getUserSearchList("EMP_Y", name); 
	}

	JSONObject jsonObj = new JSONObject();	// ajax return 용 jsonObject
	
	jsonObj.put("vt",vt);
	
	out.print(jsonObj);	// return vector
	out.flush();	
%>