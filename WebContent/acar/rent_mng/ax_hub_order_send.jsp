<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.res_search.*, ax_hub.* "%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");	
	String brch_id 		= request.getParameter("brch_id")	==null?"":request.getParameter("brch_id");
	String start_dt 	= request.getParameter("start_dt")	==null?"":request.getParameter("start_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");		
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");	
	String s_cc 		= request.getParameter("s_cc")		==null?"":request.getParameter("s_cc");
	String s_year 		= request.getParameter("s_year")	==null?"":request.getParameter("s_year");
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"":request.getParameter("asc");

	String s_cd 		= request.getParameter("s_cd")		==null?"":request.getParameter("s_cd");
	String c_id 		= request.getParameter("c_id")		==null?"":request.getParameter("c_id");
	String mode 		= request.getParameter("mode")		==null?"":request.getParameter("mode");		
	String f_page 		= request.getParameter("f_page")	==null?"":request.getParameter("f_page");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String list_from_page 	= request.getParameter("list_from_page")==null?"":request.getParameter("list_from_page");
		
	String scd_rent_st 	= request.getParameter("scd_rent_st")	==null?"":request.getParameter("scd_rent_st");
	String scd_tm 		= request.getParameter("scd_tm")	==null?"":request.getParameter("scd_tm");
	
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	
	String rent_st = rc_bean.getRent_st();
	
	//고객정보
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
			
	//단기관리자-연대보증인
	RentMgrBean rm_bean2 = rs_db.getRentMgrCase(s_cd, "2");
	RentMgrBean rm_bean4 = rs_db.getRentMgrCase(s_cd, "4");	
	
	//연장계약
	Vector exts = rs_db.getRentContExtList(s_cd);
	int ext_size = exts.size();	
	
	//스케줄정보
	ScdRentBean sr_bean = rs_db.getScdRentCase(s_cd, scd_rent_st, scd_tm);
	
	
	//결제연동 기발행건이 있는지 확인한다.
	Hashtable ht_ax = rs_db.getAxHubCase(s_cd, c_id, sr_bean.getRent_s_amt()+sr_bean.getRent_v_amt());
	
	String am_ax_code = String.valueOf(ht_ax.get("AM_AX_CODE"))==null?"":String.valueOf(ht_ax.get("AM_AX_CODE"));
	
	

%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
	//저장하기
	function save(){
		var fm = document.form1;	
		
		//if(fm.email.value == ''){ alert('이메일주소를 입력하십시오'); fm.email.focus(); return; }	
		
		if(fm.m_tel.value == ''){ alert('휴대폰번호를 입력하십시오'); fm.m_tel.focus(); return; }	
						
		//if(fm.email.value.indexOf("@") == -1)	{ alert('이메일주소를 확인하십시오.'); fm.email.focus(); return; }	
		//if(fm.email.value.indexOf(".") == -1)	{ alert('이메일주소를 확인하십시오.'); fm.email.focus(); return; }	
		//if(fm.email.value.length  < 6)		{ alert('이메일주소를 확인하십시오.'); fm.email.focus(); return; }	
		
		if(fm.m_tel.value.length  < 10)		{ alert('휴대폰번호를 확인하십시오.'); fm.m_tel.focus(); return; }	
		
		<%if(am_ax_code.equals("") || am_ax_code.equals("null")){%>
			<%if(!sr_bean.getRent_st().equals("2")){%>       
				//if(fm.am_good_m_amt.value == 0){	alert('비과세금액을 입력하십시오.'); fm.am_good_m_amt.focus(); return; }				
			<%}%>
		<%}%>
	
		
		if(!confirm('발송하시겠습니까?')){		return;	}
		fm.action = 'ax_hub_order_send_a.jsp';
		fm.target = 'i_no';
		//fm.target = '_self';
		fm.submit();			
	}
	
	function Resend(){
		var fm = document.form1;	
		if(!confirm('재발행 하시겠습니까?')){	return;	}			
		fm.action = 'ax_hub_order_resend_a.jsp';
		fm.target = 'i_no';
		//fm.target = '_self';
		fm.submit();		
	}
	
	function set_amt(){
		var fm = document.form1;
		fm.am_good_amt.value 	= parseDecimal(toInt(parseDigit(fm.am_good_s_amt.value)) + toInt(parseDigit(fm.am_good_v_amt.value)) + toInt(parseDigit(fm.am_good_m_amt.value)));
	}	
		
</script>
</head>
<body>

