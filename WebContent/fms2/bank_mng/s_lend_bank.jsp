<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String fund_id 	= request.getParameter("fund_id")==null?"":request.getParameter("fund_id");
	String cont_bn 	= request.getParameter("cont_bn")==null?"":request.getParameter("cont_bn");
	String from_page = request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	Vector bank_lends = abl_db.getBankLendList(cont_bn, "0");
	int bl_size = bank_lends.size();
	
	int count = 0;
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--	
	function setLendBank(lend_id){
		if(confirm('연결시겠습니까?'))
		{
			var fm = document.form1;		
			fm.action="s_lend_bank_a.jsp?fund_id=<%=fund_id%>&from_page=<%=from_page%>&lend_id="+lend_id;
			fm.target="i_no";
			fm.submit();
		}
	}
	
	function select_LendBank(){
	
		var fm = document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("연결할 계약을 선택하세요.");
			return;
		}	
		
		if(confirm('연결시겠습니까?'))
		{				
			fm.action="s_lend_bank_a.jsp?fund_id=<%=fund_id%>&from_page=<%=from_page%>&lend_id=";
			fm.target="i_no";
			fm.submit();
		}
	}
		
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}	
		}
		return;
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
			    	<td width='40' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>								
			    	<td width=60 class=title>계약번호</td>					
			    	<td width=100 class=title>계약일자</td>										
			    	<td width=150 class=title>금융사</td>										
			    	<td width=110 class=title>약정금액</td>				
			    	<td width=100 class=title>대출이율</td>
			    	<td width=100 class=title>상환개시일</td>					
            	</tr>
				<%for(int i = 0 ; i < bl_size ; i++){
					Hashtable bank_lend = (Hashtable)bank_lends.elementAt(i);
					if(String.valueOf(bank_lend.get("FUND_YN")).equals("Y")) continue;
					count++;
					%>
            	<tr>
			    	<td align=center><%=count%></td>
			    	<td align='center'><input type="checkbox" name="ch_l_cd" value="<%=bank_lend.get("LEND_ID")%>"></td>
			    	<td align=center><a href="javascript:setLendBank('<%=bank_lend.get("LEND_ID")%>')" onMouseOver="window.status=''; return true"><%=bank_lend.get("LEND_ID")%></a></td>
			    	<td align=center><%=bank_lend.get("CONT_DT")%></td>
			    	<td align=center><%=bank_lend.get("BANK_NM")%></td>															
			    	<td align=right><%=Util.parseDecimal(String.valueOf(bank_lend.get("CONT_AMT")))%></td>
			        <td align=center><%=bank_lend.get("LEND_INT")%>%</td>
				<td align=center><%=bank_lend.get("CONT_START_DT")%></td>										
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
        <td class=h></td>
    </tr>	
    <tr>         
        <td align="center">
            <%if(bl_size>0){%>
            <a href="javascript:select_LendBank();" title='선택처리'><img src="/acar/images/center/button_stbh.gif" align="absmiddle" border="0"></a>&nbsp;
            <%}%>
            <a href="javascript:window.close();" class="btn"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>
</body>
</html>