<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.user_mng.*, acar.doc_settle.*, acar.biz_partner.*, acar.inside_bank.*"%>
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
	BizPartnerDatabase 	bp_db 	= BizPartnerDatabase.getInstance();
	InsideBankDatabase 	ib_db 	= InsideBankDatabase.getInstance();
	
	String actseq 	= request.getParameter("actseq")==null? "":request.getParameter("actseq");
	
	String bank_code 	= request.getParameter("bank_code")==null? "":request.getParameter("bank_code");
	String p_pay_dt 	= request.getParameter("p_pay_dt")==null? "":request.getParameter("p_pay_dt");
	String off_nm 		= request.getParameter("off_nm")==null? "":request.getParameter("off_nm");
	String bank_no 		= request.getParameter("bank_no")==null? "":request.getParameter("bank_no");
	String a_bank_no 	= request.getParameter("a_bank_no")==null? "":request.getParameter("a_bank_no");
	
	if(actseq.equals("")){
		actseq = pm_db.getActSeqSearch(bank_code, p_pay_dt, off_nm, bank_no, a_bank_no);
	}
	
	//송금원장
	PayMngActBean act 	= pm_db.getPayAct(actseq);
	
	//송금수수료 처리-원장에서 처리
	Vector vt =  pm_db.getPayActList(act.getBank_code(), "", act.getOff_nm(), act.getBank_no(), act.getA_bank_no());
	int vt_size = vt.size();
	
	//은행연동에 따라 수정제한을 두어야 함--비즈파트너
	ErpTransBean et = bp_db.getErpTransCase(actseq);
	
	//은행연동에 따라 수정제한을 두어야 함--인사이트뱅크
	IbBulkTranBean it = ib_db.getIbBulkTranCase(actseq);
	
	
	
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
	
	int s1 = 0;
	int b1 = 0;
	int d1 = 0;
	
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
		
		var a_amt = toInt(parseDigit(fm.act_amt.value));
		var t_amt = toInt(parseDigit(fm.t_amt.value))-toInt(parseDigit(fm.t_m_amt.value));
		
		var a_commi = toInt(parseDigit(fm.commi.value));
		var t_commi = toInt(parseDigit(fm.t_commi.value));

				
		if(confirm('송금하시겠습니까?')){
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
			
			fm.action = 'pay_r_act_u_a.jsp';
			fm.target = 'i_no';
			fm.submit();		
			
			link.getAttribute('href',originFunc);
		}
	}
	
	function sum_amt(){
		var fm = document.form1;
		var t_amt = 0;
		var t_m_amt = 0;
		var t_commi = 0;		
		if(<%=vt_size%> == 1){
			fm.t_amt.value 	 = fm.p_amt.value;		
			fm.t_m_amt.value = fm.p_m_amt.value;		
			fm.t_commi.value = fm.p_commi.value;					
		}else{
			for(var i = 0 ; i < <%=vt_size%> ; i ++){
				t_amt += toInt(parseDigit(fm.p_amt[i].value));
				t_m_amt += toInt(parseDigit(fm.p_m_amt[i].value));
				t_commi += toInt(parseDigit(fm.p_commi[i].value));
			}
			fm.t_amt.value 		= parseDecimal(t_amt);
			fm.t_m_amt.value 	= parseDecimal(t_m_amt);
			fm.t_commi.value 	= parseDecimal(t_commi);
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
				}else if(p_gubun == '31' || p_gubun == '37'){
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
  <input type='hidden' name="actseq" 	value="<%=actseq%>">  
  <input type='hidden' name="vt_size" 	value="<%=vt_size%>">    



<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td><< 송금요청 >></td>
    </tr>  
    <tr>
      <td class=line2></td>
    </tr>    
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="15%" class=title>송금코드</td>
            <td >&nbsp;			  
              <%=actseq%> </td>
          </tr>		
          <tr>
            <td class=title>금액</td>
            <td>&nbsp;
              <input type='text' name='act_amt' size='15' value='<%=AddUtil.parseDecimalLong(act.getAmt())%>' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>
              원 &nbsp;
		    </td>
          </tr>		
          <tr>
            <td class=title>수수료</td>
            <td>&nbsp;
              <input type='text' name='commi' size='6' maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(act.getCommi())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
              원 &nbsp;
		    </td>
          </tr>		  		    
          <tr>
            <td width="15%" class=title>출금일자</td>
            <td >&nbsp;			  
              <input type='text' name='act_dt' size='11' value='<%=AddUtil.ChangeDate2(act.getAct_dt())%>' class='default' > </td>
          </tr>		
          <tr>
            <td class=title>지출처</td>
            <td>&nbsp;              
              <input type='text' name='off_nm' size='30' value='<%=act.getOff_nm()%>' class='default' >
            </td>
          </tr>		
          <tr>
            <td class=title>입금계좌</td>
            <td >
			  <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                   <td width="15%">&nbsp;			  
				     <input type='text' name='bank_nm' size='15' value='<%=act.getBank_nm()%>' class='default' ></td>
				   <td width="25%"><input type='text' name='bank_no' size='25' value='<%=act.getBank_no()%>' class='default' ></td>
				   <td width="60%">예금주 : <input type='text' name='bank_acc_nm' size='33' value='<%=act.getBank_acc_nm()%>' class='default' > </td>
				 </tr>
			  </table>	 
            </td>
          </tr>
          <tr>
            <td class=title>출금계좌</td>
            <td >
			  <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                   <td width="15%">&nbsp;	
				     <input type='text' name='a_bank_nm' size='15' value='<%=act.getA_bank_nm()%>' class='default' ></td>
				   <td width="25%"><input type='text' name='a_bank_no' size='25' value='<%=act.getA_bank_no()%>' class='default' ></td>
				   <td width="60%"></td>
				 </tr>
			  </table>	 			
            </td>
          </tr>		
          <tr>
            <td width="15%" class=title>입금자표시</td>
            <td >&nbsp;			  
              <input type='text' name='bank_memo' size='20' value='<%=act.getBank_memo()%>' class='default' > </td>
          </tr>				  		    		  
          <tr>
            <td width="15%" class=title>CMS코드</td>
            <td >&nbsp;			  
              <input type='text' name='cms_code' size='20' value='<%=act.getCms_code()%>' class='default' > </td>
          </tr>				  		    		  
		</table>
	  </td>
	</tr> 	
	<%if(!et.getTran_dt().equals("")){%>
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>은행연동(비즈파트너)</span></td>
	</tr>  		
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="10%" class=title>금액</td>									
			<td width="7%" class=title>수수료</td>			
            <td width="7%" class=title>출금일자</td>			
            <td width="18%" class=title>입금계좌번호</td>						
            <td width="13%" class=title>입금계좌예금주</td>			
            <td width="18%" class=title>출금계좌</td>
            <td width="14%" class=title>입금자표시</td>			
            <td width="10%" class=title>CMS코드</td>						
			<td width="3%" class=title>상태</td>			
          </tr>
          <tr>
            <td align="center"><input type='text' name='e_act_amt' size='15' value='<%=AddUtil.parseDecimalLong(et.getTran_amt())%>' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>						
            <td align="right"><%=Util.parseDecimal(et.getTran_fee())%>원</td>									
            <td align="center"><%=AddUtil.ChangeDate2(et.getTran_dt())%></td>									
            <td align="center"><input type='text' name='e_bank_id' size='3' value='<%=et.getIn_bank_id()%>' class='default' >
			                   &nbsp;<input type='text' name='e_bank_nm' size='15' value='<%=et.getIn_bank_name()%>' class='default' >
			                   <br><input type='text' name='e_bank_no' size='20' value='<%=et.getIn_acct_no()%>' class='default' ></td>
            <td align="center"><input type='text' name='e_bank_acc_nm' size='15' value='<%=et.getReceip_owner_name()%>' class='default' ></td>			
            <td align="center"><input type='text' name='e_a_bank_id' size='3' value='<%=et.getOut_bank_id()%>' class='default' >
			                   &nbsp;<input type='text' name='e_a_bank_nm' size='15' value='<%=et.getOut_bank_name()%>' class='default' >
			                   <br><input type='text' name='e_a_bank_no' size='20' value='<%=et.getOut_acct_no()%>' class='default' ></td>												
			<td align="center"><input type='text' name='e_bank_memo' size='15' value='<%=et.getIn_acct_memo()%>' class='default' ></td>
			<td align="center"><input type='text' name='e_cms_code' size='10' value='<%=et.getCms_code()%>' class='default' ></td>			
			<td align="center"><b><%=et.getErr_reason()%></b></td>
          </tr>		  
		</table>
	  </td>
	</tr> 				
	<tr>
		<td>* 은행연동 상태가 등록일때만 입금자표시 및 CMS코드를 수정합니다.</td>	
	</tr>	
	<%}%>		
	<%if(!it.getTran_dt().equals("")){%>
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>은행연동(인사이드뱅크)</span></td>
	</tr>  		
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="14%" class=title>금액</td>									
			      <td width="7%" class=title>수수료</td>			
            <td width="7%" class=title>출금일자</td>			
            <td width="16%" class=title>입금계좌번호</td>						
            <td width="13%" class=title>입금계좌예금주</td>			
            <td width="16%" class=title>출금계좌</td>
            <td width="14%" class=title>입금자표시</td>			
            <td width="10%" class=title>CMS코드</td>						
			<td width="3%" class=title>상태</td>			
          </tr>
          <tr>
            <td align="center"><input type='text' name='i_act_amt' size='15' value='<%=AddUtil.parseDecimalLong(it.getTran_amt_req())%>' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>						
            <td align="right"><%=Util.parseDecimal(it.getTran_fee())%>원</td>									
            <td align="center"><%=AddUtil.ChangeDate2(it.getTran_dt())%></td>									
            <td align="center"><input type='text' name='i_bank_id' size='3' value='<%=it.getTran_ip_bank_id()%>' class='default' >
			                   <br><input type='text' name='i_bank_no' size='20' value='<%=it.getTran_ip_acct_nb()%>' class='default' ></td>
            <td align="center"><input type='text' name='i_bank_acc_nm' size='15' value='<%=it.getTran_remittee_nm()%>' class='default' ></td>			
            <td align="center">신한<br><input type='text' name='i_a_bank_no' size='20' value='<%=it.getTran_ji_acct_nb()%>' class='default' ></td>												
			<td align="center"><input type='text' name='i_bank_memo' size='15' value='<%=it.getTran_ip_naeyong()%>' class='default' ></td>
			<td align="center"><input type='text' name='i_cms_code' size='10' value='<%=it.getTran_cms_cd()%>' class='default' ></td>			
			<td align="center"><b><%if(it.getTran_result_cd().equals("00")){%>처리전
			<%}else if(it.getTran_result_cd().equals("01")){%>처리중
			<%}else if(it.getTran_result_cd().equals("02")){%>정상처리
			<%}else if(it.getTran_result_cd().equals("03")){%>처리오류
			<%}%>
			</b></td>
          </tr>		  
		</table>
	  </td>
	</tr> 				
	<tr>
		<td>* 은행연동 상태가 등록일때만 입금자표시 및 CMS코드를 수정합니다.</td>	
	</tr>	
	<%}%>			
	<tr>
	  <td><hr></td>
	</tr>  			
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>세부리스트</span></td>
	</tr>  		
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="3%" class=title>연번</td>
            <td width="3%" class=title>증빙<br>서류</td>
            <td width="12%" class=title>관리번호</td>
            <td width="12%" class=title>금액</td>									
            <td width="7%" class=title>미지출금액</td>												
			      <td width="6%" class=title>수수료</td>			
            <td width="9%" class=title>출금일자</td>			
            <td width="16%" class=title>입금계좌번호</td>						
            <td width="13%" class=title>입금계좌예금주</td>			
            <td width="16%" class=title>출금계좌</td>									
			<td width="3%" class=title>상태</td>			
          </tr>
          <%
		 	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
				total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("M_AMT")));
				total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("COMMI")));%>			  
          <tr>
            <td align="center"><%=i+1%><input type="hidden" name="p_reqseq" 	value="<%=ht.get("REQSEQ")%>"></td>
          <td align='center'>
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
            <td align="center"><%=ht.get("REQSEQ")%></td>
            <td align="right"><input type='text' name='p_amt' size='15' value='<%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%>' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); sum_amt();'>원</td>						
            <td align="right"><input type='text' name='p_m_amt' size='7' value='<%=Util.parseDecimal(String.valueOf(ht.get("M_AMT")))%>' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); sum_amt();'>원</td>									
            <td align="right"><input type='text' name='p_commi' size='5' value='<%=Util.parseDecimal(String.valueOf(ht.get("COMMI")))%>' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); sum_amt();'>원</td>									
            <td align="center"><input type='text' name='p_p_pay_dt' size='11' value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("P_PAY_DT")))%>' class='default' ></td>									
            <td align="center"><input type='text' name='p_bank_nm' size='20' value='<%=ht.get("BANK_NM")%>' class='default' ><br><input type='text' name='p_bank_no' size='20' value='<%=ht.get("BANK_NO")%>' class='default' ></td>
            <td align="center"><input type='text' name='p_bank_acc_nm' size='15' value='<%=ht.get("BANK_ACC_NM")%>' class='default' ></td>			
            <td align="center"><input type='text' name='p_a_bank_nm' size='20' value='<%=ht.get("A_BANK_NM")%>' class='default' ><br><input type='text' name='p_a_bank_no' size='20' value='<%=ht.get("A_BANK_NO")%>' class='default' ></td>												
			<td align="center"><%=ht.get("P_STEP")%></td>
          </tr>
	      <%}%>		
		  <tr>
		    <td class=title colspan='3'>합계</td>
		    <td align="right"><input type='num' name='t_amt' size='15' value='<%=AddUtil.parseDecimalLong(total_amt1)%>' class='whitenum' >원</td>
		    <td align="right"><input type='text' name='t_m_amt' size='7' value='<%=AddUtil.parseDecimalLong(total_amt2)%>' class='defaultnum' >원</td>
		    <td align="right"><input type='text' name='t_commi' size='5' value='<%=AddUtil.parseDecimalLong(total_amt3)%>' class='defaultnum' >원</td>
		    <td class=title colspan='5'>&nbsp;</td>			
		  </tr>
		</table>
	  </td>
	</tr> 				
	<tr>
		<td>&nbsp;</td>	
	</tr>		
    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>	
    <tr>
	    <td align='center'>
	    <a id="submitLink" href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    </td>
	</tr>	
    <%}%>	
</table>
</form>  
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
