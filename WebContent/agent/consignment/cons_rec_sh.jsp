<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*,acar.user_mng.*"%>
<%@ include file="/agent/cookies.jsp" %> 

<%
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
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body <%if(white.equals("")){%>onload="javascript:document.form1.t_wd.focus();"<%}%> leftmargin=15 >
<form name='form1' action='/agent/consignment/cons_rec_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  	<tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > Ź�۰��� > <span class=style5>Ź�۹̼�����Ȳ</span></span></td>
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
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td colspan="2" class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>�Ⱓ</td>
                    <td>&nbsp;
        			  <select name='gubun3'>
                        <option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>��û����</option>				
                        <option value='2' <%if(gubun3.equals("2")){%>selected<%}%>>�Ƿ�����</option>				
                      </select>
                	  <select name='gubun2'>
                        <option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>���</option>
                        <option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>����</option>
                        <option value='4' <%if(gubun2.equals("4")){%>selected<%}%>>����</option>
                        <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>�Ⱓ </option>
                      </select>
                	  <input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                      ~ 
                      <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
                	</td>
                    <td class=title width=10%>Ź�۾�ü</td>
                    <td width=40%>&nbsp;
        		      <select name='gubun1'>
        			    <%if(user_id.equals("000094")){%>
                        <option value='�ڸ���Ź��' 		 <%if(gubun1.equals("�ڸ���Ź��")){%>selected<%}%>>�ڸ���Ź��</option>
						<%}else if(user_id.equals("000223")){%>			  
                        <option value='(��)�Ƹ���Ź��'       		 <%if(gubun1.equals("(��)�Ƹ���Ź��")){%>selected<%}%>>(��)�Ƹ���Ź��</option>	
        			    <%}else if(user_id.equals("000095")){%>			  
                        <option value='����'       		 <%if(gubun1.equals("����")){%>selected<%}%>>      ����</option>			  
        			    <%}else if(user_id.equals("000109")){%>			  
                        <option value='����Ƽ����' 		 <%if(gubun1.equals("����Ƽ����")){%>selected<%}%>>����Ƽ����</option>			  				
        			    <%}else if(user_id.equals("000127")){%>			  
                        <option value='�ڸ���Ź��(�λ�)' <%if(gubun1.equals("�ڸ���Ź��(�λ�)")){%>selected<%}%>>�ڸ���Ź��(�λ�)</option>
        			    <%}else if(user_id.equals("000139")){%>			  
                        <option value='����ī��'   		<%if(gubun1.equals("����ī��")){%>selected<%}%>>����ī��</option>		
						<%}else if(user_id.equals("000147")){%>			  
                        <option value='�����ɸ���'   	<%if(gubun1.equals("�����ɸ���")){%>selected<%}%>>�����ɸ���</option>								
                        <%}else if(user_id.equals("000328")){%>			  
                        <option value='�۽�Ʈ����̺�'   	<%if(gubun1.equals("�۽�Ʈ����̺�")){%>selected<%}%>>�۽�Ʈ����̺�</option>
        			    <%}else{%>
        			    <option value='' >��ü</option>
        				<option value='�Ƹ���ī'   		 <%if(gubun1.equals("�Ƹ���ī"))		{%>selected<%}%>>�Ƹ���ī</option>
						<option value='(��)�Ƹ���Ź��'       	 <%if(gubun1.equals("(��)�Ƹ���Ź��"))			{%>selected<%}%>>(��)�Ƹ���Ź��</option>
                        <option value='�ڸ���Ź��' 		 <%if(gubun1.equals("�ڸ���Ź��"))		{%>selected<%}%>>�ڸ���Ź��</option>
                        <option value='����'       		 <%if(gubun1.equals("����"))			{%>selected<%}%>>����</option>
                        <option value='�ڸ���Ź��(�λ�)' <%if(gubun1.equals("�ڸ���Ź��(�λ�)")){%>selected<%}%>>�ڸ���Ź��(�λ�)</option>						
						<option value='����ī��'   		 <%if(gubun1.equals("����ī��"))	{%>selected<%}%>>����ī��</option>	
						<option value='�����ɸ���'   	 <%if(gubun1.equals("�����ɸ���")){%>selected<%}%>>�����ɸ���</option>									
        				<option value='����Ƽ����' 		 <%if(gubun1.equals("����Ƽ����"))		{%>selected<%}%>>����Ƽ����</option>			  
        				<option value='������TS'   	<%if(gubun1.equals("������TS")){%>selected<%}%>>������TS</option>
        				<option value=�۽�Ʈ����̺�   	<%if(gubun1.equals("�۽�Ʈ����̺�")){%>selected<%}%>>�۽�Ʈ����̺�</option>	
        			    <%}%>
                      </select>
                	</td>
                </tr>	  
                <tr>
                    <td class=title width=10%>�˻�����</td>
                    <td>&nbsp;
                	  <select name='s_kd'>
               <!--         <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>���� </option> -->
                        <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>�Ƿ���</option>
                <!--        <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>����</option>
                        <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>����/�����ȣ</option>
                        <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>���/������� </option>		 -->		
                      </select>
                	  &nbsp;&nbsp;&nbsp;
                	  <input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
                	</td>
                    <td class=title width=10%>��������</td>
                    <td>&nbsp;
                	  <select name='sort'>
                        <option value='1' <%if(sort.equals("1")){%>selected<%}%>>���� </option>
                        <option value='2' <%if(sort.equals("2")){%>selected<%}%>>�Ƿ���</option>
                        <option value='6' <%if(sort.equals("6")){%>selected<%}%>>��û���� </option>
                        <option value='7' <%if(sort.equals("7")){%>selected<%}%>>�Ƿ����� </option>								
                      </select>
                	</td>
                </tr>
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td colspan="2"><%if(white.equals("")){%><a href="javascript:search();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif" align="absbottom" border="0"></a> <%}%></td>
    </tr>
</table>
</form>
</body>
</html>
