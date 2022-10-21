<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language="JavaScript">
<!--
	function search()
	{
		document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	function cng_input()
	{
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '4')
		{
			td_input.style.display	= 'none';
			td_slt.style.display 	= '';
		}
		else
		{
			td_input.style.display	= '';
			td_slt.style.display 	= 'none';
		}
	}		
//-->
</script>
</head>
<%
	String gubun = request.getParameter("gubun")==null?"1":request.getParameter("gubun");
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	InsComBean ic_r [] = c_db.getInsComAll();
	int ic_size = ic_r.length;

	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<body>
<form name='form1' method='post' action='/acar/condition/ins_condition_sc.jsp' target='c_body'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 

<table border=0 cellspacing=0 cellpadding=0 width='100%'>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > 보험현황 > <span class=style5>자동차보험계약현황</span></span></td>
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
            <table border='0' cellspacing='1' cellpadding='0' width='100%'>
            	<tr>
            		<td width='16%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif  align=absmiddle>&nbsp;
                        <select name='s_kd' onChange='javascript:cng_input()'>
            				<option value='0'>전체</option>
            				<option value='1'>상호</option>
            				<option value='2'>계약번호</option>
            				<option value='3'>차량번호</option>
            				<option value='4'>보험사</option>
            				<option value='5'>계약개시일</option>
            				<option value='6'>계약만료일</option>
            			</select>
            		</td>
					<td id='td_input' align='left'>
						<input type='text' name='t_wd' size='20' class='text' value='' onKeyDown='javascript:enter()'>&nbsp;&nbsp;
						<a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>
					</td>
					<td id='td_slt' align='left' style='display:none'>
						<select name='ins_com'>
<%
	if(ic_size > 0)
	{
		for(int i = 0 ; i < ic_size ; i++)
		{
			InsComBean ic = ic_r[i];
%>
							<option value="<%=ic.getIns_com_id()%>"><%=ic.getIns_com_nm()%></option>
<%		}
	}
%>							</select>&nbsp;&nbsp;
						<a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>
					</td>
				</tr>
				<tr>
		         <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_choice.gif  align=absmiddle>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		              <select name="gubun" >
		                <option value=""  <%if(gubun.equals("")){%> selected <%}%>>전체&nbsp;&nbsp;&nbsp;</option> 
		                <option value="1" <%if(gubun.equals("1")){%> selected <%}%>>신규&nbsp;&nbsp;&nbsp;</option>
		                <option value="2" <%if(gubun.equals("2")){%> selected <%}%>>갱신&nbsp;&nbsp;&nbsp;</option>
		                <option value="3" <%if(gubun.equals("3")){%> selected <%}%>>중도해지&nbsp;&nbsp;&nbsp;</option>
		                <option value="4" <%if(gubun.equals("4")){%> selected <%}%>>만료&nbsp;&nbsp;&nbsp;</option>
		              </select>
		          </td>
		          <td colspan=2>&nbsp;</td>
		        </tr>      
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>