<form action="" name="form1" method="post" >
 <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' 		value='<%=user_id%>'>
 <input type='hidden' name='br_id' 		value='<%=br_id%>'>
 <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>  
 <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>   
 <input type='hidden' name='brch_id' 		value='<%=brch_id%>'> 
 <input type='hidden' name='start_dt' 		value='<%=start_dt%>'> 
 <input type='hidden' name='end_dt' 		value='<%=end_dt%>'>   
 <input type='hidden' name='car_comp_id' 	value='<%=car_comp_id%>'>   
 <input type='hidden' name='code' 		value='<%=code%>'>     
 <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
 <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			 
 <input type='hidden' name='s_cc' 		value='<%=s_cc%>'>
 <input type='hidden' name='s_year' 		value='<%=s_year%>'> 
 <input type='hidden' name='sort_gubun' 	value='<%=sort_gubun%>'> 
 <input type='hidden' name='asc' 		value='<%=asc%>'> 
 <input type='hidden' name='from_page' 		value='<%=from_page%>'>
 <input type='hidden' name='list_from_page' 	value='<%=list_from_page%>'>
 <input type='hidden' name='s_cd' 		value='<%=s_cd%>'>
 <input type='hidden' name='c_id' 		value='<%=c_id%>'>
 <input type='hidden' name='scd_rent_st' 	value='<%=scd_rent_st%>'>
 <input type='hidden' name='scd_tm' 		value='<%=scd_tm%>'>
 
 <input type='hidden' name='car_no' 		value='<%=reserv.get("CAR_NO")%>'>        
 <input type='hidden' name='c_firm_nm' 		value='<%=rc_bean2.getFirm_nm()%>'>         
 <input type='hidden' name='c_client_nm' 	value='<%=rc_bean2.getCust_nm()%>'>     
 
       
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 월렌트관리 > <span class=style5>선수대여료 카드결제 인증번호 발송</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>월렌트 정보</span></td>
    </tr>              
    <tr><td class=line2></td></tr>  
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=15%>차량번호</td>
                    <td width=35%>&nbsp;<%=reserv.get("CAR_NO")%></td>
                    <td class=title width=15%>차명</td>
                    <td width=35%>&nbsp;<%=reserv.get("CAR_NM")%></td>
                <tr>                     
                    <td class=title>성명</td>
                    <td>&nbsp;<%=rc_bean2.getCust_nm()%></td>
                    <td class=title>상호</td>
                    <td>&nbsp;<%=rc_bean2.getFirm_nm()%></td>
                </tr>
                <tr> 
                    <td class=title>대여기간</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRent_start_dt())%>
                     ~ <%=AddUtil.ChangeDate3(rc_bean.getRent_end_dt())%> 
                     (<%=rc_bean.getRent_months()%>개월
                     <%=rc_bean.getRent_days()%>일)
                    </td>
                </tr>
    		  <%
    			if(ext_size > 0){
    				for(int i = 0 ; i < ext_size ; i++){
    					Hashtable ext = (Hashtable)exts.elementAt(i);%>		
                <tr> 
                    <td class=title>연장 [<%=i+1%>]</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_START_DT")))%>
                      ~ <%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_END_DT")))%>
                      (<%=ext.get("RENT_MONTHS")%>개월
                      <%=ext.get("RENT_DAYS")%>일)     
                    </td>
                </tr>    					    					
    		  <%		}
    		  	}%>			                
                <tr> 
                    <td class=title>배차일시</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_dt())%><%if(rc_bean.getDeli_dt().equals("") && rc_bean.getUse_st().equals("1")){%>예약 <%=AddUtil.ChangeDate3(rc_bean.getDeli_plan_dt())%><%}%></td>
                    <td class=title>반차예정일시</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRet_plan_dt())%></td>
                </tr>
                <tr> 
                    <td class=title>최초영업자</td>
                    <td>&nbsp;<%=c_db.getNameById(rc_bean.getBus_id(),"USER")%></td>
                    <td class=title>관리담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(rc_bean.getMng_id(),"USER")%></td>
                </tr>                
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <%if(am_ax_code.equals("") || am_ax_code.equals("null")){%>
    <tr><td class=line2></td></tr> 
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=15%>발송방식</td>
                   <td>
                      &nbsp;휴대폰문자        		    
                    </td>
                </tr>
                <tr> 
                    <td class=title>휴대폰번호</td>
                   <td>
                      &nbsp;<input type="text" name="m_tel" value="<%=rm_bean4.getEtc()%>" size="15" class=text>
                      (인증번호 받을 번호)
                      <input type='hidden' name='email' value='<%=rc_bean2.getEmail()%>'>
                    </td>
                </tr>                
                <%if(sr_bean.getRent_st().equals("2")){%>              
                <tr> 
                    <td class=title>결제금액</td>
                    <td> 
                      &nbsp;<b><%=AddUtil.parseDecimal(sr_bean.getRent_s_amt()+sr_bean.getRent_v_amt())%>원</b>
                      <input type='hidden' name='am_good_s_amt' value='<%=sr_bean.getRent_s_amt()%>'>
                      <input type='hidden' name='am_good_v_amt' value='<%=sr_bean.getRent_v_amt()%>'>
                      <input type='hidden' name='am_good_amt'   value='<%=sr_bean.getRent_s_amt()+sr_bean.getRent_v_amt()%>'>
                      <input type='hidden' name='am_good_m_amt' value='0'>
                    </td>
                </tr>
                <%}else{%>
                <tr> 
                    <td class=title>카드결제금액</td>
                    <td> 
                      &nbsp;<input type="text" name="am_good_amt" value="<%=Util.parseDecimal(sr_bean.getRent_s_amt()+sr_bean.getRent_v_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>원
                    </td>
                </tr>      
                <tr> 
                    <td class=title>과세</td>
                    <td> 
                      &nbsp;공급가 : <input type="text" name="am_good_s_amt" value="<%=Util.parseDecimal(sr_bean.getRent_s_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>원
                      &nbsp;부가세 : <input type="text" name="am_good_v_amt" value="<%=Util.parseDecimal(sr_bean.getRent_v_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>원
                      &nbsp;(<%=AddUtil.parseDecimal(sr_bean.getRent_s_amt()+sr_bean.getRent_v_amt())%>원)
                    </td>
                </tr>                              
                <tr> 
                    <td class=title>비과세</td>
                    <td> 
                      &nbsp;<input type="text" name="am_good_m_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>원
                      (카드수수료(3.7%) 등 비과세)
                    </td>
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
	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>		  	  	  
		<a href='javascript:save();'><img src="/acar/images/center/button_conf.gif" border="0" align=absmiddle></a>
	    <%}%>			
	    &nbsp;<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>				
	</td>
    </tr>    
    <%}else{%>
    <tr><td class=line2></td></tr> 
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=15%>인증번호</td>
                   <td>
                      &nbsp;<%=String.valueOf(ht_ax.get("AM_AX_CODE"))%>
                      <input type='hidden' name='am_ax_code' 	value='<%=ht_ax.get("AM_AX_CODE")%>'>     
                    </td>
                </tr>
                <tr> 
                    <td class=title>결제금액</td>
                    <td> 
                      &nbsp;<b><%=AddUtil.parseDecimal(String.valueOf(ht_ax.get("AM_GOOD_AMT")))%>원</b>
                      <input type='hidden' name='am_good_amt' 	value='<%=ht_ax.get("AM_GOOD_AMT")%>'>     
                    </td>
                </tr>
                <!--
                <tr> 
                    <td class=title>이메일주소</td>
                   <td>
                      &nbsp;<%=String.valueOf(ht_ax.get("BUYR_MAIL"))%>
                    </td>
                </tr>     
                -->
                <tr> 
                    <td class=title>휴대폰번호</td>
                   <td>
                      &nbsp;<%=String.valueOf(ht_ax.get("BUYR_TEL2"))%>
                    </td>
                </tr>                              
            </table>
        </td>
    </tr>     
    <tr>
        <td class=h></td>
    </tr>  
    <%		if(String.valueOf(ht_ax.get("ORDR_IDXX")).equals("")){%>	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>문자 재발송</span></td>
    </tr>         
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
               <tr> 
                    <td class=title width=15%>휴대폰번호</td>
                   <td>
                      &nbsp;<input type="text" name="m_tel" value="<%=String.valueOf(ht_ax.get("BUYR_TEL2"))%>" size="30" class=text>  
                      (인증번호 받을 번호)                    
                    </td>
                </tr>                 
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>      
    <tr>
	<td align="right">
	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>		  	  	  
		<a href='javascript:Resend();'><img src="/acar/images/center/button_conf.gif" border="0" align=absmiddle></a>
	    <%}%>			
	    &nbsp;<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>				
	</td>
    </tr>              
    <%		}else{%>    
    <tr>
        <td class=h></td>
    </tr>      
    <tr>
	<td align="right">
	    &nbsp;<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>				
	</td>
    </tr>          		
    <%		}%>
    <%}%>
</table>
</form>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
	var fee = 0;
	<%if(am_ax_code.equals("") || am_ax_code.equals("null")){%>
		<%if(!sr_bean.getRent_st().equals("2")){%>       
			fee = (toInt(parseDigit(fm.am_good_s_amt.value))+toInt(parseDigit(fm.am_good_v_amt.value)))*0.037;
			fm.am_good_m_amt.value 	= parseDecimal(fee);
		<%}%>
	<%}%>
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
