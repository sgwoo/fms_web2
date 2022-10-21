<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*, acar.util.*, acar.car_service.*, acar.cus_samt.*"%>

<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"5":request.getParameter("sort");
	
	String acct = request.getParameter("acct")==null?"000620":request.getParameter("acct");	
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_day = request.getParameter("s_day")==null?"":request.getParameter("s_day");
	
	String from_page = "/acar/cus_samt/cus_samt_s2_frame.jsp";
		
	CusSamt_Database cs_db = CusSamt_Database.getInstance();	
	
	int flag = 0;
	int count =0;
	boolean flag1 = true;
			
	int    vt_size 	= request.getParameter("vt_size")		==null?0 :AddUtil.parseInt(request.getParameter("vt_size"));  // 
	
	String c_id = request.getParameter("car_mng_id");	
	String s_id = request.getParameter("serv_id");	
	
	String j_st = request.getParameter("jung_st");	//정산회차
	String s_dt = request.getParameter("set_dt");	 // 정산일 - 정비일의 월의 마지막일자 
	
	String r_labor = request.getParameter("r_labor");  //공임
  	String v_amt = request.getParameter("v_amt");      //부픔
  	String v_g_dc_amt = request.getParameter("v_g_dc_amt");  //공임 dc
 	String v_ext_amt = request.getParameter("v_ext_amt");  //공임 dc
 	String v_dc_amt = request.getParameter("v_dc_amt");  //dc -할인율 
		
	for(int i=0; i < vt_size; i++){
								
		//정비테이블에 정산일 및 회차 등록 							
		if(!c_id.equals("")){		
			 flag1 = cs_db.updateServiceSetDt( c_id, s_id, s_dt, j_st, user_id);	//정산확정
		}
	
	}

 	//마감 도 같이한다 - 20220217 수정 
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
	
	for(int i=0; i < vt_size; i++){
	
		jungsan = s_dt +"^"+ j_st;
	
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
			
			s_set_dt	= value[0];
			s_jung_st	= value[1];
						
	//		System.out.println("s_set_dt="+ s_set_dt);
	//		System.out.println("s_jung_st="+ s_jung_st);
			
			s_yy = s_set_dt.substring(0,4);
			s_mm = s_set_dt.substring(4,6);
			
		//	System.out.println("s_yy="+ s_yy+ " s_mm="+ s_mm);
			
			flag1 = cs_db.updateMJ_Jungsan(acct, s_yy, s_mm, s_jung_st, t_r_labor, t_v_amt, t_v_g_dc_amt,  t_v_ext_amt, t_v_dc_amt,  user_id);

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
		
	flag1 = cs_db.updateMJ_Jungsan(acct, s_yy, s_mm, s_jung_st, t_r_labor, t_v_amt, t_v_g_dc_amt,  t_v_ext_amt, t_v_dc_amt,  user_id);


%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('정비비 정산 확정 에러입니다.\n\n확인하십시오');					<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='s_year' 	value='<%=s_year%>'>  
  <input type='hidden' name='s_mon' 	value='<%=s_mon%>'>  
  <input type='hidden' name='s_day' 	value='<%=s_day%>'>  

  <input type='hidden' name="from_page" 		value="<%=from_page%>"> 
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>