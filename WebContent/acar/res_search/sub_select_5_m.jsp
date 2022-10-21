<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");	
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");	
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript">
<!--
	function SetCarServ(car_mng_Id, seq_no, che_kd, che_no, che_comp, che_dt){
		var ofm = opener.document.form1;
		var fm = document.form1;		
		ofm.seq_no.value = seq_no;
		ofm.che_kd.value = che_kd;				
		ofm.che_no.value = che_no;
		ofm.che_comp.value = che_comp;		
		self.close();		
	}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=770>
  <form name="form1" method="post" action="sub_select_5_m.jsp">
    <input type='hidden' name='c_id' value='<%=c_id%>'>
    <input type='hidden' name='rent_st' value='<%=rent_st%>'>
    <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>	
    <input type='hidden' name='user_id' value='<%=user_id%>'>
    <tr> 
      <td width="400">차량번호 : <%=car_no%> </td>
      <td align="right" width="350">&nbsp;</td>
      <td width="20">&nbsp;</td>
    </tr>
    <tr> 
      <td  class=line colspan="2" width="750">
        <table border=0 cellspacing=1 width="750">
          <tr> 
            <td class=title width="30">연번</td>
            <td class=title width="80">점검일자</td>
            <td class=title width="150">점검종별</td>
            <td class=title width="170">점검정비 유효기간</td>
            <td class=title width="100">정비담당자</td>
            <td class=title width="220">점검업체</td>
          </tr>
        </table>
      </td>
      <td width="20">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3"><iframe src="sub_select_5_m_in.jsp?auth_rw=<%=auth_rw%>&c_id=<%=c_id%>" name="inner_s" width="770" height="500" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
	  </iframe></td>
    </tr>
  </form>
</table>
</body>
</html>