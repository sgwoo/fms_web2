<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*, acar.user_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "HEAD2", "Y");
	int user_size = users.size();
	Vector users2 = c_db.getUserList("", "", "BODY", "Y");
	int user_size2 = users2.size();	
	
	
	//변수
	String var1 = nm_db.getWorkAuthUser("본사총무팀장");	//담당부서장
	String var2 = nm_db.getWorkAuthUser("자동차세담당자");	//담당자
	
	if(user_id.equals("000056") || user_id.equals("000107") || user_id.equals("000121")) var1 = "000053";//부산-제인학
	if(user_id.equals("000056") || user_id.equals("000107") || user_id.equals("000121")) var2 = "000056";//부산-최은아    ---- 20110816 최은숙에서 최은아로 수정
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--		
	//과태료검색하기
	function fine_gov_search(){
		var fm = document.form1;	
		window.open("fine_gov_search.jsp?t_wd="+fm.gov_nm.value, "SEARCH_FINE_GOV", "left=200, top=200, width=550, height=450, resizable=yes, scrollbars=yes, status=yes");
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') fine_gov_search();
	}	
	
	//과태료검색하기
	function car_exp_search(){
		var fm = document.form1;
		if(fm.gov_nm.value == '') { alert('수신기관을 확인하십시오.'); return; }
		window.open("car_exp_search.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&t_wd="+fm.gov_nm.value, "SEARCH_FINE", "left=50, top=50, width=750, height=650, resizable=yes, scrollbars=yes, status=yes");
	}	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onload="javascript:document.form1.gov_nm.focus()">
<form name='form1' action='car_exp_reg_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 > <span class=style5>자동차세 환급신청 공문등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=12%>문서번호</td>
                    <td width=88%> 
                      &nbsp;<input type="text" name="doc_id" size="15" class="text" value="<%=FineDocDb.getFineGovNoNext("환급")%>">
                    </td>
                </tr>
                <tr> 
                    <td class='title'>시행일자</td>
                    <td> 
                      &nbsp;<input type="text" name="doc_dt" size="11" class="text" value="<%=AddUtil.getDate()%>" onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>수신</td>
                    <td> 
                      &nbsp;<input type="text" name="gov_nm" size="50" class="text" style='IME-MODE: active' onKeyDown='javascript:enter()'>
        			  <input type='hidden' name="gov_id" value=''>
                      <a href="javascript:fine_gov_search();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_search1.gif"  align="absmiddle" border="0"></a> ※인천계양은 팩스 넣기 전에 연락주도록 함(032-540-5253).
        			</td>
                </tr>
                <tr> 
                    <td class='title'>참조</td>
                    <td> 
                      &nbsp;<input type="text" name="mng_dept" size="50" class="text"> 
                      (담당자명 : 
                      <input name="mng_nm" type="text" class="text" id="mng_nm" size="15">
                      / 담당자직급 : 
                      <input name="mng_pos" type="text" class="text" id="mng_pos" size="15">
                      )</td>
                </tr>
                <tr> 
                    <td class='title'>제목</td>
                    <td>&nbsp;자동차세 환급신청서 제출</td>
                </tr>
                <tr> 
                    <td class='title'>내용</td>
                    <td>&nbsp;귀 
                    &nbsp;<input name="gov_st" type="text" class="text" id="gov_st" size="10">
                    의 무궁한 발전을 기원합니다. </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>당사</span></td>
    </tr>

    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width=12% class='title'>담당부서장</td>
                    <td width=38%>&nbsp;<select name='h_mng_id'>
                    <option value="">없음</option>
                    <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                    <option value='<%=user.get("USER_ID")%>' <%if(var1.equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
                    <%		}
        					}		%>
                    </select></td>
                    <td class='title' width=12%>담당자</td>
                    <td width=38%>&nbsp;<select name='b_mng_id'>
                    <option value="">없음</option>
                    <%	if(user_size2 > 0){
        						for (int i = 0 ; i < user_size2 ; i++){
        							Hashtable user = (Hashtable)users2.elementAt(i);	%>
                    <option value='<%=user.get("USER_ID")%>' <%if(var2.equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
                    <%		}
        					}		%>
                    </select></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>	
    <tr> 
        <td><a href="javascript:car_exp_search();"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>
    </tr>		
</table>
</form>
</body>
</html>
