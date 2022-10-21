<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.cont.*, acar.common.*, acar.call.*, acar.util.*,acar.client.*, acar.car_mst.*, acar.user_mng.*, acar.car_office.* "%>
<%@ page import="acar.insur.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="p_db" scope="page" class="acar.call.PollDatabase"/>
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
		
	//����Ÿ����		2018.03.21
	ContEtcBean cont_etc = a_db.getContEtc(m_id, l_cd);
	
	//������
	ClientBean client 		= al_db.getClient(base.getClient_id());

	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();		// 2018.03.21
	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();	// 2018.05.21
	
	
	//cont call  reg_id
	String reg_id 	= "";
	reg_id = p_db.getCallReg_id(m_id, l_cd);	
	
	if ( reg_id.equals("")) {
		reg_id = user_id;
	}
 	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+
					"&rent_mng_id="+m_id+"&rent_l_cd="+l_cd;
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
			
		t_fm.t_con_cd.value 		= fm.t_con_cd.value;
		t_fm.t_rent_dt.value 		= fm.t_rent_dt.value;
		t_fm.s_rent_st.value 		= fm.s_rent_st.value;
		t_fm.s_car_st.value 		= fm.s_car_st.value;
		t_fm.h_brch.value 			= fm.h_brch.value;
	//	t_fm.s_bus_id.value 		= fm.s_bus_id.value;		
		t_fm.s_dept_id.value 		= fm.s_dept_id.value;		
		t_fm.s_rent_way.value 		= fm.s_rent_way.value;
		t_fm.s_bus_st.value 		= fm.s_bus_st.value;
		t_fm.t_con_mon.value 		= fm.t_con_mon.value;
		t_fm.t_rent_start_dt.value 	= fm.t_rent_start_dt.value;
		t_fm.t_rent_end_dt.value 	= fm.t_rent_end_dt.value;
		t_fm.use_yn.value 			= fm.use_yn.value;
	//	t_fm.s_bus_id2.value		= fm.s_bus_id2.value;			
	//	t_fm.s_mng_id.value 		= fm.s_mng_id.value;
	//	t_fm.s_mng_id2.value 		= fm.s_mng_id2.value;				
	}


	//�����ϱ�
	function update()
	{
		var fm = document.form1;	
		save();			
		parent.c_foot.save();
		
	}	
	
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
			parent.location='/acar/call/rent_cond_frame.jsp?auth_rw='+auth+'&s_kd='+s_kd+'&brch_id='+brch_id+'&s_bank='+s_bank+'&t_wd='+t_wd+'&cont_st='+cont_st;
		} else { 
			          
			parent.location='/acar/call/call_cond_frame.jsp?auth_rw='+auth+'&s_kd='+s_kd+'&brch_id='+brch_id+'&s_bank='+s_bank+'&t_wd='+t_wd+'&cont_st='+cont_st;
			
		}
	}		

	
