<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">

<script language='javascript'>
<!--
	function search()
	{
	  //���� ����Ÿ ��������
	   var fm = document.form1;	   	  
	  
	   if (fm.s_kd.value != '5') {
	     	     
	     if (fm.t_wd.value == '') {
	     	alert("�˻������� �Է��ϼž� �մϴ�.")
	     	return;
	     }
	     
	   } 
	    document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	
	function reg()
	{
	  //���� ����Ÿ ��������
	   var fm = document.form1;	   	  
	 
	 	fm.action='cms_req_reg_frame.jsp';	

		fm.target='d_content';
		fm.submit();
		 
	 
	}
//-->
</script>
</head>
<body onload="javascript:document.form1.t_wd.focus();" leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"5":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup ��û�� ������
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
%>
<form name='form1' action='/fms2/cms/cms_req_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > �Աݰ��� > <span class=style5>CMS �����û���</span></span></td>
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
        <td align="right"></td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td colspan="2" class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>�˻�����</td>
                    <td width=30%>&nbsp;
            		    <select name='s_kd'>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>��ȣ </option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>����ȣ </option>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>������ȣ </option>
                          <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>��û���� </option>
                          
                        
                        </select>
        			    &nbsp;&nbsp;&nbsp;
        			    <input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        		    </td>
        		    <td class=title width=10%>����</td>
                    <td width=15%>&nbsp;
            		  <select name='andor'>
            		      <option value=''  <%if(andor.equals("")){ %>selected<%}%>>--��ü--</option>
            		      <option value='N' <%if(andor.equals("N")){%>selected<%}%>>��ó��</option> 
                      <option value='Y' <%if(andor.equals("Y")){%>selected<%}%>>ó��</option>                        
                                                            
                      </select>
        			</td>		  	
              
                </tr>
            </table>
	    </td>
    </tr>  
    
    <tr align="right">
        <td colspan="2">
	    <a href="javascript:search();"><img src="/acar/images/center/button_search.gif"  border="0" align=absmiddle></a>
	  <!--    <a href="javascript:reg();"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></a> -->
	    </td>
    </tr>
</table>
</form>
</body>
</html>
