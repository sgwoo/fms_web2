<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.user_mng.*, acar.doc_settle.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	PaySearchDatabase ps_db = PaySearchDatabase.getInstance();
	
	
	//은행계좌번호
	Vector banks = ps_db.getDepositList();
	int bank_size = banks.size();
	
	String vid[] 	= request.getParameterValues("ch_cd");
	String reqseq 	= "";
	String p_pay_dt = "";
	
	int vid_size = vid.length;
	
	String bank_code  = Long.toString(System.currentTimeMillis());
	boolean flag1 = true;
	
	out.println(bank_code);
	
	out.println(vid_size);
	
	for(int i=0;i < vid_size;i++){
		
		reqseq = vid[i];
		
		flag1 = pm_db.updatePayABankcode(reqseq, bank_code);
				
	}
	
	Vector vt =  pm_db.getPayABankCodeDList(bank_code);
	int vt_size = vt.size();
	
	out.println(vt_size);
	
	long total_amt0	= 0;
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;
	long total_amt11 = 0;
	long total_amt12 = 0;
	long total_amt13 = 0;
	long total_amt14 = 0;
	long total_amt15 = 0;
	long total_amt16 = 0;
	long total_amt17 = 0;
	
	int s1 = 0;
	int b1 = 0;
	int d1 = 0;
	
	int a_bank_chk = 0;
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+
				   	"&sh_height=";	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save()
	{
		var fm = document.form1;
		
		//출금정보 점검
		if(fm.pay_dt.value == ''){ alert('지출일자를 확인하십시오.'); return; }				
		
		if(fm.a_bank_chk.value != '0' && toInt(parseDigit(fm.amt5.value)) > 0){ 
			if(fm.deposit_no.options[fm.deposit_no.selectedIndex].value == ''){
				alert('계좌번호를 선택하십시오.'); return;
			}
		}
		
		//자금집금 점검
		if(toInt(parseDigit(fm.t_bc_amt.value)) > 0){ 
			fm.bill_collecting.checked = true;
			for(var i = 0 ; i < 15 ; i ++){
				if(toInt(parseDigit(fm.bc_amt[i].value)) > 0){
					if(fm.bc_a_deposit_no[i].options[fm.bc_a_deposit_no[i].selectedIndex].value == ''){ 				
						alert('집금 출금 계좌번호를 선택하십시오.'); return;						
					}
					if(fm.bc_b_deposit_no[i].options[fm.bc_b_deposit_no[i].selectedIndex].value == ''){

					}
				}							
			}
		}		
				
		if(confirm('송금하시겠습니까?')){
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
			
			fm.action = 'pay_a_cms_req_a.jsp';
			fm.target = '_blank';
			fm.submit();	
			
			link.getAttribute('href',originFunc);
				
		}
	}	
	
	function sum_bc_amt(){
		var fm = document.form1;
		var t_bc_amt = 0;
		for(var i = 0 ; i < 15 ; i ++){
			t_bc_amt += toInt(parseDigit(fm.bc_amt[i].value));			
		}
		fm.t_bc_amt.value = parseDecimal(t_bc_amt);
	}
	
	function set_m_amt(){
		var fm = document.form1;
		var t_m_amt = 0;
		var t_amt = toInt(parseDigit(fm.t_amt.value));
		if(<%=vt_size%>>1){
			for(var i = 0 ; i < <%=vt_size%> ; i ++){
				t_m_amt += toInt(parseDigit(fm.m_amt[i].value));			
			}
		}else if(<%=vt_size%>==1){
			t_m_amt = toInt(parseDigit(fm.m_amt.value));			
		}
		fm.t_m_amt.value = parseDecimal(t_m_amt);		
		fm.amt7.value = parseDecimal(t_m_amt);	
		fm.amt6.value = parseDecimal( t_amt - t_m_amt);	
	}
	
	function view_pay_ledger_doc(reqseq, p_gubun, p_cd1, p_cd2, p_cd3, p_cd4, p_cd5, p_st1, p_st4, i_cnt){
		var w_width  = 850;
		var w_height = 650;
		var url_etc = '';
		
		//직접등록
		if(p_gubun == '99'){
			w_width  = 900;
			w_height = 400;
			window.open("pay_file_list.jsp<%=valus%>&p_gubun="+p_gubun+"&reqseq="+reqseq, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");				
		//조회등록
		}else{		
			if(i_cnt == '1'){
				if(p_gubun == '01'){
					w_width  = 900;
					w_height = 700;
					window.open("/fms2/car_pur/pur_doc_u.jsp<%=valus%>&mode=view&rent_mng_id="+p_cd1+"&rent_l_cd="+p_cd2, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
				}else if(p_gubun == '02'){
					w_width  = 900;
					w_height = 700;
					if(p_cd3 == '7'){
						window.open("/fms2/commi/suc_commi_doc_u.jsp<%=valus%>&mode=view&rent_mng_id="+p_cd1+"&rent_l_cd="+p_cd2, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
					}else{
						window.open("/fms2/commi/commi_doc_u.jsp<%=valus%>&mode=view&rent_mng_id="+p_cd1+"&rent_l_cd="+p_cd2, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
					}
				}else if(p_gubun == '04'){
					w_width  = 850;
					w_height = 800;
					if(p_st4=='묶음'){
						var lend_id = p_cd1.substring(0,4);
						var rtn_seq = p_cd1.substring(4);
						window.open("/acar/con_debt/debt_c_bank2.jsp<%=valus%>&mode=view&lend_id="+lend_id+"&rtn_seq="+rtn_seq+"&alt_tm="+p_cd2, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
					}else{
							if(p_cd4 != '') url_etc = '&m_id='+p_cd3+'&l_cd='+p_cd4;
							window.open("/acar/con_debt/debt_c.jsp<%=valus%>&mode=view&c_id="+p_cd1+"&alt_tm="+p_cd2+url_etc, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
						}
				}else if(p_gubun == '11'){
					if(p_cd1 == 'null' || p_cd1==p_st1){
						w_width  = 900;
						w_height = 400;
						window.open("pay_file_list.jsp<%=valus%>&p_gubun="+p_gubun+"&reqseq="+reqseq, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");							
					}else{					
						w_width  = 900;
						w_height = 700;			
						if(p_cd5 != '') url_etc = '&rent_mng_id='+p_cd4+'&rent_l_cd='+p_cd5;			
						window.open("/acar/cus_reg/serv_reg.jsp<%=valus%>&mode=view&car_mng_id="+p_cd1+"&serv_id="+p_cd2+url_etc, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
					}
				}else if(p_gubun == '21'){
					w_width  = 1000;
					w_height = 800;
					window.open("/acar/fine_mng/fine_mng_frame.jsp<%=valus%>&mode=view&car_mng_id="+p_cd1+"&seq_no="+p_cd2+"&rent_mng_id="+p_cd3+"&rent_l_cd="+p_cd4, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
				}else if(p_gubun == '31'){
					w_width  = 1000;
					w_height = 800;
					window.open("/fms2/cls_cont/lc_cls_u3.jsp<%=valus%>&mode=view&rent_mng_id="+p_cd1+"&rent_l_cd="+p_cd2, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
				}else if(p_gubun == '35'){
					w_width  = 1100;
					w_height = 600;
					window.open("/fms2/lc_rent/lc_c_c_suc_commi.jsp<%=valus%>&mode=pay_view&rent_mng_id="+p_cd1+"&rent_l_cd="+p_cd2, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
				}else if(p_gubun == '07' || p_gubun == '08'){
					w_width  = 1000;
					w_height = 500;					
					window.open("pay_lists.jsp<%=valus%>&p_gubun="+p_gubun+"&reqseq="+reqseq, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");
				}else{		
					w_width  = 900;
					w_height = 400;
					window.open("pay_file_list.jsp<%=valus%>&p_gubun="+p_gubun+"&reqseq="+reqseq, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
				}
			}else{
				if(p_gubun == '07' || p_gubun == '08'){
					w_width  = 1000;
					w_height = 500;					
					window.open("pay_lists.jsp<%=valus%>&p_gubun="+p_gubun+"&reqseq="+reqseq, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");
				}else{		
					w_width  = 1000;
					w_height = 500;
					window.open("pay_file_lists.jsp<%=valus%>&p_gubun="+p_gubun+"&reqseq="+reqseq, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");
				}	
			}
		}
	}
			
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>      
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">
  <input type='hidden' name='size' 		value='<%=vt_size%>'>    


<table border="0" cellspacing="0" cellpadding="0" width=1200>
    <tr>
        <td><< 입금정보 >></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
        <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr>
        			<td width='30' rowspan="2" class='title'>연번</td>
        			<td width='30' rowspan="2" class='title'>출금<br>시간</td>					
        			<td width='30' rowspan="2" class='title'>증빙<br>서류</td>					
        			<td width='60' rowspan="2" class='title'>출금방식</td>
        		    <td width="150" rowspan="2" class='title'>지출처</td>					
               		<td width='170' rowspan="2" class='title'>적요</td>
               		<td width='80' rowspan="2" class='title'>금융사</td>					
               		<td width='130' rowspan="2" class='title'>계좌번호</td>
               		<td width='150' rowspan="2" class='title'>예금주</td>					
               		<td width='100' rowspan="2" class='title'>금액</td>
               		<td colspan="2" class='title'>미지출분</td>
       			</tr>
		        <tr>
		          <td width='100' class='title'>금액</td>
	              <td width='170' class='title'>사유</td>
	          </tr>		
		  <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
		        <tr>
        			<td align='center'><%=i+1%><input type='hidden' name='reqseq' 	value='<%=ht.get("REQSEQ")%>'></td>
					<td align='center'>
					  <%if(String.valueOf(ht.get("AT_ONCE")).equals("Y")){%>
					  <font color=red>즉시</font>
					  <%}else{%>
					  지정
					  <%}%>
				    </td>	
          <td width='40' align='center'>
		  <%if(String.valueOf(ht.get("P_GUBUN")).equals("01") || String.valueOf(ht.get("P_GUBUN")).equals("06") || String.valueOf(ht.get("P_GUBUN")).equals("02") || String.valueOf(ht.get("P_GUBUN")).equals("04") || String.valueOf(ht.get("P_GUBUN")).equals("11") || String.valueOf(ht.get("P_GUBUN")).equals("12") || String.valueOf(ht.get("P_GUBUN")).equals("13") || String.valueOf(ht.get("P_GUBUN")).equals("21") || String.valueOf(ht.get("P_GUBUN")).equals("31") || String.valueOf(ht.get("P_GUBUN")).equals("35") || String.valueOf(ht.get("P_GUBUN")).equals("37") || String.valueOf(ht.get("P_GUBUN")).equals("41")){//자동차대금,할부금,과태료%>
		    <a href="javascript:view_pay_ledger_doc('<%=ht.get("REQSEQ")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("P_CD1")%>','<%=ht.get("P_CD2")%>','<%=ht.get("P_CD3")%>','<%=ht.get("P_CD4")%>','<%=ht.get("P_CD5")%>','<%=ht.get("P_ST1")%>','<%=ht.get("P_ST4")%>','<%=ht.get("I_CNT")%>')" onMouseOver="window.status=''; return true" title="클릭하세요">보기</a>
		  <%}else if(String.valueOf(ht.get("P_GUBUN")).equals("99") && !String.valueOf(ht.get("FILE_CNT")).equals("0")){%>
		    <a href="javascript:view_pay_ledger_doc('<%=ht.get("REQSEQ")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("P_CD1")%>','<%=ht.get("P_CD2")%>','<%=ht.get("P_CD3")%>','<%=ht.get("P_CD4")%>','<%=ht.get("P_CD5")%>','<%=ht.get("P_ST1")%>','<%=ht.get("P_ST4")%>','<%=ht.get("I_CNT")%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=String.valueOf(ht.get("FILE_CNT"))%>건</a>		  
		  <%}else if(String.valueOf(ht.get("P_GUBUN")).equals("99") && String.valueOf(ht.get("FILE_CNT")).equals("0")){%>
		    <a href="javascript:view_pay_ledger_doc('<%=ht.get("REQSEQ")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("P_CD1")%>','<%=ht.get("P_CD2")%>','<%=ht.get("P_CD3")%>','<%=ht.get("P_CD4")%>','<%=ht.get("P_CD5")%>','<%=ht.get("P_ST1")%>','<%=ht.get("P_ST4")%>','<%=ht.get("I_CNT")%>')" onMouseOver="window.status=''; return true" title="클릭하세요">등록</a>		  
		  <%}else{%>
		  <%	if(String.valueOf(ht.get("FILE_CNT")).equals("0")){%>
		    <a href="javascript:view_pay_ledger_doc('<%=ht.get("REQSEQ")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("P_CD1")%>','<%=ht.get("P_CD2")%>','<%=ht.get("P_CD3")%>','<%=ht.get("P_CD4")%>','<%=ht.get("P_CD5")%>','<%=ht.get("P_ST1")%>','<%=ht.get("P_ST4")%>','<%=ht.get("I_CNT")%>')" onMouseOver="window.status=''; return true" title="클릭하세요">등록</a>
		  <%	}else{%>
		    <a href="javascript:view_pay_ledger_doc('<%=ht.get("REQSEQ")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("P_CD1")%>','<%=ht.get("P_CD2")%>','<%=ht.get("P_CD3")%>','<%=ht.get("P_CD4")%>','<%=ht.get("P_CD5")%>','<%=ht.get("P_ST1")%>','<%=ht.get("P_ST4")%>','<%=ht.get("I_CNT")%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=String.valueOf(ht.get("FILE_CNT"))%>건</a>
		  <%	}%>
		  <%}%>
		  </td>    				    
		  			<td align='center'><%=ht.get("WAY_NM")%></td>					
        		    <td align='center'><%=ht.get("OFF_NM")%></td>					
		  			<td >&nbsp;<%=ht.get("P_CONT")%></td>
		  			<td align='center'><%=ht.get("BANK_NM")%><%if(String.valueOf(ht.get("BANK_NO")).equals("") && !String.valueOf(ht.get("A_BANK_NO")).equals("")){%><%=ht.get("A_BANK_NM")%><%}%></td>
		  			<td align='center'><%=ht.get("BANK_NO")%><%if(String.valueOf(ht.get("BANK_NO")).equals("") && !String.valueOf(ht.get("A_BANK_NO")).equals("")){%><%=ht.get("A_BANK_NO")%><%}%></td>
		  			<td >&nbsp;<%=ht.get("BANK_ACC_NM")%></td>
		  			<td align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%></td>
		  			<td align='center'><input type='text' name='m_amt' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_m_amt();' value='' size='8' maxlength='12'></td>
	  			    <td align='center'><input type='text' name='m_cau' class='default' value='' size='20' maxlength='30'></td>
       			</tr>
		  <%		total_amt0 	= total_amt0 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					if(String.valueOf(ht.get("P_WAY")).equals("1")) 		total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					if(String.valueOf(ht.get("P_WAY")).equals("2")) 		total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					if(String.valueOf(ht.get("P_WAY")).equals("3")) 		total_amt3 = total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					if(String.valueOf(ht.get("P_WAY")).equals("4")) 		total_amt4 = total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					if(String.valueOf(ht.get("P_WAY")).equals("5")) 		total_amt5 = total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					if(String.valueOf(ht.get("P_WAY")).equals("7")) 		total_amt17 = total_amt17 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					
					if(String.valueOf(ht.get("P_WAY")).equals("5") && String.valueOf(ht.get("A_BANK_NO")).equals(""))		a_bank_chk++;
		 		}%>
		        <tr>
        		    <td class=title colspan="9">합계</td>
        		    <td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt0)%></td>		
        		    <td class='title'><input type='text' name='t_m_amt' class='defaultnum' value='' size='8' maxlength='12'></td>
        		    <td class=title>&nbsp;</td>					
       		    </tr>
		    </table>
	    </td>
    </tr>  		    	
	<tr>
		<td align="right">
		  <a href="javascript:print()"><img src=/acar/images/center/button_print.gif align=absmiddle border=0></a><font color=#CCCCCC>&nbsp;(※인쇄TIP : A3, 가로방향)</font>&nbsp;&nbsp;&nbsp;
		  <a href="javascript:window.close();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>	
	</tr>		
    <tr>
        <td><hr></td>
    </tr>
	<tr>
		<td>&nbsp;</td>	
	</tr>	
    <tr>
        <td><< 출금정보 >></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
        <td class='line'>
		    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                          <tr>
                            <td width="90" class=title>지출일자</td>
                            <td colspan="2" >&nbsp;
                              <input type='text' size='11' name='pay_dt' maxlength='10' class='default' value='<%=AddUtil.getDate()%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                          </tr>
                          <tr>
                            <td class=title>구분</td>
                            <td class=title width="360" >금액</td>
                            <td width="450" class=title>계좌번호</td>
                          </tr>
                          <tr>
                            <td class=title>현금출금</td>
                            <td align="center" >&nbsp;
                              <input type='text' name='amt1' maxlength='15' value='<%=AddUtil.parseDecimalLong(total_amt1)%>' class='whitenum' size='15' onBlur='javascript:this.value=parseDecimal(this.value);'>
                              원</td>
                            <td align="center">-</td>
                          </tr>
                          <tr>
                            <td class=title>자동이체</td>
                            <td align="center" >&nbsp;
                              <input type='text' name='amt2' maxlength='15' value='<%=AddUtil.parseDecimalLong(total_amt4)%>' class='whitenum' size='15' onBlur='javascript:this.value=parseDecimal(this.value);'>
                              원</td>
                            <td align="center">-</td>
                          </tr>
                          <tr>
                            <td class=title>선불카드</td>
                            <td align="center" >&nbsp;
                              <input type='text' name='amt3' maxlength='15' value='<%=AddUtil.parseDecimalLong(total_amt2)%>' class='whitenum' size='15' onBlur='javascript:this.value=parseDecimal(this.value);'>
                              원</td>
                            <td align="center">-</td>
                          </tr>
                          <tr>
                            <td class=title>후불카드</td>
                            <td align="center" >&nbsp;
                              <input type='text' name='amt4' maxlength='15' value='<%=AddUtil.parseDecimalLong(total_amt3)%>' class='whitenum' size='15' onBlur='javascript:this.value=parseDecimal(this.value);'>
                              원</td>
                            <td align="center">-</td>
                          </tr>
                          <tr>
                            <td class=title>카드할부</td>
                            <td align="center" >&nbsp;
                              <input type='text' name='amt8' maxlength='15' value='<%=AddUtil.parseDecimalLong(total_amt17)%>' class='whitenum' size='15' onBlur='javascript:this.value=parseDecimal(this.value);'>
                              원</td>
                            <td align="center">-</td>
                          </tr>
                          <tr>
                            <td class=title>계좌이체</td>
                            <td align="center" class=is>&nbsp;
                              <input type='text' name='amt5' maxlength='15' value='<%=AddUtil.parseDecimalLong(total_amt5)%>' class='whitenum' size='15' onBlur='javascript:this.value=parseDecimal(this.value);'>
                              원 </td>
                            <td align="center" class=is>&nbsp; 
                              <select name='deposit_no' class='default'>
                                <option value=''>계좌를 선택하세요</option>
                                <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
                                <option value='<%= bank.get("DEPOSIT_NO")%>' <%if(String.valueOf(bank.get("DEPOSIT_NO")).equals("140-004-023871")){%>selected<%}%>>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
                                <%		}
									}%>
                              </select></td>
                          </tr>
                          <tr>
                            <td class=title>미지출분</td>
                            <td align="center" >&nbsp;
                              <input type='text' name='amt7' maxlength='15' value='' class='whitenum' size='15' onBlur='javascript:this.value=parseDecimal(this.value);'>
                              원</td>
                            <td align="center">-</td>
                          </tr>
                          <tr>
                            <td class=title>합계</td>
                            <td class=title>&nbsp;
                              <input type='text' name='amt6' maxlength='15' value='<%=AddUtil.parseDecimalLong(total_amt0)%>' class='whitenum' size='15' onBlur='javascript:this.value=parseDecimal(this.value);'>
원 </td>
                            <td class=title>&nbsp;<input type='hidden' name='t_amt' 		value='<%=total_amt0%>'></td>
                          </tr>
            </table>		  
	    </td>	
	</tr>
	<tr>
		<td>&nbsp;</td>	
	</tr>
		
	<%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    <tr>
	    <td align='center'>
	    <a id="submitLink" href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_send_money.gif border=0 align=absmiddle></a>
	    </td>
	</tr>	
	<%}%>			  	
	
	<tr>
	  <td><hr></td>
    </tr>
	<tr>
	  <td><< 자금집금 >></td>
    </tr>
	<tr>
	  <td class=line><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="90" class=title>집금여부</td>
          <td colspan="4" >&nbsp;              <input type="checkbox" name="bill_collecting" value="Y"></td>
        </tr>
        <tr>
          <td width="90" class=title>연번</td>
          <td class=title width="140" >금액</td>
          <td class=title width="320" >출금계좌</td>
          <td width="30" class=title>&nbsp;</td>
          <td width="320" class=title>입금계좌</td>
        </tr>
        <tr>
          <td class=title>1</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td rowspan="10" align="center" class=is>-&gt;                                                                                                                                            </td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>2</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>3</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>4</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>5</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>6</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>7</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>8</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>9</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>10</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>11</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td rowspan="10" align="center" class=is>-&gt;                                                                                                                                            </td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>12</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>13</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>14</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>15</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>        
        <tr>
          <td width="90" class=title>합계</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='t_bc_amt' maxlength='15' value='' class='whitenum' size='15'>
원  </td>
          <td align="center" class=is colspan="3" >-</td>
          </tr>		  
      </table></td>
    </tr>	
	<tr>
		<td>※ 입금계좌없이 출금계좌만 입력되었을 경우 현금출금으로 회계처리시 입금전표로 발행됩니다. &nbsp;</td>	
	</tr>
	
</table>
<%
	flag1 = pm_db.updatePayABankcodeNull(bank_code);
%>
  <input type='hidden' name='a_bank_chk' 	value='<%=a_bank_chk%>'>  
</form>  
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
