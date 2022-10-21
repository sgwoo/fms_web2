<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.user_mng.*, acar.doc_settle.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
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
	
	String bank_code 	= request.getParameter("bank_code")==null?"":request.getParameter("bank_code");
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	
	
	boolean flag1 = true;
	
	Vector vt =  pm_db.getPayActDocBankCodeList(bank_code, doc_no);
	int vt_size = vt.size();
	
	Vector vt2 =  pm_db.getPayActDocBankCodeList_Sub(bank_code);
	int vt_size2 = vt2.size();
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
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
	
	String pay_dt = "";
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+
				   	"&sh_height=";	
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		
		if(confirm('결재하시겠습니까?')){	
			fm.action='pay_a_cms_req_app_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}									
	}
	
	function doc_sanction_non(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		fm.non_id2.value = '1';
		
		if(confirm('결재하시겠습니까?')){	
			fm.action='pay_a_cms_req_app_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}									
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
  <input type='hidden' name='bank_code'	value='<%=bank_code%>'>    
  <input type='hidden' name='doc_no'	value='<%=doc_no%>'>      
  <input type='hidden' name='doc_bit'	value=''>       
  <input type='hidden' name='non_id2'	value=''>         

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td><< 출금요청 >></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>  	
	<%if(1==1)%>
    <tr>
        <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr>
        			<td width='30' rowspan="2" class='title'>연번</td>
					<td width='30' rowspan="2" class='title'>출금<br>시간</td>					
					<td width='30' rowspan="2" class='title'>증빙<br>서류</td>					
        			<td width='60' rowspan="2" class='title'>출금방식</td>					
        		    <td width="170" rowspan="2" class='title'>지출처</td>					
               		<td width='270' rowspan="2" class='title'>적요</td>
               		<td width='100' rowspan="2" class='title'>금액</td>					
               		<td width='80' rowspan="2" class='title'>금융사</td>					
               		<td width='130' rowspan="2" class='title'>계좌번호</td>
               		<td width='150' rowspan="2" class='title'>예금주</td>					
               		<td colspan="2" class='title'>미지출분</td>
       			</tr>
		        <tr>
		          <td width='50' class='title'>금액</td>
	              <td width='100' class='title'>사유</td>
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
        		    <td >&nbsp;<%=ht.get("OFF_NM")%></td>					
		  			<td >&nbsp;<%=ht.get("P_CONT")%></td>
		  			<td align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%></td>					
		  			<td align='center'><%if(!String.valueOf(ht.get("WAY_NM")).equals("현금지출")){%><%=ht.get("BANK_NM")%><%if(String.valueOf(ht.get("BANK_NO")).equals("") && !String.valueOf(ht.get("A_BANK_NO")).equals("")){%><%=ht.get("A_BANK_NM")%><%}%><%}%></td>
		  			<td align='center'><%if(!String.valueOf(ht.get("WAY_NM")).equals("현금지출")){%><%=ht.get("BANK_NO")%><%if(String.valueOf(ht.get("BANK_NO")).equals("") && !String.valueOf(ht.get("A_BANK_NO")).equals("")){%><%=ht.get("A_BANK_NO")%><%}%><%}%></td>
		  			<td >&nbsp;<%if(!String.valueOf(ht.get("WAY_NM")).equals("현금지출")){%><%=ht.get("BANK_ACC_NM")%><%}%></td>
		  			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("M_AMT"))==null?0:String.valueOf(ht.get("M_AMT")))%></td>
	  			  <td align='center'><%=ht.get("M_CAU")%></td>
       			</tr>
		  <%		total_amt0 	= total_amt0 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					if(String.valueOf(ht.get("P_WAY")).equals("1")) 		total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					if(String.valueOf(ht.get("P_WAY")).equals("2")) 		total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					if(String.valueOf(ht.get("P_WAY")).equals("3")) 		total_amt3 = total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					if(String.valueOf(ht.get("P_WAY")).equals("4")) 		total_amt4 = total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					if(String.valueOf(ht.get("P_WAY")).equals("5")) 		total_amt5 = total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					if(String.valueOf(ht.get("P_WAY")).equals("7")) 		total_amt17 = total_amt17 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					
					if(i==0){
						pay_dt 		= String.valueOf(ht.get("A_PAY_DT"))==null?"":String.valueOf(ht.get("A_PAY_DT"));
					}
		 		}%>
		        <tr>
        		    <td class=title colspan="6">합계</td>
        		    <td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt0)%></td>																						
        		    <td class=title>&nbsp;</td>																				
        		    <td class=title>&nbsp;</td>					
        		    <td class=title>&nbsp;</td>
        		    <td class='title' style='text-align:right'></td>		
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
        <td><< 송금정보 >></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>  		
    <tr>
        <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr>
        			<td width='30' rowspan="2" class='title'>연번</td>
        		    <td width="300" rowspan="2" class='title'>지출처</td>					
               		<td width='150' rowspan="2" class='title'>금액</td>					
               		<td colspan="3" class='title'>입금계좌</td>					
               		<td colspan="2" class='title'>출금계좌</td>					
           		</tr>
		        <tr>
		          <td width='100' class='title'>금융사</td>
		          <td width='150' class='title'>계좌번호</td>
		          <td width='220' class='title'>예금주</td>
		          <td width='100' class='title'>금융사</td>
		          <td width='150' class='title'>계좌번호</td>
	          </tr>		
		  <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
		        <tr>
        			<td align='center'><%=i+1%></td>
        		    <td >&nbsp;<%=ht.get("OFF_NM")%></td>					
		  			<td align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%></td>					
		  			<td align='center'><%=ht.get("BANK_NM")%></td>
		  			<td align='center'><%=ht.get("BANK_NO")%></td>
		  			<td >&nbsp;<%=ht.get("BANK_ACC_NM")%></td>
		  			<td align='center'><%=ht.get("A_BANK_NM")%></td>
		  			<td align='center'><%=ht.get("A_BANK_NO")%></td>
       			</tr>
		  <%		total_amt7 	= total_amt7 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
		 		}%>
		        <tr>
        		    <td class=title>합계</td>
        		    <td class=title>&nbsp;</td>
        		    <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt7)%></td>
        		    <td class=title>&nbsp;</td>
        		    <td class='title'>&nbsp;</td>																						
        		    <td class=title>&nbsp;</td>																				
        		    <td class=title>&nbsp;</td>					
        		    <td class=title>&nbsp;</td>
       		    </tr>
		    </table>
	    </td>
    </tr>  		    	
	<tr>
		<td>&nbsp;</td>	
	</tr>
	<%if(!nm_db.getWorkAuthUser("아마존카이외",user_id)){%>	
	<tr>
	    <td>
		    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>		  
        			<td width="300" class=line>
        			    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        			        <tr>
		                        <td class=line2 style='height:1'></td>
		                    </tr>
                            <tr valign="middle" align="center">
                                <td width='100' class=title>구분</td>
                                <td width='100' class=title>금액</td>
                                <td width='100' class=title>지출예정일자</td>
                            </tr>
                            <tr valign="middle" align="center">
                                <td align='center'>현금</td>
                                <td align='right'><%=AddUtil.parseDecimalLong(total_amt1)%></td>
                                <td rowspan="7" align='center'><input type='text' size='11' name='p_pay_dt' maxlength='10' class='text' value='<%=pay_dt%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                            </tr>
                            <tr valign="middle" align="center">
                                <td align='center'>자동이체</td>
                                <td align='right'><%=AddUtil.parseDecimalLong(total_amt4)%></td>
                            </tr>
                            <tr valign="middle" align="center">
                                <td align='center'>선불카드</td>
                                <td align='right'><%=AddUtil.parseDecimalLong(total_amt2)%></td>
                            </tr>
                            <tr valign="middle" align="center">
                                <td align='center'>후불카드</td>
                                <td align='right'><%=AddUtil.parseDecimalLong(total_amt3)%></td>
                            </tr>
                            <tr valign="middle" align="center">
                                <td align='center'>카드할부</td>
                                <td align='right'><%=AddUtil.parseDecimalLong(total_amt17)%></td>
                            </tr>
                            <tr valign="middle" align="center">
                                <td align='center'>계좌이체</td>
                                <td align='right'><%=AddUtil.parseDecimalLong(total_amt5)%></td>
                            </tr>							
                            <tr valign="middle" align="center">
                                <td class=title>합계</td>
                                <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt0)%></td>
                            </tr>
                        </table>			
        			</td>	
        			<td width="100">&nbsp;</td>							  
                    <td width="600" class=line>
        			    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                            <tr valign="middle" align="center">
                                <td width='30' rowspan="2" class=title>결<br>재</td>
                                <td width='150' class=title>지점명</td>
                                <td width='150' class=title>요청자</td>
                                <td width='150' class=title>팀장</td>
                                <td width='150' class=title>대표이사</td>				  
                            </tr>
                            <tr>
                                <td align='center'>&nbsp;<br>&nbsp;<br>&nbsp;<br><br>&nbsp;<br><br><%=user_bean.getBr_nm()%><br><br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;</td>
                                <td align='center'>&nbsp;<br><br><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%>&nbsp;<br><br><%=doc.getUser_dt1()%><%if(doc.getUser_dt1().equals("")){%><a href="javascript:doc_sanction('1')"><img src=/acar/images/center/button_in_gj.gif border=0 align=absmiddle></a><%}%><br><br>&nbsp;<br>&nbsp;</td>
                                <td align='center'>&nbsp;<br><br><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%>&nbsp;<br><br><%=doc.getUser_dt2()%><%if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("")){%><%if(doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("임원",user_id)){%><a href="javascript:doc_sanction('2')"><img src=/acar/images/center/button_in_gj.gif border=0 align=absmiddle></a><%}%><%}%>
                                				<!--사후결재-->
								<%if(!doc.getDoc_step().equals("3") && doc.getUser_dt2().equals("")){%><%if(nm_db.getWorkAuthUser("전산팀",user_id)  || nm_db.getWorkAuthUser("입금담당",user_id) || nm_db.getWorkAuthUser("영업수당회계관리자",user_id) || nm_db.getWorkAuthUser("보험업무",user_id)){%><br>&nbsp;<br>&nbsp;<a href="javascript:doc_sanction_non('2')"><img src="/acar/images/center/button_gj_sh.gif" align="absmiddle" border="0"></a><%}%><%}%>
								<br><br>&nbsp;<br>&nbsp;</td>				
                                <td align='center'>&nbsp;<br><br><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%>&nbsp;<br><br><%=doc.getUser_dt3()%><%if(!doc.getUser_dt2().equals("") && doc.getUser_dt3().equals("")){%><%}%></td>
                            </tr>
                        </table>
        			</td>
        			<td width="200">&nbsp;</td>
                </tr>	
            </table>		  
	    </td>	
	</tr>
	<%}%>			  			  	
	<tr>
	  <td><hr></td>
    </tr>
</table>
</form>  
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
