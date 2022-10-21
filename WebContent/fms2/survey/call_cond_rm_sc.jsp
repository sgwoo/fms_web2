<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.call.*" %>

<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String gubun = request.getParameter("gubun")==null?"4":request.getParameter("gubun");	
	String ref_dt1 = request.getParameter("ref_dt1")==null?Util.getDate():request.getParameter("ref_dt1");	
	String ref_dt2 = request.getParameter("ref_dt2")==null?Util.getDate():request.getParameter("ref_dt2");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");	
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String g_fm = "1";
	String fn_id= "0";

	String sort = request.getParameter("sort")==null?"7":request.getParameter("sort");
	String andor 	= request.getParameter("andor")==null?"14":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String st_nm 	= request.getParameter("st_nm")==null? "" :request.getParameter("st_nm");

				
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
	int cnt = 2; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-180;//현황 라인수만큼 제한 아이프레임 사이즈
	
	if(height < 50) height = 150;
	

	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--


function view_cont(m_id, l_cd, poll_st, r_dt)
	{
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.mode.value = '2'; /*조회*/
		fm.g_fm.value = '1';
		fm.type.value = '2';
		fm.poll_st.value = poll_st;
		fm.cls_dt.value = r_dt;
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form name='form1' method='post' target='d_content' action='./survey_rm_reg_frame.jsp'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='g_fm' value='1'>
<input type='hidden' name='type' value='2'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd'  value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>	
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='poll_st' value=''> 
<input type='hidden' name='cls_dt' value=''> 

</form>
<table border=0 cellspacing=0 cellpadding=0 width=100%>

<tr> 
        <td colspan='3'> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                 <td><iframe src="./call_cond_rm_sc_in.jsp?auth_rw=<%=auth_rw%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun1=<%= gubun1 %>&sort=<%=sort%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>" name="RegCondList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>		
            
                </tr>
            </table>
        </td>
    </tr>
 <tr>
        <td class=h></td>
    </tr>

</table>
</body>
</html>