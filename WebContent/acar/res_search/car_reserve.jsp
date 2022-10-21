<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	//��������
	Hashtable reserv = rs_db.getCarInfo(c_id);
	
	//������Ȳ
	Vector conts = rs_db.getResCarList(c_id);
	int cont_size = conts.size();
%>
<form action="" name="form1" method="post" >
<input type='hidden' name='c_id' value='<%=c_id%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>  	
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ý��� > �������� > ������� > <span class=style5>������ �뿩����Ʈ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
   <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=8% style='height:38'>������ȣ</td>
                    <td width=12%>&nbsp;<font color="#FFFFCC"><b><font color="#000000"><%=reserv.get("CAR_NO")%></font></b></font></td>
                    <td class=title width=5%>����</td>
                    <td width=32%>&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></td>
                    <td class=title width=10%>���ʵ����</td>
                    <td width=9%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
                    <td class=title width=5%>Į��</td>
                    <td width=6%>&nbsp;<%=reserv.get("COLO")%></td>
                    <td class=title width=7%>��ⷮ</td>
                    <td width=6%>&nbsp;<%=reserv.get("DPM")%>cc</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="5%">����</td>
                    <td class=title width="8%">����</td>
                    <td class=title width="6%">����</td>
                    <td class=title width="33%">�뿩�Ⱓ</td>
                    <td class=title width="20%">��ȣ</td>
                    <td class=title width="10%">�����</td>
                    <td class=title width="10%">����뿩��</td>
                    <td class=title width="8%">�����</td>					
                </tr>
              <%	if(cont_size > 0){
    				for(int i = 0 ; i < cont_size ; i++){
    					Hashtable reservs = (Hashtable)conts.elementAt(i);%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=reservs.get("RENT_ST")%></td>
                    <td align="center"><%=reservs.get("USE_ST")%></td>
                    <td align="center"><%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_START_DT")))%> ~ <%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_END_DT")))%></td>
                    <td align="center"><%=reservs.get("FIRM_NM")%></td>
                    <td align="center"><%=reservs.get("CUST_NM")%></td>
                    <td align="right"><%=AddUtil.parseDecimal(String.valueOf(reservs.get("FEE_AMT")))%>&nbsp;��&nbsp;&nbsp;</td>
                    <td align="center"><%=reservs.get("BUS_NM")%></td>					
                </tr>
              <%		}
      			}else{%>
                <tr> 
                    <td colspan='8' align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
                </tr>
              <%	}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right"><a href="javascript:self.close()"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>	
</table>
</form>
</body>
</html>
