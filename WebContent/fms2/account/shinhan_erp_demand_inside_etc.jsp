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
	
	String ven_code 	= request.getParameter("ven_code")==null? "":request.getParameter("ven_code");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "12", "01");
      
	if (t_wd.equals("")) t_wd = AddUtil.getDate(4);
	
	Vector clients = new Vector();
	int client_size = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
		
	//네오엠-은행정보
	CodeBean[] banks = neoe_db.getInsideCodeAll();
	int bank_size = banks.length;
		
	clients = ib_db.getIbAcctAllTrDdEtcList(s_kd, t_wd, s_wd, bank_code , asc);
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
	
			
		//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "pr"){					
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
	}
	
	
	//의뢰 선택된것중 통장과 거래일이  선택된 경우 처리불가 
	function reg(){
		var fm= document.form1;	
	
		var len=fm.elements.length;	
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "pr"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("입금내역을 선택하세요.");
			return;
		}	
				
		<%if(from_page.equals("/card/cash_back/card_incom_sc.jsp")){%>
		if(fm.incom_st.value == ''){ alert('처리구분을 선택하십시오.'); return; }
		var ofm = opener.document.form1;
		ofm.incom_st.value = fm.incom_st.value;
		//개별
		if(fm.incom_st.value == '1'){	
			        var incom_amt = 0;
			        var incom_dt = '';
			        if(<%=client_size%>==1){						
							if(fm.pr.checked == true){	
								var ch_var = fm.pr.value;
								var ch_split = ch_var.split("^");
								incom_amt = incom_amt + toInt(ch_split[6]);
								incom_dt = ch_split[1];	
								if(ofm.size.value == '1'){
									if(ch_split[7].lastIndexOf(ofm.base_car_num.value) != -1){
										ofm.acct_seq.value = ch_split[0];
										ofm.tran_date_seq.value = ch_split[2];		
										ofm.bank_id.value = ch_split[4].substring(0,3);	
										ofm.bank_nm.value = ch_split[4].substring(4);
										ofm.bank_no.value = ch_split[5];
										ofm.base_incom_amt.value = ch_split[6];
										ofm.bank_incom_dt.value = ch_split[1];
										ofm.m_amt.value = parseDecimal( toInt(parseDigit(ofm.base_amt.value)) - toInt(parseDigit(ofm.base_incom_amt.value)) );
										ofm.rest_amt.value = 0;										
									}
								}else{
									for(i=0; i<toInt(ofm.size.value); i++){
										if(ch_split[7].lastIndexOf(ofm.base_car_num[i].value) != -1){
											ofm.acct_seq[i].value = ch_split[0];
											ofm.tran_date_seq[i].value = ch_split[2];		
											ofm.bank_id[i].value = ch_split[4].substring(0,3);	
											ofm.bank_nm[i].value = ch_split[4].substring(4);
											ofm.bank_no[i].value = ch_split[5];
											ofm.base_incom_amt[i].value = ch_split[6];
											ofm.bank_incom_dt[i].value = ch_split[1];
											ofm.m_amt[i].value = parseDecimal( toInt(parseDigit(ofm.base_amt[i].value)) - toInt(parseDigit(ofm.base_incom_amt[i].value)) );
											ofm.rest_amt[i].value = 0;		
										}
									}									
								}
							}
			        }else{
						for(i=0; i<<%=client_size%>; i++){
							if(fm.pr[i].checked == true){	
								var ch_var = fm.pr[i].value;
								var ch_split = ch_var.split("^");
								incom_amt = incom_amt + toInt(ch_split[6]);
								if(incom_dt == ''){
									incom_dt = ch_split[1];
								}
								if(ofm.size.value == '1'){
									if(ch_split[7].lastIndexOf(ofm.base_car_num.value) != -1){
										ofm.acct_seq.value = ch_split[0];
										ofm.tran_date_seq.value = ch_split[2];		
										ofm.bank_id.value = ch_split[4].substring(0,3);	
										ofm.bank_nm.value = ch_split[4].substring(4);
										ofm.bank_no.value = ch_split[5];
										ofm.base_incom_amt.value = ch_split[6];
										ofm.bank_incom_dt.value = ch_split[1];
										ofm.m_amt.value = parseDecimal( toInt(parseDigit(ofm.base_amt.value)) - toInt(parseDigit(ofm.base_incom_amt.value)) );
										ofm.rest_amt.value = 0;		
									}
								}else{
									for(j=0; j<toInt(ofm.size.value); j++){
										if(ch_split[7].lastIndexOf(ofm.base_car_num[j].value) != -1){
											ofm.acct_seq[j].value = ch_split[0];
											ofm.tran_date_seq[j].value = ch_split[2];		
											ofm.bank_id[j].value = ch_split[4].substring(0,3);	
											ofm.bank_nm[j].value = ch_split[4].substring(4);
											ofm.bank_no[j].value = ch_split[5];
											ofm.base_incom_amt[j].value = ch_split[6];
											ofm.bank_incom_dt[j].value = ch_split[1];
											ofm.m_amt[j].value = parseDecimal( toInt(parseDigit(ofm.base_amt[j].value)) - toInt(parseDigit(ofm.base_incom_amt[j].value)) );
											ofm.rest_amt[j].value = 0;		
										}
									}
								}
							}
						}				        	
			        }
					ofm.incom_dt.value = incom_dt;
					ofm.incom_amt.value = incom_amt;					
					
		//묶음	
		}else{
			if(cnt == 1){
				var ch_var = '';
				var ch_split = '';
				if(<%=client_size%>==1){
					if(fm.pr.checked == true){	
						ch_var = fm.pr.value;
						ch_split = ch_var.split("^");
					}					
				}else{
					for(i=0; i<<%=client_size%>; i++){
						if(fm.pr[i].checked == true){	
							ch_var = fm.pr[i].value;
							ch_split = ch_var.split("^");
						}
					}
				}
				
				ofm.incom_dt.value = ch_split[1];
				ofm.incom_amt.value = ch_split[6];
				
				if(ofm.size.value == '1'){
					ofm.acct_seq.value = ch_split[0];
					ofm.tran_date_seq.value = ch_split[2];		
					ofm.bank_id.value = ch_split[4].substring(0,3);	
					ofm.bank_nm.value = ch_split[4].substring(4);
					ofm.bank_no.value = ch_split[5];	
				}else{
					ofm.acct_seq[0].value = ch_split[0];
					ofm.tran_date_seq[0].value = ch_split[2];		
					ofm.bank_id[0].value = ch_split[4].substring(0,3);	
					ofm.bank_nm[0].value = ch_split[4].substring(4);
					ofm.bank_no[0].value = ch_split[5];	
				}
							
				opener.cal_dt();

			}else{
				alert('묶음처리는 하나만 선택하세요.');
			}
		}
		opener.cal_rest();
		window.close();
		<%}else{%>
			fm.target = "c_foot";
			fm.action = "incom_reg_etc_sc.jsp" ;		
			fm.submit();
			window.close();
		<%}%>
	}			
	
		
