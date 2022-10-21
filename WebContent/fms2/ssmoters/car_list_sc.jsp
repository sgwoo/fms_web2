<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동차관리 검색 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
		
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
<!--
//리스트 엑셀 전환
	function prop_excel(){
		var fm = document.form1;
		fm.target = "_blank";
		fm.action = "car_maint_excel_list2.jsp";
		fm.submit();
	}
	
	
//검사정산 
function view_jungsan(m1_no, rent_l_cd, gubun)
{
		var fm = document.form1;
			
		window.open("/fms2/ssmoters/car_maint_jungsan_popup.jsp?user_id="+fm.user_id.value+"&auth_rw="+fm.auth_rw.value+"&m1_no="+m1_no+"&rent_l_cd="+rent_l_cd+"&gubun="+gubun, "jungsan", "left=150, top=150, width=450, height=550");
}


//-->
//-->
</script>
</head>
<body leftmargin=15 rightmargin=0>
<form name='form1' method='post'>

<input type='hidden' name='s_kd' value='<%=s_kd%>'> 
<input type='hidden' name='st_dt' value='<%=st_dt%>'> 
<input type='hidden' name='end_dt' value='<%=end_dt%>'> 
<input type='hidden' name='t_wd' value='<%=t_wd%>'> 
<input type='hidden' name='gubun1' value='<%=gubun1%>'> 
<input type='hidden' name='gubun2' value='<%=gubun2%>'> 
<input type='hidden' name='gubun3' value='<%=gubun3%>'> 
<input type='hidden' name='gubun4' value='<%=gubun4%>'> 
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>	

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
		<td>
			 <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>				
			        <td align='left'><a href="javascript:prop_excel();"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>&nbsp;
			      </td>
			  
				</tr>
			</table>
		</td>
	</tr>
	
    <tr>
		<td>
			 <table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td><iframe src="./car_list_sc_in.jsp?gubun1=<%=gubun1%>&t_wd=<%=t_wd%>&gubun3=<%=gubun3%>&gubun2=<%=gubun2%>&gubun4=<%=gubun4%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&height=<%=height%>" name="RegList" width="100%" height="<%=height+10%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>								
			</table>
		</td>
	</tr>	
</table>
</form>
</body>
</html>