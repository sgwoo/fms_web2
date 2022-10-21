<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="co_bean" class="acar.car_mst.CarOptBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");	
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq = request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");		
	String view_dt = request.getParameter("car_b_dt")==null?"":request.getParameter("car_b_dt");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	AddCarMstDatabase a_cmd = AddCarMstDatabase.getInstance();

	//��������
	cm_bean = a_cmd.getCarNmCase(car_id, car_seq);
	
	//��������
	Vector cars = a_cmd.getSearchCode(car_comp_id, car_cd, car_id, "", "9", "");
	int car_size = cars.size();
	
	//���û�� ����Ʈ
	CarOptBean [] co_r = a_cmd.getCarOptList(cm_bean.getCar_comp_id(), cm_bean.getCode(), car_id, cm_bean.getCar_seq(), view_dt);
		
	//�������� Ÿ�� ���û�� - ���� �Էº� ����
	Vector vt = a_cmd.getCarOptRegList(car_comp_id, car_cd, view_dt);
	int vt_size = vt.size();
	
	//������ �ܰ����� ����Ʈ
	Vector vt2 = a_cmd.getCarShCodeBdtJgOptList(cm_bean.getJg_code(), "");
	int vt_size2 = vt2.size();
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript">
<!--
	//�����ϱ�
	function Save(mode, idx){
		var fm = document.form1;
		var size = toInt(fm.size.value);
		var ment;
		if(mode == 'u' || mode == 'd' || mode == 'i'){
			fm.h_car_s_seq.value 	= fm.car_s_seq[idx].value;
			fm.h_car_s.value 	= fm.car_s[idx].value;
			fm.h_car_s_p.value 	= fm.car_s_p[idx].value;
			fm.h_car_s_dt.value  	= fm.car_s_dt[idx].value;
			fm.h_use_yn.value  	= fm.use_yn[idx].value;	
			fm.h_opt_b.value 	= fm.opt_b[idx].value;
			fm.h_jg_opt_st.value	= fm.jg_opt_st[idx].value;
			fm.h_jg_tuix_st.value	= fm.jg_tuix_st[idx].value;
			fm.h_lkas_yn.value	= fm.lkas_yn[idx].value;
			fm.h_ldws_yn.value	= fm.ldws_yn[idx].value;
			fm.h_aeb_yn.value	= fm.aeb_yn[idx].value;
			fm.h_fcw_yn.value	= fm.fcw_yn[idx].value;
			fm.h_car_rank.value	= fm.car_rank[idx].value;
			fm.h_jg_opt_yn.value	= fm.jg_opt_yn[idx].value;
			fm.h_garnish_yn.value	= fm.garnish_yn[idx].value;			
			fm.h_hook_yn.value	= fm.hook_yn[idx].value;			
			
			if(mode == 'u'){
				ment = '����';
			}else if(mode == 'd'){
				ment = '����';
			}else if(mode == 'i'){
				ment = '���';
			}
			
			if(fm.h_car_s.value == ''){ 	alert('�ɼǸ��� Ȯ���Ͻʽÿ�'); 	return; }
			if(fm.h_car_s_p.value == ''){ 	alert('�ɼǰ����� Ȯ���Ͻʽÿ�'); 	return; }
			if(fm.h_car_s_dt.value == ''){ 	alert('�������ڸ� Ȯ���Ͻʽÿ�'); 	return; }		
			if(!max_length(fm.h_car_s.value, 1000)){ alert('�⺻����� ����1000��/�ѱ�500�ڸ� �ʰ��Ͽ����ϴ�.\n\nȮ���Ͻʽÿ�'); return; }					
		}		
		
		if(!confirm(ment+'�Ͻðڽ��ϱ�?')){	return;	}
		fm.mode.value = mode;
		fm.action = 'car_opt_a.jsp';			
		fm.target = "i_no";
		fm.submit();
	}	
	
	//�������� �����ϱ�
	function Save_oderby(mode){
		var fm = document.form1;						
		if(!confirm('���������� �����Ͻðڽ��ϱ�?')){	return;	}
		fm.mode.value = mode;
		fm.action = 'car_opt_a.jsp';			
		fm.target = "i_no";
		fm.submit();
	}
	
	//��ü�����ϱ�
	function All_Save(){
		var fm = document.form1;						
		if(!confirm('��ü�����Ͻðڽ��ϱ�?')){	return;	}
		fm.mode.value = 'all';
		fm.action = 'car_opt_a.jsp';			
		fm.target = "i_no";
		fm.submit();
	}			
	
	function search(){
		var fm = document.form1;
		fm.target='popwin2';
		fm.action="car_opt.jsp";
		fm.submit();
	}
	
	function opt_set(idx){
		var fm = document.form1;
		var s_opt = fm.s_opt[idx].value;
		var ch_split = s_opt.split("||");	
		fm.car_s[idx].value 	= ch_split[0];
		if(ch_split[1] == undefined){
			fm.opt_b[idx].value 	= "";
		}else {
			fm.opt_b[idx].value 	= ch_split[1];	
		}
		fm.car_s_p[idx].value 	= parseDecimal(ch_split[2]);	
		fm.car_s_dt[idx].value 	= ch_split[3];	
		fm.jg_opt_st[idx].value = ch_split[4];	
		fm.jg_tuix_st[idx].value = ch_split[5];
		fm.jg_opt_yn[idx].value = ch_split[6];
		fm.lkas_yn[idx].value = ch_split[7];
		fm.ldws_yn[idx].value = ch_split[8];
		fm.aeb_yn[idx].value = ch_split[9];
		fm.fcw_yn[idx].value = ch_split[10];
		fm.hook_yn[idx].value = ch_split[11];
	}	
	
