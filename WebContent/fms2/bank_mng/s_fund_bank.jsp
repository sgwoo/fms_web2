<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String lend_id 	= request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String cont_bn 	= request.getParameter("cont_bn")==null?"":request.getParameter("cont_bn");
	String from_page = request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	Vector vt = abl_db.getWorkingFundList(cont_bn, "0");
	int vt_size = vt.size();
	
	int count = 0;
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--	
	function setFundBank(fund_id){
		var fm = document.form1;
		if(confirm('연결시겠습니까?'))
		{		
			<%if(from_page.equals("/fms2/bank_mng/debt_scd_reg_i.jsp")){%>
			opener.document.form1.fund_id.value = fund_id;
			self.close();
			<%}else if(from_page.equals("/acar/bank_mng/bank_lend_i.jsp")){%>
			fm.action="/acar/bank_mng/bank_lend_i.jsp?fund_id="+fund_id;
			fm.target="r_body";
			fm.submit();
			self.close();
			<%}else{%>
			fm.action="s_fund_bank_a.jsp?lend_id=<%=lend_id%>&from_page=<%=from_page%>&fund_id="+fund_id;
			fm.target="i_no";
			fm.submit();
			<%}%>
		}
	}	
//-->
</script>
</head>

<body>
<form name='form1' method='post' action=''>
<table border=0 cellspacing=0 cellpadding=0 width="700">
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 구매자금관리 > <span class=style5>은행대출조회</span></span></td>
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
            <table border="0" cellspacing="1" cellpadding="3" width="100%">
            	<tr>
			    	<td width=40 class=title>연번</td>								
			    	<td width=100 class=title>관리번호</td>					
			    	<td width=100 class=title>대출구분</td>										
			    	<td width=100 class=title>금융기관</td>										
			    	<td width=100 class=title>대출한도</td>				
			    	<td width=100 class=title>기준금리</td>
			    	<td width=60 class=title>적용금리</td>					
			    	<td width=100 class=title>기준일자</td>					
            	</tr>
				<%for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					if(String.valueOf(ht.get("FUND_TYPE")).equals("운용자금")) continue;
					count++;
					%>
            	<tr>
			    	<td align=center><%=count%></td>				
			    	<td align=center><a href="javascript:setFundBank('<%=ht.get("FUND_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("FUND_NO")%></a></td>
			    	<td align=center><%=ht.get("FUND_TYPE")%></td>
			    	<td align=center><%=ht.get("BANK_NM")%></td>															
			    	<td align=center><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CONT_AMT")))%>원</td>
			        <td align=center><%=c_db.getNameByIdCode("0023", "", String.valueOf(ht.get("APP_B_ST")))%></td>
				<td align=center><%=ht.get("FUND_INT")%>%</td>										
				<td align=center><%=ht.get("APP_B_DT")%></td>										
            	</tr>
				<%}%>
				<%	if(count==0){%>
				<tr>
					<td colspan='8' align=center>데이타가 없습니다.</td>
				</tr>
				<%	}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="center"><a href="javascript:window.close();" class="btn"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
    <tr> 
        <td>※ 운용자금은 안나옵니다.</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>
</body>
</html>