<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//��ȸ
	InsDatabase ins_db = InsDatabase.getInstance();
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
<form name='form1' method='post'>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������� > ������ȸ > <span class=style5>���� �ߺ���� ��ȸ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>  
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="30" rowspan="2">����</td>
                    <td class=title colspan="2">�Ϸù�ȣ</td>
                    <td class=title colspan="2">������ȣ</td>
                    <td class=title width="60" rowspan="2">������</td>
                    <td class=title width="130" rowspan="2">���ǹ�ȣ</td>			
                    <td class=title width="90" rowspan="2">����Ⱓ</td>
                    <td class=title width="80" rowspan="2">��������</td>
                    <td class=title width="60" rowspan="2">����</td>
                </tr>
                <tr> 
                    <td class=title width="50">�ڵ���</td>
                    <td class=title width="30">����</td>
                    <td class=title width="85">������</td>
                    <td class=title width="85">������</td>
                </tr>
              <%//�����̷�-�Ϲݺ���
    			Vector inss = ins_db.getInsDoubleList();
    			int ins_size = inss.size();
    			if(ins_size > 0){
            		for(int i = 0 ; i < ins_size ; i++){
    				Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td><%=ins.get("CAR_MNG_ID")%><%//=ins.get("INS_KD")%></td>
                    <td><%=ins.get("INS_ST")%><%//=ins.get("CAR_USE")%></td>			
                    <td><%=ins.get("FIRST_CAR_NO")%></td>
                    <td><%=ins.get("CAR_NO")%></td>
                    <td><%=ins.get("INS_COM_NM")%></td>
                    <td><%=ins.get("INS_CON_NO")%></td>			
                    <td>
        			<%=AddUtil.ChangeDate2((String)ins.get("INS_START_DT"))%><br>~<%=AddUtil.ChangeDate2((String)ins.get("INS_EXP_DT"))%>
        			</td>
                    <td><%=AddUtil.ChangeDate2((String)ins.get("EXP_DT"))%></td>
                    <td><%=ins.get("INS_STS")%></td>
                </tr>
              <%		}
    		  }%>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right"><a href='javascript:window.close()'><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"></a></td>
    </tr>
</table>
</form>
</body>
</html>