<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//�α���ID&������ID&����
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "09");
	
	String s_kd 	= request.getParameter("s_kd")==null?"5":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

$(document).ready(function(){
	
	parkAreaSetting();
	$('#brid').bind('change', function(){
		parkAreaSetting();
	});
});

//�˻��ϱ�
	function search(){
		var fm = document.form1;		
		fm.action = 'park_s_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
	
	function search2(){
		var fm = document.form1;		
		fm.action = "park_frame2.jsp";
		fm.target='d_content';
		fm.submit();
	}
	function save2(){
		var fm = document.form1;	
		if(!confirm('���� �Ͻðڽ��ϱ�?')){	
			return;	
		}
		fm.action = 'park_condition_save_a.jsp';						
		fm.target = 'i_no';
		fm.submit();	
	}
	
	//������������ ������ ���� ����ȭ
	function parkAreaSetting(){
		var area_type1 = "";
		var area_type2 = "";
		area_type1 += '<option value=""selected>��ü</option>		<OPTION VALUE="A" >A�� ����</option>' +
					  '<OPTION VALUE="B" >B�� ����</option>		<OPTION VALUE="C" >C�� ����</option>' +
					  '<OPTION VALUE="D" >D�� ����</option>		<OPTION VALUE="E" >E�� ����</option>' +
					  '<OPTION VALUE="F" >F�� ����</option>		<OPTION VALUE="G" >G�� ����</option>' +
					  '<OPTION VALUE="H" >H�� ����</option>';
	    area_type2 += '<option value=""selected>����</option>		<OPTION VALUE="3A" >3��A����</option>' +
	  				  '<OPTION VALUE="3B" >3��B����</option>		<OPTION VALUE="3C" >3��C����</option>' +
		  			  '<OPTION VALUE="4A" >4��A����</option>		<OPTION VALUE="4B" >4��B����</option>' +
					  '<OPTION VALUE="4C" >4��C����</option>		<OPTION VALUE="5A" >5��A����</option>' +
					  '<OPTION VALUE="5B" >5��B����</option>		<OPTION VALUE="5C" >5��C����</option>' +
					  '<OPTION VALUE="F" >F����</option>			<OPTION VALUE="G" >G����</option>' +		
					  '<OPTION VALUE="H" >H����</option>';
					  
		if($("#brid").val()=="1"){	$("#gubun1").html(area_type2);	}
		else{						$("#gubun1").html(area_type1);	}
		
	}
//-->
</script>
</head>
<body leftmargin="15" >
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr> 
        <td colspan=5>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <!-- <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ý��� > ���������� > <span class=style5>��������Ȳ</span></span></td> -->
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ���������� > <span class=style5>��������Ȳ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<tr> 
		<td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp; 
			<select name='s_kd'>				
			<option value='1' selected >������ȣ</option>
			<option value='4'>����</option>
			</select>
			
			<input type='text' name='t_wd' size='20' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
			&nbsp;
			<select name='gubun'>				
			<option value='' selected >��ü</option>
			<option value='Y'>������</option>
			</select>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jrjg.gif align=absmiddle> &nbsp; 
        <select name='sort_gubun'>
			<option value='5'>����</option>
			<option value='1'>������ȣ</option>
			<option value='4'>����</option>
			<option value='3'>��ⷮ</option>
			<option value='2'>���ʵ����</option>
        </select>
        <select name='asc'>
          <option value="asc">��������</option>
          <option value="desc">��������</option>
        </select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jj.gif align=absmiddle>
		<select name='brid' id="brid">
			<!-- <option value=""<%if(br_id.equals(""))%>selected<%%>>��ü</option> -->
			<option value="1"<%if(brid.equals("1"))%>selected<%%>>����</option>
			<option value="3"<%if(brid.equals("3"))%>selected<%%>>�λ�</option>
			<option value="4"<%if(brid.equals("4"))%>selected<%%>>����</option>
			<option value="5"<%if(brid.equals("5"))%>selected<%%>>����</option>
			<option value="6"<%if(brid.equals("6"))%>selected<%%>>�뱸</option>
			<option value="7"<%if(brid.equals("7"))%>selected<%%>>������</option>
        </select>
		<%if(brid.equals("1")){%>
		<select name='gubun1' id="gubun1">
			<option value=''>��ü</option>
			<option value='A'>A�� ����</option>
			<option value='B'>B�� ����</option>
			<option value='C'>C�� ����</option>
			<option value='D'>D�� ����</option>
			<option value='E'>E�� ����</option>
        </select>
		<%}%>
      &nbsp;<a href="javascript:search(<%=brid%>)" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a></td>
		</td>

	</tr>
    <tr>
    	<td class="h"></td>
	</tr>
</table>
</form> 
</body>
</html>

