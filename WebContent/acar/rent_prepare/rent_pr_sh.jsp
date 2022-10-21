<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.car_office.*, acar.off_anc.*, acar.car_mst.*"%>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	int s_year = request.getParameter("s_year")==null?0:Util.parseDigit(request.getParameter("s_year"));
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"1":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String cjgubun = request.getParameter("cjgubun")==null?"all":request.getParameter("cjgubun");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector branches = c_db.getBranchList(); //영업소 리스트 조회
	int brch_size = branches.size();
	
	//제조사리스트
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll();	
	//차종
	AddCarMstDatabase a_cdb = AddCarMstDatabase.getInstance();
	Vector cars = a_cdb.getSearchCode(car_comp_id, code, "", "", "1", "");
	int car_size = cars.size();	
%>

<html>
<head>
<title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

var delay = 2000;
var submitted = false;

function submitCheck() {

  if(submitted == true) { return; }

  document.form1.srch.value = '검색중';
  document.form1.srch.disabled = true;
  
  setTimeout ('search()', delay);
  
  submitted = true;
}

function submitInit() {

	  document.form1.srch.value = '검색';
	  document.form1.srch.disabled = false;
	   
	  submitted = false;
	}


  //검색하기
	function search(){
		var fm = document.form1;		
		if(fm.s_kd.value == '2'){
			fm.t_wd.value = ChangeDate3(fm.t_wd.value);
		}		
	
	//	var link = document.getElementById("submitLink");
	   
	//	var originFunc = link.getAttribute("href");
	//	link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");			
		
		fm.action = 'rent_pr_sc.jsp';
		fm.first.value = 'N';
		fm.target='c_foot';
		fm.submit();
		
	//	link.getAttribute('href',originFunc);
	}
		
	function enter(){
		var keyValue = event.keyCode;
	//	if (keyValue =='13') search();
	}	
	
	//리스트 이동
	function list_move()
	{
		var fm = document.form1;
		var url = "";
		var idx = fm.gubun1.options[fm.gubun1.selectedIndex].value;
		if(idx == '1') 		url = "/acar/res_search/res_se_frame_s.jsp";
		else if(idx == '2') url = "/acar/res_stat/res_st_frame_s.jsp";
		else if(idx == '3') url = "/acar/rent_mng/rent_mn_frame_s.jsp";
		else if(idx == '4') url = "/acar/rent_settle/rent_se_frame_s.jsp";
		else if(idx == '5') url = "/acar/rent_end/rent_en_frame_s.jsp";
		else if(idx == '6') url = "/acar/rent_diary/rent_di_frame_s.jsp";		
		else if(idx == '7') url = "/acar/con_rent/res_fee_frame_s.jsp";
		fm.gubun1.value = "";
		fm.sort_gubun.value = "";		
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}					
-->
</script>
<script language="JavaScript">
<!--
	function SearchCarOff(){
		var theForm = document.form1;
		theForm.target = "c_foot";
		theForm.submit();
	}

	function GetCarKind(){
		var theForm1 = document.form1;
		var theForm2 = document.form2;
		te = theForm1.code;
		theForm2.sel.value = "form1.code";
		theForm2.car_comp_id.value = theForm1.car_comp_id.value;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		theForm2.target="i_no";
		theForm2.submit();
	}

	function SearchCarNm(){
		var theForm = document.form1;	
		theForm.target="c_foot";
		theForm.submit();
	}

	function init(){
		var theForm1 = document.form1;
		var theForm2 = document.form2;
		te = theForm1.code;
		theForm2.sel.value = "form1.code";
		theForm2.car_comp_id.value = '<%=car_comp_id%>';
		theForm2.code.value = '<%=code%>';		
		te.options[0].value = '';
		te.options[0].text = '조회중';
		theForm2.target="i_no";
		theForm2.action="/acar/res_search/car_mst_nodisplay.jsp";
		theForm2.submit(); //car_mst_nodisplay.jsp
	}