//-->
</script>
</head>

<body onload="document.form1.t_wd.focus()">
<form name='form1' method='post' action='shinhan_erp_demand_inside_etc.jsp'>
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
		    <a href="javascript:self.close();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align=absmiddle border=0></a>&nbsp;</td>
        <td align=right>
            <%if(from_page.equals("/card/cash_back/card_incom_sc.jsp")){%>
                     처리구분 <select name='incom_st'>
                    <option value=''>선택</option>
                    <option value='1'>개별</option>
                    <option value='2'>묶음</option>          
                  </select>        
            <%}%>
            <a href="javascript:reg();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>  </td>
    </tr>
    <%if(from_page.equals("/card/cash_back/card_incom_sc.jsp")){%>
    <td align=right>
        <td>※ 개별처리는 동일 일자만 처리하세요.</td>
    </tr>
    <%}%>
    <tr> 
        <td class=h></td>
    </tr>
    <tr></tr><tr></tr><tr></tr>
    	
    <tr> 
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td colspan=2 class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td width='3%' class='title' style='height:45'> <input type="checkbox" name="all_pr" value="Y" onclick="javascript:AllSelect();"> </td>
                    <td class=title width=4%>연번</td>                                
                    <td class=title width=10%>은행코드</td>
                    <td class=title width=8%>은행명</td>
                    <td class=title width=11%>계좌번호</td>
                    <td class=title width=7%>거래일</td>
                    <td class=title width=3%>순번</td>  
                    <td class=title width=12%>거래내역</td>   
                    <td class=title width=7%>적요</td>   
                    <td class=title width=8%>입금액</td>   
                    <td class=title width=8%>출금액</td>   
                    <td class=title width=9%>잔액</td>                    
                    <td class=title width=7%>거래지점</td>   
                    <td class=title width=3%>적용</td>   
                                
                </tr>
          <%for (int i = 0 ; i < client_size ; i++){
				Hashtable ht = (Hashtable)clients.elementAt(i);
				String disabled = "";
				if ( (from_page.equals("/card/cash_back/card_incom_sc.jsp") && ht.get("ERP_FMS_YN").equals("N")) || 
					 (from_page.equals("/card/cash_back/card_incom_sc.jsp") && ck_acar_id.equals("000131")) || 
					 (ht.get("TR_IPJI_GBN").equals("1") && ht.get("ERP_FMS_YN").equals("N")) 
				   ) {
					disabled = "";
				}else{
					disabled = "disabled";
				}
				
				
		  %>
                <tr> 
               	    <td align="center"><input type="checkbox" name="pr" value="<%= ht.get("ACCT_SEQ")%>^<%=ht.get("TR_DATE")%>^<%=ht.get("TR_DATE_SEQ")%>^<%=ht.get("NAEYONG")%>^<%= ht.get("BANK_NM")%>^<%= ht.get("BANK_NO")%>^<%=ht.get("IP_AMT")%>^<%=ht.get("T_NAEYONG")%>^<%= ht.get("ACCT_NB")%>^" <%=disabled%>></td>
                    <td align="center"><%=i+1%></td>                    
                    <td align="center"><%=ht.get("BANK_ID")%>(<%=ht.get("BANK_NM")%>)</td>
                    <td align="center"><%=ht.get("BANK_NAME")%></td>
                    <td align="center"><%=ht.get("ACCT_NB")%></td>
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