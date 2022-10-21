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
#ctable {float:left; margin-bottom:10px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}
#cbtn { text-align:center; margin:0 0 0 0;}



</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.* "%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.car_mst.*, acar.estimate_mng.* "%>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
	<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String car_comp_id = "0001";
	
	e_bean = e_db.getEstimateCase(est_id);
	
	cm_bean = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	//��������
  ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	if(!est_id.equals("")){
		car_comp_id = e_bean.getCar_comp_id();
	}else{
		e_bean.setCar_ja(300000);
	}
	
	/* �ڵ� ����:�뿩��ǰ�� */
	CodeBean[] goods = c_db.getCodeAll("0009"); 
	int good_size = goods.length;
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//�ڵ���ȸ�� ����Ʈ
	CarCompBean cc_r [] = umd.getCarCompAll_Esti();
	
	
	//��������Ʈ-����Ʈ=>�����ڵ���
	Vector cars = a_cmb.getSearchCode(car_comp_id, "", "", "", "8", "");
	int car_size = cars.size();
	
	//������ ����� ��� ǥ��
	Hashtable com_ht = umd.getCarCompCase(cm_bean.getCar_comp_id());
	String etc 	= String.valueOf(com_ht.get("ETC"));
	String bigo = String.valueOf(com_ht.get("BIGO"));
%>

<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	//�������ϱ�
	function CustUpate(){
		var fm = document.form1;
		fm.action = 'upd_esti_cust_a.jsp';		
		fm.target = 'i_no';
		fm.submit();				
	}
	
	//����������
	function viewEstiDoc(){
		var SUBWIN="/acar/main_car_hp/estimate_fms.jsp?est_id=<%=est_id%>&acar_id=<%=user_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp&mobile_yn=Y&opt_chk=<%=e_bean.getOpt_chk()%>";									
		window.open(SUBWIN, "EstiPrint", "left=50, top=50, width=698, height=700, scrollbars=yes, status=yes");				
	}

	//������ϱ�
	function ReEsti(){
		var fm = document.form1;
		fm.cmd.value = 're';
		fm.action = 'new_car_esti_i.jsp';		
		fm.target = '_self';		
		fm.submit();		
	}

	function view_before()
	{
		var fm = document.form1;		
		fm.action = "new_car_esti_list.jsp";		
		fm.submit();
	}				

//-->
</script>

