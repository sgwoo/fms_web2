<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String name = request.getParameter("name")==null?"":request.getParameter("name");

	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	Vector names = cod.getNameList(name);
	int name_size = names.size();
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
function emp_upd(emp_id){
	var fm = document.form1;
	fm.action = './car_office_p_u.jsp?emp_id='+emp_id;
	fm.target = 'd_content';
	fm.submit();
	this.close();
}
//-->
</script>
</head>

<body>
<form name="form1" method="post">
<table width=100% border="0" cellspacing="0" cellpadding="0">
	<tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <font color="#666666"> 
        <font color="#0066FF">수정</font>하시려면, <font color="#0066FF">성명</font>을 
        클릭하세요.</font></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" width="8%">연번</td>
                    <td class="title" width="17%">소속사</td>
                    <td class="title" width="18%">근무처</td>
                    <td class="title" width="16%">성명</td>
                    <td class="title" width="18%">핸드폰</td>
                    <td class="title" width="23%">메일주소</td>
                </tr>
                <%for(int i = 0 ; i < name_size ; i++){
			        Hashtable nm = (Hashtable)names.elementAt(i);%>
                <tr> 
                    <td align="center"><%= i+1 %></td>
                    <td align="center">&nbsp;<%=nm.get("CAR_COMP_NM")%></td>
                    <td align="center">&nbsp;<%=nm.get("CAR_OFF_NM")%></td>
                    <td align="center">&nbsp;<a href="javascript:emp_upd('<%= nm.get("EMP_ID") %>')"><%=nm.get("EMP_NM")%></a></td>
                    <td align="center">&nbsp;<%=nm.get("EMP_M_TEL")%></td>
                    <td>&nbsp;<%=nm.get("EMP_EMAIL")%></td>
                </tr>
                 <%}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
