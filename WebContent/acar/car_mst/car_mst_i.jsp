<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*, acar.car_mst.*,  acar.estimate_mng.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="ce_bean" class="acar.common.CommonEtcBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	//목록보기 데이터 이력
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"0001":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");
	String car_id 		= request.getParameter("car_id")	==null?"":request.getParameter("car_id");
	String view_dt 		= request.getParameter("view_dt")	==null?"":request.getParameter("view_dt");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String t_wd2 		= request.getParameter("t_wd2")		==null?"":request.getParameter("t_wd2");
	String t_wd3 		= request.getParameter("t_wd3")		==null?"":request.getParameter("t_wd3");
	String t_wd4 		= request.getParameter("t_wd4")		==null?"":request.getParameter("t_wd4");
	String t_wd5 		= request.getParameter("t_wd5")		==null?"":request.getParameter("t_wd5");
	String gubun1 		= request.getParameter("gubun1")	==null?"1":request.getParameter("gubun1");
	String s_car_id 	= request.getParameter("s_car_id")	==null?"":request.getParameter("s_car_id");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"":request.getParameter("asc");
	
	
	//자동차회사 리스트
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll();
	
	//차종리스트
	CarMstDatabase cmb = CarMstDatabase.getInstance();
	CarMstBean cm_r [] = cmb.getCarKindAll(car_comp_id);
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	CodeBean[] sections = c_db.getCodeAll2("0007", "Y"); /* 코드 구분:단기대여요금차종분류 */
	int section_size = sections.length;	
	
	CodeBean[] sgroups = c_db.getCodeAll2("0008", "Y"); /* 코드 구분:차량소분류 */
	int sgroup_size = sgroups.length;		
		
	EstiDatabase edb = EstiDatabase.getInstance();
	
	//차종코드별변수 
	Vector jgVarList = edb.getEstiJgVarList();
	int jgVarList_size = jgVarList.size();
	
%>

