<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*, acar.car_mst.*,  acar.estimate_mng.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="ce_bean" class="acar.common.CommonEtcBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	//��Ϻ��� ������ �̷�
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"0001":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");
	String car_id 		= request.getParameter("car_id")	==null?"":request.getParameter("car_id");
	String view_dt 		= request.getParameter("view_dt")	==null?"":request.getParameter("view_dt");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String t_wd2 		= request.getParameter("t_wd2")		==null?"":request.getParameter("t_wd2");
	String t_wd3 		= request.getParameter("t_wd3")		==null?"":request.getParameter("t_wd3");
	String t_wd4 		= request.getParameter("t_wd4")		==null?"":request.getParameter("t_wd4");
	String t_wd5 		= request.getParameter("t_wd5")		==null?"":request.getParameter("t_wd5");
	String gubun1 		= request.getParameter("gubun1")	==null?"1":request.getParameter("gubun1");
	String s_car_id 	= request.getParameter("s_car_id")	==null?"":request.getParameter("s_car_id");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"":request.getParameter("asc");
	
	
	//�ڵ���ȸ�� ����Ʈ
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll();
	
	//��������Ʈ
	CarMstDatabase cmb = CarMstDatabase.getInstance();
	CarMstBean cm_r [] = cmb.getCarKindAll(car_comp_id);
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	CodeBean[] sections = c_db.getCodeAll2("0007", "Y"); /* �ڵ� ����:�ܱ�뿩��������з� */
	int section_size = sections.length;	
	
	CodeBean[] sgroups = c_db.getCodeAll2("0008", "Y"); /* �ڵ� ����:�����Һз� */
	int sgroup_size = sgroups.length;		
		
	EstiDatabase edb = EstiDatabase.getInstance();
	
	//�����ڵ庰���� 
	Vector jgVarList = edb.getEstiJgVarList();
	int jgVarList_size = jgVarList.size();
	
%>

