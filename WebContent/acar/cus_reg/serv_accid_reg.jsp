<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_reg.*, acar.car_service.*, acar.serv_off.*, acar.cont.*"%>
<jsp:useBean id="cinfo_bean" class="acar.car_service.ContInfoBean" scope="page"/>
<jsp:useBean id="so_bean" class="acar.serv_off.ServOffBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id 		= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String accid_id 	= request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String accid_st 	= request.getParameter("accid_st")==null?"":request.getParameter("accid_st");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	int result=0;
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	CusReg_Database cr_db 	= CusReg_Database.getInstance();
	ServOffDatabase sod 	= ServOffDatabase.getInstance();
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	String dept_id = login.getDept_id(user_id);
	
	//rent_mng_id, rent_l_cd null�̸� ��ȸ
	if(rent_mng_id.equals("")||rent_l_cd.equals("")){
		Hashtable ht = c_db.getRent_id(car_mng_id);
		rent_mng_id = (String)ht.get("RENT_MNG_ID");
		rent_l_cd = (String)ht.get("RENT_L_CD");
	}
	
	//�������
	ContBaseBean base = a_db.getContBaseHi(rent_mng_id, rent_l_cd);
	
	//�ڵ������� ��ȸ
	CarInfoBean ci_bean = cr_db.getCarInfo(car_mng_id);
	
	//�����ڵ尡 ������ ���� �����ڵ� ��ȸ
	if(serv_id.equals("")){
		serv_id = cr_db.getServ_id(car_mng_id);
		result = cr_db.insertService(car_mng_id, serv_id, accid_id, rent_mng_id, rent_l_cd, ck_acar_id);
	}
	
	//�������� ��ȸ
	ServInfoBean siBn = cr_db.getServInfo(car_mng_id, serv_id);
	
	if(!siBn.getRent_mng_id().equals("")){
		rent_mng_id = siBn.getRent_mng_id();
		rent_l_cd 	= siBn.getRent_l_cd();
		accid_id 	= siBn.getAccid_id();
	}
	
	//������,������ ����Ʈ����
	if(siBn.getChecker().equals(""))	siBn.setChecker(base.getBus_id2());
	if(siBn.getIpgoza().equals(""))		siBn.setIpgoza(base.getBus_id2());
	
	//���¾�ü �⺻���� ����
	if(siBn.getOff_id().equals("")){
		if(user_id.equals("000047")){		//����������
		//	so_bean = sod.getServOff("000620");
			so_bean = sod.getServOff("009290");  //��mj				
		}else if(user_id.equals("000081")){	//����ī��ũ
			so_bean = sod.getServOff("001960");
		}else if(user_id.equals("000106")){	//�ΰ��ڵ�������
			so_bean = sod.getServOff("002105");
		}else if(user_id.equals("000173")){	//��������  // 20121217�� ������.
			so_bean = sod.getServOff("001816");
		}else if(user_id.equals("000112")){	//����ī��ũ����
			so_bean = sod.getServOff("002734");
		}else if(user_id.equals("000143")){	//���������ڵ����������
			so_bean = sod.getServOff("000286");
		}else if(user_id.equals("000154")){	//����ũ��
			so_bean = sod.getServOff("006858");
		}else if(user_id.equals("000171")){	//�����
			so_bean = sod.getServOff("007603");
		}else if(user_id.equals("000195")){	//1�ޱ�ȣ-����
			so_bean = sod.getServOff("007897");
		}else if(user_id.equals("000200")){	//����:����������
			so_bean = sod.getServOff("008507");
		}else if(user_id.equals("000198")){	//�뱸:(��)��������������
			so_bean = sod.getServOff("008462");
		}else if(user_id.equals("000210")){	//����:(��)�����ڵ���������
			so_bean = sod.getServOff("008611");
		}
		siBn.setOff_id(so_bean.getOff_id());
		siBn.setOff_nm(so_bean.getOff_nm());
	}
	
	double amt_sum 		= 0;
	double labor_sum 	= 0;
	if(!siBn.getServ_id().equals("")){
		Serv_ItemBean[] siIBns = cr_db.getServ_item(car_mng_id, serv_id, "asc");
		if(siIBns.length >0){
			for(int i=0; i<siIBns.length; i++){
				Serv_ItemBean sitBn = siIBns[i];
				amt_sum   += sitBn.getAmt();
				labor_sum += sitBn.getLabor();
			}
		}
	}
