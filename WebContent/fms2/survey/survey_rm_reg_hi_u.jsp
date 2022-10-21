<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.cont.*, acar.common.*, acar.call.*, acar.util.*,acar.client.*, acar.car_mst.*, acar.user_mng.*, acar.cls.*, acar.credit.* "%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="p_db" scope="page" class="acar.call.PollDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//�����ȸ ������
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	//�޴�����
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");	//�����ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");		//�Ҽӻ�ID
	
	//�˻�����
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank 	= request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String cont_st 	= request.getParameter("cont_st")==null?"":request.getParameter("cont_st");
	String b_lst 	= request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");		//rent_mng_id
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");		//rent_l_cd
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");		//car_mng_id
	String use_yn 	= request.getParameter("use_yn")==null?"":request.getParameter("use_yn");	//������
	String gubun1 	= request.getParameter("gubun1")==null?"20":request.getParameter("gubun1");
	
	String type 	= request.getParameter("type")==null?"1":request.getParameter("type");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "16", "01", "01");
	
	//�������
	ContBaseBean base = a_db.getContBaseHi(m_id, l_cd);
	if(c_id.equals(""))	c_id = base.getCar_mng_id();
		
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(m_id, l_cd);
	
	
	//���ǿ���
	Vector im_vt = af_db.getFeeImList(m_id, l_cd, "");
	int im_vt_size = im_vt.size();
	
	
	
	//������
	ClientBean client 		= al_db.getClient(base.getClient_id());

	//��������
	ClsBean cls = as_db.getClsCase(m_id, l_cd);
	
	//�����Ƿ�����
	ClsEtcBean clss = ac_db.getClsEtcCase(m_id, l_cd);
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();

	
	//cont call  reg_id
	String reg_id 	= "";
	reg_id = p_db.getCallReg_id(m_id, l_cd);	
	
	if ( reg_id.equals("")) {
		reg_id = user_id;
	}
 	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--


	
	//�����ϱ�
	function nocall()
	{
		var fm = document.form1;	
		if(confirm('Call �������� �����Ͻðڽ��ϱ�?')){
			fm.target='nodisplay';
//			fm.target='parent.c_foot';
			fm.action='call_reg_cont_u_a.jsp';
			fm.submit();
		}
				
	}	
	
	
	

	
//-->
</script>
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
</head>
<body leftmargin="15">
<form action='survey_reg_hi_u_a.jsp' name="form1" method='post'>
<input type='hidden' name='h_pay_tm' value=''>
<input type='hidden' name='h_pay_start_dt' value=''>
<input type='hidden' name='h_pay_end_dt' value=''>
<input type='hidden' name='h_brch' value='<%= base.getBrch_id()%>'>
<input type='hidden' name='use_yn' value='<%=base.getUse_yn()%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='cont_st' value='<%=cont_st%>'>
<input type='hidden' name='b_lst' value='<%=b_lst%>'> 
<input type='hidden' name='type' value='<%=type%>'> 
<input type='hidden' name="s_dept_id" value=''>
<input type='hidden' name="reg_id" value=''>

