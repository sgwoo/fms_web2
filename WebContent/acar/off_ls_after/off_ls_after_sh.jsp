<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String dt = request.getParameter("dt")==null?"cont_dt":request.getParameter("dt");
	String migr_dt = request.getParameter("migr_dt")==null?"":request.getParameter("migr_dt");
	String migr_gu = request.getParameter("migr_gu")==null?"3":request.getParameter("migr_gu");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st");	
	String slt_car_com = request.getParameter("slt_car_com")==null?"":request.getParameter("slt_car_com");//car_comp_id추출
	String com_id = request.getParameter("com_id")==null?"":request.getParameter("com_id");
	String slt_car_nm = request.getParameter("slt_car_nm")==null?"":request.getParameter("slt_car_nm"); //car_cd와같음
	String code = request.getParameter("code")==null?"":request.getParameter("code");
	String car_cd = request.getParameter("car_cd")==null?code:request.getParameter("car_cd");

	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector branches = c_db.getBranchList(); //영업소 리스트 조회
	int brch_size = branches.size();
	
	//제조사 , 차종, 차명
	CodeBean[] companys = c_db.getCodeAll("0001"); /* 코드 구분:자동차회사 */
	int com_size = companys.length;
	int car_size = 0;
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
%>
<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="javascript">
<!--
function EnterDown(){
	var keyValue = event.keyCode;
	if (keyValue =='13') search();
}

function search(){
	var fm = document.form1;
	fm.car_cd.value = fm.slt_car_nm.options[fm.slt_car_nm.selectedIndex].value;	
	fm.target = "c_foot";
	fm.action = "off_ls_after_sc.jsp";
	fm.submit();
}
	//자동차회사 코드 넣고 차종 리스트 가져오기
	function change_car_com(){
		var fm = document.form1;
		var tot_str = fm.slt_car_com.options[fm.slt_car_com.selectedIndex].value;
		fm.com_id.value = tot_str.substring(0,4);
		//fm.car_cd.value = fm.slt_car_nm.options[fm.slt_car_nm.selectedIndex].value;
		drop_car_nm();		
		if(tot_str == ''){
			fm.slt_car_nm.options[0] = new Option('선택', '');
			return;
		}else{
			fm.target='i_no';
			fm.action='get_car_comp_id_nodisplay.jsp?com_id='+fm.com_id.value+'&car_cd='+fm.car_cd.value;
			fm.submit();
		}
	}
	function drop_car_nm(){
		var fm = document.form1;
		var car_len = fm.slt_car_nm.length;
		for(var i = 0 ; i < car_len ; i++){
			fm.slt_car_nm.options[car_len-(i+1)] = null;
		}
	}
	function add_car_nm(idx, val, str){
		document.form1.slt_car_nm[idx] = new Option(str, val);		
	}
	function list_excel_after(){
		fm = document.form1;
		if(fm.dt.value=='1'){
			if(fm.st_dt.value==''){
				alert('조회기간을 입력해 주세요');
				return;
			}
			if(fm.end_dt.value==''){
				alert('조회기간을 입력해 주세요');
				return;
			}
		}
		window.open("about:blank",'list_excel','scrollbars=yes,status=yes,resizable=yes,width=1200,height=800,left=50,top=50');
		fm.target = "list_excel";
		fm.action = "off_ls_after_excel.jsp";
		fm.submit();
	}		
		
	function opt_frame(){
	var fm = document.form1;
	
	fm.target = "d_content";
	fm.action = "off_ls_after_opt_frame.jsp?dt=migr_dt";
	fm.submit();
}
	
//-->
</script>
</head>
<body>
<form name='form1' method='post'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<!--제조사,차종,모델-->
<input type='hidden' name='com_id' value='<%= com_id %>'>
<input type='hidden' name="car_cd" value="<%= car_cd %>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=5>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>오프리스 > 매각사후관리 > <span class=style5>매각사후현황</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td width="17%" align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gshm.gif align=absmiddle>&nbsp;
            <select name='gubun'>
              <option value='all'>전체</option>
              <option value='car_no' <%if(gubun.equals("car_no")){%>selected<%}%>>차량번호</option>
              <option value='init_reg_dt' <%if(gubun.equals("init_reg_dt")){%>selected<%}%>>연식</option>
              <option value='sui_nm' <%if(gubun.equals("sui_nm")){%>selected<%}%>>명의이전자</option>
              <option value='ins_com_nm' <%if(gubun.equals("ins_com_nm")){%>selected<%}%>>보험사</option>
              <option value='migr_no' <%if(gubun.equals("migr_no")){%>selected<%}%>>명의이전번호</option>              
            </select></td>
        <td width="13%"><input type="text" name="gubun_nm" value="<%=gubun_nm%>" class="text" size="18" onKeydown="javasript:EnterDown()"></td>
        <td width="33%">&nbsp;
            <select name='dt'>
              <option value='cont_dt' selected >매매일</option>
        	  <option value='migr_dt'>명의이전일</option>
            </select>
            &nbsp;<select name='migr_gu'>
              <option value=''>전체</option>
              <option value='1' <%if(migr_gu.equals("1")){%>selected<%}%>>기간</option>
              <option value='2' <%if(migr_gu.equals("2")){%>selected<%}%>>당월</option>
              <option value='3' <%if(migr_gu.equals("3")){%>selected<%}%>>당해</option>
            </select>
            &nbsp; <input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
            ~ 
            <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>"></td>
        <td> &nbsp;<img src=../images/center/arrow_yod.gif align=absmiddle> 
            &nbsp;<select name='car_st'>
              <option value=''>전체</option>
              <option value='1' <%if(car_st.equals("1")){%>selected<%}%>>렌트</option>
              <option value='3' <%if(car_st.equals("3")){%>selected<%}%>>리스</option>
            </select></td>
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="3" align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_jjs.gif align=absmiddle>&nbsp;&nbsp;
            &nbsp;<select name='slt_car_com' onChange='javascript:change_car_com()'>
              <%	if(com_size > 0){ %>
              <option value=''>선택</option>
              <%		for ( int i = 0 ; i < com_size ; i++){
    												CodeBean company = companys[i];	%>
              <option value='<%= company.getCode()%><%=company.getNm_cd()%><%=company.getNm()%>' <% if(company.getCode().equals(com_id)){ %>selected<% } %>><%=company.getNm()%></option>
              <%		}
    										}else{	%>
              <option value=''>제조사없음</option>
              <%	}		%>
            </select> &nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_cj.gif align=absmiddle>
            <select name='slt_car_nm' >
              <option value='' selected>선택</option>
            </select> </td>
        <td width="22%">&nbsp;<img src=../images/center/arrow_yuscd.gif align=absmiddle>
            &nbsp;<select name='brch_id' onChange='javascript:search();'>
              <option value=''>전체</option>
              <%	if(brch_size > 0){
    							for (int i = 0 ; i < brch_size ; i++){
    								Hashtable branch = (Hashtable)branches.elementAt(i);%>
              <option value='<%= branch.get("BR_ID") %>'  <%if(brch_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
              <%= branch.get("BR_NM")%> </option>
              <%							}
    						}		%>
            </select>&nbsp;&nbsp;<a href="javascript:search()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a></td>
        <td align=right><a href="javascript:list_excel_after()"><img src=../images/center/button_bhex.gif align=absmiddle border=0></a>&nbsp;</td>
        <td align=right><a href="javascript:opt_frame()" ><img src=../images/center/button_moption.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
</table>
</form>
</body>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</html>
<script language="JavaScript">
	change_car_com();
</script>
