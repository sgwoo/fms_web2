<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*, acar.car_mst.*, acar.estimate_mng.*, acar.secondhand.* , acar.user_mng.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="cm_bean2" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"2":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String esti_m = request.getParameter("esti_m")==null?"":request.getParameter("esti_m");
	String esti_m_dt = request.getParameter("esti_m_dt")==null?"":request.getParameter("esti_m_dt");
	String esti_m_s_dt = request.getParameter("esti_m_s_dt")==null?"":request.getParameter("esti_m_s_dt");
	String esti_m_e_dt = request.getParameter("esti_m_e_dt")==null?"":request.getParameter("esti_m_e_dt");	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String today_dist 	= request.getParameter("today_dist")==null?"":request.getParameter("today_dist");
	
	String white = "";
	String disabled = "";
	if(cmd.equals("")){
		white = "white";
		disabled = "disabled";
	}
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
		
	EstiDatabase e_db = EstiDatabase.getInstance();
	e_bean = e_db.getEstimateCase(est_id);
	
	
	EstimateBean rm_bean = e_db.getEstiRmCase(est_id);
	
	
	String a_a = e_bean.getA_a().substring(0,1);
	String rent_way = e_bean.getA_a().substring(1);
	String a_b = e_bean.getA_b();
	float o_13 = 0;
	
	//CAR_NM : 차명정보
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	cm_bean2 = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	String a_e = cm_bean2.getS_st();
	
	if(e_bean.getEst_st().equals("3")){
		if(car_mng_id.equals(""))	car_mng_id 	= est_id;
	}else{
		if(car_mng_id.equals(""))	car_mng_id 	= e_bean.getMgr_nm();
	}
	
	//차량정보
	Hashtable ht = shDb.getShBase(car_mng_id);
	
	String car_comp_id		= String.valueOf(ht.get("CAR_COMP_ID"));
	String car_id			= String.valueOf(ht.get("CAR_ID"));
	String car_seq			= String.valueOf(ht.get("CAR_SEQ"));
	String s_st 			= String.valueOf(ht.get("S_ST"));
	String jg_code 			= String.valueOf(ht.get("JG_CODE"));
	String car_no 			= String.valueOf(ht.get("CAR_NO"));
	String car_name			= String.valueOf(ht.get("CAR_NAME"));
	String init_reg_dt 		= String.valueOf(ht.get("INIT_REG_DT"));
	String secondhand_dt 	= String.valueOf(ht.get("SECONDHAND_DT"));
	String park		 		= String.valueOf(ht.get("PARK"));
	String dlv_dt 			= String.valueOf(ht.get("DLV_DT"));	
	String before_one_year 	= String.valueOf(ht.get("BEFORE_ONE_YEAR"));
	String tot_dist 		= String.valueOf(ht.get("TOT_DIST"));
	String serv_dt	 		= String.valueOf(ht.get("SERV_DT"));
	String lpg_yn	 		= String.valueOf(ht.get("LPG_YN"));
	String opt		 		= String.valueOf(ht.get("OPT"));
	String colo		 		= String.valueOf(ht.get("COL"));
	int car_amt 			= AddUtil.parseInt((String)ht.get("CAR_AMT"));
	int opt_amt 			= AddUtil.parseInt((String)ht.get("OPT_AMT"));
	int clr_amt 			= AddUtil.parseInt((String)ht.get("COL_AMT"));
	if(today_dist.equals(""))	today_dist 	= String.valueOf(ht.get("TODAY_DIST"));
	
	if(e_bean.getCar_amt()==0){
		e_bean.setCar_amt(car_amt);
		e_bean.setOpt_amt(opt_amt);
		e_bean.setCol_amt(clr_amt);
	}
	
	String stat = "";
	if(e_bean.getEst_st().equals("3") && car_amt == 0) stat = "신차가격불명";
	if(e_bean.getEst_st().equals("3") && AddUtil.parseInt((String)ht.get("O_L")) == 0) stat = "중고차가미정";
	
	//잔가 차량정보
	Hashtable sh_var = shDb.getShBaseVar(car_mng_id);
	
	int sh_car_amt			= AddUtil.parseInt((String)sh_var.get("SH_CAR_AMT"));
	int dlv_car_amt			= AddUtil.parseInt((String)sh_var.get("DLV_CAR_AMT"));
	
	sh_car_amt 	= e_bean.getO_1();
	dlv_car_amt = car_amt+opt_amt+clr_amt-e_bean.getO_1();	
	
	
	
	//공통변수
	em_bean = e_db.getEstiCommVarCase(a_a, "");
	
	
	//최대잔가
	o_13 = e_db.getJanga(e_bean.getCar_id(), e_bean.getCar_seq(), a_b, e_bean.getLpg_yn());			
	
	//자동차회사 리스트
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll_Esti();
	
	//차종리스트
	CarMstDatabase cmb = CarMstDatabase.getInstance();
	CarMstBean cm_r [] = cmb.getCarKindAll_Esti(e_bean.getCar_comp_id());
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	CodeBean[] goods = c_db.getCodeAll2("0009", "Y"); /* 코드 구분:대여상품명 */
	int good_size = goods.length;
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	
	String u_nm ="";
	String u_mt ="";
	String u_ht ="";
	
	UserMngDatabase umdb = UserMngDatabase.getInstance();
	
	UsersBean user_bean = umdb.getUsersBean(e_bean.getReg_id());
	
		u_nm = user_bean.getUser_nm();
		u_mt = user_bean.getUser_m_tel();
		u_ht = user_bean.getHot_tel();
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//고객수정하기
	function CustUpate(){
		var fm = document.form1;
		if(!confirm('고객정보를 수정하시겠습니까?')){	return; }	
		fm.action = 'upd_esti_cust_a.jsp';		
		fm.target = 'i_no';
		fm.submit();				
	}	
	
	//목록보기
	function go_list(){
		location='esti_rm_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&esti_m=<%= esti_m %>&esti_m_dt=<%= esti_m_dt %>&esti_m_s_dt=<%= esti_m_s_dt %>&esti_m_e_dt=<%= esti_m_e_dt %>';
	}

	
	//재리스 견적내기
	function EstiReg(){
		var fm = document.form1;
		fm.action = '/acar/secondhand/secondhand_detail_frame.jsp';
		fm.target = "d_content";
		fm.submit();
	}
	
	//메일수신하기
	function open_mail(){
		var SUBWIN="/acar/apply/mail_input.jsp?est_id=<%=est_id%>&est_email=<%=e_bean.getEst_email()%>&acar_id=<%=user_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st=sh_rm_fms_new";	
		window.open(SUBWIN, "openMail", "left=100, top=100, width=420, height=600, scrollbars=no, status=yes");
	}	
	
	//견적서보기
	function EstiView(){
		var SUBWIN="/acar/secondhand_hp/estimate_rm_new.jsp?est_id=<%=est_id%>&acar_id=<%=user_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st=sh_rm_fms_new";					
		window.open(SUBWIN, "EstiPrint", "left=50, top=50, width=698, height=700, scrollbars=yes, status=yes");				
	}
		
	//견적결과 문자보내기
	function esti_result_sms(){
		var fm = document.form1;
		
		if(fm.est_tel.value != '' && fm.est_m_tel.value == ''){ 	fm.est_m_tel.value = fm.est_tel.value }		
		
		if(fm.est_m_tel.value == ''){ 	alert('수신번호를 입력하십시오'); 		return; }		
		
		fm.cmd.value = 'result_sms';
		
		if(!confirm('결과문자를 발송하시겠습니까?')){	return; }	
		fm.action = 'upd_esti_cust_a.jsp';		
		fm.target = 'i_no';					
		fm.submit();
	}
	
	//견적결과 선택 상세내용 문자보내기
	function select_esti_result_sms(){
		var fm = document.form1;
						
		if(fm.est_tel.value != '' && fm.est_m_tel.value == ''){ 	fm.est_m_tel.value = fm.est_tel.value }		
		
		if(fm.est_m_tel.value == ''){ 	alert('수신번호를 입력하십시오'); 		return; }		
				
		fm.cmd.value = 'result_select_sms_wap_rm';
		
		if(!confirm('이 번호로 결과문자를 발송하시겠습니까?')){	return; }	
		
		fm.action = 'upd_esti_cust_a.jsp';		
		fm.target = 'i_no';							
		fm.submit();	
	}					
