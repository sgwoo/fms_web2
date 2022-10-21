<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.car_office.*"%>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"6":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
//	int s_year = request.getParameter("s_year")==null?0:Util.parseDigit(request.getParameter("s_year"));
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"a.car_nm":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):AddUtil.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):AddUtil.parseInt(request.getParameter("s_month"));	
	int year =AddUtil.getDate2(1);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector branches = c_db.getBranchList(); //영업소 리스트 조회
	int brch_size = branches.size();
	
	//제조사리스트
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll();	
%>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;		
		if(fm.s_kd.value == '6'){
			fm.t_wd.value = ChangeDate3(fm.t_wd.value);
		}
		fm.action = 'rent_di_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
		
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
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
	//	fm.gubun1.value = "";
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
		theForm2.action="car_mst_nodisplay.jsp";
		theForm2.submit(); //car_mst_nodisplay.jsp
	}
//-->
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.t_wd.focus();">
<form action="../res_search/car_mst_nodisplay.jsp" name="form2" method="post">
<input type="hidden" name="sel" value="">
<input type="hidden" name="car_comp_id" value="">
<input type="hidden" name="code" value="">
<input type="hidden" name="auth_rw" value="">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<form name='form1' method='post' action='rent_di_sc.jsp' target='c_foot'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='mode' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=5>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 영업지원 > <span class=style5>운행일지</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
    <tr> 
        <td width='18%' align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jhgb.gif align=absmiddle>&nbsp; 
            <select name='gubun1' onChange="javascript:list_move()">
              <option value='1' <%if(gubun1.equals("1")){%>selected<%}%>>예약조회</option>
              <option value='2' <%if(gubun1.equals("2")){%>selected<%}%>>배차관리</option>
              <option value='3' <%if(gubun1.equals("3")){%>selected<%}%>>반차관리</option>
              <option value='4' <%if(gubun1.equals("4")){%>selected<%}%>>정산관리</option>
              <option value='5' <%if(gubun1.equals("5")){%>selected<%}%>>사후관리</option>
              <option value='6' <%if(gubun1.equals("6")){%>selected<%}%>>운행일지</option>
    <!--          <option value='7' <%if(gubun1.equals("7")){%>selected<%}%>>요금관리</option>-->
            </select>
        </td>
        <td id='td_input' align='left' style="display:''" width="17%"><img src=/acar/images/center/arrow_ssjh.gif  align=absmiddle>&nbsp;
            <select name='gubun2'>
              <option value='' <%if(gubun2.equals("")){%>selected<%}%>>전체</option>
              <option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>예비차량</option>
              <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>직원차량</option>
            </select>
        </td>
        <td id='td_input' align='left' style="display:''" width="17%"><img src=/acar/images/center/arrow_yuscd.gif align=absmiddle>&nbsp;
            <select name='brch_id' onChange='javascript:search();'>
              <option value=''>전체</option>
              <%if(brch_size > 0){
    				for (int i = 0 ; i < brch_size ; i++){
    					Hashtable branch = (Hashtable)branches.elementAt(i);%>
              <option value='<%= branch.get("BR_ID") %>'  <%if(brch_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
              <%= branch.get("BR_NM")%> </option>
              <%	}
    			}%>
            </select>
        </td>
        <td width=20%><img src=/acar/images/center/arrow_g.gif align=absmiddle>&nbsp; 
            <select name="s_year">
              <option value="" <%if(s_year == 0){%>selected<%}%>></option>
              <%for(int i=2003; i<=year; i++){%>
              <option value="<%=i%>" <%if(s_year == i){%>selected<%}%>><%=i%>년</option>
              <%}%>
            </select>
            &nbsp; 
            <select name="s_month">
              <option value="" <%if(s_month == 0){%>selected<%}%>></option>
              <%for(int i=1; i<=12; i++){%>
              <option value="<%=i%>" <%if(s_month == i){%>selected<%}%>><%=i%>월</option>
              <%}%>
            </select>
        </td>
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jjs.gif align=absmiddle>&nbsp;  
            <select name="car_comp_id" onChange="javascript:GetCarKind()">
              <option value="">전체</option>
              <%	for(int i=0; i<cc_r.length; i++){
    						        cc_bean = cc_r[i];%>
              <option value="<%=cc_bean.getCode()%>" <%if(car_comp_id.equals(cc_bean.getCode()))%>selected<%%>><%= cc_bean.getNm() %></option>
              <%	}	%>
            </select>
        </td>
        <td align='left' colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_cj.gif align=absmiddle>&nbsp; 
            <select name="code">
              <option value="">전체</option>
            </select>
        </td>
        <td id='td_input' align='left' style="display:''"><img src=/acar/images/center/arrow_bgr.gif align=absmiddle>&nbsp; 
            <select name="s_cc">
              <option value="" <%if(s_cc.equals(""))%>selected<%%>>전체</option>
              <option value="3" <%if(s_cc.equals("3"))%>selected<%%>>2000cc초과</option>
              <option value="2" <%if(s_cc.equals("2"))%>selected<%%>>2000cc이하</option>
              <option value="1" <%if(s_cc.equals("1"))%>selected<%%>>1500cc이하</option>
            </select>
        </td>
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td align='left' colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp; 
            <select name='s_kd'>
              <option value='' <%if(s_kd.equals("")){%>selected<%}%>>전체 </option>
              <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>차량번호</option>
            </select>
            <input type='text' name='t_wd' size='20' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        </td>
        <td id='td_input' align='left' style="display:''"><img src=/acar/images/center/arrow_jr.gif align=absmiddle>&nbsp;  
            <select name='sort_gubun' onChange='javascript:search()'>
              <option value='a.car_no' <%if(sort_gubun.equals("a.car_no")){%> selected <%}%>>차량번호</option>
              <option value='a.car_nm' <%if(sort_gubun.equals("a.car_nm")){%> selected <%}%>>차명</option>
              <option value='a.init_reg_dt' <%if(sort_gubun.equals("a.init_reg_dt")){%> selected <%}%>>최초등록일</option>
              <option value='a.dpm' <%if(sort_gubun.equals("a.dpm")){%> selected <%}%>>배기량</option>
            </select>
            <select name='asc' onChange='javascript:search()'>
              <option value="asc">오름차순</option>
              <option value="desc">내림차순</option>
            </select>
        </td>
        <td>&nbsp;<a href='javascript:search()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/images/search.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
    </tr>
</table>
</form>
</body>
</html>
