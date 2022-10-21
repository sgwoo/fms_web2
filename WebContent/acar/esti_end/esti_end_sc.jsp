<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_day = request.getParameter("s_day")==null?"":request.getParameter("s_day");
	
	if(s_day.equals("0")) s_day = "";
	
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
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
	var SUBWIN="./esti_end_i.jsp";	
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
<body rightmargin=0>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <tr> 
  <!--      
    <td class='line' width="100%"> 
      <table border="0" cellspacing="1" cellpadding="1" width=100%>
        <tr> 
          <td width= 30 class=title>연번</td>
          <td width= 100 class=title>영업사원</td>
          <td width= 150 class=title>거래처명</td>
          <td width= 200 class=title>차종</td>
          <td width= 80 class=title>마감일자</td>
          <td width= 60 class=title>담당자</td>
          <td width= 80 class=title>견적결과</td>
          <td width= 100 class=title>미체결내용</td>
        </tr>
      </table>
    </td>
    <td width="20">&nbsp; </td>
  -->  
  </tr>
  <tr>
	<td><iframe src="./esti_end_sc_in.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_year=<%=s_year%>&s_mon=<%=s_mon%>&s_day=<%=s_day%>" name="EstiList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe>
	</td>
  </tr>
</table>
</body>
</html>