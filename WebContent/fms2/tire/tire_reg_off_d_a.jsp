<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.tire.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tire.TireDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");;
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String tire_gubun = request.getParameter("tire_gubun")==null?"":request.getParameter("tire_gubun");
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;	

	int result = 0;

	
%>


<%
	TireBean tire_mm 		= t_db.getDtireMM(seq, c_id);

		tire_mm.setSeq(seq);
		tire_mm.setCar_mng_id(c_id);
		tire_mm.setServ_id(serv_id);

		flag1 = t_db.deleteDtireMM(tire_mm);

	%>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='seq' 	value='<%=seq%>'>
  <input type='hidden' name='from_page' value='<%=from_page%>'>    
  <input type='hidden' name='mode' 		value='<%=mode%>'>      
</form>
<script language='javascript'>
	var flag = 0;	
<%		if(!flag1 || !flag2){		%>	alert('삭제 에러입니다.\n\n확인하십시오');		flag = 1;<%		}	%>

	if(flag == 0){
		alert('처리되었습니다.');
		var fm = document.form1;	
		fm.action = '<%=from_page%>';		
		fm.target = 'd_content';
		fm.submit();		
		
		parent.window.close();
	}
</script>
</body>
</html>
