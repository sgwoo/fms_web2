<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.tint.*, acar.doc_settle.*, acar.estimate_mng.*, card.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<jsp:useBean id="ej_bean"   class="acar.estimate_mng.EstiJgVarBean"    scope="page"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String com_con_no 	= request.getParameter("com_con_no")==null?"":request.getParameter("com_con_no");
	
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");	
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	String est_id = e_db.getEst_id(rent_l_cd);
	//System.out.println(rent_l_cd);
	//System.out.println(est_id);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
		
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//일정관리
	Hashtable est = a_db.getRentEst(rent_mng_id, rent_l_cd);
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//차량번호 이력	
	CarHisBean ch_r [] = crd.getCarHisAll(base.getCar_mng_id());

	//잔가변수NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	

	//배정관리(원계약)		
	CarPurDocListBean cpd_bean = cod.getCarPurCom(rent_mng_id, rent_l_cd, com_con_no);
	
	//변경계약
	Vector vt = cod.getCarPurComCngs(rent_mng_id, rent_l_cd, com_con_no);
	int vt_size = vt.size();	

	int cng_size = 0;
	int max_cng_seq = 0;
	for(int i = 0 ; i < vt_size ; i++){
 		Hashtable ht = (Hashtable)vt.elementAt(i);
	    if(String.valueOf(ht.get("CNG_ST")).equals("1")){
	    	cng_size++;	
	    }
    	if(String.valueOf(ht.get("CNG_ST")).equals("2")){
	  		max_cng_seq = AddUtil.parseInt(String.valueOf(ht.get("SEQ")));
	  	}
  	}
	
	//변경관리		
	CarPurDocListBean cng_bean = new CarPurDocListBean();
	
	UsersBean dlv_mng_bean = umd.getUsersBean(cpd_bean.getDlv_mng_id());
		
	
	String vlaus =	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort="+sort+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+
					"&st_dt="+st_dt+"&end_dt="+end_dt+"&from_page="+from_page+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&com_con_no="+com_con_no+"";				   	
	
	String cng_act_yn = "";
	String cls_act_yn = "";
	String re_act_yn = "";	
	
	user_bean 	= umd.getUsersBean(ck_acar_id);
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "LC_RENT";
	String content_seq  = "";

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;		
	
	Vector sr = cod.getSucResList(cpd_bean.getCom_con_no());
	int sr_size = sr.size();	
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
textarea.autosize { min-height: 50px; }
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;

	
	
	//팝업윈도우 열기
	function ScanOpen2(theURL,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}	
		theURL = "https://fms3.amazoncar.co.kr/data/carReg/"+theURL+""+file_type;
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj = window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');			
		}else{
			popObj = window.open(theURL,'popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}
		popObj.location = theURL;
		popObj.focus();			
	}	
	
	
	//팝업윈도우 열기
	function MM_openBrWindow2(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/carReg/"+theURL+".pdf";
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();	
	}
	
	//리스트
	function list(){
		var fm = document.form1;
		if(fm.from_page.value == ''){			
			fm.action = 'pur_est_frame.jsp';
		}else{
			fm.action = fm.from_page.value;
		}
		fm.target = 'd_content';
		fm.submit();
	}	

	//수정
	function update(st, seq){
	
		var height = 250;
		
		if(st == 'dlv') 				height = 250;
		else if(st == 'amt') 			height = 500;
		else if(st == 'cng') 			height = 550;
		else if(st == 'cng_amt') 		height = 400;
		else if(st == 'cls1' || st == 'cls2'|| st == 're') 	height = 300;
		else if(st == 'con') 			height = 250;
		else if(st == 're_act')			height = 250;
		else if(st == 'cng2') 			height = 400;
		else if(st == 'cls3') 			height = 300;
		else if(st == 'settle') 		height = 250;
		else if(st == 'mm') 			height = 400;		
		else if(st == 'stock') 			height = 300;
		
		height = height + 50;
				
		window.open("lc_rent_u.jsp<%=vlaus%>&cng_item="+st+"&seq="+seq, "CHANGE_ITEM", "left=50, top=50, width=1050, height="+height+", scrollbars=yes, status=yes");		
	}	
	
	//변경반영처리
	function dir_update(st, seq){
		var ment = '반영처리';
		if(st=='cng_act') 	ment = '변경 반영처리';
		if(st=='cng_cancel') 	ment = '변경 취소처리';
		if(st=='cls_act') 	ment = '해지 반영처리';
		if(st=='cng_cont') 	ment = '계약변경 반영처리';
		if(st=='order_req') ment = '주문차 고객확인처리';
		if(st=='end_act') 	ment = '배정후변경 반영처리';
		if(st=='revival') 	ment = '해지취소후 부활처리';
		if(st=='cls5') 		ment = '신차취소현황으로 보내기분 납부취소';
		if(!confirm(ment+" 를 하시겠습니까?"))	return;
		var fm = document.form1;
		fm.cng_item.value = st;
		fm.seq.value = seq;
		fm.action = 'lc_rent_u_a.jsp';
		fm.target = 'i_no';
		fm.submit();
	}
	
	
				
	//예약이력
	function view_sh_res_h(){
		var SUBWIN="reserveCarHistory.jsp?com_con_no=<%=cpd_bean.getCom_con_no()%>";
		window.open(SUBWIN, "reserveCarHistory", "left=50, top=50, width=850, height=800, scrollbars=yes, status=yes");
	}
	
	//견적상담후 예약해두기
	function reserveCar(){
		var fm = document.form1;
		var SUBWIN="reserveCar.jsp?from_page=<%=from_page%>&com_con_no=<%=cpd_bean.getCom_con_no()%>&user_id=<%=user_id%>";
		window.open(SUBWIN, "reserveCar", "left=250, top=250, width=520, height=350, scrollbars=no, status=yes");
	}

	//예약메모수정하기
	function reserveCarM(seq, situation, memo, cust_nm, cust_tel, damdang_id){
		var fm = document.form1;
		var SUBWIN="reserveCarM.jsp?from_page=<%=from_page%>&user_id=<%=user_id%>&com_con_no=<%=cpd_bean.getCom_con_no()%>&seq="+seq+"&situation="+situation+"&memo="+memo+"&cust_nm="+cust_nm+"&cust_tel="+cust_tel+"&damdang_id="+damdang_id;
		window.open(SUBWIN, "reserveCar", "left=250, top=250, width=520, height=350, scrollbars=no, status=yes");
	}

	//계약확정으로 전환하기
	function reserveCar2Cng(seq, situation, damdang_id, shres_reg_dt, shres_cust_nm, shres_cust_tel){
		var fm = document.form1;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;
		fm.shres_cust_nm.value = shres_cust_nm;
		fm.shres_cust_tel.value = shres_cust_tel;
		if(!confirm("상담중에서 계약확정으로 전환 하시겠습니까?"))	return;
		fm.action = "reserveCar2cng.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
	//예약연장하기
	function reReserveCar(seq, situation, damdang_id, shres_reg_dt){
		var fm = document.form1;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;
		if(!confirm("예약을 연장 하시겠습니까?"))	return;
		fm.action = "reReserveCar.jsp";
		fm.target = "i_no";
		fm.submit();
	}	
		
	//예약취소하기
	function cancelCar(seq, situation, damdang_id, shres_reg_dt){
		var fm = document.form1;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;
		if(!confirm("예약을 취소 하시겠습니까?"))	return;
		fm.action = "cancelCar.jsp";
		fm.target = "i_no";
		fm.submit();
	}
		
	//계약 연동하기
	function PurComReg(seq){
		var fm = document.form1;
		var SUBWIN="rePurcomReg.jsp?from_page=<%=from_page%>&user_id=<%=user_id%>&o_rent_mng_id=<%=cpd_bean.getRent_mng_id()%>&o_rent_l_cd=<%=cpd_bean.getRent_l_cd()%>&com_con_no=<%=cpd_bean.getCom_con_no()%>&seq="+seq;
		window.open(SUBWIN, "PurComReg", "left=50, top=450, width=1150, height=350, scrollbars=no, status=yes");
	}
	
	//취소차량 재견적
	function ReEsti(est_id){
		var fm = document.form1;
		fm.est_id.value = est_id;
		fm.cmd.value = 're';
		fm.action = '/acar/estimate_mng/esti_mng_atype_i.jsp';		
		fm.target = 'd_content';
		fm.submit();
	}
	
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='sort'	value='<%=sort%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="est_id" value="<%=est_id%>">
  <input type='hidden' name="cmd" value="">
  <input type='hidden' name="com_con_no" 	value="<%=com_con_no%>">
  <input type='hidden' name="car_mng_id" 	value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="client_id" 	value="<%=base.getClient_id()%>">  
  <input type='hidden' name="car_nm" 		value="<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>">  
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">  
  <input type='hidden' name="cng_item" 		value="">  
  <input type='hidden' name="seq" 		value="">  
  <input type='hidden' name="mode" 		value="<%=mode%>">  
  <input type="hidden" name="situation" 		value="">
  <input type="hidden" name="damdang_id" 		value="">
  <input type="hidden" name="shres_reg_dt" 	value="">
  <input type="hidden" name="shres_seq" 		value="">
  <input type="hidden" name="shres_cust_nm" 		value="">
  <input type="hidden" name="shres_cust_tel" 		value="">  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>계출관리 > <span class=style5>계출보기</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <%if(!mode.equals("view")){%>
    <tr>
        <td align="right"><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a></td></td>
    <tr> 	
    <%}%>
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="2" class=title>계약번호</td>
                    <td width=7% class=title>아마존카</td>
                    <td width=19%>&nbsp;<%=rent_l_cd%></td>
                    <td width=7% rowspan="2" class=title>계출일자</td>
                    <td width=7% class=title>계약등록일</td>
                    <td width="19%" >&nbsp;<%=AddUtil.ChangeDate10(cpd_bean.getReg_dt())%></td>
                    <td width=7% rowspan="2" class=title>담당자</td>
                    <td width=7% class=title>계출담당</td>
                    <td width="20%">&nbsp;<%=dlv_mng_bean.getDept_nm()%>&nbsp;<%=dlv_mng_bean.getUser_nm()%>&nbsp;<%=dlv_mng_bean.getUser_pos()%></td>
    		    </tr>
                <tr>
                  <td class=title><%=cm_bean.getCar_comp_nm()%></td>
                  <td>&nbsp;<%=cpd_bean.getCom_con_no()%>
                  	<%if(!mode.equals("view")){%> 
    								<%	if(cpd_bean.getSettle_dt().equals("") && !cpd_bean.getUse_yn().equals("N") && !cpd_bean.getSuc_yn().equals("D")){%>
    								<%		if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("자체출고관리",ck_acar_id) || nm_db.getWorkAuthUser("임원",ck_acar_id)){%>     
                    <a href='javascript:update("com_con_no", "")'><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
                    <%		}%>
                    <%	}%>
                    <%}%>
                  </td>
                  <td class=title>출고희망일</td>
                  <td >&nbsp;<%=AddUtil.ChangeDate2(pur.getPur_req_dt())%></td>
                  <td width=5% class=title>연락처</td>
                  <td>&nbsp;<%=dlv_mng_bean.getHot_tel()%></td>
                </tr>	
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>
    
    <%if(!cpd_bean.getSuc_yn().equals("")){%>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><font color=red>예약상태</font></span>
            &nbsp;&nbsp;<a href="javascript:view_sh_res_h()" title="이력"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a>
		</td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="5%">순위</td>
                    <td class="title" width="10%">담당자</td>
                    <td class="title" width="10%">진행상황</td>
                    <td class="title" width="15%">예약기간</td>
                    <td class="title" width="35%">메모</td>
                    <td class="title" width="10%">등록일자</td>
                    <td class="title" width="15%">처리</td>
                </tr>
                <%	for(int i = 0 ; i < sr_size ; i++){
                        Hashtable sr_ht = (Hashtable)sr.elementAt(i);                        
                %>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=c_db.getNameById(String.valueOf(sr_ht.get("REG_ID")),"USER")%></td>
                    <td align="center">
                    	<%	if(String.valueOf(sr_ht.get("SITUATION")).equals("0"))				out.print("상담중");
                    			else if(String.valueOf(sr_ht.get("SITUATION")).equals("2"))		out.print("계약확정");
                   				else if(String.valueOf(sr_ht.get("SITUATION")).equals("3"))		out.print("계약연동");
                    	%>
                    </td>
                    <td align="center">
                    	<%if(!String.valueOf(sr_ht.get("RES_ST_DT")).equals("")){%>
                    	<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_ST_DT"))) %>~<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_END_DT"))) %>
                    	<%}%>
                    </td>
                    <td>&nbsp;
                    	<!--메모수정-->
                    	<%if(cpd_bean.getSuc_yn().equals("D")){%><a href="javascript:reserveCarM('<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("MEMO")%>', '<%=sr_ht.get("CUST_NM")%>', '<%=sr_ht.get("CUST_TEL")%>', '<%=sr_ht.get("REG_ID")%>');" title='메모수정하기'><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>&nbsp;<%}%>
                    	<%=sr_ht.get("CUST_NM")%>&nbsp;<%=sr_ht.get("CUST_TEL")%>&nbsp;<%=sr_ht.get("MEMO")%>
                    </td>
                    <td align="center"><%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("REG_DT"))) %></td>
                    <td align="center">
                    	<%if(cpd_bean.getSuc_yn().equals("D")){%>
                    	<!--계약학정에서 계약연동-->
                    	<%	if(String.valueOf(sr_ht.get("SITUATION")).equals("2") && String.valueOf(sr_ht.get("USE_YN")).equals("Y") && (user_id.equals(String.valueOf(sr_ht.get("REG_ID"))) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("자체출고관리",user_id))){%>
                    	<input type="button" class="button" id="pre_cls" value='계약 연동하기' onclick="javascript:PurComReg('<%=sr_ht.get("SEQ")%>');">&nbsp;&nbsp;
                    	<%	}%>
                    	<%	if(user_id.equals(String.valueOf(sr_ht.get("REG_ID"))) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
                    	<%		if(i==0 && String.valueOf(sr_ht.get("SITUATION")).equals("0")){%>
                    	<!--상담을 계약확정을 전환-->
                    	<a href="javascript:reserveCar2Cng('<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("REG_ID")%>', '<%=sr_ht.get("REG_DT")%>', '<%=sr_ht.get("CUST_NM")%>', '<%=sr_ht.get("CUST_TEL")%>');" title='차량예약 계약확정하기'><img src=/acar/images/center/button_in_dec.gif align=absmiddle border=0></a>&nbsp;&nbsp;
                    	<%		}%>
                    	<!--1회연장-->
                    	<%		if((i==0 && String.valueOf(sr_ht.get("SITUATION")).equals("2") && AddUtil.parseInt(String.valueOf(sr_ht.get("ADD_CNT"))) == 0) || (i==0 && String.valueOf(sr_ht.get("SITUATION")).equals("0") && AddUtil.parseInt(String.valueOf(sr_ht.get("ADD_CNT_S"))) == 0)){%>
                    	<a href="javascript:reReserveCar('<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("REG_ID")%>', '<%=sr_ht.get("REG_DT")%>');" title='차량예약 연장하기'><img src=/acar/images/center/button_in_yj.gif align=absmiddle border=0></a>&nbsp;&nbsp;
                    	<%		}%>
                    	<!--예약취소-->
                    	<a href="javascript:cancelCar('<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("REG_ID")%>', '<%=sr_ht.get("REG_DT")%>');" title='차량예약 취소하기'><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a>&nbsp;&nbsp;
                    	<%	}%>
                    	<%}%>
                    </td>
                </tr>
				        <%}%>
				        <%if(sr_size==0){%>
                <tr>
                    <td align="center" colspan="7">등록된 데이타가 없습니다.</td>
                </tr>
				        <%}%>
            </table>
	    </td>
    </tr>
    <%if(cpd_bean.getSuc_yn().equals("D")){%>
	  <%	if(sr_size < 3){%>
    <tr>
        <td align="right">
            <a href="javascript:reserveCar();" title='차량예약하기'><img src=/acar/images/center/button_cryy.gif align=absmiddle border=0></a>
        </td>
    </tr>
	  <%	}%>
	  <%}%>
    <%}%>
    
        
    
    <%if(cng_size >0){%>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>변경전 계약</span></td>
    </tr>    
    <%}else{%>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약</span></td>
    </tr>    
    <%}%>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>차명</td>
                    <td colspan="3">&nbsp;<%=cpd_bean.getCar_nm()%> <%if(cng_size==0 && !cm_bean.getCar_y_form().equals("")){%>(연식:<%=cm_bean.getCar_y_form()%>)<%}%></td>
                </tr>
                <tr> 
                    <td width=14% class=title>선택사양</td>
                    <td colspan="3" >&nbsp;<%=cpd_bean.getOpt()%></td>
                </tr>
                <tr> 
                    <td width=14% class=title>색상(외장/내장/가니쉬)</td>
                    <td colspan="3" >&nbsp;<%=cpd_bean.getColo()%></td>
                </tr>
                <tr>
                  <td class=title>과세구분</td>
                  <td width="19%">&nbsp;<%=cpd_bean.getPurc_gu()%></td>
                  <td width=14% class=title>T/M</td>
                  <td>&nbsp;<%=cpd_bean.getAuto()%></td>
                </tr>	
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="2" class=title>차가</td>
                    <td width=7% class=title>소비자가</td>
                    <td width=19%>&nbsp;<input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_c_amt())%>'  maxlength='10' class='whitenum' readonly >원</td>
                    <td width=7% rowspan="2" class=title>D/C</td>
                    <td width=7% class=title>D/C</td>
                    <td width="19%" >&nbsp;<input type='text' name='dc_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getDc_amt())%>'  maxlength='10' class='whitenum' readonly >원</td>
                    <td width="14%" class=title>D/C합계</td>
                    <td width="20%">&nbsp;<input type='text' name='car_d_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_d_amt())%>'  maxlength='10' class='whitenum' readonly >원</td>
    		    </tr>
                <tr>
                  <td class=title>구입가</td>
                  <td>&nbsp;<input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_f_amt())%>'  maxlength='10' class='whitenum' readonly >원</td>
                  <td class=title>추가D/C</td>
                  <td >&nbsp;<input type='text' name='add_dc_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getAdd_dc_amt())%>'  maxlength='10' class='whitenum' readonly >원</td>
                  <td class=title>거래금액계</td>
                  <td>&nbsp;<input type='text' name='car_g_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_g_amt())%>'  maxlength='10' class='whitenum' readonly >원</td>
                </tr>
                <%-- <%if (nm_db.getWorkAuthUser("전산팀", user_id)) {%> --%>
                <tr>
                	<td class="title">비교견적</td>
                	<td colspan="7">&nbsp;<a href="javascript:ReEsti('<%=est_id%>');" title='비교견적'><img src=/acar/images/center/button_in_esti.gif align=absmiddle border=0></a></td>
                </tr>
                <%-- <%}%> --%>	
            </table>
        </td>
    </tr>       
    <%if(!mode.equals("view")){%>
    <%if(!cpd_bean.getUse_yn().equals("N") && !cpd_bean.getSuc_yn().equals("D")){%>
    <%	if(nm_db.getWorkAuthUser("자체출고관리",ck_acar_id) || 
    		nm_db.getWorkAuthUser("전산팀",user_id) || 
           cpd_bean.getSettle_dt().equals("") && (cpd_bean.getUse_yn().equals("Y") || cpd_bean.getUse_yn().equals("C") || cpd_bean.getSuc_yn().equals("D")) && cng_size ==0 && (nm_db.getWorkAuthUser("전산팀",user_id) || cpd_bean.getReg_id().equals(user_id) || nm_db.getWorkAuthUser("자체출고관리",ck_acar_id) )
        ){%>
    <tr>
	<td align="right">
		<a href="javascript:update('amt','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
	</td>
    <tr>	    
    <%}%>
    <%}%>
    <%}%>
    
    <%if(vt_size > 0){%>
    <%		for(int i = 0 ; i < vt_size ; i++){
    			Hashtable ht = (Hashtable)vt.elementAt(i);%>
    <tr>
        <td class=h></td>
    </tr>
    <%			if(String.valueOf(ht.get("CNG_ST")).equals("1")){
    				if(String.valueOf(ht.get("CNG_DT")).equals("")){
    					cng_act_yn = "N";
    				}
    				
    				//변경관리		
				cng_bean = cod.getCarPurComCng(rent_mng_id, rent_l_cd, com_con_no, String.valueOf(ht.get("SEQ")));
    %>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>변경계약(<%=i+1%>)</span></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>변경구분</td>
                    <td>&nbsp;<%=ht.get("CNG_CONT")%></td>
                    <td width=14% class=title>변경등록</td>
                    <td width="19%" >&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%>&nbsp;<%=ht.get("REG_DT")%></td>
                    <td width=14% class=title>처리구분</td>
                    <td width="20%">&nbsp;
                        <%if(String.valueOf(ht.get("CNG_DT")).equals("")){%>
                            <%if(nm_db.getWorkAuthUser("자체출고관리",ck_acar_id)  || nm_db.getWorkAuthUser("임원",ck_acar_id)){%>     
                                <font color=red>미반영</font>&nbsp;
                                <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
                                <a href="javascript:dir_update('cng_act','<%=ht.get("SEQ")%>')">[반영처리]</a>
                                &nbsp;&nbsp;                                
                                <a href="javascript:dir_update('cng_cancel','<%=ht.get("SEQ")%>')"><b><font color=red>[변경취소]</font></b></a>
                                <%}%>
                            <%}%>    
                        <%}else{%><%=c_db.getNameById(String.valueOf(ht.get("CNG_ID")),"USER")%>&nbsp;<%=ht.get("CNG_DT")%><%}%></td>                    
                </tr> 
                <tr> 
                    <td width=14% class=title>변경내용</td>
                    <td colspan="5">&nbsp;<textarea class="autosize" style="width:90%;overflow-y:hidden"><%=ht.get("BIGO")%></textarea></td>
                </tr>
                <%if(!String.valueOf(ht.get("CNG_CONT")).equals("배달지")){%>  
                <tr> 
                    <td width=14% class=title>차명</td>
                    <td colspan="5">&nbsp;<%=ht.get("CAR_NM")%></td>
                </tr>
                <tr> 
                    <td width=14% class=title>선택사양</td>
                    <td colspan="5" >&nbsp;<%=ht.get("OPT")%></td>
                </tr>
                <tr> 
                    <td width=14% class=title>색상(외장/내장/가니쉬)</td>
                    <td colspan="5" >&nbsp;<%=ht.get("COLO")%></td>
                </tr>
                <tr>
                  <td class=title>과세구분</td>
                  <td width="19%">&nbsp;<%=ht.get("PURC_GU")%></td>
                  <td width=14% class=title>T/M</td>
                  <td colspan="3">&nbsp;<%=ht.get("AUTO")%></td>
                </tr>	
                <%}%>
            </table>
        </td>
    </tr> 
    <%if(!String.valueOf(ht.get("CNG_CONT")).equals("배달지")){%>  
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="2" class=title>차가</td>
                    <td width=7% class=title>소비자가</td>
                    <td width=19%>&nbsp;<input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_C_AMT")))%>'  maxlength='10' class='whitenum' readonly >원</td>
                    <td width=7% rowspan="2" class=title>D/C</td>
                    <td width=7% class=title>D/C</td>
                    <td width="19%" >&nbsp;<input type='text' name='dc_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DC_AMT")))%>'  maxlength='10' class='whitenum' readonly >원</td>
                    <td width="14%" class=title>D/C합계</td>
                    <td width="20%">&nbsp;<input type='text' name='car_d_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_D_AMT")))%>'  maxlength='10' class='whitenum' readonly >원</td>
    		    </tr>
                <tr>
                  <td class=title>구입가</td>
                  <td>&nbsp;<input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_F_AMT")))%>'  maxlength='10' class='whitenum' readonly >원</td>
                  <td class=title>추가D/C</td>
                  <td >&nbsp;<input type='text' name='add_dc_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("ADD_DC_AMT")))%>'  maxlength='10' class='whitenum' readonly >원</td>
                  <td class=title>거래금액계</td>
                  <td>&nbsp;<input type='text' name='car_g_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_G_AMT")))%>'  maxlength='10' class='whitenum' readonly >원</td>
                </tr>	
            </table>
        </td>
    </tr>  
    <%if(!mode.equals("view")){%>
    <%if(!cpd_bean.getUse_yn().equals("N") && !cpd_bean.getSuc_yn().equals("D")){%>
    
    <%		if((cpd_bean.getUse_yn().equals("Y") || cpd_bean.getUse_yn().equals("C") || cpd_bean.getSuc_yn().equals("D")) && (nm_db.getWorkAuthUser("자체출고관리",ck_acar_id) || nm_db.getWorkAuthUser("전산팀",user_id) || String.valueOf(ht.get("REG_ID")).equals(user_id))){%>
    <tr>
	<td align="right"><a href="javascript:update('cng_amt','<%=ht.get("SEQ")%>')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
    <tr>	    
    <%		}%>
         
    <%		if(i+1==vt_size && cpd_bean.getSettle_dt().equals("") && (cpd_bean.getUse_yn().equals("Y") || cpd_bean.getUse_yn().equals("C") || cpd_bean.getSuc_yn().equals("D"))){%>
    <tr>
	<td align="right"><a href="javascript:update('cng_amt','<%=ht.get("SEQ")%>')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
    <tr>	    
    <%		}%>
    <%}%>     
    <%}%>
    <%}%>    
    <%			}else if(String.valueOf(ht.get("CNG_ST")).equals("2")){
    				if(String.valueOf(ht.get("CNG_DT")).equals("")){
    					if(String.valueOf(ht.get("CNG_CONT")).equals("신차취소현황으로 보내기") && cpd_bean.getSuc_yn().equals("D")){
    					}else{
    						cls_act_yn = "N";
    					}
    				}    
    %>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(String.valueOf(ht.get("CNG_CONT")).equals("신차취소현황으로 보내기") && cpd_bean.getSuc_yn().equals("D")){%>변경<%}else{%><font color=red>계약해지</font><%}%></span></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>해지구분</td>
                    <td>&nbsp;<%=ht.get("CNG_CONT")%></td>
                    <td width=14% class=title>해지등록</td>
                    <td width="19%" >&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%>&nbsp;<%=ht.get("REG_DT")%></td>
                    <td width=14% class=title>처리구분</td>
                    <td width="20%">&nbsp;
                        <%if(String.valueOf(ht.get("CNG_DT")).equals("")){%>미반영&nbsp;
                            <%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("자체출고관리",ck_acar_id) || nm_db.getWorkAuthUser("임원",ck_acar_id)){%>     
                            	<%if(String.valueOf(ht.get("CNG_CONT")).equals("신차취소현황으로 보내기") && cpd_bean.getSuc_yn().equals("D")){%>
                    					<%}else{%>                            
                              <a href="javascript:dir_update('cls_act','<%=ht.get("SEQ")%>')">[반영처리]</a>
                              <%}%>
                            <%}%>
                        <%}else{%><%=c_db.getNameById(String.valueOf(ht.get("CNG_ID")),"USER")%>&nbsp;<%=ht.get("CNG_DT")%><%}%>
                    </td>                    
                </tr>            
                <tr>
                    <td class=title>해지사유</td>
                    <td colspan="5">&nbsp;<textarea class="autosize" style="width:90%;overflow-y:hidden"><%=ht.get("BIGO")%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>    
    <%			}else if(String.valueOf(ht.get("CNG_ST")).equals("3")){
    				if(String.valueOf(ht.get("CNG_DT")).equals("")){
    					re_act_yn = "N";
    				}    
    %>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><font color=red>재배정요청</font></span></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>구분</td>
                    <td width=36%>&nbsp;<%=ht.get("CNG_CONT")%></td>
                    <td width=14% class=title>출고희망일</td>
                    <td width="36%" >&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("PUR_REQ_DT")))%></td>
                </tr>            
                <tr> 
                    <td class=title>사유</td>
                    <td colspan="3">&nbsp;<textarea class="autosize" style="width:90%;overflow-y:hidden"><%=ht.get("BIGO")%></textarea></td>
                </tr>            
                <tr> 
                    <td class=title>요청일자</td>
                    <td >&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%>&nbsp;<%=ht.get("REG_DT")%></td>
                    <td class=title>처리구분</td>
                    <td >&nbsp;
                        <%if(String.valueOf(ht.get("CNG_DT")).equals("")){%>미반영&nbsp;
                            <%if(nm_db.getWorkAuthUser("자체출고관리",ck_acar_id) || nm_db.getWorkAuthUser("임원",ck_acar_id)){%>    
                                <a href="javascript:update('re_act','<%=ht.get("SEQ")%>')">[반영처리]</a>
                            <%}%>    
                        <%}else{%><%=c_db.getNameById(String.valueOf(ht.get("CNG_ID")),"USER")%>&nbsp;<%=ht.get("CNG_DT")%><%}%></td>                    
                </tr>            
            </table>
        </td>
    </tr>    
    <%			}else if(String.valueOf(ht.get("CNG_ST")).equals("5")){
    %>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><font color=red>고객변경</font></span></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>등록</td>
                    <td width="36%" >&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%>&nbsp;<%=ht.get("REG_DT")%></td>
                    <td width=14% class=title>처리구분</td>
                    <td width="36%">&nbsp;
                        <%if(String.valueOf(ht.get("CNG_DT")).equals("")){%>미반영&nbsp;
                            <%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("자체출고관리",ck_acar_id) || nm_db.getWorkAuthUser("임원",ck_acar_id)){%>     
                            	<%if(String.valueOf(ht.get("CNG_CONT")).equals("신차취소현황으로 보내기") && cpd_bean.getSuc_yn().equals("D")){%>
                    					<%}else{%>                            
                              <a href="javascript:dir_update('cng_cont','<%=ht.get("SEQ")%>')">[반영처리]</a>
                              <%}%>
                            <%}%>
                        <%}else{%><%=c_db.getNameById(String.valueOf(ht.get("CNG_ID")),"USER")%>&nbsp;<%=ht.get("CNG_DT")%><%}%>
                    </td>                    
                </tr>            
            </table>
        </td>
    </tr>                
    <%			}%>    
    <%		}%>     
    <%}%>     
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>배정</span></td>
    </tr>        
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="4" class=title>배정</td>
                    <td width=7% class=title>구분</td>
                    <td width=19%>&nbsp;<b>[<%if(cpd_bean.getDlv_st().equals("1")){%>예정<%}%><%if(cpd_bean.getDlv_st().equals("2")){%>배정<%}%>]</b>&nbsp;
                        <%if(cpd_bean.getDlv_st().equals("1")){%><%=AddUtil.ChangeDate2(cpd_bean.getDlv_est_dt())%><%}%>
                        <%if(cpd_bean.getDlv_st().equals("2")){%><%=AddUtil.ChangeDate2(cpd_bean.getDlv_con_dt())%><%}%>
                    </td>
                    <td width=7% rowspan="3" class=title>배달지</td>
                    <td width=7% class=title>구분</td>
                    <td width="19%" >&nbsp;<%if(cpd_bean.getUdt_st().equals("1") ){%>서울본사<%}%><%if(cpd_bean.getUdt_st().equals("2")){%>부산지점<%}%><%if(cpd_bean.getUdt_st().equals("3")){%>대전지점<%}%><%if(cpd_bean.getUdt_st().equals("4")){%>고객<%}%><%if(cpd_bean.getUdt_st().equals("5")){%>대구지점<%}%><%if(cpd_bean.getUdt_st().equals("6")){%>광주지점<%}%></td>
                    <td width="7%" rowspan="2" class=title>담당자</td>
                    <td width="7%" class=title>부서/성명</td>
                    <td width="20%">&nbsp;<%=cpd_bean.getUdt_mng_nm()%></td>
    		    </tr>
                <tr>
                  <td class=title>출고사무소</td>
                  <td>&nbsp;<%=cpd_bean.getDlv_ext()%></td>
                  <td class=title>지점/상호</td>
                  <td >&nbsp;<%=cpd_bean.getUdt_firm()%></td>
                  <td class=title>연락처</td>
                  <td>&nbsp;<%=cpd_bean.getUdt_mng_tel()%></td>
                </tr>
                <tr>
                  <td class=title>배달탁송료</td>
                  <td>&nbsp;<input type='text' name='cons_amt' maxlength='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>' class='whitenum' size='10' readonly >원</td>
                  <td class=title>주소</td>
                  <td colspan="4" >&nbsp;<%=cpd_bean.getUdt_addr()%></td>
                </tr>	
                <tr>
                  <td class=title>배달탁송사</td>
                  <td colspan="7">&nbsp;상호 : <input type='text' name='cons_off_nm' maxlength='50' value='<%=cpd_bean.getCons_off_nm()%>' class='whitetext' size='40' readonly >
                  	&nbsp;&nbsp;&nbsp;&nbsp;
                  	연락처 : <input type='text' name='cons_off_tel' maxlength='50' value='<%=cpd_bean.getCons_off_tel()%>' class='whitetext' size='20' readonly >
                  	
                  	</td>
                </tr>                
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>
    <%if(!mode.equals("view")){%>
    <%	if(!cpd_bean.getUse_yn().equals("N") && !cpd_bean.getSuc_yn().equals("D")){%>
    <tr>
	    <td align="right">
        <%if(nm_db.getWorkAuthUser("자체출고관리",ck_acar_id) || nm_db.getWorkAuthUser("전산팀",user_id) || ((cpd_bean.getUse_yn().equals("Y") || cpd_bean.getUse_yn().equals("C") || cpd_bean.getSuc_yn().equals("D")) && cpd_bean.getDlv_st().equals("1"))){%>
          <a href="javascript:update('dlv','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
        <%}%>
        <%if((nm_db.getWorkAuthUser("자체출고관리",ck_acar_id) || nm_db.getWorkAuthUser("전산팀",user_id)) && (!cpd_bean.getSettle_dt().equals("") && base.getRent_start_dt().equals(""))){%>
          &nbsp;&nbsp;&nbsp;&nbsp;
          <a href="javascript:update('cons_off','')">[배달탁송사]</a>
        <%}%>
      </td>
    </tr>
    <%	} %>
    <%	if(cpd_bean.getUse_yn().equals("N") && cpd_bean.getSuc_yn().equals("D")){%>
    <%		if(nm_db.getWorkAuthUser("출고관리자",ck_acar_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
    <tr>
	    <td align="right">
          <a href="javascript:update('dlv','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
      </td>
    </tr>   
    <%		} %> 
    <%	} %>
    <%}%>
    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>주문차</td>
                    <td width=19%>&nbsp;<%if(cpd_bean.getOrder_car().equals("Y")){%>주문차<%}%></td>
                    <td>&nbsp;<%if(cpd_bean.getOrder_car().equals("Y")){%>
                    						고객확인:<%=c_db.getNameById(cpd_bean.getOrder_req_id(),"USER")%>&nbsp;<%=cpd_bean.getOrder_req_dt()%>
                    						<%if(cpd_bean.getOrder_req_dt().equals("")){%>
                    							<a href="javascript:dir_update('order_req','')">[고객확인처리]</a>
                    						<%}%>
                    						&nbsp;&nbsp;&nbsp;&nbsp;
                    						주문차확인:<%=c_db.getNameById(cpd_bean.getOrder_chk_id(),"USER")%>&nbsp;<%=cpd_bean.getOrder_chk_dt()%>
                    						<%if(!cpd_bean.getOrder_req_dt().equals("") && cpd_bean.getOrder_chk_dt().equals("")){%>
                    							<!--<a href="javascript:dir_update('order_chk','')">[주문차확인처리]</a> 현대에서만 처리함.-->
                    						<%}%>
                              <%}%>
                    </td>
                </tr>
                <tr> 
                    <td width=14% class=title>재고현황</td>
                    <td width=19%>&nbsp;<%if(cpd_bean.getStock_yn().equals("N")){%>없음<%}%><%if(cpd_bean.getStock_yn().equals("Y")){%>있음<%}%></td>
                    <td>&nbsp;<%if(cpd_bean.getStock_st().equals("1")){%>납기정체(1주일이상)<%}%>
                              <%if(cpd_bean.getStock_st().equals("2")){%>납기지체(1주일이내)<%}%>
                              <%if(cpd_bean.getStock_st().equals("3")){%>납기지연(약1~2일)<%}%>
                              <%if(cpd_bean.getStock_st().equals("4")){%>재고상태 : 일시적<%}%>
                              <%if(cpd_bean.getStock_st().equals("5")){%>재고상태 : 상시적<%}%>
                    </td>
                </tr>
                <tr> 
                    <td width=14% class=title>특이사항</td>
                    <td colspan='2'>&nbsp;<textarea class="autosize" style="width:90%;overflow-y:hidden"><%=cpd_bean.getBigo()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>         
    <tr>
        <td class=h></td>
    </tr>
    <%if(!mode.equals("view")){%>
    <%if(!cpd_bean.getUse_yn().equals("N") && !cpd_bean.getSuc_yn().equals("D")){%>
    <%if(nm_db.getWorkAuthUser("자체출고관리",ck_acar_id) || nm_db.getWorkAuthUser("전산팀",user_id) || ((cpd_bean.getUse_yn().equals("Y") || cpd_bean.getUse_yn().equals("C") || cpd_bean.getSuc_yn().equals("D")) && cpd_bean.getDlv_st().equals("1"))){%>
    <tr>
	<td align="right"><a href="javascript:update('stock','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
    <tr>	    
    <%}%>
    <%}%>
    <%}%>
    
    <%if(vt_size > 0){%>
    <%		for(int i = 0 ; i < vt_size ; i++){
    			Hashtable ht = (Hashtable)vt.elementAt(i);%>
    <%			if(String.valueOf(ht.get("CNG_ST")).equals("4")){
    %>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><font color=red>배정후 변경사항</font></span></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>구분</td>
                    <td colspan='3'>&nbsp;<%=ht.get("CNG_CONT")%></td>
                </tr>            
                <tr> 
                    <td class=title>사유</td>
                    <td colspan='3'>&nbsp;<textarea class="autosize" style="width:90%;overflow-y:hidden"><%=ht.get("BIGO")%></textarea></td>
                </tr> 
                <tr> 
                    <td class=title>요청일자</td>
                    <td width=36% >&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%>&nbsp;<%=ht.get("REG_DT")%></td>
                    <td width=14% class=title>처리구분</td>
                    <td width=36% >&nbsp;
                        <%if(String.valueOf(ht.get("CNG_DT")).equals("")){%>미반영&nbsp;
                            <%if(nm_db.getWorkAuthUser("자체출고관리",ck_acar_id) || nm_db.getWorkAuthUser("임원",ck_acar_id)){%>    
                                <a href="javascript:dir_update('end_act','<%=ht.get("SEQ")%>')">[반영처리]</a>
                            <%}%>    
                        <%}else{%><%=c_db.getNameById(String.valueOf(ht.get("CNG_ID")),"USER")%>&nbsp;<%=ht.get("CNG_DT")%><%}%></td>                    
                </tr>                              
            </table>
        </td>
    </tr>         			
    <%			}	
    		}
      }%>		
    
      	    
    
    <%if(!cpd_bean.getDlv_dt().equals("")){%>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>출고일자</td>
                    <td width=19%>&nbsp;<%=AddUtil.ChangeDate2(cpd_bean.getDlv_dt())%></td>
                    <td width=14% class=title>등록자</td>
                    <td width=53%>&nbsp;<%=c_db.getNameById(cpd_bean.getSettle_id(),"USER")%>&nbsp;<%=cpd_bean.getSettle_dt()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%if(!mode.equals("view")){%>
    <%if(!cpd_bean.getUse_yn().equals("N") && !cpd_bean.getSuc_yn().equals("D")){%>
    <%		if(base.getDlv_dt().equals("") && (nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("자체출고관리",ck_acar_id) )){%>
    <tr>
	<td align="right"><a href="javascript:update('dlv_dt','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
    <tr>	    
    <%		}%>
    <%	}%>    
    <%}%>    
    <%}%>
    <%if(cpd_bean.getCar_comp_id().equals("0001") && !user_bean.getDept_id().equals("8888") && !pur.getPur_com_firm().equals("")){%>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>영업담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%>
                    <%	if(!base.getAgent_emp_id().equals("")){
                    		CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id());
                    %>
                    		(에이전트 계약진행담당자 : <%=a_coe_bean.getEmp_nm()%>&nbsp;<%=a_coe_bean.getEmp_m_tel()%>)
                    <%	}%>  
                    </td>
                </tr>
            </table>
        </td>
    </tr>    
    <tr>
        <td class=h></td>
    </tr>     <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
		    <td colspan='2' class=title>변경전</td>
		    <td colspan='2' class=title>변경후(특판)</td>
                </tr>
                <tr> 
                    <td width=15% class=title>고객구분</td>
		    <td width=35% class=title>상호</td>
		    <td width=15% class=title>고객구분</td>
		    <td width=35% class=title>상호</td>
                </tr>
                <tr> 									
                    <td>&nbsp;<%if(client.getClient_st().equals("1")) 	out.println("법인");
                      	else if(client.getClient_st().equals("2"))  	out.println("개인");
                      	else if(client.getClient_st().equals("3")) 	out.println("개인사업자(일반과세)");
                      	else if(client.getClient_st().equals("4"))	out.println("개인사업자(간이과세)");
                      	else if(client.getClient_st().equals("5")) 	out.println("개인사업자(면세사업자)");%>
                    </td>
                    <td>&nbsp;<%=client.getFirm_nm()%></td>
                    <td>&nbsp;법인</td>
		    <td>&nbsp;<%=pur.getPur_com_firm()%>		        
		        <%if(pur.getPur_com_firm().equals("")){%>
		            <%=client.getFirm_nm()%>		            
		        <%}else{%>
		            &nbsp;<%=AddUtil.ChangeEnt_no(c_db.getNameById(pur.getPur_com_firm(),"ENP_NO"))%>
		        <%}%>
		    </td>
                </tr>
            </table>
        </td>
    </tr>      
    <%}else{%>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>영업담당자</td>
                    <td width=19%>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%>
                    <%	if(!base.getAgent_emp_id().equals("")){
                    		CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id());
                    %>
                    		(에이전트 계약진행담당자 : <%=a_coe_bean.getEmp_nm()%>&nbsp;<%=a_coe_bean.getEmp_m_tel()%>)
                    <%	}%>  
                    </td>
                    <td width=14% class=title>상호</td>
                    <td width=53%>&nbsp;<%=pur.getPur_com_firm()%>                        
                        <%if(pur.getPur_com_firm().equals("")){%>
                            <%=client.getFirm_nm()%>
                        <%}else{%>
                            &nbsp;<%=AddUtil.ChangeEnt_no(c_db.getNameById(pur.getPur_com_firm(),"ENP_NO"))%>
                        <%}%>
                        
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%}%>
    <tr>
        <td class=h></td>
    </tr>
    <%if(!cng_bean.getRent_mng_id().equals("") && cng_bean.getCar_g_amt() > 0 ){%>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>차량가격</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt1' value='<%=AddUtil.parseDecimal(cng_bean.getCar_g_amt())%>' class='whitenum' size='10' readonly >원</td>
                    <td width=14% class=title>배달탁송료</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt2' value='<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>' class='whitenum' size='10' readonly >원</td>
                    <td width=14% class=title>합계</td>
                    <td width=20%>&nbsp;<input type='text' name='car_amt3' value='<%=AddUtil.parseDecimal(cng_bean.getCar_g_amt()+cpd_bean.getCons_amt())%>' class='whitenum' size='10' readonly >원</td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else{%>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>차량가격</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt1' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_g_amt())%>' class='whitenum' size='10' readonly >원</td>
                    <td width=14% class=title>배달탁송료</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt2' value='<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>' class='whitenum' size='10' readonly >원</td>
                    <td width=14% class=title>합계</td>
                    <td width=20%>&nbsp;<input type='text' name='car_amt3' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_g_amt()+cpd_bean.getCons_amt())%>' class='whitenum' size='10' readonly >원</td>
                </tr>
            </table>
        </td>
    </tr>           
    <%}%>
    
    <%if(from_page.equals("/fms2/pur_com/pur_dlv_frame.jsp")){
    		if(pur.getPur_pay_dt().equals("")) pur.setPur_pay_dt(pur.getPur_est_dt());
    		
    		//카드정보
		CardBean card_bean = CardDb.getCard(pur.getCardno1());
    %>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><font color=red>카드결재정보</font></span></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>카드사</td>
                    <td width=10%>&nbsp;<%=pur.getCard_kind1()%></td>
                    <td width=10% class=title>카드번호</td>
                    <td width=26%>&nbsp;<%=pur.getCardno1()%>&nbsp;&nbsp;(<%=AddUtil.ChangeDate(card_bean.getCard_edate(),"MM/YY")%>)</td>
                    <td width=10% class=title>대금지급일</td>
                    <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(pur.getPur_pay_dt())%></td>
                    <td width=10% class=title>결재금액</td>
                    <td width=10%>&nbsp;<%=AddUtil.parseDecimal(pur.getTrf_amt1())%>원</td>
                </tr>       
                <%if(pur.getTrf_st2().equals("2") || pur.getTrf_st2().equals("3") || pur.getTrf_st2().equals("7")){
                		card_bean = CardDb.getCard(pur.getCardno2());
                %>  
                <tr> 
                    <td width=14% class=title>카드사</td>
                    <td width=10%>&nbsp;<%=pur.getCard_kind2()%></td>
                    <td width=10% class=title>카드번호</td>
                    <td width=26%>&nbsp;<%=pur.getCardno2()%>&nbsp;&nbsp;(<%=AddUtil.ChangeDate(card_bean.getCard_edate(),"MM/YY")%>)</td>
                    <td width=10% class=title>대금지급일</td>
                    <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(pur.getPur_pay_dt())%></td>
                    <td width=10% class=title>결재금액</td>
                    <td width=10%>&nbsp;<%=AddUtil.parseDecimal(pur.getTrf_amt2())%>원</td>
                </tr>                
                <%} %>     
                <%if(pur.getTrf_st3().equals("2") || pur.getTrf_st3().equals("3") || pur.getTrf_st3().equals("7")){
                		card_bean = CardDb.getCard(pur.getCardno3());
                %>  
                <tr> 
                    <td width=14% class=title>카드사</td>
                    <td width=10%>&nbsp;<%=pur.getCard_kind3()%></td>
                    <td width=10% class=title>카드번호</td>
                    <td width=26%>&nbsp;<%=pur.getCardno3()%>&nbsp;&nbsp;(<%=AddUtil.ChangeDate(card_bean.getCard_edate(),"MM/YY")%>)</td>
                    <td width=10% class=title>대금지급일</td>
                    <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(pur.getPur_pay_dt())%></td>
                    <td width=10% class=title>결재금액</td>
                    <td width=10%>&nbsp;<%=AddUtil.parseDecimal(pur.getTrf_amt3())%>원</td>
                </tr>                
                <%} %>                            
            </table>
        </td>
    </tr>         	    
    <%}%>
    
    <tr>
	<td align="right">&nbsp;</td>
    <tr>     
    <%if(!mode.equals("view")){%>
    <%if(!cpd_bean.getUse_yn().equals("N") && !cpd_bean.getSuc_yn().equals("D")){%>
    <!-- 예정현황 -->
    <%if(cpd_bean.getDlv_st().equals("1") && cpd_bean.getSettle_dt().equals("")){%>	   
    <tr>
	<td align='center'>	 
	    
	    <%if(cng_act_yn.equals("N")){%>	   
	    * 변경계약이 미반영되었습니다. 먼저 반영처리가 되어야 재배정요청/계약변경/계약해지/출고배정/고객변경을 할 수 있습니다.
	    <%}else{%>
	        <%if(cls_act_yn.equals("N")){%>	
	        * 계약해지가 미반영되었습니다. 반영처리를 하면 배정현황에서 빠집니다.<br>
	        <%}else{%>	
	        	<%if((cpd_bean.getUse_yn().equals("Y") || cpd_bean.getUse_yn().equals("C") || cpd_bean.getSuc_yn().equals("D"))){%>   
	        		     
	        			<a href="javascript:update('re','')"     title='재배정요청'   onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_ask_jbj.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;	
	        			<%if(!cpd_bean.getUse_yn().equals("N")){%>
	        			<a href="javascript:update('cng','')"    title='계약변경'     onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify_gyk.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp; 
	        				<%if(ej_bean.getJg_g_7().equals("3")){ %>
			        			<%if(nm_db.getWorkAuthUser("전기차출고관리",ck_acar_id)){		//전기차는 함윤원 과장, 조현준 대리만 권한 %>
			        				<a href="javascript:update('cls1','')"   title='납품취소해지' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_hj_npcs.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
			        			<%} %>	
	        				<%}else{ %>
			        			<a href="javascript:update('cls1','')"   title='납품취소해지' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_hj_npcs.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
	        				<%} %>  
	        			<!-- <a href="javascript:update('cls2','')"   title='차종변경해지' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_hj_cjbg.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp; -->	
	        			<%}%>
	        			<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("자체출고관리",ck_acar_id) || nm_db.getWorkAuthUser("임원",ck_acar_id)){%>     
	        			<a href="javascript:update('settle','')" title='출고'         onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_cgo.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	        			<%}%>	        			

              			<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("자체출고관리",ck_acar_id) || nm_db.getWorkAuthUser("임원",ck_acar_id)){%>     
	        			<a href="javascript:update('con','')"    title='출고배정'     onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_cgbj.gif align=absmiddle border=0></a>&nbsp;&nbsp;
        				<%}%>
	        	<%}%>
	        <%}%>	        
	    <%}%>
	    
	    
	        
	</td>
    </tr>	
    <%}%>
    <%}%>
    <!-- 배정현황 -->
    <%if(cpd_bean.getDlv_st().equals("2") && cpd_bean.getSettle_dt().equals("")){%>	 
    <tr>
	<td align='center'>	
	        	<%if((cpd_bean.getUse_yn().equals("Y") || cpd_bean.getUse_yn().equals("C") || cpd_bean.getSuc_yn().equals("D"))){%>   	        		
	        		
	        			<a href="javascript:update('re','')"     title='재배정요청'   onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_ask_jbj.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;		        			
	        			<%if(!cpd_bean.getUse_yn().equals("N")){%>
	        			<a href="javascript:update('cng','')"    title='계약변경'     onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify_gyk.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
	        				<%if(ej_bean.getJg_g_7().equals("3")){ %>
			        			<%if(nm_db.getWorkAuthUser("전기차출고관리",ck_acar_id)){		//전기차는 함윤원 과장, 조현준 대리만 권한 %>
			        				<a href="javascript:update('cls1','')"   title='납품취소해지' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_hj_npcs.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
			        			<%} %>	
	        				<%}else{ %>
			        			<a href="javascript:update('cls1','')"   title='납품취소해지' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_hj_npcs.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
	        				<%} %>
	        			<a href="javascript:update('cng2','')"   title='배정후변경'   onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify_bj.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
	        			<%}%>	        			
	        			<a href="javascript:update('cls3','')"   title='배정취소'     onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_cancel_bj.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	        			<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("자체출고관리",ck_acar_id) || nm_db.getWorkAuthUser("임원",ck_acar_id)){%>     
	        			<a href="javascript:update('settle','')" title='출고'         onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_cgo.gif align=absmiddle border=0></a>&nbsp;&nbsp;
	        			<%}%>
               	<%}else{%>	 
               		<%if(!cpd_bean.getUse_yn().equals("N")){%>       		        			
	        			<a href="javascript:update('cng2','')"   title='배정후변경'   onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify_bj.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
	        		<%}%>	
	        	<%}%>
	</td>
    </tr>	    
    <%}%>

    <%}%>
    
    <%if(cpd_bean.getUse_yn().equals("N")){%>   	
    <tr>
        <td align='center'>
	        	<!--해지취소-->
	        	<%	if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("자체출고관리",ck_acar_id) || nm_db.getWorkAuthUser("임원",ck_acar_id)){%>
	        	<%		if(cpd_bean.getSuc_yn().equals("") || cpd_bean.getSuc_yn().equals("N")){%>
	        	<input type="button" class="button" id="revival" value='해지취소후 부활' onclick="javascript:dir_update('revival', '<%=max_cng_seq%>');">
	        	<%		}%>
	        	<%	}%>        
        </td>
    </tr> 
    <%	}%>	


    
    <tr>
        <td class=h></td>
    </tr> 
    <%if(!base.getDlv_dt().equals("")){%>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="2" class=title>인수</td>
                    <td width=7% class=title>인수일자</td>
                    <td width=19%>&nbsp;<%=AddUtil.ChangeDate2(pur.getUdt_est_dt())%></td>
                    <td width=7% rowspan="2" class=title>자동차등록</td>
                    <td width=7% class=title>등록일자</td>
                    <td width="19%" >&nbsp;<%=cr_bean.getInit_reg_dt()%></td>
                    <td width=7% rowspan="2" class=title>스캔</td>
                    <td width=14% class=title>자동차등록증</td>
                    <td width="13%">&nbsp;
                    <%	for(int i=0; i<ch_r.length; i++){
    				ch_bean = ch_r[i];
    				if(ch_bean.getScanfile().equals("")) continue;	%>
                            <%	if(ch_bean.getFile_type().equals("")){%>
    			    <a href="javascript:MM_openBrWindow2('<%=ch_bean.getScanfile()%>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><%=ch_bean.getScanfile()%>.pdf</a>
			    <%	}else{%>
    			    <a href="javascript:ScanOpen2('<%= ch_bean.getScanfile() %>','<%= ch_bean.getFile_type() %>')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a> 					
			    <%	}%>    					
		    <%	}%>	    
                    </td>
    		    </tr>
                <tr>
                  <td class=title>인수자</td>
                  <td>&nbsp;<%String udt_st = pur.getUdt_st();%><%if(udt_st.equals("1")){%>서울본사 <%}else if(udt_st.equals("2")){%>부산지점 <%}else if(udt_st.equals("3")){%>대전지점 <%}else if(udt_st.equals("4")){%>고객 <%}else if(udt_st.equals("5")){%>대구지점 <%}else if(udt_st.equals("6")){%>광주지점 <%}%></td>
                  <td class=title>등록번호</td>
                  <td >&nbsp;<%=cr_bean.getCar_no()%></td>
                  <td class=title>면세물품반출신고서</td>
                  <td>&nbsp;
                    	<%
				content_code = "LC_SCAN";
				content_seq  = rent_mng_id+""+rent_l_cd+"1"+"23";

				attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);		
				attach_vt_size = attach_vt.size();		                    	
				
				int scan_cnt = 0;
                    	%>
                    	
						<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);       								    								    											
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
    						<%	}%>
    						<%}%>
    						                  
                  </td>
                </tr>	
            </table>
        </td>
    </tr>   
    <%}%> 
    

        
    <%if(mode.equals("view")){%>
    <tr>
	<td align="right"><a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    <tr>    
    <%}%>  
    <%if(!mode.equals("view")){%> 
    <%if(!cpd_bean.getSettle_dt().equals("")){%>	 
    <tr>
	<td align='center'>	 
	        	<%if(!cpd_bean.getUse_yn().equals("N")){%>   	        		
        			<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("자체출고관리",ck_acar_id) ){%>
        				<%if(ej_bean.getJg_g_7().equals("3")){ %>
		        			<%if(ck_acar_id.equals("000144")||ck_acar_id.equals("000197")||nm_db.getWorkAuthUser("전산팀",ck_acar_id)){		//전기차는 함윤원 과장, 조현준 대리만 권한 %>
		        				<a href="javascript:update('cls1','')" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_hj_npcs.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
		        			<%} %>	
        				<%}else{ %>
		        			<a href="javascript:update('cls1','')" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_hj_npcs.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
        				<%} %>
        			<%}%>
	        	<%}%>
	</td>
    </tr>	    
    <%}%>  
    <%}%>        
    
    <!--신차취소현황으로 보내기 상태에서 예약자가 없으면 납부취소 처리할수 있다.-->
    <%if(cpd_bean.getSuc_yn().equals("D")){%>
    <tr>
	<td align='center'>	 
        			<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("자체출고관리",ck_acar_id) ){%> 
       				   <%if(ej_bean.getJg_g_7().equals("3")){ %>
		        			<%if(ck_acar_id.equals("000144")||ck_acar_id.equals("000197")||nm_db.getWorkAuthUser("전산팀",ck_acar_id)){		//전기차는 함윤원 과장, 조현준 대리만 권한 %>
		        				<a href="javascript:dir_update('cls5','')" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_hj_npcs.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
		        			<%} %>	
        				<%}else{ %>
		        			<a href="javascript:dir_update('cls5','')" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_hj_npcs.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
        				<%} %>
        			<%}%>
	</td>
    </tr>	        
    <%}%>    

    
</table>
</form>
<script language="JavaScript">
<!--	
var txtArea = $(".autosize");
if (txtArea) {
    txtArea.each(function(){
        $(this).height(this.scrollHeight);
    });
}
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

