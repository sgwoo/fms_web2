<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"22":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"8":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?user_id:request.getParameter("t_wd");
	String s_bus = request.getParameter("s_bus")==null?"":request.getParameter("s_bus");
	String s_brch = request.getParameter("s_brch")==null?"":request.getParameter("s_brch");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");

	CommonDataBase c_db = CommonDataBase.getInstance();

		
					//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
				//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function enter(){
	var keyValue = event.keyCode;
	if (keyValue =='13') search();
}
function list_move()
	{
		var fm = document.form1;
		var url = "";
		
		var idx = fm.gubun1.options[fm.gubun1.selectedIndex].value;
		
		if(idx == '21') 		url = "/acar/cus0401/cus0401_s_frame.jsp";
		else if(idx == '22') 	url = "/acar/cus0402/cus0402_s_frame.jsp";
		else if(idx == '23') 	url = "/acar/cus0403/cus0403_s_frame.jsp";
		
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}
	//���÷��� Ÿ��(�˻�)-������ȸ ���ý�
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '4'){ //�Ⱓ
			td_dt.style.display	 = '';
			td_ec.style.display = 'none';
		}else{
			if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '5'){ //�˻�
				fm.gubun3.options[0].selected = true;
			}				
			td_dt.style.display	 = 'none';
			td_ec.style.display = 'none';
		}
	}
	//���÷��� Ÿ��(�˻�) -�˻����� ���ý�
	function cng_input(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'||
			fm.s_kd.options[fm.s_kd.selectedIndex].value == '10'||
			fm.s_kd.options[fm.s_kd.selectedIndex].value == '11'){ //���������		
			td_input.style.display	= 'none';
			td_bus.style.display	= '';
			td_brch.style.display	= 'none';			
		}else if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '6'){ //������
			td_input.style.display	= 'none';
			td_bus.style.display	= 'none';			
			td_brch.style.display	= '';
		}else if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '4'){ //������ȣ
			fm.gubun2.value = '5';
			td_input.style.display	= '';
			td_bus.style.display	= 'none';			
			td_brch.style.display	= 'none';						
		}else{
			td_input.style.display	= '';
			td_bus.style.display	= 'none';
			td_brch.style.display	= 'none';						
		}
	}
	
	function search(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'||
			fm.s_kd.options[fm.s_kd.selectedIndex].value == '10'||
			fm.s_kd.options[fm.s_kd.selectedIndex].value == '11'){ //���������
			fm.t_wd.value = fm.s_bus.options[fm.s_bus.selectedIndex].value;
		}
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '6'){ //������
			fm.t_wd.value = fm.s_brch.options[fm.s_brch.selectedIndex].value;
		}		
		if(fm.st_dt.value != ''){ fm.st_dt.value = ChangeDate3(fm.st_dt.value);	}
		if(fm.end_dt.value != ''){ fm.end_dt.value = ChangeDate3(fm.end_dt.value);	}
		if(fm.st_dt.value !='' && fm.end_dt.value==''){ fm.end_dt.value = fm.st_dt.value; }

		fm.submit();
	}
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='../cus0402/cus0402_s_sc.jsp' target='c_body'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table width="100%" border="0" cellspacing="1" cellpadding="0">
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������ > ������ > <span class=style5>���湮��ȸ</span></span></td>
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
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=19%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jhgb.gif  align=absmiddle>&nbsp; 
                      <select name="gubun1" onChange="javascript:list_move()">
                        <option value="22" <%if(gubun1.equals("22")){%>selected<%}%>>������</option>
                        <option value="21" <%if(gubun1.equals("21")){%>selected<%}%>>�ڵ�������</option>
                        <option value="23" <%if(gubun1.equals("23")){%>selected<%}%>>�������˻�</option>
                      </select></td>
                    <td width=13%><img src=/acar/images/center/arrow_ssjh.gif  align=absmiddle>&nbsp; 
                      <select name="gubun2" onChange="javascript:cng_input1()">
                        <option value="1" <%if(gubun2.equals("")||gubun2.equals("1")){%>selected<%}%>>���</option>
                        <option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>����</option>
        				<option value="3" <%if(gubun2.equals("3")){%>selected<%}%>>����</option>
                        <option value="4" <%if(gubun2.equals("4")){%>selected<%}%>>�Ⱓ</option>
        				<option value="5" <%if(gubun2.equals("5")){%>selected<%}%>>�˻�</option>
                      </select></td>
                    <td width=14%><img src=/acar/images/center/arrow_sbjh.gif  align=absmiddle>&nbsp; 
                      <select name="gubun3">
                        <option value="P" <%if(gubun3.equals("P")){%>selected<%}%>>��ü</option>
        				<option value="Y" <%if(gubun3.equals("Y")){%>selected<%}%>>�湮</option>
        				<option value="N" <%if(gubun3.equals("N")){%>selected<%}%>>����</option>              
                      </select></td>
                    <td align="left" width=16%> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td id='td_dt' <%if(gubun2.equals("4")){%>style="display:''"<%}else{%>style='display:none'<%}%>> 
                                <input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                                ~ 
                                <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>"> 
                                </td>
                                <td id='td_ec' <%if(gubun2.equals("3")){%>style="display:''"<%}else{%>style='display:none'<%}%>>&nbsp; 
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td>&nbsp; </td>
                </tr>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif  align=absmiddle>&nbsp; 
                      <select name='s_kd' onChange="javascript:document.form1.t_wd.value='', cng_input()">
                        <option value='0' <%if(s_kd.equals("0")){%> selected <%}%>>��ü</option>
                        <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>��ȣ</option>
                        <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>����</option>
                        <option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>����ȣ</option>
                        <option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>������ȣ</option>
                        <option value='9' <%if(s_kd.equals("9")){%> selected <%}%>>����</option>
                        <option value='5' <%if(s_kd.equals("5")){%> selected <%}%>>�����ȣ</option>
                        <option value='6' <%if(s_kd.equals("6")){%> selected <%}%>>�������ڵ�</option>
                        <option value='7' <%if(s_kd.equals("7")){%> selected <%}%>>��뺻����</option>
                        <option value='8' <%if(s_kd.equals("8")){%> selected <%}%>>���������</option>
        				<option value='10' <%if(s_kd.equals("10")){%> selected <%}%>>���������</option>
        				<option value='11' <%if(s_kd.equals("11")){%> selected <%}%>>���ʿ�����</option>				
                      </select></td>
                    <td> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td id='td_input' <%if(s_kd.equals("10") ||s_kd.equals("8") || s_kd.equals("6")){%> style='display:none'<%}%>> 
                                <input type='text' name='t_wd' size='17' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'> 
                              </td>
                              <td id='td_bus' <%if(s_kd.equals("10") ||s_kd.equals("8")){%> style="display:''"<%}else{%>style='display:none'<%}%>> 
                                <select name='s_bus'>
                                   <%if(user_size > 0){
            							for(int i = 0 ; i < user_size ; i++){
            								Hashtable user = (Hashtable)users.elementAt(i); 
            						%>
            		          				     <option value='<%=user.get("USER_ID")%>' <%if(s_bus.equals(user.get("USER_ID"))||t_wd.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
            		                <%	}
            						}		%>
            					</select> </td>
                                
                            
                              <td id='td_brch' <%if(s_kd.equals("6")){%> style="display:''"<%}else{%>style='display:none'<%}%>> 
                                <select name='s_brch' onChange='javascript:search();'>
                                  <option value=''>��ü</option>
                                  <%Vector branches = c_db.getBranchList(); //������ ����Ʈ ��ȸ
            						int brch_size = branches.size();					  
            					  	if(brch_size > 0){
            								for (int i = 0 ; i < brch_size ; i++){
            									Hashtable branch = (Hashtable)branches.elementAt(i);%>
                                  <option value='<%= branch.get("BR_ID") %>'  <%if(s_brch.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
                                  <%= branch.get("BR_NM")%> </option>
                                  <%		}
            							}		%>
                                </select> </td>
                            </tr>
                        </table>
                    </td>
                    <td><img src=/acar/images/center/arrow_jrjg.gif  align=absmiddle>&nbsp;  
                      <select name='sort_gubun' onChange='javascript:search()'>
                        <option value='0' <%if(sort_gubun.equals("0")){%> selected <%}%>>������</option>
                        <option value='1' <%if(sort_gubun.equals("1")){%> selected <%}%>>��ȣ</option>
                        <option value='2' <%if(sort_gubun.equals("2")){%> selected <%}%>>�����</option>
        				<option value='4' <%if(sort_gubun.equals("4")){%> selected <%}%>>�ֱٹ湮����</option>
        			  	<option value='5' <%if(sort_gubun.equals("")||sort_gubun.equals("5")){%> selected <%}%>>�湮��������</option>
                      </select> </td>
                    <td>&nbsp;<input type='radio' name='asc' value='asc' checked onClick='javascript:search()'>
                      �������� 
                      <input type='radio' name='asc' value='desc' onClick='javascript:search()'>
                      �������� </td>
                    <td><a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
<script language="JavaScript">
<!--
	//search();
	cng_input();
//-->
</script>
