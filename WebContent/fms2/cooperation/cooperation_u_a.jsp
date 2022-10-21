<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.cooperation.*"%>
<jsp:useBean id="cp_bean" class="acar.cooperation.CooperationBean" scope="page"/>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_year 	= request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon 	= request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	CooperationDatabase cp_db = CooperationDatabase.getInstance();
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	int seq 			= request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	String title 		= request.getParameter("title")==null?"":request.getParameter("title");
	String content 		= request.getParameter("content")==null?"":request.getParameter("content");
	String out_content 	= request.getParameter("out_content")==null?"":request.getParameter("out_content");
	String agnt_nm 		= request.getParameter("agnt_nm")==null?"":request.getParameter("agnt_nm");
	String agnt_m_tel	= request.getParameter("agnt_m_tel")==null?"":request.getParameter("agnt_m_tel");
	String agnt_email	= request.getParameter("agnt_email")==null?"":request.getParameter("agnt_email");
	
	String sender_id = "";
	String target_id = "";
	
	int count = 0;
	boolean flag6 = true;
	
	
	
	
	cp_bean = cp_db.getCooperationBean(seq);
	
	cp_bean.setTitle		(title);
	cp_bean.setContent		(content);
	cp_bean.setOut_content	(out_content);
	cp_bean.setAgnt_nm		(agnt_nm);
	cp_bean.setAgnt_m_tel	(agnt_m_tel);
	cp_bean.setAgnt_email	(agnt_email);
		
	count = cp_db.updateCooperation(cp_bean);
	
	String valus = "?gubun=it&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
			"&s_year="+s_year+"&s_mon="+s_mon+"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+
		   	"&sh_height="+sh_height+"";
%>


<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method="POST" enctype="">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_year' 	value='<%=s_year%>'>
  <input type='hidden' name='s_mon' 	value='<%=s_mon%>'>  
  <input type='hidden' name='s_kd' 		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>  
  <input type='hidden' name='gubun1'	value='<%=gubun1%>'>    
  <input type='hidden' name='gubun2'	value='<%=gubun2%>'>    
  <input type='hidden' name='gubun3'	value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4'	value='<%=gubun4%>'>          
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='<%=from_page%>'>
  <input type='hidden' name='seq' 		value='<%=seq%>'>      
</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
	
<%	if(count>0){%>
		alert("정상적으로 수정되었습니다.");		
		fm.action='cooperation_u.jsp';	
		fm.target='COOPERATION';
		fm.submit();	
		
		<%if(from_page.equals("/fms2/cooperation/cooperation_c_sc.jsp")){%>
		parent.opener.location.href = "cooperation_c_sc.jsp";	
		<%}else if(from_page.equals("/fms2/cooperation/cooperation_n_sc.jsp")){%>
		parent.opener.location.href = "cooperation_n_sc.jsp";	
		<%}else if(from_page.equals("/fms2/cooperation/cooperation_n2_sc.jsp")){%>
		parent.opener.location.href = "cooperation_n2_sc.jsp";	
		<%}else if(from_page.equals("/fms2/cooperation/cooperation_it_sc.jsp")){%>
		parent.opener.location.href = "cooperation_it_sc.jsp<%=valus%>";	
		<%}else{%>
		parent.opener.location.href = "cooperation_sc.jsp";	
		<%}%>
				
<%	}else{%>
		alert("에러발생!!");
<%	}%>
//-->
</script>

</body>
</html>