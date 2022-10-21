<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	UserMngDatabase umd = UserMngDatabase.getInstance();

	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");

	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���

	
	//�α���ID&������ID&����
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))		br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = umd.getXmlMaMenuAuth(user_id, "07", "04", "13");
%>

<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�˻��ϱ�
	function search(){
		var fm = document.form1;
		fm.t_wd.value = replaceString("&","AND",fm.t_wd.value);
		fm.action = 'pur_pre_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
//-->
</script>
</head>
<body onload="javascript:document.form1.t_wd.focus();">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='from_page' value='<%=from_page%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������� > <span class=style5>����������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
	<td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ǰ˻�</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
    	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>���������</td>
                    <td>&nbsp;
            		<select name='gubun3'>
                            <option value='' <%if(gubun3.equals("")){%>selected<%}%>> ��ü </option>
                            <option value='B2B������'   <%if(gubun3.equals("B2B������")){%>selected<%}%>> ���� B2B������ </option>
                            <option value='���Ǵ�븮��'  <%if(gubun3.equals("���Ǵ�븮��")){%>selected<%}%>> ��� ���Ǵ��Ǹ��� </option>
                            <option value='�����δ븮��'  <%if(gubun3.equals("�����δ븮��")){%>selected<%}%>> ��� �������Ǹ��� </option>
                            <option value='���ʹ븮��'   <%if(gubun3.equals("���ʹ븮��")){%>selected<%}%>> ��� ���ʹ븮�� </option>
                            <option value='�����δ븮��'  <%if(gubun3.equals("�����δ븮��")){%>selected<%}%>> ��� �����δ븮�� </option>
                            <option value='����븮��'   <%if(gubun3.equals("����븮��")){%>selected<%}%>> ��� ����븮�� </option>
                            <option value='������û������' <%if(gubun3.equals("������û������")){%>selected<%}%>> ���� ������û�� </option>
                        </select>
        	  </td>					
                    <td class=title width=10%>����</td>
                    <td>&nbsp;
            		<input type='text' name='gubun4' size='15' class='text' value='<%=gubun4%>' style='IME-MODE: active'>
        	  </td>					
                    <td class=title width=10%>����</td>
                    <td>&nbsp;
            		<select name='gubun5'>
                            <option value='' <%if(gubun5.equals("")){%>selected<%}%>> ��ü </option>
                            <option value='Y' <%if(gubun5.equals("Y")){%>selected<%}%>> ���� </option>
                            <option value='Y1' <%if(gubun5.equals("Y1")){%>selected<%}%>> ����-��� </option>
                            <option value='Y3' <%if(gubun5.equals("Y3")){%>selected<%}%>> ����-���� </option>
                            <option value='Y2' <%if(gubun5.equals("Y2")){%>selected<%}%>> ����-��� </option>
                            <option value='N' <%if(gubun5.equals("N")){%>selected<%}%>> ��� </option>
                            <option value='P' <%if(gubun5.equals("P")){%>selected<%}%>> ��� </option>
                        </select>
        	  </td>					        	          	  
                </tr>    	        
                <tr>
                    <td class=title width=10%>�˻�����</td>
                    <td width=22%>&nbsp;
            		<select name='s_kd'>
                            <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>> �����ȣ </option>
                            <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>> ��� </option>
                            <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>> ���� </option>
                            <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>> ������ </option>
                            <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>> ������ </option>
                        </select>
                        &nbsp;
            		<input type='text' name='t_wd' size='15' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>            		
        	  </td>
                    <td class=title width=10%>�Ⱓ</td>
                    <td width=33%>&nbsp;
            		<select name='gubun1'>
                            <option value='1' <%if(gubun1.equals("1")){%>selected<%}%>> ������� </option>
                            <option value='2' <%if(gubun1.equals("2")){%>selected<%}%>> ��������� </option>
                            <option value='3' <%if(gubun1.equals("3")){%>selected<%}%>> �������� </option>
                        </select>
                        &nbsp;
                        <select name='gubun2'>                          
                          <option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>����</option>
                          <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>����</option>
                          <option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>���</option>
                          <option value='4' <%if(gubun2.equals("4")){%>selected<%}%>>�Ⱓ </option>
                        </select>
                        &nbsp;
            		<input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                                ~ 
                        <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">      		
        	  </td>
                  <td class=title width=10%>��������</td>
                  <td>&nbsp;
        	      <select name='sort'>
                          <option value='1' <%if(sort.equals("1")){ %>selected<%}%>> ������� </option>
                          <option value='2' <%if(sort.equals("2")){%>selected<%}%>> ��������� </option>
                          <option value='3' <%if(sort.equals("3")){%>selected<%}%>> �����ȣ </option>
                      </select>
        	  </td>						
                </tr>
    	    </table>
        </td>
    </tr>
    <tr align="right">
        <td>
            <a href="javascript:search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
        </td>
    </tr>
</table>
</form>
</body>
</html>
