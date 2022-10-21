<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "5":request.getParameter("s_kd");
	String andor 	= request.getParameter("andor")==null?"14":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String dt 	= request.getParameter("dt")==null? "2" :request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null? "" :request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null? "" :request.getParameter("ref_dt2");
	String st_nm 	= request.getParameter("st_nm")==null? "" :request.getParameter("st_nm");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-80;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&st_nm="+st_nm+"&andor="+andor+"&gubun1="+gubun1+"&ref_dt1="+ref_dt1+"&ref_dt2="+ref_dt2+"&dt="+dt+
				   	"&sh_height="+height+"";
%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--


function view_cont(m_id, l_cd, poll_st, clsdt)
	{
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.mode.value = '2'; /*조회*/
		fm.g_fm.value = '1';
		fm.type.value = '1';
		fm.poll_st.value = poll_st;
		fm.cls_dt.value = clsdt;
		fm.submit();
	}
//-->
</script>
</head>
<body leftmargin="15" topmargin=0>
<form name='form1' method='post' target='d_content' action='./survey_rm_reg_frame.jsp'>
<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 	value='<%=user_id%>'>
<input type='hidden' name='br_id' 	value='<%=br_id%>'>
<input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
<input type='hidden' name='st_nm' 	value='<%=st_nm%>'>			
<input type='hidden' name='andor'	 	value='<%=andor%>'>
<input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='from_page' value='rent_cond_rm_frame.jsp'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='doc_no' value=''>  
<input type='hidden' name='mode' value=''>    
<input type='hidden' name='bit' value=''>  
<input type='hidden' name='g_fm' value='1'>
<input type='hidden' name='type' value='1'>  
<input type='hidden' name='ref_dt1' 	value='<%=ref_dt1%>'>			
<input type='hidden' name='ref_dt2' 	value='<%=ref_dt2%>'>			
<input type='hidden' name='dt' 	value='<%=dt%>'>			
<input type='hidden' name='poll_st' value=''> 
<input type='hidden' name='cls_dt' 	value=''>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span></td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="rent_cond_rm_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

</form>
</body>
</html>