//-->
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.t_wd.focus();">
<form name='form1' method='post' action='rent_pr_sc.jsp' target='c_foot'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='first'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=4>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 자동차관리 > <span class=style5>보유차관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  	
    <tr> 
        <td width='33%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_ssjh.gif align=absmiddle>&nbsp;
            <select name='gubun2'>
              <option value=''   <%if(gubun2.equals("")){%>selected<%}%>>전체</option>
              <option value='21' <%if(gubun2.equals("21")){%>selected<%}%>>전체(월렌트/업무대여제외)</option>
              <option value='1'  <%if(gubun2.equals("1")){%>selected<%}%>>=예비차량=</option>
              <option value='11' <%if(gubun2.equals("11")){%>selected<%}%>>대기</option>
              <option value='12' <%if(gubun2.equals("12")){%>selected<%}%>>예약</option>		  
              <option value='13' <%if(gubun2.equals("13")){%>selected<%}%>>배차</option>
              <option value='14' <%if(gubun2.equals("14")){%>selected<%}%>>반차</option>
              <option value='15' <%if(gubun2.equals("15")){%>selected<%}%>>대여</option>		  
              <option value='2'  <%if(gubun2.equals("2")){%>selected<%}%>>=매각예정=</option>
              <option value='16' <%if(gubun2.equals("16")){%>selected<%}%>>=해지/도난/말소/수해/기타=</option>
    <!--      <option value='3'  <%if(gubun2.equals("3")){%>selected<%}%>>=보관차량=</option>-->
              <option value='4'  <%if(gubun2.equals("4")){%>selected<%}%>>=휴차(파천교)=</option>		  
              <option value='17' <%if(gubun2.equals("17")){%>selected<%}%>>=업무대여=</option>
              <option value='20' <%if(gubun2.equals("20")){%>selected<%}%>>=재리스결정=</option>
              <option value='18' <%if(gubun2.equals("18")){%>selected<%}%>>=월렌트(전체)=</option>
              <option value='19' <%if(gubun2.equals("19")){%>selected<%}%>>=월렌트(정비요+점검요+확인함제외)=</option>
              <option value='22' <%if(gubun2.equals("22")){%>selected<%}%>>=월렌트(정비요-점검요-확인함제외)=</option>
            </select>
        </td>
        <td id='td_input' style="display:''" width="16%"><img src=/acar/images/center/arrow_yuscd.gif align=absmiddle>&nbsp;
            <select name='brch_id' >
              <option value=''>전체</option>
              <option value='S1' <%if(brch_id.equals("S1")){%>selected<%}%>>본사+강남</option>
              <!--<option value='S2' <%if(brch_id.equals("S2")){%>selected<%}%>>중앙영업소</option>-->
              <option value='B1' <%if(brch_id.equals("B1")){%>selected<%}%>>부산+김해</option>
              <option value='D1' <%if(brch_id.equals("D1")){%>selected<%}%>>대전</option>		  
			  <option value='J1' <%if(brch_id.equals("J1")){%>selected<%}%>>광주</option>		  
			  <option value='G1' <%if(brch_id.equals("G1")){%>selected<%}%>>대구</option>		  
			  
              <%if(brch_size > 0){
    				for (int i = 0 ; i < brch_size ; i++){
    					Hashtable branch = (Hashtable)branches.elementAt(i);%>
    <!--          <option value='<%= branch.get("BR_ID") %>'  <%if(brch_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
              <%= branch.get("BR_NM")%> </option>
              <%	}
    			}%>-->
            </select>
        </td>
        <td id='td_input' style="display:''" colspan="2"><img src=/acar/images/center/arrow_jjs.gif align=absmiddle>&nbsp;&nbsp;&nbsp;&nbsp;
            <select name="car_comp_id" onChange="javascript:GetCarKind()">
              <option value="">전체</option>
              <%	for(int i=0; i<cc_r.length; i++){
    						        cc_bean = cc_r[i];%>
              <option value="<%=cc_bean.getCode()%>" <%if(car_comp_id.equals(cc_bean.getCode()))%>selected<%%>><%= cc_bean.getNm() %></option>
              <%	}	%>
            </select>&nbsp;&nbsp;&nbsp;&nbsp;
            <img src=/acar/images/center/arrow_cj.gif align=absmiddle>&nbsp;
            <select name="code">
              <option value="">전체</option>
    <%	if(!code.equals("")){%>
    <%		if(car_size > 0){%>
    <%			for(int i = 0 ; i < car_size ; i++){
    				Hashtable car = (Hashtable)cars.elementAt(i);%>
                    <option value="<%=car.get("CODE")%>" <% if(code.equals(String.valueOf(car.get("CODE")))) out.print("selected"); %>>[<%=car.get("CAR_CD")%>]<%=car.get("CAR_NM")%></option>			
    <%			}
    		}
    	}%>		  
            </select>
            &nbsp;&nbsp;<img src=/acar/images/center/arrow_cjgb.gif align=absmiddle>&nbsp;
              <select name='cjgubun'>
		              <option value='all' <%if(cjgubun.equals("all")){%> selected <%}%>>전체</option>
		              <option value='300' <%if(cjgubun.equals("300")){%> selected <%}%>>소형승용LPG</option>
		              <option value='301' <%if(cjgubun.equals("301")){%> selected <%}%>>중형승용LPG</option>		  
		              <option value='302' <%if(cjgubun.equals("302")){%> selected <%}%>>대형승용LPG</option>		  		  
					 			  <option value='100' <%if(cjgubun.equals("100")){%> selected <%}%>>경승용</option>	
					 		    <option value='112' <%if(cjgubun.equals("112")){%> selected <%}%>>소형승용</option>	
					 		    <option value='103' <%if(cjgubun.equals("103")){%> selected <%}%>>중형승용</option>	
					 	      <option value='104' <%if(cjgubun.equals("104")){%> selected <%}%>>대형승용</option>	
					 	      <option value='401' <%if(cjgubun.equals("401")){%> selected <%}%>>RV</option>	
					 	      <option value='701' <%if(cjgubun.equals("701")){%> selected <%}%>>승합</option>	
					 	      <option value='801' <%if(cjgubun.equals("801")){%> selected <%}%>>화물</option>	
							</select>
        </td>
    </tr>
    <tr> 
        <td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp; 
            <select name='s_kd'>
              <option value='' <%if(s_kd.equals("")){%>selected<%}%>>전체 </option>
              <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>차량번호</option>
              <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>최초등록일</option>		  
          <!--   <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>연료</option>		-->  		  
		<!--     <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>승차인원</option>		  -->		  
		<!-- 	  <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>담당자</option> -->
			  <option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>차량위치</option>
			  <option value='7' <%if(s_kd.equals("7")){%>selected<%}%>>차량상태</option>
            </select>
            <input type='text' name='t_wd' size='36' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        </td>
        <td width=28%><img src=/acar/images/center/arrow_jrjg.gif align=absmiddle> &nbsp; 
            <select name='sort_gubun' >
              <option value='1' <%if(sort_gubun.equals("1")){%> selected <%}%>>계약구분</option>
              <option value='2' <%if(sort_gubun.equals("2")){%> selected <%}%>>차량번호</option>
              <option value='3' <%if(sort_gubun.equals("3")){%> selected <%}%>>차명</option>
              <option value='4' <%if(sort_gubun.equals("4")){%> selected <%}%>>최초등록일</option>
              <option value='6' <%if(sort_gubun.equals("6")){%> selected <%}%>>보유등록일</option>
              <option value='5' <%if(sort_gubun.equals("5")){%> selected <%}%>>배기량</option>
            </select>
            <select name='asc' >
              <option value="asc" <%if(asc.equals("asc")){%> selected <%}%>>오름차순</option>
              <option value="desc" <%if(asc.equals("desc")){%> selected <%}%>>내림차순</option>
            </select>
        </td>
          <td>
       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" name="srch" value="검색" onclick="submitCheck();">  
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" name="init" value="버튼초기화" onclick="submitInit();">  
     <!--  <a id="submitLink" href="javascript:search()"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a>   -->    
        </td>
            
    </tr>
</table>
</form>
<form action="../res_search/car_mst_nodisplay.jsp" name="form2" method="post">
<input type="hidden" name="sel" value="">
<input type="hidden" name="car_comp_id" value="">
<input type="hidden" name="code" value="">
<input type="hidden" name="auth_rw" value="">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
