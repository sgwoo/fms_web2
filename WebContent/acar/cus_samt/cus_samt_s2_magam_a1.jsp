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
	
	String jung_st = request.getParameter("jung_st");  //정산회차
	String set_dt = request.getParameter("set_dt");    // 정산일 - 정비일의 월의 마지막일자 
	String r_labor = request.getParameter("r_labor");  //공임
  	String v_amt = request.getParameter("v_amt");      //부픔
  	String v_g_dc_amt = request.getParameter("v_g_dc_amt");  //공임 dc
 	String v_ext_amt = request.getParameter("v_ext_amt");  //공임 dc
 	String v_dc_amt = request.getParameter("v_dc_amt");  //dc -할인율 
 	 				                     
	boolean flag1 = true;
		
//	int vt_size = set_dt.length;
	int vt_size = 1;
//	System.out.println("vt_size="+ vt_size);
	
	int s_r_labor = 0;  //공임 
	int s_v_amt = 0;  //부픔 
	int s_v_g_dc_amt =0;  //공임 dc
	int s_v_ext_amt = 0;  //선납
	int s_v_dc_amt = 0;  //dc -할인율  (0) 
	
	int t_r_labor = 0;  //공임 
	int t_v_amt = 0;  //부픔 
	int t_v_g_dc_amt =0;  //공임 dc
	int t_v_ext_amt = 0;  //선납
	int t_v_dc_amt = 0;  //dc -할인율  (0) 
	
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
					
		s_r_labor = r_labor	==null?0 :AddUtil.parseDigit(r_labor);  //공임 
		s_v_amt = v_amt	==null?0 :AddUtil.parseDigit(v_amt);  //부픔 
		s_v_g_dc_amt = v_g_dc_amt	==null?0 :AddUtil.parseDigit(v_g_dc_amt);  //공임 dc
		s_v_ext_amt = v_ext_amt	==null?0 :AddUtil.parseDigit(v_ext_amt);  //선납
		s_v_dc_amt = v_dc_amt	==null?0 :AddUtil.parseDigit(v_dc_amt);  //dc -할인율  (0) 
		
		t_r_labor =t_r_labor + s_r_labor;  //공임  계  - 정산별
		t_v_amt = t_v_amt + s_v_amt;  //부픔 
		t_v_g_dc_amt =t_v_g_dc_amt+ s_v_g_dc_amt;  //공임 dc
		t_v_ext_amt = t_v_ext_amt + s_v_ext_amt;  //선납
		t_v_dc_amt = t_v_dc_amt + s_v_dc_amt;  //dc -할인율  (0) 
		
	}
		
	//마지막은 더한다.
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
		alert('정상적으로 처리되었습니다');
	//	parent.window.close();
	//	parent.opener.location.reload();
<%	}else{ //에러%>
		alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
</script>
</body>
</html>
