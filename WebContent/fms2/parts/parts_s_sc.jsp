<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
		
	function view_chulgo(reqseq, car_mng_id){
		var fm = document.form1;
		fm.reqseq.value 	= reqseq;		
		fm.car_mng_id.value 	= car_mng_id;		
			
		fm.action = 'doc_print.jsp';		
		fm.target = 'd_content';
		fm.submit();
	}	
	
		
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
			
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
	if(height < 50) height = 150;
	
%>
<form name='form1' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>

<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_gubun1' value='<%=s_gubun1%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='go_url' value='/off/parts/parts_s_frame.jsp'>
<input type='hidden' name='reqseq' value=''>
<input type='hidden' name='car_mng_id' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='idx' value='<%=idx%>'>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
	  <td>
		<table border="0" cellspacing="0" cellpadding="0" width=100%>
  
		  <tr>
			<td>
			  <table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
				  <td align='center'>
					<iframe src="parts_s_in.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&s_gubun1=<%=s_gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>&s_st=<%=s_st%>#<%=idx%>" name="i_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
					</iframe>
				  </td>
				</tr>
			  </table>
			</td>
		  </tr>
		</table>
	  </td>
	</tr>
	
</table>
</form>
<script language='javascript'>
<!--

//-->
</script>
</body>
</html>
