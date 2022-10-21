<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String sort 	= request.getParameter("sort")==null?"5":request.getParameter("sort");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String chk1 	= request.getParameter("chk1")==null?"":request.getParameter("chk1");
		
	String acar_id = ck_acar_id;
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

function Search()
{
	var theForm = document.MaintSearchForm;
	theForm.target = "c_foot";
	theForm.action = 'car_cost_s_sc.jsp';
	theForm.submit();
}

function ChangeFocus()
{
	var theForm = document.MaintSearchForm;
	if(theForm.gubun.value=="all")
	{
		nm.style.display = 'none';
		theForm.gubun_nm.value = "";
	
		
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
<body>


<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 자동차관리 > <span class=style5>차량별 관리비용현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<form name="MaintSearchForm" method="POST" >
    <tr>
        <td>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
            	<tr>
	            	<td width=40% colspan=2> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_ggjh.gif align=absmiddle>&nbsp;             	   
	            	   <input type="text" name=ref_dt1 size="11" maxlength="10"   class=text >
						~
					   <input type="text" name="ref_dt2" size="11" maxlength="10"  class=text>&nbsp;&nbsp;
	            	</td>   
	            	
	            	<td>
						<input type="radio" name="chk1" value="" <%if(chk1.equals("")){%> checked <%}%>>현재
						<input type="radio" name="chk1" value="1" <%if(chk1.equals("1")){%> checked <%}%>>1달전
	            	</td>           	            	
	            	        	
	            </tr>
	            <tr>    		
	            	<td width=15%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_search.gif align=absmiddle>&nbsp;&nbsp;
	            			<select name="gubun" onChange="jvascript:ChangeFocus()">
	            			    <option value="all">전체</option>
	            				<option value="car_no">차량번호</option>
	            				<option value="firm_nm">상호</option>
	            		<!--		<option value="client_nm">고객명</option> -->
	            				<option value="car_nm">차종</option>
	            				<option value="jg_code" selected>차종코드</option>
	            				<option value="bus_itm">종목</option>
	            			</select>&nbsp;&nbsp;            			
	            	</td>
	            	<td id="nm" width=20%><input type="text" name="gubun_nm" size="20" value="" class=text >&nbsp;</td>            					
           			<td width=30%><img src=/acar/images/center/arrow_sbjh.gif align=absmiddle>&nbsp;
           				<select name="gubun3">
            				<option value=""   <%if(gubun3.equals(""))%> 	selected<%%>>전체</option>
	            			<option value="1"  <%if(gubun3.equals("1"))%> 	selected<%%>>렌트(영업용)</option> 
	            			<option value="2"  <%if(gubun3.equals("2"))%> 	selected<%%>>리스(업무용)</option> 
	            			<option value="3"  <%if(gubun3.equals("3"))%> 	selected<%%>>일반식</option> 
	            			<option value="4"  <%if(gubun3.equals("4"))%> 	selected<%%>>기본식</option> 
	            		</select>	
	            			<select name="gubun4">
            				<option value=""   <%if(gubun4.equals(""))%> 	selected<%%>>전체</option>
	            			<option value="0"  <%if(gubun4.equals("0"))%> 	selected<%%>>재리스</option> 
	            			<option value="1"  <%if(gubun4.equals("1"))%> 	selected<%%>>신차</option> 
	            			<option value="2"  <%if(gubun4.equals("2"))%> 	selected<%%>>중고차</option> 	            		
	            		</select>	
            	    </td> 				
            		<td width=15%><img src=/acar/images/center/arrow_jr.gif align=absmiddle>&nbsp;
            			<select name="sort">
            				<option value="1" 	<%if(sort.equals("1"))%> 	selected<%%>>현재주행거리</option>
            				<option value="2" 	<%if(sort.equals("2"))%> 	selected<%%>>연평균주행거리</option>
            			         <option value="3" 	<%if(sort.equals("3"))%> 	selected<%%>>최초등록일</option>
            			         <option value="4" 	<%if(sort.equals("4"))%> 	selected<%%>>누적총비용</option>
            			         <option value="5" 	<%if(sort.equals("5"))%> 	selected<%%>>월평균총비용</option>
            			         <option value="6" 	<%if(sort.equals("6"))%> 	selected<%%>>상호</option>            			         
            			         <option value="7" 	<%if(sort.equals("7"))%> 	selected<%%>>차종코드</option>

            			</select>
            	    </td> 		
            	    <td><input type="hidden" name="auth_rw" value="<%=auth_rw%>"><a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>
            	    &nbsp;&nbsp; <% if (nm_db.getWorkAuthUser("전산팀",acar_id)) { %> <a href="javascript:magam()">.</a><% } %>
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