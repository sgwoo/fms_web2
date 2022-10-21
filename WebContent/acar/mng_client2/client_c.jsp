<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.client.*, acar.common.*, acar.bill_mng.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
 	
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//����ȭ��
	function go_modify()
	{
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "client_u.jsp";		
		fm.submit();
	}
	
	function view_car_mgr(rent_mng_id, rent_l_cd)
	{
		var fm = document.form1;
		fm.action='/acar/mng_client2/car_mgr_in.jsp?rent_mng_id='+rent_mng_id+'&rent_l_cd='+rent_l_cd;
		fm.target='inner2';
		fm.submit();
	}
	
	function go_to_list()
	{
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var s_kd = fm.s_kd.value;
		var t_wd = fm.t_wd.value;
		var asc = fm.asc.value;
		location='/acar/mng_client2/client_s_frame.jsp?auth_rw='+auth_rw+'&s_kd='+s_kd+'&t_wd='+t_wd+'&asc='+asc;
	}
	//����/�������
	function cl_site(client_id, firm_nm)
	{
		window.open('/acar/mng_client2/client_site_s_p.jsp?auth_rw='+document.form1.auth_rw.value+'&client_id='+client_id+'&firm_nm='+firm_nm, "CLIENT_SITE", "left=100, top=100, width=650, height=500, scrollbars=yes");
	}
	//����������̷�
	function cl_enp_h(client_id, firm_nm)
	{
		var fm = document.form1;
		window.open("about:blank", "CLIENT_ENP", "left=50, top=50, width=900, height=600, scrollbars=yes");				
		fm.action = "client_enp_p.jsp";
		fm.target = "CLIENT_ENP";
		fm.submit();
//		window.open('/acar/mng_client2/client_enp_p.jsp?auth_rw='+document.form1.auth_rw.value+'&client_id='+client_id+'&firm_nm='+firm_nm, "CLIENT_ENP", "left=100, top=100, width=900, height=500, scrollbars=yes");
	}	
	function add_site(idx, val, str){
		document.form1.t_r_site[idx] = new Option(str, val);		
	}				
	function drop_site(){
		var fm = document.form1;
		var site_len = fm.t_r_site.length;
		for(var i = 0 ; i < site_len ; i++){
			fm.t_r_site.options[site_len-(i+1)] = null;
		}
	}	
	
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "03", "01");
	
	/*�ٷΰ���*/
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	ContBaseBean base 		= a_db.getContBaseAll(m_id, l_cd);
	if(c_id.equals(""))			c_id = base.getCar_mng_id();
	if(client_id.equals(""))	client_id = base.getClient_id();
	/*�ٷΰ���*/
	
	ClientBean client = al_db.getClient(client_id);
	
	Vector c_sites = al_db.getClientSites(client_id);
	int c_site_size = c_sites.size();
	
	//�׿��� �ŷ�ó ����
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	Hashtable ven = new Hashtable();
	if(!client.getVen_code().equals("")){
		ven = neoe_db.getVendorCase(client.getVen_code());
	}
%>

