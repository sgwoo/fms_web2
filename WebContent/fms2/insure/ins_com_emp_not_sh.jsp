<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:AddUtil.parseInt(request.getParameter("sh_height"));//��ܱ���
%>

<html>
<head><title>FMS</title>
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	function search()
	{
		var fm = document.form1;
		if(fm.gubun1.value=='6'){
			if(fm.st_dt.value == '')				{	alert('��ȸ�Ⱓ�� �Է��Ͻʽÿ�');return;	}	
			if(fm.end_dt.value == '')				{	alert('��ȸ�Ⱓ�� �Է��Ͻʽÿ�');return;	}	
		}
		fm.target="c_foot";
		fm.action = "ins_com_emp_not_sc.jsp";
		document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->


//���÷��� Ÿ��(�˻�) - ��ȸ�Ⱓ ���ý�
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun1.options[fm.gubun1.selectedIndex].value == '6'){ //�Ⱓ��ȸ����
			text_input.style.display	= '';
		}else{
			text_input.style.display	= 'none';
			fm.st_dt.value='';
			fm.end_dt.value='';
		}
	}
	
	function list_excel_emp(){
		fm = document.form1;
		if(fm.s_kd.value!='9' && fm.gubun2.value!='D'){
			alert('���Ī���� ������ �ּ���');
			return;
		}
		window.open("about:blank",'list_excel','scrollbars=yes,status=yes,resizable=yes,width=1200,height=800,left=50,top=50');
		fm.target = "list_excel";
		fm.action = "ins_emp_excel.jsp";
		fm.submit();
	}		
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin=10 onload="javascript:document.form1.t_wd.focus();">

<form name='form1' action='ins_com_emp_not_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
<input type='hidden' name='br_id' 	value='<%=br_id%>'>
<input type='hidden' name='user_id' 	value='<%=user_id%>'>
<input type='hidden' name='sh_height' 	value='<%=sh_height%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>��� �� ���� > ������� > <span class=style5>����������̰�����Ȳ</span></span></td>
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
                    <td class=title width=10%>���踸����</td>
                    <td width=15%>&nbsp;
                        <select name="gubun1" onChange="javascript:cng_input1()">
                            <option value="" <%if(gubun1.equals("")){%>selected<%}%>>��ü</option>
                            <option value="4" <%if(gubun1.equals("4")){%>selected<%}%>>����15����</option>
                            <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>����30����</option>
                            <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>���</option>
			    <option value="3" <%if(gubun1.equals("3")){%>selected<%}%>>�Ϳ�</option>			    
			    <option value="5" <%if(gubun1.equals("5")){%>selected<%}%>>����</option>			
			    <option value="6" <%if(gubun1.equals("6")){%>selected<%}%>>�Ⱓ</option>    
                        </select><div id="text_input" style="display:none;">
                        &nbsp;&nbsp;<input type="text" name="st_dt" size="10" value="" class="text">
			~
			<input type="text" name="end_dt" size="10" value="" class="text">
        	    </div></td>		  		  
                    <td class=title width=10%>���Կ���</td>
                    <td width=10%>&nbsp;
                        <select name="gubun2">
                        		<option value="" <%if(gubun2.equals("")){%>selected<%}%>>��ü</option>
                            <option value="N" <%if(gubun2.equals("N")){%>selected<%}%>>�̰���</option>
                            <option value="Y" <%if(gubun2.equals("Y")){%>selected<%}%>>����</option>
                            <option value="D" <%if(gubun2.equals("Y")){%>selected<%}%>>���Ī</option>
                        </select>
        	    </td>		
        	    <td class=title width=10%>�˻�����</td>
                    <td width=25%>&nbsp;
        		<select name='s_kd'>                            
                            <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>��ȣ </option>
		            <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>����ڹ�ȣ</option>                            
		            <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>����ȣ </option>
                            <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>������ȣ </option>
                            <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>����</option>			  
                            <option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>���ʿ����� </option>
                            <option value='7' <%if(s_kd.equals("7")){%>selected<%}%>>��������� </option>
                            <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>���踸���� </option>
                            <option value='9' <%if(s_kd.equals("9")){%>selected<%}%>>�����뿩 </option>
                        </select>
        		&nbsp;
        		<input type='text' name='t_wd' size='35' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        	    </td>
        	    <td class=title width=10%>��������</td>
                    <td width=20%>&nbsp;
                        <select name="gubun3">
                        		<option value="" <%if(gubun3.equals("")){%>selected<%}%>>���������</option>
                            <option value="2" <%if(gubun3.equals("2")){%>selected<%}%>>���Ա���</option>
                        </select>
        	    </td>		  		    		  
                    
                </tr>
            </table>
	</td>
    </tr>  
    <tr align="right">
        <td>
        	<a href="javascript:list_excel_emp();"><img src=/acar/images/center/button_bhex.gif border=0 align=absmiddle></a>
        	<a href="javascript:search();"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>
</table>
</form>
</body>
</html>
