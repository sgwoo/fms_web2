<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.car_mst.*, acar.cont.*, acar.user_mng.*, acar.car_sche.*, acar.client.*, acar.car_register.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")		==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String from_page2 = request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String doc_no	 		= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 		= request.getParameter("mode")==null?"":request.getParameter("mode");	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
		
		
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "06", "02");

	int count = 0;
	
	//���⺻����
	ContBaseBean base = ac_db.getCont(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
		
	//�����⺻����
	ContCarBean car 	= ac_db.getContCar(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}	
			
	//���ຸ������
	ContGiInsBean gins 	= ac_db.getContGiInsNew(rent_mng_id, rent_l_cd, rent_st);
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP", "Y");
	int user_size = users.size();
			
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function Save(idx){
		var fm = document.form1;
		if(!CheckField()){	return;	}
		if(idx == 'i'){
			if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}
			fm.cmd.value= "i";
	//	}else{
	//		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
	//	fm.cmd.value= "u";
		}		
		fm.target="i_no";
		fm.submit();
	}

	function CheckField(){
		var fm = document.form1;
		
		
		if(fm.gi_st[0].checked == true){//����
				if(fm.gi_jijum.value == '')			{ alert('��������-���������� �Է��Ͻʽÿ�.'); 				fm.gi_jijum.focus(); 		return false; }
				var gi_amt 	= toInt(parseDigit(fm.gi_amt.value));
				var gi_fee 	= toInt(parseDigit(fm.gi_fee.value));
				if(gi_amt == 0)						{ alert('��������-���Աݾ��� �Է��Ͻʽÿ�.'); 				fm.gi_amt.focus(); 			return false; }
				if(gi_fee == 0)						{ alert('��������-��������Ḧ �Է��Ͻʽÿ�.'); 			fm.gi_fee.focus(); 			return false; }
			}else if(fm.gi_st[1].checked == true){//����
				if(fm.gi_reason.value == '')		{ alert('��������-���������� �Է��Ͻʽÿ�.'); 				fm.gi_reason.focus(); 		return false; }
				if(fm.gi_sac_id.value == '')		{ alert('��������-���� �������� �Է��Ͻʽÿ�.'); 			fm.gi_sac_id.focus(); 		return false; }
		}
	
		return true;
	}
	
	//���÷���--------------------------------------------------------------------
	function cng_input(arg){
	
	  	    
		if(arg == '1'){ 		//����
				tr_acct1.style.display		= '';
				tr_acct2.style.display		= 'none';
			
		
					
		} else { 		//����
				tr_acct1.style.display		= 'none';
				tr_acct2.style.display		= '';
			
				
			
		}
	}	
