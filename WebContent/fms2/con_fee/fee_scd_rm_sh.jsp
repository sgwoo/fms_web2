<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 	= request.getParameter("asc")==null?"":request.getParameter("asc");
	String idx 	= request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		if(fm.st_dt.value != ''){ fm.st_dt.value = ChangeDate3(fm.st_dt.value);	}
		if(fm.end_dt.value != ''){ fm.end_dt.value = ChangeDate3(fm.end_dt.value);	}
		if(fm.st_dt.value !='' && fm.end_dt.value==''){ fm.end_dt.value = fm.st_dt.value; }		
		fm.submit()
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
		
	//���÷��� Ÿ��(�˻�)-������ȸ ���ý�
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '3'){ //�Ⱓ
			td_dt.style.display	 = '';
		}else{
			td_dt.style.display	 = 'none';
		}
	}		
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onload="javascript:document.form1.t_wd.focus();">
<form name='form1' action='fee_scd_rm_sc.jsp' target='c_body' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='f_list' value='scd'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������� > <span class=style5>����Ʈ�뿩�ὺ���ٰ���</span></span></td>
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
                    <td width='17%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_dygb.gif align=absmiddle>&nbsp;
                        <select name="gubun4">
                            <option value="1" <%if(gubun4.equals("1")){%>selected<%}%>>��ü</option>                            
                            <option value="3" <%if(gubun4.equals("3")){%>selected<%}%>>�����뿩</option>
                            <option value="4" <%if(gubun4.equals("4")){%>selected<%}%>>����뿩</option>				                            
                        </select>			
        		    </td>
                    <td width='14%'><img src=/acar/images/center/arrow_dryb.gif align=absmiddle>&nbsp;
                        <select name="gubun3">
                          <option value="1" <%if(gubun3.equals("1")){%>selected<%}%>>��ü</option>
                          <option value="2" <%if(gubun3.equals("2")){%>selected<%}%>>���</option>
                          <option value="3" <%if(gubun3.equals("3")){%>selected<%}%>>�̵��</option>
						  <option value="4" <%if(gubun3.equals("4")){%>selected<%}%>>���������</option>
                        </select></td>
                    <td width=14%><img src=/acar/images/center/arrow_ggjh.gif align=absmiddle>&nbsp;
                        <select name="gubun2" onChange="javascript:cng_input1()">
                            <option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>���</option>
                            <option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>����</option>
                            <option value="3" <%if(gubun2.equals("3")){%>selected<%}%>>�Ⱓ</option>
                            <option value="4" <%if(gubun2.equals("4")){%>selected<%}%>>�˻�</option>
                        </select></td>
                    <td width=16%>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td id='td_dt' <%if(gubun2.equals("3")){%>style="display:''"<%}else{%>style='display:none'<%}%>><input type='text' size='9' name='st_dt' class='text' value='<%=st_dt%>'>
                      			~
                        		<input type='text' size='9' name='end_dt' class='text' value="<%=end_dt%>">
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
                        <select name='s_kd'>
                            <option value='0' <%if(s_kd.equals("0")){%> selected <%}%>>��ü</option>
                            <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>��ȣ</option>
                            <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>����ȣ</option>
                            <option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>������ȣ</option>
                        </select>
                    </td>
                    <td> 
                        <input type='text' name='t_wd' size='19' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'></td>
                    <td><img src=/acar/images/center/arrow_jrjg.gif align=absmiddle>&nbsp;
                        <select name='sort_gubun' onChange='javascript:search()'>
                            <option value='0' <%if(sort_gubun.equals("0")){%> selected <%}%>>�뿩������</option>
                            <option value='1' <%if(sort_gubun.equals("1")){%> selected <%}%>>��ȣ</option>
                            <option value='2' <%if(sort_gubun.equals("2")){%> selected <%}%>>������ȣ</option>
							<option value='3' <%if(sort_gubun.equals("3")){%> selected <%}%>>�����������</option>
                        </select>
                    </td>
                    <td> 
                        <input type='radio' name='asc' value='0' checked onClick='javascript:search()'>
                        �������� 
                        <input type='radio' name='asc' value='1' onClick='javascript:search()'>
                        �������� </td>
                    <td><a href="javascript:search()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>
                </tr>
            </table>
        </td>
	</tr>
</table>
</form>
</body>
</html>