<body>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='firm_nm' value='<%=client.getFirm_nm()%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ý��� > ������ > <span class=style5>�ŷ�ó����</span></span></td>
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
    	    &nbsp;&nbsp;<font color="#999999">
            <img src=/acar/images/center/arrow_ccdrj.gif align=absmiddle> : <%=c_db.getNameById(client.getReg_id(), "USER")%>&nbsp;&nbsp; <img src=/acar/images/center/arrow_ccdri.gif align=absmiddle> : 
            <%=AddUtil.ChangeDate2(client.getReg_dt())%>
    		&nbsp;&nbsp;
            <img src=/acar/images/center/arrow_cjsjj.gif align=absmiddle> : <%=c_db.getNameById(client.getUpdate_id(), "USER")%>&nbsp;&nbsp; <img src=/acar/images/center/arrow_cjsji.gif align=absmiddle> : 
            <%=AddUtil.ChangeDate2(client.getUpdate_dt())%>
            </font> 
        </td>
        <td align='right'>
            <%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
            <a href="javascript:go_modify()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify_s.gif align=absmiddle border="0"></a> 
            <%	}%>
            &nbsp;&nbsp;<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_list.gif align=absmiddle border="0"></a> 
	    </td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='12%'>������</td>
                    <td width='38%'>&nbsp; 
                      <%if(client.getClient_st().equals("1")) 		out.println("����");
                      	else if(client.getClient_st().equals("2"))  out.println("����");
                      	else if(client.getClient_st().equals("3")) 	out.println("���λ����(�Ϲݰ���)");
                      	else if(client.getClient_st().equals("4"))	out.println("���λ����(���̰���)");
                      	else if(client.getClient_st().equals("5")) 	out.println("���λ����(�鼼�����)");
        				else if(client.getClient_st().equals("6")) 	out.println("�����");%>
                    </td>
                    <td class='title' width='12%'>���������</td>
                    <td width='38%'>&nbsp;<%= client.getOpen_year()%></td>
                </tr>
                <tr> 
                    <td class='title'>��ȣ</td>
                    <td>&nbsp; 
                    <%=client.getFirm_nm()%></td>
                    <td class='title'>��ǥ��</td>
                    <td>&nbsp;<%=client.getClient_nm()%></td>
                </tr>
                <tr> 
                    <td class='title'><%if(client.getClient_st().equals("2"))%>�ֹε�Ϲ�ȣ<%else{%>�������/<br>���ι�ȣ<%}%></td>
                    <td>&nbsp;<%=client.getSsn1()%><%if(client.getClient_st().equals("1")){%>-<%=client.getSsn2()%><%}%></td>
                    <td class='title'>����ڹ�ȣ</td>
                    <td>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
                </tr>
                <tr> 
                    <td class='title'>����������</td>
                    <td colspan='3'>&nbsp; 
                      <%if(!client.getHo_addr().equals("")){%>
                      ( 
                      <%}%>
                      <%=client.getHo_zip()%> 
                      <%if(!client.getHo_addr().equals("")){%>
                      )&nbsp; 
                      <%}%>
                      <%=client.getHo_addr()%></td>
                </tr>
                <tr> 
                    <td class='title'>����� �ּ�</td>
                    <td colspan='3'>&nbsp; 
                      <%if(!client.getO_addr().equals("")){%>
                      ( 
                      <%}%>
                      <%=client.getO_zip()%> 
                      <%if(!client.getO_addr().equals("")){%>
                      )&nbsp; 
                      <%}%>
                      <%=client.getO_addr()%></td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;<%=client.getBus_cdt()%></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=client.getBus_itm()%></td>
                </tr>
		        <%if(client.getClient_st().equals("2")){%>		  
                <tr>
                    <td class='title'>�����</td>
                    <td colspan="3">&nbsp;<%=client.getCom_nm()%></td>
                </tr>
                <tr>
                    <td class='title'>�ٹ��μ�</td>
                    <td>&nbsp;<%=client.getDept()%></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=client.getTitle()%></td>
                </tr>
    		    <%}%>		  
                <tr>
                    <td class='title'>������ȭ��ȣ</td>
                    <td>&nbsp;<%=client.getH_tel()%></td>
                    <td class='title'>ȸ����ȭ��ȣ</td>
                    <td>&nbsp;<%=client.getO_tel()%>&nbsp;<%=client.getM_tel()%></td>
                </tr>
                <tr>
                    <td class='title'>�޴���</td>
                    <td>&nbsp;<%=client.getM_tel()%></td>
                    <td class='title'>FAX</td>
                    <td>&nbsp;<%=client.getFax()%></td>
                </tr>
                <tr>
                    <td class='title'>Homepage</td>
                    <td colspan="3">&nbsp;<a href='<%=client.getHomepage()%>' target='about:blank'><%=client.getHomepage()%></a></td>
                </tr>
                <tr>
                    <td class='title'>�����</td>
                    <td colspan='3'>
                        <table border="0" cellspacing="1" cellpadding="0" width='700'>
                            <tr>
                                <td width='205'>&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> �̸�: <%=client.getCon_agnt_nm()%></td>
                                <td width='165'><img src=/acar/images/center/arrow.gif align=absmiddle> �繫��: <%=client.getCon_agnt_o_tel()%></td>
                                <td width='165'><img src=/acar/images/center/arrow.gif align=absmiddle> �̵���ȭ: <%=client.getCon_agnt_m_tel()%></td>
                                <td width='165'><img src=/acar/images/center/arrow.gif align=absmiddle> FAX: <%=client.getCon_agnt_fax()%></td>
                            </tr>
                            <tr>
                                <td>&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> EMAIL: <%=client.getCon_agnt_email()%></td>
                                <td><img src=/acar/images/center/arrow.gif align=absmiddle> �ٹ��μ�: <%=client.getCon_agnt_dept()%></td>
                                <td colspan='2'><img src=/acar/images/center/arrow.gif align=absmiddle> ����: <%=client.getCon_agnt_title()%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class='title'>�̸��ϼ��Űź�</td>
                    <td colspan="3">&nbsp;<%=client.getEtax_not_cau()%></td>
                </tr>
                <tr>
                    <td class='title'>���౸��</td>
                    <td>&nbsp;
                      <%if(client.getPrint_st().equals("1")) 		out.println("���Ǻ�");
                      	else if(client.getPrint_st().equals("2"))   out.println("�ŷ�ó����");
                      	else if(client.getPrint_st().equals("3")) 	out.println("��������");
                      	else if(client.getPrint_st().equals("4"))	out.println("��������");%>
        				</td>
                    <td align="center" class='title'>�������뵵</td>
                    <td>&nbsp;<%=client.getCar_use()%></td>
                </tr>
                <tr>
                    <td class='title'>�ں���</td>
                    <td>&nbsp;
                        <%if(client.getFirm_price() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price())+"�鸸��/"+client.getFirm_day());%>
                    </td>
                    <td class='title'>������</td>
                    <td>&nbsp;
                    <%if(client.getFirm_price_y() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price_y())+"�鸸��/"+client.getFirm_day_y());%>              </td>
                </tr>
                <tr>
                    <td class='title'>�׿����ڵ�</td>
                    <td colspan='3'>&nbsp;<%if(!client.getVen_code().equals("")){%>(<%=client.getVen_code()%>)&nbsp;<%=ven.get("VEN_NAME")%><%}%></td>
                </tr>		  
                <tr>
                    <td class='title'>Ư�̻���</td>
                    <td colspan='3'>
                        <table border="0" cellspacing="1" cellpadding="4" width=650 height='40'>
                            <tr>
                                <td><%=Util.htmlBR(client.getEtc())%> </td>
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
    <tr align="center"> 
        <td colspan="2"><a href="javascript:cl_enp_h('<%=client_id%>','<%=client.getFirm_nm()%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_com_suj.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:cl_site('<%=client_id%>','<%=client.getFirm_nm()%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_com_jj.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
