<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.res_search.*, card.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
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
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//1. 고객 ---------------------------
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	
	//연대보증인정보
	Vector gurs = a_db.getContGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	
	

	//2. 자동차--------------------------
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	

	//3. 대여-----------------------------
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	//월렌트정보
	ContFeeRmBean f_fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");
		
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//신용카드 자동출금
	ContCmsBean card_cms = a_db.getCardCmsMng(rent_mng_id, rent_l_cd);
	
	
	
	//이행보증보험
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	
	//임의연장
	Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, "");
	int im_vt_size = im_vt.size();
	

	//4. 변수----------------------------
	
	//잔가변수NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	String a_a = "";
	if(base.getCar_st().equals("1")) a_a = "2";
	if(base.getCar_st().equals("3")) a_a = "1";
	em_bean = edb.getEstiCommVarCase(a_a, "");
	
	
	
	from_page = "/fms2/lc_rent/lc_c_c_fee_rm.jsp";
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
					
	String content_code = "LC_SCAN";
	String content_seq  = rent_mng_id+""+rent_l_cd; 
			
	int start_chk_file_size = 0;
	Vector attach_vt = new Vector();
	int attach_vt_size = 0;

	content_seq  = rent_mng_id+""+rent_l_cd+"131"; //주운전자면허증
  attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
  attach_vt_size = attach_vt.size();	
  start_chk_file_size = attach_vt_size;
	
	if(!client.getClient_st().equals("1")){
		content_seq  = rent_mng_id+""+rent_l_cd+"14"; //신분증jpg
	  attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
  	attach_vt_size = attach_vt.size();	
	  start_chk_file_size = start_chk_file_size+attach_vt_size;
	}
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function replaceFloatRound(per){
		return Math.round(per*1000)/10;	
	}
	
	function replaceFloatRound2(per){
		return Math.round(per*10)/10;	
	}
	
	//등록/수정: 차량가격 입력시 자동계산으로 가게..
	function enter_fee(obj)
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') set_fee_amt(obj);
	}	
	//등록/수정: 공급가, 부가세, 합계 입력시 자동계산
	function set_fee_amt(obj)
	{
		var fm = document.form1;	
	}	

	//수정
	function update(st, rent_st){
		if(st == 'grt_amt' || st == 'pp_amt' || st == 'ifee_amt' || st == 'fee_amt' || st == 'inv_amt'){
			window.open("/fms2/lc_rent/cng_item.jsp<%=valus%>&cng_item="+st+"&rent_st="+rent_st, "CHANGE_ITEM", "left=100, top=100, width=1050, height=650");
		}else{
			var height = 600;
			if(st == 'fee') 			height = 650;
			if(st == 'rent_start') 			height = 500;
			if(st == 'deli') 			height = 300;
			if(st == 'pay_way') 			height = 500;
			if(st == 'pay_way2') 			height = 500;
			if(st == 'tax') 			height = 300;
			
			if(st == 'fee' || st == 'rent_start' || st == 'deli' || st == 'pay_way2' || st == 'pay_way3'){
			
				if(st == 'pay_way2') st = 'pay_way';
								
				window.open("/fms2/lc_rent/lc_c_u_rm.jsp<%=valus%>&cng_item="+st+"&rent_st="+rent_st, "CHANGE_ITEM", "left=50, top=50, width=1050, height="+height+", scrollbars=yes");
			}else{
				window.open("/fms2/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st+"&rent_st="+rent_st, "CHANGE_ITEM", "left=50, top=50, width=1050, height="+height+", scrollbars=yes");
			}
		}
	}

	//전자문서 전송하기
	function go_edoc(link_table, link_type, link_rent_st, link_im_seq){
		var fm = document.form1;			
		fm.link_table.value 	= link_table;
		fm.link_type.value 	= link_type;
		fm.link_rent_st.value 	= link_rent_st;
		fm.link_im_seq.value 	= link_im_seq;
		window.open('about:blank', "EDOC_LINK", "left=0, top=0, width=900, height=500, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "EDOC_LINK";
		fm.action = "reg_edoc_link.jsp";
		fm.submit();		
	}
	
	//임의연장 계약서
	function view_scan_res2(c_id, m_id, l_cd){
		window.open("/fms2/lc_rent/lc_im_doc_print.jsp?c_id="+c_id+"&rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&mode=fine_doc", "VIEW_SCAN_RES2", "left=100, top=100, width=750, height=700, scrollbars=yes");		
	}	
	
	function im_cancel(im_rent_st, im_seq){
		var fm = document.form1;			
		fm.idx.value = 'im_cancel';
		fm.im_rent_st.value = im_rent_st;
		fm.im_seq.value = im_seq;
		if(confirm('임의연장 취소하시겠습니까?')){
			fm.action='lc_b_u_a.jsp';
			fm.target='i_no';
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
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>">
  <input type='hidden' name="opt"			value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"			value="<%=cm_bean.getCar_b()%>">
  <input type='hidden' name="s_st" 			value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="car_st" 			value="<%=base.getCar_st()%>">
  <input type='hidden' name="purc_gu" 			value="<%=car.getPurc_gu()%>">  
  <input type='hidden' name="pay_st" 			value="<%=car.getPay_st()%>">    
  <input type='hidden' name="rent_way" 			value="<%=ext_fee.getRent_way()%>">  
  <input type='hidden' name="dpm" 			value="<%=cm_bean.getDpm()%>">
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
  <input type='hidden' name="car_end_dt"		value="<%=cr_bean.getCar_end_dt()%>">
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">  
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">    
  <input type='hidden' name="gur_size"			value="<%=gur_size%>">  
  <input type='hidden' name='client_id' 		value='<%=base.getClient_id()%>'>    
  <input type='hidden' name='site_id' 			value='<%=base.getR_site()%>'>
  <input type='hidden' name="car_mng_id" 		value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="dec_gr"			value="<%=cont_etc.getDec_gr()%>"> 
  <input type='hidden' name="o_1"			value="">
  <input type='hidden' name="o_13"			value="">  
  <input type='hidden' name="o_13_amt"			value="">    
  <input type='hidden' name="rent_dt"			value="<%=base.getRent_dt()%>">
  <input type='hidden' name="car_ja"			value="<%=base.getCar_ja()%>">  
  <input type='hidden' name="gcp_kd"			value="<%=base.getGcp_kd()%>">    
  <input type='hidden' name="driving_age"		value="<%=base.getDriving_age()%>">    
  <input type='hidden' name="eme_yn"			value="<%=cont_etc.getEme_yn()%>">
  <input type='hidden' name="car_ext"			value="<%=car.getCar_ext()%>">
  <input type='hidden' name="gi_st"			value="<%=gins.getGi_st()%>">  
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="con_mon"			value="">  
  <input type='hidden' name="t_dc_amt"			value="">  
    
  <input type='hidden' name="fee_size"			value="<%=fee_size%>">    
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
  <input type='hidden' name="gi_amt"			value="<%=gins.getGi_amt()%>">    
  <input type='hidden' name="rent_st"			value="<%=fee_size%>">      
  <input type='hidden' name="sh_amt"			value="<%=fee_etc.getSh_amt()%>">      
  <input type='hidden' name="add_opt_amt"		value="<%=car.getAdd_opt_amt()%>">  
  <input type="hidden" name="lpg_price"  		value="<%=car.getLpg_price()%>"> 
  <input type='hidden' name="sh_rent_dt"		value="">
  <input type='hidden' name="fee_rent_st"		value="">  
  <input type='hidden' name="link_table"		value="">  
  <input type='hidden' name="link_type"			value="">  
  <input type='hidden' name="link_rent_st"		value="">  
  <input type='hidden' name="link_im_seq"		value="">  
  <input type='hidden' name="idx"				value="">
  <input type='hidden' name="im_rent_st"		value="">
  <input type='hidden' name="im_seq"			value="">

<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    </tr>			
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>배차/반차 예정사항 <%if(base.getBus_id().equals(user_id) || base.getBus_id2().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("연장대여료계산",user_id) || nm_db.getWorkAuthUser("회계업무",user_id) || nm_db.getWorkAuthUser("월렌트관리",user_id) || nm_db.getWorkAuthUser("본사주차장",user_id) || nm_db.getWorkAuthUser("주차장출납",user_id)){%>&nbsp;<a href="javascript:update('deli','1')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><%}%></span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr> 
                <td width="13%"  class=title>누적주행거리</td>
                <td colspan='3'>&nbsp;<%=AddUtil.parseDecimal(fee_etc.getSh_km())%>km</td>
              </tr>            
              <tr> 
                <td width="13%"  class=title>배차시간</td>
                <td width="37%">&nbsp;<%=AddUtil.ChangeDate3(f_fee_rm.getDeli_plan_dt())%></td>
                <td width="13%" class=title>반차시간</td>
                <td width="37%" class=''>&nbsp;<%=AddUtil.ChangeDate3(f_fee_rm.getRet_plan_dt())%></td>
              </tr>
              <tr> 
                <td width="13%"  class=title>배차장소</td>
                <td width="37%">&nbsp;<%=f_fee_rm.getDeli_loc()%></td>
                <td width="13%" class=title>반차장소</td>
                <td width="37%">&nbsp;<%=f_fee_rm.getRet_loc()%></td>
              </tr>          
            </table>
        </td>
    </tr>	     
    <tr>
	    <td class=h></td>
	</tr>	

  	<%		for(int i=1; i<=fee_size; i++){
				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i));
				ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(i));
												
				//월렌트정보
				ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, Integer.toString(i));
								
	%>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(i >1){%><%=i-1%>차 연장 <%}%>대여요금 <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id) || nm_db.getWorkAuthUser("연장/승계담당자",user_id)  ){%>&nbsp;<a href="javascript:update('fee','<%=i%>')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><%}%><font color="#CCCCCC"> ( 회계업무 : 보증금, 선납금, 개시대여료, 계약대여료, 정상대여료 수정 )</font></span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_fee style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
            	<%if(i<fee_size){%>
                <tr>
                    <td width="13%" align="center" class=title>계약일자</td>
                    <td width="20%">&nbsp;<%if(i >1){%><%=AddUtil.ChangeDate2(fees.getRent_dt())%><input type="hidden" name="rent_dt" value="<%=fees.getRent_dt()%>"><%}else{%><%=AddUtil.ChangeDate2(base.getRent_dt())%><%}%></td>
                    <td width="10%" align="center" class=title>계약담당자</td>
                    <td>&nbsp;<%if(i >1){%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}else{%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}%></td>
                    <td width="10%" align="center" class=title>영업대리인</td>
                    <td>&nbsp;<%if(i >1){%><%=c_db.getNameById(fee_etcs.getBus_agnt_id(),"USER")%><%}else{%><%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%><%}%></td>
                </tr>
                <%}else{%>
                <tr>
                    <td width="13%" align="center" class=title>계약일자</td>
                    <td width="20%">&nbsp;<%=AddUtil.ChangeDate2(fees.getRent_dt())%><input type="hidden" name="rent_dt" value="<%=fees.getRent_dt()%>"></td>
                    <td width="10%" align="center" class=title>계약담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(fees.getExt_agnt(),"USER")%></td>
                    <td width="10%" align="center" class=title>영업대리인</td>
                    <td>&nbsp;<%=c_db.getNameById(fee_etcs.getBus_agnt_id(),"USER")%></td>
                </tr>                
                <%}%>
                <tr>
                    <td width="13%" align="center" class=title>이용기간</td>
                    <td width="20%">&nbsp;<%=fees.getCon_mon()%>개월<%if(!fee_etcs.getCon_day().equals("") && !fee_etcs.getCon_day().equals("0")){%><%=fee_etcs.getCon_day()%>일<%}%>
                        <input type='hidden' name="con_mons" value="<%=fees.getCon_mon()%>">
                        <input type='hidden' name="con_days" value="<%=fee_etcs.getCon_day()%>">
                    </td>
                    <td width="10%" align="center" class=title>대여개시일</td>
                    <td width="20%">&nbsp;<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>
                      <%if(base.getUse_yn().equals("Y") && i == 1 && fees.getRent_start_dt().equals("") && (user_id.equals(base.getBus_id()) || user_id.equals(base.getBus_id2()) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("회계업무",user_id) || nm_db.getWorkAuthUser("월렌트관리",user_id))){%>
                        
                        <%	if(start_chk_file_size > 0){
                        %>
                        <a href="javascript:update('rent_start','1');" title='신차 대여개시 처리'><img src=/acar/images/center/button_in_scgs.gif align=absmiddle border=0></a>
                        <%	}else{%>
                        <font color=red>※ 대여개시전에 <%if(!client.getClient_st().equals("1")){%>신분증jpg 혹은 <%}%>운전자면허증 사본을 먼저 스캔하세요.</font>
                        
                        <%		if(ck_acar_id.equals("000029")){%>
                        <a href="javascript:update('rent_start','1');" title='신차 대여개시 처리'>.</a>
                        <%		}%>
                        <%	}%>
                        
                      <%}%>
                    </td>
                    <td width="10%" align="center" class=title>대여만료일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <%if(fees.getRent_st().equals("1")){
    		
    %>
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
                <td colspan='2' class='title'>보증금</td>
                <td align='center'>-</td>
                <td align='center'>-</td>
                <td align='center'><input type='text' size='11' maxlength='10' name='grt_s_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
    		<td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "0")%></td>		  
                <td align="center">차가의
                    <input type='text' size='4' name='gur_p_per' class='whitenum' value='<%=fees.getGur_p_per()%>' readonly>
    				  % </td>
                <td align='center'><%if(base.getRent_st().equals("3") && fees.getRent_st().equals("1")){%>대차 보증금 승계여부 :<%}%>
        			  <%if(fees.getGrt_suc_yn().equals("0")){%>승계<%}else if(fees.getGrt_suc_yn().equals("1")){%>별도<%}else{%>-<%}%><input type='hidden' name='gur_per' value=''>
		</td>
              </tr>                           
                <tr>
                    <td rowspan="5" class='title'>월<br>대<br>
                      여<br>
                      료</td>
                    <td class='title'>정상대여료</td>
                    <td align="center" ><input type='text' size='10' name='inv_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center" ><input type='text' size='9' name='inv_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center' ><input type='text' size='10' maxlength='10' name='inv_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원 </td>
                    <td align='center'>-</td>
                    <td align="center">-</td>
                    <td align='center'>-</td>
                </tr>
                <tr>
                    <td class='title'>D/C</td>
                    <td align="center" >-<input type='text' size='10' name='dc_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getDc_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center" >-<input type='text' size='9' name='dc_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getDc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center' >-<input type='text' size='10' maxlength='10' name='dc_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getDc_s_amt()+fee_rm.getDc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원 </td>
                    <td align='center'>-</td>
                    <td align="center">DC율:
                      <input type='text' size='4' name='dc_ra' maxlength='10' class="whitenum" value='<%=fees.getDc_ra()%>'></td>
                    <td align='center'>&nbsp;</td>
                </tr>	
              <tr>
                <td class='title'>내비게이션</td>
                <td align="center"><input type='text' size='11' name='navi_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='navi_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='navi_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt()+fee_rm.getNavi_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center">
                  <%if(fee_rm.getNavi_yn().equals("N")){%>없음<%}else if(fee_rm.getNavi_yn().equals("Y")){%>있음<%}else{%>-<%}%>                  
    	 	</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td class='title'>기타</td>
                <td align="center"><input type='text' size='11' name='etc_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='etc_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='etc_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt()+fee_rm.getEtc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center">
                    <input type='text' size='40' name='etc_cont' class='whitetext' value='<%=fee_rm.getEtc_cont()%>'>
    				  </td>
                <td align='center'>-</td>
              </tr>                
                <tr>
                    <td class='title'>소계</td>
                    <td align="center" ><input type='text' size='10'  name='fee_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center" ><input type='text' size='9'  name='fee_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center' ><input type='text' size='10'  name='fee_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원 </td>
                    <td align='center'>-</td>
                    <td align="center">-</td>
                    <td align='center'>-</td>
                </tr>    
              <tr>
                <td colspan="2" class='title'>대여료총액</td>
                <td align="center"><input type='text' size='11' name='t_fee_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='t_fee_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='t_fee_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center"><input type='text' name="v_con_mon" value='<%=fees.getCon_mon()%>' size="4" maxlength="2" class='whitenum' onChange='javascript:set_cont_date(this)'>
        			 개월
        			 <%if(!fee_etcs.getCon_day().equals("") && !fee_etcs.getCon_day().equals("0")){%>
        	    <input type='text' name="v_con_day" value='<%=fee_etcs.getCon_day()%>' size="4" maxlength="2" class='whitenum' onChange='javascript:set_cont_date(this)'>
        	                 일
        	                 <%}else{%>
        	                 <input type='hidden' name="v_con_day" value="<%=fee_etcs.getCon_day()%>">      
        	                 <%}%>
        			 </td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td colspan="2" class='title'>배차료</td>
                <td align="center"><input type='text' size='11' name='cons1_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='cons1_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='cons1_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt()+fee_rm.getCons1_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center">
                  <%if(fee_rm.getCons1_yn().equals("N")){%>없음<%}else if(fee_rm.getCons1_yn().equals("Y")){%>있음<%}else{%>-<%}%>                    
    	 	</td>
                <td align='center'>
    			  
                </td>
              </tr>
              <tr>
                <td colspan="2" class='title'>반차료</td>
                <td align="center"><input type='text' size='11' name='cons2_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='cons2_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='cons2_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_s_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center">
                  <%if(fee_rm.getCons2_yn().equals("N")){%>없음<%}else if(fee_rm.getCons2_yn().equals("Y")){%>있음<%}else{%>-<%}%>                    
    	 	</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td colspan="2" class='title'>합계</td>
                <td align="center"><input type='text' size='11' name='rent_tot_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='rent_tot_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='rent_tot_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt()+fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center"> </td>
                <td align='center'>-</td>
              </tr>    
              <tr>                
                <td colspan="2" class='title'><span class="title1">최초결제금액</span></td>
                <td align='center'><input type="text" name="f_rent_tot_amt" value="<%=AddUtil.parseDecimal(fee_rm.getF_rent_tot_amt())%>" size="11" class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원		  
                </td>                
                <td colspan='4'>&nbsp;&nbsp;&nbsp;
                     * 최초결제방식 : <%if(fee_rm.getF_paid_way().equals("1")){%>1개월치<%}else if(fee_rm.getF_paid_way().equals("2")){%>총액<%}else{%>-<%}%>                         
                      &nbsp;&nbsp;&nbsp;
                      반차료 <%if(fee_rm.getF_paid_way2().equals("1")){%>포함<%}else if(fee_rm.getF_paid_way2().equals("2")){%>미포함<%}else{%>-<%}%>                                                   
                      &nbsp;&nbsp;&nbsp;
                      * 예약금 : <input type="text" name="f_con_amt" value="<%=AddUtil.parseDecimal(fee_rm.getF_con_amt())%>" size="11" class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원	
                  
                </td>                
                <td align='center'>-</td>
              </tr>                                              
              <tr>
                <td colspan="2" class='title'><span class="title1">약정운행거리</span></td>
                <td colspan="5">&nbsp;
		  <input type='text' name='agree_dist' size='8' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getAgree_dist())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  km이하/1월,
                  초과 1km당 (<input type='text' name='over_run_amt' size='3' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원)의 추가요금이 부과됩니다.
                </td>
                <td align='center'>-</td>
              </tr>     
			
                <tr>
                    <td colspan="2" class='title'>중도해지위약율</td>
                    <td colspan="2" align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align="center">잔여기간 대여료의
                        <input type='text' size='3' name='cls_r_per' maxlength='10'  class='whitenum' value='<%=fees.getCls_r_per()%>'>
        				  %</td>
                    <td align='center'><font color="#FF0000">
        				<input type='text' size='3' name='cls_per' maxlength='10' class='whitenum' value='<%=fees.getCls_per()%>'>%
			</font></span></td>
                </tr>		  
				<%if(i==1 && fees.getRent_st().equals("1") && base.getRent_st().equals("3")){
					//대차원계약정보
					Hashtable suc_cont = new Hashtable();
					if(!cont_etc.getGrt_suc_l_cd().equals("")){
						suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
					}%>
                <tr>
                    <td colspan="2" class='title'>대차원계약</td>
                    <td colspan="6">&nbsp;
					  [원계약정보]&nbsp;&nbsp;
        			  계약번호 : <input type='text' name='grt_suc_l_cd' size='15' value='<%=cont_etc.getGrt_suc_l_cd()%>' class='whitetext' >
					  &nbsp;차량번호 : <input type='text' name='grt_suc_c_no' size='15' value='<%=cont_etc.getGrt_suc_c_no()%>' class='whitetext' >
					  &nbsp;차종코드별변수 차명 : <%=suc_cont.get("CARS")==null?"":suc_cont.get("CARS")%>
					  &nbsp;
					  <br>
					  &nbsp;
					  <b>[대차보증금승계]</b>
					  &nbsp;기존보증금 : <input type='text' name='grt_suc_o_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' class='whitenum'  readonly>원
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  승계보증금 : <input type='text' name='grt_suc_r_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='whitenum' >원
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  				<font color=red>(약정보증금 차액 <%=AddUtil.parseDecimal(fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>)</font>
					  			<%} %>
        			</td>
                </tr>		
		        <%}%>  	
                <tr>
                    <td colspan="2" class='title'>비고</td>
                    <td colspan="6">&nbsp;<%=HtmlUtil.htmlBR(fees.getFee_cdt())%></td>
                </tr>
            </table>		
	    </td>
    </tr>
    <%}else{//연장%>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title'>구분</td>
                    <td class='title' width='11%'>공급가</td>
                    <td class='title' width='11%'>부가세</td>
                    <td class='title' width='14%'>합계</td>
                    <td class='title' width='4%'>입금</td>			
                    <td width="27%" class='title'>계약조건</td>
                    <td class='title' width='20%'>정상조건</td>
                </tr>                      
                <!--
                <tr>
                    <td rowspan="5" class='title'>월<br>대<br>
                      여<br>
                      료</td>
                    <td class='title'>정상대여료</td>
                    <td align="center" ><input type='text' size='10' name='inv_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center" ><input type='text' size='9' name='inv_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center' ><input type='text' size='10' maxlength='10' name='inv_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원 </td>
                    <td align='center'>-</td>
                    <td align="center">-</td>
                    <td align='center'>-</td>
                </tr>
                <tr>
                    <td class='title'>D/C</td>
                    <td align="center" ><input type='text' size='10' name='dc_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getDc_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center" ><input type='text' size='9' name='dc_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getDc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center' ><input type='text' size='10' maxlength='10' name='dc_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getDc_s_amt()+fee_rm.getDc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원 </td>
                    <td align='center'>-</td>
                    <td align="center">DC율:
                      <input type='text' size='4' name='dc_ra' maxlength='10' class="whitenum" value='<%=fees.getDc_ra()%>'></td>
                    <td align='center'>&nbsp;</td>
                </tr>	
              <tr>
                <td class='title'>내비게이션</td>
                <td align="center"><input type='text' size='11' name='navi_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='navi_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='navi_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt()+fee_rm.getNavi_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center">
                  <%if(fee_rm.getNavi_yn().equals("N")){%>없음<%}else if(fee_rm.getNavi_yn().equals("Y")){%>있음<%}else{%>-<%}%>                  
    	 	</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td class='title'>기타</td>
                <td align="center"><input type='text' size='11' name='etc_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='etc_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='etc_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt()+fee_rm.getEtc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center">
                    <input type='text' size='40' name='etc_cont' class='text' value='<%=fee_rm.getEtc_cont()%>'>
    				  </td>
                <td align='center'>-</td>
              </tr>    
              -->            
                <tr>
                    <td class='title'>월대여료</td>
                    <td align="center" ><input type='text' size='11'  name='fee_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center" ><input type='text' size='11'  name='fee_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center' ><input type='text' size='11'  name='fee_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원 </td>
                    <td align='center'>-</td>
                    <td align="center">-</td>
                    <td align='center'>-</td>
                </tr>           
              <tr>
                <td class='title'>대여료총액</td>
                <td align="center"><input type='text' size='11' name='t_fee_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='t_fee_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='t_fee_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center"><input type='text' name="v_con_mon" value='<%=fees.getCon_mon()%>' size="4" maxlength="2" class='whitenum' onChange='javascript:set_cont_date(this)'>
        			 개월
        	    <input type='text' name="v_con_day" value='<%=fee_etcs.getCon_day()%>' size="4" maxlength="2" class='whitenum' onChange='javascript:set_cont_date(this)'>
        			 일</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td class='title'>배차료</td>
                <td align="center"><input type='text' size='11' name='cons1_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='cons1_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='cons1_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt()+fee_rm.getCons1_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center">
                  <%if(fee_rm.getCons1_yn().equals("N")){%>없음<%}else if(fee_rm.getCons1_yn().equals("Y")){%>있음<%}else{%>-<%}%>                    
    	 	</td>
                <td align='center'>
    			  
                </td>
              </tr>
              <tr>
                <td class='title'>반차료</td>
                <td align="center"><input type='text' size='11' name='cons2_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='cons2_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='cons2_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_s_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center">
                  <%if(fee_rm.getCons2_yn().equals("N")){%>없음<%}else if(fee_rm.getCons2_yn().equals("Y")){%>있음<%}else{%>-<%}%>                    
    	 	</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td class='title'>합계</td>
                <td align="center"><input type='text' size='11' name='rent_tot_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='rent_tot_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='rent_tot_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt()+fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center"> </td>
                <td align='center'>-</td>
              </tr>                          	
                <tr>
                    <td class='title'>비고</td>
                    <td colspan="6">&nbsp;<%=HtmlUtil.htmlBR(fees.getFee_cdt())%></td>
                </tr>
            </table>		
	    </td>
    </tr>    
    <%}%>
    <tr></tr><tr></tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>납입횟수</td>
                    <td width="20%">&nbsp;<%=fees.getFee_pay_tm()%>회 </td>
                    <td width="10%" class='title'>납입일자</td>
                    <td width="20%">&nbsp;<%if(fees.getFee_est_day().equals("98")){%>대여개시일<%}else{%>매월<%if(fees.getFee_est_day().equals("99")){%> 말일 <%}else{%><%=fees.getFee_est_day()%>일<%}%><%}%></td>
                    <td width="10%" class='title'>납입기간</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fees.getFee_pay_start_dt())%>~<%=AddUtil.ChangeDate2(fees.getFee_pay_end_dt())%></td>
                </tr>		  	
                <tr>
                    <td width="13%" class='title'>1회차납입일</td>
                    <td width="20%">&nbsp;<%=AddUtil.ChangeDate2(fees.getFee_fst_dt())%></td>
                    <td width="10%" class='title'>1회차납입액</td>
                    <td colspan="3">&nbsp;<%=AddUtil.parseDecimal(fees.getFee_fst_amt())%>원</td>
                </tr>		  		  		  		  	  		  
            </table>
        </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>			
	<%}%>
	
	<%if(im_vt_size>0){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>임의연장</span> <a href="javascript:view_scan_res2('<%=base.getCar_mng_id()%>','<%=base.getRent_mng_id()%>','<%=base.getRent_l_cd()%>')" onMouseOver="window.status=''; return true"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="임의계약서 보기"></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>			
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td class=title width="13%">연번</td>
                    <td class=title width="20%">회차</td>			
                    <td class=title width="37%">대여기간</td>
                    <td class=title width="15%">등록자</td>
                    <td class=title width="15%">등록일</td>                    
                  </tr>
        		  <%	for(int i = 0 ; i < im_vt_size ; i++){
        					Hashtable im_ht = (Hashtable)im_vt.elementAt(i);%>
                  <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=im_ht.get("ADD_TM")%>회차</td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_END_DT")))%></td>
                    <td align='center'><%=im_ht.get("USER_NM")%></td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("REG_DT")))%>
                    	<%if(AddUtil.parseInt(String.valueOf(im_ht.get("RENT_START_DT"))) > AddUtil.getDate2(4)){ %>
                    	<% 	if(nm_db.getWorkAuthUser("전산팀",user_id)){ %>
                    	<a href="javascript:im_cancel('<%=im_ht.get("RENT_ST")%>','<%=im_ht.get("IM_SEQ")%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_cancel.gif"  align="absmiddle" border="0"></a>
                    	<%	} %>
                    	<%} %>
                    </td>
                  </tr>
        		  <%	} %>
            </table>
        </td>
    </tr>				
    <tr>
        <td class=h></td>
    </tr>			
	<%}%>
		
	<tr id=tr_fee3 style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>">
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>납입방법 <%if(user_id.equals("000000") || base.getBus_id().equals(user_id) || base.getBus_id2().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("회계업무",user_id) || nm_db.getWorkAuthUser("월렌트관리",user_id)){%><a href="javascript:update('pay_way','')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><%}%><font color="#CCCCCC"> ( 회계업무권한 : 납입방법 수정 )</font></span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>					
    <tr id=tr_fee2 style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>수금구분</td>
                    <td width="20%">&nbsp;<%String fee_sh = fee.getFee_sh();%><%if(fee_sh.equals("0")){%>후불<%}else if(fee_sh.equals("1")){%>선불<%}%></td>
                    <td width="10%" class='title'>납부방법</td>
                    <td width="20%">&nbsp;<%String fee_pay_st = fee.getFee_pay_st();%><%if(fee_pay_st.equals("1")){%>자동이체<%}else if(fee_pay_st.equals("2")){%>무통장입금<%}else if(fee_pay_st.equals("3")){%>지로<%}else if(fee_pay_st.equals("4")){%>수금<%}else if(fee_pay_st.equals("5")){%>기타<%}else if(fee_pay_st.equals("6")){%>카드<%}%></td>
        			<td width="10%" class='title'>CMS미실행</td>
        			<td>&nbsp;사유 : <%=fee_etc.getCms_not_cau()%></td>
                </tr>
                <tr>
                    <td class='title'>거치여부</td>
                    <td colspan="3">&nbsp;<%String def_st = fee.getDef_st();%><%if(def_st.equals("N")){%>없음<%}else if(def_st.equals("Y")){%>없음<%}%>
                    &nbsp;&nbsp;&nbsp;&nbsp;사유 : <%=fee.getDef_remark()%></td>
                    <td width="10%" class='title'>결재자</td>
                    <td>&nbsp;<%=c_db.getNameById(fee.getDef_sac_id(),"USER")%></td>
                </tr>
                <tr>
                    <td class='title'>통장입금</td>
                    <td colspan="5">&nbsp;<%=c_db.getNameById(fee.getFee_bank(), "BANK")%></td>
                </tr>
                <tr>
                    <td class='title'>2회차청구구분</td>
                    <td colspan="5">&nbsp;<%String cms_type = f_fee_rm.getCms_type();%><%if(cms_type.equals("card")){%>신용카드<%}else if(cms_type.equals("cms")){%>CMS<%}%></td>
                </tr>
                <!-- CMS 추가 (2018.03.28) -->
                <tr>
                    <td class='title'>CMS</td>
                    <td colspan="5" style="padding: 5px;">
                    	<%if(!cms.getCms_bank().equals("")){%>
							<b><%if(!cms.getCbit().equals("")){%>[<%=cms.getCbit()%>]<%}%></b>
   			 				 <%if(!cms.getApp_dt().equals("")&&cms.getApp_dt()!=null){%>
   			 				 &nbsp; 신청일 : <%=AddUtil.ChangeDate2(cms.getApp_dt())%>
   			 				 <%} %>
   			 			<%}else{%>
   			 			[-]
   			 			<%}%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
    <!-- 자동이체 요청 -->
    
	<tr id=tr_fee3 >
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동이체 <%if(cms.getApp_dt().equals("") || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("CMS관리",user_id) || nm_db.getWorkAuthUser("출금담당",user_id)){%><%if(user_id.equals("000000") || base.getBus_id().equals(user_id) || base.getBus_id2().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("회계업무",user_id) || nm_db.getWorkAuthUser("월렌트관리",user_id)){%><a href="javascript:update('pay_way2','')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><%}%><%}%><font color="#CCCCCC"> ( 회계업무권한 : 납입방법 수정 )</font></span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>					
    <tr id=tr_fee2 > 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>자동이체</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
        			        <tr>
                			    <td>&nbsp;계좌번호 : 
                			      <%=cms.getCms_acc_no()%>
                			      (은행:<%=cms.getCms_bank()%>) </td>
        			        </tr>
        			        <tr>
                			    <td>&nbsp;예 금 주 :&nbsp;<%=cms.getCms_dep_nm()%>			      
                				  &nbsp;&nbsp;
                				  / 결제일자 : 매월 <%=cms.getCms_day()%>일								  
								  </td>
        			        </tr>
        			        <tr>
                			    <td>&nbsp;최초인출일자 : <%=AddUtil.ChangeDate2(cms.getCms_start_dt())%></td>
        			        </tr>	
        			        <tr>
                			    <td>&nbsp;신청일자 : <%=cms.getApp_dt()%></td>
        			        </tr>							
        			    </table>
        			</td>
                </tr>
            </table>
        </td>
    </tr>    
    <tr>
        <td class=h></td>
    </tr>        		
    <!-- 신용카드 자동출금 요청 -->
    
	<tr id=tr_fee3 >
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>신용카드 자동출금 <%if(card_cms.getApp_dt().equals("") || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("CMS관리",user_id) || nm_db.getWorkAuthUser("신용카드자동출금",user_id)){%><%if(user_id.equals("000000") || base.getBus_id().equals(user_id) || base.getBus_id2().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("회계업무",user_id) || nm_db.getWorkAuthUser("월렌트관리",user_id)){%><a href="javascript:update('pay_way3','')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><%}%><%}%><font color="#CCCCCC"> ( 회계업무권한 : 납입방법 수정 )</font></span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>					
    <tr id=tr_fee2 > 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>신용카드 자동출금</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
        			        <tr>
                			    <td>&nbsp;신용카드 : 
                			      <%=card_cms.getCms_acc_no()%>
                			      (카드사:<%=card_cms.getCms_bank()%>) </td>
        			        </tr>
        			        <tr>
                			    <td>&nbsp;카드주 성명 :&nbsp;<%=card_cms.getCms_dep_nm()%>			      
                				  &nbsp;&nbsp;
                				  / 결제일자 : 매월 <%=card_cms.getCms_day()%>일								  
								  </td>
        			        </tr>
        			        <tr>
                			    <td>&nbsp;최초인출일자 : <%=AddUtil.ChangeDate2(card_cms.getCms_start_dt())%></td>
        			        </tr>	
        			        <tr>
                			    <td>&nbsp;신청일자 : <%=card_cms.getApp_dt()%></td>
        			        </tr>							
        			    </table>
        			</td>
                </tr>
            </table>
        </td>
    </tr>    
    <tr>
        <td class=h></td>
    </tr>        		    
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>세금계산서 <%if(base.getBus_id().equals(user_id) || nm_db.getWorkAuthUser("회계업무",user_id) || nm_db.getWorkAuthUser("월렌트관리",user_id)){%><a href="javascript:update('tax','')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><%}%><font color="#CCCCCC"> ( 회계업무권한 : 청구서발행정보 수정 )</font></span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_tax style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>공급받는자</td>
                    <td width="20%">&nbsp;
                      <input type="radio" name="tax_type" value="1" <% if(base.getTax_type().equals("1")) out.print("checked"); %> disabled>
        			    본사
        		      <input type="radio" name="tax_type" value="2" <% if(base.getTax_type().equals("2")) out.print("checked"); %> disabled>
        		    	지점 </td>
                    <td width="10%" class='title' style="font-size : 8pt;">청구서수령방법</td>
                    <td width="20%">&nbsp;<%String rec_st = cont_etc.getRec_st();%><%if(rec_st.equals("1")){%>이메일<%}else if(rec_st.equals("2")){%>우편<%}else if(rec_st.equals("3")){%>수령안함<%}%></td>
                    <td width="10%" class='title' style="font-size : 8pt;">전자세금계산서</td>
                    <td>&nbsp;<%String ele_tax_st = cont_etc.getEle_tax_st();%><%if(ele_tax_st.equals("1")){%>당사시스템<%}else if(ele_tax_st.equals("2")){%>별도시스템<%}%>
                      &nbsp;<%=cont_etc.getTax_extra()%>
        			</td>
                </tr>
                <tr>
                    <td width="13%" class='title'>공급자</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(fee.getBr_id(), "BRCH")%></td>
                    <td width="10%" class='title'>청구구분</td>
                    <td width="20%">&nbsp;<%String fee_st = fee.getFee_st();%><%if(fee_st.equals("0")){%>미정<%}else if(fee_st.equals("1")){%>청구<%}else if(fee_st.equals("2")){%>영수<%}%></td>
                    <td width="10%" class='title'>영수일자</td>
                    <td>&nbsp;<%String rc_day = fee.getRc_day();%><%if(fee.getRc_day().equals("99"))rc_day="말";%><%=rc_day%>일</td>
                </tr>
                <tr>
                    <td width="13%" class='title'>익월여부</td>
                    <td>&nbsp;<input type='checkbox' name='c_next_yn' <%if(fee.getNext_yn().equals("Y")){%>checked<%}%>></td>
                    <td width="10%" class='title'>발행기한</td>
                    <td colspan="3">&nbsp;<%=fee.getLeave_day()%>일</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

	//바로가기
	var s_fm = parent.parent.top_menu.document.form1;
	var fm 		= document.form1;	
	s_fm.auth_rw.value 	= fm.auth_rw.value;
	s_fm.user_id.value 	= fm.user_id.value;
	s_fm.br_id.value 	= fm.br_id.value;		
	s_fm.m_id.value 	= fm.rent_mng_id.value;
	s_fm.l_cd.value 	= fm.rent_l_cd.value;	
	s_fm.c_id.value 	= fm.car_mng_id.value;
	s_fm.client_id.value = fm.client_id.value;
	s_fm.accid_id.value = "";
	s_fm.serv_id.value 	= "";
	s_fm.seq_no.value 	= "";
	

	
//-->
</script>
</body>
</html>
