<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "13", "03");
	
	String st 	= request.getParameter("st")==null?"1":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"car_no":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	function EnterDown() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}
	
	//검색하기
	function Search(){
		var fm = document.form1;	
			
	//	if ( fm.gubun1[0].checked == true ||  fm.gubun1[1].checked == true ) {}
	//	else if(fm.gubun1[0].checked == false && fm.t_wd.value == '' ) { alert('검색어를 입력하십시오.'); return;}
			
	//	else if(fm.gubun1[1].checked == false && fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); return;}		
		
	//	fm.t_wd.value = replaceString("&","AND",fm.t_wd.value);
		fm.action = 'asset_s_sc.jsp';
	   fm.first.value = 'N';
		fm.target='c_foot';
		fm.submit();
	}
	
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function save(work_st, cnt)
	{
		
		var fm = document.form1;
		var SUBWIN="asset_reg.jsp?cnt="+cnt+ "&user_id="+fm.user_id.value+"&auth_rw="+fm.auth_rw.value;	
		window.open(SUBWIN, "asset_reg", "left=50, top=50, width=500, height=400, resizable=yes, scrollbars=yes, status=yes");
	}
	
		//전기 검색하기
	function Search_j(){
		var fm = document.form1;	

		fm.action = 'asset_s_sc_j.jsp';
		fm.target='c_foot';
		fm.submit();
	}
		
	//리스트 엑셀 전환
	function pop_excel(){
		var fm = document.form1;
		fm.target = "_blak";
		
		fm.action = "popup_asset_excel.jsp?st="+ fm.st.value;
		fm.submit();
	}	
//-->
</script>
</head>
<body leftmargin="15" >
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='work_st' value=''>
<input type='hidden' name='first'>
<table width="100%" border="0" cellpadding="0" cellspacing="0">

	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 자산관리 > <span class=style5>
						자산관리</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
  <tr> 
      <td width=12%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_g.gif" align=absmiddle>&nbsp; 
        <select name='st'>
          <option value='1'  <%if(st.equals("1")){%>selected<%}%>>리스</option>
		  <option value='2'  <%if(st.equals("2")){%>selected<%}%>>렌트 </option>
	 <!--    <option value='3'  <%if(st.equals("3")){%>selected<%}%>>렌트 II</option> -->
        </select>
      </td>
      
      <td width=7% align="right"><img src="/acar/images/center/arrow_ssjh.gif" align=absmiddle>&nbsp;</td>
      <td width=8%>
		&nbsp;<select name="gubun">
			<option value="car_no" 		<%if(gubun.equals("car_no"))%> 		selected<%%>>차량번호</option>
			<option value="get_date" 		<%if(gubun.equals("get_date"))%> 		selected<%%>>취득일자</option> 
			<option value="asset_code" 		<%if(gubun.equals("asset_code"))%> 		selected<%%>>자산코드</option> 
			<option value="car_y_form" 		<%if(gubun.equals("car_y_form"))%> 		selected<%%>>연식</option> 
		</select>
	 </td>
     <td width=8%><input type="text" name="gubun_nm" size="10" value="<%=gubun_nm%>" class=text onKeydown="javascript:EnterDown()"></td>
     <td width="10%"><a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>
     <% if ( user_id.equals("000063") ) { %><a href="javascript:Search_j()">전기</a> <% } %>
     </td>
     <td width="55%">&nbsp;</td>    
    </tr>
    <tr>
       <td colspan=6 align="right">&nbsp;
	<%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("자산관리",user_id) || user_id.equals("000048") || user_id.equals("000197") || user_id.equals("000096")){%>   
		    <a href="javascript:save('insert_assetma', '1')"><img src="/acar/images/center/button_reg_cdjs.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
		    <a href="javascript:save('check_assetmove', '5')"><img src="/acar/images/center/button_check_bgjs.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
		    <a href="javascript:save('insert_assetmove', '2')"><img src="/acar/images/center/button_reg_bgjs.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
			<a href="javascript:save('insert_assetmove2', '3')"><img src="/acar/images/center/button_reg_mgjs.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;	
			
	<% } %>	
	<%if(nm_db.getWorkAuthUser("전산팀",user_id)){%> 
			<a href="javascript:save('insert_assetmove_s', '7')"><img src="/acar/images/center/button_tsscr.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
			<a href="javascript:save('insert_assetmove_green', '8')">구매보조금</a>&nbsp;&nbsp;
			<a href="javascript:save('update_assetma', '6')"><img src="/acar/images/center/button_cjcl.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;  	            	
			<a href="javascript:save('insert_yassetdep', '4')"><img src="/acar/images/center/button_year_cr.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
		
	<% } %>	
	&nbsp;&nbsp;
	    <a href="javascript:pop_excel('<%=st%>');"><img src="/acar/images/center/button_excel.gif" align="absmiddle" border="0"></a>	
		 </td>
    </tr>
 </table> 
</form> 

</body>
</html>

