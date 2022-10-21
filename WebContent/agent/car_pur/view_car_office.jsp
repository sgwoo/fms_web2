<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*" %>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>

<%@ include file="/agent/cookies.jsp" %>

<%
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	

	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String car_off_id = "";					//������ID
    String car_comp_id = "";					//�ڵ���ȸ��ID
    String car_comp_nm = "";					//�ڵ���ȸ���̸�
    String car_off_nm = "";					//�����Ҹ�
    String car_off_st = "";					//�����ұ���
    String owner_nm = "";					//������
    String car_off_tel = "";					//�繫����ȭ
    String car_off_fax = "";					//�ѽ�
    String car_off_post = "";				//�����ȣ
    String car_off_addr = "";				//�ּ�
    String bank = "";						//���°�������
    String acc_no = "";						//���¹�ȣ
    String acc_nm = "";						//������
    String ven_code = "";					//�׿����ŷ�ó�ڵ�
    String manager = "";					//����
    String agnt_nm = "";					//���ǹ���
    String agnt_m_tel = "";					//���ǹ�����ȭ    
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
		
		car_off_id = co_bean.getCar_off_id();
		car_comp_id = co_bean.getCar_comp_id();
		car_comp_nm = co_bean.getCar_comp_nm();
		car_off_nm = co_bean.getCar_off_nm();
		car_off_st = co_bean.getCar_off_st();
		owner_nm = co_bean.getOwner_nm();
		car_off_tel = co_bean.getCar_off_tel();
		car_off_fax = co_bean.getCar_off_fax();
		car_off_post = co_bean.getCar_off_post();
		car_off_addr = co_bean.getCar_off_addr();
		bank = co_bean.getBank();
		acc_no = co_bean.getAcc_no();
		acc_nm = co_bean.getAcc_nm();
		ven_code 		= co_bean.getVen_code();
		manager 		= co_bean.getManager();
		agnt_nm 		= co_bean.getAgnt_nm();
		agnt_m_tel 		= co_bean.getAgnt_m_tel();
		enp_no 			= co_bean.getEnp_no();
	}
	
	CarCompBean cc_r [] = cod.getCarCompAll();
	CodeBean cd_r [] = c_db.getCodeAll("0003");	//������� �����´�.
	CarOffEmpBean coe_r [] = cod.getCarOffEmpAll(car_off_id);
	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--

//-->
</script>
</head>
<body leftmargin="15">
<form action="/agent/car_office/car_off_null_ui.jsp" name="CarOffForm" method="POST" >
<input type="hidden" name="cmd" value="">
<input type="hidden" name="mode" value="car_pur">
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>����������</span></span></td>
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
            <table border="0" cellspacing="1" width=100%>
            	<tr>
			    	<td width=12% class=title>ȸ���</td>
			    	<td width=22%>&nbsp;<input type="hidden" name="car_comp_id" value="<%= car_comp_id %>"><input type="hidden" name="car_comp_nm" value="<%= car_comp_nm %>"><%=car_comp_nm%></td>
			    	<td class=title width=10%>������</td>
                    <td width=22%>&nbsp;<%= owner_nm %><input type="hidden" name="owner_nm" value="<%= owner_nm %>"></td>
                    <td width=10% class=title>����</td>
                    <td width=23%>
                    	&nbsp;<input type="radio" name="car_off_st" value="1" <% if(car_off_st.equals("1")||car_off_st.equals("")) out.println("checked"); %>>����&nbsp;
                    	<input type="radio" name="car_off_st" value="2" <% if(car_off_st.equals("2")) out.println("checked"); %>>�븮��&nbsp;
                    	
                 	</td>
			    </tr>
                <tr>
                    <td class=title>�븮����</td>
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
               		<td  colspan=3>&nbsp;<%if(!ven_code.equals("")){%><%=ven_code%><%}%><input type="hidden" name="ven_code" value="<%= ven_code %>"></td>
                </tr>                    
                <tr>
                    <td class=title>�ּ�</td>
               		<td colspan=5>&nbsp;(<%= car_off_post %>) <%=car_off_addr%><input type="hidden" name="car_off_post" value="<%= car_off_post %>">&nbsp;<input type="hidden" name="car_off_addr"></td>
                </tr>
                <tr>                    
                    <td class=title>�����</td>
			        <td>&nbsp;<%= manager %><input type="hidden" name="manager" value="<%= manager %>"></td>			    	
                    <td class=title>���ǹ���</td>
			        <td>&nbsp;<%= agnt_nm %><input type="hidden" name="agnt_nm" value="<%= agnt_nm %>"></td>			    	
                    <td class=title>�ǹ����ڵ���</td>
               		<td>&nbsp;<%= agnt_m_tel %><input type="hidden" name="agnt_m_tel" value="<%= agnt_m_tel %>"></td>                    
                </tr>		                

            </table>
        </td>
    </tr>

	<tr>
		<td align="right">		  
		  <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>	
	</tr>				
</table>
</form>
</body>
</html>
