<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*,acar.car_office.*"%>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarOfficeDatabase cod   = CarOfficeDatabase.getInstance();
	
	//�ڵ���ȸ�� ����Ʈ
	CarCompBean cc_r [] = cod.getCarCompAll_Esti();

	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String sort_fuel 	= request.getParameter("sort_fuel")	==null?"":request.getParameter("sort_fuel");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String gubun6 		= request.getParameter("gubun6")	==null?"":request.getParameter("gubun6");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");

	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	//�α���ID&������ID&����
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = umd.getXmlMaMenuAuth(user_id, "07", "04", "13");
	
%>

<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�˻��ϱ�
	function search(){
		var fm = document.form1;
		//fm.t_wd.value = replaceString("&","AND",fm.t_wd.value);
		fm.action = 'recall_send_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	//�˻��� �����ϱ�
	function chg_sch_form(val){ 
		if(val=='1'){
			$('#div_sch_fm1').css('display','block');
			$('#div_sch_fm2, #div_sch_fm3').css('display','none');
		}else if(val=='2'||val=='3'){
			$('#div_sch_fm2').css('display','block');
			$('#div_sch_fm1, #div_sch_fm3').css('display','none');
		}else if(val=='4'){
			$('#div_sch_fm3').css('display','block');
			$('#div_sch_fm1, #div_sch_fm2').css('display','none');
		}
	}
	//������ �����ϱ�(20190305)
	function sort_fuel_form(val){
		var fm = document.form1;
		if(val=='3'){
			fm.sort_fuel.style.display = '';
		}else{
			fm.sort_fuel.style.display = 'none';
		}
	}
	
//-->
</script>
</head>
<body onload="javascript:document.form1.gubun2.focus();">
<form name='form1' method='post'>
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>
	<input type='hidden' name='br_id' 		value='<%=br_id%>'>
	<input type='hidden' name='sh_height' 	value='<%=sh_height%>'> 
	<div class="navigation" style="margin-bottom:0px !important">
		<span class="style1">FMS����� > SMS �� �̸��� > </span><span class="style5">���ݾȳ������Ϲ߼�</span>
	</div>
	<div class="search-area" style="margin:0px 10px;">
		<table width="100%">
			<tr>
				<td>
					<label><i class="fa fa-check-circle"></i> ������</label>
				</td>
				<td>
					<select name="gubun1" id="car_comp_id" class="select">
					<%for(int i=0; i<cc_r.length; i++){
						cc_bean = cc_r[i];	%>
						<option value="<%= cc_bean.getCode() %>" <%if(cc_bean.getCode().equals(gubun1))%>selected<%%>><%= cc_bean.getNm() %></option>
					<%}	%>
					</select>
				</td>
				<td>
					<label><i class="fa fa-check-circle"></i> ����</label>
				</td>
				<td>
					<input type='text' name='gubun2' size='22' class='text input' value='<%=gubun2%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
				</td>
				<td>
					<label><i class="fa fa-check-circle"></i> ����</label>
				</td>
				<td>
					<input type='text' name='gubun3' size='22' class='text input' value='<%=gubun3%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
				</td>
				<td>
					<label><i class="fa fa-check-circle"></i> ���</label>
				</td>
				<td>
					<input type='text' name='gubun5' size='22' class='text input' value='<%=gubun5%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
					<select name="gubun6" class="select">
						<option value="1" <%if(gubun6.equals("1"))%>selected<%%>>����</option>						
						<option value="2" <%if(gubun6.equals("2"))%>selected<%%>>������</option>
					</select>
				</td>
				<td>
					<label><i class="fa fa-check-circle"></i> �����</label>
				</td>
				<td>
					<input type='text' name='st_dt' size='12' class='text input' value='<%=st_dt%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>	~
					<input type='text' name='end_dt' size='12' class='text input' value='<%=end_dt%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
				</td>
				<td>
					<label><i class="fa fa-check-circle"></i> ����</label>
				</td>
				<td>
					<select name="gubun4" class="select">
						<option value="" <%if(gubun4.equals(""))%>selected<%%>>��ü</option>
						<option value="1" <%if(gubun4.equals("1"))%>selected<%%>>�ֹ���</option>
						<option value="Y" <%if(gubun4.equals("Y"))%>selected<%%>>����</option>
						<option value="2" <%if(gubun4.equals("2"))%>selected<%%>>LPG</option>
					</select>
				</td>
				<td>
					<label><i class="fa fa-check-circle"></i> �������� </label>
				</td>
				<td>
				    <select name='sort' class="select" onchange="javascript:sort_fuel_form(this.value);">
				    	<option value='1' <%if(sort.equals("1")){%>selected<%}%>> ��������� </option>
				        <option value='2' <%if(sort.equals("2")){ %>selected<%}%>> ��ȣ </option>
				        <option value='3' <%if(sort.equals("3")){ %>selected<%}%>> ���� </option>
			        </select>
				</td>
				<td>
				    <select name='sort_fuel' class="select" style="display: none;">
				    	<option value='1' <%if(sort_fuel.equals("1")){%>selected<%}%>>�ֹ���</option>
				        <option value='Y' <%if(sort_fuel.equals("Y")){ %>selected<%}%>>����</option>
				        <option value='2' <%if(sort_fuel.equals("2")){ %>selected<%}%>>LPG</option>
			        </select>
				</td>
				<td>
					<input type="button" class="button" value="�˻�" onclick="search();">
				</td>
			</tr>
		</table>      		
	</div>
</form>
</body>
</html>

