<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.user_mng.*, acar.car_sche.*,acar.common.*, acar.car_office.*, acar.car_mst.*, acar.consignment.*, acar.estimate_mng.*,acar.client.*, acar.tint.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="pt_db" scope="page" class="acar.partner.PartnerDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	//기아자동차 탁송 선등록 페이지
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//출고정보
	ContPurBean pur = a_db.getContPur(m_id, l_cd);
	
	CommiBean emp2 	= a_db.getCommi(m_id, l_cd, "2");
	
	//영업사원
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp2.getEmp_id());
	
	String gubun = c_db.getNameByIdCode("0032", "", car.getCar_ext());
	
	
	
	Hashtable est = a_db.getRentEst(m_id, l_cd);
	
	//기존 배달탁송 등록이 있는지 확인
	ConsignmentBean cons = cs_db.getConsignmentPur(m_id, l_cd);
	
	//출고대리인
	Hashtable cons_man = cs_db.getConsignmentPurMan(cm_bean.getCar_comp_id(), pur.getDlv_ext(), pur.getOff_id());
	
	
	//출고대리인 리스트
	Vector vt = cs_db.getConsignmentPurManList(cm_bean.getCar_comp_id(), pur.getOff_id(), pur.getDlv_ext());
	int vt_size = vt.size();
	
	UsersBean udt_mng_bean_s 	= umd.getUsersBean(nm_db.getWorkAuthUser("본사주차장관리"));
	UsersBean udt_mng_bean_b2 	= umd.getUsersBean(nm_db.getWorkAuthUser("부산주차장관리"));
	UsersBean udt_mng_bean_b 	= umd.getUsersBean(nm_db.getWorkAuthUser("부산지점장"));
	UsersBean udt_mng_bean_d 	= umd.getUsersBean(nm_db.getWorkAuthUser("대전지점장"));			
	UsersBean udt_mng_bean_g 	= umd.getUsersBean(nm_db.getWorkAuthUser("대구지점장"));
	UsersBean udt_mng_bean_j 	= umd.getUsersBean(nm_db.getWorkAuthUser("광주지점장"));
	
	//용품	
	TintBean tint1 	= t_db.getCarTint(m_id, l_cd, "1");
	TintBean tint2 	= t_db.getCarTint(m_id, l_cd, "2");	
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function update(){		
		var fm = document.form1;
		
		if(fm.dlv_ext.value == '')		{	alert('출고지를 입력하여 주십시오.'); 			fm.dlv_ext.focus(); 		return;		}
		if(fm.dlv_est_dt.value == '')		{	alert('출고예정일자를 입력하여 주십시오.'); 		fm.dlv_est_dt.focus(); 		return;		}
		if(fm.udt_st.value == '')		{	alert('인수지를 입력하여 주십시오.'); 			fm.udt_st.focus(); 		return;		}
		if(fm.off_id.value == '')		{ 	alert('탁송업체를 선택하십시오.'); 							return; 	}
		if(fm.rpt_no.value == '')		{	alert('계출번호를 입력하여 주십시오.'); 		fm.rpt_no.focus(); 		return;		}
		if(fm.cons_amt1.value == '' || fm.cons_amt1.value == '0'){	alert('탁송료를 입력하여 주십시오.'); 	fm.cons_amt1.focus(); 		return;		}
		
		var dlv_chk = 0;
		//출고차량탁송구분별 점검
		//현대차-아산-상원물류-인수지(영남/광주/부산/대구/대전)
		if(fm.car_comp_id.value=='0001' && fm.dlv_ext.value=='아산' && fm.off_id.value=='011372' && (fm.udt_st.value=='1'||fm.udt_st.value=='2'||fm.udt_st.value=='3'||fm.udt_st.value=='5'||fm.udt_st.value=='6')){
			dlv_chk = 1;
		}
		//현대차-울산-상원물류-인수지(영남/대전)
		if(fm.car_comp_id.value=='0001' && fm.dlv_ext.value=='울산' && fm.off_id.value=='011372' && (fm.udt_st.value=='1'||fm.udt_st.value=='3')){
			dlv_chk = 1;
		}
		//기아차-화성-삼진특수-인수지(영남/광주/부산/대구)
		if(fm.car_comp_id.value=='0002' && fm.dlv_ext.value=='화성' && fm.off_id.value=='007751' && (fm.udt_st.value=='1'||fm.udt_st.value=='2'||fm.udt_st.value=='5'||fm.udt_st.value=='6')){
			dlv_chk = 1;
		}
		//기아차-광주-삼진특수-인수지(부산/대구)
		if(fm.car_comp_id.value=='0002' && fm.dlv_ext.value=='광주' && fm.off_id.value=='007751' && (fm.udt_st.value=='2'||fm.udt_st.value=='5')){
			dlv_chk = 1;
		}
		//신화로직스는 일단 가능하게  - 20210812
		if ( fm.off_id.value=='010265') {
			dlv_chk = 1;
		}
		//삼성차 제외
		if (fm.car_comp_id.value=='0003') {
			dlv_chk = 1;
		}
				
		if(fm.cons_st.value == '2' && dlv_chk==0){
			alert('자체탁송 불가능한 <출고지-인수지-탁송사>입니다. 확인하십시오.'); return;
		}

		fm.to_place.value = fm.udt_st.options[fm.udt_st.selectedIndex].text;
		
		if(confirm('등록 하시겠습니까?')){	
			fm.action='reg_cons_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}
	}
	
	//탁송업체 조회
	function search_off()
	{
		var fm = document.form1;
		if(fm.dlv_ext.value == '')		{ 	alert('출고지를 선택하십시오.'); 				return;	}
		if(fm.udt_st.value == '')		{	alert('인수지를 선택하십시오.'); 				return; }			
		window.open("/agent/cus0601/cus0602_frame.jsp?from_page=/agent/car_pur/reg_cons.jsp&t_wd="+fm.off_nm.value, "SERV_OFF", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		

	//탁송업체 탁송료 조회
	function search_off_amt()
	{
		var fm = document.form1;		
		if(fm.dlv_ext.value == '')		{ 	alert('출고지를 선택하십시오.'); 				return;	}
		if(fm.udt_st.value == '')		{	alert('인수지를 선택하십시오.'); 				return; }
		if(fm.off_id.value == '')		{	alert('탁송업체를 선택하십시오.'); 				return; }
		var o_url = "/agent/cons_cost/s_cons_cost.jsp?car_comp_id=<%=cm_bean.getCar_comp_id()%>&car_cd=<%=cm_bean.getCode()%>&off_id="+fm.off_id.value+"&off_nm="+fm.off_nm.value+"&dlv_ext="+fm.dlv_ext.value+"&udt_st="+fm.udt_st.value;
		window.open(o_url, "CONS_COST", "left=10, top=10, width=800, height=500, scrollbars=yes, status=yes, resizable=yes");
	}	
	
	//차량인수지 선택시 용품업체 셋팅
	function cng_input1(value){
		var fm = document.form1;
				
		if(value == '영등포 영남주차장'){		
			fm.udt_addr.value 	= '서울시 영등포구 영등포로 34길 9';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_s.getDept_nm()%> <%=udt_mng_bean_s.getUser_nm()%> <%=udt_mng_bean_s.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_s.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_s.getUser_id()%>';
			
		}else if(value == '유림카(썬팅집)'){
			fm.udt_addr.value 	= '부산광역시 연제구 연산4동 700-5';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b.getDept_nm()%> <%=udt_mng_bean_b.getUser_nm()%> <%=udt_mng_bean_b.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b.getUser_id()%>';
			
		}else if(value == '조양골프연습장 주차장'){			
			fm.udt_addr.value 	= '부산광역시 연제구 연산4동 585-1';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';
			
		}else if(value == '스마일TS'){			
			fm.udt_addr.value 	= '부산시 연제구 안연로7번나길 10(연산동 363-13번지)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';	

		}else if(value == '웰메이드오피스텔 지하1층 주차장'){			
			fm.udt_addr.value 	= '부산광역시 연제구 거제천로 230번길 70 지하1층 (연산동,웰메이드오피스텔)웰메이드주차장';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';
			
		}else if(value == '오토카용품'){
			fm.udt_addr.value 	= '대전광역시 유성구 노은동 527-5';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_d.getDept_nm()%> <%=udt_mng_bean_d.getUser_nm()%> <%=udt_mng_bean_d.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_d.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_d.getUser_id()%>';
			
		}else if(value == '미성테크'){
			fm.udt_addr.value 	= '대전광역시 유성구 온천북로59번길 10(봉명동 690-3)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_d.getDept_nm()%> <%=udt_mng_bean_d.getUser_nm()%> <%=udt_mng_bean_d.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_d.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_d.getUser_id()%>';
			
		}else if(value == '대구 썬팅집'){
			fm.udt_addr.value 	= '대구광역시 달서구 신당동 321-86';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_g.getDept_nm()%> <%=udt_mng_bean_g.getUser_nm()%> <%=udt_mng_bean_g.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_g.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_g.getUser_id()%>';			
		}else if(value == '용용이자동차용품점'){
			fm.udt_addr.value 	= '광주광역시 광산구 상무대로 233 (송정동 1360)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_j.getDept_nm()%> <%=udt_mng_bean_j.getUser_nm()%> <%=udt_mng_bean_j.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_j.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_j.getUser_id()%>';			
		}else if(value == '<%=client.getFirm_nm()%>'){
			fm.udt_addr.value 	= '<%=client.getO_addr()%>';
			fm.udt_mng_nm.value 	= '<%=client.getCon_agnt_dept()%> <%=client.getCon_agnt_nm()%> <%=client.getCon_agnt_title()%>';
			fm.udt_mng_tel.value 	= '<%=client.getO_tel()%>';
			fm.udt_mng_id.value     = '';
		}				
	}		
		
	function set_cons_amt(){
	}	
	
	function view_cons_man(){
		window.open("/fms2/pur_com/consp_man_sc.jsp", "VIEW_MAN", "left=200, top=200, width=800, height=500, scrollbars=yes, status=yes, resizable=yes");
	}	
	
	function cons_man_sms(){
		var fm = document.form1;
		
		if(fm.destname.value == '')		{	alert('수신자를 입력하여 주십시오.'); 			fm.destname.focus(); 		return;		}
		if(fm.destphone.value == '')		{	alert('수신번호를 입력하여 주십시오.'); 		fm.destphone.focus(); 		return;		}
		if(fm.msg.value == '')			{	alert('문자내용을 입력하여 주십시오.'); 		fm.msg.focus(); 		return;		}
		
		if(confirm('등록 하시겠습니까?')){	
			fm.action='reg_cons_sms_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}		
	}	
	
	//출고대리인리스트 보여주기
	function cons_man_list(){
		var fm = document.form1;		
		fm.action='reg_cons_mans.jsp';		
		fm.target='inner1';
		fm.submit();
	}	
	
	//출고지, 인수지로 탁송업체 디폴트
	function setOff(){
		var fm = document.form1;		
		
		if(<%=AddUtil.getDate(4)%> >= 20150429){
			if('<%=cm_bean.getCar_comp_id()%>' == '0001'){
				if(fm.dlv_ext.value == '울산' && ( fm.udt_st.value == '2' || fm.udt_st.value == '6' || fm.udt_st.value == '5')){
					fm.off_id.value = '007751';
					fm.off_nm.value = '(주)삼진특수';
				}else{	
					fm.off_id.value = '011372';
					fm.off_nm.value = '상원물류(주)';
				}
				<%if(cons.getCons_no().equals("")){%> 		
				tr_driver1.style.display	= '';
				<%}%>
				tr_driver2.style.display	= 'none';
				
				
			}else if('<%=cm_bean.getCar_comp_id()%>' == '0002'){
				if(fm.udt_st.value == '3' || fm.dlv_ext.value == '소하리' || fm.dlv_ext.value == '서산'){
					
				}else if((fm.udt_st.value == '1' || fm.udt_st.value == '6') && fm.dlv_ext.value == '광주'){
					fm.off_id.value = '011372';
					fm.off_nm.value = '상원물류(주)';
					
					<%if(cons.getCons_no().equals("")){%> 
					tr_driver1.style.display	= '';
					<%}%>			
					tr_driver2.style.display	= 'none';
					
				}else{
					fm.off_id.value = '007751';
					fm.off_nm.value = '(주)삼진특수';	
					
					<%if(cons.getCons_no().equals("")){%> 
					tr_driver1.style.display	= '';
					<%}%>
					tr_driver2.style.display	= 'none';		
					
				}
			}else if('<%=cm_bean.getCar_comp_id()%>' == '0003'){
				if(fm.udt_st.value == '1' || fm.udt_st.value == '3' || fm.udt_st.value == '6'){
					fm.off_id.value = '010265';
					fm.off_nm.value = '(주)신화로직스';	
					
					<%if(cons.getCons_no().equals("")){%> 
					tr_driver1.style.display	= '';
					tr_driver2.style.display	= 'none';		
					<%}%>
				
				}else if(fm.udt_st.value == '2' || fm.udt_st.value == '5'){
					fm.off_id.value = '010266';
					fm.off_nm.value = '대명운수';	
					
					<%if(cons.getCons_no().equals("")){%> 
					tr_driver1.style.display	= '';
					<%}%>
					tr_driver2.style.display	= 'none';		
					
				
				}
			}
			<%if(cons.getCons_no().equals("")){%> 
			cons_man_list();
			<%}%>
		}	
		
		var deposit_len = fm.udt_firm.length;			
		for(var i = 1 ; i < deposit_len ; i++){
			fm.udt_firm.options[i] = null;			
		}
						
		
		if(fm.udt_st.value == '1'){
			fm.udt_firm.options[1] = new Option('영등포 영남주차장', '영등포 영남주차장');
			fm.udt_firm.value = '영등포 영남주차장';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '2'){
			<%if(AddUtil.getDate2(4) >= 20210205){%>
			fm.udt_firm.options[1] = new Option('스마일TS', '스마일TS');
			fm.udt_firm.options[2] = new Option('웰메이드오피스텔 지하1층 주차장', '웰메이드오피스텔 지하1층 주차장');
			fm.udt_firm.options[3] = new Option('유림카(썬팅집)', '유림카(썬팅집)');
			fm.udt_firm.value = '스마일TS';
			<%}else{%>
			fm.udt_firm.options[1] = new Option('조양골프연습장 주차장', '조양골프연습장 주차장');
			fm.udt_firm.options[2] = new Option('웰메이드오피스텔 지하1층 주차장', '웰메이드오피스텔 지하1층 주차장');
			fm.udt_firm.options[3] = new Option('유림카(썬팅집)', '유림카(썬팅집)');
			fm.udt_firm.options[4] = new Option('스마일TS', '스마일TS');
			fm.udt_firm.value = '조양골프연습장 주차장';
			<%}%>
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '3'){
			fm.udt_firm.options[1] = new Option('미성테크', '미성테크');
			fm.udt_firm.value = '미성테크';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '5'){
			fm.udt_firm.options[1] = new Option('대구 썬팅집', '대구 썬팅집');
			fm.udt_firm.value = '대구 썬팅집';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '6'){
			fm.udt_firm.options[1] = new Option('용용이자동차용품점', '용용이자동차용품점');
			fm.udt_firm.value = '용용이자동차용품점';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '4'){
			fm.udt_firm.options[1] = new Option('<%=client.getFirm_nm()%>', '<%=client.getFirm_nm()%>');
			fm.udt_firm.value = '<%=client.getFirm_nm()%>';
			cng_input1(fm.udt_firm.value);
		}		
		
		
	}						
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post'>
<input type='hidden' name="m_id" value="<%=m_id%>">
<input type='hidden' name="l_cd" value="<%=l_cd%>">
<input type='hidden' name="mode" value="<%=mode%>">
<input type='hidden' name="car_nm" value="<%=est.get("CAR_NM")%> <%=est.get("CAR_NAME")%>">
<input type='hidden' name="car_comp_id" value="<%=cm_bean.getCar_comp_id()%>">
<input type='hidden' name="to_place" value="">
<table border="0" cellspacing="0" cellpadding="0" width=670>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>차량대금지급요청문서 기안전 자체탁송 등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>계약번호</td>
                    <td width='29%'>&nbsp;<%=l_cd%></td>
                    <td class='title' width='15%'>상호</td>
                    <td width='41%'>&nbsp;<%=est.get("FIRM_NM")%></td>
                </tr>
                <tr> 
                    <td class='title'>등록지역</td>
                    <td>&nbsp;<%=gubun%></td>
                    <td class='title'>차명</td>
                    <td>&nbsp;<%=est.get("CAR_NM")%> <%=est.get("CAR_NAME")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>탁송의뢰</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>			
                <tr> 
                    <td width=3% rowspan="2" class=title>출<br>고</td>
                    <td width=7% class=title>출고지</td>
                    <td width=15%>
                      <select name='dlv_ext' class='default' onchange="javascript:setOff();cons_man_list();">
                        <option value="">선택</option>     
                        <%if(emp2.getCar_comp_id().equals("0001")){%>
        				<option value='아산' <%if(pur.getDlv_ext().equals("아산"))%>selected<%%>>아산</option>
        				<option value='울산' <%if(pur.getDlv_ext().equals("울산"))%>selected<%%>>울산</option>        				
        		<%}else if(emp2.getCar_comp_id().equals("0002")){%>		
        				<option value='소하리' <%if(pur.getDlv_ext().equals("소하리"))%>selected<%%>>소하리</option>
        				<option value='화성' <%if(pur.getDlv_ext().equals("화성"))%>selected<%%>>화성</option>        				
        				<option value='광주' <%if(pur.getDlv_ext().equals("광주"))%>selected<%%>>광주</option>
        				<option value='서산' <%if(pur.getDlv_ext().equals("서산"))%>selected<%%>>서산</option>
        		<%}else if(emp2.getCar_comp_id().equals("0003")){%>		
        				<option value='부산' <%if(pur.getDlv_ext().equals("부산"))%>selected<%%>>부산</option>
        		<%}%>
                      </select>

        			</td>
                    <td width=3% rowspan="3" class=title>탁<br>송</td>
                    <td width=7% class=title>구분</td>
                    <td width=15%>
        			  &nbsp;<select name="cons_st" class='default'>
        				<option value="2">자체</option>							
        			  </select>
        			</td>
    		    </tr>
                <tr>
                    <td class=title>예정일시</td>
                    <td>&nbsp;<input type='text' size='12' name='dlv_est_dt' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_EST_DT")))%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
        			  <input type='text' size='2' name='dlv_est_h' class='default' value='<%=String.valueOf(est.get("DLV_EST_H"))%>'>시        			  
        			</td>
                    <td class=title>업체명</td>
                    <td>&nbsp;<input type='text' name="off_nm" value='<%=pur.getOff_nm()%>' size='17' class='default'>
        			  <input type='hidden' name='off_id' value='<%=pur.getOff_id()%>'>
    			    <span class="b"><a href="javascript:search_off()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span></td>
                </tr>
                <tr>                    
                    <td class=title colspan='2'>인수지</td>
                    <td>
        			  &nbsp;<select name="udt_st" class='default' onChange="javascript:setOff();cng_input1(this.value);">
                        <option value="">==선택==</option>
        				<option value="1" <%if(pur.getUdt_st().equals("1"))%> selected<%%>>서울본사</option>
        				<option value="2" <%if(pur.getUdt_st().equals("2"))%> selected<%%>>부산지점</option>
        				<option value="3" <%if(pur.getUdt_st().equals("3"))%> selected<%%>>대전지점</option>				
        				<option value="5" <%if(pur.getUdt_st().equals("5"))%> selected<%%>>대구지점</option>
        				<option value="6" <%if(pur.getUdt_st().equals("6"))%> selected<%%>>광주지점</option>				
        				<option value="4" <%if(pur.getUdt_st().equals("4"))%> selected<%%>>고객</option>
        			  </select>
        			</td>
                    <td class=title>탁송료</td>
                    <td>&nbsp;<input type='text' name='cons_amt1' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCons_amt1())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>원
        			  <span class="b"><a href="javascript:search_off_amt()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span></td>
                </tr>	
                <tr>
                  <td class=title colspan='2'>계출번호</td>
                    <td colspan='4'>&nbsp;<input type='text' name='rpt_no' maxlength='15' value='<%=pur.getRpt_no()%>' class='default' size='15'></td>
                </tr>	  
    		</table>
	    </td>
	</tr> 
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>			
                <tr> 
                    <td width=6% rowspan="2" class=title>배<br>
                  달<br>
                  지</td>
                    <td width=14% class=title>지점/상호</td>
                    <td width="80%">&nbsp;<select name="udt_firm" class='default' onChange="javascript:cng_input1(this.value);">
                            <option value="">==선택==</option>
        		    <%if(pur.getUdt_st().equals("1")){%>
        		    <option value="영등포 영남주차장" <%if(cons.getUdt_firm().equals("영등포 영남주차장"))%> selected<%%>>영등포 영남주차장</option>
        		    <%}%>
        		    <%if(pur.getUdt_st().equals("2")){%>     
        		    <%if(AddUtil.getDate2(4) < 20210205){%>   		    
        		    <option value="조양골프연습장 주차장" <%if(cons.getUdt_firm().equals("조양골프연습장 주차장"))%> selected<%%>>조양골프연습장 주차장</option>
        		    <%}%>
        		    <option value="웰메이드오피스텔 지하1층 주차장" <%if(cons.getUdt_firm().equals("웰메이드오피스텔 지하1층 주차장"))%> selected<%%>>웰메이드오피스텔 지하1층 주차장</option>
        		    <option value="유림카(썬팅집)" <%if(cons.getUdt_firm().equals("유림카(썬팅집)"))%> selected<%%>>유림카(썬팅집)</option>
        		    <option value="스마일TS" <%if(cons.getUdt_firm().equals("스마일TS"))%> selected<%%>>스마일TS</option>
        		    <%}%>
        		    <%if(pur.getUdt_st().equals("3")){%>
        		    <option value="미성테크" <%if(cons.getUdt_firm().equals("미성테크"))%> selected<%%>>미성테크</option>
        		    <%}%>
        		    <%if(pur.getUdt_st().equals("5")){%>
        		    <option value="대구 썬팅집" <%if(cons.getUdt_firm().equals("대구 썬팅집"))%> selected<%%>>대구 썬팅집</option>
        		    <%}%>
        		    <%if(pur.getUdt_st().equals("6")){%>
        		    <option value="용용이자동차용품점" <%if(cons.getUdt_firm().equals("용용이자동차용품점"))%> selected<%%>>용용이자동차용품점</option>				
        		    <%}%>
        		    <%if(pur.getUdt_st().equals("4")){%>
     			    <option value="<%=client.getFirm_nm()%>" <%if(cons.getUdt_firm().equals(client.getFirm_nm()))%> selected<%%>><%=client.getFirm_nm()%></option>
     			    <%}%>
        		</select>
                    </td>
    		</tr>
                <tr>
                    <td class=title>주소</td>
                    <td>&nbsp;<input type='text' name='udt_addr' size='70' value='<%=cons.getUdt_addr()%>' class='whitetext' ></td>
                </tr>
                <tr> 
                    <td rowspan="2" class=title>담<br>당<br>자</td>
                    <td class=title>부서/성명</td>
                    <td>&nbsp;<input type='text' name='udt_mng_nm' size='30' value='<%=cons.getUdt_mng_nm()%>' class='whitetext'>
                        <input type='hidden' name="udt_mng_id" 	value="<%=cons.getUdt_mng_id()%>">
                    </td>
    		</tr>
                <tr>
                    <td class=title>연락처</td>
                    <td>&nbsp;<input type='text' name='udt_mng_tel' size='30' value='<%=cons.getUdt_mng_tel()%>' class='whitetext' ></td>
                </tr>
    		</table>
	    </td>
	</tr>     	
    <tr>
        <td class=h></td>
    </tr>		
    <tr> 
        <td><font color=red>* 출고확정된 경우만 등록하세요.</red></td>
    </tr>    
    <tr>
        <td align="right">		
                <%if(pur.getPur_pay_dt().equals("")){%>			
		<a href="javascript:update()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;		
		<%}%>
		<a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
    <%if(!cons.getCons_no().equals("") && !coe_bean.getCar_off_nm().equals("법인판촉팀") && !coe_bean.getCar_off_nm().equals("법인판매팀") && !coe_bean.getCar_off_nm().equals("B2B사업운영팀")){%>   
    
    <%		//협력업체에 등록된 영업소는 사무실 여직원한테 보낸다    
    		//if(pur.getOne_self().equals("Y")){
    			//비상연락망-협력업체
    			Hashtable pt_ht = pt_db.getPartnerAgnt(coe_bean.getEmp_nm(), coe_bean.getEmp_m_tel());
    			if(!String.valueOf(pt_ht.get("PO_AGNT_NM")).equals("") && !String.valueOf(pt_ht.get("PO_AGNT_NM")).equals("null")){
    				coe_bean.setEmp_nm	(String.valueOf(pt_ht.get("PO_AGNT_NM")));
    				coe_bean.setEmp_pos	("");
    				coe_bean.setEmp_m_tel	(String.valueOf(pt_ht.get("PO_AGNT_M_TEL")));
    			}    		    		
    		//}
    %>        
    <tr> 
        <td><hr></td>
    </tr>  
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>출고대리인 SMS 발송</span>&nbsp;&nbsp;<a href="javascript:view_cons_man()" onMouseOver="window.status=''; return true">[출고대리인현황]</a></td>
    </tr>  	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='10%'>출고대리인</td>
                    <td>&nbsp;
                                                <%if(!String.valueOf(cons_man.get("MAN_NM")).equals("") && !String.valueOf(cons_man.get("MAN_NM")).equals("null")){%>                   
                            <%=cons_man.get("OFF_NM")%> <%=cons_man.get("MAN_NM")%> <%=cons_man.get("MAN_SSN")%> <%=cons_man.get("MAN_TEL")%>
                        <%}else{%>                            
                            <%=pur.getOff_nm()%> <%=cons.getDriver_nm()%> <%=cons.getDriver_ssn()%> <%=cons.getDriver_m_tel()%>
                        <%}%>
                    </td>
                </tr>            
                <tr> 
                    <td class='title' width='10%'>내용</td>
                    <td>&nbsp;<textarea rows='2' cols='90' name='msg'>[<%=pur.getDlv_ext()%>]아마존카 출고대리인:<%if(!String.valueOf(cons_man.get("MAN_NM")).equals("") && !String.valueOf(cons_man.get("MAN_NM")).equals("null")){%><%=cons_man.get("OFF_NM")%> <%=cons_man.get("MAN_NM")%> <%=cons_man.get("MAN_SSN")%> <%=cons_man.get("MAN_TEL")%><%}else{%><%=pur.getOff_nm()%> <%=cons.getDriver_nm()%> <%=cons.getDriver_ssn()%> <%=cons.getDriver_m_tel()%><%}%></textarea></td>
                </tr>
                <tr> 
                    <td class='title' width='10%'>수신자</td>
                    <td>&nbsp;<%=coe_bean.getCar_off_nm()%> <input type='text' name='destname' maxlength='15' value='<%=coe_bean.getEmp_nm()%> <%=coe_bean.getEmp_pos()%>' class='default' size='15'>
                        <input type='text' name='destphone' maxlength='15' value='<%=coe_bean.getEmp_m_tel()%>' class='default' size='15'>
                        &nbsp;&nbsp;&nbsp;
                        <a href="javascript:cons_man_sms();" title='문자보내기'><img src=/acar/images/center/button_send_smsgo.gif align=absmiddle border=0></a>        
                    </td>
                </tr>                
            </table>
        </td>
    </tr>	    
    <%}%>
    <%if(cons.getCons_no().equals("")){%>       
    <tr> 
        <td><hr></td>
    </tr>  
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>출고대리인</span></td>
    </tr>  	
	<tr id=tr_driver1 style="display:<%if(pur.getOff_id().equals("009771")){%>none<%}else{%>''<%}%>">
	    <td>
		    <iframe src="reg_cons_mans.jsp?car_comp_id=<%=cm_bean.getCar_comp_id()%>&off_id=<%=pur.getOff_id()%>&dlv_ext=<%=pur.getDlv_ext()%>" name="inner1" width="100%" height="250" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
		    </iframe>
	    </td>
	</tr>
    <%}%>
    <tr id=tr_driver2 style="display:<%if(pur.getOff_id().equals("009771")){%>''<%}else{%>none<%}%>">
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>성명</td>
                    <td width=19%>&nbsp;
                        <input type='text' size='10' name='driver_nm' maxlength='15' class='default' value='<%=cons.getDriver_nm()%>'>                                                
                    </td>
                    <td width=14% class=title>생년월일</td>
                    <td width=19%>&nbsp;
                        <input type='text' size='15' name='driver_ssn' maxlength='8' class='default' value='<%=cons.getDriver_ssn()%>'>                    
                        (생년월일과 남녀 구분자를 넣어주세요 예: 990101-1, 990101-2)
                    </td>
                    <td width=14% class=title>연락처</td>
                    <td>&nbsp;
                        <input type='text' size='13' name='driver_m_tel' maxlength='15' class='default' value='<%=cons.getDriver_m_tel()%>'>         
                    </td>
                </tr>
            </table>
        </td>
    </tr>   
</table>
</form>
<script language="JavaScript">
<!--	
	
	var fm = document.form1;
	
	
	cng_input1(<%=pur.getUdt_st()%>);
	
	if(fm.off_id.value == ''){
		setOff();
	}		
		
//-->
</script>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
