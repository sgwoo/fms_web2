<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.reserve_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.reserve_search.ReserveSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	//��������
	Hashtable reserv = rs_db.getCarInfo(c_id);
	
	//������Ȳ
	Vector conts = rs_db.getReserveRegList(c_id);
	int cont_size = conts.size();
%>
<form action="" name="form1" method="post" >
<input type='hidden' name='c_id' value='<%=c_id%>'>
  <table border=0 cellspacing=0 cellpadding=0 width=770>
    <tr> 
      <td><font color="navy">������� -> ������ȸ </font>-> <font color="red">����������Ȳ</font></td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="1" width=770>
          <tr> 
            <td class=title width=60>������ȣ</td>
            <td align="center" width=90><font color="#FFFFCC"><b><font color="#000000"><%=reserv.get("CAR_NO")%></font></b></font></td>
            <td class=title width=50>����</td>
            <td align="left">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></td>
            <td class=title width="60">���ʵ����</td>
            <td align="center" width="70"><%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
            <td class=title width="50">Į��</td>
            <td align="center" width=60><%=reserv.get("COLO")%></td>
            <td class=title width="60">��ⷮ</td>
            <td align="center" width="60"><%=reserv.get("DPM")%>cc</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="1" width=770>
          <tr> 
            <td class=title width="30">����</td>
            <td class=title width="70">����</td>
            <td class=title width="40">����</td>
            <td class=title width="120">�ε��Ͻ�</td>
            <td class=title width="120">�����Ͻ�</td>
            <td class=title width="200">�����</td>
            <td class=title width="190">��ȣ</td>
          </tr>
          <%	if(cont_size > 0){
				for(int i = 0 ; i < cont_size ; i++){
					Hashtable reservs = (Hashtable)conts.elementAt(i);%>
          <tr> 
            <td align="center"><%=i+1%></td>
            <td align="center"><%=reservs.get("RES_ST")%></td>
            <td align="center"><%=reservs.get("USE_ST")%></td>
            <td align="center"><%=AddUtil.ChangeDate3(String.valueOf(reservs.get("DELI_DT")))%></td>
            <td align="center"><%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RET_DT")))%></td>
            <td align="center"><%=reservs.get("CUST_NM")%></td>
            <td align="center"><%=reservs.get("CUST_FIRM_NM")%></td>
          </tr>
          <%		}
  			}else{%>
          <tr> 
            <td colspan='7' align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
          </tr>
          <%	}%>
        </table>
      </td>
    </tr>
    <tr> 
      <td align="right"><a href="javascript:self.close()" onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
    </tr>	
  </table>
</form>
</body>
</html>
