<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.common.*" %>
<%@ page import="acar.cus0601.*, acar.bill_mng.*" %>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	
	Cus0601_Database c61_db = Cus0601_Database.getInstance();
	c61_soBn = c61_db.getServOff(off_id);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//네오엠 거래처 정보
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	String ven_code = c61_soBn.getVen_code();
	
	Hashtable ven = new Hashtable();
	if(!ven_code.equals("")){
		ven = neoe_db.getVendorCase(ven_code);
	}
	
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function ServOffUpDisp(){
	location.href = "cus0601_d_cont_u.jsp?auth_rw=<%= auth_rw %>&off_id=<%= off_id %>";
}
//-->
</script>
</head>
<body leftmargin="10">

<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" celpadding=3 width=100%>
                <tr> 
                    <td class=title>상호</td>
                    <td colspan="3">&nbsp;<%=c61_soBn.getOff_nm()%></td>
                    <td class=title>지정업체</td>
                    <td>&nbsp;<%=c_db.getNameById(c61_soBn.getCar_comp_id(),"CAR_COM")%></td>
                    <td class=title>등급</td>
                    <td>&nbsp;<%=c61_soBn.getOff_st_nm()%></td>
                </tr>
                <tr> 
                    <td class=title>대표자</td>
                    <td>&nbsp;<%=c61_soBn.getOwn_nm()%></td>
                    <td class=title>사업자번호</td>
                    <td>&nbsp;<%=AddUtil.ChangeEnt_no(c61_soBn.getEnt_no())%></td>
                    <td class=title>업태</td>
                    <td>&nbsp;<%=c61_soBn.getOff_sta()%></td>
                    <td class=title>종목</td>
                    <td>&nbsp;<%=c61_soBn.getOff_item()%></td>
                </tr>
                <tr> 
                    <td class=title>주소</td>
                    <td align=left colspan=5>&nbsp;<%=c61_soBn.getOff_post()%>&nbsp;<%=c61_soBn.getOff_addr()%></td>
                    <td class=title>사무실전화</td>
                    <td>&nbsp;<%=c61_soBn.getOff_tel()%></td>
                </tr>
                <tr> 
                    <td class=title width=10%>계좌개설은행</td>
                    <td width=15%>&nbsp;<%=c61_soBn.getBank()%></td>
                    <td class=title width=10%>계좌번호</td>
                    <td width=15%>&nbsp;<%=c61_soBn.getAcc_no()%></td>
                    <td class=title width=10%>예금주</td>
                    <td width=15%>&nbsp;<%=c61_soBn.getAcc_nm()%></td>
                    <td class=title width=10%>팩스</td>
                    <td width=15%>&nbsp;<%=c61_soBn.getOff_fax()%></td>
                </tr>
                <tr> 
                    <td class=title>특이사항</td>
                    <td align=left colspan=7>&nbsp;<%=c61_soBn.getNote()%></td>
                </tr>
                <tr> 
                    <td class=title>네오엠거래처</td>
                    <td align=left colspan=7>&nbsp;<%if(!ven_code.equals("")){%>(<%=ven_code%>)&nbsp;<%=ven.get("VEN_NAME")%><%}%><input type="hidden" name="ven_code" value="<%= ven_code %>"></td>
                </tr>
				
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr> 
        <td align="right">
	  <% if(!auth_rw.equals("1")){ %>
	  	<a href="javascript:ServOffUpDisp()" onMouseOver="window.status=''; return true"><img src=../images/center/button_modify_s.gif border=0></a>
	  <% } %></td>
    </tr>
</table>
</body>
</html>