//-->
</script>
<script>
$(document).ready(function() {
	
	rankIndex();

	function rankIndex() {		
		var rank = $(".rank");
		var rankLen = $(".rank").length;
		
		for (var i = 0; i < rankLen; i++) {
			$(rank[i]).val(i+1);
		}
	}
	
	$('.rankUp').click(function() {
		var tr = $(this).closest('tr');
        tr.prev().before(tr);
        rankIndex();
    });
	
	$('.rankDown').click(function() {
		var tr = $(this).closest('tr');
		tr.next().after(tr);
		rankIndex();
    });
	
});
</script>
</head>
<body leftmargin="15" onLoad="javascript:document.form1.car_s<% if(co_r.length>0) %>[0]<%  %>.focus()">
<form action="./car_opt_a.jsp" name="form1" method="POST">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="br_id" value="<%=br_id%>">
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type="hidden" name="car_comp_id" value="<%=cm_bean.getCar_comp_id()%>">
	<input type="hidden" name="car_cd" value="<%=cm_bean.getCode()%>">
	<input type="hidden" name="car_id" value="<%=cm_bean.getCar_id()%>">
	<input type="hidden" name="car_seq" value="<%=cm_bean.getCar_seq()%>">
	<input type="hidden" name="car_nm" value="<%=car_nm%>">
	<input type="hidden" name="car_b_dt" value="<%=cm_bean.getCar_b_dt()%>">
	<input type="hidden" name="cmd" value="<%=cmd%>">
	<input type="hidden" name="size" value="<%=co_r.length%>">
	<input type="hidden" name="mode" value="">
	<input type="hidden" name="h_car_s_seq" value="">
	<input type="hidden" name="h_car_s" value="">
	<input type="hidden" name="h_car_s_p" value="">
	<input type="hidden" name="h_car_s_dt" value="">
	<input type="hidden" name="h_use_yn" value="">
	<input type="hidden" name="h_opt_b" value="">
	<input type="hidden" name="h_jg_opt_st" value="">
	<input type="hidden" name="h_jg_tuix_st" value="">
	<input type="hidden" name="h_lkas_yn" value="">
	<input type="hidden" name="h_ldws_yn" value="">
	<input type="hidden" name="h_aeb_yn" value="">
	<input type="hidden" name="h_fcw_yn" value="">
	<input type="hidden" name="h_car_rank" value="">
	<input type="hidden" name="h_jg_opt_yn" value="">
	<input type="hidden" name="h_garnish_yn" value="">
	<input type="hidden" name="h_hook_yn" value="">
	<input type="hidden" name="view_dt" value="<%=view_dt%>">
	<input type="hidden" name="s_opt_size" value="<%=vt_size%>">
	
	<table border=0 cellspacing=0 cellpadding=0 width="100%">
	    <tr>
	        <td>
	            <table border="0" cellspacing="0" cellpadding="0" width="100%">
	                <tr>
	                    <td>&nbsp;
	                      <img src=../images/center/arrow_cm.gif>&nbsp;&nbsp;<b>[ <%=car_nm%> ]</b> <%=cm_bean.getCar_name()%> <%=cm_bean.getJg_code()%>&nbsp;&nbsp;
	                      <img src=../images/center/arrow_gjij.gif>&nbsp; 
	                      <%=AddUtil.ChangeDate2(view_dt)%>	                      
	                    </td>
	                </tr>
	            </table>
	        </td>
	    </tr>
	    <tr>
	        <td class=h></td>
	    </tr>
	    <tr>
	        <td align="right">
	        <%if(!auth_rw.equals("1")){%>
		        <a href="javascript:Save_oderby('ob')">[�������� ����]</a>
		        <a href="javascript:All_Save()">[�ϰ�ó��]</a>
		        &nbsp;&nbsp;
	        <%}%>
	        	<a href="javascript:self.close()"><img src=../images/center/button_close.gif border=0 align=absmiddle></a>
	        </td>
	    </tr>
	    <tr>
	        <td class=line2></td>
	    </tr>
	    <tr>
	        <td class=line>
	            <table border="0" cellspacing="1" cellpadding="0" width="100%">
	            	<thead>
		                <tr>
		                    <td class=title style="display: none;">����</td>
		                    <td class=title width="10%">���û��ǰ��</td>
		                    <td class=title width="10%">���γ���</td>
		                    <td class=title width="6%">�����ܰ�</td>
		                    <td class=title width="6%">����</td>
		                    <td class=title width="4%"><span style="font-size:85%">TUIX/TUON<br>�ɼǿ���</span></td>
		                    <td class=title width="4%"><span style="font-size:85%">�ܰ��ݿ�<br>����</span></td>
		                    <td class=title width="4%"><span style="font-size:85%">������Ż<br>������</span></td>
		                    <td class=title width="4%"><span style="font-size:85%">������Ż<br>�����</span></td>
		                    <td class=title width="4%"><span style="font-size:85%">�������<br>������</span></td>
		                    <td class=title width="4%"><span style="font-size:85%">�������<br>�����</span></td>
		                    <td class=title width="4%"><span style="font-size:85%">���Ͻ� ����</span></td>
		                    <td class=title width="6%"><span style="font-size:85%">���ΰ�<br>(Ʈ���Ϸ���)</span></td>
		                    <td class=title width="12%">�ݾ�</td>
		                    <td class=title width="10%">��������</td>
		                    <td class=title width="5%">���<br>����</td>
		                    <td class=title width="5%">ó��</td>
		                </tr>
	                </thead>
	                <tbody>
	              <%	for(int i=0; i<co_r.length; i++){
	    			        co_bean = co_r[i];%>
		                <tr> 
		                    <td align="center"  style="display: none;">
		                    	<%=i+1%>
		                    	<input type="hidden" name="car_s_seq" value="<%=co_bean.getCar_s_seq()%>">
		    					<input type="hidden" name="s_opt" value="">
		                    </td>
		                    <td align="center">
		                    	<textarea cols="28" rows="4" name="car_s"><%=co_bean.getCar_s()%></textarea>
		                    </td>
		                    <td align="center">
		                    	<textarea cols="28" rows="4" name="opt_b"><%=co_bean.getOpt_b()%></textarea>
		                    </td>
		                    <td align="center">
		                      	<select name="jg_opt_st">
			                        <option value="" selected>����</option>
		                       		<%for(int j = 0 ; j < vt_size2 ; j++){
		       							Hashtable ht = (Hashtable)vt2.elementAt(j);%>
					        		<option value="<%=ht.get("JG_OPT_ST")%>" <% if(co_bean.getJg_opt_st().equals(String.valueOf(ht.get("JG_OPT_ST")))) out.print("selected"); %>>[<%=ht.get("JG_OPT_ST")%>]<%=ht.get("JG_OPT_1")%></option>
									<%}%>
				      			</select>
				      			<input type="hidden" class="rank" name="car_rank" value="">
		                    </td>
		                    <td align="center">
		                    	<button type="button" class="rankUp" onmouseover="this.style.cursor='pointer'" style="border: 0px; background-color: #FFFFFF; width: 39px; height: 17px; padding: 0px; margin-bottom:7px;"><img src=../images/center/button_in_up.png border=0></button><br/> <!-- onclick="moveUp(this)" -->
		                    	<button type="button" class="rankDown" onmouseover="this.style.cursor='pointer'" style="border: 0px; background-color: #FFFFFF; width: 50px; height: 17px; padding: 0px;"><img src=../images/center/button_in_down.png border=0></button> <!-- onclick="moveDown(this)" -->
		                    </td>
		                    <td align="center">
		                    	<select name="jg_tuix_st" style="size:3.5em;">
		            				<option value=""  <% if(co_bean.getJg_tuix_st().equals(""))  out.print("selected"); %>>����</option>
		        					<option value="N" <% if(co_bean.getJg_tuix_st().equals("N")) out.print("selected"); %>>���ش�</option>
		        					<option value="Y" <% if(co_bean.getJg_tuix_st().equals("Y")) out.print("selected"); %>>�ش�</option>
				      			</select>
		                    </td>
		                    <td align="center">
		                    	<select name="jg_opt_yn" style="size:3.5em;">
		        					<option value="" <% if(co_bean.getJg_opt_yn().equals(""))  out.print("selected"); %>>����</option>
		        					<option value="Y" <% if(co_bean.getJg_opt_yn().equals("Y")) out.print("selected"); %>>�ܰ��ݿ�</option>
		        					<option value="N" <% if(co_bean.getJg_opt_yn().equals("N")) out.print("selected"); %>>�ܰ��̹ݿ�</option>
				      			</select>
		                    </td>
		                    <td>
		                    	<select name="lkas_yn" style="size:3.5em;">
		            				<option value=""  <% if(co_bean.getLkas_yn().equals(""))  out.print("selected"); %>>����</option>
		        					<option value="N" <% if(co_bean.getLkas_yn().equals("N")) out.print("selected"); %>>���ش�</option>
		        					<option value="Y" <% if(co_bean.getLkas_yn().equals("Y")) out.print("selected"); %>>�ش�</option>
				      			</select>
		                    </td>
		                    <td>
		                    	<select name="ldws_yn" style="size:3.5em;">
		            				<option value=""  <% if(co_bean.getLdws_yn().equals(""))  out.print("selected"); %>>����</option>
		        					<option value="N" <% if(co_bean.getLdws_yn().equals("N")) out.print("selected"); %>>���ش�</option>
		        					<option value="Y" <% if(co_bean.getLdws_yn().equals("Y")) out.print("selected"); %>>�ش�</option>
				      			</select>
		                    </td>
		                    <td>
		                    	<select name="aeb_yn" style="size:3.5em;">
		            				<option value=""  <% if(co_bean.getAeb_yn().equals(""))  out.print("selected"); %>>����</option>
		        					<option value="N" <% if(co_bean.getAeb_yn().equals("N")) out.print("selected"); %>>���ش�</option>
		        					<option value="Y" <% if(co_bean.getAeb_yn().equals("Y")) out.print("selected"); %>>�ش�</option>
				      			</select>
		                    </td>
		                    <td>
		                    	<select name="fcw_yn" style="size:3.5em;">
		           					<option value=""  <% if(co_bean.getFcw_yn().equals(""))  out.print("selected"); %>>����</option>
		        					<option value="N" <% if(co_bean.getFcw_yn().equals("N")) out.print("selected"); %>>���ش�</option>
		        					<option value="Y" <% if(co_bean.getFcw_yn().equals("Y")) out.print("selected"); %>>�ش�</option>
				      			</select>
		                    </td>
		                    <td>
		                    	<select name="garnish_yn" style="size:3.5em;">
		           					<option value=""  <% if(co_bean.getGarnish_yn().equals(""))  out.print("selected"); %>>����</option>
		        					<option value="N" <% if(co_bean.getGarnish_yn().equals("N")) out.print("selected"); %>>���ش�</option>
		        					<option value="Y" <% if(co_bean.getGarnish_yn().equals("Y")) out.print("selected"); %>>�ش�</option>
				      			</select>
		                    </td>
		                    <td align="center">
		                    	<select name="hook_yn" style="size:3.5em;">
		           					<option value=""  <% if(co_bean.getHook_yn().equals(""))  out.print("selected"); %>>����</option>
		        					<option value="N" <% if(co_bean.getHook_yn().equals("N")) out.print("selected"); %>>���ش�</option>
		        					<option value="Y" <% if(co_bean.getHook_yn().equals("Y")) out.print("selected"); %>>�ش�</option>
				      			</select>
		                    </td>
		                    <td align="center">
		                    	<input type="text" name="car_s_p" value="<%=AddUtil.parseDecimal(co_bean.getCar_s_p())%>" size="7" class=num>��</td>
		                    <td align="center">
		                    	<input type="text" name="car_s_dt" value="<%=AddUtil.ChangeDate2(co_bean.getCar_s_dt())%>" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
		                    </td>
		                    <td align="center">
		                    	<select name="use_yn">
				        			<option value="Y" <% if(co_bean.getUse_yn().equals("Y")) out.print("selected"); %>>Y</option>
				        			<option value="N" <% if(co_bean.getUse_yn().equals("N")) out.print("selected"); %>>N</option>
						    	</select>
		                    </td>
		                    <td align="center">
		                    <%if(!auth_rw.equals("1")){%>
			                    <a href="javascript:Save('u', '<%=i%>')">
			                    	<img src=../images/center/button_in_modify.gif border=0 align=absmiddle style="margin-bottom:7px">
			                    </a><br>
			                    <a href="javascript:Save('d', '<%=i%>')">
			                    	<img src=../images/center/button_in_delete.gif border=0 align=absmiddle>
			                    </a>
		                    <%}%>
		                    </td>
		                </tr>
	              <%	}	%>
	              	</tbody>
	            </table>
	        </td>
	    </tr>
	    <tr>
	        <td>&nbsp;</td>
	    </tr>
	    <tr>
	        <td class=line2></td>
	    </tr>
	    <tr>
	        <td class=line>
				<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<!--�߰�-->
				<%	for(int i=co_r.length; i<(co_r.length+5); i++){%>
					<tr>
	                    <td rowspan="2" width="3%" align="center">
	                    	<span style="font-size:85%">�߰�</span>
	                    	<input type="hidden" name="car_s_seq" value="">
	                    	<input type="hidden" class="rank" name="car_rank" value="">
	                    </td>
	                    <td colspan="13" width="89%" align="center">
	                    	<select name="s_opt" onChange="javascript:opt_set(<%=i%>)">
								<option value="" selected>����</option>
	                       		<%for(int j = 0 ; j < vt_size ; j++){
	        						Hashtable ht = (Hashtable)vt.elementAt(j);%>
								<option value="<%=ht.get("CAR_S")%>||<%=ht.get("OPT_B")%>||<%=ht.get("CAR_S_P")%>||<%=ht.get("E_DT")%>||<%=ht.get("JG_OPT_ST")%>||<%=ht.get("JG_TUIX_ST")%>||<%=ht.get("JG_OPT_YN")%>||<%=ht.get("LKAS_YN")%>||<%=ht.get("LDWS_YN")%>||<%=ht.get("AEB_YN")%>||<%=ht.get("FCW_YN")%>||<%=ht.get("HOOK_YN")%>">[<%=ht.get("E_DT")%>]<%=ht.get("CAR_S")%>-<%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_S_P")))%></option>
								<%}%>
							</select>
	                    </td>
						<td rowspan="2"  width="4%" align="center"><!-- ��뿩�� -->
							<select name="use_yn">
								<option value="Y" selected>Y</option>
								<option value="N">N</option>
							</select>
	                    </td>
	                    <td rowspan="2"  width="4%" align="center"><!-- ��� -->
	                    <%if(!auth_rw.equals("1")){%>
	                    	<a href="javascript:Save('i', '<%=i%>')">
	                    		<img src=../images/center/button_in_reg.gif border=0 align=absmiddle>
	                    	</a>
	                    <%}%>
	                    </td>
	                </tr>
	                <tr>
		                <td align="center" width="16%"><!-- ���û��ǰ�� -->
		                	<textarea cols="28" rows="4" name="car_s"></textarea>
		                </td>
		                <td align="center" width="16%"><!-- ���γ��� -->
		                	<textarea cols="28" rows="4" name="opt_b"></textarea>
		                </td>
		                <td align="center" width="9%"><!-- �����ܰ� --> 
							<select name="jg_opt_st">
		                      	<option value="" selected>����</option>
	                      		<%for(int j = 0 ; j < vt_size2 ; j++){
			      					Hashtable ht = (Hashtable)vt2.elementAt(j);%>
			      				<option value="<%=ht.get("JG_OPT_ST")%>">[<%=ht.get("JG_OPT_ST")%>]<%=ht.get("JG_OPT_1")%></option>
								<%}%>
							</select>
	                  	</td>
	                  	<td align="center" width="4%"><!-- TUIX/TUON �ɼ�ǰ�� -->
	                  		<select name="jg_tuix_st" style="size:3.5em;">
			                   	<option value="" >����</option>
			       				<option value="N" >���ش�</option>
			       				<option value="Y" >�ش�</option>
			      			</select>
						</td>
		                <td align="center" width="4%"><!-- TUIX/TUON �ܰ��ݿ����� -->
		                  	<select name="jg_opt_yn" style="size:3.5em;">
		          				<option value="">����</option>
		      					<option value="Y">�ܰ��ݿ�</option>
		      					<option value="N">�ܰ��̹ݿ�</option>
		      				</select>
		                </td>
		                <td align="center" width="4%"><!-- ������Ż ������ -->
		                	<select name="lkas_yn" style="size:3.5em;">
			                   	<option value="" >����</option>
			        			<option value="N" >���ش�</option>
				        		<option value="Y" >�ش�</option>
				     		</select>
		                </td>
		                <td align="center" width="4%"><!-- ������Ż ����� -->
		                	<select name="ldws_yn" style="size:3.5em;">
			                  	<option value="" >����</option>
				        		<option value="N" >���ش�</option>
				        		<option value="Y" >�ش�</option>
			      			</select>
		                </td>
		                <td align="center" width="4%"><!-- ������� ������ -->
		                	<select name="aeb_yn" style="size:3.5em;">
			                   	<option value="" >����</option>
				        		<option value="N" >���ش�</option>
				        		<option value="Y" >�ش�</option>
			      			</select>
		                </td>
		                <td align="center" width="4%"><!-- ������� ����� -->
							<select name="fcw_yn" style="size:3.5em;">
		                    	<option value="" >����</option>
			        			<option value="N" >���ش�</option>
			        			<option value="Y" >�ش�</option>
				      		</select>
		                </td>
		                <td align="center" width="4%"><!-- ���Ͻ����� -->
							<select name="garnish_yn" style="size:3.5em;">
		                    	<option value="" >����</option>
			        			<option value="N" >���ش�</option>
			        			<option value="Y" >�ش�</option>
				      		</select>
		                </td>
		                <td align="center" width="6%"><!-- ���ΰ� -->
							<select name="hook_yn" style="size:3.5em;">
		                    	<option value="" >����</option>
			        			<option value="N" >���ش�</option>
			        			<option value="Y" >�ش�</option>
				      		</select>
		                </td>
		                <td align="center" width="9%"><!-- �ݾ� -->
		                    <input type="text" name="car_s_p" value="" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>��
		                </td>
		                <td align="center" width="9%"><!-- �������� -->
		                    <input type="text" name="car_s_dt" size="11" value="<%= AddUtil.getDate() %>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
		                </td>
	                </tr>
	                <%}%>
	              
	            </table>
	        </td>
	    </tr>
	    <tr>
	        <td class=h></td>
	    </tr>
	    <tr>
	        <td align="right">
	        <%if(!auth_rw.equals("1")){%>
		        <a href="javascript:All_Save()">[�ϰ�ó��]</a>
		        &nbsp;&nbsp;
	        <%}%>
		        <a href="javascript:self.close()"><img src=../images/center/button_close.gif border=0 align=absmiddle></a>
	        </td>
	    </tr>
	</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</body>
</html>
