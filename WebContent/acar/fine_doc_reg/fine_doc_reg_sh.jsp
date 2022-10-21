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
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//담당부서장 리스트
	Vector users = c_db.getUserList("", "", "HEAD2", "Y");
	int user_size = users.size();
	
	//담당자 리스트
	Vector users2 = c_db.getUserList("", "", "BODY", "Y");
	int user_size2 = users2.size();
	
	//변수
	String var1 = nm_db.getWorkAuthUser("본사관리팀장");//담당부서장
	String var2 = nm_db.getWorkAuthUser("과태료담당자");	//담당자
	String var3 = e_db.getEstiSikVarCase("1", "", "fine_app1");//첨부서류1
	String var4 = e_db.getEstiSikVarCase("1", "", "fine_app2");//첨부서류2
	String var5 = e_db.getEstiSikVarCase("1", "", "fine_app3");//첨부서류3
	String var6 = e_db.getEstiSikVarCase("1", "", "fine_app4");//첨부서류4
%>

<html>
<head><title>FMS</title>
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--		
	//과태료검색하기
	function fine_gov_search(){
		var fm = document.form1;	
		window.open("fine_gov_search.jsp?t_wd="+fm.gov_nm.value, "SEARCH_FINE_GOV", "left=200, top=10, width=880, height=750, scrollbars=yes");
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') fine_gov_search();
	}	
	
	//과태료검색하기
	function fine_search(){
		var fm = document.form1;
		if(fm.gov_nm.value == '') { alert('수신기관을 확인하십시오.'); return; }
		window.open("fine_search.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&t_wd="+fm.gov_nm.value+"&s_idx="+parent.c_foot.document.form1.size.value, "SEARCH_FINE", "left=50, top=10, width=1050, height=750, scrollbars=yes");
	}	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onload="javascript:document.form1.gov_nm.focus()">
<form name='form1' action='fine_doc_reg_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > 과태료관리 > <span class=style5>이의신청공문등록</span></span></td>
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
                    <td class='title' width=10%>문서번호</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="doc_id" size="20" class="text" value="<%=FineDocDb.getFineGovNoNext("관리")%>">
                    </td>
                    <td class='title' width=10%>시행일자</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="doc_dt" size="12" class="text" value="<%=AddUtil.getDate()%>" onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td width=10% class='title'>담당부서장</td>
                    <td width=15%>&nbsp;<select name='h_mng_id'>
                    <option value="">없음</option>
                    <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                    <option value='<%=user.get("USER_ID")%>' <%if(var1.equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
                    <%		}
        					}		%>
                    </select></td>
                    <td class='title' width=10%>담당자</td>
                    <td width=15%>&nbsp;<select name='b_mng_id'>
                    <option value="">없음</option>
                    <%	if(user_size2 > 0){
        						for (int i = 0 ; i < user_size2 ; i++){
        							Hashtable user = (Hashtable)users2.elementAt(i);	%>
                    <option value='<%=user.get("USER_ID")%>' <%if(var2.equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
                    <%		}
        					}		%>
                    </select></td>
                </tr>                
                <tr> 
                    <td class='title'>수신</td>
                    <td colspan='7'> 
                      &nbsp;<input type="text" name="gov_nm" size="50" class="text" style='IME-MODE: active' onKeyDown='javascript:enter()'>
        			  <input type='hidden' name="gov_id" value=''>
                      <a href="javascript:fine_gov_search();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_search1.gif"  align="absmiddle" border="0"></a>
        			</td>
                </tr>
                <tr> 
                    <td class='title'>참조</td>
                    <td colspan='7'> 
                      &nbsp;<input type="text" name="mng_dept" size="50" class="text"> 
                      (담당자명 : 
                      <input name="mng_nm" type="text" class="text" id="mng_nm" size="15">
                      / 담당자직급 : 
                      <input name="mng_pos" type="text" class="text" id="mng_pos" size="15">
                      )</td>
                </tr>
                <tr> 
                    <td class='title'>제목</td>
                    <td colspan='7'>&nbsp;도로교통법위반 과태료 부과 처분에 대한 의견 제출 (과태료 납부의무자 변경 요청)</td>
                </tr>
                <tr> 
                    <td class='title'>내용</td>
                    <td colspan='7'>&nbsp;귀 
                    &nbsp;<input name="gov_st" type="text" class="text" id="gov_st" size="20">
                    의 무궁한 발전을 기원합니다. </td>
                </tr>
                <tr> 
                    <td class='title'>첨부</td>
                    <td colspan='7'>
        			<input type="checkbox" name="app_doc1" value="Y" checked><%=var3%>
        			<input type="checkbox" name="app_doc2" value="Y" checked><%=var4%>
        			<input type="checkbox" name="app_doc3" value="Y" checked><%=var5%>
        			<input type="checkbox" name="app_doc4" value="Y" checked><%=var6%>
                    </td>
                </tr>		  

            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><a href="javascript:fine_search();"><img src="/acar/images/center/button_search_gtr.gif" align="absmiddle" border="0"></a></td>
    </tr>		
</table>
</form>
</body>
</html>
