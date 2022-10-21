<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*,acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String car_no 			= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String ins_con_no 	= request.getParameter("ins_con_no")==null?"":request.getParameter("ins_con_no");
	
	String content_code = "";
	String content_seq  = "";

	Vector attach_vt = new Vector();		
	int attach_vt_size = 0;		
	
	
	content_code = "INSUR";
	content_seq  = ins_con_no;

	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	attach_vt_size = attach_vt.size();	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	
//-->
</script>
</head>

<body>
<center>
<form name='form1' method='post' >
<table border="0" cellspacing="0" cellpadding="0" width=670>
   
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=car_no%> 가입증명서</span></td>
        <td align="right"></td>
    </tr>	
    <tr>
        <td colspan="2" class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td class="title" width='10%'>연번</td>
                  <td class="title" width='50%'>파일명</td>
                  <td class="title" width='20%'>파일보기</td>
                  <td class="title" width='20%'>등록일</td>
                </tr>
                <% for(int i=0; i<attach_vt_size; i++){
                		Hashtable attach_ht = (Hashtable)attach_vt.elementAt(i);  
                %>
                <tr>
                  <td align="center"><%= i+1 %></td>
                  <td align="center"><%=attach_ht.get("FILE_NAME")%></td>
                  <td align="center"><a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='보기' ><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
                  <td align="center"><%=attach_ht.get("REG_DT")%></td>
                </tr>                
                <% 	}%>
            </table>
        </td>
    </tr>	  
</table>
</form>
</center>
</body>
</html>
