<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, java.text.SimpleDateFormat"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.user_mng.*, acar.res_search.*, tax.*, acar.insur.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ins" 	class="acar.insur.InsurBean" 			scope="page"/>
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
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "15", "01", "15");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	InsDatabase ins_db = InsDatabase.getInstance();
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getUse_yn().equals("N"))	return;
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
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
	
	if(base.getCar_st().equals("2")){
		ext_fee.setFee_s_amt(0);
		ext_fee.setFee_v_amt(0);
	}

	//보험스케줄
	Vector scd_fee = ins_db.getScdFeeList(rent_mng_id, rent_l_cd); 
	
	int scdFee_vt_size = scd_fee.size();
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	Calendar c1 = Calendar.getInstance();
	String strToday = sdf.format(c1.getTime());
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

	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}
	
	//고객 보기
	function view_client()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("선택된 고객이 없습니다."); return;}	
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//자동차등록정보 보기
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		
	
	function upd_page(){
		var fm = document.form1;
		fm.action = 'ins_doc_reg_u.jsp';
		fm.target = 'd_content';
		fm.submit();
	}
	function getFormatDate(date){
		var year = date.getFullYear();                                 //yyyy
		var month = (1 + date.getMonth());                     //M
		month = month >= 10 ? month : '0' + month;     // month 두자리로 저장
		var day = date.getDate();                                        //d
		day = day >= 10 ? day : '0' + day;                            //day 두자리로 저장
		return  year + '' + month + '' + day;
	}

	
	//등록
	function save(){
		var fm = document.form1;
		var rent_start_dt = '<%=base.getRent_start_dt()%>';
		if(!rent_start_dt){
			alert("대여개시일이 등록되지 않았습니다. \n대여개시일 등록 다시 등록해주시기 바랍니다.");
			return false;
		}
		var checkDt = '<%=ins.getIns_exp_dt()%>'; //기준날짜
		var d = new Date();
		var preDate =  new Date(checkDt.substring(0,4),checkDt.substring(4,6)-1,checkDt.substring(6,8));
 		d.setTime(preDate - (1 * 24 * 60 * 60 * 1000)); //1일전 
 		d = getFormatDate(d);
 		var currentDt = new Date();
 		var changeDt = fm.cng_dt.value;
 		changeDt = changeDt.substring(0,4)+''+changeDt.substring(5,7)+''+changeDt.substring(8,10);
 		currentDt = getFormatDate(currentDt);
 		
 		var scdFee_vt_size = <%=scdFee_vt_size%>;
		if(currentDt == checkDt || currentDt == d || changeDt == checkDt || changeDt == d){
			alert('자동차보험 갱신 1일전과 당일에는 보험변경 불가합니다.');
			return;
		}
		
		for(var i=0 ; i<2 ; i++){
			fm.age_scp_nm[i].value 				= fm.age_scp[i].options[fm.age_scp[i].selectedIndex].text;
			fm.vins_gcp_kd_nm[i].value 			= fm.vins_gcp_kd[i].options[fm.vins_gcp_kd[i].selectedIndex].text;
			fm.vins_bacdt_kd_nm[i].value 			= fm.vins_bacdt_kd[i].options[fm.vins_bacdt_kd[i].selectedIndex].text;
			fm.vins_bacdt_kc2_nm[i].value 			= fm.vins_bacdt_kc2[i].options[fm.vins_bacdt_kc2[i].selectedIndex].text;
//			fm.vins_canoisr_yn_nm[i].value 			= fm.vins_canoisr_yn[i].options[fm.vins_canoisr_yn[i].selectedIndex].text;			
			fm.vins_cacdt_car_amt_nm[i].value 		= fm.vins_cacdt_car_amt[i].value;
			fm.vins_cacdt_me_amt_nm[i].value 		= fm.vins_cacdt_me_amt[i].value;						
			fm.vins_cacdt_mebase_amt_nm[i].value 		= fm.vins_cacdt_mebase_amt[i].options[fm.vins_cacdt_mebase_amt[i].selectedIndex].text;
			fm.vins_cacdt_memin_amt_nm[i].value 		= fm.vins_cacdt_memin_amt[i].options[fm.vins_cacdt_memin_amt[i].selectedIndex].text;
//			fm.vins_spe_yn_nm[i].value 			= fm.vins_spe_yn[i].options[fm.vins_spe_yn[i].selectedIndex].text;
			fm.com_emp_yn_nm[i].value 			= fm.com_emp_yn[i].options[fm.com_emp_yn[i].selectedIndex].text;
			fm.blackbox_yn_nm[i].value 			= fm.blackbox_yn[i].options[fm.blackbox_yn[i].selectedIndex].text;
			fm.hook_yn_nm[i].value 			= fm.hook_yn[i].options[fm.hook_yn[i].selectedIndex].text;
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
		
		if(fm.cng_st[0].checked == false && fm.cng_st[1].checked == false){
			alert('등록구분을 선택하여 주십시오.');
			return;
		}
		if(scdFee_vt_size>0 && !fm.r_fee_est_dt.value ){
			alert('결제예정일을 선택하여 주십시오.');
			return;
		}
		
		if(fm.cng_st[0].checked == true){		
			if(fm.cng_dt.value == '')			{ alert('변경일자를 입력하십시오.'); 			fm.cng_dt.focus(); 	return; }
			if(fm.cng_etc.value == '')			{ alert('사유 및 특이사항을 입력하십시오.'); 		fm.cng_etc.focus();	return; }			
		}
		
		var checkDB =  true;
		if('<%=base.getCar_st()%>'=='3' && (parseInt(changeDt)>=20180126 && parseInt(changeDt)<=20180210 ) ){
			alert('리스 차량인 경우 1월 26일~2월 10일 까지 등록이 제한됩니다.\n2월 10일 이후 다시 등록 해주시기 바랍니다.');
			checkDB =  false;
		}
		
		if(checkDB){
			if(confirm('등록하시겠습니까?')){	
			
				fm.action='ins_doc_reg_c_a.jsp';		
				fm.target='i_no';
				//fm.target='_blank';
				fm.submit();
			}							
		}
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
<form action='ins_doc_reg_c_a.jsp' name="form1" method='post'>
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
  <input type='hidden' name="o_fee_amt"	 	value="<%=ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt()%>">
  <input type='hidden' name="firm_nm"	 	value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="car_no"	 	value="<%=cr_bean.getCar_no()%>">
  <input type='hidden' name="c_id" 			value="<%=c_id%>">
  <input type='hidden' name="ins_st"		value="<%=ins_st%>">
  <input type='hidden' name="from_page" 	value="/fms2/insure/ins_doc_reg_c.jsp">             
  <input type='hidden' name='st' value=''>        
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<%
	if( Integer.parseInt(strToday) <= 20200210 && ins.getCar_use().equals("2") ){
		
	%>
     <tr>
        <td></td>
    </tr>
    <tr>
        <td style="text-align:center; font-size:15pt; font-weight:bold">2020.02.10까지 보험회사변경으로 영무용차량은 보험변경이 불과합니다 </td>
    </tr>
    <tr>
        <td></td>
    </tr>
	<% 
    }
	
	%>
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
                    <td class=title width=10%>보험기간</td>
                    <td width=25%>&nbsp;<%=AddUtil.ChangeDate2(ins.getIns_start_dt())%>~<%=AddUtil.ChangeDate2(ins.getIns_exp_dt())%> 
        			</td>									
                    <td class=title width=10%>보험회사</td>
                    <td width=15%>&nbsp;<%=c_db.getNameById(ins.getIns_com_id(), "INS_COM")%></td>
                    <td class=title width=10%>보험종류</td>
                    <td>&nbsp; 
                      <%if(ins.getCar_use().equals("1")){%>영업용<%}%>
                      <%if(ins.getCar_use().equals("2")){%>업무용<%}%>
        			  <%if(ins.getCar_use().equals("3")){%>개인용<%}%>
                    </td>										
                </tr>				
            </table>
	    </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <%
	if(  Integer.parseInt(strToday) <= 20200210 && ins.getCar_use().equals("2")   ){
	}else{
	%>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험변경</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>선택</td>
                    <td width="15%" class=title>구분</td>
                    <td class=title width=37%>변경전 </td>
                    <td class=title width=38%>변경후</td>
                </tr>
                <tr>
                  <td class=title><input type="checkbox" name="u_chk" value="1"></td> 
                    <td class=title>연령범위</td>
                    <td>&nbsp;
                      <select name='age_scp' disabled><!--disabled 풀면 처리부분 소스 배열로 수정해야함. 풀지말것 -->
                        <option value='3' <%if(ins.getAge_scp().equals("3")){%>selected<%}%>>전연령</option>
                        <option value='1' <%if(ins.getAge_scp().equals("1")){%>selected<%}%>>21세이상</option>
                        <option value='4' <%if(ins.getAge_scp().equals("4")){%>selected<%}%>>24세이상</option>
                        <option value='2' <%if(ins.getAge_scp().equals("2")){%>selected<%}%>>26세이상</option>
                        <option value=''>=피보험자고객=</option>
                        <option value='5' <%if(ins.getAge_scp().equals("5")){%>selected<%}%>>30세이상</option>
                        <option value='6' <%if(ins.getAge_scp().equals("6")){%>selected<%}%>>35세이상</option>
                        <option value='7' <%if(ins.getAge_scp().equals("7")){%>selected<%}%>>43세이상</option>
                        <option value='8' <%if(ins.getAge_scp().equals("8")){%>selected<%}%>>48세이상</option>
                        <option value='9' <%if(ins.getAge_scp().equals("9")){%>selected<%}%>>22세이상</option>
                        <option value='10' <%if(ins.getAge_scp().equals("10")){%>selected<%}%>>28세이상</option>
                        <option value='11' <%if(ins.getAge_scp().equals("11")){%>selected<%}%>>35세이상~49세이하</option>
                      </select></td>
                    <td>&nbsp;
                      <select name='age_scp'>
					    <%if(ins.getCar_use().equals("1")){//영업용%>
                        <option value='1' <%if(ins.getAge_scp().equals("1")){%>selected<%}%>>21세이상</option>
                        <option value='2' <%if(ins.getAge_scp().equals("2")){%>selected<%}%>>26세이상</option>
						<%}else{//자가용%>
                        <option value='1' <%if(ins.getAge_scp().equals("1")){%>selected<%}%>>21세이상</option>
                        <option value='4' <%if(ins.getAge_scp().equals("4")){%>selected<%}%>>24세이상</option>
                        <option value='2' <%if(ins.getAge_scp().equals("2")){%>selected<%}%>>26세이상</option>
                        <option value=''>=피보험자고객=</option>
                        <option value='3' <%if(ins.getAge_scp().equals("3")){%>selected<%}%>>전연령</option>
                        <option value='5' <%if(ins.getAge_scp().equals("5")){%>selected<%}%>>30세이상</option>
                        <option value='6' <%if(ins.getAge_scp().equals("6")){%>selected<%}%>>35세이상</option>
                        <option value='7' <%if(ins.getAge_scp().equals("7")){%>selected<%}%>>43세이상</option>
                        <option value='8' <%if(ins.getAge_scp().equals("8")){%>selected<%}%>>48세이상</option>						
                        <option value='9' <%if(ins.getAge_scp().equals("9")){%>selected<%}%>>22세이상</option>						
                        <option value='10' <%if(ins.getAge_scp().equals("10")){%>selected<%}%>>28세이상</option>						
                        <option value='11' <%if(ins.getAge_scp().equals("11")){%>selected<%}%>>35세이상~49세이하</option>						
						<%}%>
                      </select>&nbsp;<a href="javascript:age_search();"><img src=/acar/images/center/button_in_mnigs.gif border=0 align=absmiddle></a>
					  <input type='hidden' name='age_scp_nm' value=''>
					  <input type='hidden' name='age_scp_nm' value=''>
					  </td>
                </tr>
                <tr>
                  <td class=title><input type="checkbox" name="u_chk" value="2"></td> 
                    <td class=title>대물배상&nbsp;&nbsp;</td>
                    <td>&nbsp;
			<select name='vins_gcp_kd' disabled>
                        <option value='6' <%if(ins.getVins_gcp_kd().equals("6")){%>selected<%}%>>5억원</option>
			<option value='8' <%if(ins.getVins_gcp_kd().equals("8")){%>selected<%}%>>3억원</option>
			<option value='7' <%if(ins.getVins_gcp_kd().equals("7")){%>selected<%}%>>2억원</option>
                        <option value='3' <%if(ins.getVins_gcp_kd().equals("3")){%>selected<%}%>>1억원</option>						
                        <option value='4' <%if(ins.getVins_gcp_kd().equals("4")){%>selected<%}%>>5000만원</option>
                        <option value='1' <%if(ins.getVins_gcp_kd().equals("1")){%>selected<%}%>>3000만원</option>
                        <option value='2' <%if(ins.getVins_gcp_kd().equals("2")){%>selected<%}%>>1500만원</option>
                        <option value='5' <%if(ins.getVins_gcp_kd().equals("5")){%>selected<%}%>>1000만원</option>				
                      </select>
                      (1사고당)</td>
                    <td>&nbsp;
                      <select name='vins_gcp_kd'>
                        <option value='6' <%if(ins.getVins_gcp_kd().equals("6")){%>selected<%}%>>5억원</option>
                        <option value='8' <%if(ins.getVins_gcp_kd().equals("8")){%>selected<%}%>>3억원</option>
                        <option value='7' <%if(ins.getVins_gcp_kd().equals("7")){%>selected<%}%>>2억원</option>
                        <option value='3' <%if(ins.getVins_gcp_kd().equals("3")){%>selected<%}%>>1억원</option>
                        <option value='4' <%if(ins.getVins_gcp_kd().equals("4")){%>selected<%}%>>5000만원</option>						
                      </select>
                      (1사고당)
				      <input type='hidden' name='vins_gcp_kd_nm' value=''>
					  <input type='hidden' name='vins_gcp_kd_nm' value=''>
				  </td>
                </tr>
                <tr>
                  <td class=title><input type="checkbox" name="u_chk" value="3"></td> 
                    <td class=title rowspan="2">자기신체사고</td>
                    <td>&nbsp;
					  <select name='vins_bacdt_kd' disabled>
                        <option value=""  <%if(ins.getVins_bacdt_kd().equals("")){%>selected<%}%>>선택</option>
                        <option value="1" <%if(ins.getVins_bacdt_kd().equals("1")){%>selected<%}%>>3억원</option>
                        <option value="2" <%if(ins.getVins_bacdt_kd().equals("2")){%>selected<%}%>>1억5천만원</option>
                        <option value="6" <%if(ins.getVins_bacdt_kd().equals("6")){%>selected<%}%>>1억원</option>
                        <option value="5" <%if(ins.getVins_bacdt_kd().equals("5")){%>selected<%}%>>5000만원</option>
                        <option value="3" <%if(ins.getVins_bacdt_kd().equals("3")){%>selected<%}%>>3000만원</option>
                        <option value="4" <%if(ins.getVins_bacdt_kd().equals("4")){%>selected<%}%>>1500만원</option>
                      </select>
                      (1인당사망/장해)</td>
                    <td>&nbsp;
                      <select name='vins_bacdt_kd'>
                        <option value=""  <%if(ins.getVins_bacdt_kd().equals("")){%>selected<%}%>>선택</option>
                        <option value="6" <%if(ins.getVins_bacdt_kd().equals("6")){%>selected<%}%>>1억원</option>
                        <option value="5" <%if(ins.getVins_bacdt_kd().equals("5")){%>selected<%}%>>5000만원</option>
                      </select>
                  (1인당사망/장해)
				      <input type='hidden' name='vins_bacdt_kd_nm' value=''>
					  <input type='hidden' name='vins_bacdt_kd_nm' value=''>
				  </td>
                </tr>
                <tr>
                  <td class=title><input type="checkbox" name="u_chk" value="4"></td> 
                    <td>&nbsp;
                      <select name='vins_bacdt_kc2' disabled>
                        <option value=""  <%if(ins.getVins_bacdt_kc2().equals("")){%>selected<%}%>>선택</option>					  
                        <option value="1" <%if(ins.getVins_bacdt_kc2().equals("1")){%>selected<%}%>>3억원</option>
                        <option value="2" <%if(ins.getVins_bacdt_kc2().equals("2")){%>selected<%}%>>1억5천만원</option>
                        <option value="6" <%if(ins.getVins_bacdt_kc2().equals("6")){%>selected<%}%>>1억원</option>
                        <option value="5" <%if(ins.getVins_bacdt_kc2().equals("5")){%>selected<%}%>>5000만원</option>
                        <option value="3" <%if(ins.getVins_bacdt_kc2().equals("3")){%>selected<%}%>>3000만원</option>
                        <option value="4" <%if(ins.getVins_bacdt_kc2().equals("4")){%>selected<%}%>>1500만원</option>
                      </select>
                      (1인당부상)</td>
                    <td>&nbsp;
                      <select name='vins_bacdt_kc2'>
                        <option value=""  <%if(ins.getVins_bacdt_kc2().equals("")){%>selected<%}%>>선택</option>
                        <option value="4" <%if(ins.getVins_bacdt_kc2().equals("4")){%>selected<%}%>>1500만원</option>
                      </select>
					  (1인당부상)
				      <input type='hidden' name='vins_bacdt_kc2_nm' value=''>
					  <input type='hidden' name='vins_bacdt_kc2_nm' value=''>
				  </td>
                </tr>
				<!--
                <tr>
                  <td class=title><input type="checkbox" name="u_chk" value="5"></td> 
                    <td class=title>무보험차상해</td>
                    <td>&nbsp;
                      <select name='vins_canoisr_yn' disabled>
                        <option value="1" <%if(ins.getVins_canoisr_amt() == 0){%>selected<%}%>>미가입</option>
                        <option value="2" <%if(ins.getVins_canoisr_amt() > 0){%>selected<%}%>>가입</option>
                      </select>
                    </td>
                    <td>&nbsp;
                      <select name='vins_canoisr_yn'>
                        <option value="1" <%if(ins.getVins_canoisr_amt() == 0){%>selected<%}%>>미가입</option>
                        <option value="2" <%if(ins.getVins_canoisr_amt() > 0){%>selected<%}%>>가입</option>
                      </select>
				      <input type='hidden' name='vins_canoisr_yn_nm' value=''>
					  <input type='hidden' name='vins_canoisr_yn_nm' value=''>					  
					</td>
                </tr>
				-->
                <tr>
                  <td class=title><input type="checkbox" name="u_chk" value="6"></td>
                    <td rowspan="2" class=title>자기차량손해</td>
                    <td>&nbsp;
					  차&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;량 
                      <input type='text' size='6' name='vins_cacdt_car_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_car_amt()))%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'> 만원</td>
                    <td>&nbsp;
					  차&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;량
                      <input type='text' size='6' name='vins_cacdt_car_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_car_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
					  만원
				      <input type='hidden' name='vins_cacdt_car_amt_nm' value=''>
					  <input type='hidden' name='vins_cacdt_car_amt_nm' value=''>					  
					</td>
                </tr>
                <tr>
                  <td class=title><input type="checkbox" name="u_chk" value="7"></td> 
                    <td>&nbsp;
					  물적사고할증기준
					  <select name='vins_cacdt_mebase_amt' disabled>
					    <option value=""    <%if(ins.getVins_cacdt_mebase_amt()==0  ){%>selected<%}%>>선택</option>
					    <option value="50"  <%if(ins.getVins_cacdt_mebase_amt()==50 ){%>selected<%}%>>50만원</option>
					    <option value="100" <%if(ins.getVins_cacdt_mebase_amt()==100){%>selected<%}%>>100만원</option>
					    <option value="150" <%if(ins.getVins_cacdt_mebase_amt()==150){%>selected<%}%>>150만원</option>
					    <option value="200" <%if(ins.getVins_cacdt_mebase_amt()==200){%>selected<%}%>>200만원</option>
					  </select>
					  <br>
					  &nbsp;
					  최대자기부담금 &nbsp;&nbsp; 
                      <input type='text' size='6' name='vins_cacdt_me_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_me_amt()))%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'> 
                      만원 
					  <br>
					  &nbsp;
					  최소자기부담금 &nbsp;&nbsp;  
                      <select name='vins_cacdt_memin_amt' disabled>
                        <option value=""   <%if(ins.getVins_cacdt_memin_amt()==0 ){%>selected<%}%>>선택</option>
                        <option value="5"  <%if(ins.getVins_cacdt_memin_amt()==5 ){%>selected<%}%>>5만원</option>
                        <option value="10" <%if(ins.getVins_cacdt_memin_amt()==10){%>selected<%}%>>10만원</option>
                        <option value="15" <%if(ins.getVins_cacdt_memin_amt()==15){%>selected<%}%>>15만원</option>
                        <option value="20" <%if(ins.getVins_cacdt_memin_amt()==20){%>selected<%}%>>20만원</option>
                      </select>                       
					  </td>
                    <td>&nbsp;
					  물적사고할증기준
                      <select name='vins_cacdt_mebase_amt'>
                        <option value=""    <%if(ins.getVins_cacdt_mebase_amt()==0  ){%>selected<%}%>>선택</option>
                        <option value="50"  <%if(ins.getVins_cacdt_mebase_amt()==50 ){%>selected<%}%>>50만원</option>
                        <option value="100" <%if(ins.getVins_cacdt_mebase_amt()==100){%>selected<%}%>>100만원</option>
                        <option value="150" <%if(ins.getVins_cacdt_mebase_amt()==150){%>selected<%}%>>150만원</option>
                        <option value="200" <%if(ins.getVins_cacdt_mebase_amt()==200){%>selected<%}%>>200만원</option>
                      </select>
					  <br>
					  &nbsp;
					  최대자기부담금 &nbsp;&nbsp;
					  <input type='text' size='6' name='vins_cacdt_me_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_me_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
					  만원 <br>
					  &nbsp;
					  최소자기부담금 &nbsp;&nbsp;
					  <select name='vins_cacdt_memin_amt'>
						<option value=""   <%if(ins.getVins_cacdt_memin_amt()==0 ){%>selected<%}%>>선택</option>
						<option value="5"  <%if(ins.getVins_cacdt_memin_amt()==5 ){%>selected<%}%>>5만원</option>
						<option value="10" <%if(ins.getVins_cacdt_memin_amt()==10){%>selected<%}%>>10만원</option>
						<option value="15" <%if(ins.getVins_cacdt_memin_amt()==15){%>selected<%}%>>15만원</option>
						<option value="20" <%if(ins.getVins_cacdt_memin_amt()==20){%>selected<%}%>>20만원</option>
					  </select>
				      <input type='hidden' name='vins_cacdt_mebase_amt_nm' value=''>
					  <input type='hidden' name='vins_cacdt_mebase_amt_nm' value=''>					  
				      <input type='hidden' name='vins_cacdt_me_amt_nm' value=''>
					  <input type='hidden' name='vins_cacdt_me_amt_nm' value=''>					  
				      <input type='hidden' name='vins_cacdt_memin_amt_nm' value=''>
					  <input type='hidden' name='vins_cacdt_memin_amt_nm' value=''>					  
				  </td>
                </tr>
				<!--
                <tr>
                  <td class=title><input type="checkbox" name="u_chk" value="8"></td> 
                    <td class=title>애니카특약</td>
                    <td>&nbsp;
                      <select name='vins_spe_yn' disabled>
                        <option value="1" <%if(ins.getVins_spe_amt() == 0){%>selected<%}%>>미가입&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
                        <option value="2" <%if(ins.getVins_spe_amt() > 0){%>selected<%}%>>가입</option>
                      </select>
                    </td>
                    <td>&nbsp;
                      <select name='vins_spe_yn'>
                        <option value="1" <%if(ins.getVins_spe_amt() == 0){%>selected<%}%>>미가입&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
                        <option value="2" <%if(ins.getVins_spe_amt() > 0){%>selected<%}%>>가입</option>
                      </select>
				      <input type='hidden' name='vins_spe_yn_nm' value=''>
					  <input type='hidden' name='vins_spe_yn_nm' value=''>					  					  
					</td>
                </tr>
				-->
                <tr>
                  <td class=title><input type="checkbox" name="u_chk" value="9"></td> 
                    <td class=title>임직원한정운전특약</td>
                    <td>&nbsp;
                      <select name='com_emp_yn' disabled>
                        <option value="N" <%if(ins.getCom_emp_yn().equals("N")){%>selected<%}%>>미가입</option>
                        <option value="Y" <%if(ins.getCom_emp_yn().equals("Y")){%>selected<%}%>>가입</option>
                      </select>                                          
                    </td>
                    <td>&nbsp;
                      <select name='com_emp_yn'>
                        <option value="N" <%if(ins.getCom_emp_yn().equals("N")){%>selected<%}%>>미가입</option>
                        <option value="Y" <%if(ins.getCom_emp_yn().equals("Y")){%>selected<%}%>>가입</option>
                      </select>   
					  <input type='hidden' name='com_emp_yn_nm' value=''>
					  <input type='hidden' name='com_emp_yn_nm' value=''>
                                                             
                    </td>
                </tr>
                <tr>
                  <td class=title><input type="checkbox" name="u_chk" value="13"></td> 
                    <td class=title>블랙박스</td>
                    <td>&nbsp;
                      <select name='blackbox_yn' disabled>
                        <option value="N" <%if(ins.getBlackbox_yn().equals("N")){%>selected<%}%>>없다</option>
                        <option value="Y" <%if(ins.getBlackbox_yn().equals("Y")){%>selected<%}%>>있다</option>
                      </select>                          
                    </td>
                    <td>&nbsp;
                      <select name='blackbox_yn'>
                        <option value="N" <%if(ins.getBlackbox_yn().equals("N")){%>selected<%}%>>없다</option>
                        <option value="Y" <%if(ins.getBlackbox_yn().equals("Y")){%>selected<%}%>>있다</option>
                      </select>    
					  <input type='hidden' name='blackbox_yn_nm' value=''>
					  <input type='hidden' name='blackbox_yn_nm' value=''>
                    </td>
                </tr>
                
                 <tr>
                  <td class=title><input type="checkbox" name="u_chk" value="14"></td> 
                    <td class=title>견인고리</td>
                    <td>&nbsp;
                      <select name='hook_yn' disabled>
                        <option value="N" <%if(ins.getHook_yn().equals("N")){%>selected<%}%>>미가입</option>
                        <option value="Y" <%if(ins.getHook_yn().equals("Y")){%>selected<%}%>>가입</option>
                      </select>                          
                    </td>
                    <td>&nbsp;
                      <select name='hook_yn'>
                        <option value="N" <%if(ins.getHook_yn().equals("N")){%>selected<%}%>>미가입</option>
                        <option value="Y" <%if(ins.getHook_yn().equals("Y")){%>selected<%}%>>가입</option>
                      </select>    
					  <input type='hidden' name='hook_yn_nm' value=''>
					  <input type='hidden' name='hook_yn_nm' value=''>
                    </td>
                </tr>
                	
                </tr>
                <tr>
                  <td class=title><input type="checkbox" name="u_chk" value="10"></td> 
                    <td class=title>피보험자변경</td>
                    <td>&nbsp;
                      <input type='text' name='vins_con_f_nm' size='50' value='<%=ins.getCon_f_nm()%>' class='whitetext'>
                    </td>
                    <td>&nbsp;
                      <input type='text' name='vins_con_f_nm' size='50' class='text'></td>
                </tr>
                <tr>
                  <td class=title><input type="checkbox" name="u_chk" value="11"></td> 
                    <td class=title>보험갱신</td>
                    <td>&nbsp;
                      -
                    </td>
                    <td>&nbsp;
                      <input type='text' name='vins_renew' size='50' class='text'></td>
                </tr>
                <tr>
                  <td class=title><input type="checkbox" name="u_chk" value="12"></td> 
                    <td class=title>기타</td>
                    <td>&nbsp;
                      -
                    </td>
                    <td>&nbsp;
                      <input type='text' name='vins_etc' size='50' class='text'></td>
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
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>등록구분</td>
                    <td>&nbsp;
        		<input type='radio' name="cng_st" value='1' >
                        반영
                        <input type='radio' name="cng_st" value='2' >
                        견적
                    </td>
                </tr>
                <tr> 
                    <td width='10%' class='title'>변경일자</td>
                    <td>&nbsp;
        			  <input type='text' name='cng_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 24시 </td>
                </tr>
                <tr> 
                    <td width='10%' class='title'>변경담보유효기간</td>
                    <td>&nbsp;
        			  <input type='text' name='cng_s_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> ~ <input type='text' name='cng_e_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> </td>
                </tr>
                <%if(scdFee_vt_size > 0){ %>
                <tr> 
                    <td width='10%' class='title'>결제예정일</td>
                    <td>&nbsp;
        			  	<select name='r_fee_est_dt' style="width:100px">
                        	<option value="">선택</option>
                        	<%
                       		
                        		int count = 0 ;
			    				for (int j = 0 ; j < scdFee_vt_size ; j++){
    								Hashtable ht = (Hashtable)scd_fee.elementAt(j); 
    								if(Integer.parseInt(String.valueOf(ht.get("R_FEE_EST_DT"))) >= Integer.parseInt(strToday) 
    									&& count < 5 ){
    									count++;
    						%>
    						<option value="<%=ht.get("R_FEE_EST_DT")%>"><%=ht.get("YEAR")%>-<%=ht.get("MONTH")%>-<%=ht.get("DAY")%></option>	
   								<%	} %>
   							<%	} %>
	   						
                      </select>
        			  </td>
                </tr>
                <%} %>
                <tr> 
                    <td class='title'>사유 및 특이사항</td>
                    <td>&nbsp;
        			  <textarea name="cng_etc" cols="100" class="text" style="IME-MODE: active" rows="5"></textarea> 
                    </td>
                </tr>
				<!--
                <tr> 
                    <td width='10%' class='title'>보험변경요청서</td>
                    <td>&nbsp;
        			  (팩스발송용) <a href="javascript:ins_doc_form();">보험변경요청서</a></td>
                </tr>				
				-->
            </table>
        </td>
    </tr>	
	<tr>
	    <td>* 변경담보유효기간 종료 3일전에는 담당자(기안자)에게 종료예정임을 사내메신저로 통보할 예정입니다. 담당자는 변경내용의 연장 여부 등을 반드시 보험관리담당자에게 문서로 제출해야만 합니다.</td>
	</tr>		
	<!--
	<tr>
	    <td>* 보험변경요청서는 고객에게 선발송합니다. 명판 및 인감 날인된 것을 받아 문서 기안시 스캔하여 등록하여 주세요.</td>
	</tr>		
	-->
	<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    <tr>
		<td align="right"><a href="javascript:save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
	</tr>	
	<%}%>
	
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
