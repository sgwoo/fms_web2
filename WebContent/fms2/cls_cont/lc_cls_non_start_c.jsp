<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.insur.*, acar.fee.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getUse_yn().equals("N"))	return;
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//1. 고객 ---------------------------
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//3. 대여-----------------------------
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//출고지연대차
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	//출고지연대차 리스트
	Vector ta_vt = a_db.getTaechaList(rent_mng_id, rent_l_cd);
	int ta_vt_size = ta_vt.size();	
	
	Vector ht = af_db.getFeeScdCng(rent_l_cd, Integer.toString(fee_size), "");
	int ht_size = ht.size();
	
	FeeScdBean fee_scd = new FeeScdBean();
	
	
	
	//대여스케줄중 연체리스트
	Vector v_fee_scd = af_db.getFeeScdPrint(rent_l_cd, "");
	int fee_scd_size = v_fee_scd.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//기존차 조회
	function car_search()
	{
		var fm = document.form1;
		window.open("search_ext_car.jsp", "EXT_CAR", "left=100, top=100, width=600, height=500, resizable=yes, scrollbars=yes, status=yes");
	}	

	//고객 보기
	function view_client(client_id)
	{
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//지점/현장 보기
	function view_site(client_id, site_id)
	{
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id+"&site_id="+site_id, "CLIENT_SITE", "left=100, top=100, width=620, height=450, resizable=yes, scrollbars=yes, status=yes");
	}			

	//자동차등록정보 보기
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, resizable=yes, scrollbars=yes, status=yes");
	}		
	
	//대여요금
	function view_fee(rent_mng_id, rent_l_cd, rent_st)
	{		
		window.open("/fms2/lc_rent/view_fee.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&cmd=view", "VIEW_FEE", "left=100, top=100, width=850, height=650, resizable=yes, scrollbars=yes, status=yes");
	}		
	
	//변경된 해지일자로 다시 계산
	function set_day(){
		var fm = document.form1;	
		if(fm.cls_dt.value == ''){ 	alert('해지일자를 입력하십시오'); 	fm.cls_dt.focus(); 	return;	}
		if(!isDate(fm.cls_dt.value)){ fm.cls_dt.focus(); return;	}					
		fm.action='/acar/cls_con/cls_settle_nodisplay.jsp';		
		fm.target='i_no';
		fm.submit();
	}
	
	function save(){
		var fm = document.form1;
		if(fm.cls_dt.value == '')			{ alert('해지일자를 입력하십시오.');					return;}		
		
		if(toInt(parseDigit(fm.t_fee_amt.value)) >0){
			fm.t_fee_s_amt.value 	= sup_amt(toInt(parseDigit(fm.t_fee_amt.value)));
			fm.t_fee_v_amt.value 	= toInt(parseDigit(fm.t_fee_amt.value)) - toInt(fm.t_fee_s_amt.value);
		}
		
		if(confirm('등록하시겠습니까?')){		
			fm.action='lc_cls_non_start_c_a.jsp';
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
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
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="m_id" 				value="<%=rent_mng_id%>">
  <input type='hidden' name="l_cd" 				value="<%=rent_l_cd%>">  
  <input type='hidden' name="fee_size"			value="<%=fee_size%>">   
  <input type='hidden' name="car_mng_id" 		value="<%=base.getCar_mng_id()%>">   
  <input type='hidden' name="from_page" 		value="/fms2/cls_cont/lc_cls_non_start_frame.jsp">
  <input type='hidden' name='con_cd3' value=''>
  <input type='hidden' name='con_cd4' value=''>  
  <input type='hidden' name='t_fee_s_amt' value=''>
  <input type='hidden' name='t_fee_v_amt' value=''>
  <input type='hidden' name='t_fee_amt'   value='<%=AddUtil.parseDecimal(taecha.getRent_fee())%>'>
  <input type='hidden' name="firm_nm" 	  value="<%=client.getFirm_nm()%>">     
  <input type='hidden' name="fee_scd_size" value="<%=fee_scd_size%>">       
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>계약번호</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>영업지점</td>
                    <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
                    <td class=title width=10%>관리지점</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
                </tr>
                <tr> 
                    <td class=title>최초영업자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
                    <td class=title>영업대리인</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
                    <td class=title>영업담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>
                <tr>
                    <td class=title>계약일자</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td class=title>계약구분</td>
                    <td>&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>신규<%}else if(rent_st.equals("3")){%>대차<%}else if(rent_st.equals("4")){%>증차<%}%></td>
                    <td class=title>영업구분</td>
                    <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>인터넷<%}else if(bus_st.equals("2")){%>영업사원<%}else if(bus_st.equals("3")){%>업체소개<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>전화상담<%}else if(bus_st.equals("6")){%>기존업체<%}else if(bus_st.equals("7")){%>에이전트<%}else if(bus_st.equals("8")){%>모바일<%}%></td>
                </tr>
                <tr> 
                    <td class=title>차량구분</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}%></td>
                    <td class=title>용도구분</td>
                    <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("5")){%>업무대여<%}%></td>
                    <td class=title>관리구분</td>
                    <td>&nbsp;<%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}%></td>
                </tr>
                <tr>
                    <td class=title>상호</td>
                    <td>&nbsp;<a href="javascript:view_client('<%=client.getClient_id()%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=client.getFirm_nm()%></a></td>
                    <td class=title>대표자</td>
                    <td>&nbsp;<%=client.getClient_nm()%></td>
                    <td class=title>지점/현장</td>
                    <td>&nbsp;<a href="javascript:view_site('<%=client.getClient_id()%>','<%=base.getR_site()%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=site.getR_site()%></a></td>
                </tr>
                <tr>
                    <td class=title>차량번호</td>
                    <td width=20%>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=cr_bean.getCar_no()%></a></td>
                    <td class=title width=10%>차명</td>
                    <td colspan="3" >&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;
        			<font color="#999999">(차종코드:<%=cm_bean.getJg_code()%>)</font>
    			    </td>
                </tr>		  
            </table>
	    </td>
    </tr>
	<tr>
	    <td align="right"></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
	    <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
                <tr>
                    <td style="font-size : 8pt;" width="3%" class=title rowspan="2">연번</td>
                    <td style="font-size : 8pt;" width="10%" class=title rowspan="2">계약일자</td>
                    <td style="font-size : 8pt;" width="6%" class=title rowspan="2">이용기간</td>
                    <td style="font-size : 8pt;" width="8%" class=title rowspan="2">대여개시일</td>
                    <td style="font-size : 8pt;" width="8%" class=title rowspan="2">대여만료일</td>
                    <td style="font-size : 8pt;" width="7%" class=title rowspan="2">계약담당</td>
                    <td style="font-size : 8pt;" width="9%" class=title rowspan="2">월대여료</td>
                    <td style="font-size : 8pt;" class=title colspan="2">보증금</td>
                    <td style="font-size : 8pt;" width="10%" class=title rowspan="2">선납금</td>
                    <td style="font-size : 8pt;" class=title colspan="2">개시대여료</td>
                    <td style="font-size : 8pt;" class=title colspan="2">매입옵션</td>
                </tr>
                <tr>
                    <td style="font-size : 8pt;" width="10%" class=title>금액</td>
                    <td style="font-size : 8pt;" width="3%" class=title>승계</td>
                    <td style="font-size : 8pt;" width="10%" class=title>금액</td>
                    <td style="font-size : 8pt;" width="3%" class=title>승계</td>
                    <td style="font-size : 8pt;" width="10%" class=title>금액</td>
                    <td style="font-size : 8pt;" width="3%" class=title>%</td>			
                </tr>
    		  <%for(int i=0; i<fee_size; i++){
    				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
    				if(!fees.getCon_mon().equals("")){%>	
                <tr>
                    <td style="font-size : 8pt;" align="center"><%=i+1%></td>
                    <td style="font-size : 8pt;" align="center"><a href="javascript:view_fee('<%=rent_mng_id%>','<%=rent_l_cd%>','<%=fees.getRent_st()%>')"><%=AddUtil.ChangeDate2(fees.getRent_dt())%></a></td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getCon_mon()%>개월</td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_start_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%if(i==0){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>승계<%}else if(fees.getGrt_suc_yn().equals("1")){%>별도<%}else{%>-<%}%></td>			
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>승계<%}else if(fees.getIfee_suc_yn().equals("1")){%>별도<%}else{%>-<%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getOpt_per()%></td>
                </tr>
    		  <%}}%>
            </table>
	    </td>
	</tr>
	<tr>
        <td></td>
    </tr>
    <tr>
        <td></td>
    </tr>
	<tr>
	    <td style='background-color:e5e5e5; height:1;'></td>
	</tr>
	<tr>
        <td></td>
    </tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약해지</span></td>
	</tr>	
	<tr>
	    <td class=line2></td>
	</tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>해지구분</td>
                    <td width="20%">&nbsp;
        			  <select name="cls_st">
        				<%if(base.getCar_gu().equals("0")){%><option value="10">개시전해지(재리스)</option><%}%>
                        <%if(base.getCar_gu().equals("1")){%><option value="7">출고전해지(신차)</option><%}%>                			
                      </select></td>
                    <td width='10%' class='title'>해지일</td>
                    <td>&nbsp;
        			  <input type='text' name='cls_dt' size='10' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
                    </td>
                </tr>
                <tr> 
                    <td class='title'>해지내역 </td>
                    <td colspan="3">&nbsp;
        			  <textarea name="cls_cau" cols="100" class="text" style="IME-MODE: active" rows="3"></textarea> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
	<tr>
	    <td align="right"></td>
	</tr>
          <%if(fee_scd_size>0){%>
          <tr> 
            <td align='left' > <<미수 대여료 리스트>> </td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td class='title' width="100">회차</td>
                  <td class='title' width="110">구분</td>
                  <td class='title' width="200">월대여료</td>
                  <td class='title' width="150">연체일수</td>
                  <td class='title' width="150">연체료</td>
                  <td class='title' width="90">면제</td>
                </tr>
                <%	for(int i = 0 ; i < fee_scd_size ; i++){
				  		FeeScdBean a_fee = (FeeScdBean)v_fee_scd.elementAt(i);
						if(a_fee.getRc_yn().equals("0")){ //미입금%>
                <tr> 
                  <td width="100" align="center"> 
                    <%if(a_fee.getTm_st1().equals("0")){%>
                    <%=a_fee.getFee_tm()%> 
                    <%}%>
                  </td>
                  <td width="110" align="center"> 
                    <%if(a_fee.getTm_st1().equals("0")){%>
                    대여료 
                    <%}else{%>
                    잔액 
                    <%}%>
                  </td>
                  <td width="200" align='right'><%=AddUtil.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%>원&nbsp;</td>
                  <td width="150" align="center"><%=a_fee.getDly_days()%>일</td>
                  <td width="150" align='right'><%=AddUtil.parseDecimal(a_fee.getDly_fee())%>원&nbsp;</td>
                  <td align="center" width="90"> 
                    <input type='checkbox' name='dly_chk' checked value='N'>		
				    <input type='hidden' name='ht_rent_st' value='<%=a_fee.getRent_st()%>'>
				    <input type='hidden' name='ht_rent_seq' value='<%=a_fee.getRent_seq()%>'>								
				    <input type='hidden' name='ht_fee_tm' value='<%=a_fee.getFee_tm()%>'>
				    <input type='hidden' name='ht_tm_st1' value='<%=a_fee.getTm_st1()%>'>
				    <input type='hidden' name='ht_tm_st2' value='<%=a_fee.getTm_st2()%>'>					
                  </td>
                </tr>
                <%		}
					}%>
              </table>
            </td>
          </tr>
	<tr>
	    <td>※ 청구하여 입금 처리할 회차는 면제를 해제해 주세요.</td>
	</tr>		  
          <%	}	%>
	<%if(fee.getRent_start_dt().equals("")){%>
    <tr>
		<td align="right"><input type="button" name="b_selete" value="등록" onClick="javascript:save();"></td>
	</tr>	
	<%}else{%>
    <tr>
		<td align="right"><font color=red>※ 대여개시된 건입니다. 여기서는 해지처리가 되지 않습니다.</font></td>
	</tr>	
	<%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
//-->
</script>
</body>
</html>
