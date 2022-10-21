<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	  br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "07");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int sh_height = request.getParameter("sh_height")==null?0:AddUtil.parseInt(request.getParameter("sh_height"));//상단길이
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//영업소리스트
	Vector branches = c_db.getUserBranchs("rent"); 			//영업소 리스트
	int brch_size = branches.size();
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
	function search(){
		var fm = document.form1;
		fm.t_wd.value = replaceString("&","AND",fm.t_wd.value);
		fm.action = 'lc_b_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
//-->
</script>
</head>
<body onload="javascript:document.form1.t_wd.focus();">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='gubun1' value='<%=gubun1%>'>  
  <input type='hidden' name='from_page' value='<%=from_page%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>미결현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>조건검색</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
    	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>검색조건</td>
                    <td width=40%>&nbsp;
            			<select name='s_kd'>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>계약번호 </option>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>
                          <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>관리번호 </option>
                          <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>차대번호 </option>
                          <option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>계출번호 </option>
						  <option value='7' <%if(s_kd.equals("7")){%>selected<%}%>>영업지점 </option>
						  <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>최초영업자 </option>
						  <option value='9' <%if(s_kd.equals("9")){%>selected<%}%>>차종 </option>
						  
                        </select>
                        &nbsp;&nbsp;&nbsp;
            			<input type='text' name='t_wd' size='20' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>            		
        		    </td>
                  <td class=title width=10%>구분</td>
                  <td width=15%>&nbsp;
        			<select name='gubun3'>
                      <option value=''  <%if(gubun3.equals("")){ %>selected<%}%>>전체 </option>
                      <option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>일반식 </option>
                      <option value='2' <%if(gubun3.equals("2")){%>selected<%}%>>기본식 </option>
                      <option value='3' <%if(gubun3.equals("3")){%>selected<%}%>>신차 </option>
                      <option value='4' <%if(gubun3.equals("4")){%>selected<%}%>>재리스 </option>
                      <option value='5' <%if(gubun3.equals("5")){%>selected<%}%>>중고차 </option>
                      <option value='6' <%if(gubun3.equals("6")){%>selected<%}%>>연장 </option>
                      <option value='12' <%if(gubun3.equals("12")){%>selected<%}%>>신규 </option>
                      <option value='13' <%if(gubun3.equals("13")){%>selected<%}%>>증차 </option>                                                  
                      <option value='14' <%if(gubun3.equals("14")){%>selected<%}%>>대차 </option>
                      <option value='7' <%if(gubun3.equals("7")){%>selected<%}%>>계약승계 </option>
                      <option value='8' <%if(gubun3.equals("8")){%>selected<%}%>>차종변경 </option>
                      <option value='9' <%if(gubun3.equals("9")){%>selected<%}%>>에이젼트 </option>
                      <%if(ck_acar_id.equals("000029")){ %>
                      <option value='15' <%if(gubun3.equals("15")){%>selected<%}%>>1단계 </option>
                      <option value='16' <%if(gubun3.equals("16")){%>selected<%}%>>2단계 </option>
                      <option value='17' <%if(gubun3.equals("17")){%>selected<%}%>>3단계 </option>
                      <%} %>
                    </select>
        			</td>						
                    <td class=title width=10%>관리지점</td>
                    <td width=15%>&nbsp;
            		    <select name='gubun2'>
                          <option value=''>전체</option>
                          <%	if(brch_size > 0)	{
            						for (int i = 0 ; i < brch_size ; i++){
            							Hashtable branch = (Hashtable)branches.elementAt(i);%>
                          <option value='<%=branch.get("BR_ID")%>' <%if(gubun2.equals(String.valueOf(branch.get("BR_ID")))){%> selected <%}%>><%= branch.get("BR_NM")%></option>
                          <%		}
            					}%>
                        </select></td>		  		  
        
                </tr>
            </table>
        </td>
    </tr>
    <tr align="right">
        <td><a href="javascript:search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</body>
</html>

