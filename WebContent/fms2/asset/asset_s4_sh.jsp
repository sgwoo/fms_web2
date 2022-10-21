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
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");

	String chk1 = request.getParameter("chk1")==null?"2":request.getParameter("chk1");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(chk){
		var fm = document.form1;
		
		fm.action="asset_s4_sc.jsp?chk="+chk;
		fm.target="c_foot";		
		fm.submit();
	}
	
	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
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
<body>
<form  name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 자산관리 > <span class=style5>
						자산취득현황</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td></td>
	</tr>

    <tr>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_jh.gif" align=absmiddle>&nbsp; 
        <!--<input type="radio" name="chk1" value="1" <%if(chk1.equals("1")){%> checked <%}%>>
		당일 -->
		<input type="radio" name="chk1" value="1" <%if(chk1.equals("1")){%> checked <%}%>>
		전월 
		<input type="radio" name="chk1" value="2" <%if(chk1.equals("2")){%> checked <%}%>>
		당월 
		<input type="radio" name="chk1" value="3" <%if(chk1.equals("3")){%> checked <%}%>>
		기간 &nbsp;
		<input type="text" name="st_dt" size="12" value="<%=st_dt%>" class="text" onBlur="javascript:ChangeDT('st_dt')">
		&nbsp;~&nbsp;
		<input type="text" name="end_dt" size="12" value="<%=end_dt%>" class="text" onBlur="javascript:ChangeDT('end_dt')" > 
		&nbsp;&nbsp;

		<a href="javascript:Search('0');"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>
		<a href="javascript:Search('1');">차량대금</a>
		</td>
      <td align="right">&nbsp;</td>
    </tr>
   <!-- 
    <tr> 
      <td><font color="#0099CC"><img src="../../images/arrow2.gif" width="12" height="9">기간구분 :</font>
        <select name="gubun1" >
          <option value="1" <%if(gubun1.equals("1")){%> selected <%}%>>취득일&nbsp;</option>
        </select>	
		    <input type="text" name="st_dt" size="12" value="<%=st_dt%>" class="text">
		    &nbsp;~&nbsp;
		    <input type="text" name="end_dt" size="12" value="<%=end_dt%>" class="text">		  
      </td>
      <td></td>
      <td colspan="2">&nbsp;</td>
    </tr>
   --> 
    <tr> 
      <td width="70%"><table width="100%" cellspacing=0 border="0" cellpadding="0">
        <tr>
          <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_jg.gif" align=absmiddle>&nbsp;&nbsp; 
              <select name="s_kd" >
                <option value=""  <%if(s_kd.equals("")){%> selected <%}%>>전체&nbsp;&nbsp;&nbsp;</option>
                <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>리스&nbsp;&nbsp;&nbsp;</option>
                <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>렌트&nbsp;&nbsp;&nbsp;</option>
              </select>
      		<!--  <input type="text" name="t_wd" size="30" value="<%=t_wd%>" class="text" onKeyDown="javasript:enter()"> -->
      	  </td>
         </tr>
      </table></td>
     <td align="right">&nbsp;</td>
    <!--  <td width="10%" align="right"><input type="button" name="b_ms2" value="검색" onClick="javascript:Search();" class="btn">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td> -->
    </tr>
    
  </table>
</form>
</body>
</html>