<body>
<form name='form1' method='post' action=''>
<%@ include file="/include/search_hidden.jsp" %>
    <input type="hidden" name="est_id" value="<%=est_id%>">
    <input type="hidden" name="cmd" value="">
    <input type="hidden" name="from_page" value="new_car_esti_u.jsp">
	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">������������</div>
			<div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='����ȭ�� ����'><img src=/smart/images/button_back.gif align=absmiddle /></a>
				<a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>                                    
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
							<td valign=top><input type="text" name="est_nm" value="<%=e_bean.getEst_nm()%>" size="25" class=text style='IME-MODE: active'></td>
						</tr>
						<tr>
							<th valign=top>�����/<br>�������</th>
							<td valign=top><input type="text" name="est_ssn" value="<%=e_bean.getEst_ssn()%>" size="15" class=text></td>
						</tr>
						<tr>
							<th valign=top>��ȭ��ȣ</th>
							<td valign=top><input type="text" name="est_tel" value="<%=e_bean.getEst_tel()%>" size="15" class=text></td>
						</tr>
						<tr>
							<th valign=top>FAX</th>
							<td valign=top><input type="text" name="est_fax" value="<%=e_bean.getEst_fax()%>" size="15" class=text></td>
						</tr>
						<tr>
							<th valign=top>E-MAIL</th>
							<td valign=top><input type="text" name="est_email" value="<%=e_bean.getEst_email()%>" size="25" class=text style='IME-MODE: inactive'></td>
						</tr>
				    	<tr>
				    		<th>������</th>
				    		<td><select name="doc_type">
					   <option value="">����</option>
                        <option value="1" <%if(e_bean.getDoc_type().equals("1"))%>selected<%%>>���ΰ�</option>
                        <option value="2" <%if(e_bean.getDoc_type().equals("2"))%>selected<%%>>���λ����</option>
						<option value="3" <%if(e_bean.getDoc_type().equals("3"))%>selected<%%>>����</option>
                      </select>
        	 		  		</td>
				    	</tr>								
				    	<tr>
				    		<th>������ȿ�Ⱓ</th>
				    		<td><select name="vali_type">
					    		<option value="">����</option>
                        		<option value="0" <%if(e_bean.getVali_type().equals("0"))%>selected<%%>>��¥��ǥ��(10��)</option>
                        		<option value="1" <%if(e_bean.getVali_type().equals("1"))%>selected<%%>>����ĿD/C ���� ���ɼ� ���</option>
                       			<option value="2" <%if(e_bean.getVali_type().equals("2"))%>selected<%%>>��Ȯ������</option>						
                      		</select>
        	 		  		</td>
				    	</tr>
				    	<tr>
				    		<th>���������<br>���� ���</th>
				    		<td>
				    			<select name="gi_grade">
				    				<option value="" <%if(e_bean.getGi_grade().equals("")){%>selected<%}%>>������ǥ��</option>
			    					<option value="1" <%if(e_bean.getGi_grade().equals("1")){%>selected<%}%>>1���</option>
			    					<option value="2" <%if(e_bean.getGi_grade().equals("2")){%>selected<%}%>>2���</option>
			    					<option value="3" <%if(e_bean.getGi_grade().equals("3")){%>selected<%}%>>3���</option>
			    					<option value="4" <%if(e_bean.getGi_grade().equals("4")){%>selected<%}%>>4���</option>
			    					<option value="5" <%if(e_bean.getGi_grade().equals("5")){%>selected<%}%>>5���</option>
			    					<option value="6" <%if(e_bean.getGi_grade().equals("6")){%>selected<%}%>>6���</option>
			    					<option value="7" <%if(e_bean.getGi_grade().equals("7")){%>selected<%}%>>7���</option>			    					
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
          			    <option value='<%=user.get("USER_ID")%>' <% if(e_bean.getReg_id().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                		<%		}
        					}%>
        			  </select>
        			  &nbsp;&nbsp;&nbsp;
        			  <input type="radio" name="caroff_emp_yn" value="1" <%if(e_bean.getCaroff_emp_yn().equals("1") || e_bean.getCaroff_emp_yn().equals("")){%>checked<%}%>  >�����������
        			  <input type="radio" name="caroff_emp_yn" value="2" <%if(e_bean.getCaroff_emp_yn().equals("2")){%>checked<%}%>  >�����������(��� ����� ǥ��)
        			  <input type="radio" name="caroff_emp_yn" value="3" <%if(e_bean.getCaroff_emp_yn().equals("3")){%>checked<%}%>  >�����������(��� ����� ��ǥ��)
        		        			  
        	 		  		</td>
				    	</tr>																																																								
				    	<tr>
				    		<th>�ſ뵵����</th>
				    		<td><b><% if(e_bean.getSpr_yn().equals("2")){%>�ʿ췮���<% }else if(e_bean.getSpr_yn().equals("1")){%>�췮���<% }else if(e_bean.getSpr_yn().equals("0")){%>�Ϲݱ��<% }else if(e_bean.getSpr_yn().equals("3")){%>�ż�����<%}%></b></td>
				    	</tr>												
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
			
	</div>
	<div id="cbtn"><a href="javascript:CustUpate();"><img src=/smart/images/btn_modify.gif align=absmiddle></a></div>
	<div style="height:10px"></div>
	<div id="contents">
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">��������</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
				    	<tr>
				    		<th width="90">������</th>
				    		<td><%=cm_bean.getCar_comp_nm()%></td>
				    	</tr>
				    	<tr>
				    		<th width="90"></th>
				    		<td><%=etc%></td>
				    	</tr>
				    	<tr>
				    		<th>����</th>
				    		<td><%=cm_bean.getCar_nm()%> (�����ڵ�:<%=cm_bean.getJg_code()%>)</td>
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
										<td><%if(!e_bean.getIn_col().equals("")){%>����: <%}%><%=e_bean.getCol()%><%if(!e_bean.getIn_col().equals("")){%>&nbsp;/&nbsp;����: <%=e_bean.getIn_col()%><%}%></td>
									</tr>
									<tr>
										<td align="right"><%=AddUtil.parseDecimal(e_bean.getCol_amt())%>��</td>
									</tr>
								</table>
							</td>
						</tr>		
						<tr>
							<th>����</th>
							<td>
								<%=e_bean.getConti_rat()%>
							</td>
							<td></td>
						</tr>				
						<tr>
							<th>������DC</th>
							<td>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td><%=e_bean.getDc()%></td>
									</tr>
									<tr>
										<td align="right">-<%=AddUtil.parseDecimal(e_bean.getDc_amt())%>��</td>
									</tr>
								</table>
							</td>
						</tr>	
				    	<tr>
				    		<th width="90"></th>
				    		<td><%=bigo%></td>
				    	</tr>
						
						<%if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>			
						<tr>
							<th>���Ҽ� ����</th>
							<td>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td>�����Һ� �� ������ ���� </td>
									</tr>
									<tr>
										<td align="right">-<%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%>��</td>
									</tr>
								</table>
							</td>
						</tr>										
						<%}%>
				    	<tr>
				    		<th width="90">���</th>
				    		<td><%=cm_bean.getEtc()%></td>
				    	</tr>						
						<tr>
							<th>��������</th>
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
				    		<th>�����Ͻ�</th>
				    		<td><%=AddUtil.ChangeDate3(e_bean.getReg_dt())%></td>
				    	</tr>	
				    	<tr>
				    		<th>�뿩��ǰ</th>
				    		<td><%=c_db.getNameByIdCode("0009", "", e_bean.getA_a())%></td>
				    	</tr>	
						<tr>
							<th>�뿩�Ⱓ</th>
							<td><%=e_bean.getA_b()%>����</td>
						</tr>																
						<tr>
							<th>�ִ��ܰ�</th>
							<td><%=e_bean.getO_13()%>%</td>
						</tr>																
				    	<tr>
				    		<th width="90">�����ܰ�</th>
				    		<td><%=e_bean.getRo_13()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>��
        	 		  		</td>
				    	</tr>																													
				    	<tr>
				    		<th>���Կɼ�</th>
				    		<td><%if(e_bean.getOpt_chk().equals("0")){%>�̺ο�<%}else if(e_bean.getOpt_chk().equals("1")){%>�ο�<%}%>
							</td>
				    	</tr>
				    	<tr>
				    		<th>������</th>
				    		<td><%=e_bean.getRg_8()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean.getRg_8_amt())%>��
        	 		  		</td>
				    	</tr>				
				    	<tr>
				    		<th>������</th>
				    		<td><%=e_bean.getPp_per()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean.getPp_amt())%>��
        	 		  		</td>
				    	</tr>			
				    	<tr>
				    		<th>���ô뿩��</th>
				    		<td><%=e_bean.getG_10()%>����ġ</td>
				    	</tr>	
				    	<tr>
				    		<th>��������</th>
				    		<td><%if(e_bean.getInsurant().equals("1")){%>�Ƹ���ī<%}else if(e_bean.getInsurant().equals("2")){%>��<%}%></td>
				    	</tr>	
				    	<tr>
				    		<th>�Ǻ�����</th>
				    		<td><%if(e_bean.getIns_per().equals("1")){%>�Ƹ���ī(��������)<%}else if(e_bean.getIns_per().equals("2")){%>��(���������)<%}%></td>
				    	</tr>	
				    	<tr>
				    		<th>�빰/�ڼ�</th>
				    		<td><%if(e_bean.getIns_dj().equals("1")){%>5õ����/5õ����<%}else if(e_bean.getIns_dj().equals("2")){%>1���/1���<%}else if(e_bean.getIns_dj().equals("4")){%>2���/1���<%}else if(e_bean.getIns_dj().equals("8")){%>3���/1���<%}else if(e_bean.getIns_dj().equals("3")){%>5���/1���<%}%></td>
				    	</tr>																																																	
																																																						
				    	<tr>
				    		<th>�����ڿ���</th>
				    		<td><%if(e_bean.getIns_age().equals("1")){%>��26���̻�<%}else if(e_bean.getIns_age().equals("2")){%>��21���̻�<%}else if(e_bean.getIns_age().equals("3")){%>��24���̻�<%}%></td>
				    	</tr>																																																																																																							
				    	<tr>
				    		<th>������å��</th>
				    		<td><%=AddUtil.parseDecimal(e_bean.getCar_ja())%>��</td>
				    	</tr>																																																							
				    	<tr>
				    		<th>��������</th>
				    		<td><%=e_bean.getGi_per()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean.getGi_amt())%>��</td>
				    	</tr>	
				    	<tr>
				    		<th>��ǰ</th>
				    		<td><%if(e_bean.getTint_b_yn().equals("Y")){%>2ä�� ���ڽ�<%}%><br><%if(e_bean.getTint_s_yn().equals("Y")){%>���� ����(�⺻��)<%}%><br><%if(e_bean.getTint_ps_yn().equals("Y")){%>��޽���<%}%><%if(e_bean.getTint_ps_nm()!=""){%><br><span style="margin-left:100px;">���� : <%=e_bean.getTint_ps_nm()%></span><%}%><%if(e_bean.getTint_ps_amt()!=0){%><br><span style="margin-left:30px;">�߰��ݾ�(���ް�) : <%=AddUtil.parseDecimal(e_bean.getTint_ps_amt())%> ��</span><%}%><br><%if(e_bean.getTint_n_yn().equals("Y")){%>��ġ�� ������̼�<%}%><br><%if(e_bean.getTint_bn_yn().equals("Y")){%>���ڽ� ������ ���� (��Ʈ��ķ,������..)<%}%><br><%if(e_bean.getTint_eb_yn().equals("Y")){%>�̵��� ������(������)<%}%><%if (e_bean.getTint_cons_amt() != 0) {%><br>�߰�Ź�۷�� : <%=AddUtil.parseDecimal(e_bean.getTint_cons_amt())%> ��<%}%><br>
				    			<%if(e_bean.getNew_license_plate().equals("1") || e_bean.getNew_license_plate().equals("2")){%>������ȣ��<%} else if(e_bean.getNew_license_plate().equals("0")){%>������ȣ��<%} %>
				    			<%-- <%if(e_bean.getNew_license_plate().equals("1") || e_bean.getNew_license_plate().equals("2")){%>������ȣ�ǽ�û<%}%> --%>
