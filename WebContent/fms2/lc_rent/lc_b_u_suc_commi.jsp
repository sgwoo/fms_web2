<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.ext.*, acar.car_register.*, acar.user_mng.*"%>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String auth_rw 		= request.getParameter("auth_rw")  ==null?acar_br   :request.getParameter("auth_rw");
			
	String s_kd 		= request.getParameter("s_kd")	==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")	==null?"" :request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")	==null?"":request.getParameter("andor");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	
	String now_stat	 	= request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	String san_st	 	= request.getParameter("san_st")==null?"":request.getParameter("san_st");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
		
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//계약승계 혹은 차종변경일때 원계약 해지내용
	Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, cont_etc.getSuc_rent_st());
	int begin_fee_size = AddUtil.parseInt(cont_etc.getSuc_rent_st());
	int m_con_mon = 0;
	if(cont_etc.getN_mon().equals("") && cont_etc.getN_day().equals("")){
		for(int i=0; i<begin_fee_size-1; i++){
			ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
			m_con_mon = m_con_mon + AddUtil.parseInt(fees.getCon_mon());			
		}
	}	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--    
	//직원조회
	function User_search(nm, idx)
	{
		var fm = document.form1;
		
		var t_wd = '';
		if(idx == '')	t_wd = fm.user_nm.value;
		else  		t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=600,left=370,top=200');		
		fm.action = "/fms2/lc_rent/search_user.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&mode=EMP&nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();		
	}	
	
	//승계수수료스케줄만들기
	function make_suc_schedule(){
		var fm = document.form1;
				
		fm.idx.value = 'make_suc_schedule';
		
		if(confirm('승계수수료 스케줄을 생성하시겠습니까?')){	

			if(fm.suc_commi_est_dt.value=='') 	fm.suc_commi_est_dt.value = fm.rent_suc_dt.value;
			
			if(toInt(parseDigit(fm.suc_commi_s_amt.value)) == 0){
				fm.suc_commi_s_amt.value = sup_amt(toInt(parseDigit(fm.rent_suc_commi.value)));			
				fm.suc_commi_v_amt.value = toInt(parseDigit(fm.rent_suc_commi.value)) - toInt(fm.suc_commi_s_amt.value);
			}
		
			fm.action='lc_b_u_suc_commi_a.jsp';		
			//fm.target='i_no';
			fm.target='_self';
			fm.submit();
		}						
	}

	
	//수정
	function update(idx){
		
		var fm = document.form1;
		
		fm.idx.value = idx;

		if(confirm('수정하시겠습니까?')){	
			fm.action='lc_b_u_suc_commi_a.jsp';		
			//fm.target='i_no';
			fm.target='_self';
			fm.submit();
		}							
	}
	
	//청구금액 셋팅
	function set_reqamt(st){
		var fm = document.form1;	
		
		//미사용기간
		var n_mon = toInt(fm.n_mon.value);
		var n_day = toInt(fm.n_day.value);
		
		if(n_mon == 0 && n_day == 0){
			n_mon = <%=ext_fee.getCon_mon()%>-toInt(fm.r_mon.value)+<%=m_con_mon%>;
			n_day = 0;
			if(toInt(fm.r_day.value) >0){
				n_mon = n_mon-1;
				n_day = 30-toInt(fm.r_day.value);
			}
		}	
		
		if(st == 'pp_amt'){
			var mon_amt	= toInt(parseDigit(fm.suc_pp_suc_o_amt.value))/<%=ext_fee.getCon_mon()%>;
			var amt 	= Math.round( (mon_amt*n_mon) + (mon_amt/30*n_day) );
			fm.suc_pp_suc_r_amt.value	= parseDecimal(amt);
		}

		if(st == 'ifee_amt'){
			//기간계산
			var ifee_cnt = <%=ext_fee.getPere_r_mth()%>;
			var r_mon = <%=ext_fee.getCon_mon()%>-ifee_cnt;
			var r_day = 0;
			//미사용분이 있다.
			if(n_mon < ifee_cnt){				
				var mon_amt	= toInt(parseDigit(fm.suc_ifee_suc_o_amt.value))/ifee_cnt;
				var amt 	= Math.round( (mon_amt*n_mon) + (mon_amt/30*n_day) );
				fm.suc_ifee_suc_r_amt.value = parseDecimal(amt);				
			}
		}
		
		fm.n_mon.value = n_mon;
		fm.n_day.value = n_day;
	}			


