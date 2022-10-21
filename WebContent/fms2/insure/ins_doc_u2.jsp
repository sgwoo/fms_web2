<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.user_mng.*, acar.res_search.*, tax.*, acar.insur.*, acar.doc_settle.*, acar.car_sche.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ea_bean" class="acar.estimate_mng.EstiCarVarBean" scope="page"/>
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"" :request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String m_id 		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String c_id 		= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String ins_st 		= request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	
	String doc_no 		= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String ins_doc_no   = request.getParameter("ins_doc_no")==null?"":request.getParameter("ins_doc_no");
	String mode   		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "15", "01", "15");
	

	String fee_start_dt 	= "";

	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	InsDatabase ins_db = InsDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	//보험변경
	InsurChangeBean cng_doc = ins_db.getInsChangeDoc(ins_doc_no);
	
	if(!ins_doc_no.equals("") && doc_no.equals("")){
		rent_mng_id 	= cng_doc.getRent_mng_id();
		rent_l_cd 	= cng_doc.getRent_l_cd();
		c_id		= cng_doc.getCar_mng_id();
		ins_st		= cng_doc.getIns_st();
		rent_st		= cng_doc.getRent_st();
		
		doc = d_db.getDocSettleCommi("47", ins_doc_no);
		doc_no = doc.getDoc_no();
	}
	
	if(ins_doc_no.equals("")){
		ins_doc_no = doc.getDoc_id();
		//보험변경
		cng_doc = ins_db.getInsChangeDoc(ins_doc_no);
	}
	
	//기안자
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	
	//보험정보
	ins = ins_db.getInsCase(c_id, ins_st);
	
	
	
	//보험변경리스트
	Vector ins_cha = ins_db.getInsChangeDocList(ins_doc_no);
	int ins_cha_size = ins_cha.size();	
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	
	//1. 고객 ---------------------------
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	
	//2. 자동차 ---------------------------
	
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
	int fee_size = af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	String rent_dt = base.getRent_dt();
	
	if(fee_size > 1) rent_dt = ext_fee.getRent_dt();
	
	//변수기준일자
	String jg_b_dt = edb.getVar_b_dt("jg", rent_dt);
	String em_a_j  = edb.getVar_b_dt("em", rent_dt);
	String ea_a_j  = edb.getVar_b_dt("ea", rent_dt);	

	
	int total_amt = 0;	
	
	
	//잔가변수NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), jg_b_dt);
	
	String a_a = "2";
	if(base.getCar_st().equals("1")) a_a = "2";
	if(base.getCar_st().equals("3")) a_a = "1";
	
	String a_e = ej_bean.getJg_a();
	if(a_e.equals("")) a_e = cm_bean.getS_st();
	
	ea_bean = edb.getEstiCarVarCase(a_e, a_a, "", ea_a_j);
	
	String var_seq = "";
	//공통변수
	if(a_a.equals("1")) var_seq = "92";
	if(a_a.equals("2")) var_seq = "93";
	em_bean = edb.getEstiCommVarCase(a_a, "", em_a_j);
	
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, cng_doc.getRent_st());
	
	
	e_bean = edb.getEstimateHpCase(fee_etc.getBc_est_id());
	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "LC_RENT";
	String content_seq  = "";

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;	
	
	String scan_chk_yn = "Y";	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;
	
	//팝업윈도우 열기
	function ScanOpen(theURL,file_path,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+file_path+""+theURL+""+file_type;		
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj =window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}		
		popObj.location = theURL;
		popObj.focus();			
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();	
	}
		
		
	//리스트
	function list(){
		var fm = document.form1;		
		if(fm.mode.value == 'doc_settle'){
			fm.action = '/fms2/doc_settle/doc_settle_frame.jsp';
		}else{
			fm.action = 'ins_doc_frame.jsp';
		}			
		fm.target = 'd_content';
		fm.submit();
	}	

	
	//고객 보기
	function view_client()
	{
		var fm = document.form1;
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id=<%=base.getClient_id()%>", "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//자동차등록정보 보기
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		
	
	//스캔등록
	function scan_reg(file_st, file_cont){
		window.open("/fms2/lc_rent/reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/car_pur/pur_doc_i.jsp&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&file_st="+file_st+"&file_cont="+file_cont, "SCAN", "left=10, top=10, width=620, height=350, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//스캔관리 보기
	function view_scan(){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, scrollbars=yes");		
	}

	function set_n_ch_amt(){
		var fm = document.form1;
		fm.n_fee_amt.value 	= parseDecimal(toInt(parseDigit(fm.o_fee_amt.value)) + toInt(parseDigit(fm.d_fee_amt.value)));
	}	
			
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;

		if(doc_bit == '2' || doc_bit == '5'){
			if(fm.ins_doc_st.value == ''){ alert('처리구분을 선택하십시오.'); return; }	
		}
		
		var ment = '결재하시겠습니까?';
		
		if(doc_bit == 'u') ment = '수정하시겠습니까?';
		if(doc_bit == 'd') ment = '삭제하시겠습니까?';
		if(doc_bit == 'ch_st1' || doc_bit == 'ch_st2') ment = '변경하시겠습니까?';
		if(doc_bit == 'd_req') ment = '삭제요청하시겠습니까?';
		
		if(confirm(ment)){	
			fm.action='ins_doc_sanction.jsp';		
			fm.target='i_no';
			fm.submit();
		}									
	}
	
	function page_reload(){
		var fm = document.form1;
		fm.action='ins_doc_u.jsp';		
		fm.target='d_content';
		fm.submit();		
	}
	
	
	//변경요청서
	function select_inss(){
		var fm = document.form1;
		window.open('about:blank', "INSDOC_PRINT", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "INSDOC_PRINT";
		fm.action = "ins_doc_print.jsp";
		fm.submit();	
	}	
	//만나이계산하기
	function age_search()
	{
		var fm = document.form1;
		
		window.open("about:blank",'age_search','scrollbars=yes,status=no,resizable=yes,width=360,height=250,left=370,top=200');		
		fm.action = "/fms2/lc_rent/search_age.jsp?mode=EM";
		fm.target = "age_search";
		fm.submit();		
	}		
	
	//기각일대 사유보이기
	function display_reject(){
		var fm = document.form1;
		
		if(fm.ins_doc_st.value =='N' || fm.ins_doc_st.value ==''){ //기각
			tr_reject.style.display	= '';
		}else if(fm.ins_doc_st.value =='Y'){ //승인
			tr_reject.style.display	= 'none';
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
<form action='ins_doc_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1'	 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="m_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_st" 		value="<%=cng_doc.getRent_st()%>">  
  <input type='hidden' name="car_mng_id" 	value="<%=c_id%>">
  <input type='hidden' name="ins_st" 		value="<%=ins_st%>">
  <input type='hidden' name="doc_no"		value="<%=doc_no%>">  
  <input type='hidden' name="ins_doc_no"	value="<%=ins_doc_no%>">    
  <input type='hidden' name="firm_nm"	 	value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="car_no"	 	value="<%=cr_bean.getCar_no()%>">  
  <input type='hidden' name="mode"		value="<%=mode%>">      
  <input type='hidden' name="from_page" 	value="/fms2/insure/ins_doc_u.jsp">             
  <input type='hidden' name='doc_bit' 		value=''>   
  <input type='hidden' name='o_est_id' 		value='<%=e_bean.getEst_id()%>'>     
  <input type='hidden' name='ch_cd' 		value='<%=cng_doc.getIns_doc_no()%>'>       
  <input type='hidden' name='car_st' 		value='<%=base.getCar_st()%>'>       
  
       
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>전자문서 > 문서기안 > <span class=style5>보험변경문서</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
	<td class=h></td>
    </tr>
    <tr>
	<td align="right"><%if(!mode.equals("view")){%><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a><%}%></td></td>
    <tr> 	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>계약번호</td>
                    <td width=25%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>용도/관리</td>
                    <td width=15%>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("5")){%>업무대여<%}%>
				  &nbsp;<%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}%>
		    </td>
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
                    <td class=title width=10%>보험기간</td>
                    <td width=25%>&nbsp;<%=AddUtil.ChangeDate2(ins.getIns_start_dt())%>~<%=AddUtil.ChangeDate2(ins.getIns_exp_dt())%></td>									
                    <td class=title width=10%>보험회사</td>
                    <td width=15%>&nbsp;<%=c_db.getNameById(ins.getIns_com_id(), "INS_COM")%></td>
                    <td class=title width=10%>보험종류</td>
                    <td>&nbsp; 
                        <%if(ins.getCar_use().equals("1")){%>영업용<%}%>
                        <%if(ins.getCar_use().equals("2")){%>업무용<%}%>
    			<%if(ins.getCar_use().equals("3")){%>개인용<%}%>
                    &nbsp;<a href="javascript:age_search();"><img src=/acar/images/center/button_in_mnigs.gif border=0 align=absmiddle></a></td>										
                </tr>				
            </table>
        </td>
    </tr>
    <tr>
	<td class=h></td>
    </tr>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험변경</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10% rowspan="2">연번</td>
                    <td class=title width=30% rowspan="2">변경항목</td>
                    <td class=title colspan="2">계약정보</td>
                </tr>
                <tr> 
                    <td class=title width=30%>변경전</td>
                    <td class=title width=30%>변경후</td>
                </tr>
                <%for(int i = 0 ; i < ins_cha_size ; i++){
			InsurChangeBean cha = (InsurChangeBean)ins_cha.elementAt(i);
					
			if(cha.getCh_after().equals("고객피보험자 갱신") || cha.getCh_item().equals("16"))	scan_chk_yn = "N";
		%>
                <tr align="center"> 
                    <td><%=i+1%> 
                        <input type='hidden' name='ch_tm' value='<%=cha.getCh_tm()%>'>
                    </td>
                    <td>
        	        <select name="ch_item" disabled>
            	            <option value="10" <%if(cha.getCh_item().equals("10")){%>selected<%}%>>대인2가입금액</option>
            	            <option value="1" <%if(cha.getCh_item().equals("1")){%>selected<%}%>>대물가입금액</option>
        	            <option value="2" <%if(cha.getCh_item().equals("2")){%>selected<%}%>>자기신체사고가입금액(사망/장애)</option>
			    <option value="12" <%if(cha.getCh_item().equals("12")){%>selected<%}%>>자기신체사고가입금액(부상)</option>
        	            <option value="7" <%if(cha.getCh_item().equals("7")){%>selected<%}%>>대물+자기신체사고가입금액</option>			  
                	    <option value="3" <%if(cha.getCh_item().equals("3")){%>selected<%}%>>무보험차상해특약</option>
                	    <option value="4" <%if(cha.getCh_item().equals("4")){%>selected<%}%>>자기차량손해가입금액</option>			  
                	    <option value="9" <%if(cha.getCh_item().equals("9")){%>selected<%}%>>자기차량손해자기부담금</option>			  			  			  
            	            <option value="5" <%if(cha.getCh_item().equals("5")){%>selected<%}%>>연령변경</option>		  
                	    <option value="6" <%if(cha.getCh_item().equals("6")){%>selected<%}%>>애니카특약</option>			  			  
                	    <option value="8" <%if(cha.getCh_item().equals("8")){%>selected<%}%>>차종변경</option>			  			  			  
                	    <option value="11" <%if(cha.getCh_item().equals("11")){%>selected<%}%>>차량대체</option>			  
                	    <option value="14" <%if(cha.getCh_item().equals("14")){%>selected<%}%>>임직원한정운전특약</option>
                	    <option value="17" <%if(cha.getCh_item().equals("17")){%>selected<%}%>>블랙박스</option>
                	    <option value="15" <%if(cha.getCh_item().equals("15")){%>selected<%}%>>피보험자변경</option>
                	    <option value="16" <%if(cha.getCh_item().equals("16")){%>selected<%}%>>고객피보험자 보험갱신</option>
                	    <option value="13" <%if(cha.getCh_item().equals("13")){%>selected<%}%>>기타</option>
        	        </select>			
                    </td>
                    <td>
                        <input type='text' size='40' name='ch_before' class='whitetext' value='<%=cha.getCh_before()%>'>
                    </td>					
                    <td>
                        <input type='text' size='40' name='ch_after' class='whitetext' value='<%=cha.getCh_after()%>'>
                    </td>
                </tr>		  
                <%}%>
            </table>
        </td>
    </tr>	
    <tr>
        <td align=right>* 최초등록일 : <%=AddUtil.ChangeDate2(cng_doc.getReg_dt())%></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>            
                <tr> 
                    <td width='10%' class='title'>등록구분</td>
                    <td>&nbsp;<%if(cng_doc.getCh_st().equals("2")){%>견적<%}else{%>반영<%}%></td>
                </tr>
                <tr> 
                    <td width='10%' class='title'>변경일자</td>
                    <td>&nbsp;<input type='text' name='cng_dt' size='11' value='<%=AddUtil.ChangeDate2(cng_doc.getCh_dt())%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 24시 </td>
                </tr>
                <tr> 
                    <td width='10%' class='title'>변경담보유효기간</td>
                    <td>&nbsp;<input type='text' name='cng_s_dt' size='11' value='<%=AddUtil.ChangeDate2(cng_doc.getCh_s_dt())%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> ~ <input type='text' name='cng_e_dt' size='10' value='<%=AddUtil.ChangeDate2(cng_doc.getCh_e_dt())%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> </td>
                </tr>                
                <tr> 
                    <td class='title'>사유 및 특이사항</td>
                    <td>&nbsp;<textarea name="cng_etc" cols="100" class="text" style="IME-MODE: active" rows="5"><%=cng_doc.getCh_etc()%></textarea></td>
                </tr>
                <%if(!cng_doc.getCh_st().equals("2")){%>                                
                <tr> 
                    <td width='10%' class='title'>보험변경요청서</td>
                    <td>&nbsp;
                    	<%
				content_code = "LC_SCAN";
				content_seq  = rent_mng_id+""+rent_l_cd+"1"+"21";

				attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "21", 0);		
				attach_vt_size = attach_vt.size();	
				
				int scan_cnt = 0;
                    	%>
                    	
			<%if(attach_vt_size > 0){%>
			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    					Hashtable ht = (Hashtable)attach_vt.elementAt(j); 
    								    								
					//등록일과 완료일 사이의 스캔만 가져온다.	
    					if(AddUtil.parseInt(cng_doc.getReg_dt()) > AddUtil.parseInt(String.valueOf(ht.get("REG_DT")))) continue; 
    								
    					if(!doc.getVar01().equals("") && AddUtil.parseInt(doc.getVar01()) < AddUtil.parseInt(String.valueOf(ht.get("REG_DT")))) continue; 
    								    								
  					scan_cnt++;				
    			%>
    			&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
    			&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
    			<%	}%>
    			<%}%>
    			
    			<%if(scan_cnt>0){%>		
    			<input type='hidden' name='scan_yn' value='Y'>        
    			<%}else{%>      
    			<input type='hidden' name='scan_yn' value='N'>        
        		<span class="b"><a href="javascript:scan_reg('21', '<%=cng_doc.getIns_doc_no()%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_scan_reg.gif align=absmiddle border=0></a></span>
			&nbsp;&nbsp;* 스캔파일을 등록하고나서 이 페이지를 <a href="javascript:page_reload()">새로고침</a> 해주세요 						
			&nbsp;&nbsp;<a href="javascript:select_inss()" onMouseOver="window.status=''; return true" title="클릭하세요">[양식보기]</a>												
    			<%}%>
    			
			&nbsp;&nbsp;<a href="javascript:view_scan()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a>
		    </td>
                </tr>		
		<%}%>		
		
                <tr> 
                    <td class='title' width="10%">처리구분</td>
                    <td>&nbsp;
                        <select name='ins_doc_st'  class='default' onchange="javascript:display_reject();">
                            <option value="">선택</option>
			    <option value="Y" <%if(cng_doc.getIns_doc_st().equals("Y"))%>selected<%%>>승인</option>
			    <option value="N" <%if(cng_doc.getIns_doc_st().equals("N"))%>selected<%%>>기각</option>
                        </select>
		    </td>
                </tr>				
                <tr id=tr_reject style="display:<%if(cng_doc.getIns_doc_st().equals("N")){%>''<%}else{%>none<%}%>"> 
                    <td class='title' width="10%">기각사유</td>
                    <td>&nbsp;<textarea cols="100" rows="5" name="reject_cau"><%=cng_doc.getReject_cau()%></textarea></td>
                </tr>										
            </table>
        </td>
    </tr>	
    <tr>
	<td>* 변경담보유효기간 종료 3일전에는 담당자(기안자)에게 종료예정임을 사내메신저로 통보할 예정입니다. 담당자는 변경내용의 연장 여부 등을 반드시 보험관리담당자에게 문서로 제출해야만 합니다.</td>
    </tr>		    
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여료스케줄 반영</span></td>
    </tr>
    <%if(!base.getCar_st().equals("2")){%>	
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>월반영금액</td>
                    <td>&nbsp;
        		월 <input type='text' name='d_fee_amt' size='10' value='<%=AddUtil.parseDecimal(cng_doc.getD_fee_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value); set_n_ch_amt();'>원씩 증감
			&nbsp;&nbsp;(vat포함)
		    </td>
                </tr>
                <tr> 
                    <td width='10%' class='title'>월대여료</td>
                    <td>&nbsp;
        		[변경전] <input type='text' name='o_fee_amt' size='10' value='<%=AddUtil.parseDecimal(cng_doc.getO_fee_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value); set_n_ch_amt();'>원
			->
			[변경후] <input type='text' name='n_fee_amt' size='10' value='<%=AddUtil.parseDecimal(cng_doc.getN_fee_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value); set_n_ch_amt();'>원
			&nbsp;&nbsp;(vat포함)
		    </td>
                </tr>				
            </table>
        </td>
    </tr>	
    <%}else{%>
	<input type='hidden' name="d_fee_amt" 	value="<%=cng_doc.getD_fee_amt()%>">
	<input type='hidden' name="o_fee_amt" 	value="<%=cng_doc.getO_fee_amt()%>">
	<input type='hidden' name="n_fee_amt" 	value="<%=cng_doc.getN_fee_amt()%>">
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td>&nbsp;* 예비차입니다. 대여료 스케줄 반영분은 없습니다.</td>
                </tr>
            </table>
        </td>
    </tr>		
    <%}%>	
    <tr>
        <td>doc_id : <%=doc.getDoc_id()%>&nbsp;</td>
    </tr>
    <%if(!cng_doc.getCh_st().equals("2")){%>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10% rowspan="2">결재</td>
                    <td class=title width=15%>지점명</td>
                    <td class=title width=15%><%=doc.getUser_nm1()%></td>
                    <td class=title width=15%><%=doc.getUser_nm2()%></td>
                    <td class=title width=15%><%=doc.getUser_nm3()%></td>
                    <td class=title width=15%><%=doc.getUser_nm4()%></td>
                    <td class=title width=15%></td>			
        	    </tr>	
                <tr> 
                    <td align="center" style='height:44'><%=user_bean.getBr_nm()%></td>
                    <td align="center">
			<!--기안자-->
			<%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%>
        		<%if(doc.getUser_dt1().equals("") && !cng_doc.getIns_doc_st().equals("N")){
        			String user_id1 = doc.getUser_id1();
        			CarScheBean cs_bean = csd.getCarScheTodayBean(user_id1);
        			if(!cs_bean.getWork_id().equals(""))	user_id1 = cs_bean.getWork_id();
        		%>
        		<%	if(doc.getUser_id1().equals(user_id) || user_id1.equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("보험담당",user_id)){%>
        		<a href="javascript:doc_sanction('1')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        		<%	}%>
        		<br>&nbsp;
        		<%}%>
		    </td>
            <td align="center">
            	<%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%>
				<!--영업부팀장-->
				<% if(!doc.getUser_nm5().equals("사후")){ %>
					<%if(doc.getUser_dt2().equals("") && !cng_doc.getIns_doc_st().equals("N")){
        			String user_id2 = doc.getUser_id2();
        			CarScheBean cs_bean = csd.getCarScheTodayBean(user_id2);
        			if(!cs_bean.getWork_id().equals(""))	user_id2 = cs_bean.getWork_id();
        		%>
        		<%	if(doc.getUser_id2().equals(user_id) || user_id2.equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사영업팀장",user_id) || nm_db.getWorkAuthUser("본사영업부팀장",user_id)){%>
        			<a href="javascript:doc_sanction('2')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        		<%	}else if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("보험담당",user_id)){%>
        			<a href="javascript:doc_sanction('5')"><img src="/acar/images/center/button_gj_sh.gif" align="absmiddle" border="0"></a>
        		<%}%>
        		<br>&nbsp;
        		<%}%>
				<%}else{ %>
				
				<%} %>
				
        	
     			<br>&nbsp;
		    </td>
                    <td align="center">
			<!--영업팀장->스케줄담당자-->
        		<br>&nbsp;
		    </td>
                    <td align="center"></td>
                    <td align="center"></td>			
        	</tr>	
            </table>
	</td>
    </tr>  	 
    <%}%>
    
    <%if(!mode.equals("view")){%> 				
    <%		if(doc.getUser_id1().equals(user_id) || doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("보험담당",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id) || nm_db.getWorkAuthUser("해지관리자",user_id)){%>
    <tr>
	<td class=h></td>
    </tr>		
    <tr>
	<td align="right">
		
		
		
		
	    <a href="javascript:doc_sanction('u');"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
		  		  
	    
		<%if(nm_db.getWorkAuthUser("전산팀",user_id)||nm_db.getWorkAuthUser("보험업무",user_id) || doc.getUser_id2().equals(user_id)){%>
	    &nbsp;&nbsp;&nbsp;
	    <a href="javascript:doc_sanction('d');"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>
	    <%}else{%>
	    <%		if((cng_doc.getCh_st().equals("2") && doc.getUser_id1().equals(user_id)) || (cng_doc.getCh_st().equals("1") && doc.getUser_id1().equals(user_id) && doc.getUser_dt1().equals(""))){//견적은 등록자 삭제권한%>
	    &nbsp;&nbsp;&nbsp;
	    <a href="javascript:doc_sanction('d');"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>
	    <%		} %>
	    <%		if(cng_doc.getCh_st().equals("1") && doc.getUser_id1().equals(user_id) && !doc.getUser_dt1().equals("") && !doc.getDoc_step().equals("3")){//반영은 삭제요청%>
	    &nbsp;&nbsp;&nbsp;
	    <input type="button" class="button" value="삭제요청" onclick="javascript:doc_sanction('d_req');">	    
	    <%		} %>
	    <%} %>
	    	    
	    
		  
		  
	    <%if(nm_db.getWorkAuthUser("전산팀",user_id) && cng_doc.getCh_st().equals("1")){%> 			  
	    &nbsp;&nbsp;&nbsp;
	    <a href="javascript:doc_sanction('ch_st2');">[견적으로 변경]</a>		  
	    <%}%>

	    <%if(cng_doc.getCh_st().equals("2") && doc.getDoc_step().equals("3")){%> 	
	    &nbsp;&nbsp;&nbsp;
	    <a href="javascript:doc_sanction('ch_st1');">[반영으로 변경]</a>
	    <%}%>

	</td>
    </tr>	
    <%		}%>	
    <%}%>	
<input type='hidden' name="scan_chk_yn"		value="<%=scan_chk_yn%>">      	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	function replaceRound(per, st){
		return Math.round(per/st)*st;
	}

	var fm = document.form1;
	var d_fee_s_amt = 0;
	<%if(doc.getUser_dt1().equals("") && cng_doc.getD_fee_amt() == 0){%>
	<%		for(int i = 0 ; i < ins_cha_size ; i++){
				InsurChangeBean cha = (InsurChangeBean)ins_cha.elementAt(i);%>	
				
				<%if(cha.getCh_item().equals("1")){//대물가입금액%>
				
						if('<%=cha.getCh_before()%>' == '1억원' && '<%=cha.getCh_after()%>' == '2억원'){
							d_fee_s_amt = d_fee_s_amt+3000;
						}
						if('<%=cha.getCh_before()%>' == '1억원' && '<%=cha.getCh_after()%>' == '3억원'){
							d_fee_s_amt = d_fee_s_amt+6000;
						}
						if('<%=cha.getCh_before()%>' == '1억원' && '<%=cha.getCh_after()%>' == '5억원'){
							d_fee_s_amt = d_fee_s_amt+12000;
						}
						
						if('<%=cha.getCh_before()%>' == '2억원' && '<%=cha.getCh_after()%>' == '1억원'){
							d_fee_s_amt = d_fee_s_amt+(-3000);
						}
						if('<%=cha.getCh_before()%>' == '2억원' && '<%=cha.getCh_after()%>' == '3억원'){
							d_fee_s_amt = d_fee_s_amt+3000;
						}
						if('<%=cha.getCh_before()%>' == '2억원' && '<%=cha.getCh_after()%>' == '5억원'){
							d_fee_s_amt = d_fee_s_amt+9000;
						}
						
						if('<%=cha.getCh_before()%>' == '3억원' && '<%=cha.getCh_after()%>' == '1억원'){
							d_fee_s_amt = d_fee_s_amt+(-6000);
						}
						if('<%=cha.getCh_before()%>' == '3억원' && '<%=cha.getCh_after()%>' == '2억원'){
							d_fee_s_amt = d_fee_s_amt+(-3000);
						}
						if('<%=cha.getCh_before()%>' == '3억원' && '<%=cha.getCh_after()%>' == '5억원'){
							d_fee_s_amt = d_fee_s_amt+6000;
						}

						if('<%=cha.getCh_before()%>' == '5억원' && '<%=cha.getCh_after()%>' == '1억원'){
							d_fee_s_amt = d_fee_s_amt+(-12000);
						}
						if('<%=cha.getCh_before()%>' == '5억원' && '<%=cha.getCh_after()%>' == '2억원'){
							d_fee_s_amt = d_fee_s_amt+(-9000);
						}
						if('<%=cha.getCh_before()%>' == '5억원' && '<%=cha.getCh_after()%>' == '3억원'){
							d_fee_s_amt = d_fee_s_amt+(-6000);
						}

				<%}%>
				
				<%if(cha.getCh_item().equals("5")){//연령변경%>
				
					//신차소비차가 기준 20190515
					var car_price 	= <%=car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()%>;

					if(car_price > 0){
						var oa_c = <%=em_bean.getOa_c()%>/100;
						var oa_d = <%=ea_bean.getOa_d()%>;
						var k_tu = <%=ea_bean.getK_tu()%>/100;
						var k_pu = <%=ea_bean.getK_pu()%>;
						var jg_z = <%=ej_bean.getJg_z()%>;
						var amt  = ( car_price * k_tu ) + k_pu; //26->21
						
						//수입차
						if('<%=ej_bean.getJg_w()%>' == '1'){
							amt  = ( car_price * k_tu * jg_z) + k_pu;
						}
																								
						var amt24 = amt*0.4;                   //26->24
						
						
						if('<%=cha.getCh_before()%>' == '26세이상' && '<%=cha.getCh_after()%>' == '21세이상'){
							d_fee_s_amt = d_fee_s_amt+amt;
						}
						if('<%=cha.getCh_before()%>' == '26세이상' && '<%=cha.getCh_after()%>' == '24세이상'){
							d_fee_s_amt = d_fee_s_amt+amt24;
						}
						
						if('<%=cha.getCh_before()%>' == '24세이상' && '<%=cha.getCh_after()%>' == '21세이상'){
							d_fee_s_amt = d_fee_s_amt+(amt-amt24);
						}						
						if('<%=cha.getCh_before()%>' == '24세이상' && '<%=cha.getCh_after()%>' == '26세이상'){
							d_fee_s_amt = d_fee_s_amt+(-amt24);
						}				
						
						if('<%=cha.getCh_before()%>' == '21세이상' && '<%=cha.getCh_after()%>' == '24세이상'){
							d_fee_s_amt = d_fee_s_amt+(-(amt-amt24));
						}														
						if('<%=cha.getCh_before()%>' == '21세이상' && '<%=cha.getCh_after()%>' == '26세이상'){
							d_fee_s_amt = d_fee_s_amt+(-amt);
						}						

					}
				<%}%>
				
				d_fee_s_amt = Math.round(d_fee_s_amt);
				d_fee_s_amt = replaceRound(d_fee_s_amt,1000);
				fm.d_fee_amt.value 	= parseDecimal(Math.round(d_fee_s_amt * 1.1));		
				set_n_ch_amt()	
	<%		}%>
	<%}%>
	
	<%if(from_page.equals("/fms2/insure/ins_doc_reg_c_a.jsp")){%>
		doc_sanction('amt_set');
	<%}%>
	
	
	
//-->
</script>
</body>
</html>