<%-- 				    			<%if(e_bean.getNew_license_plate().equals("1")){%>������ȣ�ǽ�û(������)<%} else if (e_bean.getNew_license_plate().equals("2")){%>������ȣ�ǽ�û(����/�뱸/����/�λ�)<%}%> --%>
				    		</td>
				    	</tr>
				    	<%if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>		
				    	<tr>
				    		<th>������ ���ּ���</th>
				    		<td><%=c_db.getNameByIdCode("0034", "", e_bean.getEcar_loc_st())%></td>
				    	</tr>
				    	<%if (!(ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4"))) {%>
				    	<tr>
				    		<th>�������ｺƼĿ �߱�</th>
				    		<td><%if(e_bean.getEco_e_tag().equals ("0")){%>�̹߱�<%}else if(e_bean.getEco_e_tag().equals("1")){%>�߱�<%}%></td>
				    	</tr>
				    	<%}%>
				    	<%}%>
				    	<tr>
				    		<th>�����μ�����</th>
				    		<td><%=c_db.getNameByIdCode("0035", "", e_bean.getUdt_st())%></td>
				    	</tr>			
				    	<tr>
				    		<th>�ǵ������</th>
				    		<td><%=c_db.getNameByIdCode("0032", "", e_bean.getA_h())%></td>
				    	</tr>																																																						
				    	<tr>
				    		<th>��������</th>
				    		<td>������<%=e_bean.getO_11()%>%</td>
				    	</tr>																																																	
				    	<tr>
				    		<th>�뿩��D/C</th>
				    		<td>�뿩����<%=e_bean.getFee_dc_per()%>%</td>
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
				    		<th width="90">���ް�</th>
				    		<td><%=AddUtil.parseDecimal(e_bean.getFee_s_amt())%>��</td>
				    	</tr>	
				    	<tr>
				    		<th>�ΰ���</th>
				    		<td><%=AddUtil.parseDecimal(e_bean.getFee_v_amt())%>��</td>
				    	</tr>	
						<tr>
							<th>���뿩���</th>
							<td><%=AddUtil.parseDecimal(e_bean.getFee_s_amt()+e_bean.getFee_v_amt())%>��</td>
						</tr>																
						<tr>
							<th>�ʿ�������</th>
							<td><%=e_bean.getCls_n_per()%>%</td>
						</tr>																
				    	<tr>
				    		<th>����������</th>
				    		<td><%=e_bean.getCls_per()%>%</td>
				    	</tr>																													
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>				
						
	</div>
	<div id="cbtn">
			<a href="javascript:viewEstiDoc();"><img src=/smart/images/btn_see_est.gif align=absmiddle></a>&nbsp;&nbsp;&nbsp;
			<a href="javascript:ReEsti();"><img src=/smart/images/btn_re_est.gif align=absmiddle></a></div>
	<div id="footer"></div>  
</div>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
