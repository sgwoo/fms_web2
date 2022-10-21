<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.user_mng.*, acar.res_search.*, tax.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.end_cont.End_ContDatabase"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 		= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 				= request.getParameter("mode")==null?"":request.getParameter("mode");
	String fee_start_dt 	= "";
	
	if(rent_l_cd.equals("")) return;
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "24");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getUse_yn().equals("N"))	return;
	
	//if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
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
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//잔가변수NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//3. 대여-----------------------------
	
	//대여료갯수조회(연장여부)
	int fee_size = af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	fee_start_dt = rs_db.addDay(ext_fee.getRent_end_dt(), 1);
	
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//발행작업스케줄-신차
	Vector fee_scd = ScdMngDb.getFeeScdTaxScd("", "3", ext_fee.getRent_st(), "", "", rent_mng_id, rent_l_cd, base.getCar_mng_id(), "", "1");
	int fee_scd_size = fee_scd.size();
	
	Hashtable end_cont = ec_db.selectEnd_Cont(rent_mng_id, rent_l_cd);
	
	//분할청구정보
	Vector rtn = af_db.getFeeRtnList(rent_mng_id, rent_l_cd, ext_fee.getRent_st());
	int rtn_size = rtn.size();
	
//	if(rtn_size>0) out.println("분할청구 업체입니다. 전산팀 정현미 대리에게 문의하세요.");
	
	rtn_size = 0; //분할은 나중에
	
	String f_use_s_dt 	= "";
	String f_use_e_dt 	= "";
	String f_fst_dt 	= "";
	String f_req_dt 	= "";
	String f_tax_dt 	= "";
	String last_fee_tm	= "";
	
	String ext_reg_chk	= "";
	
	//차령만료일 최대연장 반영분
	String car_end_dt_max = cr_bean.getInit_reg_dt();
	//2000cc미만은 5+2=7년
	car_end_dt_max = c_db.addMonth(car_end_dt_max, 82);
	//비LPG -1개월
	if(!ej_bean.getJg_b().equals("2")){
		car_end_dt_max = c_db.addMonth(car_end_dt_max, 1);
	}	
	//2000cc초과는 8+2=10년
	if(AddUtil.parseInt(cr_bean.getDpm()) > 2000){
		car_end_dt_max = c_db.addMonth(car_end_dt_max, 36);
	}
	//car_end_dt_max = c_db.addDay(car_end_dt_max, -1);
	
	if(!cr_bean.getCar_end_dt().equals("") && cr_bean.getCar_end_yn().equals("Y")){
	//	car_end_dt_max = c_db.addDay(cr_bean.getCar_end_dt(), -2);
	}
	
	//20211126 여유분 1개월 더 줌 (생산일 기준으로하면 더 줘야 함) - 김광수팀장요청
	car_end_dt_max = c_db.addMonth(car_end_dt_max, -1);

	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	//고객 보기
	function view_client()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("선택된 고객이 없습니다."); return;}	
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//지점/현장 보기
	function view_site()
	{
		var fm = document.form1;
		if(fm.site_id.value == ""){ alert("선택된 지점이 없습니다."); return;}
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value+"&site_id="+fm.site_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=450");
	}			

	//자동차등록정보 보기
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		
	
	//스케줄변경이력
	function FeeScdCngList(){
		var fm = document.form1;
		window.open("about:blank", "ScdCngList", "left=50, top=50, width=800, height=500, scrollbars=yes");				
		fm.action = "/fms2/con_fee/fee_scd_u_cnglist.jsp";
		fm.target = "ScdCngList";
		fm.submit();	
	}	
		
	//대여기간 셋팅
	function ScdfeeSet()
	{
		var fm = document.form1;
		//fm.rent_end_dt.value = addMonth(fm.rent_start_dt.value, fm.add_tm.value);
		if(toInt(fm.add_tm.value) == 0 || toInt(fm.add_tm.value) > 5)	{ alert('임의연장은 1개월부터 5개월까지 입력할 수 있습니다.'); 	fm.add_tm.focus(); 		return; }
		if(fm.rent_start_dt.value != '' && fm.add_tm.value != ''){
			fm.action = "/fms2/con_fee/fee_scd_set_nodisplay.jsp";
			fm.target = "i_no";
			fm.submit();
		}
	}			
	
	//통합여부에 따른 디스플레이
	function display_rtn(){
		var fm = document.form1;		
		if(fm.rtn_st.checked == true){ 					
			tr_rtn.style.display = 'block';		
		}else{											
			tr_rtn.style.display = 'none';							
		}	
	}
	
	function cal_sv_amt(obj)
	{
		var fm = document.form1;
		obj.value=parseDecimal(obj.value);

		if(obj == fm.fee_s_amt){ //월대여료 공급가
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1) ;
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value))); 				
		}else if(obj == fm.fee_v_amt){ //월대여료 부가세		
			fm.fee_s_amt.value = parseDecimal(toInt(parseDigit(fm.fee_v_amt.value)) / 0.1) ;
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value))); 				
		}else if(obj == fm.fee_amt){ //월대여료 합계		
			fm.fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));
		}
	}		
			
				
	//등록
	function save(){
		var fm = document.form1;

		if(fm.add_tm.value == '')					{ alert('연장회차를 입력하십시오.'); 					fm.add_tm.focus(); 		return; }
		if(toInt(fm.add_tm.value) == 0 || toInt(fm.add_tm.value) > 5)	{ alert('임의연장은 1개월부터 5개월까지 입력할 수 있습니다.'); 		fm.add_tm.focus(); 		return; }
		
		//fm.rent_end_dt.value = addMonth(fm.rent_start_dt.value, fm.add_tm.value);
		if(fm.rent_end_dt.value == ''){
			ScdfeeSet();
		}
				
		/*
		if(fm.rent_start_dt.value == '')	{ alert('연장대여기간을 입력하십시오.'); 						fm.rent_start_dt.focus(); 	return; }
		if(fm.rent_end_dt.value == '')		{ alert('연장대여기간을 입력하십시오.'); 						fm.rent_end_dt.focus(); 	return; }
		if(fm.f_use_start_dt.value == '')	{ alert('1회차 사용기간을 입력하십시오.'); 						fm.f_use_start_dt.focus(); 	return; }
		if(fm.f_use_end_dt.value == '')		{ alert('1회차 사용기간을 입력하십시오.'); 						fm.f_use_end_dt.focus(); 	return; }
		if(fm.f_req_dt.value == '')			{ alert('1회차 발행예정일을 입력하십시오.'); 					fm.f_req_dt.focus(); 		return; }
		if(fm.f_tax_dt.value == '')			{ alert('1회차 세금일자를 입력하십시오.'); 						fm.f_tax_dt.focus(); 		return; }
		if(fm.f_est_dt.value == '')			{ alert('1회차 입금예정일을 입력하십시오.'); 					fm.f_est_dt.focus(); 		return; }						
		*/

		<%if(rtn_size>0){%>
		//분할청구
		if(fm.rtn_st.checked == true){
			var rtn_tm = <%=rtn_size%>;			
			var tot_rtn_fee_amt = 0;
			if(fm.rtn_fee_amt[0].value == '0'){			alert('1번 분할청구 대여료 금액을 확인하십시오'); 	fm.rtn_fee_amt[0].focus(); 	return; }
			for(i=0; i<rtn_tm; i++){ 
				if(fm.rtn_firm_nm[i].value == '' || fm.rtn_fee_amt[i].value == ''){ alert(i+1+'번 분할청구 내용을 입력하십시오.'); return;}
				if(toInt(parseDigit(fm.rtn_fee_amt[i].value)) > 0){ 
					fm.rtn_fee_s_amt[i].value 	= sup_amt(toInt(parseDigit(fm.rtn_fee_amt[i].value)));
					fm.rtn_fee_v_amt[i].value 	= toInt(parseDigit(fm.rtn_fee_amt[i].value)) - toInt(fm.rtn_fee_s_amt[i].value);
					tot_rtn_fee_amt 			= tot_rtn_fee_amt + toInt(parseDigit(fm.rtn_fee_amt[i].value));
				}
			}
			if(toInt(parseDigit(fm.fee_amt.value)) != tot_rtn_fee_amt){ alert('분할청구금액합이 맞지 않습니다.'); return; }		
		}
		<%}%>
				
		//영업용차량일 경우 차령만료일 체크해서 연장만료일자 경과를 할 경우 등록이 안되도록 한다.
		<%if(!ck_acar_id.equals("000029") && !ck_acar_id.equals("000026") && cr_bean.getCar_use().equals("1")){%>
		if(toInt(replaceString('-','','<%=car_end_dt_max%>')) < toInt(replaceString('-','',fm.rent_end_dt.value)) ){
			alert('대여기간 만료일이 차령만료일보다 큽니다. 확인하십시오.'); 						fm.rent_end_dt.focus(); 	return;
		}
		<%}%>				
				
			
		if(confirm('등록하시겠습니까?')){	
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
			
		
			fm.action='lc_im_renew_c_rm_a.jsp';		

			<%if(mode.equals("pop")){%>
				fm.target='RENEW';
			<%}else{%>
				fm.target='d_content';
			<%}%>
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}							
	}

	//청구금액 셋팅
	function set_reqamt(st){
		var fm = document.form1;			
		if(fm.f_use_start_dt.value == ''){	alert('시작일을 입력하십시오.'); fm.f_use_start_dt.focus(); return;}
		if(fm.f_use_end_dt.value == ''){	alert('종료일을 입력하십시오.'); fm.f_use_end_dt.focus(); 	return;}				
		fm.st.value = st;
		fm.action='/fms2/con_fee/getUseDayFeeAmt.jsp';		
		if(st == 'view'){
			fm.target='_blank';
		}else{
			fm.target='i_no';
		}				
		fm.submit();
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
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="m_id" 			value="<%=rent_mng_id%>">
  <input type='hidden' name="l_cd" 			value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_st"	 	value="<%=ext_fee.getRent_st()%>">
  <input type='hidden' name="from_page" 	value="/fms2/lc_rent/lc_im_renew_c.jsp">             
  <input type='hidden' name="firm_nm"	 	value="<%=client.getFirm_nm()%>">
  <input type='hidden' name='st' value=''>        
  <input type='hidden' name='f_fee_amt' value=''>
  <input type='hidden' name='f_fee_s_amt' value=''>
  <input type='hidden' name='f_fee_v_amt' value=''>
  <input type='hidden' name='client_id' value='<%=base.getClient_id()%>'>
  <input type='hidden' name='mode' value='<%=mode%>'>
  
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
                    <td class=title width=10%>용도/관리</td>
                    <td width=10%>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("5")){%>업무대여<%}%>
					&nbsp;<%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}%></td>
                    <td class=title width=10%>영업담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>
                <tr>
                    <td class=title>상호</td>
                    <td >&nbsp;<a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=client.getFirm_nm()%> <%=site.getR_site()%></a></td>
                    <td class=title>차량번호</td>
                    <td>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=cr_bean.getCar_no()%></a></td>
                    <td class=title>차명</td>
                    <td>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;
        			<font color="#999999">(차종코드:<%=cm_bean.getJg_code()%>)</font>
        			</td>
                </tr>
                <tr>
                    <td class=title>차령만료일</td>
                    <td>&nbsp;<font color=red><b><%=AddUtil.ChangeDate2(cr_bean.getCar_end_dt())%></b></font>
                    	<%if(cr_bean.getCar_use().equals("1")){
							int car_end_d_day = c_db.getCar_D_day("car_end_dt", base.getCar_mng_id());
						%>
						<%if(car_end_d_day <= 30){ %><font color=red>(D-day <%=car_end_d_day%>일)</font><%}else{ if(ck_acar_id.equals("000029")){%>:<%=car_end_d_day%>일<%}} %>
						<%} %>
                    </td>
                    <%	
        		    	int car_maint_d_day = c_db.getCar_D_day("car_maint_dt", base.getCar_mng_id());
				%>
                    <td class=title>검사유효기간</td>
                    <td colspan='3'>&nbsp;<b><%=cr_bean.getMaint_st_dt()%>~<%=cr_bean.getMaint_end_dt()%> <%if(car_maint_d_day <= 30){ %><font color=red>(D-day <%=car_maint_d_day%>일)</font><%}else{ if(ck_acar_id.equals("000029")){%>:<%=car_maint_d_day%>일<%}} %></b></td>
                </tr>
				<%if(!cms.getCms_bank().equals("")){%>
                <tr>
                     <td class='title'>CMS</td>
                     <td colspan='5'>&nbsp;
						<b><%if(!cms.getCbit().equals("")){%>[<%=cms.getCbit()%>]<%}%></b>
        			 	<%=cms.getCms_bank()%> : <%=AddUtil.ChangeDate2(cms.getCms_start_dt())%> ~ <%=AddUtil.ChangeDate2(cms.getCms_end_dt())%> (매월 <%=cms.getCms_day()%>일)
					 </td>                     
                </tr>							
        		<%}%>		
				<%if(!client.getEtc().equals("")){%>	 				
                <tr>
                     <td class='title'>고객 특이사항</td>
                     <td colspan='5'>&nbsp;<%=Util.htmlBR(client.getEtc())%></td>                     
                </tr>		
        		<%}%>						
				<%if(!String.valueOf(end_cont.get("RE_BUS_NM")).equals("") && !String.valueOf(end_cont.get("RE_BUS_NM")).equals("null")){%>				
                <tr>
                     <td class='title'>만기진행현황</td>
                     <td colspan='5'>&nbsp;<%=end_cont.get("REG_DT")%> : [<%=end_cont.get("RE_BUS_NM")%>] <%=end_cont.get("CONTENT")%></td>                     
                </tr>	
				<%}%>						
                <tr>
                     <td class='title'>계산서발행구분</td>
                     <td colspan='5'>&nbsp;<font color='#CCCCCC'>(계산서발행구분:
					  <%if(client.getPrint_st().equals("1")) 		out.println("계약건별");
                      	else if(client.getPrint_st().equals("2"))   out.println("<font color='#FF9933'>거래처통합</font>");
                      	else if(client.getPrint_st().equals("3")) 	out.println("<font color='#FF9933'>지점통합</font>");
                     	else if(client.getPrint_st().equals("4"))	out.println("<font color='#FF9933'>현장통합</font>");%>)
						</font></td>                     
                </tr>	
            </table>
	    </td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
                <tr>
                    <td style="font-size : 8pt;" width="3%" class=title rowspan="3">최<br>종<br>계<br>약<br></td>
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
    		  <%//for(int i=0; i<fee_size; i++){
