<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth_rw = "";
	if(request.getParameter("auth_rw") != null)	auth_rw= request.getParameter("auth_rw");
	String sort 	= request.getParameter("sort")==null?"2":request.getParameter("sort");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String acar_id = ck_acar_id;
			//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	String user_nm = "";
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--

function Search()
{
	var theForm = document.MaintSearchForm;
	var g_nm = theForm.gubun_nm.value;

//	g_nm = encodeURIComponent(g_nm);

	theForm.action = 'car_s_sc.jsp';//?gubun_nm=' + g_nm;
	theForm.target = "c_foot";
	theForm.submit();
}

function ChangeFocus()
{
	var theForm = document.MaintSearchForm;
	if(theForm.gubun.value=="ref_dt")
	{
		nm.style.display = 'none';
		theForm.ref_dt1.value = "";
		theForm.ref_dt2.value = "";
		theForm.ref_dt1.focus();
		
	}else{
		nm.style.display = '';
		theForm.gubun_nm.value = "";
		theForm.gubun_nm.focus();
	}
}
function ChangeDT(arg)
{
	var theForm = document.MaintSearchForm;
	if(arg=="ref_dt1")
	{
	theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2"){
	theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}

}


function magam()
{
	var theForm = document.MaintSearchForm;
	
	if(!confirm('마감하시겠습니까?'))
		return;
			
	theForm.action = 'stat_end_null.jsp';		
	theForm.target = 'i_no';
					
	theForm.submit();	
	
}
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body onload="javascript:Search();">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 자동차관리 > <span class=style5>자동차주행거리현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<form name="MaintSearchForm" method="POST" >
	<input type="hidden" name="selectedPage" value="1" />
	<input type="hidden" name="rowsPerPage" value="100" />
	<!-- 처음 페이지 로딩에서 Search()로 검색된 내용인지 구분하기 위한 value -->
	<input type="hidden" name="fromSearch" value="true" />
    <tr>
        <td>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
            	<tr>
            		
            		<td width=13%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_search.gif align=absmiddle>&nbsp; 
            			<select name="gubun">
            				<option value="car_no">차량번호</option>
            				<option value="firm_nm">상호</option>
            		<!--		<option value="client_nm">고객명</option> -->
            				<option value="car_nm">차종</option>
            				<option value="jg_code" >차종코드</option>
							<option value="mng_nm" selected>관리담당자</option>
            			</select>
            		</td>
					<%	if(user_size > 0){
					for (int i = 0 ; i < user_size ; i++){
						Hashtable user = (Hashtable)users.elementAt(i);
							if(ck_acar_id.equals(user.get("USER_ID"))){
								user_nm = (String)user.get("USER_NM");
							}
					}
				}%>
            		<td id="nm" width=25%><input type="text" name="gubun_nm" size="20" value="<%=user_nm%>" class=text ></td>            					
           			<td width=15%><img src=/acar/images/center/arrow_sbjh.gif align=absmiddle>&nbsp;
           				<select name="gubun3">
            				<option value=""   <%if(gubun3.equals(""))%> 	selected<%%>>전체</option>
	            			<option value="1"  <%if(gubun3.equals("1"))%> 	selected<%%>>렌트(영업용)</option> 
	            			<option value="2"  <%if(gubun3.equals("2"))%> 	selected<%%>>리스(업무용)</option> 
	            		</select>	
            	    </td> 
					<td width=15%>&nbsp;
           				<select name="gubun2">
            				<option value=""   <%if(gubun2.equals(""))%> 	selected<%%>>전체</option>
	            			<option value="3"  <%if(gubun2.equals("3"))%> 	selected<%%>>일반식</option> 
	            			<option value="4"  <%if(gubun2.equals("4"))%> 	selected<%%>>기본식</option> 
	            		</select>	
            	    </td> 
            		<td width=15%><img src=/acar/images/center/arrow_jr.gif align=absmiddle>&nbsp;
            			<select name="sort">
            				<option value="1" 	<%if(sort.equals("1"))%> 	selected<%%>>현재주행거리</option>
            				<option value="2" 	<%if(sort.equals("2"))%> 	selected<%%>>연평균주행거리</option>
            			    <option value="3" 	<%if(sort.equals("3"))%> 	selected<%%>>최초등록일</option>
            			</select>
            	    </td> 		
            	    <td><input type="hidden" name="auth_rw" value="<%=auth_rw%>"><a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>
            	    &nbsp;&nbsp; <% if (  auth_rw.equals("6") ) {%>   <a href="javascript:magam()">.</a> <% } %>
            	    </td>
            		
            		
            	</tr>
            </table>
        </td>
    </tr>
    <input type='hidden' name='sh_height' value='<%=sh_height%>'>
    <input type='hidden' name='ck_acar_id' value='<%=ck_acar_id%>'>
	<input type='hidden' name="s_width" value="<%=s_width%>">   
	<input type='hidden' name="s_height" value="<%=s_height%>"> 
    </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>