<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.fee.*,acar.client.*"%>
<%@ page import="acar.cont.*, acar.ext.*, acar.car_register.*"%>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();

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
	
	String mode	 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	if(mode.equals("pay_view")){
		//계약승계 혹은 차종변경일때 승계계약 해지내용
		Hashtable cng_cont = af_db.getScdFeeCngContA(rent_mng_id, rent_l_cd);
		rent_l_cd = cng_cont.get("RENT_L_CD")+"";
	}	
		
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
		
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	
	
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
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body>
<form action='' name="form1" method='post'>
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
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <%if(mode.equals("pay_view")){ 
    
    	//계약승계 혹은 차종변경일때 원계약 해지내용
    	Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
    	
    	//고객정보
    	ClientBean client = al_db.getNewClient(base.getClient_id());
    %>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>변경전 원계약</span></td>
    </tr>
    <tr>
      <td class=line2></td>
    </tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding='0' width=100%>		
                <tr> 
                    <td class=title width=13%>변경구분</td>
                    <td width=20%>&nbsp;<%=begin.get("CLS_ST")%> <%=begin.get("RENT_L_CD")%></td>
                    <td class=title width=10%>변경일자</td>
                    <td width=20%>&nbsp;<%=begin.get("CLS_DT")%></td>
                    <%if(String.valueOf(begin.get("CLS_ST")).equals("계약승계")){%>
                    <td class=title width=10%>고객</td>
                    <td>&nbsp;<%=begin.get("FIRM_NM")%>&nbsp;<%=begin.get("CLIENT_NM")%></td>
                    <%}else if(String.valueOf(begin.get("CLS_ST")).equals("차종변경")){%>
                    <td class=title width=10%>자동차</td>
                    <td>&nbsp;<%=begin.get("CAR_NO")%>&nbsp;<%=begin.get("CAR_NM")%></td>
                    <%}%>
                </tr>
                <tr>
                  <td class=title>해지내역</td>
                  <td colspan="5">&nbsp;<%=begin.get("CLS_CAU")%></td>
                </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>    
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객</span>(<%=client.getClient_id()%>)</td>
    </tr>
    <tr>
      <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>상호/성명</td>
                    <td <%if(client.getClient_st().equals("2")){%>colspan='3'<%}%>>&nbsp;<%=client.getFirm_nm()%>
                    	(
                    	<%if(client.getClient_st().equals("2")){%>
                    	  <%=client.getSsn1()%>-<%=client.getSsn2().substring(0,1)%>
                    	<%}else{%>
                    	  <%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%>
                    	<%}%>
                    	)                     
                    </td>
                    <%if(!client.getClient_st().equals("2")){%>
                    <td width='10%' class='title'>대표자</td>
                    <td align='left'>&nbsp;<%=client.getClient_nm()%></td>
                    <%}%>
                </tr>
                <tr>
                    <td class='title'>연락처</td>
                    <td colspan='3'>&nbsp;
                    	<%if(!client.getClient_st().equals("2")){%>
                    	회사전화 : <%=AddUtil.phoneFormat(client.getO_tel())%>, 대표자핸드폰 : <%=AddUtil.phoneFormat(client.getM_tel())%><%if(!client.getClient_st().equals("1")){%>, 자택전화 : <%=AddUtil.phoneFormat(client.getH_tel())%><%}%>
                    	<%}else{%>
                    	고객휴대폰 : <%=AddUtil.phoneFormat(client.getM_tel())%>, 자택전화 : <%=AddUtil.phoneFormat(client.getH_tel())%>, 직장전화 : <%=AddUtil.phoneFormat(client.getO_tel())%>
                    	<%}%>
                    </td>
                </tr>                
            </table>
        </td>
    </tr>    
    <%} %>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle>&nbsp;계약승계</td>
    </tr>      
    <%	
    	
	ExtScdBean suc2 = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, "1", "5", "1");//기존 등록 여부 조회
	
	//원게약자 승계수수료 부담
	if(cont_etc.getRent_suc_commi_pay_st().equals("1") && cont_etc.getRent_suc_commi() != (suc2.getExt_s_amt()+suc2.getExt_v_amt()) ){
		suc2 = ae_db.getAGrtScd(rent_mng_id, cont_etc.getRent_suc_l_cd(), "1", "5", "1");//기존 등록 여부 조회
	}
    %>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=13%>계약승계일자</td>
                    <td>&nbsp;
    			    <input type="text" name="rent_suc_dt" value="<%=AddUtil.ChangeDate2(cont_etc.getRent_suc_dt())%>" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
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
    			    	<select name='rent_suc_exem_cau'>
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
						<input type="text" name="rent_suc_fee_tm_b_dt" value="<%=AddUtil.ChangeDate2(cont_etc.getRent_suc_fee_tm_b_dt())%>" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value)'> 
						
					</td>					
				</tr>						
				<tr>
                    <td class=title width=13%>보증금</td>
                    <td width=50%>&nbsp;
    			    	원계약
						<input type='text' size='11' name='suc_grt_suc_o_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원						
						, 승계계약
						<input type='text' size='11' name='suc_grt_suc_r_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원						
						
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
						<input type='text' size='11' name='suc_pp_suc_o_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getPp_suc_o_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원						
						, 승계계약
						<input type='text' size='11' name='suc_pp_suc_r_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getPp_suc_r_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원						
						
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
						<input type='text' size='11' name='suc_ifee_suc_o_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getIfee_suc_o_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원						
						, 승계계약
						<input type='text' size='11' name='suc_ifee_suc_r_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getIfee_suc_r_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원						
						
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
</table>
  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>