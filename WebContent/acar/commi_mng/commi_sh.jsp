<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.user_mng.*, acar.common.*, acar.util.*, acar.car_office.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"11":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"2":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String f_list = request.getParameter("f_list")==null?"now":request.getParameter("f_list");
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase co_db = CarOfficeDatabase.getInstance();
	
	//�ڵ���ȸ�� ����Ʈ
	CarCompBean cc_r [] = co_db.getCarCompAll();	
	int car_comp_size = cc_r.length;
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();	
	
  	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	
%>
	
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'){ //���������
			fm.t_wd.value = fm.s_bus.options[fm.s_bus.selectedIndex].value;
		}
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '11'){ //�ڵ���������
			fm.t_wd.value = fm.s_off.options[fm.s_off.selectedIndex].value;
		}		
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '6'){ //������
			fm.t_wd.value = fm.s_brch.options[fm.s_brch.selectedIndex].value;
		}					
		if(fm.st_dt.value != ''){ fm.st_dt.value = ChangeDate3(fm.st_dt.value);	}
		if(fm.end_dt.value != ''){ fm.end_dt.value = ChangeDate3(fm.end_dt.value);	}
		if(fm.st_dt.value !='' && fm.end_dt.value==''){ fm.end_dt.value = fm.st_dt.value; }		
		fm.action='/acar/commi_mng/commi_sc.jsp';
		fm.target='c_foot';		
		fm.submit()
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
		
	//���÷��� Ÿ��(�˻�) -�˻����� ���ý�
	function cng_input(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'){ //���������
			td_input.style.display	= 'none';
			td_bus.style.display	= '';
			td_off.style.display	= 'none';			
			td_brch.style.display	= 'none';																
		}else if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '11'){ //�ڵ���������
			td_input.style.display	= 'none';
			td_bus.style.display	= 'none';
			td_off.style.display	= '';		
			td_brch.style.display	= 'none';													
		}else if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '6'){ //������
			td_input.style.display	= 'none';
			td_bus.style.display	= 'none';		
			td_off.style.display	= 'none';						
			td_brch.style.display	= '';													
		}else{
			td_input.style.display	= '';
			td_bus.style.display	= 'none';
			td_off.style.display	= 'none';						
			td_brch.style.display	= 'none';																
		}
	}	
	
	//���÷��� Ÿ��(�˻�)-������ȸ ���ý�
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '4'){ //�Ⱓ
			td_dt.style.display	 = '';
		}else{
			if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '5'){ //�˻�
				fm.gubun3.options[0].selected = true;
			}				
			td_dt.style.display	 = 'none';
		}
	}		

	//�ڵ���ȸ�� ���ý� �ڵ��������� ����
	function change_car_off(){
		var fm = document.form1;
		if(fm.gubun4.options[fm.gubun4.selectedIndex].value == ''){
			drop_off();
			add_off(0, '', '�ڵ���ȸ�縦 �����Ͻʽÿ�');
			return;
		}else{
			fm.action='commi_sh_nodisplay.jsp';
			fm.target='i_no';
			fm.submit();
		}
	}
	function drop_off(){
		var fm = document.form1;
		var car_len = fm.s_off.length;
		
		for(var i = 0 ; i < car_len ; i++){
			fm.s_off.options[car_len-(i+1)] = null;
		}
	}	
	function add_off(idx, val, str){
		document.form1.s_off[idx] = new Option(str, val);
	}	

	/*
	//���� ������ ����Ʈ �̵�
	function list_move()
	{
		var fm = document.form1;
		var url = "";
		fm.auth_rw.value = "";		
		fm.gubun4.value = "";
		var idx = fm.gubun1.options[fm.gubun1.selectedIndex].value;
		if(idx == '1') 		url = "/fms2/con_fee/fee_frame_s.jsp";
		else if(idx == '2') url = "/fms2/con_grt/grt_frame_s.jsp";
		else if(idx == '3') url = "/acar/con_forfeit/forfeit_frame_s.jsp";
		else if(idx == '4') url = "/fms2/con_ins_m/ins_m_frame_s.jsp";
		else if(idx == '5') url = "/fms2/con_ins_h/ins_h_frame_s.jsp";
		else if(idx == '6') url = "/fms2/con_cls/cls_frame_s.jsp";		
		else if(idx == '7') url = "/acar/settle_acc/settle_s_frame.jsp";	
		else if(idx == '8') url = "/acar/con_debt/debt_frame_s.jsp";
		else if(idx == '9') url = "/acar/con_ins/ins_frame_s.jsp?f_list=now";
		else if(idx == '10') url = "/acar/forfeit_mng/forfeit_s_frame.jsp";
		else if(idx == '11') url = "/acar/commi_mng/commi_frame_s.jsp";
		else if(idx == '12') url = "/acar/mng_exp/exp_frame_s.jsp";		
		else if(idx == '13') url = "/acar/con_tax/tax_frame_s.jsp";								
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();								
	}	
	*/			