//-->
</script>
</head>
<body leftmargin="15">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form action="../car_mst/car_mst_null.jsp" name="form2" method="post">
    <input type="hidden" name="sel" value="">
    <input type="hidden" name="car_comp_id" value="">
    <input type="hidden" name="code" value="">
    <input type="hidden" name="mode" value="">
  </form>
  <form action="./esti_rm_mng_u_a.jsp" name="form1" method="POST" >
    <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
    <input type="hidden" name="br_id" value="<%=br_id%>">
    <input type="hidden" name="user_id" value="<%=user_id%>">
    <input type="hidden" name="gubun1" value="<%=gubun1%>">
    <input type="hidden" name="gubun2" value="<%=gubun2%>">
    <input type="hidden" name="gubun3" value="<%=gubun3%>">
    <input type="hidden" name="gubun4" value="<%=gubun4%>">
  <input type="hidden" name="gubun5" value="<%=gubun5%>">
  <input type="hidden" name="gubun6" value="<%=gubun6%>">  
    <input type="hidden" name="s_dt" value="<%=s_dt%>">
    <input type="hidden" name="e_dt" value="<%=e_dt%>">
    <input type="hidden" name="s_kd" value="<%=s_kd%>">
    <input type="hidden" name="t_wd" value="<%=t_wd%>">
    <input type="hidden" name="esti_m" value="<%=esti_m%>">
    <input type="hidden" name="esti_m_dt" value="<%=esti_m_dt%>">
    <input type="hidden" name="esti_m_s_dt" value="<%=esti_m_s_dt%>">
    <input type="hidden" name="esti_m_e_dt" value="<%=esti_m_e_dt%>">
    <input type="hidden" name="est_id" value="<%=est_id%>">
    <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">	
    <input type="hidden" name="cmd" value="<%=cmd%>">
    <input type="hidden" name="s_st" value="">
    <input type="hidden" name="a_e" value="">
	<input type="hidden" name="udt_st" value="<%=e_bean.getUdt_st()%>">
	<input type="hidden" name="spr_yn" value="<%=e_bean.getSpr_yn()%>">
	<input type="hidden" name="set_code" value="">	
	<input type="hidden" name="from_page" value="esti_rm_mng_u.jsp">	
	<input type="hidden" name="u_nm" value="<%=u_nm%>">
	<input type="hidden" name="u_mt" value="<%=u_mt%>">
	<input type="hidden" name="u_ht" value="<%=u_ht%>">
	<input type="hidden" name="dlv_car_amt" value="<%=dlv_car_amt%>">
	
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 견적관리 > <span class=style5>월렌트 견적보기(<%=est_id%>)</span></span> : (<%=est_id%>)</td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객정보</span></td>
        <td align="right">
        <a href="javascript:go_list();"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellpadding=0 cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>상호/성명</td>
                    <td width=19%> 
                        &nbsp;<input type="text" name="est_nm" value="<%=e_bean.getEst_nm()%>" size="27" class=text style='IME-MODE: active'>
						
                  </td>
                    <td class=title width=13%>사업자/생년월일</td>
                    <td width=14%> 
                        &nbsp;<input type="text" name="est_ssn" value="<%=e_bean.getEst_ssn()%>" size="15" class=text>
                    </td>
                    <td class=title width=10%>전화번호</td>
                    <td width=12%> 
                        &nbsp;<input type="text" name="est_tel" value="<%=e_bean.getEst_tel()%>" size="12" class=text>
                    </td>
                    <td class=title width=10%>FAX</td>
                    <td width=12%> 
                        &nbsp;<input type="text" name="est_fax" value="<%=e_bean.getEst_fax()%>" size="12" class=text>
                    </td>
                </tr>
                <tr>				
                    <td class=title>이메일</td>
                    <td colspan="7">
                    	&nbsp;<input type="text" name="est_email" value="<%=e_bean.getEst_email()%>" size="30" class=text style='IME-MODE: inactive'>
                      </td>
                </tr>					  
                <tr>				
                    <td class=title>고객구분</td>
                    <td colspan="7">&nbsp;<input type="radio" name="doc_type" value="1" <% if(e_bean.getDoc_type().equals("1")||e_bean.getDoc_type().equals("")) out.print("checked"); %>>
                      법인고객
					  <input type="radio" name="doc_type" value="2" <% if(e_bean.getDoc_type().equals("2")) out.print("checked"); %>>
                      개인사업자 
					  <input type="radio" name="doc_type" value="3" <% if(e_bean.getDoc_type().equals("3")) out.print("checked"); %>>
                      개인 					  
                      </td>
                </tr>					  
                <tr>
                    <td class=title>견적유효기간</td>
                    <td colspan="7">&nbsp;<input type="radio" name="vali_type" value="0" <% if(e_bean.getVali_type().equals("0")||e_bean.getVali_type().equals("")) out.print("checked"); %>>
                      날짜만표기(10일)
					  <input type="radio" name="vali_type" value="1" <% if(e_bean.getVali_type().equals("1")) out.print("checked"); %>>
                      메이커D/C 변경 가능성 언급 
					  <input type="radio" name="vali_type" value="2" <% if(e_bean.getVali_type().equals("2")) out.print("checked"); %>>
                      미확정견적 
                      </td>
                </tr>				
                <tr>
                    <td class=title>신용도</td>
                    <td colspan="7">&nbsp;<b><% if(e_bean.getSpr_yn().equals("2")){%>초우량기업<% }else if(e_bean.getSpr_yn().equals("1")){%>우량기업<% }else if(e_bean.getSpr_yn().equals("0")){%>일반기업<% }else if(e_bean.getSpr_yn().equals("3")){%>신설법인<%}%></b>
                      </td>
                </tr>	
                <tr>
                    <td class=title>담당자</td>
                    <td colspan="7">&nbsp;<select name='damdang_id' class=default>            
                        <option value="">미지정</option>
        		        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); 
        				%>
          			    <option value='<%=user.get("USER_ID")%>' <% if(e_bean.getReg_id().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                		<%		}
        					}%>
        			  </select>
                      </td>
                </tr>															
            </table>
        </td>
    </tr>
    <tr> 
        <td></td>
        <td align="right"><a href="javascript:CustUpate();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정보</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=10%>제조사</td>
                    <td colspan="2">&nbsp;<select name="car_comp_id" onChange="javascript:GetCarCode()" <%=disabled%>>
                        <%for(int i=0; i<cc_r.length; i++){
        						        cc_bean = cc_r[i];%>
                        <option value="<%= cc_bean.getCode() %>" <%if(e_bean.getCar_comp_id().equals(cc_bean.getCode()))%>selected<%%>><%= cc_bean.getNm() %></option>
                        <%	}	%>
                      </select> </td>
                </tr>
                <tr> 
                    <td class=title>차명</td>
                    <td colspan="2">&nbsp;<select name="code" <%=disabled%>>
                        <option value="">선택</option>
                        <%for(int i=0; i<cm_r.length; i++){
        						        cm_bean = cm_r[i];%>
                        <option value="<%= cm_bean.getCode() %>" <%if(e_bean.getCar_cd().equals(cm_bean.getCode()))%>selected<%%>>[<%=cm_bean.getCar_cd()%>]<%=cm_bean.getCar_nm()%></option>
                        <%	}	%>
                      </select> 
					  (<%=cm_bean2.getJg_code()%>)
					  </td>
                </tr>
                <tr> 
                    <td class=title width=10%>차종</td>
                    <td width=65%> 
                      <%if(!cmd.equals("")){%>
                      &nbsp;<a href="javascript:sub_list('1');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a> 
                      <%}%>
                      &nbsp;<input type="text" name="car_name" value="<%=cm_bean2.getCar_name()%>" size="75" class=<%=white%>text> 
                      <input type="hidden" name="car_id" value="<%=e_bean.getCar_id()%>"> 
                      <input type="hidden" name="car_seq" value="<%=e_bean.getCar_seq()%>"> 
                    </td>
                    <td align="center"> <input type="text" name="car_amt" value="<%=AddUtil.parseDecimal(e_bean.getCar_amt())%>" size="15" class=<%=white%>num>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>옵션</td>
                    <td> 
                      <%if(!cmd.equals("")){%>
                      &nbsp;<a href="javascript:sub_list('2');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>  
                      <%}%>
                      &nbsp;<input type="text" name="opt" value="<%=e_bean.getOpt()%>" size="75" class=<%=white%>text> 
                      <input type="hidden" name="opt_seq" value="<%=e_bean.getOpt_seq()%>"> 
                    </td>
                    <td align="center"> <input type="text" name="opt_amt" value="<%=AddUtil.parseDecimal(e_bean.getOpt_amt())%>" size="15" class=<%=white%>num>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>색상</td>
                    <td> 
                      <%if(!cmd.equals("")){%>
                      &nbsp;<a href="javascript:sub_list('3');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>  
                      <%}%>
                      &nbsp;<input type="text" name="col" value="<%=e_bean.getCol()%>" size="75" class=<%=white%>text> 
                      <input type="hidden" name="col_seq" value="<%=e_bean.getCol_seq()%>"> 
                    </td>
                    <td align="center"> <input type="text" name="col_amt" value="<%=AddUtil.parseDecimal(e_bean.getCol_amt())%>" size="15" class=<%=white%>num>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>감가상각</td>
                    <td>&nbsp;신차등록일 : <%=AddUtil.ChangeDate2(init_reg_dt)%>&nbsp;&nbsp;&nbsp;&nbsp;주행거리 : <%= AddUtil.parseDecimal(today_dist) %> <%if(today_dist.equals("0")) out.println("*****");%> km
                    </td>
                    <td align="center"> -<input type="text" name="dc_amt" value="<%=AddUtil.parseDecimal(dlv_car_amt)%>" size="15" class=<%=white%>num onBlur='javscript:this.value = parseDecimal(this.value); set_amt();'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">차량가격 (차량번호 : <%=car_no%>)</td>
                    <td align="center"><input type="text" name="o_1" value="<%=AddUtil.parseDecimal(e_bean.getO_1())%>" size="15" class=<%=white%>num>
                      원</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약조건</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr> 
                    <td width=10% colspan="2" class=title>견적일시</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate3(e_bean.getReg_dt())%> </td>
                </tr>
                <tr> 
                    <td colspan="2" class=title>대여상품</td>
                    <td colspan="3">&nbsp;<select name="a_a" onChange="javascript:change_c(); opt_display(); GetVar();" <%=disabled%>>
                        <option value="">=선 택=</option>
                        <%for(int i = 0 ; i < good_size ; i++){
        					CodeBean good = goods[i];%>
                        <option value='<%= good.getNm_cd()%>' <%if(e_bean.getA_a().equals(good.getNm_cd()))%>selected<%%>><%= good.getNm()%></option>
                        <%}%>
                      </select> 
                      <!--<input type="text" name="reg_dt" value="<%=AddUtil.getDate()%>" class=text size="12" onBlur='javscript:this.value = ChangeDate(this.value);'>
                      견적일자 -->
                    </td>
                </tr>
                <tr> 
                    <td colspan="2" class=title>대여기간</td>
                    <td colspan="3">&nbsp;
                      <input type="text" name="a_b" value="<%=e_bean.getA_b()%>" size="2" class=<%=white%>text>개월
                    </td>
                </tr>				
                <tr> 
                    <td width="10%" rowspan="2" class=title>잔가</td>
                    <td width="8%" class=title>적용잔가율</td>
                    <td colspan="3"> &nbsp;차가의 
                      <input type="text" name="ro_13" value="<%=e_bean.getRo_13()%>" size="4" class=<%=white%>text  onblur="javascript:compare(this)">
                      % <font color="#666666">(최대잔가율 
                      <input type="text" name="o_13" value="<%=o_13*100%>" class=whitenum size="3">
                      % 내에서 선택)</font> , 적용잔가금액 
                      <input type="text" name="ro_13_amt" class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);' value="<%=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>">
                      원 <font color="#666666">(매입옵션 금액임)</font>
					  <a href="javascript:searchO13();"><img src=/acar/images/center/button_in_max.gif align=absmiddle border=0></a>
					  </td>
                </tr>
                <tr>
                  <td class=title>매입옵션</td>
                  <td colspan="3">&nbsp;
				    <input type='radio' name="opt_chk" value='0' <%if(e_bean.getOpt_chk().equals("0")){%> checked <%}%>>
                      미부여
                      <input type='radio' name="opt_chk" value='1' <%if(e_bean.getOpt_chk().equals("1")){%> checked <%}%>>
        	 		  부여
					</td>
                </tr>				
                <tr> 
                    <td rowspan="3" class=title>선수</td>
                    <td class=title>보증금<br>
                    </td>
                    <td colspan="3">&nbsp;차가의 
                      <input type="text" name="rg_8" value="<%=e_bean.getRg_8()%>" class=<%=white%>num size="4" onBlur="javascript:compare(this)">
                      %, 적용보증금액 <font color="#666666"> 
                      <input type="text" name="rg_8_amt" value="<%=AddUtil.parseDecimal(e_bean.getRg_8_amt())%>" class=<%=white%>num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      원 (기본보증금율 
                      <input type="text" name="g_8" value="<%=em_bean.getG_8()%>" class=whitenum size="3">
                      % 이상에서 선택) </font> </td>
                </tr>
                <tr> 
                    <td class=title>선납금<br>
                    </td>
                    <td colspan="3">&nbsp;차가의 
                      <input type="text" name="pp_per" value="<%=e_bean.getPp_per()%>" class=<%=white%>num size="4" onBlur="javascript:compare(this)">
                      %, 적용선납금액<font color="#666666">&nbsp;</font> <input type="text" name="pp_amt" value="<%=AddUtil.parseDecimal(e_bean.getPp_amt())%>" class=<%=white%>num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      원 </td>
                </tr>
                <tr id="tr_ifee" style="display:''"> 
                    <td class=title>개시대여료</td>
                    <td colspan="3">&nbsp;<font color="#666666"> 
                    <input type="checkbox" name="pp_st" value="1" <%if(e_bean.getPp_st().equals("1"))%> checked<%%> <%=disabled%>>
                    <input type="text" name="g_10" class=<%=white%>num size="2" value="<%=e_bean.getG_10()%>">
                    개월치 대여료 선납 </font></td>
                </tr>
                 <tr> 
                    <td rowspan="3" class=title>보험</td>
                    <td class=title>대물,자손</td>
                    <td >&nbsp;                      <select name="ins_dj"  <%=disabled%>>
                        <option value="1" <%if(e_bean.getIns_dj().equals("1"))%>selected<%%>>5천만원/5천만원</option>
                        <option value="2" <%if(e_bean.getIns_dj().equals("2"))%>selected<%%>>1억원/1억원</option>
                        <option value="4" <%if(e_bean.getIns_dj().equals("4"))%>selected<%%>>2억원/1억원</option>
                    </select> </td>
                    <!--
                    <td class=title width=11%>애니카보험</td>
                    <td>&nbsp;<select name="ins_good" <%=disabled%>>
                        <option value="0" <%if(e_bean.getIns_good().equals("0"))%>selected<%%>>미가입</option>
                        <option value="1" <%if(e_bean.getIns_good().equals("1"))%>selected<%%>>가입</option>
                      </select> </td>
                      -->
                      <td class=title width='11%'>보험계약자</td>
                    <td> 
                      &nbsp;<select name="insurant"  <%=disabled%>>
                            <option value="1" <%if(e_bean.getInsurant().equals("1"))%>selected<%%>>아마존카</option>
                            <!--<option value="2" <%if(e_bean.getInsurant().equals("2"))%>selected<%%>>고객</option>-->
                          </select>
                    </td>	 
                </tr>
                <tr>
                  <td class=title>운전자연령</td> 
                    <td >&nbsp;                      <select name="ins_age"  <%=disabled%>>
                        <option value="1" <%if(e_bean.getIns_age().equals("1"))%>selected<%%>>만26세이상</option>
						<option value="3" <%if(e_bean.getIns_age().equals("3"))%>selected<%%>>만24세이상</option>
                        <option value="2" <%if(e_bean.getIns_age().equals("2"))%>selected<%%>>만21세이상</option>
                    </select> </td>
                    <td class=title width='11%'>피보험자</td>
                    <td> 
                      &nbsp;<select name="ins_per"  <%=disabled%>>
                            <option value="1" <%if(e_bean.getIns_per().equals("1"))%>selected<%%>>아마존카(보험포함)</option>
                            <option value="2" <%if(e_bean.getIns_per().equals("2"))%>selected<%%>>고객(보험미포함)</option>
                          </select>
                    </td>	
                </tr>
                <tr> 
                    <td class=title>보증보험</td>
                    <td>&nbsp;<select name="gi_yn"  <%=disabled%>>
                        <option value="0" <%if(e_bean.getGi_yn().equals("0"))%>selected<%%>>면제</option>
                        <option value="1" <%if(e_bean.getGi_yn().equals("1"))%>selected<%%>>가입</option>
                      </select> </td>
                    <td class=title>자차면책금</td>
                    <td>&nbsp;<input type="text" name="car_ja" value="<%=AddUtil.parseDecimal(e_bean.getCar_ja())%>" class=<%=white%>num size="10" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>					  
                </tr>
               <tr> 
                    <td rowspan="3" class=title>기타<br> </td>
                    <td class=title>등록지역</td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0032", "", e_bean.getA_h())%></td>
                    <td class=title>차량인수지</td>
                    <td>&nbsp;<select name="f_udt_st"  <%=disabled%> >
                        <option value="">=선 택=</option>
                        <option value="1" <%if(e_bean.getUdt_st().equals("1"))%>selected<%%>>서울본사</option>
                        <option value="2" <%if(e_bean.getUdt_st().equals("2"))%>selected<%%>>부산지점</option>
                        <option value="3" <%if(e_bean.getUdt_st().equals("3"))%>selected<%%>>대전지점</option>
                        <option value="4" <%if(e_bean.getUdt_st().equals("4"))%>selected<%%>>고객</option>
                      </select> </td>					  
                </tr>
                <tr> 
                    <td class=title>대여료D/C</td>
                    <td>&nbsp;대여료의 
                      <input type="text" name="fee_dc_per" value="<%=e_bean.getFee_dc_per()%>" size="4" class=<%=white%>text>
                      %</td>
					<td class=title>영업수당</td>
                    <td>&nbsp;차가의 
                      <input type="text" name="o_11" value="<%=e_bean.getO_11()%>" size="4" class=<%=white%>text>
                      %</td>  
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>견적결과</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=10%>구분</td>
                    <td class=title width=20%>1개월 대여요금</td>
                    <td class=title width=15%>대여기간</td>
                    <td class=title width=15%>할인율</td>
                    <td class=title width=20%>할인율적용대여료</td>
                    <td class=title width=20%>기간적용대여료</td>
                </tr>
                <tr> 
                    <td class=title>공급가</td>
                    <td align="center"><input type="text" name="fee_s_amt" value="<%=AddUtil.parseDecimal(e_bean.getFee_s_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center" rowspan="3"><%=rm_bean.getMonths()%>개월<%=rm_bean.getDays()%>일</td>
                    <td align="center" rowspan="3"><%=rm_bean.getPer()%></td>
                    <td align="center"><input type="text" name="tot_rm" value="<%=AddUtil.parseDecimal(rm_bean.getTot_rm())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"><input type="text" name="tot_rm1" value="<%=AddUtil.parseDecimal(rm_bean.getTot_rm1())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>부가세<br> </td>
                    <td align="center"><input type="text" name="fee_v_amt" value="<%=AddUtil.parseDecimal(e_bean.getFee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"><input type="text" name="tot_rm_v_amt" value="<%=AddUtil.parseDecimal(AddUtil.parseInt(rm_bean.getTot_rm())*0.1)%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"><input type="text" name="tot_rm1_v_amt" value="<%=AddUtil.parseDecimal(AddUtil.parseInt(rm_bean.getTot_rm1())*0.1)%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                </tr>
                <tr> 
                    <td class=title>계</td>
                    <td align="center"><input type="text" name="t_fee_amt" value="<%=AddUtil.parseDecimal(e_bean.getFee_s_amt()+e_bean.getFee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"><input type="text" name="t_tot_rm_amt" value="<%=AddUtil.parseDecimal(AddUtil.parseInt(rm_bean.getTot_rm())*1.1)%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"><input type="text" name="t_tot_rm1_amt" value="<%=AddUtil.parseDecimal(AddUtil.parseInt(rm_bean.getTot_rm1())*1.1)%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                </tr>
                <tr> 
                    <td class=title colspan="2">월대여료 잔여 납입회수</td>
                    <td colspan="4">
                      &nbsp;<font color="#666666"><input type="text" name="tm" value="<%=AddUtil.parseInt(e_bean.getA_b())-e_bean.getG_10()%>" class=<%=white%>num size="2">
                      </font>회</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">보증보험가입금액 </td>
                    <td>&nbsp;<input type="text" name="gi_amt" value="<%=AddUtil.parseDecimal(e_bean.getGi_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td class=title>보증보험료</td>
                    <td colspan="2">&nbsp;<input type="text" name="gi_fee" value="<%=AddUtil.parseDecimal(e_bean.getGi_fee())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                </tr>
                <tr> 
                    <td class=title colspan="2">중도해지위약금</td>
                    <td colspan="4">&nbsp;잔여기간 대여료총액의 
                      <input type="text" name="cls_per" value="<%=e_bean.getCls_per()%>" size="4" class=<%=white%>text>
                      %</td>
                </tr>				
            </table>
        </td>
    </tr>
    <tr> 
        <td align=right colspan="2">&nbsp; </td>
    </tr>
    <tr> 
        <td align=center colspan="2"> 
          <a href="javascript:EstiReg();" title='재리스견적 다시 내기'><img src=/acar/images/center/button_again_gj.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
          <a href="javascript:open_mail()" title='메일발송하기'><img src=/acar/images/center/button_send_mail.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
    	  <a href="javascript:EstiView()" title='견적서보기'><img src=/acar/images/center/button_est_see.gif align=absmiddle border=0></a> 
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>결과문자 발송</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    <tr> 
    <%
		String url1 = "http://fms1.amazoncar.co.kr/acar/secondhand_hp/estimate_rm_new.jsp?est_id="+est_id+"&acar_id="+user_id+"&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st=sh_rm_fms_new";
	%> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
				<tr>
					<td class=title>수신번호</td>
					<td>&nbsp;
						<input type="text" name="est_m_tel" value="" size="20" class=text></td>
				</tr>			
                <tr>
                  <td width="10%" class=title>문자내용</td>
                  <td width="90%">&nbsp;
                  					  	<input type="text" name="sms_cont1" value="<%=e_bean.getEst_nm()%> 고객님께서 요청하신 견적서를" size="70" class=whitetext readOnly>
						<br>
						&nbsp;
					<select name='sms_cont2'>            
                        <option value="">없음</option>					
                        <option value="팩스" selected>팩스</option>
                        <option value="메일">메일</option>
					</select>	
					<input type="text" name="sms_cont3" value="로 보냈으니 확인 바랍니다. 궁금한 점이 있으면 언제든지 전화주세요. 담당자는 <%=u_nm%> <%=u_mt%> 입니다. (주)아마존카" size="120" class=whitetext readOnly>	
					&nbsp;<a href="javascript:esti_result_sms();" title='문자보내기'><img src=/acar/images/center/button_send_smsgo.gif align=absmiddle border=0></a>				
				  </td>
                </tr>		
                <tr>
                  <td width="10%" class=title><input type="checkbox" name="ch_mms_id" value="<%=e_bean.getEst_id()%>" checked >견적문자1</td>
                  <td width="90%">&nbsp;
		    <input type="text" name="wap_msg_body" value="[고객님이 요청하신 월렌트 견적 안내.] <%=car_no%> <%=cm_bean.getCar_nm()%> <%=AddUtil.parseDecimal(e_bean.getO_1()+dlv_car_amt)%>원 <%=AddUtil.getDate3(init_reg_dt).substring(0,9)%>식 <%= AddUtil.parseDecimal(today_dist) %>km <%=rm_bean.getMonths()%>개월 <%=AddUtil.parseDecimal(AddUtil.parseInt(rm_bean.getTot_rm())*1.1)%>원/월 VAT포함 (견적서 보기 : <%=ShortenUrlGoogle.getShortenUrl(url1) %> ) 담당자는 <%=u_nm%> <%=u_mt%> 입니다. (주)아마존카 " size="146" class=text>
		    <input type="hidden" name="a_url" value="<%=ShortenUrlGoogle.getShortenUrl(url1)%>">                           
		    <input type="hidden" name="a_car_name" value="<%=car_no%> <%=cm_bean.getCar_nm()%>">                           
		    <input type="hidden" name="a_gubun1" value="<%=AddUtil.getDate3(init_reg_dt).substring(0,9)%>식 <%= AddUtil.parseDecimal(today_dist) %>km">
		    <input type="hidden" name="a_gubun2" value="">
		    &nbsp;<a href="javascript:select_esti_result_sms();" title='문자보내기'><img src=/acar/images/center/button_send_smsgo.gif align=absmiddle border=0></a>				
		  </td>
                </tr>	                 
            </table>
        </td>
    </tr>			
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>