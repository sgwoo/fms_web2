<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.car_register.*, acar.user_mng.*"%>
<%@ page import="acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	String cng_cau = request.getParameter("cng_cau")==null?"":request.getParameter("cng_cau");
	
	out.println("start_row="+start_row+"<br>");
	out.println("value_line="+value_line+"<br>");
	out.println("cng_cau="+cng_cau+"<br>");
	
	String result[]  = new String[value_line+10];
	String value0[]  = request.getParameterValues("value0");//����ȣ
	String value1[]  = request.getParameterValues("value1");//��������
	String value2[]  = request.getParameterValues("value2");//��������ID
	String value3[]  = request.getParameterValues("value3");//
	String value4[]  = request.getParameterValues("value4");//
	String value5[]  = request.getParameterValues("value5");//
	String value6[]  = request.getParameterValues("value6");//
	String value7[]  = request.getParameterValues("value7");//
	String value8[]  = request.getParameterValues("value8");//
	String value9[]  = request.getParameterValues("value9");//
	String value10[] = request.getParameterValues("value10");//
	
	boolean flag = true;
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//����  ������ ����Ÿ ����
	ad_db.deleteConvBusid2Case();	
	
	for(int i=start_row ; i <= value_line ; i++){
		
		result[i] = "";
		
		String rent_l_cd		= value0[i]  ==null?"":AddUtil.replace(value0[i],"'","");
		String mng_nm2			= value1[i]  ==null?"":AddUtil.replace(value1[i],"'","");
		
		out.println("i="+i+"&nbsp;&nbsp;&nbsp;");
		out.println("rent_l_cd="+rent_l_cd+"&nbsp;&nbsp;&nbsp;");
		out.println("mng_nm2="+mng_nm2+"&nbsp;&nbsp;&nbsp;");
		
		UsersBean mng2_bean = umd.getUserNmBean(mng_nm2);
		
		if(mng2_bean.getUse_yn().equals("Y")){
			ad_db.insertConvBusid2Case(rent_l_cd, mng_nm2);
			
			//������������ �������� ���� �߼۾���.
		}
		
		out.println("<br>");
		
	}
	
	//����ڹ������ν���ȣ��----------------------------------------------------------------------------
	String  d_flag1 =  ad_db.call_sp_conv_mngid2_excel();
	System.out.println("����ڹ������ν���ȣ��");
	//--------------------------------------------------------------------------------------------------	
	
	int result_cnt = 0;
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>���� ���� �о� ����ϱ�
</p>
<form method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
//-->
</SCRIPT>
</BODY>
</HTML>