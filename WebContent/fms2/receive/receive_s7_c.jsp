<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.user_mng.*,   acar.cls.*"%>
<%@ page import="acar.bill_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="rc_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?acar_br:request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	//if(base.getUse_yn().equals("Y"))	return;
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
		
		
	//해지정보
	ClsBean cls_info = ac_db.getClsCase(rent_mng_id, rent_l_cd);
	
	Hashtable fee_base = rc_db.getClsContInfo(rent_mng_id, rent_l_cd);
	
	//rent_start_dt
	String  start_dt =  rc_db.getRent_start_dt(rent_l_cd);
	
	int  days =  c_db.getDays(  AddUtil.getDate(4), cls_info.getCls_dt());
		
	String ven_code = "";
	String ven_name = "";
	
	Vector cms_bnk = c_db.getCmsBank();	//은행명을 가져온다.
	int cms_bnk_size1 = cms_bnk.size();
	
		
	//해지정산 리스트
	Vector vt_ext = ac_db.getClsList(base.getClient_id(), rent_l_cd);
	int vt_size = vt_ext.size();
	
	long total_amt	= 0;

	for(int i = 0 ; i < vt_size ; i++)
	{
		Hashtable ht = (Hashtable)vt_ext.elementAt(i);		
		total_amt = total_amt + AddUtil.parseLong(String.valueOf(ht.get("CLS_AMT")));		
	}	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
