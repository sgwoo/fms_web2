<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_service.*, acar.cus_samt.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.cus_samt.CusSamt_Database"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String acct = request.getParameter("acct")==null?"000620":request.getParameter("acct");	
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_day = request.getParameter("s_day")==null?"":request.getParameter("s_day");
	
	String acct_dt = s_year + s_mon + s_day;
		
//	System.out.println("acct="+ acct);
//	System.out.println("acct_dt="+ acct_dt);
	
	//String s_yy = request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	//String s_mm = request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	//String s_seq = request.getParameter("s_seq")==null?"":request.getParameter("s_seq");

	//String acct = request.getParameter("acct")==null?"000620":request.getParameter("acct");
	
	//int j_g_amt = request.getParameter("j_g_amt")==null?0: AddUtil.parseInt(request.getParameter("j_g_amt"));
	//int j_b_amt = request.getParameter("j_b_amt")==null?0: AddUtil.parseInt(request.getParameter("j_b_amt"));
	//int j_g_dc_amt = request.getParameter("j_g_dc_amt")==null?0: AddUtil.parseInt(request.getParameter("j_g_dc_amt"));
	//int j_dc_amt = request.getParameter("j_dc_amt")==null?0: AddUtil.parseInt(request.getParameter("j_dc_amt"));
	//int j_ext_amt = request.getParameter("j_ext_amt")==null?0: AddUtil.parseInt(request.getParameter("j_ext_amt"));
	
	String jung_st = request.getParameter("jung_st");  //����ȸ��
	String set_dt = request.getParameter("set_dt");    // ������ - �������� ���� ���������� 
	String r_labor = request.getParameter("r_labor");  //����
  	String v_amt = request.getParameter("v_amt");      //����
  	String v_g_dc_amt = request.getParameter("v_g_dc_amt");  //���� dc
 	String v_ext_amt = request.getParameter("v_ext_amt");  //���� dc
 	String v_dc_amt = request.getParameter("v_dc_amt");  //dc -������ 
 	 				                     
	boolean flag1 = true;
		
//	int vt_size = set_dt.length;
	int vt_size = 1;
//	System.out.println("vt_size="+ vt_size);
	
	int s_r_labor = 0;  //���� 
	int s_v_amt = 0;  //���� 
	int s_v_g_dc_amt =0;  //���� dc
	int s_v_ext_amt = 0;  //����
	int s_v_dc_amt = 0;  //dc -������  (0) 
	
	int t_r_labor = 0;  //���� 
	int t_v_amt = 0;  //���� 
	int t_v_g_dc_amt =0;  //���� dc
	int t_v_ext_amt = 0;  //����
	int t_v_dc_amt = 0;  //dc -������  (0) 
	
	String jungsan = "";
	String chk_jungsan = "";
	
	String s_set_dt = "";
	String s_jung_st = "";
	
	String s_yy		 = "";
	String s_mm		 = "";
	
	String value[] = new String[2];
	
	for(int i = 0; i<vt_size; i++){
		jungsan = set_dt +"^"+ jung_st;
	
	//	System.out.println("jungsan="+ jungsan);
				
		if (i==0) chk_jungsan = jungsan;
		
		if (  !chk_jungsan.equals(jungsan)) {
									
		//	System.out.println("chk_jungsan="+ chk_jungsan);
		//	System.out.println("t_r_labor="+ t_r_labor);
		//	System.out.println("t_v_amt="+ t_v_amt);
							
			StringTokenizer st = new StringTokenizer(chk_jungsan,"^");
			int s=0;
			
			while(st.hasMoreTokens()){
				value[s] = st.nextToken();
				s++;
			}
			
			s_set_dt		= value[0];
			s_jung_st	= value[1];
						
	//		System.out.println("s_set_dt="+ s_set_dt);
	//		System.out.println("s_jung_st="+ s_jung_st);
			
			s_yy = s_set_dt.substring(0,4);
			s_mm = s_set_dt.substring(4,6);
			
		//	System.out.println("s_yy="+ s_yy+ " s_mm="+ s_mm);
			
			flag1 = cs_db.updateMJ_Jungsan(acct, s_yy, s_mm, s_jung_st, t_r_labor, t_v_amt, t_v_g_dc_amt,  t_v_ext_amt, t_v_dc_amt,  user_id, s_set_dt);

			t_r_labor = 0;
			t_v_amt = 0;
			t_v_g_dc_amt = 0;
			t_v_ext_amt = 0;
			t_v_dc_amt = 0;		
			
			chk_jungsan = jungsan;
						
		}
					
		s_r_labor = r_labor	==null?0 :AddUtil.parseDigit(r_labor);  //���� 
		s_v_amt = v_amt	==null?0 :AddUtil.parseDigit(v_amt);  //���� 
		s_v_g_dc_amt = v_g_dc_amt	==null?0 :AddUtil.parseDigit(v_g_dc_amt);  //���� dc
		s_v_ext_amt = v_ext_amt	==null?0 :AddUtil.parseDigit(v_ext_amt);  //����
		s_v_dc_amt = v_dc_amt	==null?0 :AddUtil.parseDigit(v_dc_amt);  //dc -������  (0) 
		
		t_r_labor =t_r_labor + s_r_labor;  //����  ��  - ���꺰
		t_v_amt = t_v_amt + s_v_amt;  //���� 
		t_v_g_dc_amt =t_v_g_dc_amt+ s_v_g_dc_amt;  //���� dc
		t_v_ext_amt = t_v_ext_amt + s_v_ext_amt;  //����
		t_v_dc_amt = t_v_dc_amt + s_v_dc_amt;  //dc -������  (0) 
		
	}
		
	//�������� ���Ѵ�.
//	System.out.println("chk_jungsan="+ chk_jungsan);
//	System.out.println("t_r_labor="+ t_r_labor);
//	System.out.println("t_v_amt="+ t_v_amt);
	
//	System.out.println("s_set_dt="+ s_set_dt);
//	System.out.println("s_jung_st="+ s_jung_st);
	
	StringTokenizer st1 = new StringTokenizer(jungsan,"^");
	int s1=0;
		
	while(st1.hasMoreTokens()){
		value[s1] = st1.nextToken();
		s1++;
	}
	
	s_set_dt	= value[0];
	s_jung_st	= value[1];
				
//	System.out.println("s_set_dt="+ s_set_dt);
//	System.out.println("s_jung_st="+ s_jung_st);
	
	s_yy = s_set_dt.substring(0,4);
	s_mm = s_set_dt.substring(4,6);
	
//	System.out.println("s_yy="+ s_yy+ " s_mm="+ s_mm);
		
	flag1 = cs_db.updateMJ_Jungsan(acct, s_yy, s_mm, s_jung_st, t_r_labor, t_v_amt, t_v_g_dc_amt,  t_v_ext_amt, t_v_dc_amt,  user_id , s_set_dt);
	
%>
<script language='javascript'>
<%	if(flag1){%>
		alert('���������� ó���Ǿ����ϴ�');
	//	parent.window.close();
	//	parent.opener.location.reload();
<%	}else{ //����%>
		alert('ó������ �ʾҽ��ϴ�\n\n�����߻�!');
<%	}%>
</script>
</body>
</html>
