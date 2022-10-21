<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS Client_Info</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<meta name="viewport" content="width=device-width,height=device-height,user-scalable=yes,initial-scale=1.0;"> 
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta name="robots" content="noindex, nofollow">

<style type="text/css">

/* body ���� �Ӽ� */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '�������';}
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0;}

/* ���̾ƿ� ū�ڽ� �Ӽ� */
#wrap {float:left; margin:0 auto; width:100%; background-color:#dedbcd;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%; height:100%}
#footer {float:left; width:100%; height:40px; background:#44402d; margin-top:40px;}

/* �޴������ܵ� */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* �ΰ� */
#gnb_box {float:left; text-align:middle; width:100%; height:40Px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}



.view_detail {width:100%; border-bottom:1px solid #DDDEE2; table-layout:fixed; font:12px;}
.view_detail th {padding:8px 0 5px 10px; width:25%; border-top:1px solid #DDDEE2; background:#F1F1F3; color:#3333cc; font-weight:bold; text-align:left; vertical-align:top;}
.view_detail td {padding:8px 5px 5px 10px; border-top:1px solid #DDDEE2; line-height:16px; vertical-align:top;}


/* �ձ����̺� ���� */

.roundedBox {position:relative; width:83%; padding:17px; }

    .corner {position:absolute; width:17px; height:17px;}

        .topLeft {top:0; left:0; background-position:-1px -1px;}
        .topRight {top:0; right:0; background-position:-19px -1px;}
        .bottomLeft {bottom:0; left:0; background-position:-1px -19px;}
        .bottomRight {bottom:0; right:0; background-position:-19px -19px;}
        
#type4 {background-color:#fff; border:1px solid #bcb9aa;}
    #type4 .corner {background-image:url(/smart/images/corners-type.gif);}
        #type4 .topLeft {top:-1px;left:-1px;}
        #type4 .topRight {top:-1px; right:-1px;}
        #type4 .bottomLeft {bottom:-1px; left:-1px;}
        #type4 .bottomRight {bottom:-1px; right:-1px;}





/* �������̺� */
.contents_box {width:100%; table-layout:fixed; font-size:13px;}
.contents_box th {color:#282828; height:26px; text-align:left; font-weight:bold;}
.contents_box td {line-height:16px; color:#7f7f7f; font-weight:bold;}


/* �������̺� */
#ctitle {float:left; margin:3px 0 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:15px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}
#cbtn { text-align:center; margin:15px 0 0 0;}




</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.* "%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.car_mst.*, acar.estimate_mng.* "%>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="bc_db" class="acar.bad_cust.BadCustDatabase" scope="page"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")	==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no 		= request.getParameter("car_no")	==null?"":request.getParameter("car_no");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	String est_nm 		= request.getParameter("est_nm")==null?"":request.getParameter("est_nm");
	String est_ssn		= request.getParameter("est_ssn")==null?"":request.getParameter("est_ssn");
	String est_tel 		= request.getParameter("est_tel")==null?"":request.getParameter("est_tel");
	String est_fax 		= request.getParameter("est_fax")==null?"":request.getParameter("est_fax");
	String est_email 	= request.getParameter("est_email")==null?"":request.getParameter("est_email");
	String doc_type 	= request.getParameter("doc_type")==null?"1":request.getParameter("doc_type");
	String damdang_id	= request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	
	String st 			= request.getParameter("st")		==null?"":request.getParameter("st");
	String esti_nm 		= request.getParameter("esti_nm")	==null?"":request.getParameter("esti_nm");
	String a_a 			= request.getParameter("a_a")		==null?"":request.getParameter("a_a");
	String a_b 			= request.getParameter("a_b")		==null?"":request.getParameter("a_b");
	String pp_st 		= request.getParameter("pp_st")		==null?"":request.getParameter("pp_st");
	String rg_8 		= request.getParameter("rg_8")		==null?"":request.getParameter("rg_8");
	String est_code 	= request.getParameter("est_code")	==null?"":request.getParameter("est_code");
	String today_dist 	= request.getParameter("today_dist")==null?"":request.getParameter("today_dist");
	String o_1 			= request.getParameter("o_1")		==null?"":request.getParameter("o_1");
	String rent_dt 		= request.getParameter("rent_dt")	==null?"":request.getParameter("rent_dt");
	String amt 			= request.getParameter("amt")		==null?"":request.getParameter("amt");
	String page_kind 	= request.getParameter("page_kind")	==null?"":request.getParameter("page_kind");
	
	//�ҷ��� Ȯ��
	Vector vt_chk1 = bc_db.getBadCustRentCheck(est_nm, est_nm, "", "", est_tel, "", "", est_email, est_fax, "", "");
	int vt_chk1_size = vt_chk1.size(); 	
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String car_comp_id = "0001";
	
	//�⺻����,��������
	if(!st.equals("1")){
		est_id = e_db.getSearchEstIdSh(car_mng_id, a_a, a_b, o_1, today_dist, rent_dt, amt, est_code);
	//���������������
	}else{
		est_id = e_db.getSearchEstIdTaeSh(car_mng_id, a_a, o_1, today_dist, rent_dt, est_code);
	}
	e_bean = e_db.getEstimateShCase(est_id);
	
	
	cm_bean = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	if(st.equals("1")){
		e_bean.setA_a	(a_a);
		e_bean.setA_b	(a_b);
	}
	
	//��������
	Hashtable ht = e_db.getShBase(car_mng_id);
	
	String a_e = String.valueOf(ht.get("S_ST"));
	
	/* �ڵ� ����:�뿩��ǰ�� */
	CodeBean[] goods = c_db.getCodeAll("0009"); 
	int good_size = goods.length;
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	String jg_b_dt = e_db.getVar_b_dt(String.valueOf(ht.get("JG_CODE")), "jg", rent_dt);
	
	//��������
	ej_bean = e_db.getEstiJgVarCase(String.valueOf(ht.get("JG_CODE")), jg_b_dt);		
%>

<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�ѵ��� ��, ����==�ݾ� ��ȯ
	function compare(obj){
		var fm = document.form1;
		var a_a = '<%=e_bean.getA_a()%>';
		if(obj == fm.rg_8){
			fm.rg_8_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.rg_8.value)/100);	
		}else if(obj == fm.rg_8_amt){
			var rg_8 = toInt(parseDigit(fm.rg_8_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100;
			fm.rg_8.value = Math.round(rg_8);	
		}else if(obj == fm.pp_per){
			fm.pp_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.pp_per.value)/100);						
		}else if(obj == fm.pp_amt){
			fm.pp_per.value = Math.round(toInt(parseDigit(fm.pp_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100);
		}else if(obj == fm.ro_13){
			fm.ro_13_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.ro_13.value)/100);		
		}else if(obj == fm.ro_13_amt){
			var ro_13 = toInt(parseDigit(fm.ro_13_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100;
			fm.ro_13.value = Math.round(ro_13);		
		}else if(obj == fm.gi_per){
			fm.gi_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.gi_per.value)/100);						
		}else if(obj == fm.gi_amt){
			fm.gi_per.value = Math.round(toInt(parseDigit(fm.gi_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100);
		}	
	}	
	
	//��������
	function EstiReg(){
		var fm = document.form1;
		
		
		<%if(vt_chk1_size>0){%>
		if(fm.st.value == '2'){//�⺻����
			alert('[<%=est_nm%>]�� �ҷ������� ��ϵ� ���� �������� ���θ� Ȯ�� �� �����Ͻñ� �ٶ��ϴ�. ������������ Ȯ���ϰ� ó���ϼ���.'); 
			return;
		}
		<%}%>
		
				
		var a_a = '<%=e_bean.getA_a()%>';
		var ins_age = fm.ins_age.options[fm.ins_age.selectedIndex].value;
				
		var a_h = 1;
		var a_e = '<%=a_e%>';
		var a_a = a_a.substring(0,1);
		var au28 = 0;
		var av28 = 0;
		if(a_e == 402 || a_e == 501 || a_e == 502 || a_e == 601 || a_e == 602) au28 = 1;//7-9�ν�2000cc�ʰ�¤����
		if(a_e == 104 || a_e == 105 || a_e == 106 || a_e == 107 || a_e == 201) av28 = 1;//�����¿뿩��
		
		if(a_a != ''){
			if(a_a=='1'){//����		
				if(av28==1){
					a_h = 4;	
				}else{
					if(au28==1){
						if(fm.udt_st.value == '1') 			a_h = 1; //�����μ��϶� ����
						else if(fm.udt_st.value == '2') 	a_h = 4; //�λ��μ��ϴ� �泲
						else if(fm.udt_st.value == '3') 	a_h = 4; //�����μ��϶� �泲
						else if(fm.udt_st.value == '4') 	a_h = 1; //���μ��ϴ� ����
					}else{
						if(fm.udt_st.value == '1') 			a_h = 2; //�����μ��϶� ���
						else if(fm.udt_st.value == '2') 	a_h = 4; //�λ��μ��ϴ� �泲
						else if(fm.udt_st.value == '3') 	a_h = 4; //�����μ��϶� �泲
						else if(fm.udt_st.value == '4') 	a_h = 1; //���μ��ϴ� ����
					}
				}				
			}else{//��Ʈ
				if(fm.udt_st.value == '1') 					a_h = 2; //�����μ��϶� ���
				else if(fm.udt_st.value == '2') 			a_h = 4; //�λ��μ��ϴ� �泲
				else if(fm.udt_st.value == '3') 			a_h = 4; //�����μ��϶� �泲
			}
			fm.a_h.value = a_h;
		}
		
		//20150626 �����⺻�ĸ� �������� �� ���ð���, �������ڰ� ���̸� �Ǻ����ڵ� ���̿��� �Ѵ�.			
		/*
		if(a_a == '12'){
			if(fm.insurant.value == '2' && fm.ins_per.value != '2'){
				alert('�������� ���̸� �Ǻ����ڵ� ���̿��� �մϴ�.');
				return;					
			}
		}else{
			if(fm.insurant.value == '2'){
				alert('�������� ���� �����⺻�ĸ� �����մϴ�.');
				return;
			}			
		}	
		*/		
		// ������ ���� 100% ����		2018.1.4
		/* var car_o_1 = fm.o_1.value;
		var car_rg_8_amt = fm.rg_8_amt.value.replace(/,/gi,'');		
	    if(Number(car_rg_8_amt) > Number(car_o_1)){
	    	alert('�������� ������ 100% �̳��� ���� �����մϴ�. \n\n�߰��� �ʱⳳ�Ա� ���θ� ���� ��� ���������� �����Ͻø� �˴ϴ�.');
	    	return;
	    } */
		
		<%if(ej_bean.getJg_w().equals("1")){%>
			if(parseDigit(fm.car_ja.value) != '500000'){
      	alert('��å�� �ݾ��� Ʋ�Ƚ��ϴ�.'); return;
      }
		<%}else{%>
			if(parseDigit(fm.car_ja.value) == '300000' || parseDigit(fm.car_ja.value) == '200000' || parseDigit(fm.car_ja.value) == '100000'){
      }else{
      	alert('��å�� �ݾ��� Ʋ�Ƚ��ϴ�.'); return;
      }
		<%}%>
		
		if(!fm.st.value == '2'){//�⺻����
			if(!confirm('�����Ͻðڽ��ϱ�?')){	return; }
		}
		fm.cmd.value = "i";
		fm.action = 'sh_car_esti_i_a.jsp';
//		fm.target = "_self";
		fm.target = "i_no";
		fm.submit();
	}
	
	//�ҷ���
	function view_badcust(est_nm, lic_no, est_tel, est_o_tel, est_mail, est_fax, est_comp_tel, est_comp_cel, driver_cell)
	{
		window.open('/acar/bad_cust/stat_badcust_list.jsp?badcust_chk_from=esti_mng_i_20090901.jsp&est_nm='+est_nm+'&lic_no='+lic_no+'&est_tel='+est_tel+'&est_o_tel='+est_o_tel+'&est_mail='+est_mail+'&est_fax='+est_fax+'&est_comp_tel='+est_comp_tel+'&est_comp_cel='+est_comp_cel+'&driver_cell='+driver_cell, "BADCUST", "left=10, top=10, width=1200, height=560, resizable=yes, scrollbars=yes, status=yes");
	}			

//-->
</script>

<body>
<form name='form1' method='post' action=''>
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd'	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='from_page'	value='<%=from_page%>'>

    <input type="hidden" name="est_id" 		value="<%=est_id%>">		
	<input type="hidden" name="est_nm" 		value="<%=est_nm%>">		
    <input type="hidden" name="est_ssn" 	value="<%=est_ssn%>">		
    <input type="hidden" name="est_tel" 	value="<%=est_tel%>">			
    <input type="hidden" name="est_fax" 	value="<%=est_fax%>">		
    <input type="hidden" name="est_email" 	value="<%=est_email%>">		
    <input type="hidden" name="doc_type" 	value="<%=doc_type%>">			
    <input type="hidden" name="damdang_id" 	value="<%=damdang_id%>">			
	
	<input type="hidden" name="st"	 			value="<%=st%>">
	<input type="hidden" name="esti_nm"			value="<%=esti_nm%>">
	<input type="hidden" name="a_a"				value="<%=a_a%>">
	<input type="hidden" name="a_b"				value="<%=a_b%>">
	<input type="hidden" name="o_1"				value="<%=o_1%>">	
	<input type="hidden" name="rent_dt"			value="<%=rent_dt%>">
	<input type="hidden" name="today_dist"		value="<%=today_dist%>">	
	<input type="hidden" name="est_code"		value="<%=est_code%>">			
	<input type="hidden" name="page_kind"		value="<%=page_kind%>">
	
    <input type="hidden" name="a_e" value="<%=a_e%>">
	<input type="hidden" name="a_h" value="">	
	<input type="hidden" name="ins_good" value="0"><!--�ִ�ī����:�̰���-->			
    <input type="hidden" name="cmd" value="">	
	
	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login"><%=car_no%> �縮����������</div>
			<div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
            
        </div>
    </div>
    <div id="contents">
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">������</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width="90" valign=top>��ȣ/����</th>
							<td valign=top><%=est_nm%>
    <%if(vt_chk1_size>0){%>
    <br>�� [<%=est_nm%>]�� �ҷ������� ��ϵ� ���� �������� ���θ� Ȯ�� �� �����Ͻñ� �ٶ��ϴ�.
        	<input type="button" class="button" id="bad_cust" value='���뺸��' onclick="javascript:view_badcust('<%=est_nm%>', '', '<%=est_tel%>', '', '<%=est_email%>', '<%=est_fax%>', '', '', '');">	        
    <%}%>								
								
								</td>
						</tr>
				    	<tr>
				    		<th>�ſ뵵����</th>
				    		<td><select name="spr_yn">
                        		  <option value="">=�� ��=</option>
								  <option value="3" <% if(e_bean.getSpr_yn().equals("3")) out.print("selected"); %>>�ż�����</option>
								  <option value="0" <% if(e_bean.getSpr_yn().equals("0")) out.print("selected"); %>>�Ϲݱ��</option>
								  <option value="1" <% if(e_bean.getSpr_yn().equals("1")) out.print("selected"); %>>�췮���</option>
								  <option value="2" <% if(e_bean.getSpr_yn().equals("2")||e_bean.getSpr_yn().equals("")) out.print("selected"); %>>�ʿ췮���</option>
                      			</select></td>
				    	</tr>																									
				    	<tr>
				    		<th>������ȿ�Ⱓ</th>
				    		<td><select name="vali_type">
					    		<option value="">����</option>
                        		<option value="0" <%if(e_bean.getVali_type().equals("0")||e_bean.getVali_type().equals(""))%>selected<%%>>��¥��ǥ��(10��)</option>
                        		<option value="1" <%if(e_bean.getVali_type().equals("1"))%>selected<%%>>����ĿD/C ���� ���ɼ� ���</option>
                       			<option value="2" <%if(e_bean.getVali_type().equals("2"))%>selected<%%>>��Ȯ������</option>						
                      		</select>
        	 		  		</td>
				    	</tr>																																																								
				    	<tr>
				    		<th>�����</th>
				    		<td><select name='damdang_id' class=default>            
                        <option value="">������</option>
        		        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); 
        					%>
          			    <option value='<%=user.get("USER_ID")%>' <% if(ck_acar_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                		<%		}
        					}%>
        			  </select>
        	 		  		</td>
				    	</tr>																																																								
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">��������</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
				    	<tr>
				    		<th width="100">������</th>
				    		<td><%=cm_bean.getCar_comp_nm()%></td>
				    	</tr>
				    	<tr>
				    		<th>����</th>
				    		<td><%=cm_bean.getCar_nm()%></td>
				    	</tr>	
						<tr>
							<th>����</th>
							<td>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td><%=cm_bean.getCar_name()%></td>
									</tr>
									<tr>
										<td align="right"><%=AddUtil.parseDecimal(e_bean.getCar_amt())%>��</td>
									</tr>
								</table>
							</td>
						</tr>					
						<tr>
							<th>�ɼ�</th>
							<td>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td><%=e_bean.getOpt()%></td>
									</tr>
									<tr>
										<td align="right"><%=AddUtil.parseDecimal(e_bean.getOpt_amt())%>��</td>
									</tr>
								</table>
							</td>
						</tr>				
						<tr>
							<th>����</th>
							<td>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td><%=e_bean.getCol()%></td>
									</tr>
									<tr>
										<td align="right"><%=AddUtil.parseDecimal(e_bean.getCol_amt())%>��</td>
									</tr>
								</table>
							</td>
						</tr>						
						<tr>
							<th>������</th>
							<td align="right"><%=AddUtil.parseDecimal(e_bean.getCar_amt()+e_bean.getOpt_amt()+e_bean.getCol_amt()-e_bean.getO_1())%>��
							</td>
						</tr>																																
						<tr>
							<th>�縮�����ذ���</th>
							<td align="right"><%=AddUtil.parseDecimal(e_bean.getO_1())%>��
							</td>
						</tr>																																
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>		
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">�������</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
				    	<tr>
				    		<th>�뿩��ǰ</th>
				    		<td><%=c_db.getNameByIdCode("0009", "", e_bean.getA_a())%>
								<%if(st.equals("1")){%>
								- ���������
								<%}%>
							</td>
				    	</tr>	
						<tr>
							<th>�뿩�Ⱓ</th>
							<td><%=e_bean.getA_b()%>����</td>
						</tr>	
                <%if(AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20150216){%>
                <%
              		int b_agree_dist =0;
              		int agree_dist   =0;
              	
           		b_agree_dist = 30000;
           		
			//���� ���� +5000
			if(!ej_bean.getJg_w().equals("1") && ej_bean.getJg_b().equals("1")){
				b_agree_dist = b_agree_dist+5000;
			}				
			//LPG +5000
			if(ej_bean.getJg_b().equals("2")){
				b_agree_dist = b_agree_dist+5000;				
			}
			
			agree_dist = b_agree_dist;
					
			//������-10000			
			if(ej_bean.getJg_w().equals("1")){	
				agree_dist = agree_dist-10000;				
			}
		
              %>     						
				    	<tr>
				    		<th width="90">ǥ�ؾ�������Ÿ�</th>
				    		<td><input type="text" name="b_agree_dist" class=whitenum size="10" value='<%=AddUtil.parseDecimal(b_agree_dist)%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                        km/��
				    		</td>
				    	</tr>																	
				    	<tr>
				    		<th width="90">�����������Ÿ�</th>
				    		<td><input type="text" name="agree_dist" class=whitenum size="10" value='<%=AddUtil.parseDecimal(agree_dist)%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                        km/��
				    		</td>
				    	</tr>	
    	      <%}%>																
				    	<tr>
				    		<th width="90">�����ܰ�</th>
				    		<td><input type="text" name="ro_13" size="4" class=text  value='<%//=e_bean.getRo_13()%>' onblur="javascript:compare(this)">%
	                      		<input type="text" name="ro_13_amt" class=num size="10" value='<%//=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
    	                  		��<br>
						  		(���Կɼ� �ݾ���, ���Է½� �ִ��ܰ����� ����)
        	 		  		</td>
				    	</tr>																													
				    	<tr>
				    		<th>���Կɼ�</th>
				    		<td><input type='radio' name="opt_chk" value='0' <%if(e_bean.getOpt_chk().equals("0")||e_bean.getOpt_chk().equals("")){%> checked <%}%>>
                      			�̺ο�
                      			<input type='radio' name="opt_chk" value='1' <%if(e_bean.getOpt_chk().equals("1")){%> checked <%}%>>
        	 		 			�ο�
							</td>
				    	</tr>
				    	<tr>
				    		<th>������</th>
				    		<td><input type="text" name="rg_8" class=num size="4" value='<%=e_bean.getRg_8()%>' onBlur="javascript:compare(this)">%
								<%if(st.equals("1")){%>
								||
								<%}%>
	                      		<input type="text" name="rg_8_amt" class=num size="10" value="<%=AddUtil.parseDecimal(e_bean.getRg_8_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
    	                  		��
								<%if(st.equals("1")){%>
								<br>
								(���� ���� ���� ������ �ݾ��� �Է��� �ּ���.)
								<%}%>
        	 		  		</td>
				    	</tr>				
				    	<tr>
				    		<th>������</th>
				    		<td><input type="text" name="pp_per" class=num size="4" value="<%=e_bean.getPp_per()%>" onBlur="javascript:compare(this)">%
								<%if(st.equals("1")){%>
								||
								<%}%>
	                      		<input type="text" name="pp_amt" class=num size="10" value="<%=AddUtil.parseDecimal(e_bean.getPp_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
    	                  		��
								<%if(st.equals("1")){%>
								<br>
								(���� ���� ���� ������ �ݾ��� �Է��� �ּ���.)
								<%}%>								
        	 		  		</td>
				    	</tr>			
				    	<tr>
				    		<th>���ô뿩��</th>
				    		<td><input type="text" name="g_10" class=num size="2" value="<%=e_bean.getG_10()%>">����ġ
								<%if(st.equals("1")){%>
								||
	                      		<input type="text" name="g_10_amt" class=num size="10" value="" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
    	                  		��								
								<%}%>
								<%if(st.equals("1")){%>
								<br>
								(���� ���� ���� ���ô뿩�� �ݾ��� �Է��� �ּ���.)
								<%}%>							
        	 		  		</td>
				    	</tr>	
				    	<!--
				    	<tr>
				    		<th>��������</th>
				    		<td><select name="insurant">
                            <option value="1" <%if(e_bean.getInsurant().equals("1")||e_bean.getInsurant().equals(""))%>selected<%%>>�Ƹ���ī</option>
                            <option value="2" <%if(e_bean.getInsurant().equals("2"))%>selected<%%>>��</option>
                          </select>
        	 		  		</td>
				    	</tr>
				    	-->
				    	<tr>
				    		<th>�Ǻ�����</th>
				    		<td><select name="ins_per">
                            <option value="1" <%if(e_bean.getIns_per().equals("1")||e_bean.getIns_per().equals(""))%>selected<%%>>�Ƹ���ī(��������)</option>
                            <!--<option value="2" <%if(e_bean.getIns_per().equals("2"))%>selected<%%>>��(���������)</option>-->
                          </select>
        	 		  		</td>
				    	</tr>																																																	
				    	<tr>
				    		<th>�����ڿ���</th>
				    		<td><select name="ins_age">
                			<option value="1" <%if(e_bean.getIns_age().equals("1")||e_bean.getIns_age().equals(""))%>selected<%%>>��26���̻�</option>
   							<option value="3" <%if(e_bean.getIns_age().equals("3"))%>selected<%%>>��24���̻�</option>
                			<option value="2" <%if(e_bean.getIns_age().equals("2"))%>selected<%%>>��21���̻�</option>
               			 	</select>
        	 		  		</td>
				    	</tr>																																																																																																							
				    	<tr>
				    		<th>�빰/�ڼ�</th>
				    		<td><select name="ins_dj" >
                			<option value="1" <%if(e_bean.getIns_dj().equals("1"))%>selected<%%>>5õ����/5õ����</option>
                			<option value="2" <%if(e_bean.getIns_dj().equals("2")||e_bean.getIns_dj().equals(""))%>selected<%%>>1���/1���</option>
                			<option value="4" <%if(e_bean.getIns_dj().equals("4"))%>selected<%%>>2���/1���</option>
               	 			</select>
        	 		  		</td>
				    	</tr>																																																				
				    	<tr>
				    		<th>������å��</th>
				    		<td><input type="text" name="car_ja" class=num size="10" value="<%=AddUtil.parseDecimal(e_bean.getCar_ja())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��
        	 		  		</td>
				    	</tr>																																																							
				    	<tr <%if (e_bean.getA_a().equals("12") || e_bean.getA_a().equals("11")) {%>style="display: none;"<%}%>>
				    		<th>��������</th>
				    		<td><input type="text" name="gi_per" class=num size="4" value='<%if (e_bean.getA_a().equals("12") || e_bean.getA_a().equals("11")) {%>0<%} else {%><%=e_bean.getGi_per()%><%}%>' onBlur="javascript:compare(this)">%
							<input type="text" name="gi_amt" class=num size="10" value='<%if (e_bean.getA_a().equals("12") || e_bean.getA_a().equals("11")) {%>0<%} else {%><%=AddUtil.parseDecimal(e_bean.getGi_amt())%><%}%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>��
        	 		  		</td>
				    	</tr>
				    	<tr <%if (e_bean.getA_a().equals("12") || e_bean.getA_a().equals("11")) {%>style="display: none;"<%}%>>
				    		<th>���������<br>������</th>
				    		<td>
				    			<select name="gi_grade" id="gi_grade">
		               				<option value="" selected>������ǥ��</option>
		                			<option value="1">1���</option>
		                			<option value="2">2���</option>
		                			<option value="3">3���</option>
		                			<option value="4">4���</option>
		                			<option value="5">5���</option>
		                			<option value="6">6���</option>
		                			<option value="7">7���</option>
		                		</select>
				    		</td>
				    	</tr>
				    	<tr>
				    		<th>�������</th>
				    		<td><select name="udt_st">
                        <option value="1" <%if(e_bean.getUdt_st().equals("1"))%>selected<%%>>���ﺻ��</option>
                        <option value="2" <%if(e_bean.getUdt_st().equals("2"))%>selected<%%>>�λ�����</option>
                        <option value="3" <%if(e_bean.getUdt_st().equals("3"))%>selected<%%>>��������</option>
                        <option value="5" <%if(e_bean.getUdt_st().equals("5"))%>selected<%%>>�뱸����</option>
                        <option value="6" <%if(e_bean.getUdt_st().equals("6"))%>selected<%%>>��������</option>
                        <option value="4" <%if(e_bean.getUdt_st().equals("4"))%>selected<%%>>��</option>
                      </select>
        	 		  		</td>
				    	</tr>																																																	
				    	<tr>
				    		<th>��������</th>
				    		<td>������ <input type="text" name="o_11" value="<%=e_bean.getO_11()%>" size="4" class=text>
                      		%
        	 		  		</td>
				    	</tr>																																																	
				    	<tr>
				    		<th>�뿩��D/C</th>
				    		<td>�뿩���� 
                     		<input type="text" name="fee_dc_per" value="<%=e_bean.getFee_dc_per()%>" size="4" class=text>
                      		%
        	 		  		</td>
				    	</tr>	
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>								
			
	</div>
	<div id="cbtn"><a href="javascript:EstiReg();"><img src=/smart/images/btn_est.gif align=absmiddle border=0></a></div>	
	<div id="footer"></div>  
</div>
</form>
<script>
<!--	
	var fm = document.form1;
	
	if(toInt(fm.gi_per.value) == 0 && toInt(parseDigit(fm.gi_amt.value)) > 0){
		compare(fm.gi_amt);
	}
	
	if(fm.st.value == '2'){//�⺻����
		EstiReg();
	}
	
//-->
</script>	
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
