<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.tour.*"%>
<jsp:useBean id="Bean" scope="page" class="acar.tour.TourBean"/>  

<%@ include file="/acar/cookies.jsp" %>
<%

	//중복되는 변수
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));
	String cmd	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	//insertPs
	String ps_dt = request.getParameter("ps_dt")==null?"":request.getParameter("ps_dt");
	String ps_gubun = "";
	String ps_content = request.getParameter("ps_content")==null?"":request.getParameter("ps_content");
	String ps_str_dt = request.getParameter("ps_str_dt")==null?"":request.getParameter("ps_str_dt");
	String ps_end_dt = request.getParameter("ps_end_dt")==null?"":request.getParameter("ps_end_dt");
	String ps_count = request.getParameter("ps_count")==null?"":request.getParameter("ps_count");
	String jigub = request.getParameter("jigub")==null?"":request.getParameter("jigub");
	String ps_amt = "";
	
	int count = 0;
	
	TourDatabase t_db = TourDatabase.getInstance();	

if(cmd.equals("i")){
	
	if(ps_count.equals("5")){
		ps_amt = "2000000";
	}else if(ps_count.equals("11")){
		ps_amt = "2200000";
	}else if(ps_count.equals("18")){
		ps_amt = "2500000";
	}else{
		ps_amt = "2500000";
	}
	
	Bean.setUser_id(user_id);
	Bean.setSeq(seq);
	Bean.setPs_dt(ps_dt);
	Bean.setPs_count(ps_count);
	Bean.setPs_amt(ps_amt);
	Bean.setPs_gubun("2");
	Bean.setPs_content(ps_content);
	Bean.setPs_str_dt(ps_str_dt);
	Bean.setPs_end_dt(ps_end_dt);
	Bean.setJigub(jigub);
	
	count = t_db.insertPs(Bean);
	
}else if(cmd.equals("d")){ 
	
	Bean.setUser_id(user_id);
	Bean.setSeq(seq);
	
	count = t_db.tour_del(Bean);
	
}

%>
<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15" >

<form name='form1' method='post'>
<input type="hidden" name="user_id" 	value="<%=user_id%>">
<input type="hidden" name="cmd" 	value="<%=cmd%>">
</form>
<script language='javascript'>
<!--
	var fm = document.form1;

<%	if(cmd.equals("i")){
		if(count == 1){
%>
		alert("정상적으로 등록되었습니다.");
		fm.action='./tour_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>';			
		parent.parent.close();
		fm.submit();
	

<%	}
}else if(cmd.equals("d")){
	if(count == 1){
%>
		alert("정상적으로 삭제되었습니다.");
		parent.parent.close();
		fm.submit();
	//	parent.location="javascript:location.reload()";  //새로고침
	//	fm.submit();		
<%}
}else{
%>
	alert("에러입니다.");

<%
}
%>
//-->

</script>
</body>
</html>
