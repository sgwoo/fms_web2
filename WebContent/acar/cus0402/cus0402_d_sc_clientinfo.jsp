<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.client.*, acar.common.*"%>
<jsp:useBean id="cnd" scope="session" class="acar.common.ConditionBean"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>

<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"21":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_bus = request.getParameter("s_bus")==null?"":request.getParameter("s_bus");
	String s_brch = request.getParameter("s_brch")==null?"":request.getParameter("s_brch");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	
	/*�ٷΰ���*/
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	ContBaseBean base 						= a_db.getContBaseAll(m_id, l_cd);
	if(c_id.equals(""))			c_id 		= base.getCar_mng_id();
	if(client_id.equals(""))	client_id 	= base.getClient_id();
	/*�ٷΰ���*/
	
	ClientBean client = al_db.getClient(client_id);
	
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) user_id = login.getCookieValue(request, "acar_id");
	
	Vector c_sites = al_db.getClientSites(client_id);
	int c_site_size = c_sites.size();
%>
<html>
<head><title>FMS</title>
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_modify()
	{
		var fm = document.form1;
		var client_id = fm.client_id.value;
		var auth_rw = fm.auth_rw.value;
		var s_kd = fm.s_kd.value;
		var t_wd = fm.t_wd.value;
		var asc = fm.asc.value;
		location='/acar/mng_client2/client_u.jsp?client_id='+client_id+'&auth_rw='+auth_rw+'&s_kd='+s_kd+'&t_wd='+t_wd+'&asc='+asc;
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
		location='/acar/cus0402/cus0402_s_frame.jsp';
	}
	
	function go_to_list2()
	{
		var url = "?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_bus=<%=s_bus%>&s_brch=<%=s_brch%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>";
		location='/acar/cus0401/cus0401_s_frame.jsp'+url;
	}
	
	function cl_site(client_id, firm_nm)
	{
		window.open('/acar/mng_client2/client_site_p.jsp?auth_rw='+document.form1.auth_rw.value+'&client_id='+client_id+'&firm_nm='+firm_nm, "CLIENT_MM", "left=100, top=100, width=360, height=400, scrollbars=yes");
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
function regCycle_vst(){
	var SUBWIN="./cus0402_d_sc_clienthis_reg.jsp?client_id=<%= client_id %>";
	window.open(SUBWIN, "Cycle_vstReg", "left=100, top=110, width=470, height=410, scrollbars=no");		
}	
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>

<body leftmargin=15>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������ > ���������������� > <span class=style5>�ŷ�ó����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>		
        <td align='right'><a href="javascript:<% if(cmd.equals("")){ %>go_to_list()<% }else{ %>go_to_list2()<% } %>" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif"  align="absmiddle" border="0"></a> 
        </td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>		 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=13%> ������ </td>
                    <td width=20%>&nbsp; <%if(client.getClient_st().equals("1")) 		out.println("����");
                      	else if(client.getClient_st().equals("2"))  out.println("����");
                      	else if(client.getClient_st().equals("3")) 	out.println("���λ����(�Ϲݰ���)");
                      	else if(client.getClient_st().equals("4"))	out.println("���λ����(���̰���)");
                      	else if(client.getClient_st().equals("5")) 	out.println("���λ����(�鼼�����)");%> </td>
                    <td class='title' width=13%>��ȣ</td>
                    <td width=20%>&nbsp;<%=client.getFirm_nm()%></td>
                    <td class='title' width=13%>�����</td>
                    <td width=21%>&nbsp;<%=client.getClient_nm()%></td>
                </tr>
                <tr> 
                    <td class='title' style='height:36'>�������<br>
                      (���ι�ȣ)</td>
                     <td>&nbsp;<%=client.getSsn1()%>-<%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%>*****</td>
                    <td class='title'>����ڵ�Ϲ�ȣ</td>
                    <td>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
                    <td class='title'>�������뵵</td>
                    <td>&nbsp;<%=client.getCar_use()%></td>
                </tr>
                <tr> 
                    <td class='title'>�����</td>
                    <td>&nbsp;<%=client.getCom_nm()%></td>
                    <td class='title'>�ٹ��μ�</td>
                    <td>&nbsp;<%=client.getDept()%></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=client.getTitle()%></td>
                </tr>
                <tr> 
                    <td class='title'>������ȭ��ȣ</td>
                    <td>&nbsp;<%=client.getH_tel()%></td>
                    <td class='title'>ȸ����ȭ��ȣ</td>
                    <td>&nbsp;<%=client.getO_tel()%></td>
                    <td class='title'>�޴���</td>
                    <td>&nbsp;<%=client.getM_tel()%></td>
                </tr>
                <tr> 
                    <td class='title'>FAX</td>
                    <td>&nbsp;<%=client.getFax()%></td>
                    <td class='title'>Homepage</td>
                    <td colspan='3'>&nbsp;<a href='<%=client.getHomepage()%>' target='about:blank'><%=client.getHomepage()%></a></td>
                </tr>
                <tr> 
                    <td class='title'>���������� �ּ�</td>
                    <td colspan='5'>&nbsp; <%if(!client.getHo_addr().equals("")){%>
                      ( 
                      <%}%> <%=client.getHo_zip()%> <%if(!client.getHo_addr().equals("")){%>
                      )&nbsp; <%}%> <%=client.getHo_addr()%></td>
                </tr>
                <tr> 
                    <td class='title'>����� �ּ�</td>
                    <td colspan='5'>&nbsp; <%if(!client.getO_addr().equals("")){%>
                      ( 
                      <%}%> <%=client.getO_zip()%> <%if(!client.getO_addr().equals("")){%>
                      )&nbsp; <%}%> <%=client.getO_addr()%></td>
                </tr>
    		  <%if(c_site_size>0){%>
                <tr> 
                    <td class='title'>��뺻����</td>
                    <td colspan='5'>&nbsp; <select name='t_r_site'>
                        <%if(c_site_size > 0){
        					for(int i = 0 ; i < c_site_size ; i++){
        						ClientSiteBean site = (ClientSiteBean)c_sites.elementAt(i);%>
                        <option value='<%=site.getSeq()%>'><%=site.getR_site()%></option>
                        <%	}
        				  }		%>
                      </select> </td>
                </tr>
    		  <%}%>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;<%=client.getBus_cdt()%></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=client.getBus_itm()%></td>
                    <td class='title'>���������</td>
                    <td>&nbsp;<%= client.getOpen_year()%></td>
                </tr>
                <tr> 
                    <td class='title'>�ں���/������</td>
                    <td>&nbsp; <%if(client.getFirm_price() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price())+"�鸸��/"+client.getFirm_day());%> </td>
                    <td class='title'>������/������</td>
                    <td colspan="3">&nbsp; <%if(client.getFirm_price_y() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price_y())+"�鸸��/"+client.getFirm_day_y());%> </td>
                </tr>
            </table>
	    </td>
	</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td align='left'><img src="/acar/images/center/icon_arrow.gif" align=absmiddle> <span class=style2>��ฮ��Ʈ</span></td>
        <td align='right'><img src="/acar/images/center/arrow.gif" align=absmiddle> �������� ��� �Ǽ� : 
        <input type='text' name='valid_cont_cnt' class='whitenum' size='4' value='' readonly>
        ��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
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
                        <!-- ����ڵ�, �����, ������ȣ, ����, ���Ⱓ, �뿩���, �뿩�Ⱓ, �뿩����, �������//-->
                            <tr> 
                              <td width='5%' class=title>����</td>
                              <td width='13%' class=title>����ȣ</td>
                              <td width='10%' class=title>�����</td>
                              <td width='12%' class=title>������ȣ</td>
                              <td width='18%' class=title>����</td>
                              <td width='18%' class=title>���Ⱓ</td>
                              <td width='8%' class=title>�뿩���</td>
                              <td width='8%' class=title>�������</td>
                              <td width=8% class=title>�뿩����</td>
                            </tr>
                        </table>
                    </td>
                    <td width=16>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan='2'> <iframe src="/acar/cus0402/cus0402_d_con_s.jsp?client_id=<%=client_id%>" name="inner1" width="100%" height="93" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe> </td>
    </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td width="100%" colspan="2" align='left'>&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2" align='left'>
            <img src="/acar/images/center/icon_arrow.gif" align=absmiddle> <span class=style2>��ȸ�湮</span></td>
    </tr>
    <tr> 
        <td colspan='2'> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width="100%">
                            <tr> 
                                <td width=5% class=title>����</td>
                                <td width=12% class=title>�湮����</td>
                                <td width=8% class=title>�湮��</td>
                                <td width=18% class=title>����</td>
                                <td width=33% class=title>�湮����</td>
                                <td width=14% class=title>�湮��������</td>
                                <td width=10% class=title>����</td>
                            </tr>
                        </table>
                    </td>
                    <td width=16>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan='2'> <iframe src="/acar/cus0402/cus0402_d_cycle_vst.jsp?client_id=<%=client_id%>" name="inner2" width="100%" height="162" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe> </td>
    </tr>
</table>    
</form>
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