//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body>
<form action='lc_b_u_suc_commi_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 			value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 			value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 			value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 			value='<%=end_dt%>'>    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="idx" 			value="">
  <input type='hidden' name="r_mon" 		value="<%=begin.get("R_MON")%>">
  <input type='hidden' name="r_day" 		value="<%=begin.get("R_DAY")%>">
  
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td colspan='2'>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>계약승계</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle>&nbsp;<%=cr_bean.getCar_no()%></td>
    </tr>      
    <%	
    	
	ExtScdBean suc2 = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, "1", "5", "1");//기존 등록 여부 조회
	
	
    %>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=13%>계약승계일자</td>
                    <td>&nbsp;
    			    <input type="text" name="rent_suc_dt" value="<%=AddUtil.ChangeDate2(cont_etc.getRent_suc_dt())%>" size="12" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                    <td class=title>승계시점주행거리</td>
                    <td>&nbsp;
    			    <input type="text" name="rent_suc_dist" value="<%=AddUtil.parseDecimal(cont_etc.getRent_suc_dist())%>" size="11" maxlength='10' class=num onBlur='javascript:this.value=parseDecimal(this.value)'>km
    	            </td>		        			    
    		</tr>	  
				<tr>
                    <td class=title width=13%>비고-승계루트</td>
                    <td colspan='3'>&nbsp;
    			    	<textarea name="rent_suc_route" cols="100" class="text" style="IME-MODE: active" rows="3"><%=cont_etc.getRent_suc_route()%></textarea> 						
					</td>					
				</tr>    		  
		<tr>			
					</td>	
                    <td class=title width=13%>계약승계수수료</td>
                    <td colspan='3'>&nbsp;
        			  <input type='text' size='11' name='rent_suc_commi' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getRent_suc_commi())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원
					  &nbsp;&nbsp;&nbsp;
					  <% 	if(suc2 == null || suc2.getRent_l_cd().equals("")){%> 
					  공급가 : <input type='text' size='8' name='suc_commi_s_amt' maxlength='10' class='num' value='0' onBlur='javascript:this.value=parseDecimal(this.value);'>원
					  부가세 : <input type='text' size='8' name='suc_commi_v_amt' maxlength='10' class='num' value='0' onBlur='javascript:this.value=parseDecimal(this.value);'>원					  
					  &nbsp;&nbsp;&nbsp;					  
					  <% 		if(AddUtil.parseInt(cont_etc.getRent_suc_dt()) >= 20100520){%> 	
					  <br>&nbsp;
						(스케줄 없음 -> 
					    <!--<input type="checkbox" name="suc_tax_req" value="Y"> 계산서 발행, -->
						입금예정일 : <input type='text' name='suc_commi_est_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'>
						<a href="javascript:make_suc_schedule();"><img src=/acar/images/center/button_sch_cre.gif  align=absmiddle border="0"></a> )
					  <%		}%>
					  <%	}else{%>
					  공급가 : <input type='text' size='8' name='suc_commi_s_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(suc2.getExt_s_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원
					  부가세 : <input type='text' size='8' name='suc_commi_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(suc2.getExt_v_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원					  
					  &nbsp;&nbsp;&nbsp;
					  <%	}%>				   				   
				   &nbsp;&nbsp;&nbsp;
				   
           <% int car_amt = car.getCar_cs_amt()+car.getOpt_cs_amt()+car.getClr_cs_amt()+car.getCar_cv_amt()+car.getOpt_cv_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt();%>
				   
           <%if(AddUtil.parseInt(base.getReg_dt()) < 20170220){//20170220 이전 0.7*1.1%>
               * 정상승계수수료 : <%=AddUtil.parseDecimal(car_amt*0.7/100*1.1)%>원	
               (신차소비자가 <%=AddUtil.parseDecimal(car_amt)%>원*0.7%*1.1, 부가세포함)                        
           <%}else{%>   
               * 정상승계수수료 : <%=AddUtil.parseDecimal(car_amt*0.8/100)%>원	                     
               (신차소비자가 <%=AddUtil.parseDecimal(car_amt)%>원의 0.8%, 부가세포함)
           <%}%> 
					  
					  </td>
                    
                </tr>
                
				<tr>
                    <td class=title width=13%>승계수수료감면사유</td>
                    <td colspan='3'>&nbsp;
    			    	<select name='rent_suc_exem_cau' >
                                      <option value="">선택</option>
                                      <option value="1" <%if(cont_etc.getRent_suc_exem_cau().equals("1")){%>selected<%}%>>법인 전환 (전액감면)</option>
                                      <option value="2" <%if(cont_etc.getRent_suc_exem_cau().equals("2")){%>selected<%}%>>이용자 동일 (50%감면)</option>
                                      <option value="3" <%if(cont_etc.getRent_suc_exem_cau().equals("3")){%>selected<%}%>>기존고객과 특수관계</option>
                                      <%if(cont_etc.getRent_suc_exem_cau().equals("5")){%>
                                      <option value="5" <%if(cont_etc.getRent_suc_exem_cau().equals("5")){%>selected<%}%>>에이전트 승계수당과 상계</option>
                                      <%}%>
                                      <option value="4" <%if(!cont_etc.getRent_suc_exem_cau().equals("") && !cont_etc.getRent_suc_exem_cau().equals("1") && !cont_etc.getRent_suc_exem_cau().equals("2") && !cont_etc.getRent_suc_exem_cau().equals("3") && !cont_etc.getRent_suc_exem_cau().equals("5")){%>selected<%}%>>기타 (내용 직접 입력)</option>
                      </select>       
                      <%if(cont_etc.getRent_suc_exem_cau().equals("") || (cont_etc.getRent_suc_exem_cau().equals("1") && !cont_etc.getRent_suc_exem_cau().equals("2") && !cont_etc.getRent_suc_exem_cau().equals("3") && !cont_etc.getRent_suc_exem_cau().equals("5"))){%>                      
                      <input type='text' name='rent_suc_exem_cau_sub' size='30' class='text' value="<%=cont_etc.getRent_suc_exem_cau()%>">    					
                      <%}else{%>
                      <input type='hidden' name="rent_suc_exem_cau_sub"		value="<%=cont_etc.getRent_suc_exem_cau()%>">
                      <%}%>
                      <%if(cont_etc.getRent_suc_exem_cau().equals("5")){%>
                      <br>&nbsp;
                       ※ 에이전트 승계수당과 상계 : 정상승계수수료 11만원(VAT포함) 이하는 승계수수료 전액면제, 정상승계수수료 11만원(VAT포함) 이상은 승계수수료 11만원(VAT포함)이 감액됩니다.
                      <%}%>
					</td>					
                </tr>
                
				<tr>					
					<td class=title width=13%>수수료감면 결재자</td>
					<td colspan='3'>&nbsp;
					        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(cont_etc.getRent_suc_exem_id(), "USER")%>" size="12"> 
			                        <input type="hidden" name="rent_suc_exem_id" value="<%=cont_etc.getRent_suc_exem_id()%>">			                        
			                        <a href="javascript:User_search('rent_suc_exem_id', '');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>						                        			                        
					</td>					
				</tr>	
		
				<tr>
                    <td class=title width=13%>비용부담자</td>
                    <td colspan='3'>&nbsp;
    			    	<select name='rent_suc_commi_pay_st'>
                           <option value="">선택</option>
                           <option value="1" <%if(cont_etc.getRent_suc_commi_pay_st().equals("1")){%>selected<%}%>>원계약자</option>
                           <option value="2" <%if(cont_etc.getRent_suc_commi_pay_st().equals("2")){%>selected<%}%>>계약승계자</option>
                        </select>
					
					</td>					
				</tr>
				<tr>
                    <td class=title width=13%>스케줄이관회차</td>
                    <td width=50%>&nbsp;
    			    	<input type='text' size='2' name='rent_suc_fee_tm' maxlength='12' class='text' value='<%=cont_etc.getRent_suc_fee_tm()%>' >회차						
					</td>					
					<td class=title width=10%>일자계산기준일</td>
					<td>&nbsp;
						<input type="text" name="rent_suc_fee_tm_b_dt" value="<%=AddUtil.ChangeDate2(cont_etc.getRent_suc_fee_tm_b_dt())%>" size="12" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value)'> 
						
					</td>					
				</tr>					
				<tr>
                    <td class=title width=13%>보증금</td>
                    <td width=50%>&nbsp;
    			    	원계약
						<input type='text' size='11' name='suc_grt_suc_o_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);' readonly>원						
						, 승계계약
						<input type='text' size='11' name='suc_grt_suc_r_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);' <%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)||nm_db.getWorkAuthUser("계약변경관리",ck_acar_id)) {%><%}else{ %>readonly<%}%>>원						
						
					</td>					
					<td class=title width=13%>보증금승계여부</td>
					<td>&nbsp;
						<select name='rent_suc_grt_yn'> 
                           <option value="">선택</option>
                           <option value="0" <%if(cont_etc.getRent_suc_grt_yn().equals("0")){%>selected<%}%>>승계</option>
                           <option value="1" <%if(cont_etc.getRent_suc_grt_yn().equals("1")){%>selected<%}%>>별도</option>
                        </select>
					</td>					
				</tr>	
				<tr>
                    <td class=title width=13%>선납금</td>
                    <td width=50%>&nbsp;
    			    	원계약
						<input type='text' size='11' name='suc_pp_suc_o_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getPp_suc_o_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);' readonly>원						
						, 승계계약
						<input type='text' size='11' name='suc_pp_suc_r_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getPp_suc_r_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);' <%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)||nm_db.getWorkAuthUser("계약변경관리",ck_acar_id)) {%><%}else{ %>readonly<%}%>>원
						
						<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)||nm_db.getWorkAuthUser("계약변경관리",ck_acar_id)) {%>
						<span class="b"><a href="javascript:set_reqamt('pp_amt')" onMouseOver="window.status=''; return true" title="선납금 계산합니다."><img src="/acar/images/center/button_in_cal.gif" align="absmiddle" border="0"></a></span>
						<%} %>							
						
					</td>					
					<td class=title width=13%>선납금승계여부</td>
					<td>&nbsp;
						<select name='rent_suc_pp_yn'> 
                           <option value="">선택</option>
                           <option value="0" <%if(cont_etc.getRent_suc_pp_yn().equals("0")){%>selected<%}%>>승계</option>
                           <option value="1" <%if(cont_etc.getRent_suc_pp_yn().equals("1")){%>selected<%}%>>별도</option>
                        </select>
					</td>					
				</tr>	
				<tr>
                    <td class=title width=13%>개시대여료</td>
                    <td width=50%>&nbsp;
    			    	원계약
						<input type='text' size='11' name='suc_ifee_suc_o_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getIfee_suc_o_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);' readonly>원						
						, 승계계약
						<input type='text' size='11' name='suc_ifee_suc_r_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getIfee_suc_r_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);' <%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)||nm_db.getWorkAuthUser("계약변경관리",ck_acar_id)) {%><%}else{ %>readonly<%}%>>원
						
						<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)||nm_db.getWorkAuthUser("계약변경관리",ck_acar_id)) {%>
						<span class="b"><a href="javascript:set_reqamt('ifee_amt')" onMouseOver="window.status=''; return true" title="선납금 계산합니다."><img src="/acar/images/center/button_in_cal.gif" align="absmiddle" border="0"></a></span>
						<%} %>						
						
					</td>					
					<td class=title width=13%>개시대여료승계여부</td>
					<td>&nbsp;
						<select name='rent_suc_ifee_yn'> 
                           <option value="">선택</option>
                           <option value="0" <%if(cont_etc.getRent_suc_ifee_yn().equals("0")){%>selected<%}%>>승계</option>
                           <option value="1" <%if(cont_etc.getRent_suc_ifee_yn().equals("1")){%>selected<%}%>>별도</option>
                        </select>
					</td>					
				</tr>	
				<tr>
                    <td class=title width=13%>미사용기간</td>
                    <td colspan='3'>&nbsp;
    			    	<input type='text' size='3' name='n_mon' maxlength='3' class='num' value='<%=cont_etc.getN_mon()%>'>개월						
						<input type='text' size='3' name='n_day' maxlength='3' class='num' value='<%=cont_etc.getN_day()%>'>일	
										
					</td>					
				</tr>											
            </table>
	    </td>
    </tr>
	<tr>
	    <td align="right"><%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('suc_commi')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%>
	    	&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
	    	</td>
	<tr>
	<tr>
        <td class=h></td>
    </tr>  
    <tr>
	    <td>※ 선납금,개시대여료 승계분 계산식 : (원계약금액/원계약대여개월수)*미사용기간</td>
	<tr>
</table>
  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>