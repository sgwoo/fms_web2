<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
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
	
	String dt 	= request.getParameter("dt")==null?"3":request.getParameter("dt");	
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String vid[] 	= request.getParameterValues("ch_cd");
	
	String vid_num="";
	
	String ch_result_nm="";  
	String ch_bank_acc_nm="";  
	String ch_match_yn="";
		
	int vid_size = vid.length;
	
	boolean flag1 = true;
	
	int result = 0;
	int count = 0;
				
	System.out.println(" 송금결과관리 선택건수="+vid_size+"<br><br>");
			
	for(int i=0;i < vid_size;i++){
		
		vid_num = vid[i];
				
		StringTokenizer token1 = new StringTokenizer(vid_num,"^");
						
		while(token1.hasMoreTokens()) {				
			ch_result_nm = token1.nextToken().trim();	
			ch_bank_acc_nm = token1.nextToken().trim();		
			ch_match_yn = token1.nextToken().trim();		
		}		
						
		flag1 = in_db.insertIbResult(ch_result_nm, ch_bank_acc_nm, ch_match_yn);			
	}
		

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>	
  <input type='hidden' name='dt' value='<%=dt%>'> 
  <input type='hidden' name='ref_dt1' value='<%=ref_dt1%>'> 
  <input type='hidden' name='ref_dt2' value='<%=ref_dt2%>'>		
	
</form>
<script language='javascript'>
<%	if(flag1){	%>		
		var fm = document.form1;	
		fm.action = '/fms2/account/shinhan_erp_ib_bulk.jsp';
		fm.target = 'd_content';
		fm.submit();		
<%	}else{	%>
		alert('데이터베이스 에러입니다.\n\n등록되지 않았습니다');		
<%	}	%>
</script>
<body>
</body>
</html>