<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr> 
        <td class= colspan="3">
			<table border="0" cellspacing="1" cellpadding='0' width=100%>
				<tr>
					<td class=""></td>
					<td align="right"></td>
				</tr>
			</table>
		</td>
    </tr>
    <tr>
        <td class=h><label><i class="fa fa-check-circle"></i> ������ </label></td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width="15%">����ȣ</td>
                    <td width="30%" class=b>&nbsp;<%=base.getRent_l_cd()%></td>
                    <td class=title width="15%">�������</td>
                    <td width="30%" class=b>&nbsp;<%=base.getRent_dt()%></td>
				</tr>
				<tr>
                    <td class=title width="10%">��౸��</td>
                    <td  colspan="" class=b>&nbsp; 
                      <select name='s_rent_st' onChange='javascript:change_sub_menu()' disabled >
                        <option value='1' <% if(base.getRent_st().equals("1")){%> selected <%}%>>�ű�</option>
                        <option value='3' <% if(base.getRent_st().equals("3")){%> selected <%}%>>����</option>
                        <option value='4' <% if(base.getRent_st().equals("4")){%> selected <%}%>>����</option>
                        <option value='5' <% if(base.getRent_st().equals("5")){%> selected <%}%>>����(6�����̸�)</option>
                        <option value='2' <% if(base.getRent_st().equals("2")){%> selected <%}%>>����(6�����̻�)</option>
                        <option value='6' <% if(base.getRent_st().equals("6")){%> selected <%}%>>�縮��(6�����̻�)</option>
                        <option value='7' <% if(base.getRent_st().equals("7")){%> selected <%}%>>�縮��(6�����̸�)</option>				
                      </select>
                    </td>
                    <td align="center" width="10%" class=title>�뿩����</td>
                    <td width="30%" class=b>&nbsp;
                      <select name="s_car_st" onChange='javascript:set_con_cd()' disabled >
                        <%if(base.getCar_st().equals("1") || base.getCar_st().equals("3")){%>
                        <option value="1" <%if(base.getCar_st().equals("1")){%>selected<%}%>>��Ʈ</option>
                        <option value="3" <%if(base.getCar_st().equals("3")){%>selected<%}%>>����</option>
                        <%}else if(base.getCar_st().equals("2")){%>
                        <option value="2" <%if(base.getCar_st().equals("2")){%>selected<%}%>>����</option>
						<%}else if(base.getCar_st().equals("4")){%>
                        <option value="4" <%if(base.getCar_st().equals("4")){%>selected<%}%>>����Ʈ</option>
                        <%}%>
						</select>
					</td>
				</tr>
                <tr>
                    <td width="10%" align="center" class=title>�뿩���</td>
                    <td width="30%" class=b>&nbsp;
                      <%if(nm_db.getWorkAuthUser("�뿩��ĺ���",user_id)){%>
                      <select name="s_rent_way" disabled >
                        <option value=''  <%if(base.getRent_way().equals("")){%>selected<%}%>>����</option>
                        <option value='1' <%if(base.getRent_way().equals("1")){%>selected<%}%>>�Ϲݽ�</option>
                        <option value='2' <%if(base.getRent_way().equals("2")){%>selected<%}%>>�����</option>
                        <option value='3' <%if(base.getRent_way().equals("3")){%>selected<%}%>>�⺻��</option>
                      </select>
                      <%}else{%>
                      <%	if(base.getRent_way().equals("1")){%>
                        �Ϲݽ�
                        <%	}else if(base.getRent_way().equals("2")){%>
                        �����
                        <%	}else if(base.getRent_way().equals("3")){%>
                        �⺻��
                        <%	}%>
                        <input type='hidden' name="s_rent_way" value='<%=base.getRent_way()%>'>
                        <%}%>
					</td>
                    <td width="10%" align="center" class=title>��������</td>
                    <td width="30%" class=b>&nbsp;
                      <select name="s_bus_st" disabled >
                        <option value=""  <%if(base.getBus_st().equals("")){%>selected<%}%>>����</option>
                        <option value="1" <%if(base.getBus_st().equals("1")){%>selected<%}%>>���ͳ�</option>
                        <option value="2" <%if(base.getBus_st().equals("2")){%>selected<%}%>>�������</option>
                        <option value="3" <%if(base.getBus_st().equals("3")){%>selected<%}%>>������ü�Ұ�</option>
                        <option value="4" <%if(base.getBus_st().equals("4")){%>selected<%}%>>catalog�߼�</option>
                        <option value="5" <%if(base.getBus_st().equals("5")){%>selected<%}%>>��ȭ���</option>
                        <option value="6" <%if(base.getBus_st().equals("6")){%>selected<%}%>>������ü</option>
                        <option value="7" <%if(base.getBus_st().equals("7")){%>selected<%}%>>������Ʈ</option>
                        <option value="8" <%if(base.getBus_st().equals("8")){%>selected<%}%>>�����</option>
                      </select>
					</td>
                </tr>		  
                <tr> 
                    <td width="10%" align="center" class=title>�뿩����</td>
                    <td width="30%" class=b>&nbsp;<%=base.getCon_mon()%>���� </td>
                    <td width="10%" align="center" class=title>�뿩�Ⱓ</td>
                    <td width="30%" class=b>&nbsp;<%=base.getRent_start_dt()%>	~	<%=base.getRent_end_dt()%></td>
                </tr>
                <tr> 
                    <td width="10%" align="center" class=title>���ʿ�����</td>
                    <td width="30%" class=b>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
                    <td width="10%" align="center" class=title>�����븮��</td>
                    <td width="30%" class=b>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
				</tr>
				<tr>
                    <td width="10%" align="center" class=title>���������</td>
                    <td width="30%" class=b>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>    
                    <td width="10%"  class=title align="center">���������</td>
                    <td width="30%"  class=b>&nbsp;<%=c_db.getNameById(base.getMng_id(),"USER")%></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h><label><i class="fa fa-check-circle"></i> �� </label></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width='15%' class='title'>������</td>
                    <td width='30%' align='left'>&nbsp;<% if(client.getClient_st().equals("1")){%>����
						<% }else if(client.getClient_st().equals("2")){%>����
						<% }else if(client.getClient_st().equals("3")){%>���λ����(�Ϲݰ���)
						<% }else if(client.getClient_st().equals("4")){%>���λ����(���̰���)
						<% }else if(client.getClient_st().equals("5")){%>���λ����(�鼼�����)
						<% }%> 
					</td>
                    <td width='15%' class='title'>��ȣ</td>
                    <td width='30%' align='left'>&nbsp;<%=client.getFirm_nm()%></td>
				</tr>
                <tr>	
                    <td width='10%' class='title'>��ǥ��</td>
                    <td width='30%' align='left'>&nbsp;<%=client.getClient_nm()%></td>
                    <td width="" class='title'>����ڹ�ȣ</td>
                    <td width="" align='left'>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%> </td>
				</tr>
                <tr>
                    <td width="" class='title'>�������</td>
					<td width="" align='left'>&nbsp;<%=client.getSsn1()%>-******* </td>
                    <td width='' class='title'>Homepage</td>
                    <td align='left'>&nbsp; 
                      <%if(!client.getHomepage().equals("") && client.getHomepage().length() > 7){%>
                      <a href="<%=client.getHomepage()%>" target="_bank"><%=client.getHomepage()%></a> 
                      <%}else{%>
                      <%=client.getHomepage()%>
                      <%}%>
                    </td>
                </tr>
                <tr> 
                    <td width="" class='title'>�繫����ȭ</td>
                    <td width="" align='left'>&nbsp;<%= client.getO_tel()%></td>
                    <td width="" class='title'>FAX ��ȣ</td>
                    <td width="" align='left'>&nbsp;<%= client.getFax()%></td>
				</tr>
                <tr>
                    <td class='title' width="10%">���������</td>
                    <td class='left'>&nbsp;<%= client.getOpen_year()%></td>
                    <td width="" class='title'>�ں���</td>
                    <td width="" align='left'>&nbsp;<%if(client.getFirm_price() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price())+"�鸸��/"+client.getFirm_day());%></td>
				</tr>
                <tr>                
                    <td width="" class='title'>������</td>
                    <td width="">&nbsp;<%if(client.getFirm_price_y() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price_y())+"�鸸��/"+client.getFirm_day_y());%> </td>
                    <td width="" class='title'>���౸��</td>
                    <td>&nbsp;<% if(client.getPrint_st().equals("1")){%>���Ǻ�
						<% }else if(client.getPrint_st().equals("2")){%>�ŷ�ó����
						<% }else if(client.getPrint_st().equals("3")){%>��������
						<% }else if(client.getPrint_st().equals("4")){%>��������
						<% }%>
                    </td>
                </tr>
                <tr> 
                    <td width="10%" class='title'>����</td>
                    <td width="" align='left'>&nbsp;<%= client.getBus_cdt()%></td>
                    <td width="10%" class='title'>����</td>
                    <td align='left'>&nbsp;<%= client.getBus_itm()%></td>
                </tr>
                <tr> 
                    <td width="10%" class='title'>������ּ�</td>
                    <td colspan="3">&nbsp;(<%=client.getO_zip()%>)&nbsp;<%=client.getO_addr()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<%//���ΰ�����������
        			Vector car_mgrs = a_db.getCarMgr(m_id, l_cd);
        			int mgr_size = car_mgrs.size();
        			if(mgr_size > 0){
        				for(int i = 0 ; i < mgr_size ; i++){
        					CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);%>
	<tr>	
        <td class=h></td>
    </tr>
	<tr>
        <td class=h><label><i class="fa fa-check-circle"></i> <%= mgr.getMgr_st()%> </label></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="15%">�ٹ��μ�</td>
					<td width="30%">&nbsp;
					<%= mgr.getMgr_dept()%></td>
                    <td class=title width="15%">����</td>
					<td width="30%">&nbsp;
					<%= mgr.getMgr_nm()%></td>
				</tr>	
				<tr>
                    <td class=title width="15%">����</td>
					<td width="30%">&nbsp;
					<%= mgr.getMgr_title()%></td>
                    <td class=title width="15%">��ȭ��ȣ</td>
					<td width="30%">&nbsp;
					<%= mgr.getMgr_tel()%></td>
				</tr>	
				<tr>
                    <td class=title width="15%">�޴���</td>
					<td width="30%">&nbsp;
					<%= mgr.getMgr_m_tel()%></td>
                    <td class=title width="15%">E-MAIL</td>
					<td width="30%">&nbsp;
					<%= mgr.getMgr_email()%></td>
                </tr>
            
            </table>
	    </td>
    </tr>
	  <%	}
	}%>
	<tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h><label><i class="fa fa-check-circle"></i> �����⺻���� </label></td>
    </tr>
    <%	
		//�����������
		Hashtable car_fee 	= a_db.getCarRegFee(m_id, l_cd);
		//�����⺻����
		ContCarBean car 	= a_db.getContCar(m_id, l_cd);
		
		//�ڵ���ȸ��&����&�ڵ�����
		AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
		CarMstBean mst 		= a_cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
	%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id='write'> 
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    <td class='line'>
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>                   
                            <tr> 
                                <td class='title' width="15%"> ������ȣ </td>
                                <td width="30%">&nbsp;<%=car_fee.get("CAR_NO")%></td>
                                <td class='title' width="15%"> �ڵ���ȸ�� </td>
                                <td width="30%">&nbsp;<%=mst.getCar_comp_nm()%></td>
							</tr>
							<tr>
                                <td class='title' width="100">����</td>
                                <td width="30%">&nbsp;<%=mst.getCar_nm()%></td>
                                <td class='title' width='100'>����</td>
                                <td width="30%">&nbsp;<%=mst.getCar_name()%></td>
                            </tr>                                                        
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>	
   	<tr>
        <td class=h></td>
    </tr>
	<%if(im_vt_size>0){%>
	<tr>
        <td class=h><label><i class="fa fa-check-circle"></i> �뿩�Ⱓ </label></td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr> 
		<td colspan="3" width="90%" class=line> 
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				  <tr> 
					<td class=title width="13%">����</td>
					<td class=title width="10%">ȸ��</td>			
					<td class=title width="37%">�뿩�Ⱓ</td>
					<td class=title width="15%">�����</td>
					<td class=title width="20%">�����</td>                    
				  </tr>
				  <%	for(int i = 0 ; i < im_vt_size ; i++){
							Hashtable im_ht = (Hashtable)im_vt.elementAt(i);%>
				  <tr> 
					<td align='center'><%=i+1%></td>
					<td align='center'><%=im_ht.get("ADD_TM")%>ȸ��</td>
					<td align='center'><%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_END_DT")))%></td>
					<td align='center'><%=im_ht.get("USER_NM")%></td>
					<td align='center'><%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("REG_DT")))%></td>
				  </tr>
				  <%	} %>
			</table>
		</td>
	</tr>				
	<tr>
        <td class=h></td>
    </tr>
	<%}%>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h><label><i class="fa fa-check-circle"></i> �������� </label></td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr> 
					<td width='15%' class='title'>��������</td>
					<td width="23%" align='center'><%if(cls.getCls_st().equals("����Ʈ����")){%>����Ʈ����<%}%></td>
					<td width='15%' class='title'>������</td>
					<td width="23%" align='center'><%=cls.getCls_dt()%></td>
				</tr>
				<tr> 
					<td class='title' width="15%">�̿�Ⱓ</td>
					<td width="23%" align='center'><%=cls.getR_mon()%>���� <%=cls.getR_day()%>��</td>
					<td width='10%' class='title'>������<br>���Թ��</td>
					<td align='center'><% if(cls.getPp_st().equals("1")){%>
							3����ġ �뿩�� ������
						<%}else if(cls.getPp_st().equals("2")){%>
							�� ������ ������
						<%}%>
					</td>
				</tr>
				<tr> 
					<td width='15%' class='title'>���꼭<br>�ۼ����� </td>
					<td align='center'><% if(cls.getCls_doc_yn().equals("N")){%>
							����
						<%}else if(cls.getCls_doc_yn().equals("Y")){%>
							����
						<%}%>
					</td>
					<td width='15%' class='title'>�ܿ�������<br>������ҿ���</td>
					<td align='center'> <% if(cls.getCancel_yn().equals("N")){%>
							��������
						<%}else if(cls.getCancel_yn().equals("Y")){%>
							�������
						<%}%>
					</td>			
				</tr>
				<tr> 
					<td width='15%' class='title'>�������� </td>
					<td colspan="3" align='center'><br><%=cls.getCls_cau()%><br>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h><label><i class="fa fa-check-circle"></i> �̳��Աݾ� ����</label></td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr> 
		<td class='line'>
		  <table border="0" cellspacing="1" cellpadding="0" width="100%">
			<tr> 
			  <td class="title" colspan="4">�׸�</td>
			  <td class="title" width='30%'>����</td>
			  <td class="title" width='35%'>���</td>
			</tr>
			<tr> 
			  <td class="title" rowspan="18" width="5%">��<br>
				��<br>
				��<br>
				��<br>
				��</td>
			  <td colspan="3" class="title">���·�/��Ģ��(D)</td>
			  <td class='title' width='30%' style="text-align:right;"> 
				<%=AddUtil.parseDecimal(cls.getFine_amt())%>��&nbsp; </td>
			  <td class='title' width='35%'>&nbsp;</td>
			</tr>
			 <tr> 
			  <td colspan="3" class="title">�ڱ��������ظ�å��(E)</td>
			  <td class='title' width='30%' style="text-align:right;"> 
				<%=AddUtil.parseDecimal(cls.getCar_ja_amt())%>��&nbsp; </td>
			  <td class='title' width='35%'>&nbsp;</td>
			</tr>
			<tr> 
			  <td class="title" rowspan="5" width="5%"><br>
				��<br>
				��<br>
				��</td>
			  <td align="center" colspan="2">������</td>
			  <td width='30%' align="right">&nbsp; 
				<%=AddUtil.parseDecimal(cls.getEx_di_amt())%>��&nbsp; </td>
			  <td width='35%'>&nbsp; </td>
			</tr>
			<tr> 
			  <td rowspan="2" align="center" width="10%">�̳���</td>
			  <td width='5%' align="center">�Ⱓ</td>
			  <td width='30%' align="center"> 
				<%=cls.getNfee_mon()%>���� &nbsp; <%=cls.getNfee_day()%>�� </td>
			  <td width='35%'>&nbsp;</td>
			</tr>
			<tr> 
			  <td align="center">�ݾ�</td>
			  <td width='30%' align="right"> 
				<%=AddUtil.parseDecimal(cls.getNfee_amt())%>��&nbsp; </td>
			  <td width='35%'>���� ���ݰ�꼭 ����</td>
			</tr>
			<tr> 
			  <td colspan="2" align="center">��ü��</td>
			  <td width='30%' align="right"> 
				<%=AddUtil.parseDecimal(cls.getDly_amt())%>��&nbsp; </td>
			  <td width='35%'>&nbsp;</td>
			</tr>
			<tr> 
			  <td class="title" colspan="2">�뿩��(F)</td>
			  <td class='title' width='30%' style="text-align:right;">
				�� </td>
			  <td class='title' width='35%'>&nbsp;</td>
			</tr>
			<tr> 
			  <td rowspan="6" class="title">��<br>
				��<br>
				��<br>
				��<br>
				��<br>
				��<br>
				��</td>
			  <td align="center" colspan="2">�뿩���Ѿ�</td>
			  <td width='30%' align="right"> 
				<%=AddUtil.parseDecimal(cls.getTfee_amt())%>��&nbsp;</td>
			  <td width='35%'>=������+���뿩���Ѿ�</td>
			</tr>
			<tr> 
			  <td align="center" colspan="2">���뿩��(ȯ��)</td>
			  <td width='30%' align="right"> 
				<%=AddUtil.parseDecimal(cls.getMfee_amt())%>��&nbsp;</td>
			  <td width='35%'>=�뿩���Ѿס����Ⱓ</td>
			</tr>
			<tr> 
			  <td align="center" colspan="2">�ܿ��뿩���Ⱓ</td>
			  <td width='30%' align="center"> 
				<%=cls.getRcon_mon()%>���� <%=cls.getRcon_day()%>��</td>
			  <td width='35%'>&nbsp;</td>
			</tr>
			<tr> 
			  <td align="center" colspan="2">�ܿ��Ⱓ �뿩�� �Ѿ�</td>
			  <td width='30%' align="right"> 
				<%=AddUtil.parseDecimal(cls.getTrfee_amt())%>��&nbsp;</td>
			  <td width='35%'>&nbsp;</td>
			</tr>
			<tr> 
			  <td align="center" colspan="2">����� �������</td>
			  <td width='30%' align="center"> 
				<%=cls.getDft_int()%>%</td>
			  <td width='35%'>�ܿ��Ⱓ �뿩�� �Ѿ� ����</td>
			</tr>
			<tr> 
			  <td  class="title" colspan="2">�ߵ����������(G)</td>
			  <td class='title' width='30%' style="text-align:right;"> 
				<%=AddUtil.parseDecimal(cls.getDft_amt())%>��&nbsp;</td>
			  <td align="left"><%if(clss.getTax_chk0().equals("Y")){%>�ߵ���������� ��꼭 ����<%}%></td>
			</tr>
			<tr> 
			 <td class="title" rowspan="5" width="5%"><br>
				��<br>
				Ÿ</td> 
			  <td colspan="2" class="title">����ȸ�����ֺ��(H)</td>
			  <td class='title' width='30%' style="text-align:right;"> 
				<%=AddUtil.parseDecimal(cls.getEtc_amt())%>�� &nbsp;</td>
			   <td align="left"><%if(clss.getTax_chk1().equals("Y")){%>����ȸ�����ֺ�� ��꼭 ����<%}%></td>
			</tr>
			<tr> 
			  <td colspan="2" class="title">����ȸ���δ���(I)</td>
			  <td class='title' width='30%' style="text-align:right;"> 
				<%=AddUtil.parseDecimal(cls.getEtc2_amt())%>�� &nbsp;</td>
			  <td align="left"><%if(clss.getTax_chk2().equals("Y")){%>����ȸ���δ��� ��꼭 ����<%}%></td>
			</tr>
			<tr> 
			  <td colspan="2" class="title">������������(J)</td>
			  <td class='title' width='30%' style="text-align:right;"> 
				<%=AddUtil.parseDecimal(cls.getEtc3_amt())%>�� &nbsp;</td>
			  <td width='35%'>&nbsp;</td>
			</tr>
			<tr> 
			  <td colspan="2" class="title">��Ÿ���ع���(K)</td>
			  <td class='title' width='30%' style="text-align:right;"><%=AddUtil.parseDecimal(cls.getEtc4_amt())%>��&nbsp; </td>
			  <td align="left"><%if(clss.getTax_chk3().equals("Y")){%>��Ÿ���ع��� ��꼭 ����<%}%></td>
			</tr>
			<tr> 
				<td colspan="2" class="title">�ΰ���(L)</td>
				<td class='title' width='30%' style="text-align:right;"><%=AddUtil.parseDecimal(cls.getNo_v_amt())%>��&nbsp; </td>
				<td class='title' width='35%'>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr> 
							<td style="display:''" class='title'>=(�̳��Աݾ�-B-C)��10% </td>
							<td style='display:none' class='title'>=(�̳��Աݾ�-B-C)��10% </td>
						</tr>
					</table>
				</td>
			</tr>
			<tr> 
				<td class="title" colspan="4">��(J)</td>
				<td class='title' width='30%' style="text-align:right;"><%=AddUtil.parseDecimal(cls.getFdft_amt1())%>��&nbsp; </td>
				<td class='title' width='35%'>=(D+E+F+G+H+I+J+K+L)</td>
			</tr>
		  </table>
		</td>
	</tr>
	<tr>
        <td></td>
    </tr>
</table>
</form>
</body>
</html>
