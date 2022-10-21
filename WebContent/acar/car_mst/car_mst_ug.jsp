<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*, acar.car_mst.*, acar.short_fee_mng.*, acar.estimate_mng.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="sfm_db" scope="page" class="acar.short_fee_mng.ShortFeeMngDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String view_dt 		= request.getParameter("view_dt")	==null?"":request.getParameter("view_dt");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String t_wd2 		= request.getParameter("t_wd2")		==null?"":request.getParameter("t_wd2");
	String t_wd3 		= request.getParameter("t_wd3")		==null?"":request.getParameter("t_wd3");
	String t_wd4 		= request.getParameter("t_wd4")		==null?"":request.getParameter("t_wd4");
	String t_wd5 		= request.getParameter("t_wd5")		==null?"":request.getParameter("t_wd5");
	String gubun1 		= request.getParameter("gubun1")	==null?"1":request.getParameter("gubun1");
	String s_car_id 	= request.getParameter("s_car_id")	==null?"":request.getParameter("s_car_id");
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"":request.getParameter("asc");
	
	
	String car_id 		= request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq 		= request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String disabled = "disabled";
	String white = "white";
	String readonly = "readonly";
	if(cmd.equals("ug")){
		disabled = "";
		white = "";
		readonly = "";
	}
	
	//차명정보
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	cm_bean = a_cmb.getCarNmCase(car_id, car_seq);
	
	//자동차회사 리스트
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll();
	
	//차종리스트
	Vector cars = a_cmb.getSearchCode(cm_bean.getCar_comp_id(), cm_bean.getCode(), cm_bean.getCar_id(), cm_bean.getCar_b_dt(), "1", "");
	int car_size = cars.size();
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	CodeBean[] sections = c_db.getCodeAll2("0007", "Y"); /* 코드 구분:단기대여요금차종분류 */
	int section_size = sections.length;	
	CodeBean[] sgroups = c_db.getCodeAll2("0008", "Y"); /* 코드 구분:차량소분류 */
	int sgroup_size = sgroups.length;	
	
	Vector conts = sfm_db.getSectionList();
	int cont_size = conts.size();
		
	//기본사양 포함 차명
	String car_b_inc_name = a_cmb.getCar_b_inc_name(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	
	EstiDatabase edb = EstiDatabase.getInstance();
	
	//구)중고차잔가코드 20050913
	Vector shVarList = edb.getEstiShVarList();
	int shVarList_size = shVarList.size();
	
	//신)중고차잔가코드 20070316
	Vector jgVarList = edb.getEstiJgVarList();
	int jgVarList_size = jgVarList.size();
	
	//차종변수
	EstiJgVarBean ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>자동차회사</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//자동차회사 선택시 차종코드 출력하기
	function GetCarCode(){
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.code;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		fm2.sel.value = "form1.code";
		fm2.car_comp_id.value = fm.car_comp_id.value;
		fm2.mode.value = '1';
		fm2.target="i_no";
		fm2.submit();
	}
	
	//차종코드 선택시 차종 디스플레이
	function GetCarId(){
		var fm = document.form1;
		var car_nm = fm.code.options[fm.code.selectedIndex].text;
		var car_nm_split = car_nm.split("]");
		fm.car_nm.value = car_nm_split[1];
	}

	//수정하기
	function Reg(){
		var fm = document.form1;
		if(fm.car_nm.value == ''){ alert('차명를 확인하십시오'); return; }
		if(fm.car_name.value == ''){ alert('차종를 확인하십시오'); return; }
		if(fm.car_b.value == ''){ alert('기본사양을 확인하십시오'); return; }
		if(fm.car_b_p.value == ''){ alert('기본가격을 확인하십시오'); return; }
		if(fm.car_b_dt.value == ''){ alert('기준일자를 확인하십시오'); return; }	
		if(fm.jg_code.value == ''){ alert('차종코드를 확인하십시오'); 	return; }	
		<%if(!ej_bean.getJg_b().equals("5")&&!ej_bean.getJg_b().equals("6")){%>
		if(fm.dpm.value == '')		{ alert('배기량를 확인하십시오'); 	return; }
		if(fm.dpm.value == '0')		{ alert('배기량를 확인하십시오'); 	return; }
		<%}%>
		if(!max_length(fm.car_b.value, 4000)){ alert('기본사양이 영문4000자/한글2000자를 초과하였습니다.\n\n확인하십시오'); return; }
		if(!confirm('수정하시겠습니까?')){	return;	}
		
		var link = document.getElementById("submitLink");
		var originFunc = link.getAttribute("href");
		link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
		
		fm.action = 'car_mst_ug_a.jsp';			
		fm.target = "i_no";
		fm.submit();
		
		link.getAttribute('href',originFunc);
	}	
	
	//목록보기
	function go_list(){
		var fm = document.form1;
		fm.action = 'car_mst_frame.jsp';
		fm.target = 'd_content';
		fm.submit();
	}
	
	function open_car_b_inc(){
		var fm = document.form1;
		if(fm.code.value=="" || fm.car_comp_id.value==""){
			alert("자동차회사 및 차명코드를 먼저 선택하세요!!"); 
			return; 
		}
		window.open("car_b_inc.jsp?car_comp_id="+fm.car_comp_id.value+"&car_cd="+fm.code.value+"&car_b_dt="+fm.car_b_dt.value,"car_b_inc", "left=300, top=100, width=500, height=400, scrollbars=yes");
	}	
	
	//차종코드 선택시 셋팅
	function in_set(){
		var fm = document.form1;
		var jg_code = fm.jg_code.options[fm.jg_code.selectedIndex].value;
		var jg_code_split 	= jg_code.split("||");
		fm.r_jg_code.value 	= jg_code_split[0];
		fm.dpm.value 		= jg_code_split[1];
	}		
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:self.focus()">

<form action="./car_mst_null.jsp" name="form2" method="post">
  <input type="hidden" name="sel" value="">
  <input type="hidden" name="car_comp_id" value="">
  <input type="hidden" name="code" value="">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="mode" value="">  
</form>
<form action="./car_mst_ug_a.jsp" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">    
  <input type="hidden" name="view_dt" value="<%=view_dt%>">    
  <input type="hidden" name="t_wd" value="<%=t_wd%>">      
  <input type="hidden" name="t_wd2" value="<%= t_wd2 %>">  
  <input type="hidden" name="t_wd3" value="<%= t_wd3 %>">  
  <input type="hidden" name="t_wd4" value="<%= t_wd4 %>">
  <input type="hidden" name="t_wd5" value="<%= t_wd5 %>">
  <input type="hidden" name="gubun1" value="<%= gubun1 %>">  
  <input type="hidden" name="sort_gubun" value="<%= sort_gubun %>">
  <input type="hidden" name="asc" 	value="<%= asc %>">      
  <input type="hidden" name="s_car_id" value="<%=s_car_id%>">
  <input type="hidden" name="car_id" value="<%=car_id%>">
  <input type="hidden" name="car_seq" value="<%=car_seq%>">
  <input type="hidden" name="cmd" value="<%=cmd%>">
  <input type="hidden" name="car_b_inc_id" value="<%= cm_bean.getCar_b_inc_id() %>">  
  <input type="hidden" name="car_b_inc_seq" value="<%= cm_bean.getCar_b_inc_seq() %>">   
  <input type="hidden" name="r_jg_code" value="<%=cm_bean.getJg_code()%>"> 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td>            
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr>
    	            <td>
                	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                                <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > <span class=style5>차명관리 (업그레이드)</span></span></td>
                                <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                            </tr>
                        </table>
                	</td>
                </tr>
                <tr>
                    <td class=h></td>
                </tr>
                <tr> 
                    <td align="right"> 
        		  	<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        		    <a id="submitLink" href='javascript:Reg();'> 
        	        <img src=../images/center/button_reg.gif border=0></a>
        			<%	if(cmd.equals("u")){%>
        		    <a href='javascript:document.form1.reset();'> 
            	    <img src=../images/center/button_cancel.gif border=0></a>		
        			<%	}%>
        			<%}%>			
                      <a href="javascript:go_list();"><img src=../images/center/button_list.gif border=0></a></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" cellpadding="3" width=100%>
                <!-- 
                <tr> 
                    <td width="13%" class=title>자동차회사</td>
                    <td > <select name="car_comp_id" onChange="javascript:GetCarCode()" <%//=disabled%>>
                    <%for(int i=0; i<cc_r.length; i++){
						        cc_bean = cc_r[i];%>
                    <option value="<%= cc_bean.getCode() %>" <%if(cm_bean.getCar_comp_id().equals(cc_bean.getCode()))%>selected<%//%>><%= cc_bean.getNm() %></option>
                    <%	}	%>
                    </select></td>
                </tr>
                <tr> 
                    <td class=title>차명코드</td>
                    <td > <select name="code" onChange="javascript:GetCarId()" <%//=disabled%>>
                    <option value="">선택</option>
                    <%for(int i = 0 ; i < car_size ; i++){
    					Hashtable car = (Hashtable)cars.elementAt(i);%>
                    <option value="<%=car.get("CODE")%>" <%if(cm_bean.getCode().equals(String.valueOf(car.get("CODE"))))%>selected<%//%>>[<%=car.get("CAR_CD")%>]<%=car.get("CAR_NM")%></option>
                    <%	}	%>
                    </select> </td>
                </tr>
                 -->
                 <input type="hidden" name="car_comp_id" value="<%=cm_bean.getCar_comp_id()%>">
                 <input type="hidden" name="code" value="<%=cm_bean.getCode()%>">
                <tr> 
                    <td class=title>차명</td>
                    <td > <input type="text" name="car_nm" value="<%=cm_bean.getCar_nm()%>" size="30" class=<%=white%>text></td>
                </tr>
                <tr> 
                    <td class=title>차종</td>
                    <td > <input type="text" name="car_name" value="<%=cm_bean.getCar_name()%>" size="70" class=<%=white%>text></td>
                </tr>
                <tr> 
                    <td class=title>연식</td>
                    <td > 연식1 : <input type="text" name="car_y_form" value="<%=cm_bean.getCar_y_form()%>" size="4" class=<%=white%>text> 
                    연식2 : <input type="text" name="car_y_form2" value="<%=cm_bean.getCar_y_form2()%>" size="4" class=<%=white%>text>
                    연식3 : <input type="text" name="car_y_form3" value="<%=cm_bean.getCar_y_form3()%>" size="4" class=<%=white%>text>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	                    <select name="car_y_form_yn">
	                    	<option value="Y" <%if(cm_bean.getCar_y_form_yn().equals("Y")){%>selected<%}%>>신차 견적서 연형 표기</option>
	                    	<option value="N" <%if(cm_bean.getCar_y_form_yn().equals("N")){%>selected<%}%>>신차 견적서 연형 미표기</option>
	                    </select>
                    </td>
                </tr>                
                <tr> 
                    <td class=title>기본사양</td>
                    <td > 포함차종명 : 
                    <input type="text" name="car_b_inc_name" value="" size="85" class=text placeholder="기존 포함차종명은 [<%= car_b_inc_name %>]입니다. 업그레이드 반영분 다시 조회하세요."> 
                    <a href="javascript:open_car_b_inc();"><img src=../images/center/button_in_cho.gif border=0 align=absmiddle></a>
                    &nbsp; (기존 포함차종명 : <%= car_b_inc_name %>)
                    <br> 
                    <textarea name="car_b" cols="110" class="text" rows="10" <%=readonly%>><%=cm_bean.getCar_b()%></textarea></td>
                </tr>
                <tr> 
                    <td class=title>기본가격</td>
                    <td > <input type="text" name="car_b_p" value="<%=AddUtil.parseDecimal(cm_bean.getCar_b_p())%>" size="15" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>원
                    &nbsp;&nbsp;&nbsp;
	                     <select name="duty_free_opt" <%=disabled%>>
	                     	<option value="">선택</option>
	                     	<option value="0"<%if(cm_bean.getDuty_free_opt().equals("0")){ %>selected<%}%>>차량가격표 개소세 과세가 표기차량</option>
	                     	<option value="1"<%if(cm_bean.getDuty_free_opt().equals("1")){ %>selected<%}%>>차량가격표 개소세 면세가 표기차량</option>
	                     </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>배기량</td>
                    <td > <input type="text" name="dpm" value="<%=AddUtil.parseDecimal(cm_bean.getDpm())%>" size="4" class=<%=white%>num>
                      cc</td>
                </tr>							
                <tr>			  
                    <td class="title">변속기</td>
                    <td><input type="radio" name="auto_yn" value="Y" <% if(cm_bean.getAuto_yn().equals("Y")) out.print("checked"); %>>
                      A/T 
                      <input type="radio" name="auto_yn" value="N" <% if(cm_bean.getAuto_yn().equals("N")) out.print("checked"); %>>
                      M/T 		  
        			</td>		  

                </tr>

                <tr> 
                    <td class=title>차종코드</td>
                    <td><select name='jg_code'  <%=disabled%> onChange='javascript:in_set();'>
                      <option value="">=======선 택=======</option>
                      <%if(jgVarList_size > 0){
        					for(int i = 0 ; i < jgVarList_size ; i++){
        						Hashtable jgVar = (Hashtable)jgVarList.elementAt(i); %>
                      <option value='<%= jgVar.get("SH_CODE") %>||<%=jgVar.get("JG_C")%>' <%if(cm_bean.getJg_code().equals((String)jgVar.get("SH_CODE")))%>selected<%//%>> [<%= jgVar.get("SH_CODE") %>]<%= jgVar.get("CARS") %> </option>
                      <%	}
        				}%>
                    </select></td>
                </tr>

                <tr> 
                    <td class=title>기타</td>
                    <td > 
        			  <select name="air_ds_yn">
                        <option value="">선택</option>
                        <option value="Y" <%if(cm_bean.getAir_ds_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cm_bean.getAir_ds_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>
        				운전석에어백
        			  <select name="air_as_yn">
                        <option value="">선택</option>
                        <option value="Y" <%if(cm_bean.getAir_as_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cm_bean.getAir_as_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
                      
        				조수석에어백

                    </td>
                </tr>		  		  		  
                <tr> 
                    <td class=title>사용여부</td>
                    <td> <input name="use_yn" type="radio" value="Y" <%if(cm_bean.getCar_yn().equals("Y"))%>checked<%%>>
                      사용 
                      <input type="radio" name="use_yn" value="N" <%if(cm_bean.getCar_yn().equals("N"))%>checked<%%>>
                      미사용 </td>

                </tr>
                <tr> 
                    <td class=title>홈페이지사용여부</td>
                    <td > 
                    	<input type="radio" name="hp_yn" value="Y" <%if(cm_bean.getHp_yn().equals("Y"))%>checked<%%>>
                      사용 
                      <input type="radio" name="hp_yn" value="N" <%if(cm_bean.getHp_yn().equals("N"))%>checked<%%>>
                      미사용 </td>

                </tr>  
                <tr> 
                    <td class=title>TUIX/TUON 트림여부</td>
                    <td > <input type="radio" name="jg_tuix_st" value="N" <%if(cm_bean.getJg_tuix_st().equals("N"))%>checked<%%>>
                      미해당
                      <input type="radio" name="jg_tuix_st" value="Y" <%if(cm_bean.getJg_tuix_st().equals("Y"))%>checked<%%>>
                      해당 </td>
                </tr>                                          
                <tr>
                	<td class=title>차선이탈 제어형</td>
                	<td > <input type="radio" name="lkas_yn" value="N" <%if(cm_bean.getLkas_yn().equals("N"))%>checked<%%>>
                		미해당
                		<input type="radio" name="lkas_yn" value="Y" <%if(cm_bean.getLkas_yn().equals("Y"))%>checked<%%>>
                		해당</td>
                </tr>
                <tr>
                	<td class=title>차선이탈 경고형</td>
                	<td > <input type="radio" name="ldws_yn" value="N" <%if(cm_bean.getLdws_yn().equals("N"))%>checked<%%>>
                		미해당
                		<input type="radio" name="ldws_yn" value="Y" <%if(cm_bean.getLdws_yn().equals("Y"))%>checked<%%>>
                		해당</td>
                </tr>
                <tr>
                	<td class=title>긴급제동 제어형</td>
                	<td > <input type="radio" name="aeb_yn" value="N" <%if(cm_bean.getAeb_yn().equals("N"))%>checked<%%>>
                		미해당
                		<input type="radio" name="aeb_yn" value="Y" <%if(cm_bean.getAeb_yn().equals("Y"))%>checked<%%>>
                		해당</td>
                </tr>
                <tr>
                	<td class=title>긴급제동 경고형</td>
                	<td > <input type="radio" name="fcw_yn" value="N" <%if(cm_bean.getFcw_yn().equals("N"))%>checked<%%>>
                		미해당
                		<input type="radio" name="fcw_yn" value="Y" <%if(cm_bean.getFcw_yn().equals("Y"))%>checked<%%>>
                		해당</td>
                </tr>
                <tr> 
                    <td class=title>기준일자</td>
                    <td > <input type="text" name="car_b_dt" value="<%//=AddUtil.ChangeDate2(cm_bean.getCar_b_dt())%>" size="15" class=<%=white%>text onBlur='javscript:this.value = ChangeDate(this.value);'> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>비고</td>
                    <td > <textarea name="etc" cols="110" class="text" rows="2" <%=readonly%> maxlength="200"><%=cm_bean.getEtc()%></textarea> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>기타</td>		<!-- 기타 추가(2018.02.08) -->
                    <td > <textarea name="etc2" cols="110" class="text" rows="2" <%=readonly%> placeholder="(견적서 기타란에 보여지는 부분입니다)" maxlength="200"><%=cm_bean.getEtc2()%></textarea> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>생산여부</td>
                    <td > 
                    	<input type="radio" name="end_dt" value="Y" <%if(cm_bean.getEnd_dt().equals("Y"))%>checked<%%>>
                      생산
                      <input type="radio" name="end_dt" value="N" <%if(cm_bean.getEnd_dt().equals("N"))%>checked<%%>>
                      단종
                    </td>
                </tr>                
            </table>
        </td>
    </tr>
    <%if(ej_bean.getJg_w().equals("1")){%>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>수입차</span></td>
    </tr>        
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="3" width=100%>
                <tr> 
                    <td width="13%" class=title>적용면세차가</td>
                    <td> <input type="text" name="car_b_p2" value="<%=AddUtil.parseDecimal(cm_bean.getCar_b_p2())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원
                    </td>
                </tr>
                <tr>
                    <td class=title>세금계산서D/C</td>
                    <td>렌트
                        <input type="text" name="r_dc_amt" value="<%=AddUtil.parseDecimal(cm_bean.getR_dc_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원 / 리스 
                        <input type="text" name="l_dc_amt" value="<%=AddUtil.parseDecimal(cm_bean.getL_dc_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원
                    </td>
                </tr>
                <tr>
                    <td class=title>카드결제금액</td>
                    <td>렌트
                        <input type="text" name="r_card_amt" value="<%=AddUtil.parseDecimal(cm_bean.getR_card_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원 / 리스 
                        <input type="text" name="l_card_amt" value="<%=AddUtil.parseDecimal(cm_bean.getL_card_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원
                    </td>
                </tr>                        
                <tr>
                    <td class=title>Cash Back </td>
                    <td>렌트
                        <input type="text" name="r_cash_back" value="<%=AddUtil.parseDecimal(cm_bean.getR_cash_back())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원 / 리스
                        <input type="text" name="l_cash_back" value="<%=AddUtil.parseDecimal(cm_bean.getL_cash_back())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원
                    </td>
                </tr>    
                <tr>
                    <td class=title>탁송썬팅비용등</td>
                    <td>렌트
                        <input type="text" name="r_bank_amt" value="<%=AddUtil.parseDecimal(cm_bean.getR_bank_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원 / 리스
                        <input type="text" name="l_bank_amt" value="<%=AddUtil.parseDecimal(cm_bean.getL_bank_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원
                    </td>
                </tr>                                        
                            
            </table>
        </td>
        <td width="20" bgcolor="#FFFFFF">&nbsp;</td>
    </tr>                 
    <%}%>    

</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