<script language="JavaScript">
<!--	
	
	//스캔관리 보기
	function view_scan(m_id, l_cd){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");		
	}
	
			//은행선택시 계좌번호 가져오기
	function change_bank(){
		var fm = document.form1;
		var bank_code = fm.bank_code.options[fm.bank_code.selectedIndex].value;
		fm.bank_code2.value = bank_code.substring(0,3);
		fm.bank_name.value = bank_code.substring(3);
		
		drop_deposit();		

		if(bank_code == ''){
			fm.bank_code.options[0] = new Option('선택', '');
			return;
		}else{
			fm.target='i_no';
			fm.action='/fms2/con_fee/get_deposit_nodisplay.jsp?bank_code='+bank_code.substring(0,3);
			fm.submit();
		}
	}
	
	function drop_deposit(){
		var fm = document.form1;
		var deposit_len = fm.deposit_no.length;
		for(var i = 0 ; i < deposit_len ; i++){
			fm.deposit_no.options[deposit_len-(i+1)] = null;
		}
	}
		
	function add_deposit(idx, val, str){
		document.form1.deposit_no[idx] = new Option(str, val);		
	}
	
	//기등록분은 등록 안되게 처리
	function save(){
		var fm = document.form1;
				
		if(fm.req_dt.value == '')				{ alert('위임일자를 입력하십시오'); 		fm.req_dt.focus(); 		return;	}
		if(fm.n_ven_code.value == '')			{ alert('위임업체를 입력하십시오'); 		fm.n_ven_name.focus(); 		return;	}
		
		if(fm.bank_cd.value == ""){ alert("은행을 선택하십시오."); return; }			
		if(fm.bank_nm.value == ""){ alert("예금주를 입력하십시오."); return; }			
		if(fm.bank_no.value == ""){ alert("계좌번호를 입력하십시오."); return; }				
		
		 if( toInt(parseDigit(fm.tot_amt.value)) < 1 ) { 	 alert('추심금액을  입력하십시오'); 		fm.tot_amt.focus(); 		return;	}	 
		 if( toInt(parseDigit(fm.re_rate.value)) < 1 ) { 	 alert('수수료를 입력하십시오'); 		fm.re_rate.focus(); 		return;	}	 
				
		if(fm.re_bank_cd.value == ""){ alert("은행을 선택하십시오."); return; }		
		if(fm.re_bank_nm.value == ""){ alert("예금주를 입력하십시오."); return; }			
		if(fm.re_bank_no.value == ""){ alert("계좌번호를 입력하십시오."); return; }		
		
		
		//미회수자동차의위임구분 :미회수자동차가 있는 경우만 해당 
					
		if(confirm('등록하시겠습니까?')){	
			fm.action='receive_7_c_a.jsp';	
//			fm.target='ii_no';
			fm.target='d_content';
			fm.submit();
		}		

	}
	
	
	//위임업체 조회하기
	function search(idx){
		var fm = document.form1;	
		var t_wd;
		if(fm.n_ven_name.value != ''){	fm.t_wd.value = fm.n_ven_name.value;		}
		else{ 							alert('조회할 거래처명을 입력하십시오.'); 	fm.n_ven_name.focus(); 	return;}
		window.open("vendor_list.jsp?idx="+idx+"&t_wd="+fm.t_wd.value, "VENDOR_LIST", "left=350, top=150, width=700, height=400, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	function search_enter(idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') search(idx);
	}	
	
	
	
	// 자동계산
	function set_cls_amt(obj){
		var fm = document.form1;
											
		obj.value=parseDecimal(obj.value);
		if(obj == fm.band_amt || obj == fm.no_re_amt){ 
			fm.tot_amt.value 	= parseDecimal( toInt(parseDigit(fm.band_amt.value)) + toInt(parseDigit(fm.no_re_amt.value)) );				
		}	    	
	}
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='' name="form1" method='post'>

<input type='hidden' name='car_gu' 	value='<%=base.getCar_gu()%>'>
<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 	value='<%=user_id%>'>
<input type='hidden' name='br_id' 	value='<%=br_id%>'>
<input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
<input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
<input type='hidden' name='andor'	 	value='<%=andor%>'>
<input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
<input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">

  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
 	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>기본사항</span></td>
	</tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>                              
                    <td width='12%' class='title' height="91">계약번호</td>
                    <td height="17%">&nbsp;<%=fee_base.get("RENT_L_CD")%></td>
                    <td width='13%' class='title'>담당자</td>
                    <td height="25%">&nbsp;영업담당 : <%=c_db.getNameById((String)fee_base.get("BUS_ID2"),"USER")%> 
                      / 관리담당 : <%=c_db.getNameById((String)fee_base.get("MNG_ID"),"USER")%></td>
                    <td width='12%' class='title'>대여방식</td>
                    <td width='21%'>&nbsp; <%=fee_base.get("RENT_WAY")%></td>
                </tr>
                <tr> 
                    <td class='title'>상호</td>
                    <td>&nbsp;<%=fee_base.get("FIRM_NM")%></td>
                    <td class='title'>고객명</td>
                    <td>&nbsp;<%=fee_base.get("CLIENT_NM")%></td>
                    <td class='title'>대여차명</td>
                    <td>&nbsp;<%=fee_base.get("CAR_NM")%>&nbsp;<%=fee_base.get("CAR_NAME")%></td>
                </tr>
                <tr> 
                    <td class='title'>차량번호</td>
                    <td>&nbsp;<font color="#000099"><b><%=fee_base.get("CAR_NO")%></b></font></td>
                    <td class='title'>등록일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2((String)fee_base.get("INIT_REG_DT"))%></td>
                    <td class='title'>대여기간</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(start_dt)%>&nbsp;~&nbsp;<%=cls_info.getCls_dt()%></td>
                </tr>
                <tr> 
                   <td class='title' height="91">해지구분</td>
                    <td >&nbsp;<%=cls_info.getCls_st()%> </td>                    
                    <td class='title'>해지일</td>
                    <td>&nbsp;<%=cls_info.getCls_dt()%>&nbsp;&nbsp; <font color="#000099"> (경과기일:  <%=days%>일  ) </font></td>
                    <td class='title'>실이용기간</td>
                    <td>&nbsp;<%=cls_info.getRcon_mon()%>개월&nbsp;<%=cls_info.getRcon_day()%>일</td>
              
                </tr>          
                <tr> 
                    <td class='title' style='height:40'>해지내역 </td>
                    <td colspan="5">
                        <table border="0" cellspacing="0" cellpadding="3" width=100%>
                            <tr>
                                <td><%=cls_info.getCls_cau()%> </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
       
    <tr></tr><tr></tr><tr></tr>  	  
        
    <tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>위임내역</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	
		    	 <tr>
		                    <td width="13%" class=title>위임일자</td>
		                    <td colspan=6>&nbsp;<input type='text' name='req_dt' value='<%=AddUtil.getDate()%>' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td> 		           
	                </tr>
	                 <tr>
	                    <td width="13%" class=title>위임업체명</td>
	                    <td colspan=4>&nbsp;
		            	<input name="n_ven_name" type="text" class="text" value="<%=ven_name%>" size="35" style='IME-MODE: active' onKeyDown="javasript:search_enter(1)">
						&nbsp;&nbsp;&nbsp;* 네오엠코드 : &nbsp;	        
				<input type="text" readonly name="n_ven_code" value="<%=ven_code%>" class='whitetext' >
			      	<input type="hidden" name="n_ven_nm_cd"  value="">&nbsp;		
						<a href="javascript:search(1);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a> </td>				
		
	                    <td width="13%" class='title'>추심수수료(vat별도)</td>
	                    <td>&nbsp;회수금액의 <input type="text" name="re_rate" value="25" size="3" class=num>%</td>	             
	                </tr>
	                 <tr>
	                    <td width="13%" class=title>부서명</td>
	                    <td width="20%">&nbsp;<input type="text" name="re_dept" value="" size="25" class=text></td>
	                    <td width="10%" class='title' rowspan=2>담당자</td>
	                    <td width="10%" class='title'>성명</td>
	                    <td><input type="text" name="re_nm" value="" size="25" class=text></td>	             
	                   <td width="13%" class='title'>fax</td>
	                    <td><input type="text" name="re_fax" value="" size="25" class=text></td>	             
	                </tr>
	                 <tr>
	                    <td width="13%" class=title>대표전화</td>
	                    <td width="20%">&nbsp;<input type="text" name="re_tel" value="" size="25" class=text></td>	            
	                    <td width="10%" class='title'>연락처</td>
	                    <td><input type="text" name="re_phone" value="" size="25" class=text></td>	             
	                   <td width="13%" class='title'>이메일</td>
	                    <td><input type="text" name="re_mail" value="" size="25" class=text></td>	             
	                </tr>     
	            
		       </table>
		      </td>        
         </tr>   
               
     	</table>
      </td>	 
    </tr>	 
        
    <tr></tr><tr></tr>
        <tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>거래계좌</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	
		    	 <tr>
		                    <td width="50%" class=title colspan=3>채권회수금 입금계좌</td>
		                    <td width="50%" class=title colspan=3>추심수수료 지급계좌</td>		                
	                </tr>
	                 <tr>
	                    <td width="15%" class=title>은행명</td>
	                     <td width="15%" class=title>예금주</td>
	                     <td width="20%" class=title>계좌번호</td>
	                      <td width="15%" class=title>은행명</td>
	                      <td width="15%" class=title>예금주</td>
	                      <td width="20%" class=title>계좌번호</td>	            
	                </tr>
	                   <tr>
	                      <td >&nbsp; <select name="bank_cd" style="width:135">
                            <option value="026">신한은행</option> 
			      </select></td>	   	           
	                     <td width="15%">&nbsp;<input type="text" name="bank_nm" value="(주)아마존카" size="25" class=text></td>
	                     <td width="20%">&nbsp;<input type="text" name="bank_no" value="140-004-023871" size="25" class=text></td>
	                    <td >&nbsp; <select name="re_bank_cd" style="width:135">
                              <option value="026">신한은행</option>
			            </select></td>	             
	                      <td width="15%">&nbsp;<input type="text" name="re_bank_nm" value="(주)아마존카" size="25" class=text></td>
	                      <td width="20%">&nbsp;<input type="text" name="re_bank_no" value="140-004-023871" size="25" class=text></td>	            
	                </tr>         
	              
		       </table>
		      </td>  
		     <tr>       
       	</table>
      </td>	 
    </tr>	   
          <tr></tr><tr></tr>
          <tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>위임채권의 내용</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	
		    	 <tr>
		                     <td width="8%" class=title rowspan=3>채권</td>
		                     <td width="10%" class=title >금전채권</td>
		                     <td colspan=3 >&nbsp;<input type="text" name="band_amt" value="<%=AddUtil.parseDecimal((String) fee_base.get("AMT"))%>" size="15" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>
		                     <td width="10%" class=title >기준일자</td>		                
		                     <td width="10%" ><input type="text" name="basic_dt" value="" size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td> 	       
	                  </tr>
	                	 <tr>
		                     <td width="10%" class=title >미회수자동차</td>
		                     <td width="12%">&nbsp;<input type="text" name="no_re_amt" value="" size="15" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>
		                     <td width="10%" class=title >잔가</td>		                
		                     <td width="10%" ><input type="text" name="car_jan_amt" value="" size="15" class=num></td>	
		                     <td width="10%" class=title >잔가산정기준/일자</td>	
		                     <td width="10%" >&nbsp;</td>		                
	                  </tr>
	                   <tr>
		                     <td width="10%" class=title >합계</td>
		                     <td width="12%">&nbsp;<input type="text" name="tot_amt" value="" readonly size="15" class=num></td>
		                     <td width="13%" class=title >미회수자동차의위임구분</td>		                
		                     <td width="13%" >&nbsp;<input type="radio" name="re_st" value="1" >통합위임
	                            <input type="radio" name="re_st" value="2"  >개별</td>	              
		                     <td  colspan=2>&nbsp;합계=금전채권+미회수자동차의 잔가</td>		                
	                  </tr>
	                   <tr>
		                     <td width="13%" class=title  colspan=2 >동일채무자 타채권</td>
		                     <td width="12%" align=right ><%=vt_size%>건</td>		                                 
		                     <td width="10%" class=title >총채권금액</td>	
		                     <td align=right><%=Util.parseDecimal(total_amt)%></td>
		                     <td colspan=2>&nbsp;</td>		  		                
	                  </tr>
	                  	              
		       </table>
		      </td>        
         </tr>   
           
     	 <tr>
     		 <td>&nbsp;</td>
     	 </tr>
     	</table>
      </td>	 
    </tr>	  	 	     	 	    
   
    <tr><td class=line2 colspan=2></td></tr> 
     <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
               <tr> 
	                    <td class=title> 특이사항</td>
	                    <td colspan="5" height="76"> 
	                     &nbsp;<textarea name="remarks" cols="140" rows="3"></textarea>
	                  </td>
	           </tr>       
	          </table>        
         </td>
    </tr>            
        
    <tr>
	  <td align="center">&nbsp;<a href="javascript:save();"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></td>
	</tr>	
  
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	set_init();
	
	function set_init(){
		var fm = document.form1;
		
		fm.tot_amt.value 	= parseDecimal( toInt(parseDigit(fm.band_amt.value)) + toInt(parseDigit(fm.no_re_amt.value)) );	
 	}
 	 	
//-->
</script>
</body>
</html>
