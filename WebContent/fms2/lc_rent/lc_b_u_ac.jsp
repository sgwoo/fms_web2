<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.car_office.*, acar.con_ins.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")  ==null?acar_br:request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"" :request.getParameter("t_wd");
	String andor = request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st = request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String now_stat = request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	String san_st = request.getParameter("san_st")==null?"":request.getParameter("san_st");

	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//자동차기본정보-기본차량
	CarMstBean cm_bean2 = new CarMstBean();
	if(!cm_bean.getCar_b_inc_id().equals("")){
		cmb.getCarNmCase(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	}
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	
	//중고차 딜러와 판매처
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "5");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "6");
	
	
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	
	
	
	//영업소리스트
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();
	
	//금융사리스트 - cms 가능
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
	
  //차량등록지역
  CodeBean[] code32 = c_db.getCodeAll3("0032");
  int code32_size = code32.length;	
	
	//잔가변수NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	Hashtable carOld = new Hashtable();	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&from_page="+from_page+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
				  "&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+rent_st+"";
	String valus_t = valus;
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	
	function replaceFloatRound(per){return Math.round(per*1000)/10;}
	function replaceFloatRound2(per){return Math.round(per*10)/10;}
	//길이 체크
	function CheckLen(f, max_len){
		if(get_length(f)>max_len){alert(f+'는 길이'+len+'로 최대길이'+max_len+'를 초과합니다.');}
	}
	//리스트
	function list(){
		var fm = document.form1;
		if(fm.from_page.value==''){fm.action='lc_b_frame.jsp';}
		else{fm.action=fm.from_page.value;}
		fm.target='d_content';
		fm.submit();
	}
	
	//등록/수정: 차량가격 입력시 자동계산으로 가게..
	function enter_car(obj)
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') set_car_amt(obj);
	}	
	//등록/수정: 공급가, 부가세, 합계 입력시 자동계산
	function set_car_amt(obj)
	{
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		
		//중고차 원단위 처리가 달라서 미결에서 자동계산은 안함.
		
		sum_car_c_amt();
		sum_car_f_amt();
	}	

	//차량 소비자가 합계
	function sum_car_c_amt(){
		var fm = document.form1;
		
		fm.tot_cs_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) );
		fm.tot_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)) );
		fm.tot_c_amt.value  	= parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)) + toInt(parseDigit(fm.tot_cv_amt.value)) );
	}
	
	//차가 구입가 합계
	function sum_car_f_amt(){
		var fm = document.form1;
		
		fm.tot_fs_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.commi_s_amt.value)) + toInt(parseDigit(fm.storage_s_amt.value)));
		fm.tot_fv_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) + toInt(parseDigit(fm.commi_v_amt.value)) + toInt(parseDigit(fm.storage_v_amt.value)));
		fm.tot_f_amt.value 		= parseDecimal(toInt(parseDigit(fm.tot_fs_amt.value)) + toInt(parseDigit(fm.tot_fv_amt.value)) );
	}
	
	//전산팀 계약삭제하기
	function rent_delete(){
		var fm = document.form1;
		fm.idx.value = 'delete';
		if(confirm('삭제하시겠습니까?')){					
		if(confirm('계약관련 모든 데이타를 삭제하게 됩니다. \n\n삭제하시겠습니까?')){				
			fm.action='lc_b_u_ac_a.jsp';		
			fm.target='d_content';
			fm.submit();
		}}
	}		

	//수정
	function update(idx){
		var fm = document.form1;
		
		fm.idx.value = idx;
		
		if(confirm('수정하시겠습니까?')){	
			fm.action='lc_b_u_ac_a.jsp';
			fm.target='d_content';
			fm.submit();
		}							
	}
	
	//중고차가격 계산하기-숨어서(중고차)
	function getSecondhandCarAmt_h(){
		var fm = document.form1;
		fm.action = "/acar/secondhand/getSecondhandBaseSet3.jsp";
		fm.target = "i_no";
		if(fm.user_id.value == '000029'){
			fm.target = "_blank";
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
<body>
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 		value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 		value="<%=user_id%>">
  <input type='hidden' name="br_id"   		value="<%=br_id%>">
  <input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="opt"					value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"				value="<%=cm_bean.getCar_b()%><%=cm_bean2.getCar_b()%>">
  <input type='hidden' name="s_st" 				value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="car_st" 			value="<%=base.getCar_st()%>">
  <input type='hidden' name="dpm" 				value="<%=cm_bean.getDpm()%>">
  <input type='hidden' name="car_end_dt"	value="<%=cr_bean.getCar_end_dt()%>">
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">
  <input type='hidden' name="o_1"					value="">
  <input type='hidden' name="ro_13"				value="">
  <input type='hidden' name="o_13"				value="">
  <input type='hidden' name="o_13_amt"		value="">
  <input type='hidden' name="esti_stat"		value="">
  <input type='hidden' name="t_dc_amt"		value="">
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">
  <input type='hidden' name="rent_dt"			value="<%=base.getRent_dt()%>">
  <input type='hidden' name="car_mng_id"	value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="client_id"		value="<%=base.getClient_id()%>">
  <input type='hidden' name="from_page"		value="<%=from_page%>">
  <input type='hidden' name="est_from"		value="lc_reg">
  <input type='hidden' name="firm_nm"			value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="car_id"			value="<%=car.getCar_id()%>">
  <input type='hidden' name="car_seq"			value="<%=car.getCar_seq()%>">
  <input type='hidden' name="idx"					value="">
     
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td colspan='2'>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>미결계약</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	    <td align='right'><a href='javascript:list()' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a></td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>계약번호</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>계약일자</td>
                    <td width=20%>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td class=title width=10%>상호</td>
                    <td>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
                <%String car_gu = base.getCar_gu();%>
                <%String car_st = base.getCar_st();%>
                <tr>
                    <td class=title>차량구분</td>
                    <td>&nbsp;<%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%><b>중고차</b><%}%></td>
                    <td class=title>용도구분</td>
                    <td colspan='3'>&nbsp;<b><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("5")){%>업무대여<%}%></b></td>
                </tr>  
                <tr> 
                    <td class=title>관리지점</td>
                    <td colspan='5'>&nbsp;<%if(cont_etc.getMng_br_id().equals("")) cont_etc.setMng_br_id(base.getBrch_id());%>
        	        <select name='mng_br_id'>
                            <option value=''>선택</option>
                            <%for (int i = 0 ; i < brch_size ; i++){
        			Hashtable branch = (Hashtable)branches.elementAt(i);%>
                            <option value='<%=branch.get("BR_ID")%>' <%if(cont_etc.getMng_br_id().equals(String.valueOf(branch.get("BR_ID")))){%> selected <%}%>><%= branch.get("BR_NM")%></option>
                            <%}%>
                        </select></td>
                </tr>                
            </table>
	    </td>
    </tr>
    <tr>
	<td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여차량</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class='line'> 			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
    		    <%if(!cr_bean.getCar_no().equals("")){%>
        	    <tr>
        		    <td width='13%' class='title'> 차량번호 </td>
        		    <td width="20%">&nbsp;<%=cr_bean.getCar_no()%> (<%=cr_bean.getCar_mng_id()%>)</td>
                <td class='title' width="10%">관리번호</td>
        		    <td width="20%">&nbsp;<%=cr_bean.getCar_doc_no()%>&nbsp;(<%String car_ext = cr_bean.getCar_ext();%><%=c_db.getNameByIdCode("0032", "", car_ext)%>)</td>
        		    <td width="10%" class='title'><%if(cr_bean.getCar_use().equals("1")){%>차령만료일<%}else{%>최초등록일<%}%></td>
        		    <td>&nbsp;<%if(cr_bean.getCar_use().equals("1")){%><font color=red><b><%=cr_bean.getCar_end_dt()%></b></font><%}else{%><%=cr_bean.getInit_reg_dt()%><%}%></td>
        	    </tr>		
    		    <tr>
        		    <td class='title'> 검사유효기간 </td>
        		    <td>&nbsp;<b><%=cr_bean.getMaint_st_dt()%>~<%=cr_bean.getMaint_end_dt()%></b></td>
                	<td class='title'>점검유효기간</td>
        		    <td colspan='3'>&nbsp;<b><%=cr_bean.getTest_st_dt()%>~<%=cr_bean.getTest_end_dt()%></b></td>
    		    </tr>			  					  
        		<%}%>	  
                <tr>
                    <td width='13%' class='title'>자동차회사</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%></td>
                    <td class='title' width="10%">차명</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
                    <td class='title' width='10%'>차종</td>
                    <td>&nbsp;<%=cm_bean.getCar_name()%></td>
                </tr>
                <tr>
                    <td class='title'>소분류 </td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0008", "", cm_bean.getS_st())%></td>
                    <td class='title'>차종코드</td>
                    <td>&nbsp;[<%=cm_bean.getJg_code()%>]<%=ej_bean.getCars()%></td>
                    <td class='title'>배기량</td>
                    <td>&nbsp;<%if(cr_bean.getCar_mng_id().equals("")){%><%=cm_bean.getDpm()%>cc<%}else{%><%=cr_bean.getDpm()%>cc<%}%></td>
                </tr>
                <tr>
                    <td class='title'>옵션</td>
                    <td colspan="5">&nbsp;
        			          <%=car.getOpt()%></td>
                </tr>
                <tr>
                    <td class='title'>색상</td>
                    <td colspan="5">&nbsp;                        
        			  <input type='text' name='color' size='45' maxlength='100' class='text' value='<%=car.getColo()%>'>
					  &nbsp;&nbsp;&nbsp;
					  (내장색상(시트): <input type='text' name="in_col" size='20' class='text' value='<%=car.getIn_col()%>'> )  
					  &nbsp;&nbsp;&nbsp;
					  (가니쉬: <input type='text' name="garnish_col" size='20' class='text' value='<%=car.getGarnish_col()%>'> )  
        			  </td>
                </tr>	
                <tr>
                	<td class="title">연비</td>
                	<td colspan="5">
                		&nbsp;<%=car.getConti_rat() %>
                	</td>
                </tr>
                <tr>
                	<td class="title">추정수리비</td>
                	<td>
                		&nbsp;<input type='text' name='accid_serv_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(car.getAccid_serv_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        		원
                	<td class="title">사고내용</td>
                	<td colspan='3'>
                		&nbsp;<input type='text' name="accid_serv_cont" size='50' class='text' value='<%=car.getAccid_serv_cont()%>'>
                	</td>
                </tr>  
                <tr>
                	<td class="title">색상잔가반영</td>
                	<td>
                		&nbsp;<input type='text' name="jg_col_st" size='5' class='text' value='<%=car.getJg_col_st()%>'>
                	</td>
                	<td class="title">사양잔가반영</td>
                	<td colspan='3'>
                		&nbsp;<input type='text' name="jg_opt_st" size='5' class='text' value='<%=car.getJg_opt_st()%>'>
                	</td>
                </tr>  
                <!--
                <tr>
                	<td class="title">TUIX/TUON트림여부</td>
                	<td>
                		&nbsp;<input type='text' name="jg_tuix_st" size='5' class='text' value='<%=car.getJg_tuix_st()%>'>
                	</td>
                	<td class="title">TUIX/TUON옵션여부</td>
                	<td colspan='3'>
                		&nbsp;<input type='text' name="jg_tuix_opt_st" size='5' class='text' value='<%=car.getJg_tuix_opt_st()%>'>
                	</td>
                </tr>
                -->
                <tr>
                    <td class='title'>차량인수지</td>
                    <td colspan="3">&nbsp;
                        <select name="udt_st">
                        <option value=''>선택</option>
        				    <option value="1" <%if(pur.getUdt_st().equals("1"))%> selected<%%>>서울본사</option>
        		        <option value="2" <%if(pur.getUdt_st().equals("2"))%> selected<%%>>부산지점</option>
                		<option value="3" <%if(pur.getUdt_st().equals("3"))%> selected<%%>>대전지점</option>				
        		        <option value="5" <%if(pur.getUdt_st().equals("5"))%> selected<%%>>대구지점</option>
                		<option value="6" <%if(pur.getUdt_st().equals("6"))%> selected<%%>>광주지점</option>				
                		<option value="4" <%if(pur.getUdt_st().equals("4"))%> selected<%%>>고객</option>
                      </select>
        			  </td>
                    <td class='title'>등록지역</td>
                    <td colspan="3">&nbsp;
                      <select name="car_ext">
                    <option value=''>선택</option>
                    	  <%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(car.getCar_ext().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                      </select></td>
                </tr>
                <tr>
                    <td class='title'>비고</td>
                    <td colspan="5">&nbsp;
                        <textarea rows='5' cols='90' name='remark'><%=car.getRemark()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량가격</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_car1 style="display:<%if(!base.getCar_gu().equals("0")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title'>과세구분</td>
                    <td colspan="3">&nbsp;
                      <select name="purc_gu">
                        <option value=''>선택</option>
                        <option value='1' <%if(car.getPurc_gu().equals("1")){%> selected <%}%>>과세</option>
                        <option value='0' <%if(car.getPurc_gu().equals("0")){%> selected <%}%>>면세</option>
                      </select></td>
                    <td class='title'>출처</td>
                    <td colspan="3">&nbsp;
        			  <%String car_origin = car.getCar_origin();%>
        			  <%if(car_origin.equals("")){
        			  		if(!cm_bean.getCar_comp_id().equals("")){
        						code_bean = c_db.getCodeBean("0001", cm_bean.getCar_comp_id(), "");
        					}
        					car_origin = code_bean.getApp_st();
        				}%>
        			<select name="car_origin">
                        <option value="">선택</option>
                        <option value="1" <%if(car_origin.equals("1")){%> selected <%}%>>국산</option>
                        <option value="2" <%if(car_origin.equals("2")){%> selected <%}%>>수입</option>
                      </select></td>
                </tr>
                <tr>
                    <td width="13%" rowspan="2" class='title'>구분 </td>
                    <td colspan="3" class='title'>소비자가격</td>
                    <td width="10%" rowspan="2" class='title'>구분</td>
                    <td colspan="3" class='title'>중고차구입가격</td>
                </tr>
                <tr>
                    <td width="13%" class='title'>공급가</td>
                    <td width="13%" class='title'>부가세</td>
                    <td width="13%" class='title'><span class="b"><a href="javascript:sum_car_c_amt()" onMouseOver="window.status=''; return true" title="소비자가 합계 계산하기">합계</a></span></td>
                    <td width="13%" class='title'>공급가</td>
                    <td width="12%" class='title'>부가세</td>
                    <td width="13%" class='title'><span class="b"><a href="javascript:sum_car_f_amt()" onMouseOver="window.status=''; return true" title="구입가 합계 계산하기">합계</a></span>&nbsp;<span class="b"><a href="javascript:sum_car_f_amt2()" onMouseOver="window.status=''; return true" title="구입가 계산하기">계산</a></span></td>
                </tr>
                <tr>
                    <td class='title'> 기본가격</td>
                    <td>&nbsp;
                      <input type='text' name='car_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='car_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td class=title>매매금액</td>
                    <td>&nbsp;
                      <input type='text' name='car_fs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='car_fv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fv_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                </tr>
                <tr>
                    <td height="12" class='title'>옵션</td>
                    <td>&nbsp;
                      <input type='text' name='opt_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>' maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='opt_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>' maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='opt_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='10' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                <td class=title>중개수수료</td>
                <td height="12">&nbsp;
                  <input type='text' name='commi_s_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCommi_s_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td height="12">&nbsp;
                  <input type='text' name='commi_v_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCommi_v_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td height="12">&nbsp;
                  <input type='text' name='commi_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCommi_s_amt()+car.getCommi_v_amt())%>' maxlength='7' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                </tr>
                <tr>
                    <td height="26" class='title'> 색상</td>
                    <td>&nbsp;
                      <input type='text' name='col_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='col_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='col_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='7' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                                <td class=title>보관료</td>
                <td height="12">&nbsp;
                  <input type='text' name='storage_s_amt' size='10' value='<%=AddUtil.parseDecimal(car.getStorage_s_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td height="12">&nbsp;
                  <input type='text' name='storage_v_amt' size='10' value='<%=AddUtil.parseDecimal(car.getStorage_v_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td height="12">&nbsp;
                  <input type='text' name='storage_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getStorage_s_amt()+car.getStorage_v_amt())%>' maxlength='7' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                </tr>           
                <tr>
                    <td align="center" class='title_p'>합계</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_cs_amt' size='10' value='' class='whitenum' readonly>
        			    원</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_cv_amt' size='10' value='' class='whitenum' readonly>
        				원</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_c_amt' size='10' value='' class='whitenum'  readonly>
        				원</td>
                    <td align='center' class='title_p'>합계</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_fs_amt' size='10' value='' class='whitenum' readonly>
        				원</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_fv_amt' size='10' value='' class='whitenum' readonly>
        				원</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_f_amt' size='10' value='' class='whitenum'  readonly>
        				원</td>
                </tr>
            </table>		
	    </td>
    </tr>			 
    <tr>
        <td class=h></td>
    </tr>    		      
    <tr id=tr_car0 style="display:''"> 
	<%	int sh_car_amt = 0;
		String sh_year= "";
		String sh_month = "";
		String sh_day = "";
		String sh_day_bas_dt = "";
		int sh_amt = 0;
		float sh_ja = 0;
		int sh_km = 0;
		int sh_tot_km = 0;
		String sh_km_bas_dt = "";
		String sh_init_reg_dt = "";
		
				sh_car_amt 		= fee_etc.getSh_car_amt();
				sh_year 		= fee_etc.getSh_year();
				sh_month 		= fee_etc.getSh_month();
				sh_day	 		= fee_etc.getSh_day();
				sh_amt			= fee_etc.getSh_amt();
				sh_ja			= fee_etc.getSh_ja();
				sh_km			= fee_etc.getSh_km();
				sh_tot_km		= fee_etc.getSh_tot_km();
				sh_km_bas_dt	= fee_etc.getSh_km_bas_dt();
				sh_init_reg_dt	= fee_etc.getSh_init_reg_dt();
				sh_day_bas_dt	= fee_etc.getSh_day_bas_dt();
				if(sh_tot_km==0) sh_tot_km = a_db.getSh_tot_km(base.getCar_mng_id(), fee_etc.getSh_km_bas_dt());
				
				if(sh_year.equals("")){
					sh_year 	= String.valueOf(carOld.get("YEAR"));
					sh_month 	= String.valueOf(carOld.get("MONTH"));
					sh_day	 	= String.valueOf(carOld.get("DAY"));
					
				}
	%>
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='13%' class='title'> 신차소비자가 </td>
                    <td width="20%">&nbsp;
        				  	<input type='text' name='sh_car_amt' value='<%=AddUtil.parseDecimal(sh_car_amt)%>'size='10' class='defaultnum' >
        				  원 
        				  <input type='hidden' name="view_car_amt" value=""></td>
                    <td class='title' width="10%">잔가율</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='sh_ja' value='<%= AddUtil.parseFloatCipher(sh_ja,2) %>'size='4' class='defaultnum' >
					  %</td>
                    <td class='title' width='10%'>재리스잔존가</td>
                  <td>&nbsp;
                    <input type='text' name='sh_amt' value='<%= AddUtil.parseDecimal(sh_amt) %>'size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>
					  원
					  </td>
                </tr>
                <tr>
                  <td class='title'>차령</td>
                  <td colspan="3">&nbsp;
                    <input type='text' name='sh_year' value='<%=sh_year%>'size='1' class='white' >
                    년
                    <input type='text' name='sh_month' value='<%=sh_month%>'size='2' class='white' >
                    개월
                    <input type='text' name='sh_day' value='<%=sh_day%>'size='2' class='white' >
                    일 (최초등록일
                    <input type='text' name='sh_init_reg_dt' size='11' value='<%=AddUtil.ChangeDate2(sh_init_reg_dt)%>' class='default' onBlur='javascript:this.value=ChangeDate(this.value);'>
                    ~계약일
                    <input type='text' name='sh_day_bas_dt' value='<%=AddUtil.ChangeDate2(sh_day_bas_dt)%>'size='11' class='white' >
                    )
				            </td>
                    <td class='title' width='10%'>경매장시세</td>
                    <td>&nbsp;
                      <input type='text' name='sh_est_amt' value='<%= AddUtil.parseDecimal(car.getSh_est_amt()) %>' size='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 
                    </td>
                </tr>
                <tr>				  
                  <td class='title'>적용주행거리</td>
                  <td colspan="5">&nbsp;
                    <input type='text' name='sh_km' size='6' value='<%= AddUtil.parseDecimal(sh_km) %>' class='defaultnum' >
					  km 
					  
                       &nbsp;&nbsp;&nbsp;&nbsp;
                        <a href="javascript:getSecondhandCarAmt_h();"><img src=/acar/images/center/button_in_conf.gif align=absmiddle border=0></a>
                        ( 중고차 최초등록일가 주행거리를 입력하고 확인을 클릭하면 당사 재리스잔존가 계산합니다. )					  
					 </td>
                </tr>

            </table>
	    </td>
    </tr>                        
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험사항</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="13%"  class=title>보험계약자</td>
                    <td width="20%">&nbsp;
                        <select name='insurant'>
                          <option value="1" <%if(cont_etc.getInsurant().equals("1")||cont_etc.getInsurant().equals("")){%> selected <%}%>>아마존카</option>
                      </select></td>
                    <td width="10%"  class=title>피보험자</td>
                    <td colspan='3'>&nbsp;<%if(cont_etc.getInsur_per().equals("")) cont_etc.setInsur_per("1");%>
                        <select name='insur_per' onChange='javascript:display_ip()'>
                          <option value="">선택</option>
                          <option value="1" <%if(cont_etc.getInsur_per().equals("1")||cont_etc.getInsur_per().equals("")){%> selected <%}%>>아마존카</option>
                          <!--  <option value="2" <%if(cont_etc.getInsur_per().equals("2")){%> selected <%}%>>고객</option>-->
                      </select></td>
                </tr>            
                <tr> 
                    <td width="13%" class=title>운전자범위</td>
                    <td width="20%" class=''>&nbsp;
        			<select name='driving_ext'>
                          <option value="">선택</option>
                          <option value="1" <%if(base.getDriving_ext().equals("1")){%> selected <%}%>>모든사람</option>
                          <option value="2" <%if(base.getDriving_ext().equals("2")){%> selected <%}%>>가족한정</option>
                          <option value="3" <%if(base.getDriving_ext().equals("3")){%> selected <%}%>>기타</option>
                      </select>
        			</td>
                    <td width="10%" class=title >운전자연령</td>
                    <td width="20%">&nbsp;
                        <select name='driving_age'>
                          <option value="">선택</option>
                          <option value="0" <%if(base.getDriving_age().equals("0")){%> selected <%}%>>26세이상</option>
                          <option value="3" <%if(base.getDriving_age().equals("3")){%> selected <%}%>>24세이상</option>
                          <option value="1" <%if(base.getDriving_age().equals("1")){%> selected <%}%>>21세이상</option>
                          <option value="2" <%if(base.getDriving_age().equals("2")){%> selected <%}%>>모든운전자</option>
					  <option value=''>=피보험자고객=</option>				
                      <option value='5' <%if(base.getDriving_age().equals("5")){%>selected<%}%>>30세이상</option>				
                      <option value='6' <%if(base.getDriving_age().equals("6")){%>selected<%}%>>35세이상</option>				
                      <option value='7' <%if(base.getDriving_age().equals("7")){%>selected<%}%>>43세이상</option>						
					  <option value='8' <%if(base.getDriving_age().equals("8")){%>selected<%}%>>48세이상</option>					  						  
					  <option value='9' <%if(base.getDriving_age().equals("9")){%>selected<%}%>>22세이상</option>					  						  
					  <option value='10' <%if(base.getDriving_age().equals("10")){%>selected<%}%>>22세이상</option>					  						  
					  <option value='11' <%if(base.getDriving_age().equals("11")){%>selected<%}%>>35세이하~49세이하</option>					  						  
                      </select>&nbsp;<a href="javascript:age_search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a></td>
                <td class=title >임직원운전한정특약</td>
                <td class=''>&nbsp;
                  <select name='com_emp_yn'>
                    <option value="">선택</option>
                    <option value="Y" <%if(cont_etc.getCom_emp_yn().equals("Y")){%> selected <%}%>>가입</option>
                    <option value="N" <%if(cont_etc.getCom_emp_yn().equals("N")){%> selected <%}%>>미가입</option>
                  </select>
                  
                  </td>                        
                </tr>
                <tr>
                    <td class=title>대인배상</td>
                    <td>&nbsp; 무한(대인배상Ⅰ,Ⅱ)</td>
                    <td class=title>대물배상</td>
                    <td class=''>&nbsp;
                        <select name='gcp_kd'>
                          <option value="">선택</option>
                          <option value="1" <% if(base.getGcp_kd().equals("1")) out.print("selected"); %>>5천만원</option>
                          <option value="2" <% if(base.getGcp_kd().equals("2")) out.print("selected"); %>>1억원</option>
						  <option value="4" <% if(base.getGcp_kd().equals("4")) out.print("selected"); %>>2억원</option>
						  <option value="8" <% if(base.getGcp_kd().equals("8")) out.print("selected"); %>>3억원</option>
                          <option value="3" <% if(base.getGcp_kd().equals("3")) out.print("selected"); %>>5억원</option>						  
                      </select></td>
                    <td width="10%" class=title >자기신체사고</td>
                    <td class=''>&nbsp;
                        <select name='bacdt_kd'>
                          <option value="">선택</option>
                          <option value="1" <% if(base.getBacdt_kd().equals("1")) out.print("selected"); %>>5천만원</option>
                          <option value="2" <% if(base.getBacdt_kd().equals("2")) out.print("selected"); %>>1억원</option>
                          <option value="9" <% if(base.getBacdt_kd().equals("9")) out.print("selected"); %>>미가입</option>
                      </select></td>
                </tr>
                <tr>
                    <td  class=title>무보험차상해</td>
                    <td>&nbsp;
                      <select name='canoisr_yn'>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getCanoisr_yn().equals("Y")){%> selected <%}%>>가입</option>
                        <option value="N" <%if(cont_etc.getCanoisr_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>            </td>
                    <td class=title>자기차량손해</td>
                    <td class=''>&nbsp;
                      <select name='cacdt_yn'>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getCacdt_yn().equals("Y")){%> selected <%}%>>가입</option>
                        <option value="N" <%if(cont_etc.getCacdt_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>              </td>
                    <td class=title >긴급출동</td>
                    <td class=''>&nbsp;
                      <select name='eme_yn'>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getEme_yn().equals("Y")){%> selected <%}%>>가입</option>
                        <option value="N" <%if(cont_etc.getEme_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select></td>
                </tr>
                <tr>
                    <td class='title'>비고</td>
                    <td colspan="5">&nbsp;
                        <textarea rows='3' cols='90' name='others'><%=base.getOthers()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>	

	

	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>중고차딜러</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_emp_bus style="display:''">
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>           
                <tr>
                    <td width="13%" class='title'>성명</td>
                    <td width="20%" >&nbsp;
                      <input type='text' name='emp_nm' size='5' class='whitetext' value='<%=emp1.getEmp_nm()%>' readonly>
        			  <input type='hidden' name='emp_id' value='<%=emp1.getEmp_id()%>'>
        		    </td>
                    <td width="10%" class='title'>상호/영업소명</td>
                    <td width="20%">&nbsp;
                      <%=c_db.getNameById(emp1.getCar_comp_id(),"CAR_COM")%>
                      <input type='text' name='car_off_nm' size='15' value='<%=emp1.getCar_off_nm()%>' class='whitetext' readonly>
					  <input type='hidden' name='car_off_id' value='<%=emp1.getCar_off_id()%>'>
					  </td>
                    <td width="10%" class='title'>연락처</td>
                    <td>&nbsp;
                      <input type='text' name='emp_m_tel' size='15' value='<%=emp1.getEmp_m_tel()%>' class='whitetext' readonly>
                      <input type='hidden' name='car_off_st' value=''>
                    </td>
                </tr>
              <tr>
                <td class='title'>계약일자</td>
                <td >&nbsp;
                  <input type='text' name='sh_base_dt' value='<%= AddUtil.ChangeDate2(emp1.getSh_base_dt())%>' class='text' size='11' maxlength='11' onBlur='javscript:this.value = ChangeDate(this.value);'>
    			</td>
                <td class='title'>중개수수료</td>
                <td colspan='3'>&nbsp;
                  <input type='text' name='commi' value='<%=AddUtil.parseDecimal(emp1.getCommi())%>' class='text' size='10' maxlength='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
              </tr>
              <tr>
                <td class='title'>세금계산서일자</td>
                <td >&nbsp;
                  <input type='text' name='file_gubun1' value='<%= AddUtil.ChangeDate2(emp1.getFile_gubun1())%>' class='text' size='11' maxlength='11' onBlur='javscript:this.value = ChangeDate(this.value);'>
                  (보관료)
    			</td>
                <td class='title'>보관료</td>
                <td colspan='3'>&nbsp;
                  <input type='text' name='dlv_con_commi' value='<%=AddUtil.parseDecimal(emp1.getDlv_con_commi())%>' class='text' size='10' maxlength='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
    			</td>
              </tr>              
                
                <tr>
                    <td class='title'>은행명</td>
                    <td >&nbsp;
                    	<input type='hidden' name="emp_bank" value="<%=emp1.getEmp_bank()%>">
        		      <select name='emp_bank_cd'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        											CodeBean bank = banks[i];
        											//신규인경우 미사용은행 제외
															if(bank.getUse_yn().equals("N"))	 continue;
												%>
                        <option value='<%= bank.getCode()%>' <%if(emp1.getEmp_bank().equals(bank.getNm())||emp1.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        										}%>
                      </select>
        			</td>
                    <td class='title'>계좌번호</td>
                    <td>&nbsp;
                      <input type='text' name="emp_acc_no" value='<%=emp1.getEmp_acc_no()%>' size="22" class='text'>
        			</td>
                    <td class='title'>예금주명</td>
                    <td>&nbsp;
                      <input type='text' name="emp_acc_nm" value='<%=emp1.getEmp_acc_nm()%>' size="20" class='text'>
        			</td>
                </tr>		  		  
            </table>
        </td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>중고차구입처</span></td>
	</tr>	
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_emp_dlv style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>성명</td>
                    <td width="20%" >&nbsp;
                      <input type='text' name='emp_nm' size='5' class='whitetext' value='<%=emp2.getEmp_nm()%>' readonly>
        			        <input type='hidden' name='emp_id' value='<%=emp2.getEmp_id()%>'>
                    </td>
                    <td width="10%" class='title'>영업소명</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='car_off_nm' size='15' value='<%=emp2.getCar_off_nm()%>' class='whitetext' readonly>
					            <input type='hidden' name='car_off_id' value='<%=emp2.getCar_off_id()%>'>
        			      </td>
                    <td width="10%" class='title'>연락처</td>
                    <td>&nbsp;
                      <input type='text' name='emp_m_tel' size='15' value='<%=emp2.getEmp_m_tel()%>' class='whitetext' readonly>
                      <input type='hidden' name='car_off_st' value=''>
                    </td>
                </tr>
              <tr>
                <td class='title'>매매일자</td>
                <td >&nbsp;
                  <input type='text' name='sh_base_dt' value='<%= AddUtil.ChangeDate2(emp2.getSh_base_dt())%>' class='text' size='11' maxlength='11' onBlur='javscript:this.value = ChangeDate(this.value);'>
    			</td>
                <td class='title'>매매금액</td>
                <td colspan="3">&nbsp;
                  <input type='text' name='commi' value='<%=AddUtil.parseDecimal(emp2.getCommi())%>' class='text' size='10' maxlength='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
    			</td>
              </tr>
              <tr>
                <td class='title'>전차량번호</td>
                <td >&nbsp;
                  <input type='text' name='est_car_no' value='<%=pur.getEst_car_no()%>' class='text' maxlength='15' size='15' onBlur='javascript:this.value=this.value.toUpperCase()'>
    		    </td>
                <td class='title'>차대번호</td>
                <td colspan="3">&nbsp;
                  <input type='text' name='car_num' value='<%=pur.getCar_num()%>' class='text' maxlength='20' size='20' onBlur='javascript:this.value=this.value.toUpperCase()'>
    			</td>
              </tr>
              <tr>				
                <td class='title'>계약금</td>
                <td>&nbsp;
				  <input type='text' name='con_amt' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCon_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>원	
    			</td>				
                <td class='title'>은행계좌</td>				
                <td colspan="3">&nbsp;
					<select name='con_bank'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        												CodeBean bank = banks[i];
        												%>
                        <option value='<%= bank.getNm()%>' <%if(pur.getCon_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        					}%>
                    </select>
				  	&nbsp;
					계좌번호 : 
        			<input type='text' name='con_acc_no' value='<%=pur.getCon_acc_no()%>' size='20' class='text'>
					&nbsp;
					예금주 : 
        			<input type='text' name='con_acc_nm' value='<%=pur.getCon_acc_nm()%>' size='20' class='text'>
    			</td>				
              </tr>		  		  
            </table>
        </td>
    </tr>
    <tr>
	    <td>&nbsp;</td>
    </tr>		
    <tr>
	      <td align='center'>	

            <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
            
            
	              <%	if(base.getReg_step().equals("4") || base.getReg_step().equals("0")){%>	
	                  <% if(user_id.equals("000000") || base.getBus_id().equals(ck_acar_id) || base.getBus_id2().equals(ck_acar_id) || base.getReg_id().equals(ck_acar_id) || nm_db.getWorkAuthUser("관리자모드",ck_acar_id)){%>
	                  &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:update(99);" title='전체 수정하기'><img src=/acar/images/center/button_all_modify.gif align=absmiddle border=0></a>
	                  <% }%>
	              <%	}%>
            
		
	              <%	if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>
	                  <%		if(base.getUse_yn().equals("")){%>
	                      &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:rent_delete();" title='계약 삭제하기'>[삭제]</a>
	                  <%		}%>
	              <%	}%>
			    
	          <%}%>
		
        </td>
    </tr>
    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    <tr>
	    <td>&nbsp;</td>
    </tr>		
    <tr>
        <td align='right'>
	        <%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || (base.getBus_id().equals(user_id) && base.getUse_yn().equals("") && base.getReg_step().equals("3")) || (base.getReg_id().equals(user_id) && base.getUse_yn().equals("") && base.getReg_step().equals("3"))){%>	  
	          <a href="lc_reg_step4_ac.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_4step.gif align=absmiddle border=0></a>&nbsp; 	 
          <%}%>
          <%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>            
            <a href="lc_c_frame.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_gy.gif align=absmiddle border=0></a>	  	   
          <%}%>
	</td>	
    </tr>	
    <%}%>		
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--
	var fm = document.form1;
	sum_car_c_amt();
	sum_car_f_amt();

	//바로가기
	var s_fm 	= parent.top_menu.document.form1;
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
