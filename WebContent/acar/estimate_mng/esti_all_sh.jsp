<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//��ȸ
	function search(){
		var fm = document.form1;
		if(fm.gubun1.value == '3' && fm.s_dt.value == ''){
			alert('�Ⱓ �������� �Է��Ͻʽÿ�.'); return;
		}
		if(fm.gubun1.value == '3' && fm.e_dt.value == ''){
			alert('�Ⱓ �������� �Է��Ͻʽÿ�.'); return;
		}
		if(fm.t_wd.value == ''){
			alert('�˻�� �Է��Ͻʽÿ�.'); return;
		}
		fm.action = "esti_all_sc.jsp";
		fm.target = "c_foot";
		fm.submit();
	}
	function EnterDown(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
//-->
</script>
</head>
<body>
<form action="./esti_all_sc.jsp" name="form1" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > �������� > <span class=style5>��������</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td> 
            <table border=0 cellpadding=0 cellspacing=1 width="100%">
                <tr> 
                    <td><img src=/acar/images/center/arrow_day_gj.gif align=absmiddle>&nbsp;
                                    <select name="gubun1">
                                        <option value="6" <%if(gubun1.equals("6"))%>selected<%%>>����</option>
                                        <option value="1" <%if(gubun1.equals("1"))%>selected<%%>>���</option>
                                        <option value="5" <%if(gubun1.equals("5"))%>selected<%%>>����</option>
                                        <option value="2" <%if(gubun1.equals("2"))%>selected<%%>>����</option>
                                        <option value="4" <%if(gubun1.equals("4"))%>selected<%%>>����</option>                                        
                                        <option value="3" <%if(gubun1.equals("3"))%>selected<%%>>�Ⱓ</option>                                        
                                    </select>
                                    &nbsp;
                                	<input type="text" name="s_dt" size="11" value="<%=AddUtil.ChangeDate2(s_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                                	~ 
                                	<input type="text" name="e_dt" size="11" value="<%=AddUtil.ChangeDate2(e_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                                	&nbsp; 
                                	&nbsp;<input type="checkbox" name="gubun2" value="Y" <% if(gubun2.equals("Y")) out.print("checked"); %>> �縮����������
                                	&nbsp; 
                                	&nbsp;<input type="checkbox" name="gubun3" value="Y" <% if(gubun3.equals("Y")) out.print("checked"); %>> ����������
                                	
                        &nbsp;&nbsp;&nbsp;        
                    	<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp;
                                <select name="s_kd">
                                    <option value="1" <%if(s_kd.equals("1"))%>selected<%%>>������ȣ</option>                                    
                                    <option value="2" <%if(s_kd.equals("2"))%>selected<%%>>����ȣ</option>                                    
                                    <option value="3" <%if(s_kd.equals("3"))%>selected<%%>>�Ϸù�ȣ</option>                                    
                                    <option value="4" <%if(s_kd.equals("4"))%>selected<%%>>�����</option>
                                  </select> 
                                	&nbsp;<input type="text" name="t_wd" size="20" value="<%=t_wd%>" class=text onKeyDown="javasript:EnterDown()">
                        &nbsp;&nbsp;&nbsp;        	
                    	<a href="javascript:search()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>

