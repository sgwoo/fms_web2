<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//���� ����
	CodeBean[] fuels = c_db.getCodeAll("0039");
	int fuels_size = fuels.length;
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript'>
	
	function popup(url)
	{
		var fm = document.form1;
		
		if(url=='inside_req_list9.jsp'){
			url = url+'?start_dt='+fm.start_dt9.value+'&end_dt='+fm.end_dt9.value;
		}
		fm.target = '_blank';
		fm.action = url;
		fm.submit();
	}	
	
	function popup2(url, s_var)
	{
		var fm = document.form1;
		fm.s_var.value = s_var;		
		fm.target = '_blank';
		fm.action = url;
		fm.submit();
	}
	
	function go_list1_excel(){	
		popup('inside_req_list1_excel.jsp');
	}		
	
	function go_list3()
	{	
		var start_dt = $("#start_dt").val();
		var end_dt = $("#end_dt").val();
		if((start_dt !="" && end_dt !="" && (start_dt > end_dt)) || (start_dt!="" && start_dt.length!=8) || (end_dt!="" && end_dt.length!=8)){
			alert("��ȸ�Ⱓ�� ��Ȯ�� �Է����ּ���. ");
			return false;
		}else{
			popup('inside_req_list3.jsp?start_dt='+start_dt+'&end_dt='+end_dt);
		}
	}
	
	function OnList3Alert(){
		$("#alert_span3").css("display","block");
	}
	
	function OffList3Alert(){
		$("#alert_span3").css("display","none");
	}

	function go_list7()
	{	
		var start_dt = $("#start_dt7").val();
		var end_dt = $("#end_dt7").val();
		if((start_dt !="" && end_dt !="" && (start_dt > end_dt)) || (start_dt!="" && start_dt.length!=8) || (end_dt!="" && end_dt.length!=8)){
			alert("��ȸ�Ⱓ�� ��Ȯ�� �Է����ּ���. ");
			return false;
		}else{
			popup('inside_req_list7.jsp?start_dt='+start_dt+'&end_dt='+end_dt);
		}
	}
	
	function go_list8(){	
		var start_dt = $("#start_dt8").val();
		var end_dt = $("#end_dt8").val();
		if((start_dt !="" && end_dt !="" && (start_dt > end_dt)) || (start_dt!="" && start_dt.length!=8) || (end_dt!="" && end_dt.length!=8)){
			alert("��ȸ�Ⱓ�� ��Ȯ�� �Է����ּ���. ");
			return false;
		}else{
			popup('inside_req_list8.jsp?start_dt='+start_dt+'&end_dt='+end_dt);
		}
	}
	
	function go_list8_2(){	
		var start_dt = $("#start_dt8_2").val();
		var end_dt = $("#end_dt8_2").val();
		var jg_code = $("#jg_code8_2").val();
		var car_nm = $("#car_nm8_2").val();
		if((start_dt !="" && end_dt !="" && (start_dt > end_dt)) || (start_dt!="" && start_dt.length!=8) || (end_dt!="" && end_dt.length!=8)){
			alert("��ȸ�Ⱓ�� ��Ȯ�� �Է����ּ���. ");
			return false;
		}else{
			popup('inside_req_list8_2.jsp?start_dt='+start_dt+'&end_dt='+end_dt+'&jg_code='+jg_code+'&car_nm='+car_nm);
		}
	}
	


	
	function go_list8_2_excel(){	
		var start_dt = $("#start_dt8_2").val();
		var end_dt = $("#end_dt8_2").val();
		var jg_code = $("#jg_code8_2").val();
		var car_nm = $("#car_nm8_2").val();
		if((start_dt !="" && end_dt !="" && (start_dt > end_dt)) || (start_dt!="" && start_dt.length!=8) || (end_dt!="" && end_dt.length!=8)){
			alert("��ȸ�Ⱓ�� ��Ȯ�� �Է����ּ���. ");
			return false;
		}else{
			popup('inside_req_list8_2_excel.jsp?start_dt='+start_dt+'&end_dt='+end_dt+'&jg_code='+jg_code+'&car_nm='+car_nm);
		}
	}	
	
	function go_list10(){	
		var start_dt = $("#start_dt10").val();
		var end_dt = $("#end_dt10").val();
		if((start_dt !="" && end_dt !="" && (start_dt > end_dt)) || (start_dt!="" && start_dt.length!=8) || (end_dt!="" && end_dt.length!=8)){
			alert("��ȸ�Ⱓ�� ��Ȯ�� �Է����ּ���. ");
			return false;
		}else{
			popup('inside_req_list10.jsp?start_dt='+start_dt+'&end_dt='+end_dt);
		}
	}
	function go_list11(){	
		var start_dt = $("#start_dt11").val();
		var end_dt = $("#end_dt11").val();
		if((start_dt !="" && end_dt !="" && (start_dt > end_dt)) || (start_dt!="" && start_dt.length!=8) || (end_dt!="" && end_dt.length!=8)){
			alert("��ȸ�Ⱓ�� ��Ȯ�� �Է����ּ���. ");
			return false;
		}else{
			popup('inside_req_list11.jsp?start_dt='+start_dt+'&end_dt='+end_dt);
		}
	}
	function go_list12(){	
		var start_dt = $("#start_dt12").val();
		var end_dt = $("#end_dt12").val();
		var fuel_kd = $("#fuel_kd").val();
		if((start_dt !="" && end_dt !="" && (start_dt > end_dt)) || (start_dt!="" && start_dt.length!=8) || (end_dt!="" && end_dt.length!=8)){
			alert("��ȸ�Ⱓ�� ��Ȯ�� �Է����ּ���. ");
			return false;
		}else{
			popup('inside_req_list12.jsp?start_dt='+start_dt+'&end_dt='+end_dt+'&fuel_kd='+fuel_kd);
		}
	}
	function go_list13(){	
		var start_dt = $("#start_dt13").val();
		var car_nm = $("#car_nm13").val();
		if(start_dt == "" || car_nm == ""){
			alert("�������̳� ������ �Է����ּ���. ");
			return false;
		}else{
			popup('inside_req_list13.jsp?start_dt='+start_dt+'&car_nm='+car_nm);
		}
	}
	
	
	function OnList8Alert(){		$("#alert_span8").css("display","block");			}
	
	function OffList8Alert(){		$("#alert_span8").css("display","none");			}
	
	function OnList8_2Alert(){	$("#alert_span8_2").css("display","block");		}
	
	function OffList8_2Alert(){	$("#alert_span8_2").css("display","none");		}

	function OnList10Alert(){		$("#alert_span10").css("display","block");			}
	
	function OffList10Alert(){		$("#alert_span10").css("display","none");			}
	
	function OnList11Alert(){		$("#alert_span11").css("display","block");			}
	
	function OffList11Alert(){		$("#alert_span11").css("display","none");			}
	
	function OnList12Alert(){		$("#alert_span12").css("display","block");			}
	
	function OffList12Alert(){		$("#alert_span12").css("display","none");			}
	
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_var' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>

	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ADMIN > <span class=style5>���ο�û�ڷ�</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. �������⺻���� (������) - <b>�м�</b>
	       &nbsp;&nbsp;<a href="javascript:popup('inside_req_list1.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>	
       <%if(ck_acar_id.equals("000029")){ %>
	    &nbsp;&nbsp;<a href="javascript:go_list1_excel()"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>
	    <%} %>	   
	</td>
	</tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
	<tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. ������ �������� 
	       &nbsp;&nbsp;<a href="javascript:popup('inside_req_list2.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		   
	</td>
	</tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
	<tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. ����������������Ʈ 
		&nbsp;&nbsp;
		<span>
	    	<input id="start_dt" type="text" size="10" placeholder="ex) <%=AddUtil.getDate(4)%>"> ~ <input id="end_dt" type="text" size="10" placeholder="ex) <%=AddUtil.getDate(4)%>">
	    </span>
	    <!-- &nbsp;&nbsp;<a href="javascript:popup('inside_req_list3.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a> -->		   
	    &nbsp;&nbsp;<a href="javascript:go_list3()" onmouseover="OnList3Alert();" onmouseout="OffList3Alert();"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
	    &nbsp;&nbsp;
	    <span id="alert_span3" style="display: none; color: red; margin-left: 50px;">
	    	<br>�Ⱓ�� �� �� �� �ѳ��� �Է��ϼŵ� ��ȸ�����մϴ�. ���Է½� ��� �����Ͱ� ��ȸ�˴ϴ�.
	    	<br>�Ⱓ�� �а� �Է½� �������� ���� ������ �������� ���� �������ų� ����� ���� �۵����� ���� �� �ֽ��ϴ�.
	    </span>
	</td>
  </tr>  
  <tr>
	<td>&nbsp;</td>
  </tr>
  
	<tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4. ������ ��������(�ڵ���ȸ��,�����ȣ,����)
	       &nbsp;&nbsp;<a href="javascript:popup('inside_req_list4.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		   
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  
	<tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;7. ��ü��Ȳ�м�ǥ
		&nbsp;&nbsp;
		<span>
	    	<input id="start_dt7" name="start_dt7" type="text" size="10" placeholder="ex) <%=AddUtil.getDate(4)%>"> ~ <input id="end_dt7" name="end_dt7" type="text" size="10" placeholder="ex) <%=AddUtil.getDate(4)%>">
	    </span>	    
	    &nbsp;&nbsp;<a href="javascript:go_list7()"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;8. ���������������Ʈ (��������)
		&nbsp;&nbsp;
		<span>
	    	<input id="start_dt8" type="text" size="10" placeholder="ex) <%=AddUtil.getDate(4)%>"> ~ <input id="end_dt8" type="text" size="10" placeholder="ex) <%=AddUtil.getDate(4)%>">
	    </span>
	    &nbsp;&nbsp;<a href="javascript:go_list8()" onmouseover="OnList8Alert();" onmouseout="OffList8Alert();"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
	    &nbsp;&nbsp;
	    <span id="alert_span8" style="display: none; color: red; margin-left: 50px;">
	    	<br>�Ⱓ�� �� �� �� �ѳ��� �Է��ϼŵ� ��ȸ�����մϴ�. ���Է½� ��� �����Ͱ� ��ȸ�˴ϴ�.
	    	<br>�Ⱓ�� �а� �Է½� �������� ���� ������ �������� ���� �������ų� ����� ���� �۵����� ���� �� �ֽ��ϴ�.
	    </span>
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;8_2. ���������������Ʈ (����+�������)
		&nbsp;&nbsp;
		<span>
	    	<input id="start_dt8_2" type="text" size="10" placeholder="ex) <%=AddUtil.getDate(4)%>"> ~ <input id="end_dt8_2" type="text" size="10" placeholder="ex) <%=AddUtil.getDate(4)%>">
	    	�����ڵ� : <input id="jg_code8_2" type="text" size="10" placeholder="ex) 2154">
	    	���� : <input id="car_nm8_2" name="car_nm" type="text" size="10" placeholder="ex) ��3">
	    </span>
	    &nbsp;&nbsp;<a href="javascript:go_list8_2()" onmouseover="OnList8_2Alert();" onmouseout="OffList8_2Alert();"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
	    <%if(ck_acar_id.equals("000029")){ %>
	    &nbsp;&nbsp;<a href="javascript:go_list8_2_excel()" onmouseover="OnList8_2Alert();" onmouseout="OffList8_2Alert();"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>
	    <%} %>
	    &nbsp;&nbsp;
	    <span id="alert_span8_2" style="display: none; color: red; margin-left: 50px;">
	    	<br>�Ⱓ�� �� �� �� �ѳ��� �Է��ϼŵ� ��ȸ�����մϴ�. ���Է½� ��� �����Ͱ� ��ȸ�˴ϴ�.
	    	<br>�Ⱓ�� �а� �Է½� �������� ���� ������ �������� ���� �������ų� ����� ���� �۵����� ���� �� �ֽ��ϴ�.
	    </span>
	</td>
  </tr>  
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;9. ������������Ȳ 
		&nbsp;&nbsp;
		<span>
	    	<input id="start_dt9" type="text" size="10" placeholder="ex) <%=AddUtil.getDate(4)%>"> ~ <input id="end_dt9" type="text" size="10" placeholder="ex) <%=AddUtil.getDate(4)%>">
	    </span>
	    &nbsp;&nbsp;<a href="javascript:popup('inside_req_list9.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
	</td>
  </tr>  
  <tr>
	<td>&nbsp;</td>
  </tr>    
  
    <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10. �縮�������������Ʈ 
		&nbsp;&nbsp;
		<span>
	    	<input id="start_dt10" type="text" size="10" placeholder="ex) <%=AddUtil.getDate(4)%>"> ~ <input id="end_dt10" type="text" size="10" placeholder="ex) <%=AddUtil.getDate(4)%>">
	    </span>
	    &nbsp;&nbsp;<a href="javascript:go_list10()" onmouseover="OnList10Alert();" onmouseout="OffList10Alert();"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
	    &nbsp;&nbsp;
	    <span id="alert_span10" style="display: none; color: red; margin-left: 50px;">
	    	<br>�Ⱓ�� �� �� �� �ѳ��� �Է��ϼŵ� ��ȸ�����մϴ�. ���Է½� ��� �����Ͱ� ��ȸ�˴ϴ�.
	    	<br>�Ⱓ�� �а� �Է½� �������� ���� ������ �������� ���� �������ų� ����� ���� �۵����� ���� �� �ֽ��ϴ�.
	    </span>
	</td>
  </tr>  
  
  <tr>
	<td>&nbsp;</td>
  </tr>
   <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;11. ��ų�����������Ʈ 
		&nbsp;&nbsp;
		<span>
	    	<input id="start_dt11" type="text" size="10" placeholder="ex) <%=AddUtil.getDate(4)%>"> ~ <input id="end_dt11" type="text" size="10" placeholder="ex) <%=AddUtil.getDate(4)%>">
	    </span>
	    &nbsp;&nbsp;<a href="javascript:go_list11()" onmouseover="OnList11Alert();" onmouseout="OffList11Alert();"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
	    &nbsp;&nbsp;
	    <span id="alert_span11" style="display: none; color: red; margin-left: 50px;">
	    	<br>�Ⱓ�� �� �� �� �ѳ��� �Է��ϼŵ� ��ȸ�����մϴ�. ���Է½� ��� �����Ͱ� ��ȸ�˴ϴ�.
	    	<br>�Ⱓ�� �а� �Է½� �������� ���� ������ �������� ���� �������ų� ����� ���� �۵����� ���� �� �ֽ��ϴ�.
	    </span>
	</td>
  </tr>  
   <tr>
	<td>&nbsp;</td>
  </tr>
   <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;12. ������ ���Ằ ��������
		&nbsp;&nbsp;
		<span>
	    	<input id="start_dt12" type="text" size="10" placeholder="ex) <%=AddUtil.getDate(4)%>"> ~ <input id="end_dt12" type="text" size="10" placeholder="ex) <%=AddUtil.getDate(4)%>">
	    </span>
	    &nbsp;&nbsp;
	    <span>
			<select name="fuel_kd" id="fuel_kd">
			  <option value="">���ἱ��</option>
			<%	for(int i = 0 ; i < fuels_size ; i++){
					CodeBean fuel = fuels[i];
					if(fuel.getUse_yn().equals("Y")){
			%>
			   <option value='<%= fuel.getNm_cd()%>'><%= fuel.getNm()%></option>
			<%}}%>
			 
			</select>
	    </span>
	    &nbsp;&nbsp;<a href="javascript:go_list12()" onmouseover="OnList12Alert();" onmouseout="OffList12Alert();"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
	    &nbsp;&nbsp;
	    <span id="alert_span11" style="display: none; color: red; margin-left: 50px;">
	    	<br>�Ⱓ�� �� �� �� �ѳ��� �Է��ϼŵ� ��ȸ�����մϴ�. ���Է½� ��� �����Ͱ� ��ȸ�˴ϴ�.
	    	<br>�Ⱓ�� �а� �Է½� �������� ���� ������ �������� ���� �������ų� ����� ���� �۵����� ���� �� �ֽ��ϴ�.
	    </span>
	</td>
  </tr>   
  
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;13. ������������Ʈ (������+��������) - ������� �����
		&nbsp;&nbsp;
		<span>
	    	<input id="start_dt13" type="text" size="10" placeholder="ex) <%=AddUtil.getDate(4)%>"> ���� 	
	    	���� : <input id="car_nm13" name="car_nm13" type="text" size="20" placeholder="ex) ���׽ý� G90 (RS4)">
	    </span>
	    &nbsp;&nbsp;<a href="javascript:go_list13()" ><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
	</td>
  </tr>  
    
  <tr>
	<td>&nbsp;</td>
  </tr>
  
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
