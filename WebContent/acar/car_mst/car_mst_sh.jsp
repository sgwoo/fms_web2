<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*, acar.car_mst.*, acar.user_mng.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	//목록보기 데이터 이력
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");
	String car_id 		= request.getParameter("car_id")	==null?"":request.getParameter("car_id");
	String view_dt 		= request.getParameter("view_dt")	==null?"":request.getParameter("view_dt");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String t_wd2 		= request.getParameter("t_wd2")		==null?"":request.getParameter("t_wd2");
	String t_wd3 		= request.getParameter("t_wd3")		==null?"":request.getParameter("t_wd3");
	String t_wd4 		= request.getParameter("t_wd4")		==null?"":request.getParameter("t_wd4");
	String t_wd5 		= request.getParameter("t_wd5")		==null?"":request.getParameter("t_wd5");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"":request.getParameter("asc");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	
	CarOfficeDatabase umd 	= CarOfficeDatabase.getInstance();
	AddCarMstDatabase a_cdb = AddCarMstDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	CarCompBean cc_r [] = umd.getCarCompAll();
	
	//차명
	Vector cars 	= a_cdb.getSearchCode(car_comp_id, code, car_id, view_dt, "1", "");
	int car_size 	= cars.size();	
	
	//차종
	Vector cars2 	= a_cdb.getSearchCode(car_comp_id, code, car_id, view_dt, "4", "");
	int car_size2 	= cars2.size();
	
	//기준일자
	Vector cars3 	= a_cdb.getSearchCode(car_comp_id, code, car_id, view_dt, "3", "");
	int car_size3 	= cars3.size();	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language="JavaScript">
