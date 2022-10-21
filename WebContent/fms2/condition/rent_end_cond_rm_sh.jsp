<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.common.*, acar.user_mng.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");

	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"1":request.getParameter("gubun5");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	user_bean 	= umd.getUsersBean(user_id);
	
	Vector users = c_db.getUserList("", "", "EMP"); //영업담당자 리스트
	int user_size = users.size();
	Vector users2 = c_db.getUserList("9999", "", "", "N"); //퇴사자 리스트
	int user_size2 = users2.size();
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function SearchRentCond()
{
	var theForm = document.RentCondSearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}

	//디스플레이 타입
function cng_input(){
		var fm = document.RentCondSearchForm;
		if(fm.gubun3.options[fm.gubun3.selectedIndex].value != ''){
			td_user.style.display 	= 'block';
		}else{
			td_user.style.display 	= 'none';
		}
}
//-->
</script>
</head>
<body>
<input type="hidden" name="user_id" id="user_id" value="<%=user_id%>">

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 월렌트관리 > <span class=style5>계약만료현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	      
	<form action="./rent_end_cond_rm_sc.jsp" name="RentCondSearchForm" id="RentCondSearchForm" method="POST" target="c_foot">
	<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
    <tr>
        <td>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
            	<tr>
            		<td width=35% colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            			<input type="radio" name="dt" value="1" checked> 스케쥴 기준 10일이내
            			<input type="radio" name="dt" value="2"> 기간
            		</td>
            		<td width=25%>
            			<input type="text" name="ref_dt1" size="11" value="" class=text> ~ <input type="text" name="ref_dt2" size="11" value="" class=text>
            		</td>
					<td>&nbsp;</td>
            	</tr>
            	<tr> 
		            <td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_ddj.gif align=absmiddle>&nbsp;
		              <select name="gubun3" onChange='javascript:cng_input()'>
		                <option value=""  <%if(gubun3.equals(""))%>selected<%%>>전체</option>
		                <option value="1" <%if(gubun3.equals("1"))%>selected<%%>>최초영업자</option>
		                <option value="2" <%if(gubun3.equals("2"))%>selected<%%>>영업담당자</option>
		                <option value="3" <%if(gubun3.equals("3"))%>selected<%%>>관리담당자</option>
		                <option value="4" <%if(gubun3.equals("4"))%>selected<%%>>진행담당자</option>
		              </select></td>
		            <td id='td_user' align='left' <%if(gubun3.equals("")){%> style='display:none'<%}%> >
				          <select name='gubun4' id="gubun4" onChange='javascript:SearchRentCond()'>
								    <option value="">미지정</option>
								<%	if(user_size > 0){
											for (int i = 0 ; i < user_size ; i++){
												Hashtable user = (Hashtable)users.elementAt(i);	%>
				            <option value='<%=user.get("USER_ID")%>' <%if(gubun4.equals(user.get("USER_ID"))) out.println("selected");%>
				            	<%if((user_bean.getLoan_st().equals("1")||user_bean.getLoan_st().equals("2"))&& String.valueOf(user.get("USER_ID")).equals(ck_acar_id)){ %>selected<%} %>
				            ><%=user.get("USER_NM")%></option>
				        <%		}
										}
								%>
								    <option value="">=퇴사자=</option>
				        <%	if(user_size2 > 0){
											for (int i = 0 ; i < user_size2 ; i++){
												Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
								    <option value='<%=user2.get("USER_ID")%>' <%if(gubun4.equals(user2.get("USER_ID"))) out.println("selected");%>><%=user2.get("USER_NM")%></option>
				        <%		}
										}
								%>
				          </select>
						      <input type="hidden" name="search_text" id="search_text" style="width:100px;">
				        </td>
				        <td>
            			 <select name="gubun5" onChange='javascript:cng_input()' align=absmiddle>
		                <option value=""  <%if(gubun5.equals(""))%>selected<%%>>전체</option>
		                <option value="1"  <%if(gubun5.equals("1"))%>selected<%%>>차량번호</option>
		              </select>
		              <input type="text" name="t_wd" size="13" value="" class=text> &nbsp;&nbsp;&nbsp;&nbsp;
		              <a href="javascript:SearchRentCond()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
            		</td>
				</tr>
            </table>
        </td>
    </tr>
</form>
</table>
</body>
<script>
	// 영업관리 > 월렌트관리 > 월렌트기간만료현황 김경선 대리 전용 이름으로 검색 기능 추가 		2017.12.12
	// 팀장 김광수, 대리 김경선, 팀장 이종준, 차장 차영화, 과장 정현미, 대리 심병호(개발자)
	var user_id = $("#user_id").val();
	if(user_id == 000026 || user_id == 000058 || user_id == 000237 || user_id == 000063 || user_id == 000029 || user_id == 000293){
		$("#gubun4").css("background","Gainsboro");
		$("#search_text").prop("type", "text");
	}

	$("#search_text").change(function(){
		var search_text  = $(this).val();
		if(search_text == ""){
			$("select[name='gubun4'] option:eq(0)").prop("selected", true);	
		}else {
			$("select[name='gubun4'] option:contains('"+search_text+"')").prop("selected", true);
		}
		SearchRentCond();
	});
</script>
</html>