%>

<html>
<head>
<title>:: FMS ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//��������ϱ�
	function regGeneral(){
		var fm = document.form1;	
		if(fm.off_nm.value==""){			alert("�����ü�� ������ �ּ���!");		fm.off_nm.focus(); 		return; }
		if(fm.serv_st.value==""){			alert("���񱸺��� ������ �ּ���!");		fm.serv_st.focus(); 	return; }
		if(toInt(fm.tot_dist.value) == 0){	alert("������Ÿ��� �Է��� �ּ���!");	fm.tot_dist.focus(); 	return; }
		if(fm.serv_dt.value==""){			alert("�������ڸ� �Է��� �ּ���!");		fm.serv_dt.focus(); 	return; }
		if(fm.checker.value==""){			alert("�����ڸ� ������ �ּ���!");	fm.checker.focus(); 		return; }
		if(fm.ipgoza.value==""){			alert("�԰����ڸ� ������ �ּ���!");	fm.ipgoza.focus(); 		return; }
		if(fm.ipgodt.value==""){			alert("�԰����ڸ� �Է��� �ּ���!");		fm.ipgodt.focus(); 		return; }				
		
		//���굥��Ÿ ���� �Ұ��� �߰�
		if(fm.jung_st.value != "")		{	alert("�����̿Ϸ�Ȱ��Դϴ�. ������ �� �����ϴ�.!");		return; }
		
		if(!confirm('�Է��� ���񳻿��� ��� �Ͻðڽ��ϱ�?')){ return; }
			
		
		fm.spdchk_dt.value 		= fm.serv_dt.value;
		fm.next_serv_dt.value 	= fm.next_serv_dt.value;
				
		fm.action = "/acar/cus_reg/general_ins.jsp";
		fm.target = "i_no";
		fm.submit();
	}

	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	

	//�����ü��ȸ
	function serv_off_open(){
		var fm = document.form1;
		fm.off_id.value = '';
		fm.off_nm.value = '';
		window.open("./cus0401_d_sc_serv_off.jsp", "CLIENT", "left=100, top=120, width=530, height=400, resizable=yes, scrollbars=yes, status=yes");
	}
			
	function enter3(){
		var keyValue = event.keyCode;
		if (keyValue =='13') set_tot_amt();
	}
	
	function set_tot_amt(){
		fm = document.form1;		
	
		var dc = toInt(parseDigit(fm.dc.value))
		rep_amt = toInt(parseDigit(fm.rep_amt.value));
		fm.tot_amt.value = parseDecimal(rep_amt - dc);
	}
	
	
	//����ݾ� ���
	function set_rep_amt(){
		fm = document.form1;		
		var sup_amt = toInt(parseDigit(fm.sup_amt.value));
		var add_amt = toInt(parseDigit(fm.add_amt.value));
		fm.rep_amt.value = parseDecimal(sup_amt+add_amt);	
		
		var dc = toInt(parseDigit(fm.dc.value))
		rep_amt = toInt(parseDigit(fm.rep_amt.value));
		fm.tot_amt.value = parseDecimal(rep_amt - dc);
	}
	
	
	function enter5(){
		var keyValue = event.keyCode;
		if (keyValue =='13') set_r_j_amt();
	}	
	
	
	
	function set_r_j_amt(){  // dc���ݿ��� ���� dc
		fm = document.form1;
		r_amt = toInt(parseDigit(fm.r_amt.value));
		
		var r_dc1 = r_amt *(toInt(fm.r_dc_per.value)/100);
		 
		r_dc =  toInt(parseDigit(fm.r_dc.value)); 
	     	         
		fm.r_j_amt.value = parseDecimal(r_amt - r_dc1 - r_dc);
		
		var item_sum = toInt(parseDigit(fm.r_labor.value))+  toInt(parseDigit(fm.r_j_amt.value));
		fm.add_amt.value = "0"; //�ΰ��� �ٽ� �Է��ϵ���
		
		fm.sup_amt.value = parseDecimal(item_sum);	
		
	}
	
	
	function chk_add_amt(){  //item serv ���� ȣ��
		fm = document.form1;							
		
		//��ǰ���� ���			
		var r_amt = toInt(parseDigit(fm.r_amt.value));
		var r_dc1 = r_amt *(toInt(fm.r_dc_per.value)/100);
				
		var r_dc =  toInt(parseDigit(fm.r_dc.value)); 
	             	         
		fm.r_j_amt.value = parseDecimal(r_amt - r_dc1 - r_dc);
		
		var item_sum = toInt(parseDigit(fm.r_labor.value))+  toInt(parseDigit(fm.r_j_amt.value));
		 
		if ( item_sum > 0 ) {		              
				fm.sup_amt.value = parseDecimal(item_sum);	//���ް� sum							
		}
				
	}
	
	
	function set_dc1(){
		fm = document.form1;
		var dc = toInt(parseDigit(fm.dc.value))
		rep_amt = toInt(parseDigit(fm.rep_amt.value));
	//	fm.dc.value = parseDecimal(dc);
		fm.tot_amt.value = parseDecimal(rep_amt - dc);
	}
	
	
