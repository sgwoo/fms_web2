<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.user_mng.*, acar.res_search.*, tax.*, acar.insur.*, acar.doc_settle.*, acar.car_sche.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ins" 	class="acar.insur.InsurBean" 			scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String fee_start_dt 	= "";
	
	String m_id 		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String c_id 		= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String ins_st 		= request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	
	String doc_no 		= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String ins_doc_no   	= request.getParameter("ins_doc_no")==null?"":request.getParameter("ins_doc_no");
	String mode   		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "15", "01", "15");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	InsDatabase ins_db = InsDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	//보험변경
	InsurChangeBean cng_doc = ins_db.getInsChangeDoc(ins_doc_no);
	
	//보험변경리스트
	Vector ins_cha = ins_db.getInsChangeDocList(ins_doc_no);
	int ins_cha_size = ins_cha.size();
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
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
	int fee_size = af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//보험정보
	ins = ins_db.getInsCase(c_id, ins_st);
	
	
	//기안자
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	
	
	int total_amt = 0;	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "LC_RENT";
	String content_seq  = "";

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;	
	
	

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


	
	function set_t_ch_amt(){
		var fm = document.form1;
		var t_amt = 0;

		<%for(int i = 0 ; i < ins_cha_size ; i++){%>
		<%	if(ins_cha_size > 1){%>
				t_amt = t_amt + toInt(parseDigit(fm.ch_amt[<%=i%>].value))
		<%	}else{%>
				t_amt = t_amt + toInt(parseDigit(fm.ch_amt.value))
		<%	}%>
		<%}%>
		fm.t_ch_amt.value = parseDecimal(t_amt);

	}
	
	function set_n_ch_amt(){
		var fm = document.form1;
		fm.n_fee_amt.value 	= parseDecimal(toInt(parseDigit(fm.o_fee_amt.value)) + toInt(parseDigit(fm.d_fee_amt.value)));
	}	
				
	//보험료 합계 셋팅
	function set_tot(){
		var fm = document.form1;
		//책임
		var tot_amt1 = fm.rins_pcp_amt.value;	
		//임의
		var tot_amt2 = parseDecimal(toInt(parseDigit(fm.vins_pcp_amt.value))+
											toInt(parseDigit(fm.vins_gcp_amt.value))+
											toInt(parseDigit(fm.vins_bacdt_amt.value))+
											toInt(parseDigit(fm.vins_canoisr_amt.value))+
											toInt(parseDigit(fm.vins_share_extra_amt.value))+
											toInt(parseDigit(fm.vins_cacdt_cm_amt.value))+
											toInt(parseDigit(fm.vins_spe_amt.value)));
		//계
		fm.tot_amt12.value = parseDecimal(toInt(parseDigit(tot_amt1)) + toInt(parseDigit(tot_amt2)));		
	}	
				
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;

		
		<%if(!doc.getUser_dt2().equals("") && !base.getCar_st().equals("2")){%>
		if(doc_bit == '3'){
			//if(fm.t_ch_amt.value == '' || fm.t_ch_amt.value == '0')	{	alert('추징보험료를 입력하십시오.');			return;	}
			//if(fm.d_fee_amt.value == '' || fm.d_fee_amt.value == '0')	{	alert('대여료스케줄 월반영금액를 입력하십시오.');		return;	}
			//if(fm.n_fee_amt.value == '' || fm.n_fee_amt.value == '0')	{	alert('변경후 대여료금액을 입력하십시오.');			return;	}			
		}
		<%}%>
		
		if(doc_bit == '3'){
			if(fm.ins_doc_st.value == ''){ alert('처리구분을 선택하십시오.'); return; }	
			if(fm.i_inschange_cng_yn.checked==true){fm.i_inschange_cng_yn_2.value='Y'};
			if(fm.i_inschange_cng_yn.checked==false){fm.i_inschange_cng_yn_2.value='N'};
			if(fm.i_insamt_cng_yn.checked==true){fm.i_insamt_cng_yn_2.value='Y'};
			if(fm.i_insamt_cng_yn.checked==false){fm.i_insamt_cng_yn_2.value='N'};
			
		
		}		
		
		var ment = '결재하시겠습니까?';
		
		if(doc_bit == 'u') ment = '수정하시겠습니까?';
		if(doc_bit == 'd') ment = '삭제하시겠습니까?';		
		if(doc_bit == 'd_req') ment = '삭제요청하시겠습니까?';
		
		if(confirm(ment)){	
			fm.action='ins_doc_sanction2.jsp';		
			fm.target='i_no';
//			fm.target='_blank';
			fm.submit();
		}									
	}
	
	
	function page_reload(){
		var fm = document.form1;
		fm.action='ins_doc_u2.jsp';		
		fm.target='d_content';
		fm.submit();		
	}
	
	//기각일대 사유보이기
	function display_reject(){
		var fm = document.form1;
		
		if(fm.ins_doc_st.value =='N' || fm.ins_doc_st.value ==''){ //기각
			tr_reject.style.display	= '';
			
			tr_cng0.style.display	= 'none';
			tr_cng1.style.display	= 'none';
			tr_cng2.style.display	= 'none';
			tr_cng3.style.display	= 'none';
			tr_cng4.style.display	= 'none';
			tr_cng5.style.display	= 'none';
			tr_cng6.style.display	= 'none';
			<%if(base.getCar_st().equals("1") || base.getCar_st().equals("3") || base.getCar_st().equals("5")){%>
			tr_cng7.style.display	= 'none';
			tr_cng8.style.display	= 'none';
			tr_cng9.style.display	= 'none';
			tr_cng10.style.display	= 'none';
			<%}%>
			
			
		}else if(fm.ins_doc_st.value =='Y'){ //승인
			tr_reject.style.display	= 'none';
			
			tr_cng0.style.display	= '';
			tr_cng1.style.display	= '';
			tr_cng2.style.display	= '';
			tr_cng3.style.display	= '';
			tr_cng4.style.display	= '';
			tr_cng5.style.display	= '';
			tr_cng6.style.display	= '';
			<%if(base.getCar_st().equals("1") || base.getCar_st().equals("3") || base.getCar_st().equals("5")){%>
			tr_cng7.style.display	= '';
			tr_cng8.style.display	= '';
			tr_cng9.style.display	= '';
			tr_cng10.style.display	= '';
			<%}%>
			
			
		}
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
  <input type='hidden' name="from_page" 	value="/fms2/insure/ins_doc_u2.jsp">             
  <input type='hidden' name='doc_bit' 		value=''>     
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
                    <td>&nbsp;<a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=client.getFirm_nm()%> <%=site.getR_site()%></a></td>
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
                   &nbsp;<a href="javascript:age_search();"><img src=/acar/images/center/button_in_mnigs.gif border=0 align=absmiddle></a> </td>										
                </tr>				
            </table>
	    </td>
    </tr>
    <tr>
	<td class=h></td>
    </tr>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험변경</span> <input type="checkbox" name="i_inschange_cng_yn" value="Y" checked> 보험변경사항 반영</td>
        <input type="hidden" name="i_inschange_cng_yn_2" value="Y">
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=3% rowspan="2">연번</td>
                    <td class=title width=25% rowspan="2">변경항목</td>
                    <td class=title colspan="2">계약정보</td>
                    <td class=title width=12% rowspan="2">추징보험료</td>                    
                </tr>
                <tr> 
                    <td class=title width=30%>변경전</td>
                    <td class=title width=30%>변경후</td>
                </tr>
                <%for(int i = 0 ; i < ins_cha_size ; i++){
			InsurChangeBean cha = (InsurChangeBean)ins_cha.elementAt(i);										
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
                        <input type='text' size='40' name='ch_before' class='text' value='<%=cha.getCh_before()%>'>
                    </td>					
                    <td>
                        <input type='text' size='40' name='ch_after' class='text' value='<%=cha.getCh_after()%>'>
                    </td>
                    <td> 
                        <input type='text' size='10' name='ch_amt' class='num' value='<%=Util.parseDecimal(cha.getCh_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_t_ch_amt();'>
                        원
                    </td>
                </tr>		  
                <%	total_amt = total_amt + cha.getCh_amt();
		  }
		%>		
                <tr align="center"> 
                    <td class=title>&nbsp;</td>
                    <td class=title>계</td>
                    <td class=title>&nbsp;</td>
                    <td class=title>&nbsp;</td>
                    <td class=title><input type='text' size='10' name='t_ch_amt' class='whitenum' value='<%=Util.parseDecimal(total_amt)%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원
                    </td>                
                </tr>						
            </table>
        </td>
    </tr>	
    <tr>
        <td align=right>* 최초등록일 : <%=AddUtil.ChangeDate2(cng_doc.getReg_dt())%></td>
    </tr>
    <tr>
	<td class=h></td>
    </tr>	
    <tr id=tr_cng0 style="display:'none'"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동차보험 담보변경분 반영</span><input type="checkbox" name="i_carinschange_cng_yn" value="Y" checked> 자동차보험 담보변경분 반영</td>
    </tr>
    <tr id=tr_cng1 style="display:'none'">
        <td class=line2></td>
    </tr>
    <%	int i_cnt = 0; %>	     	    	     
    <tr id=tr_cng2 style="display:'none'"> 
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=3% rowspan="2">연번</td>
                    <td class=title width=3% rowspan="2">선택</td>
                    <td class=title width=22% rowspan="2">변경항목</td>
                    <td class=title colspan="2">보험정보</td>                    
                </tr>
                <tr> 
                    <td class=title width=30%>변경전</td>
                    <td class=title width=30%>변경후</td>
                </tr>
                <%
                	for(int i = 0 ; i < ins_cha_size ; i++){
				InsurChangeBean cha = (InsurChangeBean)ins_cha.elementAt(i);	
		%>	
		<%		if(cha.getCh_item().equals("5")){
					i_cnt++;
		%>
                <tr align="center"> 
                    <td><%=i_cnt%></td>
                    <td align='center'><input type="checkbox" name="i_ch_cd" value="<%=i_cnt-1%>" checked></td>
                    <td>연령변경<input type='hidden' name='i_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <select name='v_age_scp' disabled>
                            <option value='1' <%if(ins.getAge_scp().equals("1")){%>selected<%}%>>21세이상</option>
                            <option value='4' <%if(ins.getAge_scp().equals("4")){%>selected<%}%>>24세이상</option>
                            <option value='2' <%if(ins.getAge_scp().equals("2")){%>selected<%}%>>26세이상</option>
                            <option value='3' <%if(ins.getAge_scp().equals("3")){%>selected<%}%>>전연령</option>                            
                            <option value='5' <%if(ins.getAge_scp().equals("5")){%>selected<%}%>>30세이상</option>				
                            <option value='6' <%if(ins.getAge_scp().equals("6")){%>selected<%}%>>35세이상</option>				
                            <option value='7' <%if(ins.getAge_scp().equals("7")){%>selected<%}%>>43세이상</option>
			    <option value='8' <%if(ins.getAge_scp().equals("8")){%>selected<%}%>>48세이상</option>												
                        </select>
                    </td>					
                    <td>
                        <select name='age_scp'>
                            <option value='1' <%if(cha.getCh_after().equals("21세이상")){%>selected<%}%>>21세이상</option>
                            <option value='4' <%if(cha.getCh_after().equals("24세이상")){%>selected<%}%>>24세이상</option>
                            <option value='2' <%if(cha.getCh_after().equals("26세이상")){%>selected<%}%>>26세이상</option>
                            <option value='3' <%if(cha.getCh_after().equals("전연령")){  %>selected<%}%>>전연령</option>                            
                            <option value='5' <%if(cha.getCh_after().equals("30세이상")){%>selected<%}%>>30세이상</option>				
                            <option value='6' <%if(cha.getCh_after().equals("35세이상")){%>selected<%}%>>35세이상</option>				
                            <option value='7' <%if(cha.getCh_after().equals("43세이상")){%>selected<%}%>>43세이상</option>
			    <option value='8' <%if(cha.getCh_after().equals("48세이상")){%>selected<%}%>>48세이상</option>												
                        </select>                                            
                    </td>
                </tr>		  		
		<%		}%>
		<%		if(cha.getCh_item().equals("1")){
					i_cnt++;
		%>
                <tr align="center"> 
                    <td><%=i_cnt%></td>
                    <td align='center'><input type="checkbox" name="i_ch_cd" value="<%=i_cnt-1%>" checked></td>
                    <td>대물가입금액<input type='hidden' name='i_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <select name='v_vins_gcp_kd' disabled>
                            <option value='6' <%if(ins.getVins_gcp_kd().equals("6")){%>selected<%}%>>5억원</option>
			    <option value='8' <%if(ins.getVins_gcp_kd().equals("8")){%>selected<%}%>>3억원</option>
			    <option value='7' <%if(ins.getVins_gcp_kd().equals("7")){%>selected<%}%>>2억원</option>
                            <option value='3' <%if(ins.getVins_gcp_kd().equals("3")){%>selected<%}%>>1억원</option>						
                            <option value='4' <%if(ins.getVins_gcp_kd().equals("4")){%>selected<%}%>>5000만원</option>
                            <option value='1' <%if(ins.getVins_gcp_kd().equals("1")){%>selected<%}%>>3000만원</option>
                            <option value='2' <%if(ins.getVins_gcp_kd().equals("2")){%>selected<%}%>>1500만원</option>
                            <option value='5' <%if(ins.getVins_gcp_kd().equals("5")){%>selected<%}%>>1000만원</option>				
                        </select>
                    </td>					
                    <td>
                        <select name='vins_gcp_kd'>
                            <option value='6' <%if(cha.getCh_after().equals("5억원")){%>selected<%}%>>5억원</option>
			    <option value='8' <%if(cha.getCh_after().equals("3억원")){%>selected<%}%>>3억원</option>
			    <option value='7' <%if(cha.getCh_after().equals("2억원")){%>selected<%}%>>2억원</option>
                            <option value='3' <%if(cha.getCh_after().equals("1억원")){%>selected<%}%>>1억원</option>						
                            <option value='4' <%if(cha.getCh_after().equals("5000만원")){%>selected<%}%>>5000만원</option>
                            <option value='1' <%if(cha.getCh_after().equals("3000만원")){%>selected<%}%>>3000만원</option>
                            <option value='2' <%if(cha.getCh_after().equals("1500만원")){%>selected<%}%>>1500만원</option>
                            <option value='5' <%if(cha.getCh_after().equals("1000만원")){%>selected<%}%>>1000만원</option>				
                        </select>                    
                    </td>
                </tr>		  		
		<%		}%>					
		<%		if(cha.getCh_item().equals("2")){
					i_cnt++;
		%>
                <tr align="center"> 
                    <td><%=i_cnt%></td>
                    <td align='center'><input type="checkbox" name="i_ch_cd" value="<%=i_cnt-1%>" checked></td>
                    <td>자기신체사고가입금액(사망/장애)<input type='hidden' name='i_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <select name='v_vins_bacdt_kd' disabled>
                            <option value="1" <%if(ins.getVins_bacdt_kd().equals("1")){%>selected<%}%>>3억원</option>
                            <option value="2" <%if(ins.getVins_bacdt_kd().equals("2")){%>selected<%}%>>1억5천만원</option>
                            <option value="6" <%if(ins.getVins_bacdt_kd().equals("6")){%>selected<%}%>>1억원</option>
                            <option value="5" <%if(ins.getVins_bacdt_kd().equals("5")){%>selected<%}%>>5000만원</option>
                            <option value="3" <%if(ins.getVins_bacdt_kd().equals("3")){%>selected<%}%>>3000만원</option>
                            <option value="4" <%if(ins.getVins_bacdt_kd().equals("4")){%>selected<%}%>>1500만원</option>
                        </select>
                    </td>					
                    <td>
                        <select name='vins_bacdt_kd'>
                            <option value="1" <%if(cha.getCh_after().equals("3억원")){%>selected<%}%>>3억원</option>
                            <option value="2" <%if(cha.getCh_after().equals("1억5천만원")){%>selected<%}%>>1억5천만원</option>
                            <option value="6" <%if(cha.getCh_after().equals("1억원")){%>selected<%}%>>1억원</option>
                            <option value="5" <%if(cha.getCh_after().equals("5000만원")){%>selected<%}%>>5000만원</option>
                            <option value="3" <%if(cha.getCh_after().equals("3000만원")){%>selected<%}%>>3000만원</option>
                            <option value="4" <%if(cha.getCh_after().equals("1500만원")){%>selected<%}%>>1500만원</option>
                        </select>                    
                    </td>
                </tr>		  		
		<%		}%>		
		<%		if(cha.getCh_item().equals("12")){
					i_cnt++;
		%>
                <tr align="center"> 
                    <td><%=i_cnt%></td>
                    <td align='center'><input type="checkbox" name="i_ch_cd" value="<%=i_cnt-1%>" checked></td>
                    <td>자기신체사고가입금액(부상)<input type='hidden' name='i_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <select name='v_vins_bacdt_kc2' disabled>
                            <option value="1" <%if(ins.getVins_bacdt_kc2().equals("1")){%>selected<%}%>>3억원</option>
                            <option value="2" <%if(ins.getVins_bacdt_kc2().equals("2")){%>selected<%}%>>1억5천만원</option>
                            <option value="6" <%if(ins.getVins_bacdt_kc2().equals("6")){%>selected<%}%>>1억원</option>
                            <option value="5" <%if(ins.getVins_bacdt_kc2().equals("5")){%>selected<%}%>>5000만원</option>
                            <option value="3" <%if(ins.getVins_bacdt_kc2().equals("3")){%>selected<%}%>>3000만원</option>
                            <option value="4" <%if(ins.getVins_bacdt_kc2().equals("4")){%>selected<%}%>>1500만원</option>
                        </select>
                    </td>					
                    <td>
                        <select name='vins_bacdt_kc2'>
                            <option value="1" <%if(cha.getCh_after().equals("3억원")){%>selected<%}%>>3억원</option>
                            <option value="2" <%if(cha.getCh_after().equals("1억5천만원")){%>selected<%}%>>1억5천만원</option>
                            <option value="6" <%if(cha.getCh_after().equals("1억원")){%>selected<%}%>>1억원</option>
                            <option value="5" <%if(cha.getCh_after().equals("5000만원")){%>selected<%}%>>5000만원</option>
                            <option value="3" <%if(cha.getCh_after().equals("3000만원")){%>selected<%}%>>3000만원</option>
                            <option value="4" <%if(cha.getCh_after().equals("1500만원")){%>selected<%}%>>1500만원</option>
                        </select>                    
                    </td>
                </tr>		  		
		<%		}%>	
		<%		if(cha.getCh_item().equals("4")){
					i_cnt++;
		%>
                <tr align="center"> 
                    <td><%=i_cnt%></td>
                    <td align='center'><input type="checkbox" name="i_ch_cd" value="<%=i_cnt-1%>" checked></td>
                    <td>자기차량손해가입금액<input type='hidden' name='i_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <input type='text' size='10' name='v_vins_cacdt_cm_amt2' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_cm_amt()))%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'> 원
                    </td>					
                    <td>
                        <input type='text' size='10' name='vins_cacdt_cm_amt2' value='<%=Util.parseDecimal(String.valueOf(cha.getCh_after()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 원
                    </td>
                </tr>		  		
		<%		}%>	
		<%		if(cha.getCh_item().equals("9")){
					i_cnt++;
		%>
                <tr align="center"> 
                    <td><%=i_cnt%></td>
                    <td align='center'><input type="checkbox" name="i_ch_cd" value="<%=i_cnt-1%>" checked></td>
                    <td>자기차량손해자기부담금<input type='hidden' name='i_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        물적사고할증기준
		        <select name='v_vins_cacdt_mebase_amt' disabled>
			    <option value=""    <%if(ins.getVins_cacdt_mebase_amt()==0  ){%>selected<%}%>>선택</option>
			    <option value="50"  <%if(ins.getVins_cacdt_mebase_amt()==50 ){%>selected<%}%>>50만원</option>
			    <option value="100" <%if(ins.getVins_cacdt_mebase_amt()==100){%>selected<%}%>>100만원</option>
			    <option value="150" <%if(ins.getVins_cacdt_mebase_amt()==150){%>selected<%}%>>150만원</option>
			    <option value="200" <%if(ins.getVins_cacdt_mebase_amt()==200){%>selected<%}%>>200만원</option>
			</select>
			<br>
			&nbsp;
			최대자기부담금 &nbsp;&nbsp; 
                        <input type='text' size='6' name='v_vins_cacdt_me_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_me_amt()))%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'> 
                        만원 
			<br>
			&nbsp;
			최소자기부담금 &nbsp;&nbsp;  
                        <select name='v_vins_cacdt_memin_amt' disabled>
                            <option value=""   <%if(ins.getVins_cacdt_memin_amt()==0 ){%>selected<%}%>>선택</option>
                            <option value="5"  <%if(ins.getVins_cacdt_memin_amt()==5 ){%>selected<%}%>>5만원</option>
                            <option value="10" <%if(ins.getVins_cacdt_memin_amt()==10){%>selected<%}%>>10만원</option>
                            <option value="15" <%if(ins.getVins_cacdt_memin_amt()==15){%>selected<%}%>>15만원</option>
                            <option value="20" <%if(ins.getVins_cacdt_memin_amt()==20){%>selected<%}%>>20만원</option>
                        </select>                    			
                    </td>					
                    <td>
                        <%
                        	int s=0; 
                        	String app_value[] = new String[3];	
	
				if(cha.getCh_after().length() > 0){
					StringTokenizer st = new StringTokenizer(cha.getCh_after(),"/");				
					while(st.hasMoreTokens()){
						app_value[s] = st.nextToken();
						s++;
					}		
				}	
                        %>                        
                        물적사고할증기준
		        <select name='vins_cacdt_mebase_amt' >
			    <option value=""    <%if(app_value[0].equals("선택")){%>selected<%}%>>선택</option>
			    <option value="50"  <%if(app_value[0].equals("50만원")){%>selected<%}%>>50만원</option>
			    <option value="100" <%if(app_value[0].equals("100만원")){%>selected<%}%>>100만원</option>
			    <option value="150" <%if(app_value[0].equals("150만원")){%>selected<%}%>>150만원</option>
			    <option value="200" <%if(app_value[0].equals("200만원")){%>selected<%}%>>200만원</option>
			</select>
			<br>
			&nbsp;
			최대자기부담금 &nbsp;&nbsp; 
                        <input type='text' size='6' name='vins_cacdt_me_amt' value='<%=Util.parseDecimal(app_value[1])%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
                        만원 
			<br>
			&nbsp;
			최소자기부담금 &nbsp;&nbsp;  
                        <select name='vins_cacdt_memin_amt' >
                            <option value=""   <%if(app_value[2].equals("선택")){%>selected<%}%>>선택</option>
                            <option value="5"  <%if(app_value[2].equals("5만원")){%>selected<%}%>>5만원</option>
                            <option value="10" <%if(app_value[2].equals("10만원")){%>selected<%}%>>10만원</option>
                            <option value="15" <%if(app_value[2].equals("15만원")){%>selected<%}%>>15만원</option>
                            <option value="20" <%if(app_value[2].equals("20만원")){%>selected<%}%>>20만원</option>
                        </select>                                                          
                    </td>
                </tr>		  		
		<%		}%>	
		<%		if(cha.getCh_item().equals("14")){
					i_cnt++;
		%>
                <tr align="center"> 
                    <td><%=i_cnt%></td>
                    <td align='center'><input type="checkbox" name="i_ch_cd" value="<%=i_cnt-1%>" checked></td>
                    <td>임직원한정운전특약<input type='hidden' name='i_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                      <select name='v_com_emp_yn2' disabled>
                        <option value="N" <%if(ins.getCom_emp_yn().equals("N")){%>selected<%}%>>미가입</option>
                        <option value="Y" <%if(ins.getCom_emp_yn().equals("Y")){%>selected<%}%>>가입</option>
                      </select>                                                                  
                    </td>					
                    <td>
                      <select name='com_emp_yn2'>
                        <option value="N" <%if(cha.getCh_after().equals("미가입")){%>selected<%}%>>미가입</option>
                        <option value="Y" <%if(cha.getCh_after().equals("가입")){%>selected<%}%>>가입</option>
                      </select>                                                                  
                    </td>
                </tr>		  		
		<%		}%>		
		<%		if(cha.getCh_item().equals("17")){
					i_cnt++;
		%>
                <tr align="center"> 
                    <td><%=i_cnt%></td>
                    <td align='center'><input type="checkbox" name="i_ch_cd" value="<%=i_cnt-1%>" checked></td>
                    <td>블랙박스<input type='hidden' name='i_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                      <select name='v_blackbox_yn' disabled>
                        <option value="N" <%if(ins.getBlackbox_yn().equals("N")){%>selected<%}%>>없다</option>
                        <option value="Y" <%if(ins.getBlackbox_yn().equals("Y")){%>selected<%}%>>있다</option>
                      </select>                                                                  
                    </td>					
                    <td>
                      <select name='blackbox_yn'>
                        <option value="N" <%if(cha.getCh_after().equals("미가입")){%>selected<%}%>>없다</option>
                        <option value="Y" <%if(cha.getCh_after().equals("가입")){%>selected<%}%>>있다</option>
                      </select>                                                                  
                    </td>
                </tr>		  		
		<%		}%>																			
		<%		if(cha.getCh_item().equals("15")){
					i_cnt++;
		%>
                <tr align="center"> 
                    <td><%=i_cnt%></td>
                    <td align='center'><input type="checkbox" name="i_ch_cd" value="<%=i_cnt-1%>" checked></td>
                    <td>피보험자변경<input type='hidden' name='i_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <input type='text' name='v_con_f_nm' value='<%=ins.getCon_f_nm()%>' size='20' class='whitetext'>
                    </td>					
                    <td>
                        <input type='text' name='con_f_nm' value='<%=cha.getCh_after()%>' size='20' class='text'>
                    </td>
                </tr>		  		
		<%		}%>

                <% 	}%>		
            </table>
        </td>
    </tr>
    <input type='hidden' name='i_cnt' 		value='<%=i_cnt%>'>       
    <tr id=tr_cng3 style="display:'none'">
	<td class=h></td>
    </tr>	
    <tr id=tr_cng4 style="display:'none'"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동차보험 보험료</span> <input type="checkbox" name="i_insamt_cng_yn" value="Y" checked> 보험료 변경분 반영</td>
        <input type="hidden" name="i_insamt_cng_yn_2" value="Y">
    </tr>
    <tr id=tr_cng5 style="display:'none'">
        <td class=line2></td>
    </tr>    
    <tr id=tr_cng6 style="display:'none'">
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>구분</td>
                    <td class=title width=10%>대인배상Ⅰ</td>
                    <td class=title width=10%>대인배상Ⅱ</td>
                    <td class=title width=10%>대물배상</td>
                    <td class=title width=10%>자기신체사고</td>
                    <td class=title width=10%>무보험차상해</td>
                    <td class=title width=10%>분담금할증한정</td>
                    <td class=title width=10%>자기차량손해</td>
                    <td class=title width=10%>특약</td>
                    <td class=title width=10%>합계</td>
        	</tr>	
                <tr> 
                    <td class=title>보험료</td>
                    <td align="center"><input type='text' size='10' name='rins_pcp_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getRins_pcp_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'></td>
                    <td align="center"><input type='text' size='10' name='vins_pcp_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_pcp_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'></td>
                    <td align="center"><input type='text' size='10' name='vins_gcp_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_gcp_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'></td>
                    <td align="center"><input type='text' size='10' name='vins_bacdt_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_bacdt_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'></td>
                    <td align="center"><input type='text' size='10' name='vins_canoisr_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_canoisr_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'></td>
                    <td align="center"><input type='text' size='10' name='vins_share_extra_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_share_extra_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'></td>
                    <td align="center"><input type='text' size='10' name='vins_cacdt_cm_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_cm_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'></td>
                    <td align="center"><input type='text' size='10' name='vins_spe_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_spe_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'></td>                    
                    <td align="center"><input type='text' size='10' name='tot_amt12' value='<%=Util.parseDecimal(String.valueOf(ins.getRins_pcp_amt()+ins.getVins_pcp_amt()+ins.getVins_gcp_amt()+ins.getVins_bacdt_amt()+ins.getVins_canoisr_amt()+ins.getVins_share_extra_amt()+ins.getVins_cacdt_cm_amt()+ins.getVins_spe_amt()))%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
        	</tr>	
    	    </table>
	</td>
    </tr>  
    <%	int l_cnt = 0; %>	     	    	     
    <%if(base.getCar_st().equals("1") || base.getCar_st().equals("3") || base.getCar_st().equals("5")){%>	    
    <tr id=tr_cng7 style="display:'none'">
	<td class=h></td>
    </tr>	
    <tr id=tr_cng8 style="display:'none'"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>장기계약 보험사항 변경분 반영</span><input type="checkbox" name="i_insinschange_cng_yn" value="Y" checked> 보험사항 변경분 반영</td>
    </tr>
    <tr id=tr_cng9 style="display:'none'">
        <td class=line2></td>
    </tr>
    <tr id=tr_cng10 style="display:'none'"> 
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=3% rowspan="2">연번</td>
                    <td class=title width=3% rowspan="2">선택</td>
                    <td class=title width=22% rowspan="2">변경항목</td>
                    <td class=title colspan="2">계약정보</td>                    
                </tr>
                <tr> 
                    <td class=title width=30%>변경전</td>
                    <td class=title width=30%>변경후</td>
                </tr>
                <%
                	
                	for(int i = 0 ; i < ins_cha_size ; i++){
				InsurChangeBean cha = (InsurChangeBean)ins_cha.elementAt(i);	
		%>	
		<%		if(cha.getCh_item().equals("5")){
					l_cnt++;
		%>
                <tr align="center"> 
                    <td><%=l_cnt%></td>
                    <td align='center'><input type="checkbox" name="l_ch_cd" value="<%=l_cnt-1%>" checked></td>
                    <td>연령변경<input type='hidden' name='l_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <select name='v_driving_age' disabled>                            
                            <option value="1" <%if(base.getDriving_age().equals("1")){%> selected <%}%>>21세이상</option>
                            <option value="3" <%if(base.getDriving_age().equals("3")){%> selected <%}%>>24세이상</option>
                            <option value="0" <%if(base.getDriving_age().equals("0")){%> selected <%}%>>26세이상</option>                                                        
                            <option value="2" <%if(base.getDriving_age().equals("2")){%> selected <%}%>>모든운전자</option>					  
                            <option value='5' <%if(base.getDriving_age().equals("5")){%>selected<%}%>>30세이상</option>				
                            <option value='6' <%if(base.getDriving_age().equals("6")){%>selected<%}%>>35세이상</option>				
                            <option value='7' <%if(base.getDriving_age().equals("7")){%>selected<%}%>>43세이상</option>						
			    <option value='8' <%if(base.getDriving_age().equals("8")){%>selected<%}%>>48세이상</option>					  						  
                        </select>
                    </td>					
                    <td>
                        <select name='driving_age'>                            
                            <option value="1" <%if(cha.getCh_after().equals("21세이상")){%>selected <%}%>>21세이상</option>
                            <option value="3" <%if(cha.getCh_after().equals("24세이상")){%>selected <%}%>>24세이상</option>
                            <option value="0" <%if(cha.getCh_after().equals("26세이상")){%>selected <%}%>>26세이상</option>                            
                            <option value="2" <%if(cha.getCh_after().equals("전연령")){%>selected <%}%>>모든운전자</option>					  
                            <option value='5' <%if(cha.getCh_after().equals("30세이상")){%>selected<%}%>>30세이상</option>				
                            <option value='6' <%if(cha.getCh_after().equals("35세이상")){%>selected<%}%>>35세이상</option>				
                            <option value='7' <%if(cha.getCh_after().equals("43세이상")){%>selected<%}%>>43세이상</option>						
			   				<option value='8' <%if(cha.getCh_after().equals("48세이상")){%>selected<%}%>>48세이상</option>					  						  
                       		<option value='9' <%if(cha.getCh_after().equals("22세이상")){%>selected<%}%>>22세이상</option>
                        	<option value='10' <%if(cha.getCh_after().equals("28세이상")){%>selected<%}%>>28세이상</option>
                        	<option value='11' <%if(cha.getCh_after().equals("35세이상~49세이하")){%>selected<%}%>>35세이상~49세이하</option>
                        </select>                                            
                    </td>
                </tr>		  		
		<%		}%>		
		<%		if(cha.getCh_item().equals("1")){
					l_cnt++;
		%>
                <tr align="center"> 
                    <td><%=l_cnt%></td>
                    <td align='center'><input type="checkbox" name="l_ch_cd" value="<%=l_cnt-1%>" checked></td>
                    <td>대물가입금액<input type='hidden' name='l_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <select name='v_gcp_kd' disabled>
                            <option value="1" <% if(base.getGcp_kd().equals("1")) out.print("selected"); %>>5천만원</option>
                            <option value="2" <% if(base.getGcp_kd().equals("2")) out.print("selected"); %>>1억원</option>
			    <option value="4" <% if(base.getGcp_kd().equals("4")) out.print("selected"); %>>2억원</option>
			    <option value="8" <% if(base.getGcp_kd().equals("8")) out.print("selected"); %>>3억원</option>
			    <option value="3" <% if(base.getGcp_kd().equals("3")) out.print("selected"); %>>5억원</option>
                        </select>
                    </td>					
                    <td>
                        <select name='gcp_kd'>
                            <option value="1" <% if(cha.getCh_after().equals("5천만원")) out.print("selected"); %>>5천만원</option>
                            <option value="2" <% if(cha.getCh_after().equals("1억원")) out.print("selected"); %>>1억원</option>
			    <option value="4" <% if(cha.getCh_after().equals("2억원")) out.print("selected"); %>>2억원</option>
			    <option value="8" <% if(cha.getCh_after().equals("3억원")) out.print("selected"); %>>3억원</option>
			    <option value="3" <% if(cha.getCh_after().equals("5억원")) out.print("selected"); %>>5억원</option>
                        </select>                    
                    </td>
                </tr>		  		
		<%		}%>	
		<%		if(cha.getCh_item().equals("2")){
					l_cnt++;
		%>
                <tr align="center"> 
                    <td><%=l_cnt%></td>
                    <td align='center'><input type="checkbox" name="l_ch_cd" value="<%=l_cnt-1%>" checked></td>
                    <td>자기신체사고<input type='hidden' name='l_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <select name='v_bacdt_kd' disabled>
                            <option value="1" <% if(base.getBacdt_kd().equals("1")) out.print("selected"); %>>5천만원</option>
                            <option value="2" <% if(base.getBacdt_kd().equals("2")) out.print("selected"); %>>1억원</option>
                            <option value="9" <% if(base.getBacdt_kd().equals("9")) out.print("selected"); %>>미가입</option>
                        </select>
                    </td>					
                    <td>
                        <select name='bacdt_kd'>
                            <option value="1" <% if(cha.getCh_after().equals("5천만원")) out.print("selected"); %>>5천만원</option>
                            <option value="2" <% if(cha.getCh_after().equals("1억원")) out.print("selected"); %>>1억원</option>
                            <option value="9" <% if(cha.getCh_after().equals("미가입")) out.print("selected"); %>>미가입</option>
                        </select>                    
                    </td>
                </tr>		  		
		<%		}%>	
		<%		if(cha.getCh_item().equals("4")){
					l_cnt++;
		%>
                <tr align="center"> 
                    <td><%=l_cnt%></td>
                    <td align='center'><input type="checkbox" name="l_ch_cd" value="<%=l_cnt-1%>" checked></td>
                    <td>자기차량손해<input type='hidden' name='l_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <select name='v_cacdt_yn' disabled>
                            <option value="">선택</option>
                            <option value="Y" <%if(cont_etc.getCacdt_yn().equals("Y")){%> selected <%}%>>가입</option>
                            <option value="N" <%if(cont_etc.getCacdt_yn().equals("N")){%> selected <%}%>>미가입</option>
                        </select>                                                
                    </td>					
                    <td>
                        <select name='cacdt_yn'>
                            <option value="">선택</option>
                            <option value="Y" <%if(!cha.getCh_after().equals("0")){%> selected <%}%>>가입</option>
                            <option value="N" <%if(cha.getCh_after().equals("0")){%> selected <%}%>>미가입</option>
                        </select>                                                
                    </td>
                </tr>		  		
		<%		}%>	
		<%		if(cha.getCh_item().equals("14")){
					l_cnt++;
		%>
                <tr align="center"> 
                    <td><%=l_cnt%></td>
                    <td align='center'><input type="checkbox" name="l_ch_cd" value="<%=l_cnt-1%>" checked></td>
                    <td>임직원한정운전특약<input type='hidden' name='l_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                      <select name='v_com_emp_yn' disabled>
                        <option value="N" <%if(cont_etc.getCom_emp_yn().equals("N")){%>selected<%}%>>미가입</option>
                        <option value="Y" <%if(cont_etc.getCom_emp_yn().equals("Y")){%>selected<%}%>>가입</option>
                      </select>                                                                  
                        
                    </td>					
                    <td>
                      <select name='com_emp_yn'>
                        <option value="N" <%if(cha.getCh_after().equals("미가입")){%>selected<%}%>>미가입</option>
                        <option value="Y" <%if(cha.getCh_after().equals("가입")){%>selected<%}%>>가입</option>
                      </select>                                                                  
                        
                    </td>
                </tr>		  		
		<%		}%>											
		<%		if(cha.getCh_item().equals("15")){
					l_cnt++;
		%>
                <tr align="center"> 
                    <td><%=l_cnt%></td>
                    <td align='center'><input type="checkbox" name="l_ch_cd" value="<%=l_cnt-1%>" checked></td>
                    <td>피보험자변경<input type='hidden' name='l_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <select name='v_insur_per' disabled>                            
                            <option value="1" <%if(cont_etc.getInsur_per().equals("1")){%> selected <%}%>>아마존카</option>
                            <option value="2" <%if(cont_etc.getInsur_per().equals("2")){%> selected <%}%>>고객</option>
                        </select>
                    </td>					
                    <td>
                        <select name='insur_per'>                            
                            <option value="1" <%if(cha.getCh_after().equals("아마존카")){%> selected <%}%>>아마존카</option>
                            <option value="2" <%if(!cha.getCh_after().equals("아마존카")){%> selected <%}%>>고객</option>
                        </select>                        
                    </td>
                </tr>		  		
		<%		}%>

                <% 	}%>		
            </table>
        </td>
    </tr>	    	    
    <%}%>
    <input type='hidden' name='l_cnt' 		value='<%=l_cnt%>'>       
    <tr>
	<td class=h></td>
    </tr>	    
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>            
                <tr> 
                    <td width='10%' class='title'>등록구분</td>
                    <td>&nbsp;
        		<%if(cng_doc.getCh_st().equals("2")){%>견적<%}else{%>반영<%}%>
	            </td>
                </tr>
                <tr> 
                    <td width='10%' class='title'>변경일자</td>
                    <td>&nbsp;
        		<input type='text' name='cng_dt' size='11' value='<%=AddUtil.ChangeDate2(cng_doc.getCh_dt())%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 24시 </td>
                </tr>
                <tr> 
                    <td width='10%' class='title'>변경담보유효기간</td>
                    <td>&nbsp;
                        <input type='text' name='cng_s_dt' size='11' value='<%=AddUtil.ChangeDate2(cng_doc.getCh_s_dt())%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> ~ <input type='text' name='cng_e_dt' size='10' value='<%=AddUtil.ChangeDate2(cng_doc.getCh_e_dt())%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> </td>
                </tr>                                
                <tr> 
                    <td class='title'>사유 및 특이사항</td>
                    <td>&nbsp;
        		<textarea name="cng_etc" cols="100" class="text" style="IME-MODE: active" rows="5"><%=cng_doc.getCh_etc()%></textarea> 
                    </td>
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
		<%}%>		
            </table>
        </td>
    </tr>	
    <tr>
	<td>* 변경담보유효기간 종료 3일전에는 담당자(기안자)에게 종료예정임을 사내메신저로 통보합니다. 담당자는 변경내용의 연장 여부 등을 반드시 보험관리담당자에게 문서로 제출해야만 합니다.</td>
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
        <td>&nbsp;</td>
    </tr>
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
                    <td class=title width=15%><%//=doc.getUser_nm5()%></td>			
        	</tr>	
                <tr> 
                    <td align="center" style='height:44'><%=user_bean.getBr_nm()%></td>
                    <td align="center">
			<!--기안자-->
			<%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%>        		
		    </td>
                   
      <%if(!doc.getUser_id4().equals("")){%>
       <td align="center">
		      <!--영업부팀장-->
					<%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%>        
				    </td>
		                    <td align="center">
					<!--보험담당-->
					<%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%>
		        		<%if(!doc.getUser_dt2().equals("") && doc.getUser_dt3().equals("") && !cng_doc.getIns_doc_st().equals("N")){
		        			String user_id3 = doc.getUser_id3();
		        			CarScheBean cs_bean = csd.getCarScheTodayBean(user_id3);
		        			if(!cs_bean.getWork_id().equals(""))	user_id3 = cs_bean.getWork_id();
		        		%>
		     			<%	if(doc.getUser_id3().equals(user_id) || user_id3.equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("보험담당",user_id)){%>
		        		<a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
		        		<%	}%>
		        		<br>&nbsp;
		        		<%}%>
		       			<br>&nbsp;
				    </td>
      <%}else{%>
      
		                    <td align="center">
					<!--보험담당-->
					<%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%>
		        		<%if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("") && !cng_doc.getIns_doc_st().equals("N")){
		        			String user_id2 = doc.getUser_id2();
		        			CarScheBean cs_bean = csd.getCarScheTodayBean(user_id2);
		        			if(!cs_bean.getWork_id().equals(""))	user_id2 = cs_bean.getWork_id();
		        		%>
		     			<%	if(doc.getUser_id2().equals(user_id) || user_id2.equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("보험담당",user_id)){%>
		        		<a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
		        		<%	}%>
		        		<br>&nbsp;
		        		<%}%>
		       			<br>&nbsp;
				    </td>
      <td align="center"></td>
      <%}%>
			
                    <td align="center"></td>
                    <td align="center"></td>			
        	</tr>	
    	    </table>
	</td>
    </tr>  	 
    <%if(!mode.equals("view")){%> 		
    <%		if(doc.getUser_id1().equals(user_id) || doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("보험담당",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id) || nm_db.getWorkAuthUser("해지관리자",user_id)){%>
    <tr>
	<td class=h></td>
    </tr>		
    <tr>
	<td align="right">
		
	    <%if(!doc.getDoc_step().equals("3")){%> 	
	    <a href="javascript:doc_sanction('u');"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
	    <%}%>
		  	  
	    <%if(cng_doc.getCh_st().equals("2") || !doc.getDoc_step().equals("3")){%> 	
	    <%		if(nm_db.getWorkAuthUser("전산팀",user_id)||nm_db.getWorkAuthUser("보험업무",user_id)){%>
	    &nbsp;&nbsp;&nbsp;
	    <a href="javascript:doc_sanction('d');"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>
	    <%		}%>
	    <%}else{%>	
	    <%		if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
	    &nbsp;&nbsp;&nbsp;
	    <a href="javascript:doc_sanction('d');"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>
	    <%		}%>
	    <%}%>
	    
	    <%		if(cng_doc.getCh_st().equals("1") && doc.getUser_id1().equals(user_id) && !doc.getUser_dt1().equals("") && !doc.getDoc_step().equals("3")){//반영은 삭제요청%>
	    &nbsp;&nbsp;&nbsp;
	    <input type="button" class="button" value="삭제요청" onclick="javascript:doc_sanction('d_req');">	    
	    <%		} %>
	    
	</td>
    </tr>	
    <%		}%>	
    <%}%>	

</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

//-->
</script>
</body>
</html>
