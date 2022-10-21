<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.add_mark.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	//등록하기
	function reg(){
		var fm = document.form1;	
		if(fm.r_marks.value == ''){ alert("가산 점수을 입력하십시오."); fm.r_marks.focus(); return; }		
		if(fm.r_start_dt.value == ''){ alert("적용일자를 입력하십시오."); fm.r_start_dt.focus(); return; }				
		if(!confirm('등록하시겠습니까?'))	return;
		fm.target='i_no_in';
		fm.submit();		
	}
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String s_br_id = request.getParameter("s_br_id")==null?"":request.getParameter("s_br_id");
	String s_dept_id = request.getParameter("s_dept_id")==null?"":request.getParameter("s_dept_id");
	String s_start_dt = request.getParameter("s_start_dt")==null?"":request.getParameter("s_start_dt");	
	String s_gubun = request.getParameter("s_gubun")==null?"":request.getParameter("s_gubun");
	String s_mng_who = request.getParameter("s_mng_who")==null?"":request.getParameter("s_mng_who");	
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "11", "03", "04");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector branches = c_db.getBranchList(); //영업소 리스트 조회
	int brch_size = branches.size();
	
	CodeBean[] depts = c_db.getCodeAll2("0002", "Y"); /* 코드 구분:부서명-가산점적용 */
	int dept_size = depts.length;
	
	CodeBean[] ways = c_db.getCodeAll2("0005", "Y"); /* 코드 구분:대여방식-가산점적용 */
	int way_size = ways.length;	

	CodeBean[] stats = c_db.getCodeAll2("0006", "Y"); /* 코드 구분:가산관리현황-가산점적용 */
	int stat_size = stats.length;	
		
	CodeBean[] way2s = c_db.getCodeAll2("0005", ""); /* 코드 구분:대여방식 */
	int way_size2 = way2s.length;
%>
<form action="add_mark_null_ui.jsp" name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="s_br_id" value="<%=s_br_id%>">
<input type="hidden" name="s_dept_id" value="<%=s_dept_id%>">
<input type="hidden" name="s_start_dt" value="<%=s_start_dt%>">
<input type="hidden" name="s_gubun" value="<%=s_gubun%>">
<input type="hidden" name="s_mng_who" value="<%=s_mng_who%>">
<input type="hidden" name="cmd" value="i">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class='title' width=10%>영업소명</td>
                    <td class='title' width=10%>부서명</td>
                    <td class='title' width=10%>현황구분</td>
                    <td class='title' width=9%>가산기준</td>
                    <td class='title' width=11%>가산구분</td>
                    <td class='title' width=13%>점수구분</td>
                    <td class='title' width=10%>점수</td>
                    <td class='title' width=20%>적용일자</td>
                    <td class='title' width=7%>처리</td>
                </tr>
            </table>
        </td>
        <td width="17">&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2"> <iframe src="./add_mark_s_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_br_id=<%=s_br_id%>&s_dept_id=<%=s_dept_id%>&s_start_dt=<%=s_start_dt%>" name="i_view" width="100%" height="340" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe>	
        </td>
    </tr>
    <tr align="right"> 
        <td>&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width="100%">
                <tr> 
                    <td class='title'>영업소명</td>
                    <td> 
                      <select name='r_br_id'>
                        <%	if(brch_size > 0){
        							for (int i = 0 ; i < brch_size ; i++){
        								Hashtable branch = (Hashtable)branches.elementAt(i);%>
                        <option value='<%= branch.get("BR_ID") %>'  <%if(br_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
                        <%= branch.get("BR_NM")%> </option>
                        <%							}
        						}		%>
                      </select>
                    </td>
                    <td class='title'>부서명</td>
                    <td> 
                      <select name='r_dept_id'>
                        <option value="0000">전체</option>			  
                        <%if(dept_size > 0){
        					for(int i = 0 ; i < dept_size ; i++){
        						CodeBean dept = depts[i];%>
                        <option value='<%= dept.getCode()%>'> <%= dept.getNm()%> </option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td class='title'>현황구분</td>
                    <td colspan="4"> 
                      <select name='r_gubun'>
                        <%if(stat_size > 0){
        					for(int i = 0 ; i < stat_size ; i++){
        						CodeBean stat = stats[i];%>
                        <option value='<%= stat.getCode()%>'> <%= stat.getNm()%> </option>
                        <%	}
        				}%>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class='title' width=10%>가산기준</td>
                    <td width=15%> 
                      <select name='r_mng_who'>
                        <option value="1">업체</option>
                        <option value="2">차량</option>
                        <option value="3">계약</option>				
                        <option value="4">연체</option>								
                      </select>
                    </td>
                    <td class='title' width=10%>가산구분</td>
                    <td width=15%> 
                      <select name='r_mng_way'>
                        <option value="0">전체</option>
                        <%if(way_size > 0){
        					for(int i = 0 ; i < way_size ; i++){
        						CodeBean way = ways[i];%>
                        <option value='<%= way.getNm_cd()%>'> <%= way.getNm()%> </option>
                        <%	}
        				}%>				
                        <option value="9">기본식/맞춤식</option>				
                      </select>
                    </td>
                    <td class='title' width=10%>점수구분</td>
                    <td width=15%> 
                      <select name='r_mng_st'>
                        <option value=""></option>
                        <option value="1">단독</option>
                        <option value="2">공동</option>
                        <option value="3">최초영업</option>
                        <option value="4">영업관리</option>
                        <option value="5">정비관리</option>
                        <option value="6">신규계약</option>
                        <option value="7">대차계약</option>
                        <option value="8">증차계약</option>
                        <option value="9">연장계약</option>
                        <option value="10">보유차(6개월이상)</option>
                        <option value="11">연체율-기</option>				
                        <option value="12">연체율-변</option>								
                        <option value="13">관리-변</option>												
                      </select>
                    </td>
                    <td class='title' width=10%>점수 </td>
                    <%for(int j=0;j<way_size;j++){
        				CodeBean way = ways[j];%>
                    <%}%>
                    <td colspan="2" width=15%> 
                      <input type="text" name="r_marks" size="5" class="num" value="">
                      점 </td>
                </tr>
                <tr> 
                    <td class='title'>적용시작일</td>
                    <td> 
                      <input type="text" name="r_start_dt" size="9" class="text">
                    </td>
                    <td class='title'>적용만료일</td>
                    <td colspan="6"> 
                      <input type="text" name="r_end_dt" size="9" class="text">
        			  <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>				  
                	  <a href="javascript:reg();"><img src=../images/center/button_in_reg.gif border=0 align=absmiddle></a>
        			  <%	}%>	
                    </td>
                </tr>
            </table>
        </td>
        <td>&nbsp; </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no_in" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
</body>
</html>