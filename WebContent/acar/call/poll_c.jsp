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
		window.open("about:blank", "CLIENT_ENP", "left=50, top=50, width=900, height=500, scrollbars=yes");				
		fm.action = "client_enp_p.jsp";
		fm.target = "CLIENT_ENP";
		fm.submit();
//		window.open('/acar/mng_client2/client_enp_p.jsp?auth_rw='+document.form1.auth_rw.value+'&client_id='+client_id+'&firm_nm='+firm_nm, "CLIENT_ENP", "left=100, top=100, width=900, height=500, scrollbars=yes");
	}	
	function add_site(idx, val, str){
		document.form1.t_r_site[idx] = new Option(str, val);		
	}				

-->
</script>
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	int poll_id = request.getParameter("poll_id")==null?"0":request.getParameter("poll_id");
	
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
      <td colspan="2"> <font color="navy">�������� -> </font><font color="navy">�ŷ�ó
        ���� </font>-> <font color="red">�ŷ�ó ����</font> </td>
    </tr>
    <tr> 
      <td>
	  <font color="#999999">
        �� ���ʵ���� : <%=c_db.getNameById(client.getReg_id(), "USER")%>&nbsp;&nbsp; �� ���ʵ���� : 
        <%=AddUtil.ChangeDate2(client.getReg_dt())%>
		&nbsp;&nbsp;
        �� ���������� : <%=c_db.getNameById(client.getUpdate_id(), "USER")%>&nbsp;&nbsp; �� ���������� : 
        <%=AddUtil.ChangeDate2(client.getUpdate_dt())%>
        </font> 
      </td>
      <td align='right'>
        <%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:go_modify()" onMouseOver="window.status=''; return true"><img src="/images/up_info.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
        <%	}%>
        &nbsp;&nbsp;<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
	  </td>
    </tr>
    <tr> 
      <td colspan="2" class='line'> <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width='100'> ������ </td>
            <td width='300'>&nbsp; 
              <%if(client.getClient_st().equals("1")) 		out.println("����");
              	else if(client.getClient_st().equals("2"))  out.println("����");
              	else if(client.getClient_st().equals("3")) 	out.println("���λ����(�Ϲݰ���)");
              	else if(client.getClient_st().equals("4"))	out.println("���λ����(���̰���)");
              	else if(client.getClient_st().equals("5")) 	out.println("���λ����(�鼼�����)");%>
            </td>
            <td class='title' width='100'>���������</td>
            <td width='307'>&nbsp;<%= client.getOpen_year()%></td>
          </tr>
          <tr> 
            <td class='title' width='85'> ��ȣ</td>
            <td width='160'>&nbsp; 
            <%=client.getFirm_nm()%>            </td>
            <td class='title'>��ǥ��</td>
            <td>&nbsp;<%=client.getClient_nm()%></td>
          </tr>
          <tr> 
            <td class='title'>�ֹ�(����)��ȣ</td>
            <td>&nbsp;<%=client.getSsn1()%>-<%=client.getSsn2()%></td>
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
            <td width="100" class='title'>�����</td>
            <td colspan="3">&nbsp;<%=client.getCom_nm()%></td>
          </tr>
          <tr>
            <td class='title'>�ٹ��μ�</td>
            <td width="300">&nbsp;<%=client.getDept()%></td>
            <td width="100" class='title'>����</td>
            <td width="307">&nbsp;<%=client.getTitle()%></td>
          </tr>
		  <%}%>		  
          <tr>
            <td width="100" class='title'>������ȭ��ȣ</td>
            <td width="300">&nbsp;<%=client.getH_tel()%></td>
            <td width="100" class='title'>ȸ����ȭ��ȣ</td>
            <td width="307">&nbsp;<%=client.getO_tel()%>&nbsp;<%=client.getM_tel()%></td>
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
            <td colspan='3'><table border="0" cellspacing="1" cellpadding="0" width='650'>
                <tr>
                  <td width='155'>&nbsp;�̸�:<%=client.getCon_agnt_nm()%></td>
                  <td width='150'>�繫��:<%=client.getCon_agnt_o_tel()%></td>
                  <td width='150'>�̵���ȭ:<%=client.getCon_agnt_m_tel()%></td>
                  <td width='150'>FAX:<%=client.getCon_agnt_fax()%></td>
                </tr>
                <tr>
                  <td>&nbsp;EMAIL:<%=client.getCon_agnt_email()%></td>
                  <td>�ٹ��μ�:<%=client.getCon_agnt_dept()%></td>
                  <td colspan='2'>����:<%=client.getCon_agnt_title()%></td>
                </tr>
            </table></td>
          </tr>
          <tr>
            <td class='title'>�̸��ϼ��Űź�</td>
            <td colspan="3">&nbsp;<%=client.getEtax_not_cau()%></td>
          </tr>
          <tr>
            <td width="100" class='title'>���౸��</td>
            <td width="300">&nbsp;
              <%if(client.getPrint_st().equals("1")) 		out.println("���Ǻ�");
              	else if(client.getPrint_st().equals("2"))   out.println("�ŷ�ó����");
              	else if(client.getPrint_st().equals("3")) 	out.println("��������");
              	else if(client.getPrint_st().equals("4"))	out.println("��������");%>
				</td>
            <td width="100" align="center" class='title'>�������뵵</td>
            <td width="307">&nbsp;<%=client.getCar_use()%></td>
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
            <td class='title'> Ư�̻��� </td>
            <td colspan='3'><table border="0" cellspacing="1" cellpadding="4" width=650 height='40'>
                <tr>
                  <td><%=Util.htmlBR(client.getEtc())%> </td>
                </tr>
            </table></td>
          </tr>
        </table></td>
    </tr>
    <tr align="center"> 
      <td colspan="2">| <a href="javascript:cl_enp_h('<%=client_id%>','<%=client.getFirm_nm()%>')" onMouseOver="window.status=''; return true">��������� ����</a> | <a href="javascript:cl_site('<%=client_id%>','<%=client.getFirm_nm()%>')" onMouseOver="window.status=''; return true">����/���� ����</a> | </td>
    </tr>	
  </table>

	<tr>
		<td colspan='2'>
			<iframe src="/acar/mng_client2/con_s.jsp?client_id=<%=client_id%>" name="inner1" width="100%" height="130" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>
		</td>
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

</body>
</html>