<html>
<head>
<title>�ڵ���ȸ��</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//�ڵ���ȸ�� ���ý� �����ڵ� ����ϱ�
	function GetCarCode(){
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.code;
		te.options[0].value = '';
		te.options[0].text = '��ȸ��';
		fm2.sel.value = "form1.code";
		fm2.car_comp_id.value = fm.car_comp_id.value;
		fm2.mode.value = '1';
		fm2.target="i_no";
		fm2.submit();
	}
	
	//�����ڵ� ���ý� ���� ���÷���
	function GetCarId(){
		var fm = document.form1;
		var fm2 = document.form2;
		var car_nm = fm.code.options[fm.code.selectedIndex].text;
		var car_nm_split = car_nm.split("]");
		fm.car_nm.value = car_nm_split[1];
		
		fm2.car_comp_id.value = fm.car_comp_id.value;
		
		//���� ���� �⺻���� �ɼ� ��������
		te = fm.add_car_amt_opt;
		te.options[0].value = '';
		te.options[0].text = '�ɼǾ���';
		fm2.sel.value = "form1.add_car_amt_opt";
		fm2.code.value = fm.code.options[fm.code.selectedIndex].value;
		fm2.mode.value = 'opt';
		fm2.target="i_no";
		//fm2.target="_blank";
		fm2.submit();
	}

	//����ϱ�
	function Reg(){
		var fm = document.form1;
		if(fm.car_comp_id.value == '')	{ alert('�ڵ���ȸ�縦 �����Ͻʽÿ�'); 	return; }
		if(fm.code.value == '')		{ alert('�����ڵ带 �����Ͻʽÿ�'); 	return; }
		if(fm.car_nm.value == '')	{ alert('���� Ȯ���Ͻʽÿ�'); 	return; }
		if(fm.car_name.value == '')	{ alert('������ Ȯ���Ͻʽÿ�'); 	return; }
				
		if(fm.car_b.value == '')	{ alert('�⺻����� Ȯ���Ͻʽÿ�'); 	return; }		
		if(fm.car_b_p.value == '')	{ alert('�⺻������ Ȯ���Ͻʽÿ�'); 	return; }
		
		if(fm.jg_2.value == '1' && fm.duty_free_opt.value == ''){ alert('�Ϲ�LPG�����Դϴ�. ��������ǥ ���Ҽ� ������/�鼼�� ǥ������ ������ �����Ͻʽÿ�'); 	return; }
		
		if(fm.car_b_dt.value == '')	{ alert('�������ڸ� Ȯ���Ͻʽÿ�'); 	return; }
		if(fm.jg_code.value == '')	{ alert('�����ڵ带 Ȯ���Ͻʽÿ�'); 	return; }
				
		if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}
		
		var link = document.getElementById("submitLink");
		var originFunc = link.getAttribute("href");
		link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");
		
		fm.cmd.value = "i";
		//fm.target = "i_no";
		fm.submit();
		
		link.getAttribute('href',originFunc);
	}	
	
	//��Ϻ���
	function go_list(){
		var fm = document.form1;
		fm.action = 'car_mst_frame.jsp';
		fm.target = 'd_content';
		fm.submit();
	}
	
	function open_car_b_inc(){
		var fm = document.form1;
		if(fm.code.value=="" || fm.car_comp_id.value==""){
			alert("�ڵ���ȸ�� �� �����ڵ带 ���� �����ϼ���!!"); 
			return; 
		}
		window.open("car_b_inc.jsp?car_comp_id="+fm.car_comp_id.value+"&car_cd="+fm.code.value+"&car_b_dt="+fm.car_b_dt.value,"car_b_inc", "left=300, top=100, width=500, height=400, scrollbars=yes");
	}
	
	//�����ڵ� ���ý� ����
	function in_set(){
		var fm = document.form1;
		var jg_code = fm.jg_code.options[fm.jg_code.selectedIndex].value;
		var jg_code_split 	= jg_code.split("||");
		fm.r_jg_code.value 	= jg_code_split[0];
		fm.dpm.value 		= jg_code_split[1];
		fm.jg_2.value 		= jg_code_split[2];
	}
	
	//�⺻���� + �����ɼ�
	function add_car_amt_total(){
		var fm = document.form1;
		var car_amt_init 	 = Number(fm.init_car_b_p.value.replace(/,/gi, ""));
		var car_amt_opt_init = fm.add_car_amt_opt.options[fm.add_car_amt_opt.selectedIndex].value;
		
		var car_amt_opt_arr  = car_amt_opt_init.split("///");
		var car_amt_opt_nm   = car_amt_opt_arr[0];
		var car_amt_opt_amt  = Number(car_amt_opt_arr[1]);
		//var car_amt_opt 	 = Number(fm.add_car_amt_opt.options[fm.add_car_amt_opt.selectedIndex].value);
		fm.car_b_p.value = parseDecimal(car_amt_init + car_amt_opt_amt);
		
		if($("#span1_hidden_yn").val()=="Y"){	//�ɼ��߰� ����̸�
			fm.add_opt_amt.value = car_amt_opt_amt;
			fm.add_opt_nm.value  = car_amt_opt_nm;
		}
	}
	
	//�⺻���� �ɼ��߰���ư set
	function setDisplayAddOpt(){
		var span1_yn = $("#span1_hidden_yn").val();
		if(span1_yn=="N"){
			$("#hidden_span1").css("display","block");
			$("#span1_hidden_yn").val("Y");
		}else if(span1_yn=="Y"){
			$("#hidden_span1").css("display","none");
			$("#span1_hidden_yn").val("N");
		}
	}
	
	//�⺻���� �ɼ� �߰�/����
	function addCarAmtOpt(){
		var fm = document.form1;
		if(fm.add_opt_nm.value==""){
			alert("�߰��� �ɼ��� ��Ī(����)�� �Է����ּ���.");
			return;
		}
		if(fm.add_opt_amt.value==""){
			alert("�߰��� �ɼ��� ������ �Է����ּ���.");
			return;
		}
		fm.cmd.value = "opt";
		fm.submit();
	}
	
	//�����ڵ忡 ���� �����⺻���� �ɼ� ����
	<%-- function setCarAmtOpt(car_cd){
	
		<%	//�����⺻����-�ɼ���ȸ
		  CommonEtcBean addCarAmts [] = c_db.getCommonEtcAll("add_car_amt","car_code","89","","","","","","");
		  for(int i=0; i<addCarAmts.length; i++){
			  ce_bean = addCarAmts[i];
		%>	
		
	} --%>
	
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:self.focus()">

<form action="./car_mst_null.jsp" name="form2" method="post">
  <input type="hidden" name="sel" value="">
  <input type="hidden" name="car_comp_id" value="">
  <input type="hidden" name="code" value="">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="mode" value="">  
  <input type="hidden" name="from_page" value="/acar/car_mst/car_mst_i.jsp">
</form>
<form action="./car_mst_i_a.jsp" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">    
  <input type="hidden" name="view_dt" value="<%=view_dt%>">
  <input type="hidden" name="t_wd" value="<%=t_wd%>">      
  <input type="hidden" name="t_wd2" value="<%= t_wd2 %>">  
  <input type="hidden" name="t_wd3" value="<%= t_wd3 %>">  
  <input type="hidden" name="t_wd4" value="<%= t_wd4 %>">
  <input type="hidden" name="t_wd5" value="<%= t_wd5 %>">
  <input type="hidden" name="gubun1" value="<%= gubun1 %>">  
  <input type="hidden" name="sort_gubun" value="<%= sort_gubun %>">
  <input type="hidden" name="asc" 	value="<%= asc %>">  
  <input type="hidden" name="s_car_id" value="<%=s_car_id%>">
  <input type="hidden" name="car_id" value="<%=car_id%>">        
  <input type="hidden" name="cmd" value="">
  <input type="hidden" name="car_b_inc_id" value="">  
  <input type="hidden" name="car_b_inc_seq" value=""> 
  <input type="hidden" name="r_jg_code" value=""> 
  <input type="hidden" name="jg_2" value="">
   
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td>            
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                	<td>
                	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                                <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > <span class=style5>������� (���)</span></span></td>
                                <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                            </tr>
                        </table>
                	</td>
                </tr>
                <tr>
                    <td class=h></td>
                </tr>
                <tr> 
                    <td align="right"> 
                      <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a id="submitLink" href="javascript:Reg()"><img src=../images/center/button_reg.gif border=0></a>
                      <%}%>
                      <a href="javascript:go_list();"><img src=../images/center/button_list.gif border=0></a></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" cellpadding="3" width="100%">
            	<colgroup>
            		<col width="12%">
            		<col width="30%">
            		<col width="58%">
            	</colgroup>
                <tr> 
                    <td class=title>�ڵ���ȸ��</td>
                    <td colspan="2"> <select name="car_comp_id" onChange="javascript:GetCarCode()">
                        <%for(int i=0; i<cc_r.length; i++){
   						        cc_bean = cc_r[i];
   						        if(!cc_bean.getCms_bk().equals("Y")) continue;
        				%>
                        <option value="<%= cc_bean.getCode() %>" <%if(car_comp_id.equals(cc_bean.getCode()))%>selected<%%>><%= cc_bean.getNm() %></option>
                        <%	}	%>
                      </select> </td>
                </tr>
                <tr> 
                    <td class=title>�����ڵ�</td>
                    <td colspan="2"> <select name="code" onChange="javascript:GetCarId()">
                        <option value="">����</option>
                        <%for(int i=0; i<cm_r.length; i++){
        						        cm_bean = cm_r[i];%>
                        <option value="<%=cm_bean.getCode()%>" <%if(code.equals(cm_bean.getCode()))%>selected<%%>>[<%=cm_bean.getCar_cd()%>]<%=cm_bean.getCar_nm()%></option>
                        <%	}	%>
                      </select> </td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td colspan="2"> <input type="text" name="car_nm" size="30" class=text> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td colspan="2"> <input type="text" name="car_name" id="car_name" value="" size="70" class=text placeholder="&#39; &#34; &#60; &#62; ���� Ư�����ڴ� �Է��� �Ұ��� �մϴ�."> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td colspan="2"> ����1 <input type="text" name="car_y_form" value="" size="4" class=text> 
                    ����2 <input type="text" name="car_y_form2" value="" size="4" class=text>
                    ����3 <input type="text" name="car_y_form3" value="" size="4" class=text>
	                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	                    <select name="car_y_form_yn">
	                    	<option value="Y" <%if(cm_bean.getCar_y_form_yn().equals("Y")){%>selected<%}%>>���� ������ ���� ǥ��</option>
	                    	<option value="N" <%if(cm_bean.getCar_y_form_yn().equals("N")){%>selected<%}%>>���� ������ ���� ��ǥ��</option>
	                    </select>
                    </td>
                </tr>                
                <tr> 
                    <td class=title>�⺻���</td>
                    <td colspan="2"> ����������: 
                      <input type="text" name="car_b_inc_name" value="" size="40" class=text > 
                      <a href="javascript:open_car_b_inc();"><img src=../images/center/button_in_cho.gif border=0 align=absmiddle
                      		></a><br> <textarea name="car_b" id="car_b" cols="100" class="text" rows="10" placeholder="&#39; &#34; ���� Ư�����ڴ� �Է��� �Ұ��� �մϴ�."></textarea> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>�⺻����</td>
                    <td width='40%'> 
                    	<input type="text" name="init_car_b_p" value="" size="15" class=num onBlur='javascript:add_car_amt_total(); this.value=parseDecimal(this.value);'>
                      ��
                      	<select name="add_car_amt_opt" onchange="javascript:add_car_amt_total();">
                      		<option value="///0">�ɼǾ���</option>
                      	</select>
                      	
                      	<select name="duty_free_opt">
                      		<option value="">����</option>
                      		<option value="0">��������ǥ ���Ҽ� ������ ǥ������</option>
                      		<option value="1">��������ǥ ���Ҽ� �鼼�� ǥ������</option>
                      	</select>
                      </td>
                      <td align="right">	
                      	<input type="button" class="button" value="�ɼ��߰�" onclick="javascript:setDisplayAddOpt();">
                      	<span id="hidden_span1" style="display: none;">
                      		�ɼ��̸�(����) : <input type="text" name="add_opt_nm" >&nbsp;&nbsp;&nbsp;<br>
                      		<input type="button" class="button" value="�߰�/����" onclick="javascript:addCarAmtOpt();">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      		�ɼǰ��� : <input type="text" name="add_opt_amt" > ��
                      		<input type="hidden" id="span1_hidden_yn" value="N">
                      	</span>
                      </td>
					<!--  
                    <td width="12%" class=title>��ⷮ</td>
                    <td width="38%"> <input type="text" name="dpm" value="<%//=cm_bean.getCar_nm()%>" size="4" class=num>
                      cc </td>
					  -->
                </tr>
                <!-- �׽�Ʈ -->
                <tr>
                	<td class="title">�⺻��������(����)</td>
                	<td colspan="2">
                		<input type="text" name="car_b_p" value="" size="15" class=num readonly="readonly"> �� (�⺻���� + �߰��ɼǰ���)
                	</td>	
                </tr>
                <!-- �׽�Ʈ ��-->
                <tr> 
                    <td class=title>��ⷮ</td>
                    <td colspan="2"> <input type="text" name="dpm" value="" size="4" class=num>
                      cc </td>
					<!--  
                    <td width="12%" class=title>��ⷮ</td>
                    <td width="38%"> <input type="text" name="dpm" value="<%//=cm_bean.getCar_nm()%>" size="4" class=num>
                      cc </td>
					  -->
                </tr>				
                <tr> 
                    <td class="title">���ӱ�</td>
                    <td colspan="2"><input type="radio" name="auto_yn" value="Y" >
                      A/T 
                      <input type="radio" name="auto_yn" value="N" >
                      M/T 		  
        			</td>		
					<!--  
                    <td class="title">����</td>
                    <td><input type="radio" name="diesel_yn" value="1" >
                      �ֹ��� 
                      <input type="radio" name="diesel_yn" value="Y" >
                      ���� 
                      <input type="radio" name="diesel_yn" value="2" >
                      LPG </td>
					  -->
                </tr>			
                <tr> 
                    <td class=title>�����ڵ�</td>
                    <td colspan="2"><select name='jg_code' onChange='javascript:in_set();'>
                      <option value="">=======�� ��=======</option>
                      <%if(jgVarList_size > 0){
        					for(int i = 0 ; i < jgVarList_size ; i++){
        						Hashtable jgVar = (Hashtable)jgVarList.elementAt(i);
        						//�����Ǹſ���
        						if(String.valueOf(jgVar.get("JG_13")).equals("1")){
        			  %>
                      <option value='<%=jgVar.get("SH_CODE")%>||<%=jgVar.get("JG_C")%>||<%=jgVar.get("JG_2")%>' > [<%= jgVar.get("SH_CODE") %>]<%= jgVar.get("CARS") %> </option>
                      <%		}
                      		}
        				}%>
                    </select></td>
                </tr>				
                <tr> 
                    <td class=title>��Ÿ</td>
                    <td colspan="2"> 
                    
        			  <select name="air_ds_yn">
                        <option value="">����</option>
                        <option value="Y" >��</option>
                        <option value="N" >��</option>
                      </select>
        				�����������
        				
        			  <select name="air_as_yn">
                        <option value="">����</option>
                        <option value="Y" >��</option>
                        <option value="N" >��</option>
                      </select>	
        				�����������
                      <!--          				
        				&nbsp;
        			  <select name="air_cu_yn">
                        <option value="">����</option>
                        <option value="Y" >��</option>
                        <option value="N" >��</option>
                      </select>	
        				Ŀư�����<br>
        				
                      <select name="abs_yn">
                        <option value="">����</option>
                        <option value="Y" >��</option>
                        <option value="N" >��</option>
                      </select>
        				ABS��ġ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        				
                      <select name="rob_yn">
                        <option value="">����</option>
                        <option value="Y" >��</option>
                        <option value="N" >��</option>
                      </select>
        				����������ġ
        				&nbsp;
        				
                      <select name="sp_car_yn">
                        <option value="">����</option>
                        <option value="Y">��</option>
                        <option value="N" selected>��</option>
                      </select>
                      ������ī����
                      -->
                    </td>
                </tr>		  
                <tr> 
                    <td class=title>��뿩��</td>
                    <td colspan="2"> <input name="use_yn" type="radio" value="Y" checked>
                      ��� 
                      <input type="radio" name="use_yn" value="N">
                      �̻�� </td>
					  <!--
                    <td class=title>���� ���뿩��</td>
                    <td><input name="est_yn" type="radio" value="Y" checked>
                      ���� 
                      <input type="radio" name="est_yn" value="N">
                      ������ </td>-->
                </tr>
                <tr> 
                    <td class=title>TUIX/TUON Ʈ������</td>
                    <td colspan="2"> <input type="radio" name="jg_tuix_st" value="N" checked>
                      ���ش�
                      <input type="radio" name="jg_tuix_st" value="Y">
                      �ش� </td>
                </tr>
                <tr>
                	<td class=title>������Ż ������</td>
                	<td colspan="2"> <input type="radio" name="lkas_yn" value="N" checked>
                		���ش�
                		<input type="radio" name="lkas_yn" value="Y">
                		�ش�</td>
                </tr>
                <tr>
                	<td class=title>������Ż �����</td>
                	<td colspan="2"> <input type="radio" name="ldws_yn" value="N" checked>
                		���ش�
                		<input type="radio" name="ldws_yn" value="Y">
                		�ش�</td>
                </tr>
                <tr>
                	<td class=title>������� ������</td>
                	<td colspan="2"> <input type="radio" name="aeb_yn" value="N" checked>
                		���ش�
                		<input type="radio" name="aeb_yn" value="Y">
                		�ش�</td>
                </tr>
                <tr>
                	<td class=title>������� �����</td>
                	<td colspan="2"> <input type="radio" name="fcw_yn" value="N" checked>
                		���ش�
                		<input type="radio" name="fcw_yn" value="Y">
                		�ش�</td>
                </tr>
				<!-- <tr>
                	<td class=title>���ΰ�(Ʈ���Ϸ���)</td>
                	<td colspan="2"> <input type="radio" name="hook_yn" value="N" checked>
                		���ش�
                		<input type="radio" name="hook_yn" value="Y">
                		�ش�</td>
                </tr> -->
                <tr> 
                    <td class=title>��������</td>
                    <td colspan="2"> <input type="text" name="car_b_dt" value="<%= AddUtil.getDate() %>" size="15" class=text onBlur='javscript:this.value = ChangeDate(this.value);'> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>���</td>
                    <td colspan="2"> <textarea name="etc" cols="100" class="text" rows="2" maxlength="200"></textarea> 
                    </td>
                </tr>
                <tr> 	<!-- ��Ÿ �߰�(2018.02.08) -->
                    <td class=title>��Ÿ</td>
                    <td colspan="2"> <textarea name="etc2" cols="100" class="text" rows="2" placeholder="(������ ��Ÿ���� �������� �κ��Դϴ�)" maxlength="200"></textarea> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
    </tr>        
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="3" width=100%>
                <tr> 
                    <td width="13%" class=title>����鼼����</td>
                    <td> <input type="text" name="car_b_p2" value="<%//=AddUtil.parseDecimal(cm_bean.getCar_b_p2())%>" size="10" class=<%//=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        ��
                    </td>
                </tr>
                <tr>
                    <td class=title>���ݰ�꼭D/C</td>
                    <td>��Ʈ
                        <input type="text" name="r_dc_amt" value="<%//=AddUtil.parseDecimal(cm_bean.getR_dc_amt())%>" size="10" class=<%//=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        �� / ���� 
                        <input type="text" name="l_dc_amt" value="<%//=AddUtil.parseDecimal(cm_bean.getL_dc_amt())%>" size="10" class=<%//=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        ��
                    </td>
                </tr>
                <tr>
                    <td class=title>ī������ݾ�</td>
                    <td>��Ʈ
                        <input type="text" name="r_card_amt" value="<%//=AddUtil.parseDecimal(cm_bean.getR_card_amt())%>" size="10" class=<%//=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        �� / ���� 
                        <input type="text" name="l_card_amt" value="<%//=AddUtil.parseDecimal(cm_bean.getL_card_amt())%>" size="10" class=<%//=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        ��
                    </td>
                </tr>                
                <tr>
                    <td class=title>Cash Back </td>
                    <td>��Ʈ
                        <input type="text" name="r_cash_back" value="<%//=AddUtil.parseDecimal(cm_bean.getR_cash_back())%>" size="10" class=<%//=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        �� / ����
                        <input type="text" name="l_cash_back" value="<%//=AddUtil.parseDecimal(cm_bean.getL_cash_back())%>" size="10" class=<%//=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        ��
                    </td>
                </tr>                
                <tr>
                    <td class=title>Ź�۽��ú���</td>
                    <td>��Ʈ
                        <input type="text" name="r_bank_amt" value="<%//=AddUtil.parseDecimal(cm_bean.getR_bank_amt())%>" size="10" class=<%//=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        �� / ����
                        <input type="text" name="l_bank_amt" value="<%//=AddUtil.parseDecimal(cm_bean.getL_bank_amt())%>" size="10" class=<%//=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        ��
                    </td>
                </tr>                
            </table>
        </td>
        <td width="20" bgcolor="#FFFFFF">&nbsp;</td>
    </tr>                  
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script language="JavaScript">
<!--
	<%if(!code.equals("")){%>
		GetCarId();
	<%}%>
	
	// ����, �⺻��翡 Ư������ �Է� ����
	var regex1 = /[\'\"<>]/gi;
	var regex2 = /[\'\"]/gi;
	var car_name;
	var car_b;
	
	// ���� ' " < > ����
	$("#car_name").bind("keyup",function(){
		car_name = $("#car_name").val();
		if(regex1.test(car_name)){
			$("#car_name").val(car_name.replace(regex1,""));
		}
	});
	
	// �⺻��� ' " ����
	$("#car_b").bind("keyup",function(){
		car_b = $("#car_b").val();
		if(regex2.test(car_b)){
			$("#car_b").val(car_b.replace(regex2,""));
		}
	});
	
	
//-->
</script>
</body>
</html>