function update(st){
	
			var height = 350;			
			window.open("call_mgr_u.jsp<%=valus%>&cng_item="+st+"&rent_st=1", "CHANGE_ITEM", "left=50, top=50, width=1050, height="+height+", scrollbars=yes");
	
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
                    <td  width="30%" class=b>&nbsp;<%=base.getRent_l_cd()%></td>
                    <td class=title width="15%">�������</td>
                    <td  width="30%" class=b>&nbsp;<%=base.getRent_dt()%></td>
				</tr>
				<tr>
                    <td class=title width="15%">��౸��</td>
                    <td  width="30%" class=b>&nbsp; 
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
                    <td class=title  width="10%">�뿩����</td>
                    <td  width="30%" class=b>&nbsp;
						<select name="s_car_st" onChange='javascript:set_con_cd()' disabled >
							<%if(base.getCar_st().equals("1") || base.getCar_st().equals("3")){%>
							<option value="1" <%if(base.getCar_st().equals("1")){%>selected<%}%>>��Ʈ</option>
							<option value="3" <%if(base.getCar_st().equals("3")){%>selected<%}%>>����</option>
							<%}else if(base.getCar_st().equals("2")){%>
							<option value="2" <%if(base.getCar_st().equals("2")){%>selected<%}%>>����</option>
							<%}%>
						</select>
					</td>
				</tr>
                <tr>
                    <td width="10%" class=title>�뿩���</td>
                    <td  width="30%" class=b>&nbsp;
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
                    <td  width="10%" class=title>��������</td>
                    <td class=b  width="30%">&nbsp;
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
                    <td width="10%" class=title>�뿩����</td>
                    <td width="30%" class=b>&nbsp;<%=base.getCon_mon()%>���� </td>
                    <td width="10%" class=title>�뿩�Ⱓ</td>
                    <td class=b align="center" width="30%">&nbsp;<%=base.getRent_start_dt()%>
					~
					<%=base.getRent_end_dt()%></td>
                </tr>
                <tr> 
                    <td width="10%" class=title>���ʿ�����</td>
                    <td width="30%" class=b>&nbsp; <%=c_db.getNameById(base.getBus_id(),"USER")%> <br/>
                    	<%if(!base.getAgent_emp_id().equals("")){ CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id()); %>&nbsp;(�����������:<%=a_coe_bean.getEmp_nm()%>&nbsp;<%=a_coe_bean.getEmp_m_tel()%>)<%}%>
                    </td>
                    <td width="10%" class=title>�����븮��</td>
                    <td width="30%" class=b>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
				</tr>
                <tr>
                    <td width="10%" class=title>���������</td>
                    <td width="30%" class=b>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>    
                    </td>
                    <td width="10%" class=title>���������</td>
                    <td width="30%" class=b>&nbsp;<%=c_db.getNameById(base.getMng_id(),"USER")%></td>
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
                    <td width="30%" align='left'>&nbsp;
                        			<% if(client.getClient_st().equals("1")){%>����
        							<% }else if(client.getClient_st().equals("2")){%>����
        							<% }else if(client.getClient_st().equals("3")){%>���λ����(�Ϲݰ���)
        							<% }else if(client.getClient_st().equals("4")){%>���λ����(���̰���)
        							<% }else if(client.getClient_st().equals("5")){%>���λ����(�鼼�����)
        							<% }%></td>
                    <td width='15%' class='title'>��ȣ</td>
                    <td width='30%' align='left'>&nbsp;<%=client.getFirm_nm()%></td>
				</tr>
                <tr> 
                    <td width='10%' class='title'>��ǥ��</td>
                    <td width="30%">&nbsp;<%=client.getClient_nm()%></td>
                
                    <td width="10%" class='title'>����ڹ�ȣ</td>
                    <td width="30%" align='left'>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
				</tr>
                <tr> 
                    <td width="10%" class='title'>�������</td>
					<td width="30%" align='left'>&nbsp;<%=client.getSsn1()%>-*******</td>
                    <td width='10%' class='title'>Homepage</td>
                    <td width="30%" align='left'>&nbsp; 
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
                    <td width="10%" class='title'>�繫����ȭ</td>
                    <td width="30%" align='left'>&nbsp;<%= client.getO_tel()%></td>
                    <td width="10%" class='title'>FAX ��ȣ</td>
                    <td width="30%" align='left'>&nbsp;<%= client.getFax()%></td>
				</tr>
                <tr> 
                    <td class='title' width="10%">���������</td>
                    <td width="30%">&nbsp;<%= client.getOpen_year()%></td>
                    <td width="10%" class='title'>�ں���</td>
                    <td width="30%" align='left'>&nbsp;<%if(client.getFirm_price() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price())+"�鸸��/"+client.getFirm_day());%></td>
				</tr>
                <tr> 
                    <td width="10%" class='title'>������</td>
                    <td width="30%">&nbsp;<%if(client.getFirm_price_y() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price_y())+"�鸸��/"+client.getFirm_day_y());%></td>
                    <td width="10%" class='title'>���౸��</td>
                    <td width="30%">&nbsp;
						<% if(client.getPrint_st().equals("1")){%>���Ǻ�
						<% }else if(client.getPrint_st().equals("2")){%>�ŷ�ó����
						<% }else if(client.getPrint_st().equals("3")){%>��������
						<% }else if(client.getPrint_st().equals("4")){%>��������
						<% }%>
                    </td>
                </tr>
                <tr> 
                    <td width="10%" class='title'>����</td>
                    <td width="30%"align='left'>&nbsp;<%= client.getBus_cdt()%></td>
                    <td width="10%" class='title'>����</td>
                    <td align='left'  width="30%">&nbsp;<%= client.getBus_itm()%></td>
                </tr>
                <tr> 
                    <td width="10%" class='title'>������ּ�</td>
                    <td colspan="3"  width="30%">&nbsp; (<%=client.getO_zip()%>)&nbsp; <%=client.getO_addr()%> </td>
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
        <td class=h><input type="button" class="button button4" value="�����ڼ���" onclick="update('mgr');"/></td>
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
        <td class=h><label><i class="fa fa-check-circle"></i> <%=mgr.getMgr_st()%> </label></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr> 
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr> 
					<td class=title width="15%">����</td>
					<td width="30%">&nbsp;<%= mgr.getMgr_nm()%></td>
					<td class=title width="15%">�ٹ��μ�</td>
					<td width="30%">&nbsp;<%= mgr.getMgr_dept()%></td>
				</tr>
                <tr> 	
                    <td class=title width="15%">����</td>
					<td width="30%">&nbsp;<%= mgr.getMgr_title()%></td>
				
                    <td class=title width="15%">��ȭ��ȣ</td>
					<td width="30%">&nbsp;<%= mgr.getMgr_tel()%></td>
				</tr>
                <tr>                 
					<td class=title width="15%">�޴���</td>
					<td width="30%">&nbsp;<%= mgr.getMgr_m_tel()%></td>
                    <td class=title width="15%">E-MAIL</td>
					<td width="30%">&nbsp;<%= mgr.getMgr_email()%></td>
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
        <td class=h><label><i class="fa fa-check-circle"></i> �������</label></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
               
                  <%//���޼�����:�����һ��
        			Hashtable mgrs 		= a_db.getCommiNInfo(m_id, l_cd);
        			Hashtable mgr_bus 	= (Hashtable)mgrs.get("BUS");
        			Hashtable mgr_dlv 	= (Hashtable)mgrs.get("DLV");%>
				 <tr> 
                    <td class=title width="15%">��ȣ</td>
					<td width="30%">&nbsp;<%if(mgr_bus.get("COM_NM") != null)%><%=mgr_bus.get("COM_NM")%></td>
                    <td class=title width="15%">������</td>
					<td width="30%">&nbsp;<%if(mgr_bus.get("CAR_OFF_ST") != null && mgr_bus.get("CAR_OFF_ST").equals("1") && mgr_bus.get("CAR_OFF_NM") != null)%><%=mgr_bus.get("CAR_OFF_NM")%></td>
				</tr>
				<tr>
                    <td class=title width="10%">�����Ҹ�</td>
					<td width="30%">&nbsp;<%if(mgr_bus.get("CAR_OFF_ST") != null && !mgr_bus.get("CAR_OFF_ST").equals("1") && mgr_bus.get("CAR_OFF_NM") != null)%><%=mgr_bus.get("CAR_OFF_NM")%></td>
                    <td class=title width="10%">����</td>
					<td width="30%">&nbsp;<%if(mgr_bus.get("NM") != null)%><%=mgr_bus.get("NM")%></td>
				</tr>
				<tr>
                    <td class=title width="10%">����</td>
					<td width="30%">&nbsp;<%if(mgr_bus.get("POS") != null)%><%=mgr_bus.get("POS")%></td>
                    <td class=title width="10%">��ȭ��ȣ</td>
					<td width="30%">&nbsp;<%if(mgr_bus.get("O_TEL") != null)%><%=mgr_bus.get("O_TEL")%></td>
				</tr>
				<tr>
                    <td class=title width="10%">�޴���</td>
					<td width="30%">&nbsp;<%if(mgr_bus.get("TEL") != null)%><%=mgr_bus.get("TEL")%></td>
                    <td class=title>�̸���</td>
					<td width="30%">&nbsp;<%if(mgr_bus.get("EMP_EMAIL") != null)%><%=mgr_bus.get("EMP_EMAIL")%></td>
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
        <td class=h><label><i class="fa fa-check-circle"></i> �����</label></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
				 <tr> 
                    <td class=title width="15%">��ȣ</td>
					<td width="30%">&nbsp;<%if(mgr_dlv.get("COM_NM") != null)%><%=mgr_dlv.get("COM_NM")%></td>
                    <td class=title width="15%">������</td>
					<td width="30%">&nbsp;<%if(mgr_dlv.get("CAR_OFF_ST") != null && mgr_dlv.get("CAR_OFF_ST").equals("1") && mgr_dlv.get("CAR_OFF_NM") != null)%><%=mgr_dlv.get("CAR_OFF_NM")%></td>
				</tr>
				<tr>
                    <td class=title width="15%">�����Ҹ�</td>
					<td width="30%">&nbsp;<%if(mgr_dlv.get("CAR_OFF_ST") != null && !mgr_dlv.get("CAR_OFF_ST").equals("1") && mgr_dlv.get("CAR_OFF_NM") != null)%><%=mgr_dlv.get("CAR_OFF_NM")%></td>
                    <td class=title width="15%">����</td>
					<td width="30%">&nbsp;<%if(mgr_dlv.get("NM") != null)%><%=mgr_dlv.get("NM")%></td>
				</tr>
				<tr>
                    <td class=title width="10%">����</td>
					<td width="30%">&nbsp;<%if(mgr_dlv.get("POS") != null)%><%=mgr_dlv.get("POS")%></td>
                    <td class=title width="15%">��ȭ��ȣ</td>
					<td width="30%">&nbsp;<%if(mgr_dlv.get("O_TEL") != null)%><%=mgr_dlv.get("O_TEL")%></td>
				</tr>
				<tr>
                    <td class=title width="15%">�޴���</td>
					<td width="30%">&nbsp;<%if(mgr_dlv.get("TEL") != null)%><%=mgr_dlv.get("TEL")%></td>
                    <td class=title width="15%">�̸���</td>
					<td width="30%">&nbsp;<%if(mgr_dlv.get("EMP_EMAIL") != null)%><%=mgr_dlv.get("EMP_EMAIL")%></td>
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
					<td width="30%">&nbsp;<%=car_fee.get("CAR_NO")%></td>
					<td class='title' width='15%'> �ڵ���ȸ�� </td>
					<td width="30%">&nbsp;<%=mst.getCar_comp_nm()%></td>
				</tr>
				<tr>
					<td class='title' width="15%">����</td>
					<td width="30%">&nbsp;<%=mst.getCar_nm()%></td>
					<td class='title' width='15%'>����</td>
					<td width="30%">&nbsp;<%=mst.getCar_name()%></td>
				</tr>                                                        
			</table>
		</td>
	</tr>
	<tr><!-- 2018.03.20 -->
        <td class=h></td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h><label><i class="fa fa-check-circle"></i> ������� </label></td>
    </tr>
    <%	
		
	%>
    <tr>
        <td class=line2></td>
    </tr>
	<tr> 
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>      
			<%	//�����̷�-�Ϲݺ���
				String ins_com_nm = "";
				if(true){
					Vector inss2 = ai_db.getInsHisList1(base.getCar_mng_id());
					int ins_size2 = inss2.size();
					//System.out.println("ins_size2 : " + ins_size2);
					if(ins_size2 > 0){
						for(int i=0; i<ins_size2; i++){
							Hashtable ins2 = (Hashtable)inss2.elementAt(i);
							//System.out.println(" i : " + i);
							if(i<ins_size2-1) {
								continue;
							}
							ins_com_nm = (String)ins2.get("INS_COM_NM");
							
						}
					}
				}
			%>             
				<tr> 
					<td class='title' width='15%'> ������ </td>
					<td width="30%">&nbsp;<%=ins_com_nm%></td>
					<td class='title' width='15%' style="font-size:100%;"><b>�Ǻ�����</b></td><!-- ���� ũ�� ���� / ��ä�� ����� ���û��� 2018.03.30 -->
					<td width="30%">&nbsp;<font style="font-size:130%;"><b><%String insur_per = cont_etc.getInsur_per();%><%if(insur_per.equals("1") || insur_per.equals("")){%>�Ƹ���ī<%}else if(insur_per.equals("2")){%>��<%}%></b></font></td>
				</tr>
				<tr>
					<td class='title' width="15%">���ι��</td>
					<td width="30%">&nbsp;����(���ι��,��)</td>
					<td class='title' width='15%'><!-- �������� --></td><!-- ���� ��༭ ���� / ��ä�� ����� ���û��� 2018.03.30 -->
					<td width="30%">&nbsp;<%-- <%String insurant = cont_etc.getInsurant();%><%if(insurant.equals("1") || insurant.equals("")){%>�Ƹ���ī<%}else if(insurant.equals("2")){%>��<%}%> --%></td>
				</tr>
				<tr>
					<td class='title' width="15%">�빰���</td>
					<td width="30%">&nbsp;<%String gcp_kd = base.getGcp_kd();%><%if(gcp_kd.equals("1")){%>5õ����<%}else if(gcp_kd.equals("2")){%>1���<%}else if(gcp_kd.equals("3")){%>5���<%}else if(gcp_kd.equals("4")){%>2���<%}else if(gcp_kd.equals("8")){%>3���<%}%></td>
					<td class='title' width='15%'>�����ڿ���</td>
					<td width="30%">&nbsp;<%String driving_age = base.getDriving_age();%><%if(driving_age.equals("0")){%>26���̻�<%}
                    	else if(driving_age.equals("3")){%>24���̻�<%}
                    	else if(driving_age.equals("1")){%>21���̻�<%}
                    	else if(driving_age.equals("5")){%>30���̻�<%}
                    	else if(driving_age.equals("6")){%>35���̻�<%}
                    	else if(driving_age.equals("7")){%>43���̻�<%}
                    	else if(driving_age.equals("8")){%>48���̻�<%}
                    	else if(driving_age.equals("9")){%>22���̻�<%}
                    	else if(driving_age.equals("10")){%>28���̻�<%}
                    	else if(driving_age.equals("11")){%>35���̻�~49������<%}
                    	else if(driving_age.equals("2")){%>��������<%}%></td>
				</tr>
				<tr>
					<td class='title' width="15%">�ڱ��ü���</td>
					<td width="30%">&nbsp;<%String bacdt_kd = base.getBacdt_kd();%><%if(bacdt_kd.equals("1")){%>5õ����<%}else if(bacdt_kd.equals("2")){%>1���<%}else if(bacdt_kd.equals("9")){%>�̰���<%}%></td>
					<td class='title' width='15%' style="letter-spacing:-0.5px;">��������������Ư��</td>
					<td width="30%">&nbsp;<%String com_emp_yn = cont_etc.getCom_emp_yn();%><%if(com_emp_yn.equals("Y")){%>����<%}else if(!com_emp_yn.equals("Y")){%>�̰���<%}%></td>
				</tr>
				<tr>
					<td class='title' width="15%">������������</td>
					<td width="30%">&nbsp;<%String canoisr_yn = cont_etc.getCanoisr_yn();%><%if(canoisr_yn.equals("Y")){%>����<%}else if(canoisr_yn.equals("N")){%>�̰���<%}%></td>
					<td class='title' width='15%'></td>
					<td width="30%"></td>
				</tr>
				<tr>
					<td class='title' width="15%">�������ظ�å��<br>(�ڱ�δ��)</td>
					<td width="30%" colspan="3">&nbsp;<%if(insur_per.equals("1")||insur_per.equals("")){
						%>���Ǵ� <%=AddUtil.parseDecimal(base.getCar_ja())%>�� (�ڱ����� ���ش� ����翡 �������� �ʰ�, �Ƹ���ī �ڱ��������� ��å������ �ǰ� ����)<%}else{
						%>��������������� : <%=cont_etc.getCacdt_mebase_amt()%>����
							  &nbsp;&nbsp;&nbsp;�ּ��ڱ�δ�� : <%=cont_etc.getCacdt_memin_amt()%>���� 
							  &nbsp;&nbsp;&nbsp;�ִ��ڱ�δ�� : <%=cont_etc.getCacdt_me_amt()%>����<%}%></td>
				</tr>
			</table>
		</td>
	</tr>
	<%if(insur_per.equals("1") || insur_per.equals("")){%>
	<tr><td style="height:5px;"></td></tr>
	<tr>
		<td>
			�� �ڱ��������� ��å ������ ���� ���Ƿ� ���� ��������, ���� ������ �ڱ��������� ��å��(�ڱ�δ��)�� �ڵ��� �뿩ȸ�翡 �����ϰ�, 
			�߻��� �ڱ��������ؿ� ���Ͽ� ��å�Ǵ� �����Դϴ�. (�Ƹ���ī�� �ش� ������ ���պ����� ������ ������� ����� ���Ͽ� �ڱ��������� ��å ���� �)
		</td>
	</tr>
	<%}%>
   	<tr>
        <td></td>
    </tr>
</table>
</form>
</body>
</html>
