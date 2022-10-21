<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.cont.*, acar.client.*, acar.accid.*, acar.car_mst.*, acar.car_service.*,  acar.user_mng.*, acar.car_office.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="p_db" scope="page" class="acar.call.PollDatabase"/>
<jsp:useBean id="s_bean" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="s_bean2" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
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
	String s_id 	= request.getParameter("s_id")==null?"":request.getParameter("s_id");		//serv_id
	String use_yn 	= request.getParameter("use_yn")==null?"":request.getParameter("use_yn");	//������
	String gubun1 	= request.getParameter("gubun1")==null?"20":request.getParameter("gubun1");
	
	String type 	= request.getParameter("type")==null?"1":request.getParameter("type");
	
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");	
	
	String accid_id 	= request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "16", "01", "01");
	
	AccidDatabase as_db = AccidDatabase.getInstance();	
	
	
	//�������
	ContBaseBean base = a_db.getContBaseHi(m_id, l_cd);
	if(c_id.equals(""))	c_id = base.getCar_mng_id();
		
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(m_id, l_cd);
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();	// 2018.05.23
	
	
	
	//cont call  reg_id
	String reg_id 	= "";
	reg_id = p_db.getCallServiceReg_id(m_id, l_cd,c_id,s_id);	
	
	if ( reg_id.equals("")) {
		reg_id = user_id;
	}
	
	//���:������
	ContBaseBean base2 		= p_db.getContBaseAll(m_id, l_cd);
	
	String h_brch = base.getBrch_id();
	String rent_st = base.getRent_st();
	String bus_st = base.getBus_st();  //6:������ü
	String ext_st = base.getExt_st();
		
	if (rent_st.equals("2")){
		rent_st = "5";
	}else if (rent_st.equals("7")){	
		rent_st = "6";
	}
	if (rent_st.equals("6") &&	bus_st.equals("6")){
			rent_st = "8";   // �縮�� ������ü
	}
	if (ext_st.equals("����")){
		rent_st = "5";
	}		
	//������
	ClientBean client 		= al_db.getClient(base.getClient_id());
	
	//�����ȸ
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
	  
	String accid_dt = a_bean.getAccid_dt();
	String accid_dt_h = "";
	String accid_dt_m = "";
	if(!accid_dt.equals("")){
		accid_dt = a_bean.getAccid_dt().substring(0,8);
		accid_dt_h = a_bean.getAccid_dt().substring(8,10);
		accid_dt_m = a_bean.getAccid_dt().substring(10,12);
	}
	  
	 //����/����(��å��)
	ServiceBean s_r [] = as_db.getServiceList(c_id, accid_id);
	

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

	//����ϱ�
	function save()
	{		
		var fm = document.form1;		
		var t_fm = parent.c_foot.document.form1;
				
	}


	//�����ϱ�
	function update()
	{
		var fm = document.form1;	
		save();			
		parent.c_foot.save();
		
	}	
	
	
	//��Ϻ���
	function list(b_lst)
	{
		var fm = document.form1;
		var auth = fm.auth_rw.value;
		var s_kd = fm.s_kd.value;
		var brch_id = fm.brch_id.value;
		var s_bank = fm.s_bank.value;
		var t_wd = fm.t_wd.value;		
		var cont_st = fm.cont_st.value;		
		var type1 = fm.type.value;		
		
		if ( type1 == '1' ) {
			parent.location='/fms2/survey/car_accident_s_frame.jsp?dt='+fm.dt.value+'&gubun2='+fm.gubun2.value+'&ref_dt1='+fm.ref_dt1.value+'&ref_dt2='+fm.ref_dt2.value+'&auth_rw='+auth+'&s_kd='+s_kd+'&brch_id='+brch_id+'&s_bank='+s_bank+'&t_wd='+t_wd+'&cont_st='+cont_st;
		} else { 
			parent.location='/fms2/survey/call_accident_s_frame.jsp?auth_rw='+auth+'&s_kd='+s_kd+'&brch_id='+brch_id+'&s_bank='+s_bank+'&t_wd='+t_wd+'&cont_st='+cont_st;
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
<form action='call_service_reg_hi_u_a.jsp' name="form1" method='post'>
<input type='hidden' name='h_pay_tm' value=''>
<input type='hidden' name='h_pay_start_dt' value=''>
<input type='hidden' name='h_pay_end_dt' value=''>
<input type='hidden' name='h_brch' value='<%= base.getBrch_id()%>'>
<input type='hidden' name='use_yn' value='<%=base.getUse_yn()%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='s_id' value='<%=s_id%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='cont_st' value='<%=cont_st%>'>
<input type='hidden' name='b_lst' value='<%=b_lst%>'> 
<input type='hidden' name='type' value='<%=type%>'> 
<input type='hidden' name="s_dept_id" value=''>
<input type='hidden' name='dt' value="<%=dt%>">
<input type='hidden' name='gubun2' value="<%=gubun2%>">
<input type='hidden' name='ref_dt1' value="<%=ref_dt1%>">
<input type='hidden' name='ref_dt2' value="<%=ref_dt2%>"> 
 
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
                    <td width="30%" class=b>&nbsp;
					<%=base.getRent_l_cd()%></td>
                    <td class=title width="15%">�������</td>
                    <td width="30%" class=b>&nbsp;
					<%=base.getRent_dt()%></td>
				</tr>
				<tr>
                    <td class=title width="100">��౸��</td>
                    <td class=b>&nbsp; 
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
                    <td align="center" class=title>�뿩����</td>
                    <td width="160" class=b>&nbsp;
                      <select name="s_car_st" onChange='javascript:set_con_cd()' disabled >
                        <%if(base.getCar_st().equals("1") || base.getCar_st().equals("3")){%>
                        <option value="1" <%if(base.getCar_st().equals("1")){%>selected<%}%>>��Ʈ</option>
                        <option value="3" <%if(base.getCar_st().equals("3")){%>selected<%}%>>����</option>
                        <%}else if(base.getCar_st().equals("2")){%>
                        <option value="2" <%if(base.getCar_st().equals("2")){%>selected<%}%>>����</option>
                        <%}%>
                    </select></td>
				</tr>
                <tr>
                    <td width="100" align="center" class=title>�뿩���</td>
                    <td width="160" class=b>&nbsp;
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
                        <%}%></td>
                    <td width="100" align="center" class=title>��������</td>
                    <td class=b>&nbsp;
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
                      </select></td>
                </tr>		  
                <tr> 
                    <td width="110" align="center" class=title>�뿩����</td>
                    <td width="160" class=b>&nbsp;
					<%=base.getCon_mon()%>���� </td>
                    <td width="100" align="center" class=title>�뿩�Ⱓ</td>
                    <td class=b>&nbsp;
					<%=base.getRent_start_dt()%>
                    ~
                    <%=base.getRent_end_dt()%></td>
                </tr>
                <tr> 
                    <td width="110" align="center" class=title>���ʿ�����</td>
                    <td width="160" class=b>&nbsp;
						<%=c_db.getNameById(base.getBus_id(),"USER")%> <br/>
						<%if(!base.getAgent_emp_id().equals("")){ CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id()); %>&nbsp;(�����������:<%=a_coe_bean.getEmp_nm()%>&nbsp;<%=a_coe_bean.getEmp_m_tel()%>)<%}%>
					</td>
                    <td width="110" align="center" class=title>�����븮��</td>
                    <td width="160" class=b>&nbsp;
					<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
				</tr>
                <tr> 
                    <td width="100" align="center" class=title>���������</td>
                    <td width="160" class=b>&nbsp;
					<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>    
                    <td width="100"  class=title align="center">���������</td>
                    <td width="160"  class=b>&nbsp;
					<%=c_db.getNameById(base.getMng_id(),"USER")%> </td>
                
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
        <td class=h><label><i class="fa fa-check-circle"></i> �⺻���� </label></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width='15%' class='title'>������</td>
                    <td width='30%' align='left'>&nbsp; 
						<% if(client.getClient_st().equals("1")){%>����
						<% }else if(client.getClient_st().equals("2")){%>����
						<% }else if(client.getClient_st().equals("3")){%>���λ����(�Ϲݰ���)
						<% }else if(client.getClient_st().equals("4")){%>���λ����(���̰���)
						<% }else if(client.getClient_st().equals("5")){%>���λ����(�鼼�����)
						<% }%></td>
                    <td width='15%' class='title'>��ȣ</td>
                    <td width='30%' align='left'>&nbsp;
					<%=client.getFirm_nm()%></td>
				</tr>
                <tr> 
                    <td width='100' class='title'>��ǥ��</td>
                    <td align='left'>&nbsp; <%=client.getClient_nm()%></td>
                    <td width="110" class='title'>����ڹ�ȣ</td>                    
                    <td width="180" align='left'>&nbsp;
					<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
				</tr>
                <tr> 
                    <td width="100" class='title'>�������</td>
                    <td width="180" align='left'>&nbsp;
					<%=client.getSsn1()%>-<%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%>******</td>
                    <td width='100' class='title'>Homepage</td>
                    <td align='left'>&nbsp; 
                      <%if(!client.getHomepage().equals("") && client.getHomepage().length() > 7){%>
                      <a href="<%=client.getHomepage()%>" target="_bank"> 
                      <%=client.getHomepage()%>
                      </a> 
                      <%}else{%>
                      <%=client.getHomepage()%>
                      <%}%>
                    </td>
                </tr>
                <tr> 
                    <td width="110" class='title'>�繫����ȭ</td>
                    <td width="180" align='left'>&nbsp;
					<%= client.getO_tel()%></td>
                    <td width="100" class='title'>FAX ��ȣ</td>					
                    <td width="180" align='left'>&nbsp;
					<%= client.getFax()%>&nbsp; </td>
				</tr>
                <tr> 
                    <td class='title' width="100">���������</td>
                    <td class='left'>&nbsp;
					<%= client.getOpen_year()%></td>
                    <td width="110" class='title'>�ں���</td>
                    <td width="180" align='left'>&nbsp;
					<%if(client.getFirm_price() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price())+"�鸸��/"+client.getFirm_day());%></td>
				</tr>
                <tr> 
                    <td width="100" class='title'>������</td>
                    <td width="180">&nbsp;
					<%if(client.getFirm_price_y() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price_y())+"�鸸��/"+client.getFirm_day_y());%></td>
                    <td width="100" class='title'>���౸��</td>
                    <td>&nbsp;
						<% if(client.getPrint_st().equals("1")){%>���Ǻ�
						<% }else if(client.getPrint_st().equals("2")){%>�ŷ�ó����
						<% }else if(client.getPrint_st().equals("3")){%>��������
						<% }else if(client.getPrint_st().equals("4")){%>��������
						<% }%>
                    </td>
                </tr>
                <tr> 
                    <td width="110" class='title'>����</td>
                    <td width="180" align='left'>&nbsp;
					<%= client.getBus_cdt()%></td>
                    <td width="100" class='title'>����</td>
                    <td align='left'>&nbsp;
					<%= client.getBus_itm()%></td>
                </tr>
                <tr> 
                    <td width="110" class='title'>������ּ�</td>
                    <td colspan="3">&nbsp;
					(<%=client.getO_zip()%>) <%=client.getO_addr()%></td>
                </tr>
            </table>
        </td>
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
        <td class=h align='left'><label><i class="fa fa-check-circle"></i> <%= mgr.getMgr_st()%> </label></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="15%">�ٹ��μ�</td>
					<td width="30%" align="">&nbsp;
					<%= mgr.getMgr_dept()%></td>
                    <td class=title width="15%">����</td>
					<td width="30%" align="">&nbsp;
					<%= mgr.getMgr_nm()%></td>
				</tr>
				<tr>
                    <td class=title width="80">����</td>
					<td width="30%" align="">&nbsp;
					<%= mgr.getMgr_title()%></td>
                    <td class=title width="100">��ȭ��ȣ</td>
					<td width="30%" align="">&nbsp;
					<%= mgr.getMgr_tel()%></td>
				</tr>
				<tr>
                    <td class=title width="100">�޴���</td>
					<td width="30%" align="">&nbsp;
					<%= mgr.getMgr_m_tel()%></td>
                    <td class=title width="201">E-MAIL</td>
					<td width="30%" align="">&nbsp;
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

	<tr> 
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>                   
				<tr> 
					<td class='title' width='15%'> ������ȣ </td>
					<td width="30%">&nbsp;
					<%=car_fee.get("CAR_NO")%></td>
					<td class='title' width='15%'> �ڵ���ȸ�� </td>
					<td width="30%">&nbsp;
					<%=mst.getCar_comp_nm()%></td>
				</tr>
				<tr>
					<td class='title' width="100">����</td>
					<td width="180">&nbsp;
					<%=mst.getCar_nm()%></td>
					<td class='title' width='100'>����</td>
					<td>&nbsp;
					<%=mst.getCar_name()%></td>
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
        <td class=h><label><i class="fa fa-check-circle"></i> ����� </label><font color=red>   *** ������ �ִ� ��츸 �ݴ���Դϴ�.</font> </td>
    </tr>    
     <tr>
		<td class=line2 colspan=2></td>
	</tr> 
	
      <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=15%>����</td>
                    <td width=30%>&nbsp; 
                      <%if(a_bean.getDam_type1().equals("Y")){%><b><font color='#990000'>����</font></b><%}else{%>����<%}%>
                    </td>
                    <td class=title width=15%>�빰</td>
                    <td width=30%>&nbsp;
					  <%if(a_bean.getDam_type2().equals("Y")){%><b><font color='#990000'>����</font></b><%}else{%>����<%}%>
                    </td>
				</tr>
				<tr>
					<td class=title width=10%>�ڼ�</td>
                    <td width=15%>&nbsp; 
                      <%if(a_bean.getDam_type3().equals("Y")){%><b><font color='#990000'>����</font></b><%}else{%>����<%}%>
                    </td>
					<td class=title width=10%>����</td>
                    <td width=15%>&nbsp; 
                      <%if(a_bean.getDam_type4().equals("Y")){%><b><font color='#990000'>����</font></b><%}else{%>����<%}%>
                    </td>										
                </tr>
                <tr> 
                    <td class=title width=15%>������ȣ</td>
                    <td width=30%>&nbsp; 
                      <%=c_id%>-<%=accid_id%>
                    </td>
                    <td class=title width=15%>�������</td>
                    <td width=30%>&nbsp;
						<%if(a_bean.getAccid_st().equals("1")){%>����<%}%>
						<%if(a_bean.getAccid_st().equals("2")){%>����<%}%>
						<%if(a_bean.getAccid_st().equals("3")){%>�ֹ�<%}%>
						<%if(a_bean.getAccid_st().equals("5")){%>�������<%}%>
						<%if(a_bean.getAccid_st().equals("4")){%>��������<%}%>
						<%if(a_bean.getAccid_st().equals("6")){%>����<%}%>
						<%if(a_bean.getAccid_st().equals("7")){%>�縮������<%}%>
						<%if(a_bean.getAccid_st().equals("8")){%>�ܵ�<%}%>
                    </td>
				</tr>
				<tr>
					<td class=title width=10%>�߻��Ͻ�</td>
                    <td width=15%>&nbsp;
					<%=AddUtil.ChangeDate3(a_bean.getAccid_dt())%>
                    </td>
					<td class=title width=10%>�����Ͻ�</td>
                    <td width=15%>&nbsp;
					<%=AddUtil.ChangeDate2(a_bean.getReg_dt())%>
                    </td>										
                </tr>
                <tr>
                  <td class=title width=15%>������</td>
                  <td colspan="3">&nbsp;
				    <%if(a_bean.getAccid_type_sub().equals("1")){%>[���Ϸ�]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("2")){%>[������]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("3")){%>[ö��ǳθ�]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("4")){%>[Ŀ���]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("5")){%>[����]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("6")){%>[������]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("7")){%>[����]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("8")){%>[��Ÿ]<%}%>
					<%if(!a_bean.getAccid_type_sub().equals("")){%>&nbsp;<%}%>
                    <%=a_bean.getAccid_addr()%></td>
                </tr>
                <tr>
                  <td class=title width=15%>������</td>
                  <td colspan="3">&nbsp;
				    <%=a_bean.getAccid_cont()%>
					<%if(!a_bean.getAccid_cont2().equals("") && !a_bean.getAccid_cont().equals(a_bean.getAccid_cont2())){%>
					<br>&nbsp;
					<%=a_bean.getAccid_cont2()%>
					<%}%>
				  </td>
               </tr>
               <tr>
					<td class=title width=15%>Ư�̻���</td>
					<td colspan="3">&nbsp;
					<%=a_bean.getSub_etc()%></td>
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
        <td class=h><label><i class="fa fa-check-circle"></i> ��������̷� </label></td>
    </tr>
	<%	int tot_sv_amt = 0;
		int tot_sv_req_amt = 0;
		int tot_sv_pay_amt = 0;
		for(int i=0; i<s_r.length; i++){
			s_bean2 = s_r[i];
			if(!s_bean2.getNo_dft_yn().equals("Y")){
				tot_sv_amt 		+= s_bean2.getTot_amt();
			}
			tot_sv_req_amt 	+= s_bean2.getCust_amt();
			tot_sv_pay_amt 	+= s_bean2.getExt_amt();
			if(s_bean2.getDly_amt()>0){
				tot_sv_req_amt  += s_bean2.getDly_amt();
				tot_sv_pay_amt 	+= s_bean2.getDly_amt();
			}
			if(s_bean2.getCls_amt()>0){
				tot_sv_req_amt  += s_bean2.getCls_amt();
				tot_sv_pay_amt 	+= s_bean2.getCls_amt();
			}
			%>
	<tr>
		<td class=line2 colspan=2></td>
	</tr> 
     <tr> 
		<td class=line colspan="2"> 
			<table border="0" cellspacing="1" width=100%>
				<tr> 
					<td width="15%" class=title>��������</td>
					<td width="30%" align='center'><%=AddUtil.ChangeDate2(s_bean2.getServ_dt())%></td>
					<td width="15%" class=title>�����ü��</td>
					<td width="30%" align='center'><%=s_bean2.getOff_nm()%></td>
				</tr>
				<tr>
					<td width="10%" class=title>����ݾ�</td>
					<td width="30%" align='right'><%=AddUtil.parseDecimal(s_bean2.getRep_amt())%>��&nbsp;</td>
					<td width="10%" class=title>û���ݾ�</td>
					<td width="30%" align='right'><%=AddUtil.parseDecimal(s_bean2.getCust_amt())%>��&nbsp;</td>
				</tr>
				<tr>
					<td width="10%" class=title>û������</td>
					<td width="30%" align='center'><%=AddUtil.ChangeDate2(s_bean2.getCust_req_dt())%></td>
					<td width="10%" class=title>�Աݱݾ�</td>
					<td width="30%" align='right'><%=AddUtil.parseDecimal(s_bean2.getExt_amt())%>��&nbsp;</td>
				</tr>
				<tr>
					<td width="10%" class=title>�Ա�����</td>
					<td width="30%" align='center'><%=AddUtil.ChangeDate2(s_bean2.getCust_pay_dt())%></td>
					<td width="9%" class=title>���Աݾ�</td>					
					<td width="30%" align='right'><%=AddUtil.parseDecimal(s_bean2.getDly_amt())%>��&nbsp;</td><!-- //�Աݾ��� ext_amt�� �Ἥ �ӽ÷� dly_amt�� �� -->
				</tr>
				<tr>
					<td width="9%" class=title>��������ñݾ�</td>
					<td width="30%" align='right'><%=AddUtil.parseDecimal(s_bean2.getCls_amt())%>��&nbsp;</td>
					<td width="4%" class=title>��������</td>				
					<td width="30%" align='center'><span title="��������:<%=s_bean2.getNo_dft_cau()%>"><%if(s_bean2.getNo_dft_yn().equals("Y")){//��û��%>����<%}%></span></td>
				</tr>
			</table>
		</td>
	 </tr>
	<tr>
		<td class=h></td>
    </tr> 		 
     <%	}%>     
	<tr>
		<td></td>
	</tr>
</table>
</form>
</body>
</html>
