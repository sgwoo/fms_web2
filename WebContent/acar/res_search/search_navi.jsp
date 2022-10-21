<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.res_search.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String s_brch_id = request.getParameter("s_brch_id")==null?"":request.getParameter("s_brch_id");
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vt = c_db.getNaviStatListY();
	int vt_size = vt.size();
		
	
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function select(serial_no){		
		var ofm = opener.document.form1;
		ofm.serial_no.value = serial_no;
		self.close();			
	}
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > <span class=style5>네비게이션 검색</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>네비게이션 정보</span></td>
    </tr>    
     <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td width='10%' class='title'>연번</td>
                    <td width='20%' class='title'>S / N</td>
                    <td width='30%' class='title'>모델명</td>
                    <td width='40%' class='title'>특이사항</td>                    
                  </tr>
                  <%for(int i = 0 ; i < vt_size ; i++){
    			Hashtable ht = (Hashtable)vt.elementAt(i);%>
                  <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><a href="javascript:select('<%= ht.get("SERIAL_NO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("SERIAL_NO")%></a></td>                    
                    <td align='center'><%=ht.get("MODEL")%></td>
                    <td align='center'><%=ht.get("REMARK")%></td>
                  </tr>    			
    		  <%}%>	
                </table>
	    </td>	    
	</tr>
    <tr>
        <td class=h></td>
    </tr>	
 
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