<html>
<head>
<title>자동차회사</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
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
		var fm2 = document.form2;
		var car_nm = fm.code.options[fm.code.selectedIndex].text;
		var car_nm_split = car_nm.split("]");
		fm.car_nm.value = car_nm_split[1];
		
		fm2.car_comp_id.value = fm.car_comp_id.value;
		
		//차명에 따른 기본가격 옵션 가져오기
		te = fm.add_car_amt_opt;
		te.options[0].value = '';
		te.options[0].text = '옵션없음';
		fm2.sel.value = "form1.add_car_amt_opt";
		fm2.code.value = fm.code.options[fm.code.selectedIndex].value;
		fm2.mode.value = 'opt';
		fm2.target="i_no";
		//fm2.target="_blank";
		fm2.submit();
	}

	//등록하기
	function Reg(){
		var fm = document.form1;
		if(fm.car_comp_id.value == '')	{ alert('자동차회사를 선택하십시오'); 	return; }
		if(fm.code.value == '')		{ alert('차명코드를 선택하십시오'); 	return; }
		if(fm.car_nm.value == '')	{ alert('차명를 확인하십시오'); 	return; }
		if(fm.car_name.value == '')	{ alert('차종를 확인하십시오'); 	return; }
				
		if(fm.car_b.value == '')	{ alert('기본사양을 확인하십시오'); 	return; }		
		if(fm.car_b_p.value == '')	{ alert('기본가격을 확인하십시오'); 	return; }
		
		if(fm.jg_2.value == '1' && fm.duty_free_opt.value == ''){ alert('일반LPG차량입니다. 차량가격표 개소세 과세가/면세가 표기차량 구분을 선택하십시오'); 	return; }
		
		if(fm.car_b_dt.value == '')	{ alert('기준일자를 확인하십시오'); 	return; }
		if(fm.jg_code.value == '')	{ alert('차종코드를 확인하십시오'); 	return; }
				
		if(!confirm('등록하시겠습니까?')){	return;	}
		
		var link = document.getElementById("submitLink");
		var originFunc = link.getAttribute("href");
		link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
		
		fm.cmd.value = "i";
		//fm.target = "i_no";
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
		fm.jg_2.value 		= jg_code_split[2];
	}
	
	//기본차가 + 차가옵션
	function add_car_amt_total(){
		var fm = document.form1;
		var car_amt_init 	 = Number(fm.init_car_b_p.value.replace(/,/gi, ""));
		var car_amt_opt_init = fm.add_car_amt_opt.options[fm.add_car_amt_opt.selectedIndex].value;
		
		var car_amt_opt_arr  = car_amt_opt_init.split("///");
		var car_amt_opt_nm   = car_amt_opt_arr[0];
		var car_amt_opt_amt  = Number(car_amt_opt_arr[1]);
		//var car_amt_opt 	 = Number(fm.add_car_amt_opt.options[fm.add_car_amt_opt.selectedIndex].value);
		fm.car_b_p.value = parseDecimal(car_amt_init + car_amt_opt_amt);
		
		if($("#span1_hidden_yn").val()=="Y"){	//옵션추가 모드이면
			fm.add_opt_amt.value = car_amt_opt_amt;
			fm.add_opt_nm.value  = car_amt_opt_nm;
		}
	}
	
	//기본가격 옵션추가버튼 set
	function setDisplayAddOpt(){
		var span1_yn = $("#span1_hidden_yn").val();
		if(span1_yn=="N"){
			$("#hidden_span1").css("display","block");
			$("#span1_hidden_yn").val("Y");
		}else if(span1_yn=="Y"){
			$("#hidden_span1").css("display","none");
			$("#span1_hidden_yn").val("N");
		}
	}
	
	//기본가격 옵션 추가/삭제
	function addCarAmtOpt(){
		var fm = document.form1;
		if(fm.add_opt_nm.value==""){
			alert("추가할 옵션의 명칭(설명)을 입력해주세요.");
			return;
		}
		if(fm.add_opt_amt.value==""){
			alert("추가할 옵션의 가격을 입력해주세요.");
			return;
		}
		fm.cmd.value = "opt";
		fm.submit();
	}
	
	//차명코드에 따라 차량기본가격 옵션 세팅
	<%-- function setCarAmtOpt(car_cd){
	
		<%	//차량기본가격-옵션조회
		  CommonEtcBean addCarAmts [] = c_db.getCommonEtcAll("add_car_amt","car_code","89","","","","","","");
		  for(int i=0; i<addCarAmts.length; i++){
			  ce_bean = addCarAmts[i];
		%>	
		
	} --%>
	
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
  <input type="hidden" name="from_page" value="/acar/car_mst/car_mst_i.jsp">
</form>
<form action="./car_mst_i_a.jsp" name="form1" method="POST" >
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
  <input type="hidden" name="cmd" value="">
  <input type="hidden" name="car_b_inc_id" value="">  
  <input type="hidden" name="car_b_inc_seq" value=""> 
  <input type="hidden" name="r_jg_code" value=""> 
  <input type="hidden" name="jg_2" value="">
   
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td>            
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                	<td>
                	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                                <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > <span class=style5>차명관리 (등록)</span></span></td>
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
                      <a id="submitLink" href="javascript:Reg()"><img src=../images/center/button_reg.gif border=0></a>
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
            <table border="0" cellspacing="1" cellpadding="3" width="100%">
            	<colgroup>
            		<col width="12%">
            		<col width="30%">
            		<col width="58%">
            	</colgroup>
                <tr> 
                    <td class=title>자동차회사</td>
                    <td colspan="2"> <select name="car_comp_id" onChange="javascript:GetCarCode()">
                        <%for(int i=0; i<cc_r.length; i++){
   						        cc_bean = cc_r[i];
   						        if(!cc_bean.getCms_bk().equals("Y")) continue;
        				%>
                        <option value="<%= cc_bean.getCode() %>" <%if(car_comp_id.equals(cc_bean.getCode()))%>selected<%%>><%= cc_bean.getNm() %></option>
                        <%	}	%>
                      </select> </td>
                </tr>
                <tr> 
                    <td class=title>차명코드</td>
                    <td colspan="2"> <select name="code" onChange="javascript:GetCarId()">
                        <option value="">선택</option>
                        <%for(int i=0; i<cm_r.length; i++){
        						        cm_bean = cm_r[i];%>
                        <option value="<%=cm_bean.getCode()%>" <%if(code.equals(cm_bean.getCode()))%>selected<%%>>[<%=cm_bean.getCar_cd()%>]<%=cm_bean.getCar_nm()%></option>
                        <%	}	%>
                      </select> </td>
                </tr>
                <tr> 
                    <td class=title>차명</td>
                    <td colspan="2"> <input type="text" name="car_nm" size="30" class=text> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>차종</td>
                    <td colspan="2"> <input type="text" name="car_name" id="car_name" value="" size="70" class=text placeholder="&#39; &#34; &#60; &#62; 등의 특수문자는 입력이 불가능 합니다."> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>연식</td>
                    <td colspan="2"> 연식1 <input type="text" name="car_y_form" value="" size="4" class=text> 
                    연식2 <input type="text" name="car_y_form2" value="" size="4" class=text>
                    연식3 <input type="text" name="car_y_form3" value="" size="4" class=text>
	                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	                    <select name="car_y_form_yn">
	                    	<option value="Y" <%if(cm_bean.getCar_y_form_yn().equals("Y")){%>selected<%}%>>신차 견적서 연형 표기</option>
	                    	<option value="N" <%if(cm_bean.getCar_y_form_yn().equals("N")){%>selected<%}%>>신차 견적서 연형 미표기</option>
	                    </select>
                    </td>
                </tr>                
                <tr> 
                    <td class=title>기본사양</td>
                    <td colspan="2"> 포함차종명: 
                      <input type="text" name="car_b_inc_name" value="" size="40" class=text > 
                      <a href="javascript:open_car_b_inc();"><img src=../images/center/button_in_cho.gif border=0 align=absmiddle
                      		></a><br> <textarea name="car_b" id="car_b" cols="100" class="text" rows="10" placeholder="&#39; &#34; 등의 특수문자는 입력이 불가능 합니다."></textarea> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>기본가격</td>
                    <td width='40%'> 
                    	<input type="text" name="init_car_b_p" value="" size="15" class=num onBlur='javascript:add_car_amt_total(); this.value=parseDecimal(this.value);'>
                      원
                      	<select name="add_car_amt_opt" onchange="javascript:add_car_amt_total();">
                      		<option value="///0">옵션없음</option>
                      	</select>
                      	
                      	<select name="duty_free_opt">
                      		<option value="">선택</option>
                      		<option value="0">차량가격표 개소세 과세가 표기차량</option>
                      		<option value="1">차량가격표 개소세 면세가 표기차량</option>
                      	</select>
                      </td>
                      <td align="right">	
                      	<input type="button" class="button" value="옵션추가" onclick="javascript:setDisplayAddOpt();">
                      	<span id="hidden_span1" style="display: none;">
                      		옵션이름(설명) : <input type="text" name="add_opt_nm" >&nbsp;&nbsp;&nbsp;<br>
                      		<input type="button" class="button" value="추가/삭제" onclick="javascript:addCarAmtOpt();">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      		옵션가격 : <input type="text" name="add_opt_amt" > 원
                      		<input type="hidden" id="span1_hidden_yn" value="N">
                      	</span>
                      </td>
					<!--  
                    <td width="12%" class=title>배기량</td>
                    <td width="38%"> <input type="text" name="dpm" value="<%//=cm_bean.getCar_nm()%>" size="4" class=num>
                      cc </td>
					  -->
                </tr>
                <!-- 테스트 -->
                <tr>
                	<td class="title">기본차량가격(최종)</td>
                	<td colspan="2">
                		<input type="text" name="car_b_p" value="" size="15" class=num readonly="readonly"> 원 (기본가격 + 추가옵션가격)
                	</td>	
                </tr>
                <!-- 테스트 끝-->
                <tr> 
                    <td class=title>배기량</td>
                    <td colspan="2"> <input type="text" name="dpm" value="" size="4" class=num>
                      cc </td>
					<!--  
                    <td width="12%" class=title>배기량</td>
                    <td width="38%"> <input type="text" name="dpm" value="<%//=cm_bean.getCar_nm()%>" size="4" class=num>
                      cc </td>
					  -->
                </tr>				
                <tr> 
                    <td class="title">변속기</td>
                    <td colspan="2"><input type="radio" name="auto_yn" value="Y" >
                      A/T 
                      <input type="radio" name="auto_yn" value="N" >
                      M/T 		  
        			</td>		
					<!--  
                    <td class="title">연료</td>
                    <td><input type="radio" name="diesel_yn" value="1" >
                      휘발유 
                      <input type="radio" name="diesel_yn" value="Y" >
                      디젤 
                      <input type="radio" name="diesel_yn" value="2" >
                      LPG </td>
					  -->
                </tr>			
                <tr> 
                    <td class=title>차종코드</td>
                    <td colspan="2"><select name='jg_code' onChange='javascript:in_set();'>
                      <option value="">=======선 택=======</option>
                      <%if(jgVarList_size > 0){
        					for(int i = 0 ; i < jgVarList_size ; i++){
        						Hashtable jgVar = (Hashtable)jgVarList.elementAt(i);
        						//신차판매여부
        						if(String.valueOf(jgVar.get("JG_13")).equals("1")){
        			  %>
                      <option value='<%=jgVar.get("SH_CODE")%>||<%=jgVar.get("JG_C")%>||<%=jgVar.get("JG_2")%>' > [<%= jgVar.get("SH_CODE") %>]<%= jgVar.get("CARS") %> </option>
                      <%		}
                      		}
        				}%>
                    </select></td>
                </tr>				
                <tr> 
                    <td class=title>기타</td>
                    <td colspan="2"> 
                    
        			  <select name="air_ds_yn">
                        <option value="">선택</option>
                        <option value="Y" >유</option>
                        <option value="N" >무</option>
                      </select>
        				운전석에어백
        				
        			  <select name="air_as_yn">
                        <option value="">선택</option>
                        <option value="Y" >유</option>
                        <option value="N" >무</option>
                      </select>	
        				조수석에어백
                      <!--          				
        				&nbsp;
        			  <select name="air_cu_yn">
                        <option value="">선택</option>
                        <option value="Y" >유</option>
                        <option value="N" >무</option>
                      </select>	
        				커튼에어백<br>
        				
                      <select name="abs_yn">
                        <option value="">선택</option>
                        <option value="Y" >유</option>
                        <option value="N" >무</option>
                      </select>
        				ABS장치&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        				
                      <select name="rob_yn">
                        <option value="">선택</option>
                        <option value="Y" >유</option>
                        <option value="N" >무</option>
                      </select>
        				도난방지장치
        				&nbsp;
        				
                      <select name="sp_car_yn">
                        <option value="">선택</option>
                        <option value="Y">유</option>
                        <option value="N" selected>무</option>
                      </select>
                      스포츠카여부
                      -->
                    </td>
                </tr>		  
                <tr> 
                    <td class=title>사용여부</td>
                    <td colspan="2"> <input name="use_yn" type="radio" value="Y" checked>
                      사용 
                      <input type="radio" name="use_yn" value="N">
                      미사용 </td>
					  <!--
                    <td class=title>견적 적용여부</td>
                    <td><input name="est_yn" type="radio" value="Y" checked>
                      적용 
                      <input type="radio" name="est_yn" value="N">
                      미적용 </td>-->
                </tr>
                <tr> 
                    <td class=title>TUIX/TUON 트림여부</td>
                    <td colspan="2"> <input type="radio" name="jg_tuix_st" value="N" checked>
                      미해당
                      <input type="radio" name="jg_tuix_st" value="Y">
                      해당 </td>
                </tr>
                <tr>
                	<td class=title>차선이탈 제어형</td>
                	<td colspan="2"> <input type="radio" name="lkas_yn" value="N" checked>
                		미해당
                		<input type="radio" name="lkas_yn" value="Y">
                		해당</td>
                </tr>
                <tr>
                	<td class=title>차선이탈 경고형</td>
                	<td colspan="2"> <input type="radio" name="ldws_yn" value="N" checked>
                		미해당
                		<input type="radio" name="ldws_yn" value="Y">
                		해당</td>
                </tr>
                <tr>
                	<td class=title>긴급제동 제어형</td>
                	<td colspan="2"> <input type="radio" name="aeb_yn" value="N" checked>
                		미해당
                		<input type="radio" name="aeb_yn" value="Y">
                		해당</td>
                </tr>
                <tr>
                	<td class=title>긴급제동 경고형</td>
                	<td colspan="2"> <input type="radio" name="fcw_yn" value="N" checked>
                		미해당
                		<input type="radio" name="fcw_yn" value="Y">
                		해당</td>
                </tr>
				<!-- <tr>
                	<td class=title>견인고리(트레일러용)</td>
                	<td colspan="2"> <input type="radio" name="hook_yn" value="N" checked>
                		미해당
                		<input type="radio" name="hook_yn" value="Y">
                		해당</td>
                </tr> -->
                <tr> 
                    <td class=title>기준일자</td>
                    <td colspan="2"> <input type="text" name="car_b_dt" value="<%= AddUtil.getDate() %>" size="15" class=text onBlur='javscript:this.value = ChangeDate(this.value);'> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>비고</td>
                    <td colspan="2"> <textarea name="etc" cols="100" class="text" rows="2" maxlength="200"></textarea> 
                    </td>
                </tr>
                <tr> 	<!-- 기타 추가(2018.02.08) -->
                    <td class=title>기타</td>
                    <td colspan="2"> <textarea name="etc2" cols="100" class="text" rows="2" placeholder="(견적서 기타란에 보여지는 부분입니다)" maxlength="200"></textarea> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
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
                    <td> <input type="text" name="car_b_p2" value="<%//=AddUtil.parseDecimal(cm_bean.getCar_b_p2())%>" size="10" class=<%//=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원
                    </td>
                </tr>
                <tr>
                    <td class=title>세금계산서D/C</td>
                    <td>렌트
                        <input type="text" name="r_dc_amt" value="<%//=AddUtil.parseDecimal(cm_bean.getR_dc_amt())%>" size="10" class=<%//=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원 / 리스 
                        <input type="text" name="l_dc_amt" value="<%//=AddUtil.parseDecimal(cm_bean.getL_dc_amt())%>" size="10" class=<%//=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원
                    </td>
                </tr>
                <tr>
                    <td class=title>카드결제금액</td>
                    <td>렌트
                        <input type="text" name="r_card_amt" value="<%//=AddUtil.parseDecimal(cm_bean.getR_card_amt())%>" size="10" class=<%//=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원 / 리스 
                        <input type="text" name="l_card_amt" value="<%//=AddUtil.parseDecimal(cm_bean.getL_card_amt())%>" size="10" class=<%//=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원
                    </td>
                </tr>                
                <tr>
                    <td class=title>Cash Back </td>
                    <td>렌트
                        <input type="text" name="r_cash_back" value="<%//=AddUtil.parseDecimal(cm_bean.getR_cash_back())%>" size="10" class=<%//=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원 / 리스
                        <input type="text" name="l_cash_back" value="<%//=AddUtil.parseDecimal(cm_bean.getL_cash_back())%>" size="10" class=<%//=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원
                    </td>
                </tr>                
                <tr>
                    <td class=title>탁송썬팅비용등</td>
                    <td>렌트
                        <input type="text" name="r_bank_amt" value="<%//=AddUtil.parseDecimal(cm_bean.getR_bank_amt())%>" size="10" class=<%//=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원 / 리스
                        <input type="text" name="l_bank_amt" value="<%//=AddUtil.parseDecimal(cm_bean.getL_bank_amt())%>" size="10" class=<%//=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원
                    </td>
                </tr>                
            </table>
        </td>
        <td width="20" bgcolor="#FFFFFF">&nbsp;</td>
    </tr>                  
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script language="JavaScript">
<!--
	<%if(!code.equals("")){%>
		GetCarId();
	<%}%>
	
	// 차종, 기본사양에 특수문자 입력 방지
	var regex1 = /[\'\"<>]/gi;
	var regex2 = /[\'\"]/gi;
	var car_name;
	var car_b;
	
	// 차종 ' " < > 제한
	$("#car_name").bind("keyup",function(){
		car_name = $("#car_name").val();
		if(regex1.test(car_name)){
			$("#car_name").val(car_name.replace(regex1,""));
		}
	});
	
	// 기본사양 ' " 제한
	$("#car_b").bind("keyup",function(){
		car_b = $("#car_b").val();
		if(regex2.test(car_b)){
			$("#car_b").val(car_b.replace(regex2,""));
		}
	});
	
	
//-->
</script>
</body>
</html>