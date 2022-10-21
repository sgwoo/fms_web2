<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")	==null?"":request.getParameter("gubun6");
	String gubun7 	= request.getParameter("gubun7")	==null?"":request.getParameter("gubun7");
	String st_dt 	= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 	= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String asc 	= request.getParameter("asc")		==null?"":request.getParameter("asc");
	String go_url 	= request.getParameter("go_url")	==null?"":request.getParameter("go_url");
	String idx 	= request.getParameter("idx")		==null?"":request.getParameter("idx");

	//height
	int sh_height 	= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-80;//현황 라인수만큼 제한 아이프레임 사이즈
	
	if(height < 50) height = 150;
	
	String valus 	= "?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
			  "&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&gubun6="+gubun6+"&gubun7="+gubun7+
			  "&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort="+sort+"&asc="+asc+
		   	  "&sh_height="+height+"";	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function AccidentDisp(m_id, l_cd, c_id, accid_id, accid_st, idx){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.accid_id.value = accid_id;		
		fm.accid_st.value = accid_st;			
		fm.idx.value = idx;										
		fm.cmd.value = "u";		
		fm.submit();
	}
	
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=20, top=20, width=820, height=700, scrollbars=yes");
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='../accid_mng/accid_u_frame.jsp' method='post' target='d_content'>
<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 	value='<%=user_id%>'>
<input type='hidden' name='br_id' 	value='<%=br_id%>'>

<input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
<input type='hidden' name='gubun2' 	value='<%=gubun2%>'>
<input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
<input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
<input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
<input type='hidden' name='gubun6' 	value='<%=gubun6%>'>
<input type='hidden' name='gubun7' 	value='<%=gubun7%>'>
<input type='hidden' name='s_kd' 	value='<%=s_kd%>'>
<input type='hidden' name='t_wd' 	value='<%=t_wd%>'>
<input type='hidden' name='sort' 	value='<%=sort%>'>
<input type='hidden' name='asc' 	value='<%=asc%>'>

<input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
<input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
<input type='hidden' name='idx' 	value='<%=idx%>'>
<input type='hidden' name='go_url' 	value='/acar/accid_mng2/accid_s9_2_frame.jsp'>

<input type='hidden' name='m_id' 	value=''>
<input type='hidden' name='l_cd' 	value=''>
<input type='hidden' name='c_id' 	value=''>
<input type='hidden' name='accid_id' 	value=''>
<input type='hidden' name='accid_st' 	value=''>
<input type='hidden' name='cmd' 	value=''>
<input type='hidden' name='mode' 	value='9'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	  <tr>
		<td><iframe src="accid_s9_2_sc_in.jsp<%=valus%>&go_url=<%=go_url%>#<%=idx%>" name="i_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
	  </tr>
	  <tr>
		<td> ※ 일부수금은 최종 수금일자, 전액미수일때는 청구일자를 기준으로 하여 년리 5%의 연체이자를 부과합니다.</td>
	  </tr>	  
</table>
</form>
</script>
</body>
</html>