//-->
</script>
</head>
<body>
<form name='form1' action='ins_sc_in.jsp' target='inner' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='f_list' value='<%=f_list%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ����������� > <span class=style5>���޼��������</span></span></td>
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
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    
                    <!--20130902 �Ⱥ���� ������û
                    <td width='18%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jhgb.gif align=absmiddle>&nbsp;
                        <select name="gubun1">
                            <option value="" <%if(gubun1.equals("")){%>selected<%}%>>��ü</option>
                            <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>��������</option>
                            <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>���������</option>
                            <option value="3" <%if(gubun1.equals("3")){%>selected<%}%>>���������������</option>
                            <option value="4" <%if(gubun1.equals("4")){%>selected<%}%>>�����������</option>
                        </select>
                    </td>
                    -->
                    <td width='18%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jhgb.gif align=absmiddle>&nbsp;
                        <select name="gubun1">
                            <option value="" <%if(gubun1.equals("")){%>selected<%}%>>��ü</option>
                            <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>��õ¡��</option>
                            <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>���ݰ�꼭</option>
                        </select>
                    </td>                    
                    <td width='18%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_ssjh.gif align=absmiddle>&nbsp;
                        <select name="gubun2" onChange="javascript:cng_input1()">
                            <option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>���</option>
                            <option value="6" <%if(gubun2.equals("6")){%>selected<%}%>>����</option>
                            <option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>����</option>
                            <option value="4" <%if(gubun2.equals("4")){%>selected<%}%>>�Ⱓ</option>
                            <option value="5" <%if(gubun2.equals("5")){%>selected<%}%>>�˻�</option>
                        </select>
                    </td>
                    <td width='14%'><img src=/acar/images/center/arrow_sbjh.gif align=absmiddle>&nbsp;
                        <select name="gubun3">
                            <option value="1" <%if(gubun3.equals("1")){%>selected<%}%>>��ȹ</option>
                            <option value="2" <%if(gubun3.equals("2")){%>selected<%}%>>����</option>
                            <option value="3" <%if(gubun3.equals("3")){%>selected<%}%>>������</option>
                        </select>
                    </td>
                    <td align="left" width="16%"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td id='td_dt' <%if(gubun2.equals("4")){%>style="display:''"<%}else{%>style='display:none'<%}%>> 
                                    <input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                                    ~ 
                                    <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td> 
                        <select name="gubun4"  onChange='javascript:change_car_off()'>			  
                            <option value="" <%if(gubun4.equals("")){%>selected<%}%>>��ü</option>
            				<%if(car_comp_size > 0){
            			    	for(int i=0; i<cc_r.length; i++){
            			        	CarCompBean cc_bean = cc_r[i];%>
               				<option value="<%= cc_bean.getCode() %>" <%if(gubun4.equals(cc_bean.getCode())){%>selected<%}%>><%= cc_bean.getNm() %></option>
            				<%	}
            				}%>				
                        </select>				
                    </td>
                </tr>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
                        <select name='s_kd' onChange="javascript:document.form1.t_wd.value='', cng_input()">
                            <option value='0' <%if(s_kd.equals("0")){%> selected <%}%>>��ü</option>
                            <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>��ȣ</option>
                            <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>����</option>
                            <option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>����ȣ</option>
                            <option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>������ȣ</option>
                            <option value='9' <%if(s_kd.equals("9")){%> selected <%}%>>����</option>
                            <option value='10' <%if(s_kd.equals("10")){%> selected <%}%>>�������</option>
                            <option value='11' <%if(s_kd.equals("11")){%> selected <%}%>>�ڵ���������</option>
                            <option value='12' <%if(s_kd.equals("12")){%> selected <%}%>>���������</option>				
                            <option value='6' <%if(s_kd.equals("6")){%> selected <%}%>>�������ڵ�</option>
                            <option value='8' <%if(s_kd.equals("8")){%> selected <%}%>>���������</option>
                            <option value='13' <%if(s_kd.equals("13")){%> selected <%}%>>�Ǽ�����</option>
                        </select>
                    </td>
                    <td> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td id='td_input' <%if(s_kd.equals("8") || s_kd.equals("6") || s_kd.equals("11")){%> style='display:none'<%}%>> 
                                    <input type='text' name='t_wd' size='17' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()'>
                                </td>
                                <td id='td_bus' <%if(s_kd.equals("8")){%> style="display:''"<%}else{%>style='display:none'<%}%>> 
                                    <select name='s_bus'>
                                      <option value="">������</option>
                                       <%if(user_size > 0){
                								for(int i = 0 ; i < user_size ; i++){
                									Hashtable user = (Hashtable)users.elementAt(i); 
                						%>
                							           <option value='<%=user.get("USER_ID")%>' <%if(t_wd.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                			                <%	}
                							}		%>
                                                 								
                                    </select>
                                </td>
                                <td id='td_off' <%if(s_kd.equals("11")){%> style="display:''"<%}else{%>style='display:none'<%}%>> 
                                    <select name='s_off'>
                            			<option value=''>�ڵ���ȸ�縦�����Ͻʽÿ�</option>
                					</select>
                                </td>	
                                <td id='td_brch' <%if(s_kd.equals("6")){%> style="display:''"<%}else{%>style='display:none'<%}%>> 
                			        <select name='s_brch' onChange='javascript:search();'>
                			          <option value=''>��ü</option>
                			          <%Vector branches = c_db.getBranchList(); //������ ����Ʈ ��ȸ
                						int brch_size = branches.size();					  
                					  	if(brch_size > 0){
                								for (int i = 0 ; i < brch_size ; i++){
                									Hashtable branch = (Hashtable)branches.elementAt(i);%>
                			          <option value='<%= branch.get("BR_ID") %>'  <%if(t_wd.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
                			          <%= branch.get("BR_NM")%> </option>
                			          <%		}
                							}		%>
                			        </select>
                                </td>							  			  
                            </tr>
                        </table>
                    </td>
                    <td><img src=/acar/images/center/arrow_jrjg.gif align=absmiddle>&nbsp;
                        <select name='sort_gubun' onChange='javascript:search()'>
                            <option value='0' <%if(sort_gubun.equals("0")){%> selected <%}%>>��������</option>
                            <option value='1' <%if(sort_gubun.equals("1")){%> selected <%}%>>�ڵ���ȸ���</option>
                            <option value='2' <%if(sort_gubun.equals("2")){%> selected <%}%>>�����Ҹ�</option>
                            <option value='3' <%if(sort_gubun.equals("3")){%> selected <%}%>>�������</option>
                            <option value='5' <%if(sort_gubun.equals("5")){%> selected <%}%>>������ȣ</option>
                        </select>
                    </td>
                    <td> 
                        &nbsp;<input type='radio' name='asc' value='0' checked onClick='javascript:search()'>
                        �������� 
                        <input type='radio' name='asc' value='1' onClick='javascript:search()'>
                        �������� </td>
                    <td>				
        			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        			    <a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a> 
                    </td>
                </tr>
            </table>
        </td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
