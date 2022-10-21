<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.* "%>
<%@ page import="acar.inside_bank.*"%>
<%@ page import="acar.bill_mng.*, acar.common.*"%>
<jsp:useBean id="ib_db" scope="page" class="acar.inside_bank.InsideBankDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	String bank_code = request.getParameter("bank_code")==null?"":request.getParameter("bank_code");
	String s_wd = request.getParameter("s_wd")==null?"":request.getParameter("s_wd");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "12", "01");
      
	if (t_wd.equals("")) t_wd = AddUtil.getDate(4);
	
	
	Vector clients = new Vector();
	int client_size = 0;
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
		
	//네오엠-은행정보
	CodeBean[] banks = neoe_db.getInsideCodeAll();
	int bank_size = banks.length;
	
	clients = ib_db.getIbAcctAllTrDdEtcList(s_kd, t_wd, s_wd, bank_code , asc);
	client_size = clients.size();	

	int count =0;
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
	
	function setIncom(bank_id, acct_num, bank_code, deposit_no, tran_date, tran_date_seq, tran_content, tran_amt, tran_branch, acct_seq){
		var fm = opener.document.form1;
		fm.bank_code3.value = bank_code;
		fm.deposit_no3.value = deposit_no;	
		fm.incom_dt.value = tran_date;		
		fm.tran_date_seq.value = tran_date_seq;		
		fm.remark.value = tran_content;		
//	fm.remark1.value = tran_content;		
		fm.incom_amt.value = tran_amt;		
		fm.bank_office.value = tran_branch;	
		fm.tran_date.value = tran_date;	
		fm.bank_id.value = bank_id;	
		fm.acct_num.value = acct_num;	
		fm.acct_seq.value = acct_seq;	
		fm.incom_gubun[1].checked = true;  //집금수집	
		
		window.close();
	}
	
	function setDemandFmsYn(acct_seq, tran_date, tran_date_seq){
		var fm = document.form1;
		
		if ( fm.auth_rw.value =="4" ||  fm.auth_rw.value =="6" ) {
						
			if(!confirm('FMS 반영처리하시겠습니까?'))	return;		
				
			fm.target="i_no";
			fm.action = "./shinhan_erp_null_inside_ui.jsp?s_kd="+fm.s_kd.value+"&t_wd="+fm.t_wd.value+"&acct_seq=" + acct_seq +  "&tran_date="+ tran_date + "&tran_date_seq="+tran_date_seq;
			fm.submit();
		}	
	}
		
	function setIncomCard(bank_id, bank_nm, acct_nb, deposit_no, tran_date, tran_date_seq, tran_content, tran_amt, tran_branch, acct_seq){
		var fm = opener.document.form1;
		fm.incom_dt.value = tran_date;		
		fm.tran_date_seq.value = tran_date_seq;		
		fm.incom_amt.value = tran_amt;		
		fm.acct_seq.value = acct_seq;	
		fm.bank_id.value = acct_nb.substring(0,3);	
		fm.bank_nm.value = acct_nb.substring(4);	;	
		fm.bank_no.value = deposit_no;	
		opener.cal_dt();
		window.close();
	}		
//-->
</script>
</head>

