<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.* "%>
<%@ page import="acar.biz_partner.*"%>
<jsp:useBean id="bz_db" scope="page" class="acar.biz_partner.BizPartnerDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	if (t_wd.equals("")) t_wd = AddUtil.getDate(4);
	
	Vector clients = new Vector();
	int client_size = 0;
	
	clients = bz_db.getErpDemandCurrentList("1", s_kd, t_wd, asc);
	client_size = clients.size();	

%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function setIncom(bank_id, acct_num, bank_code, deposit_no, tran_date, tran_date_seq, tran_content, tran_amt, tran_branch){
		var fm = opener.document.form1;
		fm.bank_code3.value = bank_code;
		fm.deposit_no3.value = deposit_no;	
		fm.incom_dt.value = tran_date;		
		fm.tran_date_seq.value = tran_date_seq;		
		fm.remark.value = tran_content;		
	
		fm.incom_amt.value = tran_amt;		
		fm.bank_office.value = tran_branch;	
		fm.tran_date.value = tran_date;	
		fm.bank_id.value = bank_id;	
		fm.acct_num.value = acct_num;	
		
		fm.incom_gubun[1].checked = true;  //집금수집	
		
		window.close();
	}
	
	function setDemandFmsYn(bank_id, acct_num, tran_date, tran_date_seq){
		var fm = document.form1;
				
		if(!confirm('FMS 반영처리하시겠습니까?'))	return;		
			
		fm.target="i_no";
		fm.action = "./shinhan_erp_null_ui.jsp?s_kd="+fm.s_kd.value+"&t_wd="+fm.t_wd.value+"&bank_id=" + bank_id + "&acct_num=" + acct_num + "&tran_date="+ tran_date + "&tran_date_seq="+tran_date_seq;
		fm.submit();
	}
		
//-->
</script>
</head>

<body onload="document.form1.t_wd.focus()">
<form name='form1' method='post' action='shinhan_erp_demand.jsp'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">     
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>    
<input type='hidden' name='from_page' value='<%=from_page%>'> 

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
            <select name='s_kd'>
              <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>입금일</option>
              <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>은행</option>
          
            </select>
            <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>              
		    &nbsp;<a href="javascript:search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
		   &nbsp;
		    <a href="javascript:self.close();" onMouseOver="window.status=''; return true"><img src="/acar./images/center/button_close.gif" align=absmiddle border=0></a>&nbsp;
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr></tr><tr></tr><tr></tr>
    	
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=4%>연번</td>                                
                    <td class=title width=10%>은행코드</td>
                    <td class=title width=8%>은행명</td>
                    <td class=title width=11%>계좌번호</td>
                    <td class=title width=7%>거래일</td>
                    <td class=title width=4%>연번</td>  
                    <td class=title width=14%>거래내역</td>   
                    <td class=title width=7%>적요</td>   
                    <td class=title width=8%>입금액</td>   
                    <td class=title width=8%>출금액</td>   
                    <td class=title width=9%>잔액</td>                    
                    <td class=title width=7%>거래지점</td>   
                    <td class=title width=3%>적용</td>   
                                
                </tr>
          <%for (int i = 0 ; i < client_size ; i++){
				Hashtable ht = (Hashtable)clients.elementAt(i);%>
                <tr> 
                    <td align="center"><%=i+1%></td>                    
                    <td align="center"><% if ( ht.get("TRAN_CLSFY").equals("1") && ht.get("ERP_FMS_YN").equals("N") ) {%><a href="javascript:setDemandFmsYn('<%= ht.get("BANK_ID")%>','<%= ht.get("ACCT_NUM")%>', '<%=AddUtil.ChangeDate2(String.valueOf(ht.get("TRAN_DATE")))%>', '<%=ht.get("TRAN_DATE_SEQ")%>');"><% } %><%=ht.get("BANK_ID")%>(<%=ht.get("BANK_NM")%>)<% if ( ht.get("TRAN_CLSFY").equals("1") && ht.get("ERP_FMS_YN").equals("N") ) {%></a><% } %></td>
                    <td align="center"><%=ht.get("BANK_NAME")%></td>
                    <td align="center"><% if ( ht.get("TRAN_CLSFY").equals("1") && ht.get("ERP_FMS_YN").equals("N") && !ht.get("TRAN_CONTENT").equals("CMS공동망대금") ) {%><a href="javascript:setIncom('<%= ht.get("BANK_ID")%>','<%= ht.get("ACCT_NUM")%>', '<%= ht.get("BANK_NM")%>', '<%= ht.get("BANK_NO")%>', '<%=AddUtil.ChangeDate2(String.valueOf(ht.get("TRAN_DATE")))%>', '<%=ht.get("TRAN_DATE_SEQ")%>' , '<%=ht.get("TRAN_CONTENT")%>', '<%=Util.parseDecimal(String.valueOf(ht.get("IP_AMT")))%>', '<%=ht.get("TRAN_BRANCH")%>');"><% } %> <%=ht.get("ACCT_NUM")%><% if ( ht.get("TRAN_CLSFY").equals("1") && ht.get("ERP_FMS_YN").equals("N") ) {%></a><% } %></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TRAN_DATE")))%></td>
                    <td align="center"><%=ht.get("TRAN_DATE_SEQ")%></td>
                    <td align="center"><%=ht.get("TRAN_CONTENT")%></td>
                    <td align="center"><%=ht.get("REMARK")%></td> 
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("IP_AMT")))%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("OUT_AMT")))%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TRAN_REMAIN")))%></td>
                    <td align="center"><%=ht.get("TRAN_BRANCH")%></td>  
                    <td align="center"><%=ht.get("ERP_FMS_YN")%></td>  
                </tr>
          <%		}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;<font color=red>*</font>&nbsp;입금처리할 거래를 선택하세요!!!.</td>
    </tr>	   
</table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="100"  frameborder="0" noresize> </iframe>
</body>
</html>