//-->
</script>
</head>
<body>
<form action="gur_ins_null_ui.jsp" name="form1" method="POST" >
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">   
  <input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">   
  <input type="hidden" name="rent_st" value="<%=rent_st%>">   
  <input type="hidden" name="from_page2" value="<%=from_page2%>">   
  <input type="hidden" name="from_page" value="<%=from_page%>">   
  <input type="hidden" name="doc_no" value="<%=doc_no%>">   
  <input type="hidden" name="mode" value="<%=mode%>">   
  <input type="hidden" name="cmd" value="">
  <input type="hidden" name="firm_nm" value="<%=client.getFirm_nm()%>">
  <input type="hidden" name="car_nm" value="<%=cm_bean.getCar_nm()%> <%=cm_bean.getCar_name()%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������� > <span class=style5>�����������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>����ȣ</td>
                    <td width=25%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>�뵵</td>
                    <td width=15%>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("5")){%>�����뿩<%}%></td>
                    <td class=title width=10%>���������</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>
                <tr>
                    <td class=title>��ȣ</td>
                    <td >&nbsp;<%=client.getFirm_nm()%></td>
                    <td class=title>������ȣ</td>
                    <td>&nbsp;<%=cr_bean.getCar_no()%></td>
                    <td class=title>����</td>
                    <td>&nbsp;<%=cm_bean.getCar_nm()%>&nbsp;<%=cm_bean.getCar_name()%></td>
                </tr>
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
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr>
                    <td class=title width=25%>���Կ���</td>
        		    <td>&nbsp;
        		   	    <select name='gi_st' onClick="javascript:cng_input(this.value)">
                            <option value="0" <%if(gins.getGi_st().equals("0")){%> selected <%}%>>����</option>
                            <option value="1" <%if(gins.getGi_st().equals("1")){%> selected <%}%>>����</option>
                        </select>
        			    <input type='hidden' name='h_gi_no' value='<%=gins.getGi_no()%>'> 
                    </td>
                </tr>
            </table>
        </td>   
    </tr>    
    <tr></tr><tr></tr>         
    <tr id=tr_acct1 style="display:<%if(gins.getGi_st().equals("1")){%>''<%}else{%>none<%}%>">
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=25%>��������</td>
                    <td>&nbsp; 
                        <input type="text" name="gi_jijum" value="<%=gins.getGi_jijum()%>" size="25" class=text style='IME-MODE: active'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>���ǹ�ȣ</td>
                    <td>&nbsp; 
                        <input type='text' name='gi_no' size='25' class='text' value="<%=gins.getGi_no()%>">&nbsp;ȣ
                    </td>
                </tr>
                <tr> 
                    <td class=title>���谡�Աݾ�</td>
                    <td>&nbsp; 
                        <input type='text' name='gi_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(gins.getGi_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;��
                    </td>
                </tr>
                <tr> 
                    <td class=title>�����</td>
                    <td>&nbsp; 
                        <input type='text' name='gi_fee' size='9' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(gins.getGi_fee())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;��
                    </td>
                </tr>
                <tr> 
                    <td class=title>����Ⱓ</td>
                    <td>&nbsp; 
                    <input type="text" name="gi_start_dt" value="<%=AddUtil.ChangeDate2(gins.getGi_start_dt())%>" size="12" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'>
                    ~ 
                    <input type="text" name="gi_end_dt" size="12" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value)' value="<%=AddUtil.ChangeDate2(gins.getGi_end_dt())%>">
                  ( 
                    <input type="text" name="gi_day" size="5" maxlength='10' class=text value="<%=gins.getGi_day()%>">�ϰ�)
                    <!-- �������� ���԰��� �߰�(2018.03.22) -->
                   ( <input type="text" name="gi_month" size="5" maxlength='2' class=text value="<%=gins.getGi_month()%>">����)	
                    </td>
                </tr>
                <tr> 
                    <td class=title>���谡������</td>
                    <td>&nbsp; 
                        <input type='text' size='12' name='gi_dt' maxlength='10' class='text' onBlur='javscript:this.value = ChangeDate(this.value);' value="<%=AddUtil.ChangeDate2(gins.getGi_dt())%>"> 
                    </td>
    	        </tr>
            </table>
        </td>
    </tr>      
    <tr id=tr_acct2 style="display:<%if(gins.getGi_st().equals("0")){%>''<%}else{%>none<%}%>">
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>                
                <tr> 
                    <td class=title width=25%>��������</td>
                    <td>&nbsp; 
                        <select name='gi_reason'>
                            <option value="">����</option>
                            <option value="1" <%if(gins.getGi_reason().equals("1")){%> selected <%}%>>�ſ�����</option>
                            <option value="2" <%if(gins.getGi_reason().equals("2")){%> selected <%}%>>���������δ�ü</option>
                            <option value="3" <%if(gins.getGi_reason().equals("3")){%> selected <%}%>>���뺸�������δ�ü</option>
                            <option value="4" <%if(gins.getGi_reason().equals("4")){%> selected <%}%>>��Ÿ ����ȹ��</option>
                        </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>������</td>
                    <td>&nbsp;
                        <select name='gi_sac_id'>			  
                            <option value="">����</option>
                            <%if(user_size > 0){
            					for(int i = 0 ; i < user_size ; i++){
            						Hashtable user = (Hashtable)users.elementAt(i); %>
                            <option value='<%=user.get("USER_ID")%>' <%if(gins.getGi_sac_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                            <%	}
            				}		%>
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
        <td>
            <table border="0" cellspacing="0" width=100%>
                <tr>
    			    <td align="right">
    			    <%
    			    		String w_user_id = nm_db.getWorkAuthUser("������������");
				        	CarScheBean cs_bean = csd.getCarScheTodayBean(w_user_id);
        			  	if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals(""))	w_user_id = cs_bean.getWork_id();
    			    %>
    			    
    			    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    			    <%    if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����������",user_id) || w_user_id.equals(user_id)){%>
    				   	<a href="javascript:Save('i')"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
    			    <%    }%>	
    			    <%}%>	
            		&nbsp;&nbsp;<a href="javascript:self.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    			</tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>