<body onload="document.form1.t_wd.focus()">
<form name='form1' method='post' action='shinhan_erp_demand_inside.jsp'>
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
              &nbsp;&nbsp;입금은행 &nbsp;
			  <select name='bank_code'>
                      <option value=''>선택</option>
                      <%if(bank_size > 0){
						for(int i = 0 ; i < bank_size ; i++){
							CodeBean bank = banks[i];	
							%>						
                      <option value='<%= bank.getCode()%>' <%if(bank.getCode().equals(bank_code )  ){%>selected<%}%>><%= bank.getNm()%></option>
                      <%	}
					}	%>
               </select>
               
               <%if(from_page.equals("/card/cash_back/card_incom_sc.jsp")){%>
               <input type="text" name="s_wd" value="<%=s_wd%>" size="15" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>        
               <%}%>
                     
		    &nbsp;<a href="javascript:search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
		   &nbsp;
		    <a href="javascript:self.close();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align=absmiddle border=0></a>&nbsp;
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
                    <td class=title width=4%>순번</td>  
                    <td class=title width=14%>거래내역</td>   
                    <td class=title width=7%>적요</td>   
                    <td class=title width=8%>입금액</td>   
                    <td class=title width=8%>출금액</td>   
                    <td class=title width=9%>잔액</td>                    
                    <td class=title width=7%>거래지점</td>   
                    <td class=title width=3%>적용</td>   
                                
                </tr>
          <%for (int i = 0 ; i < client_size ; i++){
							Hashtable ht = (Hashtable)clients.elementAt(i);
							
							//카드캐쉬백현황에서 입금처리시 미적용분만 나오게 한다.
							if(from_page.equals("/card/cash_back/card_incom_sc.jsp") && String.valueOf(ht.get("ERP_FMS_YN")).equals("Y")){
								//continue;
							}
							
							count++;
				%>
                <tr> 
                    <td align="center"><%=count%></td>                    
                    <td align="center"><% if ( ht.get("TR_IPJI_GBN").equals("1") && ht.get("ERP_FMS_YN").equals("N") ) {%><a href="javascript:setDemandFmsYn('<%= ht.get("ACCT_SEQ")%>', '<%=AddUtil.ChangeDate2(String.valueOf(ht.get("TR_DATE")))%>', '<%=ht.get("TR_DATE_SEQ")%>');"><% } %><%=ht.get("BANK_ID")%>(<%=ht.get("BANK_NM")%>)<% if ( ht.get("TR_IPJI_GBN").equals("1") && ht.get("ERP_FMS_YN").equals("N") ) {%></a><% } %></td>
                    <td align="center"><%=ht.get("BANK_NAME")%></td>
                    <td align="center">
                    	<%if(from_page.equals("/card/cash_back/card_incom_sc.jsp")){%>
                    	  <a href="javascript:setIncomCard('<%= ht.get("BANK_ID")%>','<%= ht.get("ACCT_NB")%>', '<%= ht.get("BANK_NM")%>', '<%= ht.get("BANK_NO")%>', '<%=AddUtil.ChangeDate2(String.valueOf(ht.get("TR_DATE")))%>', '<%=ht.get("TR_DATE_SEQ")%>' , '<%=ht.get("NAEYONG")%>', '<%=Util.parseDecimal2(String.valueOf(ht.get("IP_AMT")))%>', '<%=ht.get("TRAN_BRANCH")%>', '<%=ht.get("ACCT_SEQ")%>');"><%=ht.get("ACCT_NB")%></a>
                    	<%}else{%>
                    	  <% if ( ht.get("TR_IPJI_GBN").equals("1") && ht.get("ERP_FMS_YN").equals("N") && !ht.get("NAEYONG").equals("CMS공동망대금") ) {%><a href="javascript:setIncom('<%= ht.get("BANK_ID")%>','<%= ht.get("ACCT_NB")%>', '<%= ht.get("BANK_NM")%>', '<%= ht.get("BANK_NO")%>', '<%=AddUtil.ChangeDate2(String.valueOf(ht.get("TR_DATE")))%>', '<%=ht.get("TR_DATE_SEQ")%>' , '<%=ht.get("NAEYONG")%>', '<%=Util.parseDecimal2(String.valueOf(ht.get("IP_AMT")))%>', '<%=ht.get("TRAN_BRANCH")%>', '<%=ht.get("ACCT_SEQ")%>');"><% } %> <%=ht.get("ACCT_NB")%><% if ( ht.get("TR_IPJI_GBN").equals("1") && ht.get("ERP_FMS_YN").equals("N") ) {%></a><% } %>
                    	<%}%>
                    </td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TR_DATE")))%></td>
                    <td align="center"><%=ht.get("TR_DATE_SEQ")%></td>
                    <td align="center"><%=ht.get("NAEYONG")%></td>
                    <td align="center"><%=ht.get("JUKYO")%></td> 
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("IP_AMT")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("OUT_AMT")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("TRAN_REMAIN")))%></td>
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