<!--
	//검색
	function Search(){
		var fm = document.form1;
		if(fm.car_comp_id.value == ''){ alert('자동차회사를 선택하십시오'); return; }
//		if(fm.code.value == ''){ alert('차종코드를 선택하십시오'); return; }
		fm.target = "c_foot";
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}
	
	//등록
	function Reg(){
		var fm = document.form1;
		fm.s_car_id.value = fm.car_id.value;
		fm.target = "d_content";
		fm.action = "car_mst_i.jsp";		
		fm.submit();
	}

	//자동차회사 선택시 차종코드 출력하기
	function GetCarCode(){
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.code;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		fm2.sel.value = "form1.code";
		fm2.car_comp_id.value = fm.car_comp_id.options[fm.car_comp_id.selectedIndex].value;
		fm2.mode.value = '1';
		fm2.target="i_no";
		fm2.submit();
	}

	//기준일자 선택시 차종 출력하기
	function GetCarId(){
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.car_id;
		te.options[0].value = '';
		te.options[0].text = '조회중';		
		fm2.sel.value 		= "form1.car_id";
		fm2.car_comp_id.value 	= fm.car_comp_id.options[fm.car_comp_id.selectedIndex].value;
		fm2.code.value 		= fm.code.options[fm.code.selectedIndex].value;		
		fm2.view_dt.value 	= fm.view_dt.options[fm.view_dt.selectedIndex].value;
		fm2.sort_gubun.value 	= fm.sort_gubun.options[fm.sort_gubun.selectedIndex].value;
		fm2.asc.value 		= fm.asc.options[fm.asc.selectedIndex].value;
		fm2.gubun1.value 	= fm.gubun1.options[fm.gubun1.selectedIndex].value;
		fm2.mode.value = '4';
		fm2.target="i_no";
		fm2.submit();
	}

	//차종 선택시 기준월 출력하기
	function GetViewDt(){
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.view_dt;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		fm2.sel.value = "form1.view_dt";
		fm2.car_comp_id.value = fm.car_comp_id.options[fm.car_comp_id.selectedIndex].value;
		fm2.code.value = fm.code.options[fm.code.selectedIndex].value;		
		fm2.car_id.value = fm.car_id.options[fm.car_id.selectedIndex].value;
		fm2.mode.value = '3';
		fm2.target="i_no";
		fm2.submit();
	}
	
	//로딩시 자동차회사=현대의 차종코드 출력하기
	function init(){
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.code;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		fm2.sel.value = "form1.code";
		fm2.car_comp_id.value = '<%= car_comp_id %>';
		fm2.mode.value = '1';
		fm2.target="i_no";
		fm2.submit();
	}
	
	function CarCompAdd(){	//자동차회사
		var SUBWIN="/acar/car_office/car_comp_i.jsp?auth_rw="+document.form1.auth_rw.value;	
		window.open(SUBWIN, "CarCompList", "left=100, top=100, width=1050, height=700, scrollbars=yes");
	}

	function CarKindAdd(){	//차종
		var SUBWIN="./car_kind_i.jsp?auth_rw="+document.form1.auth_rw.value;	
		window.open(SUBWIN, "CarKindList", "left=100, top=100, width=800, height=700, scrollbars=yes, status=yes");
	}

	function CarNmAdd(){	//차명
		var SUBWIN="./car_nm_i.jsp?auth_rw="+document.form1.auth_rw.value;
		window.open(SUBWIN, "CarNmList", "left=100, top=100, width=380, height=400, scrollbars=no");
	}
		
	function DcReg(){	//제조사DC
		var SUBWIN="./car_dc_i.jsp?auth_rw="+document.form1.auth_rw.value;	
		window.open(SUBWIN, "CarDcList", "left=100, top=10, width=740, height=850, scrollbars=yes, status=yes, resizable=yes");
	}
	
	function KmReg(){	//제조사DC
		var SUBWIN="./car_km_i.jsp?auth_rw="+document.form1.auth_rw.value;	
		window.open(SUBWIN, "CarKmList", "left=100, top=10, width=740, height=850, scrollbars=no, status=yes, resizable=yes");
	}
	
	function OptReg(){	//옵션
		var SUBWIN="./car_opt_i.jsp?auth_rw="+document.form1.auth_rw.value;	
		window.open(SUBWIN, "CarOptList", "left=100, top=10, width=1250, height=850, scrollbars=no, status=yes, resizable=yes");
	}
	
	function ColReg(){	//색상
		var SUBWIN="./car_col_i.jsp?auth_rw="+document.form1.auth_rw.value+"&user_id="+document.form1.user_id.value;	
		window.open(SUBWIN, "CarColList", "left=100, top=10, width=940, height=850, scrollbars=no, status=yes, resizable=yes");
	}
	
	function Excel(){
		var fm = document.form1;
		if(fm.car_comp_id.value == ''){ alert('자동차회사를 선택하십시오'); return; }
		
		var SUBWIN="car_nm_excel.jsp?car_comp_id="+document.form1.car_comp_id.value+"&car_cd="+fm.code.value+"&view_dt="+fm.view_dt.value;		
		window.open(SUBWIN, "CarNmExcel", "left=0, top=0, width=1050, height=700, scrollbars=yes, status=yes, resizable=yes");
		
	}
	
	function Excel2(){
		var fm = document.form1;
		if(fm.car_comp_id.value == ''){ alert('자동차회사를 선택하십시오'); return; }
		if(fm.code.value == ''){ alert('차종코드를 선택하십시오'); return; }
		
		var SUBWIN="./car_nm_excel2.jsp?car_comp_id="+document.form1.car_comp_id.value+"&car_cd="+fm.code.value+"&view_dt="+fm.view_dt.value;	
		window.open(SUBWIN, "CarNmExcel", "left=0, top=0, width=1050, height=700, scrollbars=yes, status=yes, resizable=yes");		
	}	
	
	function CarNmYn(){
		var fm = document.form1;
		if(fm.car_comp_id.value == ''){ alert('자동차회사를 선택하십시오'); return; }
		if(fm.code.value == ''){ alert('차종코드를 선택하십시오'); return; }
		
		var SUBWIN="./car_nm_yn_list2.jsp?car_comp_id="+document.form1.car_comp_id.value+"&car_cd="+fm.code.value+"&view_dt="+fm.view_dt.value;	
		window.open(SUBWIN, "CarNmYn", "left=0, top=0, width=1200, height=800, scrollbars=yes, status=yes, resizable=yes");			
	}
//-->
</script>
</head>
<body>
<form action="./car_mst_null.jsp" name="form2" method="post">
  <input type="hidden" name="sel" value="">
  <input type="hidden" name="car_comp_id" value="">
  <input type="hidden" name="code" value="">
  <input type="hidden" name="car_id" value="">
  <input type="hidden" name="view_dt" value="">    
  <input type="hidden" name="t_wd" value="">      
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="mode" value="">  
  <input type="hidden" name="sort_gubun" value="<%= sort_gubun %>">
  <input type="hidden" name="asc" 	value="<%= asc %>">
  <input type="hidden" name="gubun1" 	value="<%= gubun1 %>">
  <input type="hidden" name="from_page" 	value="/acar/car_mst/car_mst_sh.jsp">
