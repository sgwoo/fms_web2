<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String gubun = request.getParameter("gubun")==null?"4":request.getParameter("gubun");	
	String ref_dt1 = request.getParameter("ref_dt1")==null?Util.getDate():request.getParameter("ref_dt1");	
	String ref_dt2 = request.getParameter("ref_dt2")==null?Util.getDate():request.getParameter("ref_dt2");	
	String st_nm	= request.getParameter("st_nm")==null?"":request.getParameter("st_nm");	

	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");	
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");	
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String g_fm = "1";
	String fn_id= "0";
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String sort = request.getParameter("sort")==null?"7":request.getParameter("sort");
	
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
	int cnt = 2; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-80;//현황 라인수만큼 제한 아이프레임 사이즈
	
	if(height < 50) height = 150;
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table.css"></link><script language="JavaScript">
<!--

function AccidentDisp(m_id, l_cd, c_id, accid_id, accid_st, acc_dt){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.accid_id.value = accid_id;		
		fm.accid_st.value = accid_st;	
		fm.poll_st.value = '사고처리';
		fm.accid_dt.value = acc_dt;
		fm.cmd.value = "u";	
		
		fm.submit();
		
	}
	

function view_cont(m_id, l_cd, c_id, s_id, p_gubun)
	{
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.s_id.value = s_id;
		fm.p_gubun.value = p_gubun;
		fm.mode.value = '2'; /*조회*/
		fm.g_fm.value = '1';
		fm.type.value = '1';
		
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form name='form1' method='post' target='d_content' action='./survey_accident_reg_frame.jsp'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='s_id' value=''>
<input type='hidden' name='accid_id' value=''>
<input type='hidden' name='accid_st' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='p_gubun' value=''>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='g_fm' value='1'>
<input type='hidden' name='type' value='1'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd'  value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>	
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='dt' value="<%=dt%>">
<input type='hidden' name='gubun2' value="<%=gubun2%>">
<input type='hidden' name='ref_dt1' value="<%=ref_dt1%>">
<input type='hidden' name='ref_dt2' value="<%=ref_dt2%>"> 
<input type='hidden' name='poll_st' value=''> 
<input type='hidden' name='accid_dt' value=''> 

</form>
<table border=0 cellspacing=0 cellpadding=0 width=100%>

  <tr>
    <td><iframe src="./car_accident_sc_in.jsp?st_nm=<%=st_nm%>&auth_rw=<%=auth_rw%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun2=<%= gubun2 %>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&sort=<%=sort%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>		
  </tr>

</table>
</body>
</html>