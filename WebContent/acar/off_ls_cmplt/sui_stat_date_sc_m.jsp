<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.offls_cmplt.*" %>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	Vector vt = olcD.getSuiStatLst2("2", s_yy, gubun1, gubun2, gubun3, gubun4);
	int vt_size = vt.size();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='s_yy' 		value='<%=s_yy%>'>
  <input type='hidden' name='s_mm' 		value='<%=s_mm%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 		value='<%=gubun4%>'>
<table border=0 cellspacing=0 cellpadding=0 width=<%=50+(320*12)%>>
    <!--
    <tr>
      <td>2. 월별 계약현황</td>
    </tr>
    -->					
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td rowspan="2" width="50" class=title>구분</td>
					<%for (int j = 0 ; j < 12 ; j++){%>
                    <td colspan=4 class=title><%=j+1%>월</td>
					<%}%>
					<td colspan=4 class=title>전체</td>
                </tr>
               <tr align="center"> 
					<%for (int j = 0 ; j < 12+1 ; j++){%>
                    <td width="60" class=title>대수</td>
                    <td width="60" class=title>차령</td>
                    <td width="100" class=title>실질대당<br>잔가손익</td>
                    <td width="100" class=title>가중평균<br>실질잔가<br>손익율</td>
					<%}%>
                </tr>
                <%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
				%>
               <tr> 
                    <TD class='title'><%=ht.get("JG_2")%></TD>
                    <%for (int j = 0 ; j < 13 ; j++){%>
					<TD align="center" <%if(String.valueOf(ht.get("JG_2")).equals("소계")){%>class='title'<%}%>><%=ht.get("E_VAR"+(j+1))%></TD>
					<TD align="center" <%if(String.valueOf(ht.get("JG_2")).equals("소계")){%>class='title'<%}%>><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("F_VAR"+(j+1))),2)%></TD>
					<TD align="right" <%if(String.valueOf(ht.get("JG_2")).equals("소계")){%>class='title' style='text-align:right'<%}%>><%=AddUtil.parseDecimalLong((String)ht.get("O_VAR"+(j+1)))%></TD>
					<TD align="center" <%if(String.valueOf(ht.get("JG_2")).equals("소계")){%>class='title'<%}%>><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("M_VAR"+(j+1))),2)%>%</TD>
					<%}%>
                </tr>				
				<%	} %>		
            </table>
        </td>
    </tr>		
</table>
</form>
</body>
</html>