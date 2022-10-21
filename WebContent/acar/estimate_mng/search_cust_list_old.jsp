<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCarVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	Vector vars = new Vector();
	
	if(!t_wd.equals("")){
		vars = e_db.getCustSubListOld(t_wd);
	}
	
	int size = vars.size();
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	
		fm.action = 'search_cust_list_old.jsp';
		fm.submit();
	}
	
	function setCode(nm, ssn, tel, fax, reg_dt, doc_type, est_email){
		var fm = opener.document.form1;	
		<%if(from_page.equals("/acar/secondhand/secondhand_price_20090901.jsp")){%>			
			fm.cust_nm.value 	= nm;			
			fm.cust_tel.value 	= tel;
			fm.cust_fax.value 	= fax;
			fm.doc_type.value 	= doc_type;
			fm.cust_email.value 	= est_email;
		<%}else{%>
			fm.est_nm.value 	= nm;
			fm.est_ssn.value 	= ssn;
			fm.est_tel.value 	= tel;
			fm.est_fax.value 	= fax;
			fm.doc_type[0].checked = true;
			if(doc_type == '1') fm.doc_type[0].checked = true;
			if(doc_type == '2') fm.doc_type[1].checked = true;
			if(doc_type == '3') fm.doc_type[2].checked = true;
			fm.est_email.value 	= est_email;
		<%}%>
		self.close();
	}
	
	function new_search(){
		var fm = document.form1;
		fm.action = 'search_esti_sub_list.jsp';
		fm.submit();
	}		
//-->
</script>
</head>
<body>
<form name='form1' action='search_cust_list_old.jsp' method='post'>
<input type='hidden' name='size' value='<%=size%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>고객조회</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><select name="s_kd"> 
				<option value="1" selected>검색어</option> 
			</select> 
			<input accesskey="s" class="keyword" title=검색어 type="text" name="t_wd" value="<%=t_wd%>"> 
			<a href="javascript:search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>
    </tr>	
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right"><a href="javascript:new_search();">최근 3개월이내 데이타</a> | <font color=red>→ 모든데이타</font>&nbsp;</td>
    </tr> 
    	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>기존견적고객 (전체, 최대10라인)</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=5%>연번</td>
                    <td class=title width=35%>상호/성명</td>
                    <td class=title width=20%>사업자/주민등록번호</td>
                    <td class=title width=20%>전화번호</td>
                    <!--<td class=title width=10%>FAX</td>
                    <td class=title width=14%>이메일</td>-->
                    <td class=title width=10%>최초견적</td>					
                    <td class=title width=10%>최근견적</td>					
    		    </tr>	
    		    <%	if(size >10) size = 10; %>				
              		<%for(int i = 0 ; i < size ; i++){
    					Hashtable var = (Hashtable)vars.elementAt(i);%>							
						<tr>
							<td align="center"><%=i+1%></td>
							<td>&nbsp;<a href="javascript:setCode('<%=var.get("EST_NM")%>', '<%=var.get("EST_SSN")%>', '<%=var.get("EST_TEL")%>', '<%=var.get("EST_FAX")%>', '<%=var.get("REG_DT")%>', '<%=var.get("DOC_TYPE")%>', '<%=var.get("EST_EMAIL")%>');"><%=var.get("EST_NM")%></a></td>
							<td>&nbsp;<%=var.get("EST_SSN")%></td>
							<td>&nbsp;<%=var.get("EST_TEL")%></td>
							<!--<td>&nbsp;<%=var.get("EST_FAX")%></td>
							<td>&nbsp;<%=var.get("EST_EMAIL")%></td>-->
							<td align="center"><%=var.get("REG_DT2")%><br><%=var.get("USER_NM2")%></td>
							<td align="center"><%=var.get("REG_DT")%><br><%=var.get("USER_NM")%></td>							
						</tr>
              		<%}%>				
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>		
    <tr> 
        <td align="right"> 
			<a href="javascript:self.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
        </td>
    </tr>  
</table>
</form>
</body>
</html>