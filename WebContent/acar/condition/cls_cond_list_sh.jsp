<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%

	
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");

	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String dt = request.getParameter("dt")==null?"":request.getParameter("dt");
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	int st_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int year =AddUtil.getDate2(1);
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function SearchBrCond()
{
	var theForm = document.BrCondSearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}
//-->
</script>
</head>
<body leftmargin=15>


<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>계약해지 건수별현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<form action="./cls_cond_list_sc.jsp" name="BrCondSearchForm" method="POST" target="c_foot">
	<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
    <tr>
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
            	<tr>            		
            		<td width=><input type="radio" name="dt" value="1" checked> 연도&nbsp;
						<select name="st_year">
							<%for(int i=2000; i<=year; i++){%>
							<option value="<%=i%>" <%if(st_year == i){%>selected<%}%>><%=i%>년</option>
							<%}%>
						</select>
						<input type="radio" name="dt" value="3"> 기간&nbsp;
						<input type="text" name="ref_dt1" size="10" value="" class=text> ~ <input type="text" name="ref_dt2" size="10" value="" class=text>&nbsp;
						<img src=../images/center/arrow_g.gif align=absmiddle>&nbsp;
                        <select name="gubun2">
                            <option value="" <%if(gubun2.equals(""))%>selected<%%>>전체</option>
                            <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>렌트</option>
                            <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>리스</option>
                        </select>&nbsp;&nbsp;&nbsp;
						※중도해지 계산서발행여부
						<select name="gubun1">
                            <option value="" <%if(gubun1.equals(""))%>selected<%%>>전체</option>
                            <option value="Y" <%if(gubun1.equals("Y"))%>selected<%%>>발행</option>
                            <option value="N" <%if(gubun1.equals("N"))%>selected<%%>>미발행</option>
                        </select>
            		</td>
					<td><a href="javascript:SearchBrCond()"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
            	</tr>
            </table>
        </td>
    </tr>
</form>
</table>
</body>
</html>