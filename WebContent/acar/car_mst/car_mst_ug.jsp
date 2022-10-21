<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*, acar.car_mst.*, acar.short_fee_mng.*, acar.estimate_mng.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="sfm_db" scope="page" class="acar.short_fee_mng.ShortFeeMngDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String view_dt 		= request.getParameter("view_dt")	==null?"":request.getParameter("view_dt");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String t_wd2 		= request.getParameter("t_wd2")		==null?"":request.getParameter("t_wd2");
	String t_wd3 		= request.getParameter("t_wd3")		==null?"":request.getParameter("t_wd3");
	String t_wd4 		= request.getParameter("t_wd4")		==null?"":request.getParameter("t_wd4");
	String t_wd5 		= request.getParameter("t_wd5")		==null?"":request.getParameter("t_wd5");
	String gubun1 		= request.getParameter("gubun1")	==null?"1":request.getParameter("gubun1");
	String s_car_id 	= request.getParameter("s_car_id")	==null?"":request.getParameter("s_car_id");
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"":request.getParameter("asc");
	
	
	String car_id 		= request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq 		= request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String disabled = "disabled";
	String white = "white";
	String readonly = "readonly";
	if(cmd.equals("ug")){
		disabled = "";
		white = "";
		readonly = "";
	}
	
	//��������
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	cm_bean = a_cmb.getCarNmCase(car_id, car_seq);
	
	//�ڵ���ȸ�� ����Ʈ
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll();
	
	//��������Ʈ
	Vector cars = a_cmb.getSearchCode(cm_bean.getCar_comp_id(), cm_bean.getCode(), cm_bean.getCar_id(), cm_bean.getCar_b_dt(), "1", "");
	int car_size = cars.size();
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	CodeBean[] sections = c_db.getCodeAll2("0007", "Y"); /* �ڵ� ����:�ܱ�뿩��������з� */
	int section_size = sections.length;	
	CodeBean[] sgroups = c_db.getCodeAll2("0008", "Y"); /* �ڵ� ����:�����Һз� */
	int sgroup_size = sgroups.length;	
	
	Vector conts = sfm_db.getSectionList();
	int cont_size = conts.size();
		
	//�⺻��� ���� ����
	String car_b_inc_name = a_cmb.getCar_b_inc_name(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	
	EstiDatabase edb = EstiDatabase.getInstance();
	
	//��)�߰����ܰ��ڵ� 20050913
	Vector shVarList = edb.getEstiShVarList();
	int shVarList_size = shVarList.size();
	
	//��)�߰����ܰ��ڵ� 20070316
	Vector jgVarList = edb.getEstiJgVarList();
	int jgVarList_size = jgVarList.size();
	
	//��������
	EstiJgVarBean ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>�ڵ���ȸ��</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
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
		var car_nm = fm.code.options[fm.code.selectedIndex].text;
		var car_nm_split = car_nm.split("]");
		fm.car_nm.value = car_nm_split[1];
	}

	//�����ϱ�
	function Reg(){
		var fm = document.form1;
		if(fm.car_nm.value == ''){ alert('���� Ȯ���Ͻʽÿ�'); return; }
		if(fm.car_name.value == ''){ alert('������ Ȯ���Ͻʽÿ�'); return; }
		if(fm.car_b.value == ''){ alert('�⺻����� Ȯ���Ͻʽÿ�'); return; }
		if(fm.car_b_p.value == ''){ alert('�⺻������ Ȯ���Ͻʽÿ�'); return; }
		if(fm.car_b_dt.value == ''){ alert('�������ڸ� Ȯ���Ͻʽÿ�'); return; }	
		if(fm.jg_code.value == ''){ alert('�����ڵ带 Ȯ���Ͻʽÿ�'); 	return; }	
		<%if(!ej_bean.getJg_b().equals("5")&&!ej_bean.getJg_b().equals("6")){%>
		if(fm.dpm.value == '')		{ alert('��ⷮ�� Ȯ���Ͻʽÿ�'); 	return; }
		if(fm.dpm.value == '0')		{ alert('��ⷮ�� Ȯ���Ͻʽÿ�'); 	return; }
		<%}%>
		if(!max_length(fm.car_b.value, 4000)){ alert('�⺻����� ����4000��/�ѱ�2000�ڸ� �ʰ��Ͽ����ϴ�.\n\nȮ���Ͻʽÿ�'); return; }
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		
		var link = document.getElementById("submitLink");
		var originFunc = link.getAttribute("href");
		link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");
		
		fm.action = 'car_mst_ug_a.jsp';			
		fm.target = "i_no";
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
	}		
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
</form>
<form action="./car_mst_ug_a.jsp" name="form1" method="POST" >
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
  <input type="hidden" name="car_seq" value="<%=car_seq%>">
  <input type="hidden" name="cmd" value="<%=cmd%>">
  <input type="hidden" name="car_b_inc_id" value="<%= cm_bean.getCar_b_inc_id() %>">  
  <input type="hidden" name="car_b_inc_seq" value="<%= cm_bean.getCar_b_inc_seq() %>">   
  <input type="hidden" name="r_jg_code" value="<%=cm_bean.getJg_code()%>"> 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td>            
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr>
    	            <td>
                	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                                <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > <span class=style5>������� (���׷��̵�)</span></span></td>
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
        		    <a id="submitLink" href='javascript:Reg();'> 
        	        <img src=../images/center/button_reg.gif border=0></a>
        			<%	if(cmd.equals("u")){%>
        		    <a href='javascript:document.form1.reset();'> 
            	    <img src=../images/center/button_cancel.gif border=0></a>		
        			<%	}%>
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
            <table border="0" cellspacing="1" cellpadding="3" width=100%>
                <!-- 
                <tr> 
                    <td width="13%" class=title>�ڵ���ȸ��</td>
                    <td > <select name="car_comp_id" onChange="javascript:GetCarCode()" <%//=disabled%>>
                    <%for(int i=0; i<cc_r.length; i++){
						        cc_bean = cc_r[i];%>
                    <option value="<%= cc_bean.getCode() %>" <%if(cm_bean.getCar_comp_id().equals(cc_bean.getCode()))%>selected<%//%>><%= cc_bean.getNm() %></option>
                    <%	}	%>
                    </select></td>
                </tr>
                <tr> 
                    <td class=title>�����ڵ�</td>
                    <td > <select name="code" onChange="javascript:GetCarId()" <%//=disabled%>>
                    <option value="">����</option>
                    <%for(int i = 0 ; i < car_size ; i++){
    					Hashtable car = (Hashtable)cars.elementAt(i);%>
                    <option value="<%=car.get("CODE")%>" <%if(cm_bean.getCode().equals(String.valueOf(car.get("CODE"))))%>selected<%//%>>[<%=car.get("CAR_CD")%>]<%=car.get("CAR_NM")%></option>
                    <%	}	%>
                    </select> </td>
                </tr>
                 -->
                 <input type="hidden" name="car_comp_id" value="<%=cm_bean.getCar_comp_id()%>">
                 <input type="hidden" name="code" value="<%=cm_bean.getCode()%>">
                <tr> 
                    <td class=title>����</td>
                    <td > <input type="text" name="car_nm" value="<%=cm_bean.getCar_nm()%>" size="30" class=<%=white%>text></td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td > <input type="text" name="car_name" value="<%=cm_bean.getCar_name()%>" size="70" class=<%=white%>text></td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td > ����1 : <input type="text" name="car_y_form" value="<%=cm_bean.getCar_y_form()%>" size="4" class=<%=white%>text> 
                    ����2 : <input type="text" name="car_y_form2" value="<%=cm_bean.getCar_y_form2()%>" size="4" class=<%=white%>text>
                    ����3 : <input type="text" name="car_y_form3" value="<%=cm_bean.getCar_y_form3()%>" size="4" class=<%=white%>text>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	                    <select name="car_y_form_yn">
	                    	<option value="Y" <%if(cm_bean.getCar_y_form_yn().equals("Y")){%>selected<%}%>>���� ������ ���� ǥ��</option>
	                    	<option value="N" <%if(cm_bean.getCar_y_form_yn().equals("N")){%>selected<%}%>>���� ������ ���� ��ǥ��</option>
	                    </select>
                    </td>
                </tr>                
                <tr> 
                    <td class=title>�⺻���</td>
                    <td > ���������� : 
                    <input type="text" name="car_b_inc_name" value="" size="85" class=text placeholder="���� ������������ [<%= car_b_inc_name %>]�Դϴ�. ���׷��̵� �ݿ��� �ٽ� ��ȸ�ϼ���."> 
                    <a href="javascript:open_car_b_inc();"><img src=../images/center/button_in_cho.gif border=0 align=absmiddle></a>
                    &nbsp; (���� ���������� : <%= car_b_inc_name %>)
                    <br> 
                    <textarea name="car_b" cols="110" class="text" rows="10" <%=readonly%>><%=cm_bean.getCar_b()%></textarea></td>
                </tr>
                <tr> 
                    <td class=title>�⺻����</td>
                    <td > <input type="text" name="car_b_p" value="<%=AddUtil.parseDecimal(cm_bean.getCar_b_p())%>" size="15" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>��
                    &nbsp;&nbsp;&nbsp;
	                     <select name="duty_free_opt" <%=disabled%>>
	                     	<option value="">����</option>
	                     	<option value="0"<%if(cm_bean.getDuty_free_opt().equals("0")){ %>selected<%}%>>��������ǥ ���Ҽ� ������ ǥ������</option>
	                     	<option value="1"<%if(cm_bean.getDuty_free_opt().equals("1")){ %>selected<%}%>>��������ǥ ���Ҽ� �鼼�� ǥ������</option>
	                     </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>��ⷮ</td>
                    <td > <input type="text" name="dpm" value="<%=AddUtil.parseDecimal(cm_bean.getDpm())%>" size="4" class=<%=white%>num>
                      cc</td>
                </tr>							
                <tr>			  
                    <td class="title">���ӱ�</td>
                    <td><input type="radio" name="auto_yn" value="Y" <% if(cm_bean.getAuto_yn().equals("Y")) out.print("checked"); %>>
                      A/T 
                      <input type="radio" name="auto_yn" value="N" <% if(cm_bean.getAuto_yn().equals("N")) out.print("checked"); %>>
                      M/T 		  
        			</td>		  

                </tr>

                <tr> 
                    <td class=title>�����ڵ�</td>
                    <td><select name='jg_code'  <%=disabled%> onChange='javascript:in_set();'>
                      <option value="">=======�� ��=======</option>
                      <%if(jgVarList_size > 0){
        					for(int i = 0 ; i < jgVarList_size ; i++){
        						Hashtable jgVar = (Hashtable)jgVarList.elementAt(i); %>
                      <option value='<%= jgVar.get("SH_CODE") %>||<%=jgVar.get("JG_C")%>' <%if(cm_bean.getJg_code().equals((String)jgVar.get("SH_CODE")))%>selected<%//%>> [<%= jgVar.get("SH_CODE") %>]<%= jgVar.get("CARS") %> </option>
                      <%	}
        				}%>
                    </select></td>
                </tr>

                <tr> 
                    <td class=title>��Ÿ</td>
                    <td > 
        			  <select name="air_ds_yn">
                        <option value="">����</option>
                        <option value="Y" <%if(cm_bean.getAir_ds_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cm_bean.getAir_ds_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>
        				�����������
        			  <select name="air_as_yn">
                        <option value="">����</option>
                        <option value="Y" <%if(cm_bean.getAir_as_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cm_bean.getAir_as_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
                      
        				�����������

                    </td>
                </tr>		  		  		  
                <tr> 
                    <td class=title>��뿩��</td>
                    <td> <input name="use_yn" type="radio" value="Y" <%if(cm_bean.getCar_yn().equals("Y"))%>checked<%%>>
                      ��� 
                      <input type="radio" name="use_yn" value="N" <%if(cm_bean.getCar_yn().equals("N"))%>checked<%%>>
                      �̻�� </td>

                </tr>
                <tr> 
                    <td class=title>Ȩ��������뿩��</td>
                    <td > 
                    	<input type="radio" name="hp_yn" value="Y" <%if(cm_bean.getHp_yn().equals("Y"))%>checked<%%>>
                      ��� 
                      <input type="radio" name="hp_yn" value="N" <%if(cm_bean.getHp_yn().equals("N"))%>checked<%%>>
                      �̻�� </td>

                </tr>  
                <tr> 
                    <td class=title>TUIX/TUON Ʈ������</td>
                    <td > <input type="radio" name="jg_tuix_st" value="N" <%if(cm_bean.getJg_tuix_st().equals("N"))%>checked<%%>>
                      ���ش�
                      <input type="radio" name="jg_tuix_st" value="Y" <%if(cm_bean.getJg_tuix_st().equals("Y"))%>checked<%%>>
                      �ش� </td>
                </tr>                                          
                <tr>
                	<td class=title>������Ż ������</td>
                	<td > <input type="radio" name="lkas_yn" value="N" <%if(cm_bean.getLkas_yn().equals("N"))%>checked<%%>>
                		���ش�
                		<input type="radio" name="lkas_yn" value="Y" <%if(cm_bean.getLkas_yn().equals("Y"))%>checked<%%>>
                		�ش�</td>
                </tr>
                <tr>
                	<td class=title>������Ż �����</td>
                	<td > <input type="radio" name="ldws_yn" value="N" <%if(cm_bean.getLdws_yn().equals("N"))%>checked<%%>>
                		���ش�
                		<input type="radio" name="ldws_yn" value="Y" <%if(cm_bean.getLdws_yn().equals("Y"))%>checked<%%>>
                		�ش�</td>
                </tr>
                <tr>
                	<td class=title>������� ������</td>
                	<td > <input type="radio" name="aeb_yn" value="N" <%if(cm_bean.getAeb_yn().equals("N"))%>checked<%%>>
                		���ش�
                		<input type="radio" name="aeb_yn" value="Y" <%if(cm_bean.getAeb_yn().equals("Y"))%>checked<%%>>
                		�ش�</td>
                </tr>
                <tr>
                	<td class=title>������� �����</td>
                	<td > <input type="radio" name="fcw_yn" value="N" <%if(cm_bean.getFcw_yn().equals("N"))%>checked<%%>>
                		���ش�
                		<input type="radio" name="fcw_yn" value="Y" <%if(cm_bean.getFcw_yn().equals("Y"))%>checked<%%>>
                		�ش�</td>
                </tr>
                <tr> 
                    <td class=title>��������</td>
                    <td > <input type="text" name="car_b_dt" value="<%//=AddUtil.ChangeDate2(cm_bean.getCar_b_dt())%>" size="15" class=<%=white%>text onBlur='javscript:this.value = ChangeDate(this.value);'> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>���</td>
                    <td > <textarea name="etc" cols="110" class="text" rows="2" <%=readonly%> maxlength="200"><%=cm_bean.getEtc()%></textarea> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>��Ÿ</td>		<!-- ��Ÿ �߰�(2018.02.08) -->
                    <td > <textarea name="etc2" cols="110" class="text" rows="2" <%=readonly%> placeholder="(������ ��Ÿ���� �������� �κ��Դϴ�)" maxlength="200"><%=cm_bean.getEtc2()%></textarea> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>���꿩��</td>
                    <td > 
                    	<input type="radio" name="end_dt" value="Y" <%if(cm_bean.getEnd_dt().equals("Y"))%>checked<%%>>
                      ����
                      <input type="radio" name="end_dt" value="N" <%if(cm_bean.getEnd_dt().equals("N"))%>checked<%%>>
                      ����
                    </td>
                </tr>                
            </table>
        </td>
    </tr>
    <%if(ej_bean.getJg_w().equals("1")){%>
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
                    <td> <input type="text" name="car_b_p2" value="<%=AddUtil.parseDecimal(cm_bean.getCar_b_p2())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        ��
                    </td>
                </tr>
                <tr>
                    <td class=title>���ݰ�꼭D/C</td>
                    <td>��Ʈ
                        <input type="text" name="r_dc_amt" value="<%=AddUtil.parseDecimal(cm_bean.getR_dc_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        �� / ���� 
                        <input type="text" name="l_dc_amt" value="<%=AddUtil.parseDecimal(cm_bean.getL_dc_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        ��
                    </td>
                </tr>
                <tr>
                    <td class=title>ī������ݾ�</td>
                    <td>��Ʈ
                        <input type="text" name="r_card_amt" value="<%=AddUtil.parseDecimal(cm_bean.getR_card_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        �� / ���� 
                        <input type="text" name="l_card_amt" value="<%=AddUtil.parseDecimal(cm_bean.getL_card_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        ��
                    </td>
                </tr>                        
                <tr>
                    <td class=title>Cash Back </td>
                    <td>��Ʈ
                        <input type="text" name="r_cash_back" value="<%=AddUtil.parseDecimal(cm_bean.getR_cash_back())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        �� / ����
                        <input type="text" name="l_cash_back" value="<%=AddUtil.parseDecimal(cm_bean.getL_cash_back())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        ��
                    </td>
                </tr>    
                <tr>
                    <td class=title>Ź�۽��ú���</td>
                    <td>��Ʈ
                        <input type="text" name="r_bank_amt" value="<%=AddUtil.parseDecimal(cm_bean.getR_bank_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        �� / ����
                        <input type="text" name="l_bank_amt" value="<%=AddUtil.parseDecimal(cm_bean.getL_bank_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        ��
                    </td>
                </tr>                                        
                            
            </table>
        </td>
        <td width="20" bgcolor="#FFFFFF">&nbsp;</td>
    </tr>                 
    <%}%>    

</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
