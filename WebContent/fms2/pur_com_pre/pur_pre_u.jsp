<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*, acar.car_office.*, acar.user_mng.*, acar.cont.*, card.*,acar.common.*"%>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String opt1 		= request.getParameter("opt1")		==null?"":request.getParameter("opt1");
	String opt2 		= request.getParameter("opt2")		==null?"":request.getParameter("opt2");
	String opt3 		= request.getParameter("opt3")		==null?"":request.getParameter("opt3");
	String opt4 		= request.getParameter("opt4")		==null?"":request.getParameter("opt4");
	String opt5 		= request.getParameter("opt5")		==null?"":request.getParameter("opt5");
	String opt6 		= request.getParameter("opt6")		==null?"":request.getParameter("opt6");
	String opt7 		= request.getParameter("opt7")		==null?"":request.getParameter("opt7");
	String e_opt1 		= request.getParameter("e_opt1")	==null?"":request.getParameter("e_opt1");
	String e_opt2 		= request.getParameter("e_opt2")	==null?"":request.getParameter("e_opt2");
	String e_opt3 		= request.getParameter("e_opt3")	==null?"":request.getParameter("e_opt3");
	String e_opt4 		= request.getParameter("e_opt4")	==null?"":request.getParameter("e_opt4");
	String e_opt5 		= request.getParameter("e_opt5")	==null?"":request.getParameter("e_opt5");
	String e_opt6 		= request.getParameter("e_opt6")	==null?"":request.getParameter("e_opt6");
	String e_opt7 		= request.getParameter("e_opt7")	==null?"":request.getParameter("e_opt7");
	String ready_car	= request.getParameter("ready_car")	==null?"":request.getParameter("ready_car");
	String eco_yn 	= request.getParameter("eco_yn")	==null?"":request.getParameter("eco_yn");
	
	String seq 	= request.getParameter("seq")==null?"":request.getParameter("seq");
	String r_seq 	= request.getParameter("r_seq")==null?"":request.getParameter("r_seq");
	
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String cng_item 	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
		
		
	CarOffPreBean bean = cop_db.getCarOffPreSeq(seq);
	
	if(!r_seq.equals("")){
		bean = cop_db.getCarOffPreSeq(seq, r_seq);
	}
	
	//�����ڸ���Ʈ
	Vector vt = cop_db.getCarOffPreSeqResList(seq);
	int vt_size = vt.size();
		
	String vlaus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
			"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort="+sort+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+
			"&st_dt="+st_dt+"&end_dt="+end_dt+"&from_page="+from_page+
			"&opt1="+opt1+"&opt2="+opt2+"&opt3="+opt3+"&opt4="+opt4+"&opt5="+opt5+"&opt6="+opt6+"&opt7="+opt7+
			"&e_opt1="+e_opt1+"&e_opt2="+e_opt2+"&e_opt3="+e_opt3+"&e_opt4="+e_opt4+"&e_opt5="+e_opt5+"&e_opt6="+e_opt6+"&e_opt7="+e_opt7+
			"&ready_car="+ready_car+"&eco_yn="+eco_yn+
		   	"&seq="+seq+"";
	
		
	user_bean 	= umd.getUsersBean(user_id);
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAll("0003");
	int bank_size = banks.length;
		
	//ī������ ����Ʈ ��ȸ
	Vector card_kinds = CardDb.getCardKinds("", "");
	int ck_size = card_kinds.size();
	
	
	String res_yn = "N";
	
	
	if(cng_item.equals("res_i")){
		bean.setBus_nm("");
		bean.setFirm_nm("");
		bean.setAddr("");
		bean.setR_seq(0);
		bean.setCust_tel("");
		bean.setMemo("");
	}

	
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//����
	function update(){
		var fm = document.form1;
		
		<%if(cng_item.equals("res_i")){ //������ ���߿���ȵ�%>
		<%	for (int i = 0 ; i < vt_size ; i++) {
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if (String.valueOf(ht.get("CLS_DT")).equals("")) {%>
				if('<%=ht.get("REG_ID")%>' == '<%=user_id%>' || '<%=ht.get("BUS_NM")%>' == fm.bus_nm.value) { alert('�����ڴ� �Է��� �� �����ϴ�.'); return;}
		<%		}
			}
		%>
		<%}%>	
		
		<%if (cng_item.equals("res_u") || cng_item.equals("res_i")) {//������,�����ڿ���ó,������ó �ʼ�%>
			if(fm.bus_nm.value == '')		{ alert('�����ڸ� �Է��Ͻʽÿ�.'); 		return;}
			if(fm.bus_tel.value == '')		{ alert('������ ����ó�� �Է��Ͻʽÿ�.'); 	return;}
			
			if(fm.firm_nm.value == '')		{ alert('������ �Է��Ͻʽÿ�.'); 		return;}
			if(fm.cust_tel.value == '')		{ alert('�� ����ó�� �Է��Ͻʽÿ�.'); 	return;}
			
			if(!isTel(fm.bus_tel.value)  || fm.bus_tel.value.length < 7   || fm.bus_tel.value.length > 14)	{ alert('������ ����ó�� Ȯ���Ͻʽÿ�.'); 	return;}
			if(!isTel(fm.cust_tel.value) || fm.cust_tel.value.length < 7  || fm.cust_tel.value.length > 14)	{ alert('�� ����ó�� Ȯ���Ͻʽÿ�.'); 	return;}
		<%}%>
		
		if(confirm('���� �Ͻðڽ��ϱ�?')){	
			fm.action='pur_pre_u_a.jsp';
			fm.target='i_no';		
			fm.submit();
		}	
	}	
	
	//��� ����	
	function search_cont(){window.open("search_cont.jsp?car_off_nm=<%=bean.getCar_off_nm()%>&com_con_no=<%//=bean.getCom_con_no()%>&car_nm=<%//=bean.getCar_nm()%>&bus_nm=<%=bean.getBus_nm()%>&firm_nm=<%=bean.getFirm_nm()%>","S_CONT","left=300,top=300,height=500,width=1000,scrollbars=yes,status=yes");}
	
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='sort'	value='<%=sort%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'> 
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="seq" 	value="<%=seq%>">
  <input type='hidden' name="r_seq" 	value="<%=r_seq%>">
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="cng_item" 		value="<%=cng_item%>">
  <input type='hidden' name='opt1' 		value='<%=opt1%>'>
  <input type='hidden' name='opt2' 		value='<%=opt2%>'>
  <input type='hidden' name='opt3' 		value='<%=opt3%>'>
  <input type='hidden' name='opt4' 		value='<%=opt4%>'>
  <input type='hidden' name='opt5' 		value='<%=opt5%>'>
  <input type='hidden' name='opt6' 		value='<%=opt6%>'>
  <input type='hidden' name='opt7' 		value='<%=opt7%>'>
  <input type='hidden' name='e_opt1' 	value='<%=e_opt1%>'>
  <input type='hidden' name='e_opt2' 	value='<%=e_opt2%>'>
  <input type='hidden' name='e_opt3' 	value='<%=e_opt3%>'>
  <input type='hidden' name='e_opt4' 	value='<%=e_opt4%>'>
  <input type='hidden' name='e_opt5' 	value='<%=e_opt5%>'>
  <input type='hidden' name='e_opt6' 	value='<%=e_opt6%>'>
  <input type='hidden' name='e_opt7' 	value='<%=e_opt7%>'>
  <input type='hidden' name='ready_car' value='<%=ready_car%>'>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������� > <span class=style5>������� ����</span></span></td>
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
                    <td width=13% class=title>�������</td>
                    <td width=17%>&nbsp;
                    	<%=bean.getCar_off_nm()%>
                    </td>
                    <td width=10% class=title>�����ȣ</td>
                    <td width=20%>&nbsp;
                    	<%=bean.getCom_con_no()%>
                    </td>
                    <%-- <td width=10% class=title>����Ͻ�</td>
                    <td width=30%>&nbsp;
                    	<%=bean.getReg_dt()%>
                    </td> --%>
                    <td width=10% class=title>��û�Ͻ�</td>
                    <td width=30%>&nbsp;
                    	<%=bean.getReq_dt()%>
                    </td>
                </tr>
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>
    <%if(cng_item.equals("com_con_no")){%>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����ȣ ����</span></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>                     
                    <td width=14% class=title>�����ȣ</td>
                    <td>&nbsp;
                    	<%=bean.getCom_con_no()%><input type='hidden' name="o_com_con_no" value="<%=bean.getCom_con_no()%>"> -> <input type='text' size='15' name='n_com_con_no' maxlength='20' class='default' value='<%=bean.getCom_con_no()%>'>
                    </td>
 				</tr>    		    
            </table>
        </td>
    </tr>   
    <%}%>
    
    <%if(cng_item.equals("req")){%>
    <tr>
      	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��û�Ͻ� ����</span></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>                     
                    <td width=14% class=title>��û�Ͻ�</td>
                    <td>&nbsp;
                    	<%=bean.getReq_dt()%><input type='hidden' name="o_req_dt" value="<%=bean.getReq_dt()%>"> -> <input type='text' size='40' name='n_req_dt' maxlength='40' class='default' value='<%=bean.getReq_dt()%>'>
                    </td>
 				</tr>
            </table>
        </td>
    </tr>   
    <%}%>
    
    <%if(cng_item.equals("car")){%>
    <tr>
      	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������� ����</span></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                 <tr> 
                    <td width=13% class=title>��ü��������</td>
                    <td colspan="3">&nbsp;
                    	<input type="checkbox" name="bus_self_yn" value="Y" <%if (bean.getBus_self_yn().equals("Y")){%>checked<%}%>> ��ü����
                    </td>
                </tr>
                <tr> 
                    <td width=13% class=title>Q�ڵ�</td>
                    <td colspan="3">&nbsp;
                    	<input type="checkbox" name="q_reg_dt" value="Y" <%if (!bean.getQ_reg_dt().equals("")){%>checked<%}%>> 4�ð� ������ ��ü���� ���� ���� ����
                    	<input type='hidden' name='o_q_reg_dt' value='<%=bean.getQ_reg_dt()%>'>
                    </td>
                </tr>
                <tr> 
                    <td width=13% class=title>������Ʈ���⿩��</td>
                    <td colspan="3">&nbsp;
                    	<input type="checkbox" name="agent_view_yn" value="Y" <%if (bean.getAgent_view_yn().equals("Y")){%>checked<%}%>> ������Ʈ�� ���� ���̱�
                    </td>
                </tr>            
                <tr> 
                    <td width=13% class=title>����</td>
                    <td colspan="3">&nbsp;
                    	<input type='text' size='100' name='car_nm' class='default' value='<%=bean.getCar_nm()%>'>
                    </td>
                </tr>
                <tr> 
                    <td width=13% class=title>����ǰ��</td>
                    <td colspan="3" >&nbsp;
                    	<textarea rows='3' cols='100' name='opt'><%=bean.getOpt()%></textarea>
                    </td>
                </tr>
                <tr> 
                    <td width=13% class=title>�������</td>
                    <td colspan="3" >&nbsp;
                    	<input type='text' size='100' name='colo' class='default' value='<%=bean.getColo()%>'>
                    </td>
                </tr> 
                <tr> 
                    <td width=13% class=title>�������</td>
                    <td colspan="3" >&nbsp;
                    	<input type='text' size='100' name='in_col' class='default' value='<%=bean.getIn_col()%>'>
                    </td>
                </tr>   
                <tr> 
                    <td width=13% class=title>���Ͻ�����</td>
                    <td colspan="3" >&nbsp;
                    	<input type='text' size='100' name='garnish_col' class='default' value='<%=bean.getGarnish_col()%>'>
                    </td>
                </tr>                                
                <tr> 
                    <td width=13% class=title>����</td>
                    <td colspan="3">&nbsp;
                    	<select name="eco_yn">
                    		<option value="" <%if (bean.getEco_yn().equals("")){%>selected<%}%>>���Է�</option>
                    		<option value="0"<%if (bean.getEco_yn().equals("0")){%>selected<%}%>>���ָ�����</option>
                    		<option value="1"<%if (bean.getEco_yn().equals("1")){%>selected<%}%>>��������</option>
                    		<option value="2"<%if (bean.getEco_yn().equals("2")){%>selected<%}%>>LPG����</option>
                    		<option value="3"<%if (bean.getEco_yn().equals("3")){%>selected<%}%>>���̺긮��</option>
                    		<option value="4"<%if (bean.getEco_yn().equals("4")){%>selected<%}%>>�÷����� ���̺긮��</option>
                    		<option value="5"<%if (bean.getEco_yn().equals("5")){%>selected<%}%>>������</option>
                    		<option value="6"<%if (bean.getEco_yn().equals("6")){%>selected<%}%>>������</option>
                    	</select>
                    </td>
                </tr>                                
                <tr>
                  	<td class=title>�Һ��ڰ�</td>
                  	<td width="37%">&nbsp;
                  		<input type='text' name='car_amt' size='10' value='<%=AddUtil.parseDecimal(bean.getCar_amt())%>'  maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>��
                  	</td>
                  	<td width=10% class=title>�������</td>
                  	<td width="40%">&nbsp;
                  		<input type='text' size='11' name='dlv_est_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(bean.getDlv_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                  	</td>                  	
                </tr>	
                <tr>
                    <td class=title>����</td>
                  	<td colspan='3'>&nbsp;
                  		<input type='text' name='con_amt' size='10' value='<%=AddUtil.parseDecimal(bean.getCon_amt())%>'  maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>��
                  		&nbsp;
                  		���޼��� :                  		
                     <select name="trf_st0" class='default'>
                        <option value="">==����==</option>
        				<option value="3" <%if(bean.getTrf_st0().equals("3")) out.println("selected");%>>ī��</option>
        				<option value="1" <%if(bean.getTrf_st0().equals("1")) out.println("selected");%>>����</option>        				
        			  </select>
        			  <br> 
        			  &nbsp;
                      ī��/������ : 
					  <select name='con_bank'>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];%>
                        <option value='<%= bank.getNm()%>' <%if(bean.getCon_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        					}%>
                        <%	if(ck_size > 0){
        						for (int i = 0 ; i < ck_size ; i++){
        							Hashtable ht = (Hashtable)card_kinds.elementAt(i);%>
                  		<option value='<%= ht.get("CARD_KIND") %>' <%if(bean.getCon_bank().equals(String.valueOf(ht.get("CARD_KIND")))) out.println("selected");%>><%= ht.get("CARD_KIND") %></option>
                  		<%		}
        					}%>
                    </select>
				  	&nbsp;
					ī��/���¹�ȣ : 
        			<input type='text' name='con_acc_no' value='<%=bean.getCon_acc_no()%>' size='20' class='text'>
					&nbsp;
					����/������ : 
        			<input type='text' name='con_acc_nm' value='<%=bean.getCon_acc_nm()%>' size='20' class='text'>
        			&nbsp;
        			���޿�û�� :
        			<input type='text' name='con_est_dt' value='<%= AddUtil.ChangeDate2(bean.getCon_est_dt())%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
                  	
                  	</td>
                </tr>	
                <tr>
                  	<td class=title>����������</td>
                  	<td colspan='3'>&nbsp;
                  		<input type='text' size='11' name='con_pay_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(bean.getCon_pay_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                  	</td>
                </tr>
                <tr> 
                    <td width=13% class=title>���</td>
                    <td colspan="3" >&nbsp;
                    	<textarea rows='3' cols='100' name='etc'><%=bean.getEtc()%></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr> 
    <%}else{%>
    <input type='hidden' name='eco_yn' value='<%=bean.getEco_yn()%>'>
    <%} %>
    
	<%
	if (cng_item.equals("res_u") || cng_item.equals("res_i")) {
	
		if (bean.getBus_nm().equals("")) {
			bean.setBus_nm(user_bean.getUser_nm());
			if(!acar_de.equals("1000")){			
				bean.setBus_tel(user_bean.getUser_m_tel());
			}	
		}
	%>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ <%if(cng_item.equals("res_u")){%>����<%}else{%>���<%}%></span></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=13% class=title>������</td>
                    <td>&nbsp;
                    	<input type='text' size='30' name='bus_nm' class='default' value='<%=bean.getBus_nm()%>'>
                    </td>
                    <td width=13% class=title>������ ����ó</td>
                    <td>&nbsp;
                    	<input type='text' size='20' name='bus_tel' class='default' value='<%=bean.getBus_tel()%>'>
                    	<%if(acar_de.equals("1000")){ %>
                    	(������Ʈ �������� ����ó�� �Է��ϼ���.)
                    	<%} %>		
                    </td>
                </tr>
                <tr> 
                    <td width=13% class=title>����</td>
                    <td>&nbsp;
                    	<input type='text' size='50' name='firm_nm' class='default' value='<%=bean.getFirm_nm()%>'>
                    </td>
                    <td width=13% class=title>�� ����ó</td>
                    <td>&nbsp;
                    	<input type='text' size='20' name='cust_tel' class='default' value='<%=bean.getCust_tel()%>'>
                    </td>
                </tr>
                <tr> 
                    <td width=13% class=title>���ּ�</td>
                    <td colspan='3'>&nbsp;
                    	<input type='text' size='100' name='addr' class='default' value='<%=bean.getAddr()%>'>
                    </td>
                </tr>                   
                <tr> 
                    <td width=13% class=title>�޸�</td>
                    <td colspan='3'>&nbsp;
                    	<input type='text' size='100' name='memo' class='default' value='<%=bean.getMemo()%>'>
                    </td>
                </tr>                   
            </table>
        </td>
    </tr> 
    <%if (cng_item.equals("res_i")) {%>
    <tr>
      	<td><input type="checkbox" name="res_msg_yn" value="Y" checked> �����ڿ��� ������� �ȳ� �޽����� �߼��Ѵ�.</td>
    </tr> 
    <tr>
      	<td><input type="checkbox" name="res_msg_yn2" value="Y" checked> ������ȹ�� ������ ����ڿ��� ������� �ȳ� �޽����� �߼��Ѵ�.</td>
    </tr>        
    <%}%>
    
	<%}%>
	
    <%if (cng_item.equals("cont")) {%>
    <tr>
      	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��࿬��</span></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>                     
                    <td width=14% class=title>����ȣ</td>
                    <td>&nbsp;
                    	<input type='text' size='15' name='rent_l_cd' maxlength='20' class='default' value='<%=bean.getRent_l_cd()%>'>
                    	<a href='javascript:search_cont()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>	
                    </td>
 				</tr>    		    
            </table>
        </td>
    </tr>  
    <!--
    <tr>
      <td><input type="checkbox" name="cont_car_yn" value="Y"> ���������� ������ ����� ���������� ������ �Ѵ�.</td>
    </tr> 
    -->     
    <%}%>
          
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	      <td align='center'>	 
        	     
        		<a href="javascript:update()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
	        
        		&nbsp;&nbsp;&nbsp;&nbsp;
        		<a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
	      </td>
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

