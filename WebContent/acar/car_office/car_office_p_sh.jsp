<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("auth_rw")==null?"S1":request.getParameter("auth_rw");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gu_nm = request.getParameter("gu_nm")==null?"":request.getParameter("gu_nm");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String cng_rsn = request.getParameter("cng_rsn")==null?"":request.getParameter("cng_rsn");		

	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");

	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
		
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	

	CarCompBean cc_r [] = umd.getCarCompAll();
	
	Vector CodeList = FineDocDb.getZipSido();
	
	Vector CodeList2 = FineDocDb.getZipGugun(gubun1);

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function SearchCarOffP(){
		var theForm = document.form1;		
		theForm.action = "car_office_p_sc.jsp";
		theForm.target = "c_foot";	
		theForm.submit();
	}

	//시/구/군 조회
	function cng_sido(){
		var fm = document.form1;
		fm.action = "../fine_gov/get_gugun.jsp";
		fm.target = "i_no";
		fm.submit();	
	}
	
	//신규등록
	function car_emp_reg(){
		var theForm = document.form1;
		theForm.target = "d_content";
		theForm.action = "./car_office_p_i.jsp";
		theForm.submit();	
	}	
//-->
</script>
</head>

<body>
<form action="./car_office_p_sc.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 영업사원관리 > <span class=style5>영업사원관리</span></span></td>
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
            <table width="100%" border=0 cellpadding="0" cellspacing=0>
                <tr>
                    <td width=23%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_sss.gif align=absmiddle>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <select name="gubun3">
                        <option value="">전체
                        <%
            for(int i=0; i<cc_r.length; i++){
                cc_bean = cc_r[i];
                if(cc_bean.getNm().equals("에이전트")) continue;
        %>
                        <option value="<%= cc_bean.getCode() %>" <% if(gubun3.equals(cc_bean.getCode())) out.print("selected"); %>><%= cc_bean.getNm() %></option>
                        <%}%>
                    </select></td>
                    <td width=25%><img src=/acar/images/center/arrow_gmjy.gif align=absmiddle>&nbsp;
                      <select name="gubun1" onChange="javascript:cng_sido()">
                        <option value="">광역시/도</option>
                        <%	if(CodeList.size() > 0){
        					for(int i = 0 ; i < CodeList.size() ; i++){
        						Hashtable ht = (Hashtable)CodeList.elementAt(i);	%>
                        <option value='<%= ht.get("SIDO") %>' <%if(gubun1.equals((String)ht.get("SIDO"))){%>selected<%}%>><%= ht.get("SIDO") %></option>
                        <%		}
        				}%>        				
                      </select>
                &nbsp;
                  <select name="gubun2">
                    <option value="">시/구/군</option>
                    <%	if(CodeList2.size() > 0){
            		for(int i = 0 ; i < CodeList2.size() ; i++){
            			Hashtable ht = (Hashtable)CodeList2.elementAt(i);	%>
                    <option value='<%= ht.get("GUGUN") %>' <%if(gubun2.equals((String)ht.get("GUGUN"))){%>selected<%}%>><%= ht.get("GUGUN") %></option>
                    <%		}
            				}%>
                  </select>
                    </td>
                    <td><img src=/acar/images/center/arrow_g_gmc.gif align=absmiddle>&nbsp;
                      <input type="radio" name="gubun4" value="0" <% if(gubun4.equals("0")) out.print("checked"); %>>
                      전체
                      <input type="radio" name="gubun4" value="1" <% if(gubun4.equals("1")) out.print("checked"); %>>
                      지점
                      <input type="radio" name="gubun4" value="2" <% if(gubun4.equals("2")) out.print("checked"); %>>
                      대리점 </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td colspan=2>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width=38%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_search.gif align=absmiddle>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                  <select name="gubun">
                                    <option value="">전체</option>
                                    <option value="emp_nm" <% if(gubun.equals("emp_nm")||gubun.equals("")) out.print("selected"); %>>성명</option>
                                    <option value="car_comp" <% if(gubun.equals("car_comp")) out.print("selected"); %>>자동차회사</option>
                                    <option value="car_off" <% if(gubun.equals("car_off")) out.print("selected"); %>>지점</option>
                                    <option value="car_off_nm" <% if(gubun.equals("car_off_nm")) out.print("selected"); %>>영업소명</option>
                                    <option value="emp_m_tel" <% if(gubun.equals("emp_m_tel")) out.print("selected"); %>>핸드폰</option>
                                    <option value="emp_email" <% if(gubun.equals("emp_email")) out.print("selected"); %>>이메일</option>
                                    <option value="damdang_id" <% if(gubun.equals("damdang_id")) out.print("selected"); %>>담당자</option>
                                  </select></td>
                                <td align=left><input type="text" class="text" name="gu_nm" size="15" value="<%= gu_nm %>" align="absbottom"></td>
                            </tr>
                        </table>
                     </td>
                    <td><img src=/acar/images/center/arrow_jr.gif align=absmiddle>&nbsp;
                      <select name="sort_gubun">
                        <option value="emp_nm" <% if(sort_gubun.equals("emp_nm")) out.print("selected"); %>>성명</option>
                        <option value="car_off_nm" <% if(sort_gubun.equals("car_off_nm")) out.print("selected"); %>>근무처</option>
        				<option value="damdang_id" <% if(sort_gubun.equals("damdang_id")) out.print("selected"); %>>담당자</option>				
                      </select> <input type='radio' name='sort' value='asc' <% if(sort.equals("asc")) out.print("checked"); %>>
                      오름차순 
                      <input type='radio' name='sort' value='desc' <% if(sort.equals("desc")) out.print("checked"); %>>
                      내림차순</td>
                      <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_ddj_sy.gif align=absmiddle>&nbsp; 
                      <select name="cng_rsn">
                        <option value="" <% if(cng_rsn.equals("")) out.println("selected");%>>==전체==</option>
                        <option value="1" <% if(cng_rsn.equals("1")) out.println("selected");%>>1.최근계약</option>
                        <option value="2" <% if(cng_rsn.equals("2")) out.println("selected");%>>2.대면상담</option>
                        <option value="3" <% if(cng_rsn.equals("3")) out.println("selected");%>>3.전화상담</option>
                        <option value="4" <% if(cng_rsn.equals("4")) out.println("selected");%>>4.전산배정</option>
                        <option value="5" <% if(cng_rsn.equals("5")) out.println("selected");%>>5.기타</option>
                      </select> &nbsp;<input type="text" name="st_dt" size="12" value="<%=st_dt%>" class="text" onBlur='javascript:this.value=ChangeDate(this.value)'>
                      ~ 
                      <input type="text" name="end_dt" size="12" value="<%=end_dt%>" class="text" onBlur='javascript:this.value=ChangeDate(this.value)'> 
                      <a href="javascript:SearchCarOffP()" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a></td>
                    <td align="right"> 
                      <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a href="javascript:car_emp_reg()" onMouseOver="window.status=''; return true"><img src=../images/center/button_reg_new.gif border=0 align=absmiddle></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                      <%}%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe> 
</body>
</html>