</form>
<form action="./car_mst_sc.jsp" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">    
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='s_car_id' value=''>
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
      <td>
    	<table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > <span class=style5>차종관리</span></span></td>
            <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
    <tr> 
      <td> 
        <table border=0 cellspacing=1>
          <tr> 
            <td>&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_jdchs.gif align=absmiddle></td>
            <td>&nbsp;
			  <select name="car_comp_id" id="car_comp_id" onChange="javascript:GetCarCode()">
                <%	for(int i=0; i<cc_r.length; i++){
						cc_bean = cc_r[i];
						if(!cc_bean.getCms_bk().equals("Y")) continue;
				%>
                <option value="<%= cc_bean.getCode() %>" <% if(cc_bean.getCode().equals(car_comp_id)) out.print("selected"); %>><%= cc_bean.getNm() %></option>
                <%	}	%>
              </select> 
			</td>
            <td>&nbsp;&nbsp;<img src=../images/center/arrow_cmcd.gif align=absmiddle></td>
            <td>&nbsp;
			  <select name="code" id="code" onChange="javascript:GetViewDt()"><!--onChange="javascript:GetCarId()"-->
                <option value="">전체</option>
				<%	if(!code.equals("")){%>
				<%		if(car_size > 0){%>
				<%			for(int i = 0 ; i < car_size ; i++){
								Hashtable car = (Hashtable)cars.elementAt(i);								
				%>
                <option value="<%=car.get("CODE")%>" <% if(code.equals(String.valueOf(car.get("CODE")))) out.print("selected"); %>>[<%=car.get("CAR_CD")%>]<%=car.get("CAR_NM")%></option>			
				<%			}
						}
					}%>	
					
              </select>
			</td>
            <td>&nbsp;&nbsp;<img src=../images/center/arrow_gjij.gif align=absmiddle>
              <select name="view_dt" id="view_dt" onChange="javascript:GetCarId()"><!--onChange="javascript:GetCarId()"-->
                <option value="">최근</option>
				<%	if(!view_dt.equals("")){%>
				<%		if(car_size3 > 0){%>
				<%			for(int i = 0 ; i < car_size3 ; i++){
								Hashtable car = (Hashtable)cars3.elementAt(i);%>
                <option value="<%=car.get("CAR_B_DT")%>" <% if(view_dt.equals(String.valueOf(car.get("CAR_B_DT")))) out.print("selected"); %>><%=AddUtil.ChangeDate2(String.valueOf(car.get("CAR_B_DT")))%></option>
				<%			}
						}
					}%>
					<option value="99999999">전체</option>														
              </select></td>
            <td>&nbsp;&nbsp;<img src=../images/center/arrow_syyb.gif align=absmiddle> 
        	  <select name="gubun1">
                <option value="A" <% if(gubun1.equals("A")) out.print("selected"); %>>전체</option>
        		<option value="Y" <% if(gubun1.equals("Y")) out.print("selected"); %>>사용</option>
        		<option value="N" <% if(gubun1.equals("N")) out.print("selected"); %>>미사용</option>
              </select>			
			</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
        <td>
      <table border=0 cellspacing=1>
        <tr>
          <td>&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_cj.gif align=absmiddle>&nbsp;
            <select name="car_id" id="car_id" onChange="javascript:Search()"><!-- onChange="javascript:GetViewDt()"-->
              <option value="">전체</option>
              <%if(!car_id.equals("")){%>
              <%	if(car_size2 > 0){%>
              <%		for(int i = 0 ; i < car_size2 ; i++){
            				Hashtable car = (Hashtable)cars2.elementAt(i);%>
              <option value="<%=car.get("CAR_ID")%>" <% if(car_id.equals(String.valueOf(car.get("CAR_ID")))) out.print("selected"); %>><%=car.get("CAR_NAME")%></option>			
              <%			}
            		}
            	}%>					  
            </select>
            &nbsp;&nbsp;<img src=../images/center/arrow_cm.gif align=absmiddle>&nbsp;
            <input type="text" name="t_wd" value='<%=t_wd%>'   size="7" class=text  onKeyDown="javascript:enter()">
            <input type="text" name="t_wd2" value='<%=t_wd2%>' size="7" class=text  onKeyDown="javascript:enter()">
            <input type="text" name="t_wd3" value='<%=t_wd3%>' size="7" class=text  onKeyDown="javascript:enter()">
            &nbsp;&nbsp;<img src=../images/center/arrow_ggy.gif align=absmiddle>&nbsp;
            <input type="text" name="t_wd4" value='<%=t_wd4%>' size="7" class=text  onKeyDown="javascript:enter()">
	    &nbsp;&nbsp;*차종코드&nbsp;
            <input type="text" name="t_wd5" value='<%=t_wd5%>' size="4" class=text  onKeyDown="javascript:enter()">
            &nbsp;&nbsp;<img src=/acar/images/center/arrow_jrjg.gif align=absmiddle>&nbsp;
                      <select name='sort_gubun'>
                        <option value='1' <%if(sort_gubun.equals("1")){%> selected <%}%>>차종</option>
                        <option value='2' <%if(sort_gubun.equals("2")){%> selected <%}%>>차종코드</option>
                        <option value='3' <%if(sort_gubun.equals("3")){%> selected <%}%>>기본가격</option>
                        <option value='4' <%if(sort_gubun.equals("4")){%> selected <%}%>>기준일자</option>
                        <option value='5' <%if(sort_gubun.equals("5")){%> selected <%}%>>배기량</option>
                        <option value='6' <%if(sort_gubun.equals("6")){%> selected <%}%>>연료</option>
                      </select>
                      <select name='asc'>
                        <option value='0' <%if(asc.equals("0")){%> selected <%}%>>오름차순</option>
                        <option value='1' <%if(asc.equals("1")){%> selected <%}%>>내림차순</option>
                      </select>
            &nbsp;&nbsp;
            <a href="javascript:Search()" onMouseOver="window.status=''; return true"><img src="../images/center/button_search.gif" border=0 align=absmiddle></a></td>
        </tr>
      </table>
      </td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
    <tr> 
      <td>
        <table border=0 cellspacing=0 width="100%">
          <tr> 
            <td align="right">
				<a href="javascript:CarCompAdd()" 	onMouseOver="window.status=''; return true" title='자동차회사관리'><img src=../images/center/button_jdchsgl.gif border=0 align=absmiddle></a>&nbsp; 
				<a href="javascript:CarKindAdd()" 	onMouseOver="window.status=''; return true" title='차명관리'><img src=../images/center/button_cmgl.gif border=0 align=absmiddle></a>&nbsp; 
				<a href="javascript:Reg()" 		onMouseOver="window.status=''; return true" title='차종등록'><img src=../images/center/button_cjdl.gif border=0 align=absmiddle></a>&nbsp; 			  
				<a href="javascript:OptReg()" 	onMouseOver="window.status=''; return true" title='옵션관리'><img src=../images/center/button_osgl.gif border=0 align=absmiddle></a>&nbsp;			  						
				<a href="javascript:ColReg()" 	onMouseOver="window.status=''; return true" title='색상관리'><img src=../images/center/button_ss.gif border=0 align=absmiddle></a>&nbsp;			  									  
				<a href="javascript:DcReg()" 		onMouseOver="window.status=''; return true" title='제조사DC관리'><img src=/acar/images/center/button_dc_jjs.gif border=0 align=absmiddle></a>&nbsp;	  									  
				<a href="javascript:KmReg()" 		onMouseOver="window.status=''; return true" title='연비관리'><img src=/acar/images/center/button_ybgl.gif border=0 align=absmiddle></a>&nbsp;
				<a href="javascript:Excel()" 		onMouseOver="window.status=''; return true" title='엑셀열기'><img src=../images/center/button_excel.gif border=0 align=absmiddle></a>&nbsp;
				<a href="javascript:CarNmYn()" 	onMouseOver="window.status=''; return true" title='사용여부정리'><img src=../images/center/button_usejl.gif border=0 align=absmiddle></a>&nbsp;
				
			  <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("차종관리자",user_id)){%>
			  <!-- 
			  &nbsp;&nbsp;|&nbsp;&nbsp;
			  <a href="javascript:Excel2()" 		onMouseOver="window.status=''; return true" title='엑셀열기'><img src=../images/center/button_excel.gif border=0 align=absmiddle></a>&nbsp;
			  <a href="/fms2/master/car_code_excel.jsp" target="_blank" title='엑셀등록'><img src=../images/center/button_reg_excel.gif border=0 align=absmiddle></a>
			   -->
			  <%}%>  
			  							  
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
<script language="JavaScript">
	<% if(!car_comp_id.equals("")){ %>
		GetCarCode(); 
	<% } %>

	<% if(!car_comp_id.equals("") && !code.equals("") && !view_dt.equals("")){ %> 
		GetViewDt(); 
		GetCarId(); 
	<% } %>
</script>