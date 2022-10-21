<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.user_mng.*, acar.res_search.*, tax.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
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
	String fee_start_dt = "";
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String ins_st 	= request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	
	if(rent_l_cd.equals("")){
		Hashtable cont = a_db.getContViewUseYCarCase(c_id);
		rent_mng_id 	= String.valueOf(cont.get("RENT_MNG_ID"));
		rent_l_cd 		= String.valueOf(cont.get("RENT_L_CD"));
	}
	
	if(rent_l_cd.equals("") && !l_cd.equals("")){
		rent_mng_id = m_id;
		rent_l_cd 	= l_cd;
	}
	
	if(rent_l_cd.equals("") || rent_l_cd.equals("null")) return;
	
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "15", "01", "16");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(c_id.equals("")){
		c_id = base.getCar_mng_id();
	}
	
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
	int fee_size = af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//운전자격검증결과
  	CodeBean[] code50 = c_db.getCodeAll3("0050");
  	int code50_size = code50.length;
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
//오늘날짜 구하기
var dt = new Date();		
var month = dt.getMonth()+1;	if(month<10)	month = "0"+month;
var day = dt.getDate();
var year = dt.getFullYear();

	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}
	
	//고객 보기
	function view_client(client_id)
	{
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//지점/현장 보기
	function view_site(client_id, site_id)
	{
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id+"&site_id="+site_id, "CLIENT_SITE", "left=100, top=100, width=620, height=450");
	}			

	//자동차등록정보 보기
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		

	//대여요금
	function view_fee(rent_mng_id, rent_l_cd, rent_st)
	{		
		window.open("/fms2/lc_rent/view_fee.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&cmd=view", "VIEW_FEE", "left=100, top=100, width=850, height=650, scrollbars=yes");
	}		
	
	
	function set_d_ch_amt(){
		var fm = document.form1;
		fm.d_fee_amt.value 	= parseDecimal(toInt(parseDigit(fm.n_fee_amt.value)) - toInt(parseDigit(fm.o_fee_amt.value)));
	}	
	
	//등록
	function save(){
		var fm = document.form1;
		
		for(var i=0 ; i<2 ; i++){
		fm.rent_way_nm[i].value = fm.rent_way[i].options[fm.rent_way[i].selectedIndex].text;
		}
		
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "u_chk"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("변경사항을 선택하세요.");
			return;
		}	
		

		
		
		if(fm.cng_dt.value == '')			{ alert('변경일자를 입력하십시오.'); 						fm.cng_dt.focus(); 	return; }
		if(fm.cng_etc.value == '')			{ alert('사유 및 특이사항을 입력하십시오.'); 				fm.cng_etc.focus();	return; }
			
		if(fm.n_fee_amt.value == '' || fm.n_fee_amt.value == '0')		
											{ alert('변경후 대여료금액을 입력하십시오.');				fm.cng_dt.focus();	return; }
		if(fm.u_chk[2].checked==true ){
			//추가운전자 추가
			if(fm.fee_add_user.value == '운전자 추가'){
				if(fm.mgr_lic_no5.value == ''){
					alert('추가운전자 운전면허번호를 입력하십시오.');
					return;
				}
				if(fm.mgr_lic_no5.value != '' && fm.mgr_lic_emp5.value == ''){
					alert('추가운전자 운전면허번호 이름을 입력하십시오.');
					return;
				}
				if(fm.mgr_lic_no5.value != '' && fm.mgr_lic_rel5.value == ''){
					alert('추가운전자 운전면허번호 관계를 입력하십시오.');
					return;
				}
				if(fm.mgr_lic_no5.value != '' && fm.mgr_lic_result5.value != '1'){
					alert('추가운전자의 운전면허검증결과를 확인해주세요. 운전자격 없는 자에게 차량을 대여할 수 없습니다.');
					return;
				}
			}
		}		
		
		if(confirm('등록하시겠습니까?')){	
		
			fm.action='fee_doc_reg_c_a.jsp';		
//			fm.target='i_no';
			fm.target='_blank';
			fm.submit();
		}							
	}
	
	//대여료 입금예정일 건이면 월대여료 및 변경일자 자동세팅(20180723)
	function setDisplayValue(val){
		var fm = document.form1;
		if(val=="6"){
			fm.cng_dt.value = year+""+month+""+day;
			fm.n_fee_amt.value = fm.o_fee_amt.value;		
		}else{
			fm.cng_dt.value = ""
			fm.n_fee_amt.value = "";
		}
		set_d_ch_amt();
		if(val=="4"){
			if(fm.fee_add_user.value == '운전자 추가'){
				tr_mgr5.style.display='';//가입
			}else{
				tr_mgr5.style.display='none';//면제
			}	
		}else{
			tr_mgr5.style.display='none';//면제
		}
	}
	
	function search_test_lic(){
		var url = "http://211.174.180.104/fms2/car_api/car_api.jsp";
		window.open(url,"TESTLIC_POPUP", "left=0, top=0, width=850, height=850, scrollbars=yes");
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
<form action='fee_doc_reg_c_a.jsp' name="form1" method='post'>
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
  <input type='hidden' name="firm_nm"	 	value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="c_id"	 		value="<%=c_id%>">  
  <input type='hidden' name="from_page" 	value="/fms2/con_fee/fee_doc_reg_c.jsp">             
  <input type='hidden' name='st' value=''>        
  
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
                    <td>&nbsp;<%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}%></td>
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
	    <td align="right">&nbsp;</td>
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
        <td>&nbsp;</td>
    </tr>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>변경사항</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=3%>선택</td>
                    <td width="10%" class=title>구분</td>
                    <td class=title width=22%>변경전 </td>
                    <td class=title width=65%>변경후</td>
                </tr>
                <tr>
                  <td class=title><input type="radio" name="u_chk" value="1" onclick="javascript:setDisplayValue(this.value);"></td> 
                    <td class=title>대여상품</td>
                    <td>&nbsp;
					  <select name="rent_way" disabled><!--disabled 풀면 처리부분 소스 배열로 수정해야함. 풀지말것 -->
                        <option value=''>선택</option>
                        <option value='1' <%if(ext_fee.getRent_way().equals("1")){%>selected<%}%>>일반식</option>
                        <option value='3' <%if(ext_fee.getRent_way().equals("3")){%>selected<%}%>>기본식</option>
                      </select>
					</td>
                    <td>&nbsp;
					  <select name="rent_way">
                        <option value='1' <%if(ext_fee.getRent_way().equals("1")){%>selected<%}%>>일반식</option>
                        <option value='3' <%if(ext_fee.getRent_way().equals("3")){%>selected<%}%>>기본식</option>
                      </select>
					  <input type='hidden' name='rent_way_nm' value=''>
					  <input type='hidden' name='rent_way_nm' value=''>
					  </td>
                </tr>
                
                <tr>
                  <td class=title><input type="radio" name="u_chk" value="2" onclick="javascript:setDisplayValue(this.value);"></td> 
                    <td class=title>대여료할인</td>
                    <td>&nbsp;
					  -</td>
                    <td>&nbsp;
                      <input type='text' name='fee_dc' size='100' class='text'>
				  </td>
                </tr>
                 <tr>
                  <td class=title><input type="radio" name="u_chk" value="4" onclick="javascript:setDisplayValue(this.value);"></td> 
                    <td class=title>추가운전자</td>
                    <td>&nbsp;
					  -</td>
                    <td>&nbsp;
                      <select name="fee_add_user" id="fee_add_user" onChange="javascript:setDisplayValue(4)">                        
                        <option value='운전자 추가' >운전자 추가</option>
                        <option value='운전자 추가 취소' >운전자 추가 취소</option>
                      </select>                      
				  </td>
                </tr>
                 <tr>
                  <td class=title><input type="radio" name="u_chk" value="5" onclick="javascript:setDisplayValue(this.value);"></td> 
                    <td class=title>약정운행거리변경</td>
                    <td>&nbsp;
					  <%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>km이하/1년<input type='hidden' name="o_agree_dist"	value="<%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>"></td>
                    <td>&nbsp;
                      <input type='text' name='fee_dis_plus' size='10' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>km이하/1년
				  </td>
                </tr>
                <!-- 대여료 입금예정일(20180718) -->
                <tr>
                  <td class=title><input type="radio" name="u_chk" value="6" onclick="javascript:setDisplayValue(this.value);"></td> 
                    <td class=title>대여료 입금예정일</td>
                    <td>&nbsp;
					  -</td>
                    <td>&nbsp;
                      <input type='text' name='fee_day' size='100' class='text'>
				  </td>
                </tr>
                <tr>
                  <td class=title><input type="radio" name="u_chk" value="7" onclick="javascript:setDisplayValue(this.value);"></td> 
                    <td class=title>맑은서울스티커발급</td>
                    <td>&nbsp;
					  -</td>
                    <td>&nbsp;
                      <input type='text' name='fee_sticker' size='100' class='text'>
				  </td>
                </tr>
                <tr>
                  <td class=title><input type="radio" name="u_chk" value="8" onclick="javascript:setDisplayValue(this.value);"></td> 
                    <td class=title>견인장치장착</td>
                    <td>&nbsp;
					  -</td>
                    <td>&nbsp;
                      <input type='text' name='others_device' size='100' class='text'>
				  </td>
                </tr>
                <tr>
                  <td class=title><input type="radio" name="u_chk" value="9" onclick="javascript:setDisplayValue(this.value);"></td> 
                    <td class=title>보증금증감</td>
                    <td>&nbsp;
					  <%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>원<input type='hidden' name="o_grt_amt"	value="<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>"></td>
                    <td>&nbsp;
                      <input type='text' name='grt_amt' size='12' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>원
				  </td>
                </tr>
                 <tr>
                  <td class=title><input type="radio" name="u_chk" value="3" onclick="javascript:setDisplayValue(this.value);"></td> 
                    <td class=title>기타</td>
                    <td>&nbsp;
					  -</td>
                    <td>&nbsp;
                      <input type='text' name='fee_etc' size='100' class='text'>
				  </td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>변경일자</td>
                    <td>&nbsp;
        			  <input type='text' name='cng_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'>
					</td>
                </tr>
                <tr> 
                    <td class='title'>사유 및 특이사항</td>
                    <td>&nbsp;
        			  <textarea name="cng_etc" cols="100" class="text" style="IME-MODE: active" rows="5"></textarea> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
	<tr>
	    <td class=h></td>
	</tr>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여료스케줄 반영 외</span></td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=13%>구분</td>
                    <td class=title width=22%>변경전</td>
                    <td class=title width=22%>변경후</td>
                    <td class=title width=43%>-</td>
                </tr>
                <tr>
                    <td class='title'>월대여료</td>
                    <td>&nbsp;
        			          <input type='text' name='o_fee_amt' size='10' value='<%=AddUtil.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value); set_d_ch_amt();'>원
					          </td>
                    <td>&nbsp;
					              <input type='text' name='n_fee_amt' size='10' value='' class='num' onBlur='javascript: this.value = parseDecimal(this.value); set_d_ch_amt();'>원
					              &nbsp;&nbsp;(vat포함)
					          </td>
                    <td>&nbsp;월반영금액 : 
        			          월 <input type='text' name='d_fee_amt' size='10' value='' class='num' onBlur='javascript: this.value = parseDecimal(this.value); set_d_ch_amt();'>원씩 증감
					              &nbsp;&nbsp;(vat포함)
					          </td>
                </tr>
                <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                <tr>
                    <td class='title'>환급대여료</td>
                    <td>&nbsp;
        			          <input type='text' name='o_rtn_run_amt' size='10' value='<%=AddUtil.parseDecimal(fee_etc.getRtn_run_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>원/1km(부가세별도)
					          </td>
                    <td>&nbsp;
					              <input type='text' name='n_rtn_run_amt' size='10' value='<%=AddUtil.parseDecimal(fee_etc.getRtn_run_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>원/1km(부가세별도)					              
					          </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class='title'>초과운행대여료</td>
                    <td>&nbsp;
        			          <input type='text' name='o_over_run_amt' size='10' value='<%=AddUtil.parseDecimal(fee_etc.getOver_run_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>원/1km(부가세별도)
					          </td>
                    <td>&nbsp;
					              <input type='text' name='n_over_run_amt' size='10' value='<%=AddUtil.parseDecimal(fee_etc.getOver_run_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>원/1km(부가세별도)					              
					          </td>
                    <td>&nbsp;</td>
                </tr>
                <%} %>
                <tr>
                    <td class='title'>매입옵션가격</td>
                    <td>&nbsp;
        			          <input type='text' name='o_opt_amt' size='10' value='<%=AddUtil.parseDecimal(ext_fee.getOpt_s_amt()+ext_fee.getOpt_v_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>원
					          </td>
                    <td>&nbsp;
					              <input type='text' name='n_opt_amt' size='10' value='<%=AddUtil.parseDecimal(ext_fee.getOpt_s_amt()+ext_fee.getOpt_v_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>원
					              &nbsp;&nbsp;(vat포함)
					          </td>
                    <td>&nbsp;</td>
                </tr>        
                <tr> 
                    <td class='title'>위약율</td>
                    <td>&nbsp;
        			          <input type='text' name='o_cls_per' size='10' value='<%=ext_fee.getCls_r_per()%>' class='num'>%
					          </td>
                    <td>&nbsp;
					              <input type='text' name='n_cls_per' size='10' value='<%=ext_fee.getCls_r_per()%>' class='num'>%
					          </td>
                    <td>&nbsp;</td>
                </tr>                                
            </table>
        </td>
    </tr>
    <!-- 추가운전자 -->
    <tr>
	    <td class=h></td>
	</tr>	
    <tr id=tr_mgr5 style="display:none"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>                	  
                <%	
              		//법인고객차량관리자
            		Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
            		int mgr_size = car_mgrs.size();
            		CarMgrBean mgr5 = new CarMgrBean();
                	for(int i = 0 ; i < mgr_size ; i++){
        				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        				if(mgr.getMgr_st().equals("추가운전자")){
        					mgr5 = mgr;
        				}
					}                       
                %>                 
                <tr>
                    <td width=13% class='title'>추가운전자 운전면허번호</td>
                    <td>&nbsp;<input type="button" class="button" value="운전면허정보검증 조회" onclick="javascript:search_test_lic();"></td>
		            <td>&nbsp;면허번호 : <input type='text' name='mgr_lic_no5' value='<%=mgr5.getLic_no()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td>&nbsp;이름 : <input type='text' name='mgr_lic_emp5' value='<%=mgr5.getMgr_nm()%>'  size='10' class='text'></td>
		            <td>&nbsp;관계 : <input type='text' name='mgr_lic_rel5' value='<%=mgr5.getEtc()%>'  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td>&nbsp;검증결과 : <select name='mgr_lic_result5'>
        		          		<option value='' <%if(mgr5.getLic_result().equals("")) out.println("selected");%>>선택</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>' <%if(mgr5.getLic_result().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        		<%}%> 
        		            </select>&nbsp;</td>
                </tr>                    	                              
            </table>
        </td>
    </tr>
    
    
    		
    <tr>
		<td align="right"><a href="javascript:save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
	</tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

//-->
</script>
</body>
</html>
