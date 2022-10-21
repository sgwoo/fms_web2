<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.attend.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");

	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector branches = c_db.getBranchList(); //영업소 리스트 조회
	int brch_size = branches.size();	
	
	
	int cnt = 3; //현황 출력 총수
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50-70;//현황 라인수만큼 제한 아이프레임 사이즈
	
	if(height < 50) height = 150;
	
	
	

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="javascript">
<!--
function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') vacationSearch();
}

function vacationSearch(){
	fm = document.form1;
	var auth_rw = fm.auth_rw.value;
	var br_id = fm.br_id.value;
	var dept_id = fm.dept_id.value;
	var user_nm = fm.user_nm.value;
//alert("this");	
	this.inner.location.href = "./vacation_all_in_new.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&dept_id="+dept_id+"&user_nm="+user_nm;
	
}

	
//-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 근태관리 > <span class=style5>연차관리 </span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h colspan=2></td>
    </tr>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr>                
                    <td width="45%" align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gmg.gif align=absmiddle>
                        &nbsp;<select name='br_id'>
                          <option value=''>전체</option>
                          <%	if(brch_size > 0){
                				for (int i = 0 ; i < brch_size ; i++){
                					Hashtable branch = (Hashtable)branches.elementAt(i);%>
                          <option value='<%= branch.get("BR_ID") %>'><%= branch.get("BR_NM")%></option>
                          <%		}
                			}		%>
                        </select> &nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_bs.gif align=absmiddle>&nbsp;<select name="dept_id">
                          <option value="">전체</option>
                          <option value="0001">영업팀</option>
                          <option value="0020">영업기획팀</option>
                          <option value="0002">고객지원팀</option>
                          <option value="0003">총무팀</option>
						  <option value="0005">IT팀</option>
                          <option value="0007">부산지점</option>
                          <option value="0008">대전지점</option>
						  <option value="0009">강남지점</option>
						  <option value="0010">광주지점</option>
						  <option value="0011">대구지점</option>
						  <option value="0014">강서지점</option>
						  <option value="0015">구로지점</option>
						  <option value="0016">울산지점</option>
						  <option value="0017">광화문지점</option>
						  <option value="0018">송파지점</option>
                        </select> &nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_sm.gif align=absmiddle> 
                        &nbsp;<input type="text" name="user_nm" value="" class="text" size="15" style="IME-MODE:active;">
                    </td>
                    <td width=30% align="left"><a href="javascript:vacationSearch()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a></td>
                    <td width=28% align="right"> 
                    	<%if( user_id.equals("000003") || user_id.equals("000203") ){%> &nbsp;
                    	<% } else {%>
					<a href="./vacation_sc_in_new.jsp?auth_rw=<%= auth_rw %>&br_id=<%= br_id %>&user_id=<%= user_id %>"><img src=../images/center/button_see_s.gif border=0 align=absmiddle></a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                             <% } %>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=3% rowspan="3" class="title">연번</td>
                    <td width=8% rowspan="3" class="title">근무지</td>
                    <td width=8% rowspan="3" class="title">부서</td>
                    <td width=5% rowspan="3" class="title">직급</td>
                    <td width=7% rowspan="3" class="title">성명</td>
                    <td width=7% rowspan="3" class="title">입사일</td>                 
                    <td colspan="3" class="title">계속근무기간</td>
                    <td colspan="4" class="title" width=21% >근로기준법 기준</td>
                    <td colspan="4" class="title" width=19% >사규기준 {이월(기한 30일 연장)}</td>	
                    <td width="6%" rowspan="3" class="title">반휴가현황<br>오전:오후</td>
                    <td width=4% rowspan="3" class="title">무급</td>         
                                    
                </tr>
                <tr> 
                    <td width=4% rowspan="2" class="title">년</td>
                    <td width=4% rowspan="2" class="title">월</td>
                    <td width=4% rowspan="2" class="title">일</td>
                    <td colspan="3" class="title">사용현황</td>
                    <td width=7% rowspan="2" class="title">사용기한</td>
                    <td colspan="3" class="title">사용현황</td>
                    <td width=7% rowspan="2" class="title">미사용연차<br>소멸예정일</td>
                                  		               
                </tr>
                <tr> 
                    <td width=4% class="title">가용</td>
                    <td width=5% class="title">사용</td>
                    <td width=5% class="title">미사용</td>
                    <td width=4% class="title">이월</td>
                    <td width=4% class="title">사용</td>
                    <td width=4% class="title">미사용</td>
                  
                </tr>
            </table>
        </td>
        <td width=16>&nbsp;</td>  
    </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><iframe src="vacation_all_in_new.jsp?auth_rw=<%= auth_rw %>&br_id=<%= br_id %>&user_id=<%= user_id %>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe></td>
  </tr>
</table>
</form>
</body>
</html>
