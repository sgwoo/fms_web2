<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*, acar.bill_mng.*" %>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String car_off_id = "";					//������ID
    String car_comp_id = "";				//�ڵ���ȸ��ID
    String car_comp_nm = "";				//�ڵ���ȸ���̸�
    String car_off_nm = "";					//�����Ҹ�
    String car_off_st = "";					//�����ұ���
    String owner_nm = "";					//��������
    String car_off_tel = "";				//�繫����ȭ
    String car_off_fax = "";				//�ѽ�
    String car_off_post = "";				//�����ȣ
    String car_off_addr = "";				//�ּ�
    String bank = "";						//���°�������
    String acc_no = "";						//���¹�ȣ
    String acc_nm = "";						//������
    String ven_code = "";					//�׿����ŷ�ó�ڵ�
    String manager = "";					//����
	String agnt_nm = "";					//���ǹ���
    String agnt_m_tel = "";					//���ǹ�����ȭ
    String agnt_email = "";					//���ݰ�꼭���Ÿ���
	
    String cmd = "";
    String enp_no = "";
	int count = 0;
	
	if(request.getParameter("cmd") != null)
	{
		cmd = request.getParameter("cmd"); //update, inpsert ����
	}
	if(request.getParameter("car_off_id")!=null)
	{
		car_off_id = request.getParameter("car_off_id");
		
		co_bean = cod.getCarOffBean(car_off_id);
		
		car_off_id 		= co_bean.getCar_off_id();
		car_comp_id 	= co_bean.getCar_comp_id();
		car_comp_nm 	= co_bean.getCar_comp_nm();
		car_off_nm 		= co_bean.getCar_off_nm();
		car_off_st 		= co_bean.getCar_off_st();
		owner_nm 		= co_bean.getOwner_nm();
		car_off_tel 	= co_bean.getCar_off_tel();
		car_off_fax 	= co_bean.getCar_off_fax();
		car_off_post 	= co_bean.getCar_off_post();
		car_off_addr 	= co_bean.getCar_off_addr();
		bank 			= co_bean.getBank();
		acc_no 			= co_bean.getAcc_no();
		acc_nm 			= co_bean.getAcc_nm();
		ven_code 		= co_bean.getVen_code();
		manager 		= co_bean.getManager();
		agnt_nm 		= co_bean.getAgnt_nm();
		agnt_m_tel 		= co_bean.getAgnt_m_tel();
		enp_no 			= co_bean.getEnp_no();
		agnt_email 		= co_bean.getAgnt_email();
	}
	
	CarCompBean cc_r [] = cod.getCarCompAll();
	CodeBean cd_r [] = c_db.getCodeAll("0003");	//������� �����´�.
	CarOffEmpBean coe_r [] = cod.getCarOffEmpAll(car_off_id);
	
	//�׿��� �ŷ�ó ����	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	Hashtable ven = new Hashtable();
	if(!ven_code.equals("")){
		ven = neoe_db.getVendorCase(ven_code);
	}
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function CarOffDisp()
{
	var theForm = document.CarOffDispForm;
	theForm.submit();
}
function EmpRegWin()
{
	var theForm = document.CarOffDispForm;
	var car_off_id = theForm.car_off_id.value;
	var car_off_nm = '';//theForm.car_off_nm.value;
	var car_comp_id = theForm.car_comp_id.value;
	var car_comp_nm = '';//theForm.car_comp_nm.value;
	
	//var SUBWIN="./car_office_open_p_i.jsp?car_off_id="+car_off_id+"&car_off_nm="+car_off_nm+"&car_comp_id="+car_comp_id+"&car_comp_nm="+car_comp_nm;	
	//window.open(SUBWIN, "OfficePReg", "left=100, top=100, width=820, height=200, scrollbars=no");
	alert("�ڵ�������������� �޴����� �űԵ���� �ֽñ� �ٶ��ϴ�!!");
}
function CarOffReload()
{
	var theForm = document.CarOffForm;
	theForm.submit();
}
function go_list(){
	location.href = "./car_office_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%= user_id %>&br_id=<%= br_id %>&gubun1=<%= gubun1 %>&gubun2=<%= gubun2 %>&gubun3=<%= gubun3 %>&gubun4=<%= gubun4 %>&s_kd=<%= s_kd %>&t_wd=<%= t_wd %>";
}

