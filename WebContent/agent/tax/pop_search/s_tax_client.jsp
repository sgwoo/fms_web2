<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.accid.*, tax.*"%>
<jsp:useBean id="ClientMngDb" scope="page" class="tax.ClientMngDatabase"/>
<%@ include file="/agent/cookies_base.jsp" %>

<%
	String item_id = request.getParameter("item_id")==null?"":request.getParameter("item_id");
	
	Vector accids = ClientMngDb.getTaxClientsList(item_id);
	int accid_size = accids.size();
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//계약선택
	function Disp(rent_l_cd, client_st, client_id, site_id, firm_nm, client_nm, enp_no, ssn, bus_cdt, bus_item, o_addr, o_tel, agnt_nm, agnt_dept, agnt_title, agnt_m_tel, agnt_email){
		var fm = document.form1;
		opener.form1.rent_l_cd.value 		= rent_l_cd;
		opener.form1.client_id.value 		= client_id;
		opener.form1.site_id.value 			= site_id;
		opener.form1.reccoregno[1].value 	= enp_no;
		opener.form1.reccossn[1].value 		= ssn;
		opener.form1.recconame[1].value 	= firm_nm;			
		opener.form1.reccoceo[1].value 		= client_nm;			
		opener.form1.reccoaddr[1].value 	= o_addr;			
		opener.form1.reccobiztype[1].value 	= bus_cdt;			
		opener.form1.reccobizsub[1].value 	= bus_item;											
		opener.form1.con_agnt_nm[1].value 	= agnt_nm;			
		opener.form1.rectel[1].value 		= o_tel;													
		if(client_st == '2')  	opener.form1.reccoregnotype[1].checked = true;
		else   					opener.form1.reccoregnotype[0].checked = true;		
		self.close();
	}
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='s_tax_client.jsp'>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 세금계산서발행 > 관련거래처 조회 ><span class=style5>
						세금계산서</span></span></td>
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
                    <td class=title width=5%>연번</td>
                    <td class=title width=5%>구분</td>
                    <td class=title width=15%>계약번호</td>
                    <td class=title width=30%>상호</td>
                    <td class=title width=15%>대표자</td>
                    <td class=title width=15%>사업자번호</td>			
                    <td class=title width=15%>법인/생년월일</td>
                </tr>
          <%for (int i = 0 ; i < accid_size ; i++){
				Hashtable accid = (Hashtable)accids.elementAt(i);%>
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td> 
                      <%if(accid.get("USE_YN").equals("Y")){%>
                      대여 
                      <%}else if(accid.get("USE_YN").equals("N")){%>
        			  해지
                      <%}else{%>
                      미결
                      <%}%>
                    </td>
                    <td>					  
			<a href="javascript:Disp('<%=accid.get("RENT_L_CD")%>', '<%=accid.get("CLIENT_ST")%>', '<%=accid.get("CLIENT_ID")%>', '<%=accid.get("R_SITE_SEQ")%>', '<%=accid.get("FIRM_NM")%>', '<%=accid.get("CLIENT_NM")%>', '<%=accid.get("ENP_NO")%>', '<%=accid.get("SSN")%>', '<%=accid.get("BUS_CDT")%>', '<%=accid.get("BUS_ITM")%>', '<%=accid.get("O_ADDR")%>', '<%=accid.get("O_TEL")%>', '<%=accid.get("CON_AGNT_NM")%>', '<%=accid.get("CON_AGNT_DEPT")%>', '<%=accid.get("CON_AGNT_TITLE")%>', '<%=accid.get("CON_AGNT_M_TEL")%>', '<%=accid.get("CON_AGNT_EMAIL")%>')" onMouseOver="window.status=''; return true"><%=accid.get("RENT_L_CD")%></a>
		    </td>
                    <td>
			<%//if(!accid.get("R_SITE_SEQ").equals("")){%>
                      	[<%=accid.get("ST")%>]
                      	<%//}%>
			<%=accid.get("FIRM_NM")%>
		    </td>
                    <td><%=accid.get("CLIENT_NM")%></td>
                    <td><%=accid.get("ENP_NO")%></td>			
                    <td><%=AddUtil.ChangeEnpH(String.valueOf(accid.get("SSN")))%></td>								
                </tr>
          <%		}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>	
    <tr> 
        <td align="center"><a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</body>
</html>