//    				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
				ContFeeBean fees = ext_fee;
				
				//담당자 재량에 일자연장후 추가연장 가능으로 변경	
				//if(AddUtil.parseInt(base.getRent_dt()) > 20140228 && fees.getCon_mon().equals("0")) ext_reg_chk = "N";    	
				
					
//    				if(!fees.getCon_mon().equals("")){%>	
                <tr>
                    <!--<td style="font-size : 8pt;" align="center"><%//=i+1%></td>-->
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getCon_mon()%>개월</td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_start_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getRent_st().equals("1")){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>승계<%}else if(fees.getGrt_suc_yn().equals("1")){%>별도<%}else{%>-<%}%></td>			
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="right"><%if(fees.getIfee_s_amt()>0){%><%if(fees.getPere_r_mth()>0){%><%=fees.getPere_r_mth()%><%}else{%><%=fees.getIfee_s_amt()/fees.getFee_s_amt()%><%}%>회&nbsp;<%}%><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>승계<%}else if(fees.getIfee_suc_yn().equals("1")){%>별도<%}else{%>-<%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getOpt_per()%></td>
                </tr>
    		  <%//}}%>
            </table>
	    </td>
	</tr>	
    <%if(ext_reg_chk.equals("N")){%>			
    <tr>
	<td><font color=red>* 20140225일 최초계약분부터 일자단위 연장계약시 추가연장 불가입니다.</font></td>
    </tr>
</table>
</form>    	
    <%		if(1==1) return;
    	}%>		
	<tr>
	    <td align="right">&nbsp;
			    <a href="javascript:FeeScdCngList()"><img src=/acar/images/center/button_scd_bgir.gif  align=absmiddle border="0"></a>
		</td>
	</tr>

	<%if(fee_scd_size>0){
			int start_size = fee_scd_size-3;
			if(start_size < 0)	start_size = 0;
			%>  	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>최종스케줄 3회분</span></td>
	</tr>
	<tr>
	    <td colspan="2" class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>	 
                <tr>
                    <td width='5%' rowspan="2" class='title'>회차</td>
                    <td colspan="2" rowspan="2" class='title'>사용기간</td>
                    <td width="13%" rowspan="2" class='title'>월대여료</td>
                    <td colspan="3" class='title'>스케줄</td>
                    <td colspan="2" class='title'>거래명세서</td>					
                    <td colspan="2" class='title'>계산서</td>
                </tr>
                <tr>
                  <td width="10%" class='title'>발행예정일</td>
                  <td width="10%" class='title'>세금일자</td>
                  <td width="10%" class='title'>입금예정일</td>
                  <td width="8%" class='title'>발급일자</td>
                  <td width="8%" class='title'>예정일자</td>
                  <td width="8%" class='title'>발행일자</td>
                  <td width="8%" class='title'>출력일자</td>
                </tr>
        		<%	for(int j = start_size ; j < fee_scd_size ; j++){
        					Hashtable ht = (Hashtable)fee_scd.elementAt(j);
							
							if(j == fee_scd_size-1){
								f_use_s_dt 	=  c_db.addDay  (String.valueOf(ht.get("USE_E_DT")), 1);																
								f_use_e_dt 	=  c_db.addMonth(String.valueOf(ht.get("USE_E_DT")), 1);
								//월렌트는 사용기간 시작일을 발행예정일, 세금일자, 입금예정일의 기본으로 한다.
								f_fst_dt 	=  f_use_s_dt;
								f_req_dt 	=  f_use_s_dt;
								f_tax_dt 	=  f_use_s_dt;
								last_fee_tm = String.valueOf(ht.get("FEE_TM"));								
							}
							%>
                <tr>
                    <td align="center"><%=ht.get("FEE_TM")%></td>
                    <td align="center" width="10%" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT")))%></td>
                    <td align="center" width="10%" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT")))%></td>
                    <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>원&nbsp;&nbsp;</td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ITEM_DT")))%><%if(!String.valueOf(ht.get("ITEM_DT")).equals("")){%><br><font color='999999'>(<%=ht.get("ITEM_ID")%>)</font><%}%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_EST_DT")))%></td>										
                    <td align="center">
        		    <%if(AddUtil.parseInt(AddUtil.dateFormat("yyyyMMdd")) > AddUtil.parseInt(String.valueOf(ht.get("REG_DT")))){%>
        		    <%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%>
          		    <%}else{%>					
					<%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%>
					<%}%>
					<%if(!String.valueOf(ht.get("TAX_DT")).equals("")){%><br><font color='999999'>(<%=ht.get("TAX_NO")%>)</font><%}%>
        		    </td>
                    <td align="center">
        		    <%if(String.valueOf(ht.get("PRINT_DT")).equals("")){%>
        		    <%	if(AddUtil.parseInt(AddUtil.dateFormat("yyyyMMdd")) > AddUtil.parseInt(String.valueOf(ht.get("REG_DT")))){%>
        		    	<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>
          		    <%	}else{%>
						<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>
					<%	}%>
        		    <%}else{%>
        		    <%=AddUtil.ChangeDate2(String.valueOf(ht.get("PRINT_DT")))%>
        		    <%}%>
        		    </td>
                </tr>
        		<%	}%>
            </table>
	    </td>
    </tr>	
	<%}%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>임의연장</span></td>	
	</tr>	  	
    <tr>
        <td class=line2></td>
    </tr>		

	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td colspan="2" class='title'>연장회차</td>
                    <td>
                      <%if(base.getCar_st().equals("4")){%>
                      &nbsp;<input type='text' size='3' name='add_tm' value='1' maxlength='2' class='default' onBlur='javscript:ScdfeeSet();'>회
					  (default 1개월, 1~5개월내에서 선택)
                      <%}else{%>
                      &nbsp;<input type='text' size='3' name='add_tm' value='3' maxlength='2' class='default' onBlur='javscript:ScdfeeSet();'>회
					  (default 3개월, 1~5개월내에서 선택)
		      <%}%>			  
					  <input type='hidden' name='last_fee_tm' value='<%=last_fee_tm%>'>
					  </td>
                </tr>
                <tr>
                    <td colspan="2" class='title'>연장대여기간</td>
                    <td>&nbsp;<input type='text' name='rent_start_dt' value='<%=AddUtil.ChangeDate2(f_use_s_dt)%>' size='10' class='<%if(fee_scd_size==0){%>whitetext<%}else{%>whitetext<%}%>' onBlur='javscript:this.value = ChangeDate4(this, this.value); <%if(f_use_s_dt.equals("")){%>ScdfeeSet();<%}%>'>
        			  ~
        			  <input type='text' name='rent_end_dt' value='' size='10' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
        			</td>
                </tr>							
                <tr>
                    <td colspan="2" class='title'>월대여료</td>
                    <td>&nbsp;<input type='text' name='fee_amt' value='<%=AddUtil.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>' size='10' class='<%if(ext_fee.getFee_s_amt()==0){%>num<%}else{%>whitenum<%}%>' onBlur='javascript:this.value=parseDecimal(this.value); cal_sv_amt(this);'>원&nbsp;
						(임의연장은 계약서를 쓰지 않고, 대여요금은
						 <%if(AddUtil.parseInt(base.getRent_dt()) > 20140228){%>최초계약 월대여료의 5% 할인된 금액으로 한다.<%}else{%>기존과 동일하게 합니다.<%}%>
						)
						&nbsp;&nbsp;
						공급가:<input type='text' name='fee_s_amt' value='<%=AddUtil.parseDecimal(ext_fee.getFee_s_amt())%>' size='10' class='<%if(ext_fee.getFee_s_amt()==0){%>whitenum<%}else{%>whitenum<%}%>' onBlur='javascript:this.value=parseDecimal(this.value); cal_sv_amt(this);'>원, 
						부가세:<input type='text' name='fee_v_amt' value='<%=AddUtil.parseDecimal(ext_fee.getFee_v_amt())%>' size='10' class='<%if(ext_fee.getFee_s_amt()==0){%>whitenum<%}else{%>whitenum<%}%>' onBlur='javascript:this.value=parseDecimal(this.value); cal_sv_amt(this);'>원
        			</td>
                </tr>								
                <tr id=tr_im1 style='display:<%if(fee_scd_size==0){%>none<%}else{%>none<%}%>'>
                    <td width="3%" rowspan="5" class='title'>1회차</td>
                    <td class='title'>사용기간</td>
                    <td>
                      &nbsp;<input type='text' name='f_use_start_dt' value='<%=AddUtil.ChangeDate2(f_use_s_dt)%>' maxlength='10' size='10' class='default' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                      ~
                      <input type='text' name='f_use_end_dt' value='<%=AddUtil.ChangeDate2(f_use_e_dt)%>' maxlength='10' size='10' class='default' onBlur="javscript:this.value = ChangeDate4(this, this.value); set_reqamt('');">
					( <input type='hidden' name='use_days' value=''>
					  <input type="text" name="u_mon" value="" size="5" class=text>개월
  					  <input type="text" name="u_day" value="" size="5" class=text>일 )
					  &nbsp;&nbsp;&nbsp;					  
					  <a href="javascript:ScdFDdaySet();">[1회차 초기화]</a>
        		    </td>
                </tr>
                <tr id=tr_im2 style='display:<%if(fee_scd_size==0){%>none<%}else{%>none<%}%>'>
                    <td width="10%" class='title'>발행예정일</td>
                    <td>
                        &nbsp;<input type='text' name='f_req_dt' value='<%=AddUtil.ChangeDate2(f_req_dt)%>' maxlength='10' size='10' class='default' onBlur='javscript:this.value = ChangeDate4(this, this.value);'> 
                        (거래명세서 작성일자, 보편적으로 세금계산서 작성일자 15일전) </td>
                </tr>
                <tr id=tr_im3 style='display:<%if(fee_scd_size==0){%>none<%}else{%>none<%}%>'>
                    <td class='title'>세금일자</td>
                    <td>
                        &nbsp;<input type='text' name='f_tax_dt' value='<%=AddUtil.ChangeDate2(f_tax_dt)%>' maxlength='10' size='10' class='default' onBlur='javscript:this.value = ChangeDate4(this, this.value);'> 
                        (세금계산서 작성일자) 
                    </td>
                </tr>						
                <tr id=tr_im4 style='display:<%if(fee_scd_size==0){%>none<%}else{%>none<%}%>'>
                    <td class='title'>입금예정일</td>
                    <td>
                        &nbsp;<input type='text' name='f_est_dt' value='<%=AddUtil.ChangeDate2(f_fst_dt)%>' maxlength='10' size='10' class='default' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                </tr>
                <tr id=tr_im5 style='display:<%if(fee_scd_size==0){%>none<%}else{%>none<%}%>'>
                    <td class='title'>변경사유</td>
                    <td>
                        &nbsp;<textarea name="cng_cau" cols="82" rows="5" class=default style='IME-MODE: active'></textarea>
                        <input type='hidden' name='etc' value=''>
                    </td>
                </tr>
            </table>
	    </td>
    </tr>	
	<tr id=tr_im6 style='display:<%if(fee_scd_size==0){%>none<%}else{%>none<%}%>'>
	    <td><font color=green>* <!--1회차 사용기간에 있는 [계산하기]를 클릭하면 사용기간 및 대여료 일자 계산 합니다. -->1회차만료일 입력시 자동 계산함.</font></td>
    </tr>		
	<tr id=tr_im7 style='display:<%if(fee_scd_size==0){%>none<%}else{%>none<%}%>'>
	    <td><font color=green>* 대여료스케줄이 없습니다. 1회차 일자들을 입력하여 주십시오.</font></td>
    </tr>		
	<tr id=tr_im8 style='display:<%if(ext_fee.getFee_s_amt()==0){%>none<%}else{%>none<%}%>'>
	    <td><font color=green>* 월대여료가 없습니다. 입력하여 주십시오.</font></td>
    </tr>		
	<%if(rtn_size>0){%>
	<tr>
	    <td class=h></td>
	</tr>		
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width=13% class='title'>분할청구여부</td>
                    <td>&nbsp;
        			  <input type="checkbox" name="rtn_st" value="Y" onClick="javascript:display_rtn()" checked>
                    </td>
                </tr>
            </table>
	    </td>
    </tr>		
	<tr tr id=tr_rtn style="display:''">
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title'>구분</td>
                    <td width='47%' class='title'>공급받는자</td>
        			<td width='40%' class='title'>청구금액</td>
                </tr>			
				<%	for(int r = 0 ; r < rtn_size ; r++){
						Hashtable r_ht = (Hashtable)rtn.elementAt(r);%>				
                <tr>
                    <td class='title'><%=r+1%></td>
                    <td align="center">
        			  <input type='text' size='45' name='rtn_firm_nm' value='<%=r_ht.get("FIRM_NM")%>' class='text' readonly>
        			  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        			  </td>
        			  <td align="center">
                      <input type='text' name='rtn_fee_amt' value='<%=AddUtil.parseDecimal(String.valueOf(r_ht.get("RTN_AMT")))%>' size='12' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원
        			  <input type='hidden' name='rtn_fee_s_amt' value='0'>
        			  <input type='hidden' name='rtn_fee_v_amt' value='0'>		
        			  <input type='hidden' name='rtn_client_id' value='<%=r_ht.get("CLIENT_ID")%>'>
        			  <input type='hidden' name='rtn_site_id' value='<%=r_ht.get("SITE_ID")%>'>
					  <input type='hidden' name='rtn_rent_seq' value='<%=r_ht.get("RENT_SEQ")%>'>
					  </td>
                </tr>
				<%	}%>
            </table>
	    </td>
    </tr>		
	<%}%>
    <tr>
        <td>&nbsp;</td>
    </tr>
	
	<tr>
	    <td class=h></td>
	</tr>	
	<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    <tr>
		<td align="right"><a id="submitLink" href="javascript:save();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
	</tr>	
	<%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

	
	function ScdFDdaySet(){
		var fm = document.form1;
		
		fm.f_use_start_dt.value 	= ChangeDate('<%=f_use_s_dt%>');
		fm.f_use_end_dt.value 		= ChangeDate('<%=f_use_e_dt%>');
		fm.f_req_dt.value		= ChangeDate('<%=f_req_dt%>');
		fm.f_tax_dt.value		= ChangeDate('<%=f_tax_dt%>');
		fm.f_est_dt.value		= ChangeDate('<%=f_fst_dt%>');				
	}	

	function initSet(){
		var fm = document.form1;
		
		//20140301 최초계약 월대여료 대비 5%할인적용 -> 20150317 3% 적용
		<%if(AddUtil.parseInt(base.getRent_dt()) >= 20140301 && AddUtil.parseInt(base.getRent_dt()) < 20150317 && fee_size==1){%>			
		fm.fee_amt.value = <%=fee.getFee_s_amt()+fee.getFee_v_amt()%>*0.95;
		fm.fee_amt.value = bak_th_rnd(toInt(fm.fee_amt.value));
		cal_sv_amt(fm.fee_amt);
		<%}else if(AddUtil.parseInt(base.getRent_dt()) >= 20150317 && AddUtil.parseInt(base.getRent_dt()) < 20170728 && fee_size==1){%>			
		fm.fee_amt.value = <%=fee.getFee_s_amt()+fee.getFee_v_amt()%>*0.97;
		fm.fee_amt.value = bak_th_rnd(toInt(fm.fee_amt.value));
		cal_sv_amt(fm.fee_amt);
		<%}else if(AddUtil.parseInt(base.getRent_dt()) >= 20150317 && AddUtil.parseInt(base.getRent_dt()) < 20170728 && fee_size==2 && ext_fee.getCon_mon().equals("0")){%>			
		fm.fee_amt.value = <%=fee.getFee_s_amt()+fee.getFee_v_amt()%>*0.97;
		fm.fee_amt.value = bak_th_rnd(toInt(fm.fee_amt.value));
		cal_sv_amt(fm.fee_amt);
		<%}else if(AddUtil.parseInt(base.getRent_dt()) >= 20170728){%>
		fm.fee_amt.value = <%=fee.getFee_s_amt()+fee.getFee_v_amt()%>;
		//fm.fee_amt.value = bak_th_rnd(toInt(fm.fee_amt.value));
		cal_sv_amt(fm.fee_amt);
		<%}else{%>	
		fm.fee_amt.value = <%=ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt()%>;
		//fm.fee_amt.value = bak_th_rnd(toInt(fm.fee_amt.value));
		cal_sv_amt(fm.fee_amt);		
		<%}%>
			
		fm.f_fee_amt.value 		= fm.fee_amt.value;
		fm.f_fee_s_amt.value 		= fm.fee_s_amt.value;
		fm.f_fee_v_amt.value 		= fm.fee_v_amt.value;		
		fm.cng_cau.value		= '1회차 대여료(공급가) 일자계산 : '+fm.fee_s_amt.value+'*1개월'; 
		fm.u_mon.value			= '1';
		fm.u_day.value			= '0';
		
		set_reqamt();
		ScdfeeSet();		
	}	
		
	initSet();
//-->
</script>
</body>
</html>