//�����Ұ��°���
function BankAccMng(){
	var theForm = document.CarOffDispForm;
	var car_off_id = theForm.car_off_id.value;
	var car_off_nm = '';//theForm.car_off_nm.value;
	var car_comp_id = theForm.car_comp_id.value;
	var car_comp_nm = '';//theForm.car_comp_nm.value;
	
	var SUBWIN="./car_office_bank.jsp?car_off_id="+car_off_id+"&car_off_nm="+car_off_nm+"&car_comp_id="+car_comp_id+"&car_comp_nm="+car_comp_nm;	
	window.open(SUBWIN, "OfficeBank", "left=100, top=100, width=820, height=500, scrollbars=no");
}
//-->
</script>
</head>
<body>
<form action="./car_office_i.jsp" name="CarOffDispForm" method="POST" >
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ����������� > <span class=style5>�����Һ���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td colspan=2 align=right>
<%
if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))	{
%>
 			<a href="javascript:CarOffDisp()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify_s.gif" align="absmiddle" border="0"></a>&nbsp;
<%
	}
%>
			<a href="javascript:go_list()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a>&nbsp;
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td class=line colspan=2>
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
            	<tr>
			    	<td width=12% class=title>ȸ���</td>
			    	<td width=21%>&nbsp;<input type="hidden" name="car_comp_id" value="<%= car_comp_id %>"><input type="hidden" name="car_comp_nm" value="<%= car_comp_nm %>"><%=car_comp_nm%></td>
                    <td width=12% class=title>����</td>
                    <td width=22%>
                    	&nbsp;<input type="radio" name="car_off_st" value="1" <% if(car_off_st.equals("1")||car_off_st.equals("")) out.println("checked"); %>>����&nbsp;
                    	<input type="radio" name="car_off_st" value="2" <% if(car_off_st.equals("2")) out.println("checked"); %>>�븮��&nbsp;
                    	
                 	</td>
			    	<td class=title width=12%>��������</td>
                    <td width=21%>&nbsp;<%= owner_nm %><input type="hidden" name="owner_nm" value="<%= owner_nm %>"></td>
			    </tr>
                <tr>
                    <td class=title>�����Ҹ�</td>
			        <td>&nbsp;<%= car_off_nm %><input type="hidden" name="car_off_id" value="<%= car_off_id %>"><input type="hidden" name="car_off_nm" value="<%= car_off_nm %>"></td>
                    <td class=title>��ȭ</td>
               		<td>&nbsp;<%= car_off_tel %><input type="hidden" name="car_off_tel" value="<%= car_off_tel %>"></td>
               		<td class=title>FAX</td>
               		<td>&nbsp;<%= car_off_fax %><input type="hidden" name="car_off_fax" value="<%= car_off_fax %>"></td>
                    
                </tr>
                <tr>
                    <td class=title>����ڵ�Ϲ�ȣ</td>
               	    <td>&nbsp;
               	      <%=enp_no%><input type="hidden" name="enp_no" value="<%= enp_no %>">
               	    </td>
               		<td class=title>�׿����ŷ�ó</td>
               		<td  colspan=3>&nbsp;<%if(!ven_code.equals("")){%>(<%=ven_code%>)&nbsp;<%=ven.get("VEN_NAME")%><%}%><input type="hidden" name="ven_code" value="<%= ven_code %>"></td>
                </tr>                    
                <tr>
                    <td class=title>�ּ�</td>
               		<td colspan=5>&nbsp;(<%= car_off_post %>) <%=car_off_addr%><input type="hidden" name="car_off_post" value="<%= car_off_post %>">&nbsp;<input type="hidden" name="car_off_addr"></td>
                </tr>
                <tr>
                    <td class=title>�ŷ�����</td>
               		<td>&nbsp;<%= bank %></td>
               		<td class=title>���¹�ȣ</td>
               		<td>&nbsp;<%= acc_no %><input type="hidden" name="acc_no" value="<%= acc_no %>"></td>
               		<td class=title>������</td>
               		<td >&nbsp;<%= acc_nm %><input type="hidden" name="acc_nm" value="<%= acc_nm %>"></td>
                </tr>
                <tr>                    
                    <td class=title>�����</td>
			        <td>&nbsp;<%= manager %><input type="hidden" name="manager" value="<%= manager %>"></td>			    	
                    <td class=title>�����</td>
			        <td>&nbsp;<%= agnt_nm %><input type="hidden" name="agnt_nm" value="<%= agnt_nm %>"></td>			    	
                    <td class=title>����ó</td>
               		<td>&nbsp;<%= agnt_m_tel %><input type="hidden" name="agnt_m_tel" value="<%= agnt_m_tel %>"></td>                    
                </tr>	
                <tr>                    
                    <td class=title>��꼭���Ÿ���</td>
			        <td colspan='5'>&nbsp;<%= agnt_email %><input type="hidden" name="agnt_email" value="<%= agnt_email %>"></td>			    	
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
                    <td width=12% class=title>����ڵ�ϱ���</td>
		    <td width=20%>&nbsp;
		        <%if(co_bean.getEnp_reg_st().equals("1")){%>����ڵ�ϻ����<%}%>
                    	<%if(co_bean.getEnp_reg_st().equals("2")){%>����ڹ̵����<%}%>
		    </td>			    	
		    <td width=12% class=title>�ŷ�����</td>
                    <td width=24%>&nbsp;
                    	<%if(co_bean.getDoc_st().equals("1")){%>��õ¡��<%}%>
                    	<%if(co_bean.getDoc_st().equals("2")){%>���ݰ�꼭<%}%>
                    </td>
                    <td class=title width=12%>����������</td>
                    <td width=20%>&nbsp;
                    	<%if(co_bean.getEst_day().equals("")){%>����<%}%>
                    	<%if(!co_bean.getEst_day().equals("")){%>�ſ�<%=co_bean.getEst_day()%>��<%}%>
                    </td>
		</tr>                                            
                <tr>
               	    <td class=title>���ݰ�꼭<br>���뱸��</td>
               	    <td>&nbsp;
		        <%if(co_bean.getReq_st().equals("1")){%>����<%}%>
                    	<%if(co_bean.getReq_st().equals("2")){%>����<%}%>
                    	<%if(co_bean.getReq_st().equals("3")){%>����<%}%>
		    </td>			
               	    <td class=title>���ޱ���</td>
               	    <td colspan='3'>&nbsp;
		        <%if(co_bean.getPay_st().equals("1")){%>����<%}%>
                    	<%if(co_bean.getPay_st().equals("2")){%>�����Ǻ�<%}%>
		    </td>			
                </tr>                     
            </table>
        </td>
    </tr>
    
	<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))	{%>	
    <tr>
        <td colspan=2 align="right"><a href="javascript:BankAccMng()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_acc_yus.gif  align="absmiddle" border="0"></a></td>
    </tr>
	<%	}%>	
    <tr>
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���</span></td>
    	<td align="right">
		<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))	{%>
    	<!--<a href="javascript:EmpRegWin()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg_sw.gif" align="absmiddle" border="0"></a>-->
		<%	}%>
    	</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td class=line colspan=2>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
            	<tr>
            		<td width=20% class=title>����</td>
            		<td width=20% class=title>����</td>
            		<td width=30% class=title>�޴���</td>
            		<td width=30% class=title>�̸���</td>
            		
            	</tr>
<%
    for(int i=0; i<coe_r.length; i++){
        coe_bean = coe_r[i];
%>
            	<tr>
            		<td align=center><%= coe_bean.getEmp_nm() %></td>
            		<td align=center><%= coe_bean.getEmp_pos() %></td>
            		<td align=center><%= coe_bean.getEmp_m_tel() %></td>
            		<td>&nbsp;<%= coe_bean.getEmp_email() %></td>
            	</tr>
<%}%>
<% if(coe_r.length == 0) { %>
                <tr>
                    <td colspan=4 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
                </tr>
<%}%>
            </table>
        </td>
    </tr>
</table>
<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="user_id" value="<%= user_id %>">
<input type="hidden" name="br_id" value="<%= br_id %>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="gubun3" value="<%=gubun3%>">
<input type="hidden" name="gubun4" value="<%=gubun4%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
</form>

<form action="./car_office_c.jsp" name="CarOffForm" method=post>
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="user_id" value="<%= user_id %>">
<input type="hidden" name="br_id" value="<%= br_id %>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="gubun3" value="<%=gubun3%>">
<input type="hidden" name="gubun4" value="<%=gubun4%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="car_off_id" value="<%= car_off_id %>">
</form>
</body>
</html>
