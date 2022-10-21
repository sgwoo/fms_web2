<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String esti_m = request.getParameter("esti_m")==null?"":request.getParameter("esti_m");
	String esti_m_dt = request.getParameter("esti_m_dt")==null?"":request.getParameter("esti_m_dt");
	String esti_m_s_dt = request.getParameter("esti_m_s_dt")==null?"":request.getParameter("esti_m_s_dt");
	String esti_m_e_dt = request.getParameter("esti_m_e_dt")==null?"":request.getParameter("esti_m_e_dt");	
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-110;//현황 라인수만큼 제한 아이프레임 사이즈
		
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript">
<!--
function EstiReg()
{	
	var SUBWIN="./esti_mng_i.jsp";	
	window.open(SUBWIN, "EstiReg", "left=100, top=100, width=580, height=200, scrollbars=no");
}

function UpdateList(arg)
{	
	var theForm = document.CarOffUpdateForm;
	theForm.car_off_id.value = arg;
	theForm.target="d_content";
	theForm.submit();
}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
<!--
  <tr>
	<td>
	  <table border="0" cellspacing="0" cellpadding="0" width=820>
		<tr>					
          <td class='line' width="801"> 
            <table  border=0 cellspacing=1 width="800">
              <tr> 
                <td width= 30 class=title>연번</td>
                <td width= 70 class=title>견적번호</td>
                <td width= 130 class=title>대여상품</td>
                <td width= 100 class=title>고객명</td>
                <td width= 100 class=title>연락처</td>
                <td width= 240 class=title>차종</td>
                <td width= 80 class=title>견적일자</td>				
                <td width= 50 class=title>작성자</td>
              </tr>
            </table>
          </td>
		  <td width=20>&nbsp; </td>
		</tr>
	  </table>
	</td>
  </tr>-->
  <tr>
	<td>
		<table border="0" cellspacing="1" cellpadding="0" width=100%>
		  <tr>
			<td colspan=2><iframe src="./esti_res_sc_in.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&esti_m=<%= esti_m %>&esti_m_dt=<%= esti_m_dt %>&esti_m_s_dt=<%= esti_m_s_dt %>&esti_m_e_dt=<%= esti_m_e_dt %>" name="EstiList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
		  </tr>								
	  </table>
    </td>
  </tr>
</table>
</body>
</html>