</table>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ฮ��Ʈ</span></td>
		<td align='right'><img src=/acar/images/center/arrow.gif align=absmiddle> �������� ��� �Ǽ� : <input type='text' name='valid_cont_cnt' class='whitenum' size='4' value='' readonly>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td colspan='2'>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
			    <tr>
            	    <td class=line2></td>
            	</tr>
				<tr>
					<td class='line'>
						<table border="0" cellspacing="1" cellpadding="0" width=100%>
							<tr>
								<td width='12%' class=title>����ȣ</td>
								<td width='10%' class=title>�����</td>
								<td width='13%' class=title>������ȣ</td>
								<td width='20%' class=title>����</td>
								<td width='21%' class=title>���Ⱓ</td>
								<td width='8%' class=title>�뿩���</td>
								<td width='8%' class=title>�������</td>
								<td width='8%' class=title>�뿩����</td>
							</tr>
						</table>
					</td>
					<td width='17'></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan='2'>
			<iframe src="/acar/mng_client2/con_s.jsp?client_id=<%=client_id%>" name="inner1" width="100%" height="130" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>
		</td>
	</tr>
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
		<td colspan='2'>
			<iframe src="about:blank" name="inner2" width="100%" height="150" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
<script language='javascript'>
<!--
	var fm = document.form1;
	
	//�ٷΰ���
	var s_fm = parent.parent.top_menu.document.form1;
	s_fm.m_id.value = fm.m_id.value;
	s_fm.l_cd.value = fm.l_cd.value;	
	s_fm.c_id.value = fm.c_id.value;
	s_fm.auth_rw.value = fm.auth_rw.value;
	s_fm.user_id.value = fm.user_id.value;
	s_fm.br_id.value = fm.br_id.value;		
	s_fm.client_id.value = fm.client_id.value;
	s_fm.accid_id.value = "";
	s_fm.serv_id.value = "";
	s_fm.seq_no.value = "";
//-->
</script>  
</body>
</html>
