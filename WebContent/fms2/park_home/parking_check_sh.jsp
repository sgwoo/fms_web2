<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*, acar.res_search.*,acar.car_register.*"%> 
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%	
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no"); //������ȣ �Ǵ� �����ȣ
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm"); //����
	String car_mng_id	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id"); //����������ȣ
	String init_reg_dt	= request.getParameter("init_reg_dt")==null?"":request.getParameter("init_reg_dt"); //���ʵ����
	String dpm	= request.getParameter("dpm")==null?"":request.getParameter("dpm"); //��ⷮ
	String fuel_kd	= request.getParameter("fuel_kd")==null?"":request.getParameter("fuel_kd"); //����
	String colo	= request.getParameter("colo")==null?"":request.getParameter("colo"); // ����
	int car_km = request.getParameter("car_km")==null?0:Util.parseInt(request.getParameter("car_km")); //����Ÿ�
	String io_gubun	= request.getParameter("io_gubun")==null?"":request.getParameter("io_gubun");
	String park_id	= request.getParameter("park_id")==null?"1":request.getParameter("park_id");
	
	int count = 0;
	
	LoginBean login = LoginBean.getInstance();
	String acar_id = login.getCookieValue(request, "acar_id");
	
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���

	int cnt = 10; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-80;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(car_mng_id);
	

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type='hidden' name='car_mng_id' value='<%=car_mng_id%>'>

<table width="100%" border="0" cellspacing="1" cellpadding="0">
	<tr> 
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ý��� > ���������� > ��������Ȳ > <span class=style5>��������</span></span></td>
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
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=13%>���ʵ����</td>
                    <td width=21%>&nbsp; 
                      <input type="text" name="init_reg_dt" value="<%=cr_bean.getInit_reg_dt()%>" size="10" class=whitetext  maxlength="10">
                    </td>
                    <td class=title width=12%>����</td>
                    <td width=21%>&nbsp; 
                      <%=c_db.getNameByIdCode("0032", "", cr_bean.getCar_ext())%>                      
                    </td>
                    <td class=title width=12%>������ȣ</td>
                    <td width=21%>&nbsp; 
                      <input type="text" name="car_doc_no" value="<%=cr_bean.getCar_doc_no()%>" size="10" class=whitetext  maxlength="10">
                    </td>					
                </tr>
                <tr> 
                    <td class=title>�ڵ���������ȣ</td>
                    <td>&nbsp; 
                      <input type="text" name="car_no" value="<%=cr_bean.getCar_no()%>" size="15" class=whitetext maxlength="15">
                    </td>
                    <td class=title>����</td>
                    <td>&nbsp; 
                      <%=c_db.getNameByIdCode("0041", "", cr_bean.getCar_kd())%>                        
                    </td>
                    <td class=title>�뵵</td>
                    <td>&nbsp; 
                      <%if(cr_bean.getCar_use().equals("1")){%>������<%}%>
                      <%if(cr_bean.getCar_use().equals("2")){%>�ڰ���<%}%>                      
                    </td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td>
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td>
                                    <%=cr_bean.getCar_nm()%>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td class=title>�����ȣ</td>
                    <td>&nbsp; 
                      <input type="text" name="car_num" value="<%=cr_bean.getCar_num()%>" size="20" class=whitetext maxlength="20">
                    </td>
                    <td class=title>����</td>
                    <td>&nbsp; 
                      <input type="text" name="car_y_form" value="<%=cr_bean.getCar_y_form()%>" size="6" class=whitetext>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>

	<tr> 
		<td>&nbsp;</td>
	</tr>

	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="parking_check_s_in.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&car_km=<%=car_km%>" name="inner" width="100%"  frameborder=0 scrolling="auto" topmargin=0 marginwidth="0" marginheight="0" >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

</form>
</body>
</html>


