<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.credit.*,  acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	
		
	boolean flag2 = true;	
	int flag = 0;	
			
	//ī�������ΰ�� ó���Ұ� 
   	//jung_st �� 3�� ��� : ī������, �����αݾ� ���, ī�� ������Ƿڷ� ó�� - 1 row ���� - �ݾ��� Ȯ���� �ٽ� ���� 
	ClsContEtcBean cct = new ClsContEtcBean();
	cct.setRent_mng_id(rent_mng_id);
	cct.setRent_l_cd	(rent_l_cd);
	cct.setJung_st("3");  //���걸��
	cct.setH1_amt(request.getParameter("h1_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h1_amt"))); //�����ݾ�
	cct.setH2_amt(request.getParameter("h2_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h2_amt"))); //�̳��Աݾ�
	cct.setH3_amt(request.getParameter("h3_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h3_amt"))); //����ݾ�(�ջ������)
	cct.setH4_amt(request.getParameter("h4_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h4_amt"))); //ȯ��
	cct.setH5_amt(100); // ������ �߰� 
	cct.setH6_amt(request.getParameter("h6_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h6_amt"))); //û��
	cct.setH7_amt(request.getParameter("h7_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h7_amt"))); //û������ݾ�						
	
	cct.setR_date(request.getParameter("r_date")==null?"":		request.getParameter("r_date"));  //ī�� ��Ұ��� - ����� ī�� ������							

	if(!ac_db.insertClsContEtc(cct))	flag += 1;
		
			
	System.out.println("ī�� ����� �ݾ� ���� ���� - "+rent_l_cd);	

	
	//����
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");

	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");


%>
<form name='form1' action='' target='d_content' method="POST">

<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>

</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	// ���� ����%>

	alert('��� �����߻�!');

<%	}else{ 			// ���� ����.. %>
	
    alert('ó���Ǿ����ϴ�');
   	fm.action='/fms2/cls_cont/lc_cls_rm_d_frame.jsp';			
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
