<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	Vector vars = new Vector();
	
	if(!t_wd.equals("") && !t_wd.equals(" ")){
		vars = e_db.getCustSubJudgeList(t_wd);
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
		fm.action = 'search_cust_list_judge.jsp';
		fm.submit();
	}
	
	//거래처 연체금액
	function cl_dlyamt(client_id)
	{
		window.open('/acar/account/stat_settle_sc_in_view_sub_list_client.jsp?client_id='+client_id, "CLIENT_DLVAMT", "left=10, top=10, width=1200, height=560, resizable=yes, scrollbars=yes, status=yes");
	}
	
//-->
</script>
</head>
<body>
<form name='form1' action='search_cust_list_judge.jsp' method='post'>
<input type='hidden' name='size' value='<%=size%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>심사용 고객조회</span></span></td>
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>기존견적고객 (최대20라인)</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=5%>연번</td>
                    <td class=title width=30%>상호 또는 성명</td>
                    <td class=title width=15%>사업자번호 또는<br>생년월일</td>
                    <td class=title width=15%>전화번호</td>
                    <td class=title width=14%>이메일</td>
                    <td class=title width=10%>최초견적</td>					
                    <td class=title width=10%>최근견적</td>					
    		    </tr>			
    		    <%	if(size >20) size = 20; %>	
              	<%	for(int i = 0 ; i < size ; i++){
    					Hashtable var = (Hashtable)vars.elementAt(i);%>							
						<tr>
							<td align="center"><%=i+1%></td>
							<td>&nbsp;<%=var.get("EST_NM")%></td>
							<td>&nbsp;<%=var.get("EST_SSN")%></td>
							<td>&nbsp;<%=var.get("EST_TEL")%></td>
							<td>&nbsp;<%=var.get("EST_EMAIL")%></td>
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
	<%	size = 0;
		if(!t_wd.equals("")){
			vars = e_db.getSpeCustSubList(t_wd);
		}
		size = vars.size();%>
    <%	if(size >20) size = 20; %>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>스마트견적고객 (최대20라인)</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=5%>연번</td>
                    <td class=title width=30%>상호 또는 성명</td>
                    <td class=title width=20%>사업자번호 또는<br>생년월일</td>
                    <td class=title width=20%>전화번호</td>
                    <td class=title width=17%>이메일</td>
                    <td class=title width=20%>등록일자</td>					
    		    </tr>				
			
              		<%for(int i = 0 ; i < size ; i++){
    					Hashtable var = (Hashtable)vars.elementAt(i);
    					String est_st = String.valueOf(var.get("EST_ST"));
    				%>							
						<tr>
							<td align="center"><%=i+1%></td>
							<td>&nbsp;<%if(est_st.equals("PM1")||est_st.equals("PM2")||est_st.equals("PM3")){%>[월렌트예약] <%}%><%=var.get("EST_NM")%></td>
							<td>&nbsp;<%=var.get("EST_SSN")%></td>
							<td>&nbsp;<%=var.get("EST_TEL")%></td>
							<td>&nbsp;<%=var.get("EST_EMAIL")%></td>
							<td align="center"><%=var.get("REG_DT")%></td>																					
						</tr>
              		<%}%>				
            </table>
        </td>
    </tr>		
    <tr> 
        <td class=h></td>
    </tr>		
	<%	size = 0;
		if(!t_wd.equals("")){			
			vars = e_db.getLcCustSubList(t_wd);
		}	
		size = vars.size();%>
    <%	if(size >20) size = 20; %>				
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>장기대여고객 (최대20라인)</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=5%>연번</td>
                    <td class=title width=30%>상호 또는 성명</td>
                    <td class=title width=20%>사업자번호 또는<br>생년월일</td>
                    <td class=title width=15%>전화번호</td>
                    <td class=title width=20%>이메일</td>
                    <td class=title width=10%>연체금액</td>
    		    </tr>				
			
              		<%for(int i = 0 ; i < size ; i++){
    					Hashtable var = (Hashtable)vars.elementAt(i);%>							
						<tr>
							<td align="center"><%=i+1%></td>
							<td>&nbsp;<%=var.get("EST_NM")%> / <%=var.get("CLIENT_NM")%></td>
							<td>&nbsp;<%=var.get("EST_SSN")%></td>
							<td>&nbsp;<%=var.get("EST_TEL")%></td>
							<td>&nbsp;<%=var.get("EST_EMAIL")%></td>
							<td align="center"><a href="javascript:cl_dlyamt('<%=var.get("CLIENT_ID")%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
						</tr>
              		<%}%>				
            </table>
        </td>
    </tr>	
    <tr> 
        <td class=h></td>
    </tr>		
	<%	size = 0;
		if(!t_wd.equals("")){
			vars = e_db.getEmpSubList(t_wd);
		}	
		size = vars.size();%>
    <%	if(size >20) size = 20; %>	
			
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>영업사원 (최대20라인)</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=5%>연번</td>
                    <td class=title width=30%>상호 또는 성명</td>
                    <td class=title width=20%>사업자번호 또는<br>생년월일</td>
                    <td class=title width=30%>전화번호</td>
                    <td class=title width=20%>이메일</td>					
    		    </tr>							
              		<%for(int i = 0 ; i < size ; i++){
    					Hashtable var = (Hashtable)vars.elementAt(i);%>							
						<tr>
							<td align="center"><%=i+1%></td>
							<td>&nbsp;<%=var.get("EST_NM")%></td>
							<td>&nbsp;<%=AddUtil.subDataCut(var.get("EST_SSN")+"",7)%></td>
							<td>&nbsp;<%=var.get("EST_TEL")%></td>
							<td>&nbsp;<%=var.get("EST_EMAIL")%></td>
						</tr>
              		<%}%>				
            </table>
        </td>
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