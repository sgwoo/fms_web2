<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String s_au = request.getParameter("s_au")==null?"":request.getParameter("s_au");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"0":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");

	String gubun 		= request.getParameter("gubun")==null?"car_no":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	String chk1 = request.getParameter("chk1")==null?"2":request.getParameter("chk1");
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
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


	//검색하기
	function Search(){
		var fm = document.form1;	

		fm.action = 'asset_s5_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function ChangeDT(arg)
	{
		var theForm = document.form1;
		if(arg=="st_dt")
		{
		theForm.st_dt.value = ChangeDate(theForm.st_dt.value);
		}else if(arg=="end_dt"){
		theForm.end_dt.value = ChangeDate(theForm.end_dt.value);
		}
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
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 자산관리 > <span class=style5>
						자산매각현황</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td></td>
	</tr>    
    <tr>
        <td  >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_jh.gif" align=absmiddle>&nbsp; 
     		 <input type="radio" name="chk1" value="1" <%if(chk1.equals("1")){%> checked <%}%>>
		전월 
		<input type="radio" name="chk1" value="2" <%if(chk1.equals("2")){%> checked <%}%>>
		당월 
		<input type="radio" name="chk1" value="3" <%if(chk1.equals("3")){%> checked <%}%>>
		기간 &nbsp;
		<input type="text" name="st_dt" size="12" value="<%=st_dt%>" class="text" onBlur="javascript:ChangeDT('st_dt')">
		&nbsp;~&nbsp;
		<input type="text" name="end_dt" size="12" value="<%=end_dt%>" class="text" onBlur="javascript:ChangeDT('end_dt')" > 
		&nbsp;&nbsp;<a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>  
    
    </tr>
      
    <tr> 
        <td>
            <table width="100%" cellspacing=0 border="0" cellpadding="0">
                <tr>
                  <td width=15%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_yod.gif" >&nbsp;
                      <select name="s_kd" >
                        <option value=""  <%if(s_kd.equals("")){%> selected <%}%>>전체&nbsp;&nbsp;&nbsp;</option>
                        <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>리스&nbsp;&nbsp;&nbsp;</option>
                        <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>렌트&nbsp;&nbsp;&nbsp;</option>
                        <option value="3" <%if(s_kd.equals("3")){%> selected <%}%>>렌트-LPG</option>
                        <option value="4" <%if(s_kd.equals("4")){%> selected <%}%>>렌트-비LPG</option>
                      </select>
              	  </td>              	  
              	  <td width=20%><img src="/acar/images/center/arrow_gmj.gif" align=absmiddle>&nbsp; 
                      <select name="s_au" >
                        <option value=""  <%if(s_au.equals("")){%> selected <%}%>>전체&nbsp;&nbsp;&nbsp;</option>
                        <option value="000502" <%if(s_au.equals("000502")){%> selected <%}%>>시화-현대글로비스&nbsp;</option>
                        <option value="013011" <%if(s_au.equals("013011")){%> selected <%}%>>분당-현대글로비스&nbsp;</option>   
                        <option value="061796" <%if(s_au.equals("061796")){%> selected <%}%>>양산-현대글로비스&nbsp;</option>                      
				      <option value="020385" <%if(s_au.equals("020385")){%> selected <%}%>>에이제이셀카주식회사&nbsp;&nbsp;</option>
				      <option value="022846" <%if(s_au.equals("022846")){%> selected <%}%>>롯데렌탈&nbsp;&nbsp;</option>		      
				      <option value="048691" <%if(s_au.equals("048691")){%> selected <%}%>>에이치씨에이에스-오산경매장&nbsp;&nbsp;</option>
				        <option value="004242" <%if(s_au.equals("004242")){%> selected <%}%>>서울자동차경매앤오토일일사</option>		    
				        <option value="003226" <%if(s_au.equals("003226")){%> selected <%}%>>(주)서울오토&nbsp;&nbsp;&nbsp;</option>
				      <option value="011723" <%if(s_au.equals("011723")){%> selected <%}%>>(주)서울자동차경매&nbsp;&nbsp;</option>
				      <option value="013222" <%if(s_au.equals("013222")){%> selected <%}%>>동화엠파크&nbsp;&nbsp;</option>
		       			 <option value="A" <%if(s_au.equals("A")){%> selected <%}%>>경매장통합&nbsp;&nbsp;&nbsp;</option>
                        <option value="M" <%if(s_au.equals("M")){%> selected <%}%>>매입옵션&nbsp;&nbsp;&nbsp;</option>
                        <option value="S" <%if(s_au.equals("S")){%> selected <%}%>>수의매각&nbsp;&nbsp;&nbsp;</option>
                        <option value="P" <%if(s_au.equals("P")){%> selected <%}%>>폐차&nbsp;&nbsp;&nbsp;</option>
                      </select>
                     </td>                                                                             
                   <td width=*><img src="/acar/images/center/arrow_ssjh.gif" align=absmiddle>&nbsp;
		&nbsp;<select name="gubun">
			<option value="car_no" 		<%if(gubun.equals("car_no"))%> 		selected<%%>>차량번호</option>		
		</select>&nbsp;<input type="text" name="gubun_nm" size="12" value="<%=gubun_nm%>" class="text">
		&nbsp;&nbsp;&nbsp;		  		  		 
    	       <img src="/acar/images/center/arrow_ssjh.gif" align=absmiddle>&nbsp;
                      <select name='sort' onChange='javascript:Search()'>
                        <option value='0' <%if(sort.equals("0")){%> selected <%}%>>매각일</option>
                        <option value='1' <%if(sort.equals("1")){%> selected <%}%>>경매장</option>
                      </select>
                </td>
                           
             </tr>
            </table>
        </td>   
    </tr>
</table>
</form>
</body>
</html>
