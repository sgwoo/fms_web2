<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	/*������� ��������*/
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?Util.getDate():request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?Util.getDate():request.getParameter("ref_dt2");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String g_fm = "1";
	

	/*�������ȳ�*/
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
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
function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') SearchRentCond();
}
function ChangeDT(arg)
{
	var theForm = document.RentCondSearchForm;
	if(arg=="ref_dt1")
	{
	theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2"){
	theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}

}

	//���÷��� Ÿ��
	function cng_input(){
		var fm = document.RentCondSearchForm;
		if(fm.gubun3.options[fm.gubun3.selectedIndex].value != ''){
			td_user.style.display 	= '';
		}else{
			td_user.style.display 	= 'none';
		}
	}
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>�����Ȳ II</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	      
	<form action="./rent_cond_sc.jsp" name="RentCondSearchForm" method="POST" target="c_foot">
    <tr>
        <td>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td width=21%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="dt" value="1" <%if(dt.equals("1"))%>checked<%%>>
                      ���� 
                      <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
                      ��� 
                      <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
                      ��ȸ�Ⱓ </td>
                    <td width=14%><img src=/acar/images/center/arrow_g.gif align=absmiddle>&nbsp;
                      <select name="gubun2">
                        <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>�����</option>
                        <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>�뿩������</option>
                      </select></td>
                    <td width=15%> <input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
                      ~ 
                      <input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()"> 
                    </td>
                    <td>&nbsp;&nbsp;&nbsp;<a href="javascript:SearchRentCond()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
                </tr>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gy.gif align=absmiddle>&nbsp;
                      <select name="gubun3">
                        <option value=""  <%if(gubun3.equals(""))%>selected<%%>>��ü</option>
                        <option value="1" <%if(gubun3.equals("1"))%>selected<%%>>����</option>
                        <option value="2" <%if(gubun3.equals("2"))%>selected<%%>>�縮��</option>
                        <option value="3" <%if(gubun3.equals("3"))%>selected<%%>>����</option>
                      </select>
                      &nbsp;
                      <select name="gubun4">
                        <option value=""  <%if(gubun4.equals(""))%>selected<%%>>��ü</option>
                        <option value="1" <%if(gubun4.equals("1"))%>selected<%%>>��Ʈ</option>
                        <option value="3" <%if(gubun4.equals("3"))%>selected<%%>>����</option>                        
                      </select>
                    </td>
                    <td><img src=/acar/images/center/arrow_jr.gif align=absmiddle>&nbsp;
                      <select name="sort">
                        <option value="7" <%if(sort.equals("7"))%>selected<%%>>�������������</option>
                        <option value="1" <%if(sort.equals("1"))%>selected<%%>>�����</option>
                        <option value="2" <%if(sort.equals("2"))%>selected<%%>>�뿩������</option>                                  
                      </select></td>
                    <td>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 	    
</form>

</table>
</body>
</html>