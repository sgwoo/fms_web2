<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCarVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String a_e = request.getParameter("h_a_e")==null?"":request.getParameter("h_a_e");
	String a_a = request.getParameter("h_a_a")==null?"1":request.getParameter("h_a_a");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String a_j = request.getParameter("a_j")==null?"":request.getParameter("a_j");
	int count = 0;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	EstiCarVarBean [] ec_r = e_db.getEstiCarVarList(gubun1, "", gubun3);
	int size = ec_r.length;
	for(int i=0; i<size; i++){
		bean = ec_r[i];
		bean.setA_j(a_j);
		if(a_j.equals("")){
			bean.setA_j(AddUtil.getDate());
		}	
		seq = e_db.insertEstiCarVar(bean);
	}
	
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="esti_car_var_i.jsp" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">        
  <input type="hidden" name="a_e" value="<%=a_e%>">
  <input type="hidden" name="a_a" value="<%=a_a%>">
  <input type="hidden" name="seq" value="<%=seq%>">          
  <input type="hidden" name="cmd" value="u">
</form>
<script>
<%	if(cmd.equals("u")){
		if(count==1){%>
		alert("정상적으로 수정되었습니다.");
		opener.location.reload();		
//		document.form1.target='d_content';
//		document.form1.submit();	
		window.close();
<%		}else{%>
		alert("에러발생!");
<%		}
	}else{
		if(!seq.equals("")){%>
		alert("정상적으로 등록되었습니다.");
		opener.location.reload();				
//		document.form1.target='d_content';
//		document.form1.submit();
		window.close();
<%		}else{%>
		alert("에러발생!");
<%		}
	}	%>
</script>
</body>
</html>
