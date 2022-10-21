<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String c_id 		= request.getParameter("c_id")==null?"":request.getParameter("c_id");
		
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	//������ ��������Ÿ� ǥ������Ʈ
	Vector vt = new Vector();
	vt = cr_db.getCarDistViewList(c_id);
	int vt_size = vt.size();
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='s_man.jsp'>
  
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  	<tr>
    	<td colspan=5>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������ > <span class=style5><%=car_no%> ��������Ÿ� ǥ������Ʈ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
        <td class=line2 colspan=2></td>
    </tr>		
    <tr> 
        <td class=line>
    	    <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width="10%">����</td>
                    <td class=title width="25%">����</td>
                    <td class=title width="20%">����</td>
                    <td class=title width="25%">����Ÿ�</td>		  
                    <td class=title width="20%">�������</td>                    
                </tr>
                <%for (int i = 0 ; i < vt_size ; i++){
        				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%//=ht.get("ST")%>
                    	<%if(String.valueOf(ht.get("ST")).equals("service")){%>����<%}%>
                    	<%if(String.valueOf(ht.get("ST")).equals("maint")){%>�˻�<%}%>
                    	<%if(String.valueOf(ht.get("ST")).equals("cls")){%>����<%}%>
                    </td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TOT_DT")))%></td>		  
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TOT_DIST")))%>km</td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>                    
                </tr>
                <%		}%>
            </table>
	    </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>  
    <tr> 
        <td>
	   * ����Ÿ�Ȯ�θ޽����� ����� ���Ͽ��� 9�ð濡 �����ڵ�� ����Ÿ��� ����������Ÿ��� ���Ͽ� ��ȯ������Ÿ��� ���������� �� �߼��մϴ�.     
	    </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr> 
        <td align="center">
	        <a href="javascript:window.close();"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>		
	    </td>
    </tr>
</table>
</form>
</body>
</html>