//-->
</script>
</head>
<body>
<form name='form1' method='post'>
<input type='hidden' name="auth_rw" 	value="<%= auth_rw %>">
<input type='hidden' name='car_mng_id' 	value='<%= car_mng_id %>'>
<input type='hidden' name='serv_id' 	value='<%= serv_id %>'>
<input type='hidden' name='off_id' 		value='<%= siBn.getOff_id() %>'>
<input type='hidden' name='cmd' 		value='<%= cmd %>'>
<input type='hidden' name='accid_id' 	value='<%= accid_id %>'>
<input type='hidden' name='accid_st' 	value='<%= accid_st %>'>
<input type='hidden' name='rent_mng_id' value='<%= rent_mng_id %>'>
<input type='hidden' name='rent_l_cd' 	value='<%= rent_l_cd %>'>
<input type="hidden" name="spdchk_dt" 	value="<%= siBn.getSpdchk_dt() %>">
<input type="hidden" name="next_serv_dt" value="<%= siBn.getNext_serv_dt() %>">
<input type="hidden" name="item_sum" 	value="">

<input type='hidden' name='jung_st' 	value='<%= siBn.getJung_st() %>'>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������ > <span class=style5>
						�ڵ���������</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>  
	<tr>
		<td class=line2 colspan=2></td>
	</tr> 
    <tr> 
        <td colspan="2" class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr bgcolor="#FFFFFF"> 
                    <td class='title' width="100">������ȣ</td>
                    <td class='left' width="100" align="left">&nbsp;&nbsp;<%= ci_bean.getCar_no() %></td>
                    <td class='title' width="100">����</td>
                    <td class='left' width="300" align="left">&nbsp;&nbsp;<%= ci_bean.getCar_jnm() %> <%= ci_bean.getCar_nm() %></td>
                    <td class='title' width="100">���ʵ����</td>
                    <td class='left' width="100" align="center"><%= AddUtil.ChangeDate2(ci_bean.getInit_reg_dt()) %></td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
		<td class=h></td>
	</tr> 	
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ�������</span></td>
    </tr>
    <tr>
		<td class=line2 colspan=2></td>
	</tr> 
    <tr> 
        <td class=line colspan="2">
    	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width="100" height="20" class='title'>�����ü</td>
                    <td colspan='3' class='left'>&nbsp;
                      <input name="off_nm"  class="whitetext" size="60" value="<%= siBn.getOff_nm() %>"></td>
              </tr>
              <tr> 
                <td width="100" height="20" class='title'>����з�</td>
                <td width="200" class='left'>&nbsp;
                  <select name="serv_st">
                    <%if(accid_id.equals("")){%>
                    <option value="1" <% if(siBn.getServ_st().equals("1")) out.print("selected"); %>>��ȸ����</option>
                    <option value="2" <% if(siBn.getServ_st().equals("2")||siBn.getServ_st().equals("")) out.print("selected"); %>>�Ϲ�����</option>
                    <option value="3" <% if(siBn.getServ_st().equals("3")) out.print("selected"); %>>��������</option>
    		  <option value="7" <% if(siBn.getServ_st().equals("7")) out.print("selected"); %>>�縮������</option>
                    <%}else{%>
                    <option value="4" <% if(siBn.getServ_st().equals("4")||accid_st.equals("8")) out.print("selected"); %>>��������</option>
                    <option value="5" <% if(siBn.getServ_st().equals("5")||accid_st.equals("8")) out.print("selected"); %>>�������</option>
    		 <option value="7" <% if(siBn.getServ_st().equals("7")||accid_st.equals("8")) out.print("selected"); %>>�縮������</option>
    		 <option value="12" <% if(siBn.getServ_st().equals("12")||accid_st.equals("8")) out.print("selected"); %>>��������</option>		
                    <%}%>
                  </select></td>
                <td width="100" class='title'><span class="title">������Ÿ�</span></td>
                <td width="400" class='left'>&nbsp;
    			  <input name="tot_dist"  class="num" size="11" value="<%= AddUtil.parseDecimal(siBn.getTot_dist()) %>" onBlur='javascript:this.value=parseDecimal(this.value)'>km</td>
              </tr>
              <tr> 
                <td class='title' width="100">������</td>
                <td class='left' width="200">&nbsp;
                  <select name="checker">
    			    <option value='' >=����=</option>			  
                    <%if(user_size > 0){
    							for(int i = 0 ; i < user_size ; i++){
    								Hashtable user = (Hashtable)users.elementAt(i); 
    				%>
                    <option value='<%=user.get("USER_ID")%>' <% if(siBn.getChecker().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                    <%	}
    						}		%>
                  </select></td>
                <td class='title' width="100">��������</td>
                <td width="400" class='left'>&nbsp;
                  <input name="serv_dt" type="text" class="text" value="<%= AddUtil.ChangeDate2(siBn.getServ_dt()) %>" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
              </tr>
              <tr> 
                <td width="100" class='title'>�԰�����</td>
                <td width="200" class='left'>&nbsp; 
    			  <select name='ipgoza'>        
    			    <option value='' >=����=</option>
    	                <%if(user_size > 0){
    						for(int i = 0 ; i < user_size ; i++){
    							Hashtable user = (Hashtable)users.elementAt(i); 
    					%>
    	          				  <option value='<%=user.get("USER_ID")%>' <% if(siBn.getIpgoza().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
    	                <%	}
    					}		%>
    			  </select></td>
                <td width="100" class='title'>�԰�����</td>
                <td width="400" class='left'>&nbsp;
    			  <input name="ipgodt" type="text" class="text" value="<%if(!siBn.getIpgodt().equals("")) out.print(AddUtil.ChangeDate2(siBn.getIpgodt().substring(0,8))); %>" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'> 
                  <select name="ipgodt_h">
                    <%for(int i=0; i<25; i++){%>
                    <option value="<%=AddUtil.addZero2(i)%>" <% if((!siBn.getIpgodt().equals("")) && siBn.getIpgodt().substring(8,10).equals(AddUtil.addZero2(i))) out.print("selected"); %>><%=AddUtil.addZero2(i)%>��</option>
                    <%}%>
                  </select> 
    			  <select name="ipgodt_m">
                    <%for(int i=0; i<60; i+=5){%>
                    <option value="<%=AddUtil.addZero2(i)%>" <% if((!siBn.getIpgodt().equals("")) && siBn.getIpgodt().substring(10,12).equals(AddUtil.addZero2(i))) out.print("selected"); %>><%=AddUtil.addZero2(i)%>��</option>
                    <%}%>
                  </select>
    			</td>
              </tr>
              <tr>
                <td width="100" height="20" class='title'>�������</td>
                <td width="200" class='left'>&nbsp; 
    			  <select name='chulgoza'>
    			    <option value='' >=����=</option>
                    <%if(user_size > 0){
    						for(int i = 0 ; i < user_size ; i++){
    							Hashtable user = (Hashtable)users.elementAt(i); 
    				%>
                    <option value='<%=user.get("USER_ID")%>' <% if(siBn.getChulgoza().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                    <%	}
    					}%>
                  </select></td>
                <td width="100" class='title'>�������</td>
                <td width="400" class='left'>&nbsp;
                  <input name="chulgodt" type="text" class="text" value="<%if(!siBn.getChulgodt().equals("")) out.print(AddUtil.ChangeDate2(siBn.getChulgodt().substring(0,8))); %>" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'>
                  <select name="chulgodt_h">
                    <%for(int i=0; i<25; i++){%>
                    <option value="<%=AddUtil.addZero2(i)%>" <% if((!siBn.getChulgodt().equals("")) && siBn.getChulgodt().substring(8,10).equals(AddUtil.addZero2(i))) out.print("selected"); %>><%=AddUtil.addZero2(i)%>��</option>
                    <%}%>
                  </select>
                  <select name="chulgodt_m">
                    <%for(int i=0; i<60; i+=5){%>
                    <option value="<%=AddUtil.addZero2(i)%>" <% if((!siBn.getChulgodt().equals("")) && siBn.getChulgodt().substring(10,12).equals(AddUtil.addZero2(i))) out.print("selected"); %>><%=AddUtil.addZero2(i)%>��</option>
                    <%}%>
                  </select>
    			</td>
              </tr>
            </table>
	  </td>
    </tr>
    <tr>
		<td class=h></td>
	</tr> 
    <tr> 
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����/����</span>&nbsp;
		( 
		<a href="javascript:MM_openBrWindow('item_select.jsp?car_mng_id=<%= car_mng_id %>&serv_id=<%= serv_id %>','popwin_item_select','scrollbars=yes,status=no,resizable=no,width=850,height=600,top=80,left=150')"><img src=../images/center/button_jj.gif border=0 align=absmiddle></a>
		| 
		<a href="javascript:MM_openBrWindow('excel.jsp?car_mng_id=<%= car_mng_id %>&serv_id=<%= serv_id %>','popwin_item_excel','scrollbars=yes,status=no,resizable=no,width=850,height=600,top=80,left=150')"><img src=../images/center/button_excel.gif border=0 align=absmiddle></a>		
		)</td>
      <td align="right">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2">
	    <table width="100%" border="0" cellspacing="0" cellpadding="0">
	        <tr>
	            <td class=line2></td>
	        </tr>
          <tr> 
            <td class="line">
			  <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                  <td class='title' width="30">����</td>
                  <td class='title' width="70">����</td>
                  <td class='title' width="280">�۾��׸� �� ��ȯ��ǰ</td>
                  <td class='title' width="100">�۾�</td>
                  <td class='title' width="100">��ǰ�ڵ�</td>				  
                  <td class='title' width="100">��ǰ����</td>
                  <td class='title' width="100">����</td>
                </tr>
              </table>
			</td>
			<td width=17>&nbsp;</td>
          </tr>
        </table>
	  </td>
    </tr>
    <tr> 
      <td colspan="2"><iframe src="item_serv_accid_in_s.jsp?car_mng_id=<%= car_mng_id %>&serv_id=<%= serv_id %>" name="item_serv_in" width="100%" height="190" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
    </tr>
    <tr> 
      <td colspan="2">
	    <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="line">
			  <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                  <td class='title' width="580" style='text-align:right'>�� �� : &nbsp;&nbsp; 
                    <input type="text" name="amt_sum2" size="10" value="<%=amt_sum+labor_sum%>" class=whitenum>
                    ��&nbsp;</td>
                  <td class='title' width="100"><input type="text" name="amt_sum" size="10" value="<%=amt_sum%>" class=whitenum>
                    ��&nbsp;</td>
                  <td class='title' width="100"><input type="text" name="labor_sum" size="10" value="<%=labor_sum%>" class=whitenum>
                    ��&nbsp;</td>
                </tr>
              </table>
			</td>
			<td width=17>&nbsp;</td>
          </tr>
        </table>
	  </td>
    </tr>	
    <tr> 
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2" class=line2></td>
    </tr>
    <tr> 
      <td colspan="2" class="line">
	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                                                      	        <tr> 
                                                                    <td class='title' >����</td>
                                                                    <td>&nbsp;
																	  <input type="text" name="r_labor" size="8" class=whitenum readonly="true" >
                                                                      ��&nbsp;</td>
                                                                    <td class='title' >��ǰ</td>
                                                                    <td>&nbsp; 
																	  <input type="text" name="r_amt" size="8" class=whitenum readonly="true"  >
                                                                      ��&nbsp;</td>
                                                                    <td class='title' >��ǰDC��</td>
                                                                    <td>&nbsp; 								  <input type="text" name="r_dc_per" size="3" class=num  value="<%= AddUtil.parseDecimal(siBn.getR_dc_per()) %>" onBlur="javascript:set_r_j_amt()" onKeyDown="javascript:enter5()">	
														  
                                                                     %&nbsp;</td>
                                                                </tr>			
                                                      	        <tr> 
                                                                    <td class='title' >��ǰDC</td>
                                                                    <td>&nbsp; 
																	<input type="text" name="r_dc" size="8" class=num  value="<%= AddUtil.parseDecimal(siBn.getR_dc()) %>" onBlur="javascript:set_r_j_amt()" onKeyDown="javascript:enter5()">
                                                                      ��&nbsp;</td>
                                                                    <td class='title'>��ǰ(����)</td>
                                								    <td colspan='3'>&nbsp; <input type="text" name="r_j_amt" size="9" class=num value="<%= AddUtil.parseDecimal(siBn.getR_j_amt()) %>" >
                                								    ��</td>
                                                                </tr>			
        </table>
	  </td>
    </tr>	
    <tr> 
      <td colspan="2">&nbsp;</td>
    </tr>	
    <tr> 
      <td colspan="2" class="line">
	    <table border="0" cellspacing="1" cellpadding='0' width=100%>																
    
          <tr>
            <td width="100" class='title'>���ް�</td>
            <td width="100" class='left'>&nbsp;
                <input type="text" name="sup_amt" size="8" class=whitenum value="<%= AddUtil.parseDecimal(siBn.getSup_amt()) %>">
                ��</td>
            <td width="100" class='title'>�ΰ���</td>
            <td width="100" class='left'>&nbsp;
                <input type="text" name="add_amt" size="8" class=num value="<%= AddUtil.parseDecimal(siBn.getAdd_amt()) %>" onBlur="javascript:set_rep_amt()" onKeyDown="javascript:enter3()">
                ��</td>
            <td width="100" class='title'>����ݾ�</td>
            <td class='left'>&nbsp;
                <input type="text" name="rep_amt" size="9" class=whitenum value="<%= AddUtil.parseDecimal(siBn.getRep_amt()) %>">
                ��</td>
          </tr>
          <tr> 
            <td width="100" class='title'>DC</td>
            <td width="100" class='left'>&nbsp; 
			  <input type="text" name="dc" size="8" class=num value="<%= AddUtil.parseDecimal(siBn.getDc()) %>" onBlur="javascript:set_dc1();" >
              ��</td>
            <td width="100" class='title'>���ޱݾ�</td>
            <td colspan=3 class='left'>&nbsp; 
			  <input type="text" name="tot_amt" size="9" class=whitenum value="<%= AddUtil.parseDecimal(siBn.getTot_amt()) %>">
              ��              </td>
          </tr>
        </table>
	  </td>
    </tr>	
    <tr> 
      <td colspan="2"><font color="#999999">
        <%if(!siBn.getUpdate_id().equals("")){%>
        �� ���������� : <%=c_db.getNameById(siBn.getUpdate_id(), "USER")%>&nbsp;&nbsp; 
		�� ���������� : <%=AddUtil.ChangeDate2(siBn.getUpdate_dt())%>
		<%}else{%>	  
        <%	if(!siBn.getReg_id().equals("")){%>
        �� ����� : <%=c_db.getNameById(siBn.getReg_id(), "USER")%>&nbsp;&nbsp; 
		�� ����� : <%=AddUtil.ChangeDate2(siBn.getReg_dt())%>
		<%	}%>
		<%}%>		
        </font></td>
    </tr>							
    <tr> 
      <td>&nbsp;</td>
      <td><div align="right"><a href="javascript:regGeneral()"><img src=/acar/images/center/button_reg.gif align="absmiddle" border="0"></a>&nbsp;&nbsp;<a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif align="absmiddle" border="0"></a></div></td>
    </tr>							
  </table>
</form>
<script language="JavaScript">
<!--

//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
