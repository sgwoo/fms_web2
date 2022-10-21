<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	
	//자동차회사 리스트
	CarCompBean cc_r [] = umd.getCarCompAll();
	
	//지역-시도 리스트
	Vector CodeList = FineDocDb.getZipSido();
	
	//지역-구군 리스트
	Vector CodeList2 = FineDocDb.getZipGugun(gubun1);
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	function EnterDown() {
		var keyValue = event.keyCode;
		if (keyValue =='13') SearchCarOff();
	}
	function SearchCarOff(){
		var fm = document.form1;
		if(fm.s_kd.value == '' && fm.t_wd.value != '') fm.s_kd.value = 'car_off_nm';
		fm.action = "car_office_sc.jsp";	
		fm.target = "c_foot";
		fm.submit();
	}
	
	//시/구/군 조회
	function cng_sido(){
		var fm = document.form1;
		fm.action = "../fine_gov/get_gugun.jsp";
		fm.target = "i_no";
		fm.submit();	
	}	
	
	//현황
	function SearchCarOffStat(){
		var fm = document.form1;
		fm.action = "car_office_stat_frame.jsp";	
		fm.target = "d_content";
		fm.submit();
	}
	
	//회사등록
	function CarCompAdd(){	
		var SUBWIN="./car_comp_i.jsp?auth_rw=<%=auth_rw%>";	
		window.open(SUBWIN, "CarCompList", "left=50, top=50, width=400, height=570, scrollbars=yes");
	}
	
	//영업소등록
	function office_reg(){
		var fm = document.form1;
		fm.action = "car_office_i.jsp";	
		fm.target = "d_content";
		fm.submit();			
		//parent.location.href = "./car_office_i.jsp?auth_rw=<%=auth_rw%>&user_id=<%= user_id %>&br_id=<%= br_id %>&gubun1=<%= gubun1 %>&gubun2=<%= gubun2 %>&gubun3=<%= gubun3 %>&gubun4=<%= gubun4 %>&s_kd=<%= s_kd %>&t_wd=<%= t_wd %>";
	}
//-->
</script>
</head>
<body>
<form action="./car_office_sc.jsp" name="form1" method="POST" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 영업사원관리 > <span class=style5>영업소관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>   
    <tr> 
         <td> 
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr> 
                    <td width=23%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jdchs.gif align=absmiddle>&nbsp;
                      <select name="gubun3">
                        <option value="">전체</option>
                        <%	for(int i=0; i<cc_r.length; i++){
                				cc_bean = cc_r[i];
                				if(cc_bean.getNm().equals("에이전트")) continue;%>
                        <option value="<%= cc_bean.getCode() %>" <% if(gubun3.equals(cc_bean.getCode())) out.print("selected"); %>><%= cc_bean.getNm() %></option>
                        <%	}%>
                      </select></td>
                    <td width=25%><img src=/acar/images/center/arrow_jy.gif align=absmiddle>&nbsp;
                      <select name="gubun1" onChange="javascript:cng_sido()">
                        <option value="">광역시/도</option>
                        <%	if(CodeList.size() > 0){
        						for(int i = 0 ; i < CodeList.size() ; i++){
        							Hashtable ht = (Hashtable)CodeList.elementAt(i);	%>
                        <option value='<%= ht.get("SIDO") %>' <%if(gubun1.equals((String)ht.get("SIDO"))){%>selected<%}%>><%= ht.get("SIDO") %></option>
                        <%		}
        					}%>
                      </select>&nbsp;&nbsp;<select name="gubun2">
                        <option value="">시/구/군</option>
                        <%	if(CodeList2.size() > 0){
        						for(int i = 0 ; i < CodeList2.size() ; i++){
        							Hashtable ht = (Hashtable)CodeList2.elementAt(i);	%>
                        <option value='<%= ht.get("GUGUN") %>' <%if(gubun2.equals((String)ht.get("GUGUN"))){%>selected<%}%>><%= ht.get("GUGUN") %></option>
                        <%		}
        					}%>
                      </select> </td>
                    <td><img src=/acar/images/center/arrow_g_jdcyus.gif align=absmiddle>&nbsp;
                      <input type="radio" name="gubun4" value="0" <% if(gubun4.equals("0")) out.print("checked"); %>>
                      전체 
                      <input type="radio" name="gubun4" value="1" <% if(gubun4.equals("1")) out.print("checked"); %>>
                      지점 
                      <input type="radio" name="gubun4" value="2" <% if(gubun4.equals("2")) out.print("checked"); %>>
                      대리점 </td>
                </tr>
                <tr> 
                    <td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp;&nbsp;&nbsp;
                      <select name="s_kd">
                        <option value="">전체</option>
                        <option value="car_off_nm" <% if(s_kd.equals("car_off_nm")) out.print("selected"); %>>영업소명</option>
                        <option value="owner_nm" <% if(s_kd.equals("owner_nm")) out.print("selected"); %>>관할지점명</option>
                      </select> 
					  <input type="text" name="t_wd" size="20" value="<%= t_wd %>" class=text onKeydown="javasript:EnterDown()"> 
                      <a href="javascript:SearchCarOff()" onMouseOver="window.status=''; return true" title='검색하기'><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>
                    <td align="right">
        			  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
        			  <a href="javascript:CarCompAdd()" onMouseOver="window.status=''; return true" title='회사등록'><img src="/acar/images/center/button_reg_hs.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
                      <a href="javascript:office_reg();" onMouseOver="window.status=''; return true" title='영업소등록'><img src="/acar/images/center/button_reg_yus.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
        			  <%}%>
                      <a href="javascript:SearchCarOffStat();" title='자동차영업소현황'><img src="/acar/images/center/button_yushh.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;
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
