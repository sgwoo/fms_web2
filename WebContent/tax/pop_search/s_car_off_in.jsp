<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.pay_mng.*, acar.bill_mng.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	NeoErpUDatabase 	neoe_db = NeoErpUDatabase.getInstance();

	//거래처정보
	Vector vts =  ps_db.getOffSearchList("tax_car_off_id", t_wd);
	int vt_size = vts.size();

%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
//-->
</script>
</head>
<body>
<%	if(!t_wd.equals("")){%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
        <%	if(vt_size > 0){
				for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vts.elementAt(i);	
					
					String ven_st  	= String.valueOf(ht.get("VEN_ST"));
					String ven_code	= String.valueOf(ht.get("VEN_CODE"));
					String ven_name	= String.valueOf(ht.get("VEN_NAME"));
					String s_idno 	= String.valueOf(ht.get("OFF_IDNO"));
					if(ven_code.equals("") && !s_idno.equals("")){
						Hashtable vendor = neoe_db.getVendorCaseS(ven_code, s_idno);
						ven_code = String.valueOf(vendor.get("VEN_CODE"));
						ven_name = String.valueOf(vendor.get("VEN_NAME"));
					}
					%>
        <tr> 
          <td width='30' align='center'><%= i+1 %></td>          
          <td width='180' align='center'><a href="javascript:parent.select('<%= ht.get("OFF_ID")%>','<%= ven_code%>')" onMouseOver="window.status=''; return true"><%=ht.get("OFF_NM")%></a></td>
          <td width='100' align='center'><%=ht.get("OWN_NM")%></td>
          <td width='120' align='center'><%=ht.get("OFF_IDNO")%></td>
          <td width='170'>&nbsp;<%=ht.get("VEN_ADDR")%></td>
        </tr>
        <%				}
			}else{	%>
        <tr> 
          <td align='center' colspan="6">등록된 데이타가 없습니다</td>
        </tr>
        <%			}		%>
      </table>
		</td>
	</tr>
</table>
<%	}%>
</body>
</html>