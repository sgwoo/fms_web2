<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.con_tax.*, acar.insur.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	
	//2. 자동차--------------------------
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	
	//3. 대여-----------------------------
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//영업소 담당자
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	
	from_page = "/fms2/lc_rent/lc_c_c_fee.jsp";
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//선수금 합계
	function sum_pp_amt(){
		var fm = document.form1;
		
		fm.tot_pp_s_amt.value = parseDecimal(toInt(parseDigit(fm.grt_s_amt.value)) + toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.ifee_s_amt.value)));
		fm.tot_pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_v_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)) );
		fm.tot_pp_amt.value = parseDecimal(toInt(parseDigit(fm.tot_pp_s_amt.value)) + toInt(parseDigit(fm.tot_pp_v_amt.value)) );		
	
	}
	
	//신용평가 보기(이력)
	function view_eval(){
		var fm = document.form1;
		window.open("/fms2/lc_rent/view_eval.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_c_c_client.jsp&client_id="+fm.client_id.value+"&rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value, "SEARCH_EVAL", "left=50, top=50, width=850, height=600");
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
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>">
  <input type='hidden' name="opt"				value="<%=car.getOpt()%>">
  <input type='hidden' name="car_st" 			value="<%=base.getCar_st()%>">
  <input type='hidden' name="purc_gu" 			value="<%=car.getPurc_gu()%>">  
  <input type='hidden' name="pay_st" 			value="<%=car.getPay_st()%>">    
  <input type='hidden' name="rent_way" 			value="<%=fee.getRent_way()%>">  
  <input type='hidden' name="s_dc1_re" 			value="<%=car.getS_dc1_re()%>">
  <input type='hidden' name="s_dc1_yn" 			value="<%=car.getS_dc1_yn()%>">
  <input type='hidden' name="s_dc1_amt"			value="<%=car.getS_dc1_amt()%>">
  <input type='hidden' name="s_dc2_re" 			value="<%=car.getS_dc2_re()%>">
  <input type='hidden' name="s_dc2_yn" 			value="<%=car.getS_dc2_yn()%>">
  <input type='hidden' name="s_dc2_amt"			value="<%=car.getS_dc2_amt()%>">
  <input type='hidden' name="s_dc3_re" 			value="<%=car.getS_dc3_re()%>">
  <input type='hidden' name="s_dc3_yn" 			value="<%=car.getS_dc3_yn()%>">
  <input type='hidden' name="s_dc3_amt"			value="<%=car.getS_dc3_amt()%>">
  <input type='hidden' name="s_dc1_re_etc"		value="<%=car.getS_dc1_re_etc()%>">  
  <input type='hidden' name="s_dc2_re_etc"		value="<%=car.getS_dc2_re_etc()%>">  
  <input type='hidden' name="s_dc3_re_etc"		value="<%=car.getS_dc3_re_etc()%>">      
  <input type='hidden' name="s_dc1_per"			value="<%=car.getS_dc1_per()%>">  
  <input type='hidden' name="s_dc2_per"			value="<%=car.getS_dc2_per()%>">  
  <input type='hidden' name="s_dc3_per"			value="<%=car.getS_dc3_per()%>">         
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">  
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">       
  <input type='hidden' name='client_id' 		value='<%=base.getClient_id()%>'>    
  <input type='hidden' name='site_id' 			value='<%=base.getR_site()%>'>
  <input type='hidden' name="car_mng_id" 		value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="dec_gr"			value="<%=cont_etc.getDec_gr()%>"> 
  <input type='hidden' name="o_1"				value="">
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="t_dc_amt"			value="">  
        
  <input type='hidden' name="car_cs_amt"		value="<%=car.getCar_cs_amt()%>">
  <input type='hidden' name="car_cv_amt"		value="<%=car.getCar_cv_amt()%>">
  <input type='hidden' name="car_c_amt"			value="<%=car.getCar_cs_amt()+car.getCar_cv_amt()%>">  
  <input type='hidden' name="car_fs_amt"		value="<%=car.getCar_fs_amt()%>">
  <input type='hidden' name="car_fv_amt"		value="<%=car.getCar_fv_amt()%>">
  <input type='hidden' name="car_f_amt"			value="<%=car.getCar_fs_amt()+car.getCar_fv_amt()%>">    
  <input type='hidden' name="opt_cs_amt"		value="<%=car.getOpt_cs_amt()%>">
  <input type='hidden' name="opt_cv_amt"		value="<%=car.getOpt_cv_amt()%>">
  <input type='hidden' name="opt_c_amt"			value="<%=car.getOpt_cs_amt()+car.getOpt_cv_amt()%>">  
  <input type='hidden' name="sd_cs_amt"			value="<%=car.getSd_cs_amt()%>">
  <input type='hidden' name="sd_cv_amt"			value="<%=car.getSd_cv_amt()%>">
  <input type='hidden' name="sd_c_amt"			value="<%=car.getSd_cs_amt()+car.getSd_cv_amt()%>">  
  <input type='hidden' name="col_cs_amt"		value="<%=car.getClr_cs_amt()%>">
  <input type='hidden' name="col_cv_amt"		value="<%=car.getClr_cv_amt()%>">
  <input type='hidden' name="col_c_amt"			value="<%=car.getClr_cs_amt()+car.getClr_cv_amt()%>">  
  <input type='hidden' name="dc_cs_amt"			value="<%=car.getDc_cs_amt()%>">
  <input type='hidden' name="dc_cv_amt"			value="<%=car.getDc_cv_amt()%>">
  <input type='hidden' name="dc_c_amt"			value="<%=car.getDc_cs_amt()+car.getDc_cv_amt()%>">  
      
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여요금</font></td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
    		<%if(rent_st.equals("1")){%>
                <tr>
                    <td width="13%" align="center" class=title>계약일자</td>
                    <td width="20%">&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td width="10%" align="center" class=title>계약담당자</td>
                    <td colspan="3">&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
                </tr>
    		  <%}else{%>
                <tr>
                    <td width="13%" align="center" class=title>계약일자</td>
                    <td width="20%">&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_dt())%></td>
                    <td width="10%" align="center" class=title>계약담당자</td>
                    <td colspan="3">&nbsp;<%=c_db.getNameById(fee.getExt_agnt(),"USER")%></td>
                </tr>		  
    		  <%}%>
                <tr>
                    <td width="13%" align="center" class=title>이용기간</td>
                    <td width="20%">&nbsp;<%=fee.getCon_mon()%>개월</td>
                    <td width="10%" align="center" class=title>대여개시일</td>
                    <td width="20%">&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%></td>
                    <td width="10%" align="center" class=title>대여만료일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_end_dt())%></td>
                </tr>
                <tr>
                    <td width="13%" align="center" class=title>신용등급</td>
                    <td width="20%">&nbsp;<%if(cont_etc.getDec_gr().equals("")) cont_etc.setDec_gr(base.getSpr_kd());%>
        			  <% if(cont_etc.getDec_gr().equals("3")) out.print("신설법인"); 	%>
                      <% if(cont_etc.getDec_gr().equals("0")) out.print("일반고객"); 	%>
                      <% if(cont_etc.getDec_gr().equals("1")) out.print("우량기업"); 	%>
                      <% if(cont_etc.getDec_gr().equals("2")) out.print("초우량기업");  %>
        			  <a href="javascript:view_eval()"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
                    <td width="10%" align="center" class=title>대표연대보증</td>
                    <td colspan="3">&nbsp;<%if(cont_etc.getClient_guar_st().equals("1")){%>입보<%}else if(cont_etc.getClient_guar_st().equals("2")){%>면제<%}%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td colspan="2" class='title'>구분</td>
                    <td class='title' width='11%'>공급가</td>
                    <td class='title' width='11%'>부가세</td>
                    <td class='title' width='14%'>합계</td>
                    <td class='title' width='4%'>입금</td>			
                    <td width="27%" class='title'>계약조건</td>
                    <td class='title' width='20%'>정상조건</td>
                </tr>
                <tr>
                    <td width="3%" rowspan="5" class='title'>선<br>
                      수</td>
                    <td width="10%" class='title'>보증금</td>
                    <td align='center'><input type='text' size='10' maxlength='10' name='grt_s_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='10' maxlength='10' name='grt_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원 </td>
                    <td align='center'>-</td>
                    <td align="center">차가의
                        <input type='text' size='4' name='gur_p_per' class='whitenum' value='<%=fee.getGur_p_per()%>' readonly>
        				  % </td>
                    <td align='center'>-<input type='hidden' name='gur_per' value=''><!--차가 <font color="#FF0000">렌트
    			    <input type='text' size='3' name='gur_per' class='whitenum' value='' readonly>%</font> 이상--></td>
                </tr>
                <tr>
                    <td class='title'>선납금</td>
                    <td align="center"><input type='text' size='10' name='pp_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getPp_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='9' name='pp_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='pp_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getPp_s_amt()+fee.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원 </td>
                    <td align='center'>-</td>
                    <td align="center">차가의
                        <input type='text' size='4' name='pere_r_per' class='whitenum' value='<%=fee.getPere_r_per()%>' readonly>
        				  % </td>
                    <td align='center'>-<input type='hidden' name='pere_per' value=''><!--차가의 <font color="#FF0000">
        			    <input type='text' size='3' name='pere_per' class='whitenum' value='' readonly>%</font> 이상--></td>
                </tr>
                <tr>
                    <td class='title'>개시대여료</td>
                    <td align="center"><input type='text' size='10' name='ifee_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getIfee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='9' name='ifee_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ifee_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원 </td>
                    <td align='center'>-</td>
                    <td align="center">마지막
                        <input type='text' size='2' name='pere_r_mth' class='whitenum' value='<%=fee.getPere_r_mth()%>' readonly>
        				  개월치 대여료 </td>
                    <td align='center'>-<input type='hidden' name='pere_mth' value=''></td>
                </tr>
                <tr>
                    <td class='title'>합계</td>
                    <td align="center"><input type='text' size='10' name='tot_pp_s_amt' maxlength='11' class='whitenum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='9' name='tot_pp_v_amt' maxlength='10' class='whitenum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='tot_pp_amt' maxlength='11' class='whitenum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td align='center'>-</td>
                    <td align="center">입금예정일 :
                          <input type='text' size='11' name='pp_est_dt' maxlength='10' class="whitetext" value='<%=AddUtil.ChangeDate2(fee.getPp_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align='center'>&nbsp;</td>
                </tr>
                <tr>
                    <td class='title'>총채권확보</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>						
                    <td align='center'>-</td>									
                    <td align='center'><input type='text' size='4' name='credit_r_per' class='whitenum' value='<%=fee.getCredit_r_per()%>' readonly>%
        			<input type='text' size='10' name='credit_r_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getCredit_r_amt())%>' readonly>원(보증보험포함)</td>
                    <td align='center'>
        			<%if(rent_st.equals("1")){%>
        			<input type='text' size='4' name='credit_per' class='whitenum' value='<%=fee.getCredit_per()%>' readonly>%
        			<input type='text' size='10' name='credit_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getCredit_r_amt())%>' readonly>원
        			<%}else{%>
        			<input type='hidden' name="credit_per"			value="">
        			<input type='hidden' name="credit_amt"			value="">
        			<%}%>			
        			</td>
                </tr>
                <tr>
                    <td rowspan="3" class='title'>잔<br>
                      가</td>
                    <td class='title'>최대잔가</td>
                    <td align="center"><input type='text' size='10' name='ja_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getJa_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='9' name='ja_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ja_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getJa_s_amt()+fee.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td align='center'>-</td>
                    <td align='center'>
        			  최대잔가율:차가의
                          <input type='text' size='4' name='max_ja' maxlength='10' class='whitenum' value='<%=fee.getMax_ja()%>' readonly>
                          %</td>
                    <td align='center'>-</td>
                </tr>
                <tr>
                    <td class='title'>매입옵션</td>
                    <td align="center"><input type='text' size='10' name='opt_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getOpt_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='9' name='opt_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='opt_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getOpt_s_amt()+fee.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
                        <input type='text' size='4' name='opt_per' class='whitenum' value='<%=fee.getOpt_per()%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  % </td>
                    <td align='center'><%String opt_chk = fee.getOpt_chk();%><%if(opt_chk.equals("0")){%>없음<%}else if(opt_chk.equals("1")){%>있음<%}%></td>
                </tr>
                <tr>
                    <td class='title'>적용잔가</td>
                    <td align="center"><input type='text' size='10' name='ja_r_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getJa_r_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='9' name='ja_r_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ja_r_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getJa_r_s_amt()+fee.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td align='center'>-</td>				  
                    <td align="center">차가의
        			  <input type='text' size='4' name='app_ja' maxlength='10' class="whitenum" value='<%=fee.getApp_ja()%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        			  % </td>
                    <td align='center'>-</td>
                </tr>		  
                <tr>
                    <td rowspan="2" class='title'>대<br>
                      여<br>
                      료</td>
                    <td class='title'>계약요금</td>
                    <td align="center" ><input type='text' size='10'  name='fee_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center" ><input type='text' size='9'  name='fee_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center' ><input type='text' size='10'  name='fee_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원 </td>
                    <td align='center'>-</td>
                    <td align="center">DC율:
                      <input type='text' size='4' name='dc_ra' maxlength='10' class="whitenum" value='<%=fee.getDc_ra()%>'>
                    </font>%</span></td>
                    <td align='center'>-</td>
                </tr>
                <tr>
                    <td class='title'>정상요금</td>
                    <td align="center" ><input type='text' size='10' name='inv_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center" ><input type='text' size='9' name='inv_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center' ><input type='text' size='10' maxlength='10' name='inv_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getInv_s_amt()+fee.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원 </td>
                    <td align='center'>-</td>
                    <td align="center">기준일자
                      <input type='text' size='11' name='bas_dt' maxlength='10' class="whitetext" value='<%=AddUtil.ChangeDate2(fee.getBas_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align='center'>&nbsp;
                    </td>
                </tr>
                <tr>
                    <td rowspan="2" class='title'>기<br>
                      타</td>		  
                    <td class='title'>영업수당</td>
                    <td colspan="2" align="center">영업수당 기준차가</td>
                    <td align='center'><input type='text' size='11' name='commi_car_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>' onBlur="javascript:setCommi()">
        				  원</td>
                    <td align='center'>-</td>				  
                    <td align="center">
                        <input type='text' name="comm_r_rt" value='<%=emp1.getComm_r_rt()%>' size="4" class='whitenum' onBlur='javascript:setCommi()'>
        		      %</td>
                    <td align='center'>
        				<input type='text' name="comm_rt" value='<%=emp1.getComm_rt()%>' size="4" class='whitenum'>
        			  %</td>
                </tr>		  
                <tr>
                    <td class='title' style="font-size : 8pt;">중도해지위약율</td>
                    <td colspan="2" align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'><font color="#FF0000">
        				<input type='text' size='3' name='cls_per' maxlength='10' class='whitenum' value='<%=fee.getCls_per()%>'>%</font></span></td>
                    <td align="center">잔여기간 대여료의
                        <input type='text' size='3' name='cls_r_per' maxlength='10'  class='whitenum' value='<%=fee.getCls_per()%>'>
        				  %</td>
                </tr>
                <tr>
                    <td colspan="2" class='title'>결재자</td>
                    <td colspan="6">&nbsp;<%=c_db.getNameById(fee.getFee_sac_id(),"USER")%></td>
                </tr>
                <tr>
                    <td colspan="2" class='title'>비고</td>
                    <td colspan="6">&nbsp;<%=HtmlUtil.htmlBR(fee.getFee_cdt())%></td>
                </tr>
            </table>		
	    </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>납입방법</span></td>
    </tr>	
	<%if(rent_st.equals("1")){%>
	<tr>
	    <td class=line2></td>
	</tr>				
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="3%" rowspan="5" class='title'>대<br>여<br>료<br>납<br>입<br>방<br>법</td>
                    <td width="10%" class='title'>납입횟수</td>
                    <td width="20%">&nbsp;<%=fee.getFee_pay_tm()%>회 </td>
                    <td width="10%" class='title'>납입일자</td>
                    <td width="20%">&nbsp;<%if(fee.getFee_est_day().equals("98")){%>대여개시일<%}else{%>매월<%if(fee.getFee_est_day().equals("99")){%> 말일 <%}else{%><%=fee.getFee_est_day()%>일<%}%><%}%></td>
                    <td width="10%" class='title'>납입기간</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fee.getFee_pay_start_dt())%>~<%=AddUtil.ChangeDate2(fee.getFee_pay_end_dt())%></td>
                </tr>		  		  		  
                <tr>
                    <td width="10%" class='title'>수금구분</td>
                    <td width="20%">&nbsp;<%String fee_sh = fee.getFee_sh();%><%if(fee_sh.equals("0")){%>후불<%}else if(fee_sh.equals("1")){%>선불<%}%></td>
                    <td width="10%" class='title'>납부방법</td>
                    <td colspan="3">&nbsp;<%String fee_pay_st = fee.getFee_sh();%><%if(fee_pay_st.equals("1")){%>자동이체<%}else if(fee_pay_st.equals("2")){%>무통장입금<%}else if(fee_pay_st.equals("3")){%>지로<%}else if(fee_pay_st.equals("4")){%>수금<%}else if(fee_pay_st.equals("5")){%>기타<%}%></td>
                </tr>		  		  		  
                <tr>
                    <td class='title'>거치여부</td>
                    <td colspan="3">&nbsp;<%String def_st = fee.getDef_st();%><%if(def_st.equals("N")){%>없음<%}else if(def_st.equals("Y")){%>없음<%}%>
                    &nbsp;&nbsp;&nbsp;&nbsp;사유 : <%=fee.getDef_remark()%></td>
                    <td class='title'>결재자</td>
                    <td>&nbsp;<%=c_db.getNameById(fee.getDef_sac_id(),"USER")%></td>
                </tr>
                <tr>
                    <td class='title'>자동이체</td>
                    <td colspan="5">
                        <table width="500" border="0" cellpadding="0">
        			        <tr>
                			    <td>&nbsp;계좌번호 : 
                			      <%=cms.getCms_acc_no()%>
                			      (은행:<%=c_db.getNameById(cms.getCms_bank(), "BANK")%>) </td>
        			        </tr>
        			        <tr>
                			    <td>&nbsp;예 금 주 :&nbsp;<%=cms.getCms_dep_nm()%>			      
                				  &nbsp;&nbsp;
                				  / 결제일자 : 매월 <%=cms.getCms_day()%>일</td>
        			        </tr>
        			    </table>
        			</td>
                </tr>
                <tr>
                    <td class='title'>통장입금</td>
                    <td colspan="5">&nbsp;<%=c_db.getNameById(fee.getFee_bank(), "BANK")%></td>
                </tr>
            </table>
        </td>
    </tr>	
	<%}else{%>		
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>납입횟수</td>
                    <td width="20%">&nbsp;<%=fee.getFee_pay_tm()%>회 </td>
                    <td width="10%" class='title'>납입일자</td>
                    <td width="20%">&nbsp;<%if(fee.getFee_est_day().equals("98")){%>대여개시일<%}else{%>매월<%if(fee.getFee_est_day().equals("99")){%> 말일 <%}else{%><%=fee.getFee_est_day()%>일<%}%><%}%></td>
                    <td width="10%" class='title'>납입기간</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fee.getFee_pay_start_dt())%>~<%=AddUtil.ChangeDate2(fee.getFee_pay_end_dt())%></td>
                </tr>		  		  		  
            </table>
        </td>
    </tr>	
	<%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	sum_pp_amt();	
//-->
</script>
</body>
</html>
