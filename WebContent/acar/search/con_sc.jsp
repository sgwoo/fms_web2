<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//선택한 세부내용 보기
	function Move(auth_rw,no){
		var fm = document.form1;
		var m_id = fm.m_id.value;
		var l_cd = fm.l_cd.value;
		var c_id = fm.c_id.value; 		
		parent.window.opener.location.href='/acar/menu/search.jsp?no='+no+'&auth_rw='+auth_rw+'&m_id='+m_id+'&l_cd='+l_cd+'&c_id='+c_id;
	}
-->
</script>
</head>
<link rel=stylesheet type="text/css" href="../../include/table.css">
<body leftmargin="15" topmargin="0">
<object id=window type="application/x-oleobject"classid="clsid:adb880a6-d8ff-11cf-9377-00aa003b7a11"> 
<param name="Command" value="minimize"> 
</object> 
<%
	//검색구분
	String s_rent_l_cd 	= request.getParameter("s_rent_l_cd")	==null?"":request.getParameter("s_rent_l_cd");
	String s_client_nm 	= request.getParameter("s_client_nm")	==null?"":request.getParameter("s_client_nm");
	String s_car_no 	= request.getParameter("s_car_no")		==null?"":request.getParameter("s_car_no");
	String s_rent_s_dt 	= request.getParameter("s_rent_s_dt")	==null?"":request.getParameter("s_rent_s_dt");
	String s_kd 		= request.getParameter("s_kd")			==null?"":request.getParameter("s_kd");
	String s_wd 		= request.getParameter("s_wd")			==null?"":request.getParameter("s_wd");
	String mode 		= request.getParameter("mode")			==null?"":request.getParameter("mode");
%>
<form name='form1' method='post' target='d_content' action='/acar/car_rent/con_reg_frame.jsp'>
  <input type='hidden' name='mode' value='<%=mode%>'>
  <input type='hidden' name='m_id' value=''>
  <input type='hidden' name='l_cd' value=''>
  <input type='hidden' name='c_id' value=''>
  <input type='hidden' name='s_rent_l_cd'  value='<%=s_rent_l_cd%>'>
  <input type='hidden' name='s_client_nm' value='<%=s_client_nm%>'>
  <input type='hidden' name='s_car_no' value='<%=s_car_no%>'>
  <input type='hidden' name='s_rent_s_dt' value='<%=s_rent_s_dt%>'>
  <input type='hidden' name='s_kd' value='<%=s_kd%>'>
  <input type='hidden' name='s_wd' value='<%=s_wd%>'>

<table border="0" cellspacing="0" cellpadding="0" width=900>
	<tr>
	  <td>			
        <table border="0" cellspacing="0" cellpadding="0" width=900>
          <tr>
			<td>
			  <table border="0" cellspacing="0" cellpadding="0" width='880'>
			    <tr id='tr_title'>
					<td class='line' width='900' id='td_title' >			
			        <table border="0" cellspacing="1" cellpadding="0" width='880'>
			          <tr> 
						<td width='30' class='title'>선택</td>
			            <td width='30' class='title'>연번</td>
			            <td width='96' class='title'>계약번호 </td>
			            <td width='66' class='title'>계약일</td>
			            <td width='150' class='title'>상호</td>
			            <td width='157' class='title'>차명</td>
			            <td width='80' class='title'>차량번호</td>
			            <td width='66' class='title'>대여개시일</td>
			            <td width='75' class='title'>대여료</td>
			            <td width='65' class='title'>영업담당</td>
			            <td width='65' class='title'>관리담당</td>
			          </tr>
			        </table>
					</td>
				</tr>
			  </table>				
				<iframe src="con_sc_in.jsp?mode=<%=mode%>&s_rent_l_cd=<%=s_rent_l_cd%>&s_client_nm=<%=s_client_nm%>&s_car_no=<%=s_car_no%>&s_rent_s_dt=<%=s_rent_s_dt%>&s_kd=<%=s_kd%>&s_wd=<%=s_wd%>" name="inner" width="900" height="250" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
				</iframe>
			</td>
		  </tr>
        </table>
	  </td>
	</tr>
	<tr>
	  <td><HR></td>
    </tr>
	<tr height=20>
	  <td>
        <table border="0" width="700" align="center">
          <tr align="center">  
            <td width="100"><a href="javascript:Move('R/W','1');" onClick="window.Click();">계약사항</a></td>
            <td width="100"><a href="javascript:Move('R/W','2');" onClick="window.Click();">대여사항</a></td>
            <td width="100"><a href="javascript:Move('R/W','3');" onClick="window.Click();">할부금사항</a></td>
            <td width="100"><a href="javascript:Move('R/W','4');" onClick="window.Click();">과태료사항</a></td>
            <td width="100"><a href="javascript:Move('R/W','5');" onClick="window.Click();">보험료사항</a></td>
            <td width="100"><a href="javascript:Move('R/W','6');" onClick="window.Click();">정비사항</a></td>
            <td width="100"><a href="javascript:Move('R/W','7');" onClick="window.Click();">사고사항</a></td>
		  </tr>
		</table>
	  </td>
    </tr>	
</table>
</form>
</body>
</html>
