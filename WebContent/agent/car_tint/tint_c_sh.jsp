<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup ��û�� ������
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	
	String white = "";
	String disabled = "";
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
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
//-->
</script>
<style type=text/css>

<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin=15>
<form name='form1' action='tint_c_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���¾�ü > ��ǰ���� > <span class=style5>��ǰ��Ȯ����Ȳ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ǰ˻�</span></td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
    	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>�Ⱓ</td>
                    <td>&nbsp;
        		<select name='gubun3'>
                            <option value='2' <%if(gubun3.equals("2")){%>selected<%}%>>��ġ����</option>
                        </select>
                	<select name='gubun2'>
                            <option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>����</option>
                            <option value='4' <%if(gubun2.equals("4")){%>selected<%}%>>����</option>
			    <option value='5' <%if(gubun2.equals("5")){%>selected<%}%>>����</option>
			    <option value='6' <%if(gubun2.equals("6")){%>selected<%}%>>7��</option>
                            <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>�Ⱓ </option>
                        </select>
                	<input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                        ~ 
                        <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
                    </td>
                    <td class=title width=10%>��ǰ��ü</td>
                    <td width=40%>&nbsp;
						<select name='gubun1'>
							<option value='' >��ü</option>
							<option value='�ٿȹ�' 		<%if(gubun1.equals("�ٿȹ�")){%>selected<%}%>>		�ٿȹ�</option>
							<option value='������TS' 	<%if(gubun1.equals("������TS")){%>selected<%}%>>������TS</option>	
							<option value='����ī����' 		<%if(gubun1.equals("����ī����")){%>selected<%}%>>	����ī����</option>
							<option value='�ֽ�ȸ��̼���ũ' 	<%if(gubun1.equals("�ֽ�ȸ��̼���ũ")){%>selected<%}%>>	�ֽ�ȸ��̼���ũ</option>
							<option value='�ֽ�ȸ�����ī��' 	<%if(gubun1.equals("�ֽ�ȸ�����ī��")){%>selected<%}%>>	�ֽ�ȸ�����ī��</option>
							<option value='�ƽþƳ����' 	<%if(gubun1.equals("�ƽþƳ����")){%>selected<%}%>>	�ƽþƳ����</option>
							<option value='������ڵ�����ǰ��' 	<%if(gubun1.equals("������ڵ�����ǰ��")){%>selected<%}%>>	������ڵ�����ǰ��</option>
							<!--
							<option value='����Į��ƿ' 	<%if(gubun1.equals("����Į��ƿ")){%>selected<%}%>>	����Į��ƿ</option>
							<option value='����Ųõ������' 	<%if(gubun1.equals("����Ųõ������")){%>selected<%}%>>	����Ųõ������</option>
							<option value='��ȣ4WD���' 	<%if(gubun1.equals("��ȣ4WD���")){%>selected<%}%>>	��ȣ4WD���</option>
							-->
						</select>                                                                  
                	</td>
                </tr>	  
                <tr>
                    <td class=title width=10%>�˻�����</td>
                    <td>&nbsp;
                	  <select name='s_kd'>
                        <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>�Ƿ���</option>
                      </select>
                	  &nbsp;&nbsp;&nbsp;
                	  <input type='text' name='t_wd' size='25' class='whitetext' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
                	</td>
                    <td class=title width=10%>��������</td>
                    <td>&nbsp;
                	  <select name='sort'>
                        <option value='1' <%if(sort.equals("1")){%>selected<%}%>>���� </option>
                        <option value='2' <%if(sort.equals("2")){%>selected<%}%>>�Ƿ���</option>
                        <option value='3' <%if(sort.equals("3")){%>selected<%}%>>����</option>
                        <option value='4' <%if(sort.equals("4")){%>selected<%}%>>�����ȣ</option>			  					  					  
                        <option value='5' <%if(sort.equals("5")){%>selected<%}%>>�� </option>
                        <option value='7' <%if(sort.equals("7")){%>selected<%}%>>��ġ���� </option>								
                      </select>
                	</td>
                </tr>
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td><a href="javascript:search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>
</table>
</form>
</body>
</html>
