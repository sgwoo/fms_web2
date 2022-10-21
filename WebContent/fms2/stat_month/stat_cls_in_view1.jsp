<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.stat_bus.*"%>
<jsp:useBean id="sb_db" scope="page" class="acar.stat_bus.StatBusDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String brch_id = request.getParameter("brch_id")==null?br_id:request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"6":request.getParameter("gubun");
	String s_yy = request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	String bm = request.getParameter("bm")==null?"1":request.getParameter("bm");//타입
	
	String from_page = "/fms2/stat_month/stat_cls1.jsp";
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	if(save_dt.equals(""))	save_dt = sb_db.getMaxSaveDt("stat_bus");
	
	s_yy = AddUtil.replace(s_yy,"-","");
	s_mm = AddUtil.replace(s_mm,"-","");
	
	Vector buss1 = sb_db.getStatClsSearch1("6", brch_id, s_yy, s_mm, bm );
	int bus_size1 = buss1.size();
	
	int cnt1[] 	= new int[10];
	int cnt2[] 	= new int[10];
	int cnt3[] 	= new int[10];
	int cnt4[] 	= new int[10];
	int cnt5[] 	= new int[10];
	int cnt6[] 	= new int[10];
	int cnt7[] 	= new int[10];
	int cnt8[] 	= new int[10];	
	int cnt9[] 	= new int[10];
	int cnt10[] 	= new int[10];
	int cnt11[] 	= new int[10];
	int cnt12[] 	= new int[10];
	int cnt13[] 	= new int[10];
	int cnt14[] 	= new int[10];
			
	int sub_cnt1[] 	= new int[10];	
	int sub_cnt2[] 	= new int[10];	
	int sub_cnt3[] 	= new int[10];	
	int sub_cnt4[] 	= new int[10];	
	int sub_cnt5[] 	= new int[10];	
	int sub_cnt6[] 	= new int[10];	
	int sub_cnt7[] 	= new int[10];	
	int sub_cnt8[] 	= new int[10];		
	int sub_cnt9[] 	= new int[10];	
	int sub_cnt10[] 	= new int[10];	
	int sub_cnt11[] 	= new int[10];	
	int sub_cnt12[] 	= new int[10];	
	int sub_cnt13[] 	= new int[10];	
	int sub_cnt14[] 	= new int[10];	
		
	int t_cnt1[] 	= new int[10];	
	int t_cnt2[] 	= new int[10];	
	int t_cnt3[] 	= new int[10];	
	int t_cnt4[] 	= new int[10];	
	int t_cnt5[] 	= new int[10];	
	int t_cnt6[] 	= new int[10];	
	int t_cnt7[] 	= new int[10];	
	int t_cnt8[] 	= new int[10];	
	int t_cnt9[] 	= new int[10];	
	int t_cnt10[] 	= new int[10];	
	int t_cnt11[] 	= new int[10];	
	int t_cnt12[] 	= new int[10];	
	int t_cnt13[] 	= new int[10];	
	int t_cnt14[] 	= new int[10];	
	
	int g_cnt[] 	= new int[10];
			
	int car_type_cnt = 0;
	int car_type_size1 = 0;
	int car_type_size2 = 0;
	int car_type_size3 = 0;
	int car_type_size4 = 0;
	int car_type_size5 = 0;  //강남
	int car_type_size6 = 0; //광주
	int car_type_size7 = 0; //대구
	int car_type_size8 = 0; //인천
	int car_type_size9 = 0;  //수원
	int car_type_size10 = 0;  //강서
	int car_type_size11 = 0;  //구로
	int car_type_size12 = 0;  //율선
	int car_type_size13 = 0;  //구로
	int car_type_size14 = 0; //송파				
	
	int car_type_user_cnt1 = 0;
	int car_type_user_cnt2 = 0;
	int car_type_user_cnt3 = 0;
	int car_type_user_cnt4 = 0;	
	int car_type_user_cnt5 = 0;	
	int car_type_user_cnt6 = 0;	
	int car_type_user_cnt7 = 0;	
	int car_type_user_cnt8 = 0;	
	int car_type_user_cnt9 = 0;
	int car_type_user_cnt10 = 0;
	int car_type_user_cnt11 = 0;
	int car_type_user_cnt12 = 0;	
	int car_type_user_cnt13 = 0;	
	int car_type_user_cnt14 = 0;		
	
	for(int i = 0 ; i < bus_size1 ; i++){
		Hashtable ht = (Hashtable)buss1.elementAt(i);
			
		if(String.valueOf(ht.get("DEPT_ID")).equals("0001")) car_type_size1++;	
		if(String.valueOf(ht.get("DEPT_ID")).equals("0002")) car_type_size2++;
		if(String.valueOf(ht.get("DEPT_ID")).equals("0007")) car_type_size3++;
		if(String.valueOf(ht.get("DEPT_ID")).equals("0008")) car_type_size4++;
		if(String.valueOf(ht.get("DEPT_ID")).equals("0009")) car_type_size5++;
		if(String.valueOf(ht.get("DEPT_ID")).equals("0010")) car_type_size6++;
		if(String.valueOf(ht.get("DEPT_ID")).equals("0011")) car_type_size7++;
		if(String.valueOf(ht.get("DEPT_ID")).equals("0012")) car_type_size8++;		
		if(String.valueOf(ht.get("DEPT_ID")).equals("0013")) car_type_size9++;	
		if(String.valueOf(ht.get("DEPT_ID")).equals("0014")) car_type_size10++;
		if(String.valueOf(ht.get("DEPT_ID")).equals("0015")) car_type_size11++;
		if(String.valueOf(ht.get("DEPT_ID")).equals("0016")) car_type_size12++;
		if(String.valueOf(ht.get("DEPT_ID")).equals("0017")) car_type_size13++;
		if(String.valueOf(ht.get("DEPT_ID")).equals("0018")) car_type_size14++;
	}
	
	//부서별 인원수구하기
	Vector buss_1 = sb_db.getStatClsSearch1("6", "0001", s_yy, s_mm, bm );
	Vector buss_2 = sb_db.getStatClsSearch1("6", "0002", s_yy, s_mm, bm );
	Vector buss_7 = sb_db.getStatClsSearch1("6", "0007", s_yy, s_mm, bm );
	Vector buss_8 = sb_db.getStatClsSearch1("6", "0008", s_yy, s_mm, bm );
	Vector buss_9 = sb_db.getStatClsSearch1("6", "0009", s_yy, s_mm, bm );
	Vector buss_10 = sb_db.getStatClsSearch1("6", "0010", s_yy, s_mm, bm );
	Vector buss_11 = sb_db.getStatClsSearch1("6", "0011", s_yy, s_mm, bm );
	Vector buss_12 = sb_db.getStatClsSearch1("6", "0012", s_yy, s_mm, bm );	
	Vector buss_13 = sb_db.getStatClsSearch1("6", "0013", s_yy, s_mm, bm );
	Vector buss_14 = sb_db.getStatClsSearch1("6", "0014", s_yy, s_mm, bm );
	Vector buss_15 = sb_db.getStatClsSearch1("6", "0015", s_yy, s_mm, bm );
	Vector buss_16 = sb_db.getStatClsSearch1("6", "0016", s_yy, s_mm, bm );
	Vector buss_17 = sb_db.getStatClsSearch1("6", "0017", s_yy, s_mm, bm );
	Vector buss_18 = sb_db.getStatClsSearch1("6", "0018", s_yy, s_mm, bm );
	
	String u_chk = "";
		
	for(int i = 0 ; i < buss_1.size() ; i++){
		Hashtable ht1 = (Hashtable)buss_1.elementAt(i);
		
			if ( i == 0 ) { 
				u_chk = String.valueOf(ht1.get("BUS_ID"));
				car_type_user_cnt1 = 1;
			}
								
			if ( !u_chk.equals(String.valueOf(ht1.get("BUS_ID")))) {       
				car_type_user_cnt1++;
				u_chk = String.valueOf(ht1.get("BUS_ID"));
			}
				
	}	
	
	for(int i = 0 ; i < buss_2.size() ; i++){
		Hashtable ht2 = (Hashtable)buss_2.elementAt(i);		
		
			if ( i == 0 ) { 
				u_chk = String.valueOf(ht2.get("BUS_ID"));
				car_type_user_cnt2 = 1;
			}
							
			if ( !u_chk.equals(String.valueOf(ht2.get("BUS_ID")))) {       
				car_type_user_cnt2++;
				u_chk = String.valueOf(ht2.get("BUS_ID"));
			}				
	
	}
	
	for(int i = 0 ; i < buss_7.size() ; i++){
		Hashtable ht3 = (Hashtable)buss_7.elementAt(i);	
		
			if ( i == 0 ) { 
				u_chk = String.valueOf(ht3.get("BUS_ID"));
				car_type_user_cnt3 = 1;
			}
								
			if ( !u_chk.equals(String.valueOf(ht3.get("BUS_ID")))) {       
				car_type_user_cnt3++;
				u_chk = String.valueOf(ht3.get("BUS_ID"));
			}				
			
	}
	
	for(int i = 0 ; i < buss_8.size() ; i++){
		Hashtable ht4 = (Hashtable)buss_8.elementAt(i);	
		
			if ( i == 0 ) { 
				u_chk = String.valueOf(ht4.get("BUS_ID"));
				car_type_user_cnt4 = 1;
			}
								
			if ( !u_chk.equals(String.valueOf(ht4.get("BUS_ID")))) {       
				car_type_user_cnt4++;
				u_chk = String.valueOf(ht4.get("BUS_ID"));
			}				
			
	}
	
	for(int i = 0 ; i < buss_9.size() ; i++){
		Hashtable ht5 = (Hashtable)buss_9.elementAt(i);	
		
			if ( i == 0 ) { 
				u_chk = String.valueOf(ht5.get("BUS_ID"));
				car_type_user_cnt5 = 1;
			}
								
			if ( !u_chk.equals(String.valueOf(ht5.get("BUS_ID")))) {       
				car_type_user_cnt5++;
				u_chk = String.valueOf(ht5.get("BUS_ID"));
			}				
						
	}
	
	for(int i = 0 ; i < buss_10.size() ; i++){
		Hashtable ht6 = (Hashtable)buss_10.elementAt(i);	
		
			if ( i == 0 ) { 
				u_chk = String.valueOf(ht6.get("BUS_ID"));
				car_type_user_cnt6 = 1;
			}
								
			if ( !u_chk.equals(String.valueOf(ht6.get("BUS_ID")))) {       
				car_type_user_cnt6++;
				u_chk = String.valueOf(ht6.get("BUS_ID"));
			}				
			
	}
	
	for(int i = 0 ; i < buss_11.size() ; i++){
		Hashtable ht7 = (Hashtable)buss_11.elementAt(i);	
		
			if ( i == 0 ) { 
				u_chk = String.valueOf(ht7.get("BUS_ID"));
				car_type_user_cnt7 = 1;
			}
								
			if ( !u_chk.equals(String.valueOf(ht7.get("BUS_ID")))) {       
				car_type_user_cnt7++;
				u_chk = String.valueOf(ht7.get("BUS_ID"));
			}				
			
	}
	
	for(int i = 0 ; i < buss_12.size() ; i++){
		Hashtable ht8 = (Hashtable)buss_12.elementAt(i);	
		
			if ( i == 0 ) { 
				u_chk = String.valueOf(ht8.get("BUS_ID"));
				car_type_user_cnt8 = 1;
			}
								
			if ( !u_chk.equals(String.valueOf(ht8.get("BUS_ID")))) {       
				car_type_user_cnt8++;
				u_chk = String.valueOf(ht8.get("BUS_ID"));
			}				
			
	}
	
	for(int i = 0 ; i < buss_13.size() ; i++){
		Hashtable ht9 = (Hashtable)buss_13.elementAt(i);	
		
			if ( i == 0 ) { 
				u_chk = String.valueOf(ht9.get("BUS_ID"));
				car_type_user_cnt9 = 1;
			}
								
			if ( !u_chk.equals(String.valueOf(ht9.get("BUS_ID")))) {       
				car_type_user_cnt9++;
				u_chk = String.valueOf(ht9.get("BUS_ID"));
			}				
			
	}
	
	for(int i = 0 ; i < buss_14.size() ; i++){
		Hashtable ht10 = (Hashtable)buss_14.elementAt(i);	
		
			if ( i == 0 ) { 
				u_chk = String.valueOf(ht10.get("BUS_ID"));
				car_type_user_cnt10 = 1;
			}
								
			if ( !u_chk.equals(String.valueOf(ht10.get("BUS_ID")))) {       
				car_type_user_cnt10++;
				u_chk = String.valueOf(ht10.get("BUS_ID"));
			}				
			
	}
	
	for(int i = 0 ; i < buss_15.size() ; i++){
		Hashtable ht11 = (Hashtable)buss_15.elementAt(i);	
		
			if ( i == 0 ) { 
				u_chk = String.valueOf(ht11.get("BUS_ID"));
				car_type_user_cnt11 = 1;
			}
								
			if ( !u_chk.equals(String.valueOf(ht11.get("BUS_ID")))) {       
				car_type_user_cnt11++;
				u_chk = String.valueOf(ht11.get("BUS_ID"));
			}				
			
	}
	
	for(int i = 0 ; i < buss_16.size() ; i++){
		Hashtable ht12 = (Hashtable)buss_16.elementAt(i);	
		
			if ( i == 0 ) { 
				u_chk = String.valueOf(ht12.get("BUS_ID"));
				car_type_user_cnt12 = 1;
			}
								
			if ( !u_chk.equals(String.valueOf(ht12.get("BUS_ID")))) {       
				car_type_user_cnt12++;
				u_chk = String.valueOf(ht12.get("BUS_ID"));
			}				
			
	}
	for(int i = 0 ; i < buss_17.size() ; i++){
		Hashtable ht13 = (Hashtable)buss_17.elementAt(i);	
		
			if ( i == 0 ) { 
				u_chk = String.valueOf(ht13.get("BUS_ID"));
				car_type_user_cnt13 = 1;
			}
								
			if ( !u_chk.equals(String.valueOf(ht13.get("BUS_ID")))) {       
				car_type_user_cnt13++;
				u_chk = String.valueOf(ht13.get("BUS_ID"));
			}				
			
	}
	
	for(int i = 0 ; i < buss_18.size() ; i++){
		Hashtable ht14 = (Hashtable)buss_18.elementAt(i);	
		
			if ( i == 0 ) { 
				u_chk = String.valueOf(ht14.get("BUS_ID"));
				car_type_user_cnt14 = 1;
			}
								
			if ( !u_chk.equals(String.valueOf(ht14.get("BUS_ID")))) {       
				car_type_user_cnt14++;
				u_chk = String.valueOf(ht14.get("BUS_ID"));
			}				
			
	}
		
	String gubun4 = "";
	String gubun5 = "";
	
	int user_type_cnt = 0;
	int user_type_size1 = 0;
	int s_cnt= 0;
	
	String chk = "";	
	float sub_tot = 0;   
		
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
//-->
</script>
<script language='javascript'>
<!--

	function stat_search(mode, bus_id2){	
		var fm = document.form1;	
		parent.location.href = "/acar/condition/rent_cond_frame.jsp?dt=3&gubun2=1&ref_dt1=<%=s_yy%>&ref_dt2=<%=s_mm%>&gubun3=1&gubun4="+bus_id2;		
	}
	
	
	//해지현황 리스트 이동
	function list_move(gubun3, gubun4, gubun5)
	{
		var fm = document.form1;
		var url = "";
		fm.gubun3.value = gubun3;	
		fm.gubun4.value = gubun4;			
		fm.gubun5.value = gubun5;	
				
		url = "/fms2/stat_month/stat_cls_mng_frame.jsp";
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
	
			
//-->
</script>

</head>
<body onLoad="javascript:init()">
<form  name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='bus_size1' value='<%=bus_size1%>'>

<input type='hidden' name='s_user' value=''>
<input type='hidden' name='s_dept' value=''>
<input type='hidden' name='s_mng_way' value=''>
<input type='hidden' name='s_mng_st' value=''>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_yy' value='<%=s_yy%>'>
<input type='hidden' name='s_mm' value='<%=s_mm%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='bus_id2' value=''>
<input type='hidden' name='mode' value=''>

<input type='hidden' name='gubun3' 	value=''>       
<input type='hidden' name='gubun4' 	value=''> 
<input type='hidden' name='gubun5' 	value=''>       
<input type='hidden' name='gubun6' 	value=''>   

<input type='hidden' name='ref_dt1' value='<%=s_yy%>'>
<input type='hidden' name='ref_dt2' value='<%=s_mm%>'>    
<input type='hidden' name='from_page' 	value='<%=from_page%>'>  
<input type='hidden' name='bm' 	value='<%=bm%>'>

  <table border="0" cellspacing="0" cellpadding="0" width=1080>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	  <td  class=line width='180' id='td_title' style='position:relative;'>
	   <table width="180" border="0" cellspacing="1" cellpadding="1" height="61">
	      <tr> 
           <td class='title' rowspan=2>구분</td>
          </tr>
          <tr>         
        </table></td>
	<td width='900' class=line>
	    <table width='900' border="0" cellspacing="1" cellpadding="1" height="61">
          <tr  align="center"> 
            <td class=title colspan="3">총대여해지</td>
            <td class=title colspan="3">만기반납</td>
            <td class=title colspan="3">만기매입옵션</td>
            <td class=title colspan="3">중도반납</td>
            <td class=title colspan="3">중도매입옵션</td>
          </tr>
          <tr  align="center"> 
            <td class=title width="60">건수</td>
            <td class=title width="60">대차계약</td>
            <td class=title width="60">대차비율</td>      <!-- 총대여해지 -->
            <td class=title width="60">건수</td>
            <td class=title width="60">대차계약</td>
            <td class=title width="60">대차비율</td>      <!-- 만기반납 -->
            <td class=title width="60">건수</td>
            <td class=title width="60">대차계약</td>
            <td class=title width="60">대차비율</td>    <!-- 만기매입옵션 -->
            <td class=title width="60">건수</td>
            <td class=title width="60">대차계약</td>
            <td class=title width="60">대차비율</td>   <!-- 증도반납 -->
            <td class=title width="60">건수</td>
            <td class=title width="60">대차계약</td> 
            <td class=title width="60">대차비율</td>    <!-- 중도매입옵션 -->                  
          </tr>
        </table>
	</td>
  </tr>  			  
  <tr>
	  <td class='line' width='180' id='td_con' style='position:relative;'>
	   <table border="0" cellspacing="1" cellpadding="0" width='180'>
          <%	car_type_cnt = 0;
          		user_type_size1 = 0;
          		user_type_cnt = 0;          		
          		s_cnt = 0;
          		chk = "";
          		
          		for(int i = 0 ; i < buss_1.size() ; i++){
					Hashtable ht = (Hashtable)buss_1.elementAt(i);   
						
						if ( i == 0 ) {
				    		chk = String.valueOf(ht.get("BUS_ID"));
				    		gubun4 = "0";				    		
						}
													
						user_type_size1 =  AddUtil.parseInt(String.valueOf(ht.get("DATA_RN")));
														
						String d_nm1 = "";
						
						if(String.valueOf(ht.get("RENT_WAY")).equals("1")){				d_nm1 = "일반식";	gubun5 = "1";
						}else if(String.valueOf(ht.get("RENT_WAY")).equals("3")){		d_nm1 = "기본식";	gubun5 = "3";					
						}
						
						if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
							user_type_cnt= 0;
							gubun4 = "2";
							s_cnt=1;
						} 
			%>	
				
          <tr>
            <%if(car_type_cnt==0){%>
             <td align="center" width='70' rowspan='<%=car_type_size1+car_type_user_cnt1%>'><a href="javascript:list_move('0001','','');">영업팀</a></td>
		    <%}%>					 
		    <%if(user_type_cnt==0 && s_cnt == 0  ){%>
             <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0001','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
		    <%}%>		 
		   	<%if( gubun4.equals("2") && s_cnt == 1 ){%> 
		  	 <td align="center" width="60" height="20">계</td>		  	 
		  	<% } else { %> 
		     <td align="center" width="60" height="20"><a href="javascript:list_move('0001','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>   
		    <%}%>		      
		  </tr>		        
		  <%if( gubun4.equals("2") && s_cnt == 1 ){%> 		   
          <tr>         
		 	 <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0001','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
			 <td align="center" width="60" height="20"><a href="javascript:list_move('0001','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>   
		  </tr>     
		  <% } %>  
      <%			car_type_cnt++;
      				user_type_cnt++;     				
      				 				   
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0";
					s_cnt=0;
           
            }%>
           
          <% if ( buss_1.size() > 0 ){%> 	
          <tr> 
           	 <td align="center" width="60" height="20">계</td>
          </tr>
           <% } %>  	
          <tr> 
            <td class="title" align="center" colspan=3  height="20">소합계</td>           
          </tr>
                    
          <%	car_type_cnt = 0;
          		user_type_size1 = 0;
          		user_type_cnt = 0;
          		s_cnt = 0;
          		chk = "";
          		          		
          		for(int i = 0 ; i < buss_2.size() ; i++){
					Hashtable ht = (Hashtable)buss_2.elementAt(i);   
						
						if ( i == 0 ) {
				    		chk = String.valueOf(ht.get("BUS_ID"));
				    		gubun4 = "0";		
						}
													
						user_type_size1 =  AddUtil.parseInt(String.valueOf(ht.get("DATA_RN")));
										
						String d_nm1 = "";
						
						if(String.valueOf(ht.get("RENT_WAY")).equals("1")){				d_nm1 =  "일반식";	gubun5 = "1";
						}else if(String.valueOf(ht.get("RENT_WAY")).equals("3")){		d_nm1 =  "기본식";	gubun5 = "3";					
						}
						
						if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
							user_type_cnt= 0;
							gubun4 = "2";
							s_cnt=1;
						} 		
		 %>	
				
          <tr>           
            <%if(car_type_cnt==0){%>
             <td align="center" width='70' rowspan='<%=car_type_size2+car_type_user_cnt2%>'><a href="javascript:list_move('0002','','');">고객지원팀</a></td>
		    <%}%>
		    <%if(user_type_cnt==0 && s_cnt == 0  ){%>
             <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0002','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
		    <%}%>	
		    <%if( gubun4.equals("2") && s_cnt == 1 ){%> 
		  	 <td align="center" width="60" height="20">계</td>		  	 
		  	<% } else { %> 
             <td align="center" width="60" height="20"><a href="javascript:list_move('0002','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>          
            <% } %>          
          </tr>
          <%if( gubun4.equals("2") && s_cnt == 1 ){%> 		   
          <tr>         
		 	 <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0001','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
			 <td align="center" width="60" height="20"><a href="javascript:list_move('0001','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>   
		  </tr>     
		  <% } %>  
      <%			car_type_cnt++;
      				user_type_cnt++;
      				       				
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0";
					s_cnt=0;
           
           }%>	
          <% if ( buss_2.size() > 0 ){%> 	
          <tr> 
           	 <td align="center" width="60" height="20">계</td>
          </tr> 
          <%} %>
          <tr> 
            <td class="title" align="center"  colspan=3  height="20">소합계</td>           
          </tr>
          
          <%	car_type_cnt = 0;
          		user_type_size1 = 0;
          		user_type_cnt = 0;
          		s_cnt = 0;
          		chk = "";
          		
          		for(int i = 0 ; i < buss_7.size() ; i++){
					Hashtable ht = (Hashtable)buss_7.elementAt(i);   
						
					if ( i == 0 ) {
			    		chk = String.valueOf(ht.get("BUS_ID"));
			    		gubun4 = "0";	
					}
												
					user_type_size1 =  AddUtil.parseInt(String.valueOf(ht.get("DATA_RN")));
									
					String d_nm1 = "";
					
					if(String.valueOf(ht.get("RENT_WAY")).equals("1")){				d_nm1 = "일반식";	gubun5 = "1";
					}else if(String.valueOf(ht.get("RENT_WAY")).equals("3")){		d_nm1 = "기본식";	gubun5 = "3";					
					}
					
					if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
						user_type_cnt= 0;
						gubun4 = "2";
						s_cnt=1;
					} 		
			%>	
				
          <tr> 
             <%if(car_type_cnt==0){%>
             <td align="center" width='70' rowspan='<%=car_type_size3+car_type_user_cnt3%>'><a href="javascript:list_move('0007','','');">부산지점</a></td>
		    <%}%>
             <%if(user_type_cnt==0 && s_cnt == 0  ){%>
             <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0007','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
		    <%}%>	
		    <%if( gubun4.equals("2") && s_cnt == 1 ){%> 
		  	 <td align="center" width="60" height="20">계</td>		  	 
		  	<% } else { %> 
            <td align="center" width="60" height="20"><a href="javascript:list_move('0007','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>        
          	<% } %>
          </tr>
          <%if( gubun4.equals("2") && s_cnt == 1 ){%> 		   
          <tr>         
		 	 <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0007','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
			 <td align="center" width="60" height="20"><a href="javascript:list_move('0007','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>   
		  </tr>     
		  <% } %>  
        <%			car_type_cnt++;
      				user_type_cnt++;          				       				
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0";
					s_cnt=0;
       
           }%>	
          <% if ( buss_7.size() > 0 ){%> 	
          <tr> 
           	 <td align="center" width="60" height="20">계</td>
          </tr>  
          <% } %>
          <tr> 
            <td class="title" align="center"  colspan=3  height="20">소합계</td>            
          </tr>
          
           <%	car_type_cnt = 0;
           		user_type_size1 = 0;
          		user_type_cnt = 0;
          		s_cnt = 0;
          		chk = "";
          		
          		for(int i = 0 ; i < buss_8.size() ; i++){
					Hashtable ht = (Hashtable)buss_8.elementAt(i);   
						
					if ( i == 0 ) {
			    		chk = String.valueOf(ht.get("BUS_ID"));
			    		gubun4 = "0";	
					}
												
					user_type_size1 =  AddUtil.parseInt(String.valueOf(ht.get("DATA_RN")));
									
					String d_nm1 = "";
					
					if(String.valueOf(ht.get("RENT_WAY")).equals("1")){				d_nm1 = "일반식";	gubun5 = "1";
					}else if(String.valueOf(ht.get("RENT_WAY")).equals("3")){		d_nm1 = "기본식";	gubun5 = "3";					
					}
					
					if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
						user_type_cnt= 0;
						gubun4 = "2";
						s_cnt=1;
					} 
			%>	
				
          <tr> 
             <%if(car_type_cnt==0){%>
             <td align="center" width='70' rowspan='<%=car_type_size4+car_type_user_cnt4%>'><a href="javascript:list_move('0008','','');">대전지점</a></td>
		    <%}%>
             <%if(user_type_cnt==0 && s_cnt == 0  ){%>
             <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0008','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
		    <%}%>	
		     <%if( gubun4.equals("2") && s_cnt == 1 ){%> 
		  	 <td align="center" width="60" height="20">계</td>		  	 
		  	<% } else { %> 
             <td align="center" width="60" height="20"><a href="javascript:list_move('0008','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>       
            <%} %>     
          </tr>
           <%if( gubun4.equals("2") && s_cnt == 1 ){%> 		   
          <tr>         
		 	 <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0008','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
			 <td align="center" width="60" height="20"><a href="javascript:list_move('0008','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>   
		  </tr>     
		  <% } %>  
     	 <%			car_type_cnt++;
      				user_type_cnt++;          				       				
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0";
					s_cnt=0;
       
           }%>
          <% if ( buss_8.size() > 0 ){%> 	 	
          <tr> 
           	 <td align="center" width="60" height="20">계</td>
          </tr>
          <% } %> 
          <tr> 
            <td class="title" align="center"  colspan=3  height="20">소합계</td>            
          </tr>
          
            <%	car_type_cnt = 0;
           		user_type_size1 = 0;
          		user_type_cnt = 0;
          		s_cnt = 0;
          		chk = "";
          		
          		for(int i = 0 ; i < buss_9.size() ; i++){
					Hashtable ht = (Hashtable)buss_9.elementAt(i);   
						
					if ( i == 0 ) {
			    		chk = String.valueOf(ht.get("BUS_ID"));
			    		gubun4 = "0";	
					}
												
					user_type_size1 =  AddUtil.parseInt(String.valueOf(ht.get("DATA_RN")));
									
					String d_nm1 = "";
					
					if(String.valueOf(ht.get("RENT_WAY")).equals("1")){				d_nm1 = "일반식";	gubun5 = "1";
					}else if(String.valueOf(ht.get("RENT_WAY")).equals("3")){		d_nm1 = "기본식";	gubun5 = "3";					
					}
					
					if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
						user_type_cnt= 0;
						gubun4 = "2";
						s_cnt=1;
					} 
			%>	
				
          <tr> 
             <%if(car_type_cnt==0){%>
             <td align="center" width='70' rowspan='<%=car_type_size5+car_type_user_cnt5%>'><a href="javascript:list_move('0009','','');">강남지점</a></td>
		    <%}%>
             <%if(user_type_cnt==0 && s_cnt == 0  ){%>
             <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0009','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
		    <%}%>	
		     <%if( gubun4.equals("2") && s_cnt == 1 ){%> 
		  	 <td align="center" width="60" height="20">계</td>		  	 
		  	<% } else { %> 
             <td align="center" width="60" height="20"><a href="javascript:list_move('0009','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>       
            <%} %>     
          </tr>
           <%if( gubun4.equals("2") && s_cnt == 1 ){%> 		   
          <tr>         
		 	 <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0009','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
			 <td align="center" width="60" height="20"><a href="javascript:list_move('0009','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>   
		  </tr>     
		  <% } %>  
     	 <%			car_type_cnt++;
      				user_type_cnt++;          				       				
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0";
					s_cnt=0;
       
           }%>
          <% if ( buss_9.size() > 0 ){%> 	 	
          <tr> 
           	 <td align="center" width="60" height="20">계</td>
          </tr>
          <% } %> 
          <tr> 
            <td class="title" align="center"  colspan=3  height="20">소합계</td>            
          </tr>
                              
              <%	car_type_cnt = 0;
           		user_type_size1 = 0;
          		user_type_cnt = 0;
          		s_cnt = 0;
          		chk = "";
          		
          		for(int i = 0 ; i < buss_10.size() ; i++){
					Hashtable ht = (Hashtable)buss_10.elementAt(i);   
						
					if ( i == 0 ) {
			    		chk = String.valueOf(ht.get("BUS_ID"));
			    		gubun4 = "0";	
					}
												
					user_type_size1 =  AddUtil.parseInt(String.valueOf(ht.get("DATA_RN")));
									
					String d_nm1 = "";
					
					if(String.valueOf(ht.get("RENT_WAY")).equals("1")){				d_nm1 = "일반식";	gubun5 = "1";
					}else if(String.valueOf(ht.get("RENT_WAY")).equals("3")){		d_nm1 = "기본식";	gubun5 = "3";					
					}
					
					if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
						user_type_cnt= 0;
						gubun4 = "2";
						s_cnt=1;
					} 
			%>	
				
          <tr> 
             <%if(car_type_cnt==0){%>
             <td align="center" width='70' rowspan='<%=car_type_size6+car_type_user_cnt6%>'><a href="javascript:list_move('0010','','');">광주지점</a></td>
		    <%}%>
             <%if(user_type_cnt==0 && s_cnt == 0  ){%>
             <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0010','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
		    <%}%>	
		     <%if( gubun4.equals("2") && s_cnt == 1 ){%> 
		  	 <td align="center" width="60" height="20">계</td>		  	 
		  	<% } else { %> 
             <td align="center" width="60" height="20"><a href="javascript:list_move('0010','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>       
            <%} %>     
          </tr>
           <%if( gubun4.equals("2") && s_cnt == 1 ){%> 		   
          <tr>         
		 	 <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0010','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
			 <td align="center" width="60" height="20"><a href="javascript:list_move('0010','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>   
		  </tr>     
		  <% } %>  
     	 <%			car_type_cnt++;
      				user_type_cnt++;          				       				
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0";
					s_cnt=0;
       
           }%>
          <% if ( buss_10.size() > 0 ){%> 	 	
          <tr> 
           	 <td align="center" width="60" height="20">계</td>
          </tr>
          <% } %> 
          <tr> 
            <td class="title" align="center"  colspan=3  height="20">소합계</td>            
          </tr>                    
                               
                         <%	car_type_cnt = 0;
           		user_type_size1 = 0;
          		user_type_cnt = 0;
          		s_cnt = 0;
          		chk = "";
          		
          		for(int i = 0 ; i < buss_11.size() ; i++){
					Hashtable ht = (Hashtable)buss_11.elementAt(i);   
						
					if ( i == 0 ) {
			    		chk = String.valueOf(ht.get("BUS_ID"));
			    		gubun4 = "0";	
					}
												
					user_type_size1 =  AddUtil.parseInt(String.valueOf(ht.get("DATA_RN")));
									
					String d_nm1 = "";
					
					if(String.valueOf(ht.get("RENT_WAY")).equals("1")){				d_nm1 = "일반식";	gubun5 = "1";
					}else if(String.valueOf(ht.get("RENT_WAY")).equals("3")){		d_nm1 = "기본식";	gubun5 = "3";					
					}
					
					if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
						user_type_cnt= 0;
						gubun4 = "2";
						s_cnt=1;
					} 
			%>	
				
          <tr> 
             <%if(car_type_cnt==0){%>
             <td align="center" width='70' rowspan='<%=car_type_size7+car_type_user_cnt7%>'><a href="javascript:list_move('0011','','');">대구지점</a></td>
		    <%}%>
             <%if(user_type_cnt==0 && s_cnt == 0  ){%>
             <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0011','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
		    <%}%>	
		     <%if( gubun4.equals("2") && s_cnt == 1 ){%> 
		  	 <td align="center" width="60" height="20">계</td>		  	 
		  	<% } else { %> 
             <td align="center" width="60" height="20"><a href="javascript:list_move('0011','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>       
            <%} %>     
          </tr>
           <%if( gubun4.equals("2") && s_cnt == 1 ){%> 		   
          <tr>         
		 	 <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0011','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
			 <td align="center" width="60" height="20"><a href="javascript:list_move('0011','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>   
		  </tr>     
		  <% } %>  
     	 <%			car_type_cnt++;
      				user_type_cnt++;          				       				
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0";
					s_cnt=0;
       
           }%>
          <% if ( buss_11.size() > 0 ){%> 	 	
          <tr> 
           	 <td align="center" width="60" height="20">계</td>
          </tr>
          <% } %> 
          <tr> 
            <td class="title" align="center"  colspan=3  height="20">소합계</td>            
          </tr>                          
                 
       <%	car_type_cnt = 0;
           		user_type_size1 = 0;
          		user_type_cnt = 0;
          		s_cnt = 0;
          		chk = "";
          		
          		for(int i = 0 ; i < buss_12.size() ; i++){
					Hashtable ht = (Hashtable)buss_12.elementAt(i);   
						
					if ( i == 0 ) {
			    		chk = String.valueOf(ht.get("BUS_ID"));
			    		gubun4 = "0";	
					}
												
					user_type_size1 =  AddUtil.parseInt(String.valueOf(ht.get("DATA_RN")));
									
					String d_nm1 = "";
					
					if(String.valueOf(ht.get("RENT_WAY")).equals("1")){				d_nm1 = "일반식";	gubun5 = "1";
					}else if(String.valueOf(ht.get("RENT_WAY")).equals("3")){		d_nm1 = "기본식";	gubun5 = "3";					
					}
					
					if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
						user_type_cnt= 0;
						gubun4 = "2";
						s_cnt=1;
					} 
			%>	
				
          <tr> 
             <%if(car_type_cnt==0){%>
             <td align="center" width='70' rowspan='<%=car_type_size8+car_type_user_cnt8%>'><a href="javascript:list_move('0012','','');">인천지점</a></td>
		    <%}%>
             <%if(user_type_cnt==0 && s_cnt == 0  ){%>
             <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0012','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
		    <%}%>	
		     <%if( gubun4.equals("2") && s_cnt == 1 ){%> 
		  	 <td align="center" width="60" height="20">계</td>		  	 
		  	<% } else { %> 
             <td align="center" width="60" height="20"><a href="javascript:list_move('0012','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>       
            <%} %>     
          </tr>
           <%if( gubun4.equals("2") && s_cnt == 1 ){%> 		   
          <tr>         
		 	 <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0012','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
			 <td align="center" width="60" height="20"><a href="javascript:list_move('0012','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>   
		  </tr>     
		  <% } %>  
     	 <%			car_type_cnt++;
      				user_type_cnt++;          				       				
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0";
					s_cnt=0;
       
           }%>
          <% if ( buss_12.size() > 0 ){%> 	 	
          <tr> 
           	 <td align="center" width="60" height="20">계</td>
          </tr>
          <% } %> 
          <tr> 
            <td class="title" align="center"  colspan=3  height="20">소합계</td>            
          </tr>    
          
           <%	car_type_cnt = 0;
           		user_type_size1 = 0;
          		user_type_cnt = 0;
          		s_cnt = 0;
          		chk = "";
          		
          		for(int i = 0 ; i < buss_13.size() ; i++){
					Hashtable ht = (Hashtable)buss_13.elementAt(i);   
						
					if ( i == 0 ) {
			    		chk = String.valueOf(ht.get("BUS_ID"));
			    		gubun4 = "0";	
					}
												
					user_type_size1 =  AddUtil.parseInt(String.valueOf(ht.get("DATA_RN")));
									
					String d_nm1 = "";
					
					if(String.valueOf(ht.get("RENT_WAY")).equals("1")){				d_nm1 = "일반식";	gubun5 = "1";
					}else if(String.valueOf(ht.get("RENT_WAY")).equals("3")){		d_nm1 = "기본식";	gubun5 = "3";					
					}
					
					if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
						user_type_cnt= 0;
						gubun4 = "2";
						s_cnt=1;
					} 
			%>	
                                
	
	  <tr> 
             <%if(car_type_cnt==0){%>
             <td align="center" width='70' rowspan='<%=car_type_size9+car_type_user_cnt9%>'><a href="javascript:list_move('0013','','');">수원지점</a></td>
		    <%}%>
             <%if(user_type_cnt==0 && s_cnt == 0  ){%>
             <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0013','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
		    <%}%>	
		     <%if( gubun4.equals("2") && s_cnt == 1 ){%> 
		  	 <td align="center" width="60" height="20">계</td>		  	 
		  	<% } else { %> 
             <td align="center" width="60" height="20"><a href="javascript:list_move('0013','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>       
            <%} %>     
          </tr>
           <%if( gubun4.equals("2") && s_cnt == 1 ){%> 		   
          <tr>         
		 	 <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0013','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
			 <td align="center" width="60" height="20"><a href="javascript:list_move('0013','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>   
		  </tr>     
		  <% } %>  
     	 <%			car_type_cnt++;
      				user_type_cnt++;          				       				
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0";
					s_cnt=0;
       
           }%>
          <% if ( buss_13.size() > 0 ){%> 	 	
          <tr> 
           	 <td align="center" width="60" height="20">계</td>
          </tr>
          <% } %> 
          <tr> 
            <td class="title" align="center"  colspan=3  height="20">소합계</td>            
          </tr>                          
                 
            <%	car_type_cnt = 0;
           		user_type_size1 = 0;
          		user_type_cnt = 0;
          		s_cnt = 0;
          		chk = "";
          		
          		for(int i = 0 ; i < buss_14.size() ; i++){
					Hashtable ht = (Hashtable)buss_14.elementAt(i);   
						
					if ( i == 0 ) {
			    		chk = String.valueOf(ht.get("BUS_ID"));
			    		gubun4 = "0";	
					}
												
					user_type_size1 =  AddUtil.parseInt(String.valueOf(ht.get("DATA_RN")));
									
					String d_nm1 = "";
					
					if(String.valueOf(ht.get("RENT_WAY")).equals("1")){				d_nm1 = "일반식";	gubun5 = "1";
					}else if(String.valueOf(ht.get("RENT_WAY")).equals("3")){		d_nm1 = "기본식";	gubun5 = "3";					
					}
					
					if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
						user_type_cnt= 0;
						gubun4 = "2";
						s_cnt=1;
					} 
			%>	
                                
	
	  <tr> 
             <%if(car_type_cnt==0){%>
             <td align="center" width='70' rowspan='<%=car_type_size10+car_type_user_cnt10%>'><a href="javascript:list_move('0014','','');">강서지점</a></td>
		    <%}%>
             <%if(user_type_cnt==0 && s_cnt == 0  ){%>
             <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0014','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
		    <%}%>	
		     <%if( gubun4.equals("2") && s_cnt == 1 ){%> 
		  	 <td align="center" width="60" height="20">계</td>		  	 
		  	<% } else { %> 
             <td align="center" width="60" height="20"><a href="javascript:list_move('0014','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>       
            <%} %>     
          </tr>
           <%if( gubun4.equals("2") && s_cnt == 1 ){%> 		   
          <tr>         
		 	 <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0014','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
			 <td align="center" width="60" height="20"><a href="javascript:list_move('0014','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>   
		  </tr>     
		  <% } %>  
     	 <%			car_type_cnt++;
      				user_type_cnt++;          				       				
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0";
					s_cnt=0;
       
           }%>
          <% if ( buss_14.size() > 0 ){%> 	 	
          <tr> 
           	 <td align="center" width="60" height="20">계</td>
          </tr>
          <% } %> 
          <tr> 
            <td class="title" align="center"  colspan=3  height="20">소합계</td>            
          </tr>                          
           
             <%	car_type_cnt = 0;
           		user_type_size1 = 0;
          		user_type_cnt = 0;
          		s_cnt = 0;
          		chk = "";
          		
          		for(int i = 0 ; i < buss_15.size() ; i++){
					Hashtable ht = (Hashtable)buss_15.elementAt(i);   
						
					if ( i == 0 ) {
			    		chk = String.valueOf(ht.get("BUS_ID"));
			    		gubun4 = "0";	
					}
												
					user_type_size1 =  AddUtil.parseInt(String.valueOf(ht.get("DATA_RN")));
									
					String d_nm1 = "";
					
					if(String.valueOf(ht.get("RENT_WAY")).equals("1")){				d_nm1 = "일반식";	gubun5 = "1";
					}else if(String.valueOf(ht.get("RENT_WAY")).equals("3")){		d_nm1 = "기본식";	gubun5 = "3";					
					}
					
					if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
						user_type_cnt= 0;
						gubun4 = "2";
						s_cnt=1;
					} 
			%>	
                                
	
	  <tr> 
             <%if(car_type_cnt==0){%>
             <td align="center" width='70' rowspan='<%=car_type_size11+car_type_user_cnt11%>'><a href="javascript:list_move('0015','','');">구로지점</a></td>
		    <%}%>
             <%if(user_type_cnt==0 && s_cnt == 0  ){%>
             <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0015','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
		    <%}%>	
		     <%if( gubun4.equals("2") && s_cnt == 1 ){%> 
		  	 <td align="center" width="60" height="20">계</td>		  	 
		  	<% } else { %> 
             <td align="center" width="60" height="20"><a href="javascript:list_move('0015','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>       
            <%} %>     
          </tr>
           <%if( gubun4.equals("2") && s_cnt == 1 ){%> 		   
          <tr>         
		 	 <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0015','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
			 <td align="center" width="60" height="20"><a href="javascript:list_move('0015','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>   
		  </tr>     
		  <% } %>  
     	 <%			car_type_cnt++;
      				user_type_cnt++;          				       				
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0";
					s_cnt=0;
       
           }%>
          <% if ( buss_15.size() > 0 ){%> 	 	
          <tr> 
           	 <td align="center" width="60" height="20">계</td>
          </tr>
          <% } %> 
          <tr> 
            <td class="title" align="center"  colspan=3  height="20">소합계</td>            
          </tr>                                 
                 
                <%	car_type_cnt = 0;
           		user_type_size1 = 0;
          		user_type_cnt = 0;
          		s_cnt = 0;
          		chk = "";
          		
          		for(int i = 0 ; i < buss_16.size() ; i++){
					Hashtable ht = (Hashtable)buss_16.elementAt(i);   
						
					if ( i == 0 ) {
			    		chk = String.valueOf(ht.get("BUS_ID"));
			    		gubun4 = "0";	
					}
												
					user_type_size1 =  AddUtil.parseInt(String.valueOf(ht.get("DATA_RN")));
									
					String d_nm1 = "";
					
					if(String.valueOf(ht.get("RENT_WAY")).equals("1")){				d_nm1 = "일반식";	gubun5 = "1";
					}else if(String.valueOf(ht.get("RENT_WAY")).equals("3")){		d_nm1 = "기본식";	gubun5 = "3";					
					}
					
					if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
						user_type_cnt= 0;
						gubun4 = "2";
						s_cnt=1;
					} 
			%>	
                                
	
	  <tr> 
             <%if(car_type_cnt==0){%>
             <td align="center" width='70' rowspan='<%=car_type_size12+car_type_user_cnt12%>'><a href="javascript:list_move('0016','','');">울산지점</a></td>
		    <%}%>
             <%if(user_type_cnt==0 && s_cnt == 0  ){%>
             <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0016','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
		    <%}%>	
		     <%if( gubun4.equals("2") && s_cnt == 1 ){%> 
		  	 <td align="center" width="60" height="20">계</td>		  	 
		  	<% } else { %> 
             <td align="center" width="60" height="20"><a href="javascript:list_move('0016','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>       
            <%} %>     
          </tr>
           <%if( gubun4.equals("2") && s_cnt == 1 ){%> 		   
          <tr>         
		 	 <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0016','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
			 <td align="center" width="60" height="20"><a href="javascript:list_move('0016','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>   
		  </tr>     
		  <% } %>  
     	 <%			car_type_cnt++;
      				user_type_cnt++;          				       				
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0";
					s_cnt=0;
       
           }%>
          <% if ( buss_16.size() > 0 ){%> 	 	
          <tr> 
           	 <td align="center" width="60" height="20">계</td>
          </tr>
          <% } %> 
          <tr> 
            <td class="title" align="center"  colspan=3  height="20">소합계</td>            
          </tr>                                       
                 
                      <%	car_type_cnt = 0;
           		user_type_size1 = 0;
          		user_type_cnt = 0;
          		s_cnt = 0;
          		chk = "";
          		
          		for(int i = 0 ; i < buss_17.size() ; i++){
					Hashtable ht = (Hashtable)buss_17.elementAt(i);   
						
					if ( i == 0 ) {
			    		chk = String.valueOf(ht.get("BUS_ID"));
			    		gubun4 = "0";	
					}
												
					user_type_size1 =  AddUtil.parseInt(String.valueOf(ht.get("DATA_RN")));
									
					String d_nm1 = "";
					
					if(String.valueOf(ht.get("RENT_WAY")).equals("1")){				d_nm1 = "일반식";	gubun5 = "1";
					}else if(String.valueOf(ht.get("RENT_WAY")).equals("3")){		d_nm1 = "기본식";	gubun5 = "3";					
					}
					
					if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
						user_type_cnt= 0;
						gubun4 = "2";
						s_cnt=1;
					} 
			%>	
                                
	
	  <tr> 
             <%if(car_type_cnt==0){%>
             <td align="center" width='70' rowspan='<%=car_type_size13+car_type_user_cnt13%>'><a href="javascript:list_move('0017','','');">광화문지점</a></td>
		    <%}%>
             <%if(user_type_cnt==0 && s_cnt == 0  ){%>
             <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0017','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
		    <%}%>	
		     <%if( gubun4.equals("2") && s_cnt == 1 ){%> 
		  	 <td align="center" width="60" height="20">계</td>		  	 
		  	<% } else { %> 
             <td align="center" width="60" height="20"><a href="javascript:list_move('0017','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>       
            <%} %>     
          </tr>
           <%if( gubun4.equals("2") && s_cnt == 1 ){%> 		   
          <tr>         
		 	 <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0017','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
			 <td align="center" width="60" height="20"><a href="javascript:list_move('0017','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>   
		  </tr>     
		  <% } %>  
     	 <%			car_type_cnt++;
      				user_type_cnt++;          				       				
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0";
					s_cnt=0;
       
           }%>
          <% if ( buss_17.size() > 0 ){%> 	 	
          <tr> 
           	 <td align="center" width="60" height="20">계</td>
          </tr>
          <% } %> 
          <tr> 
            <td class="title" align="center"  colspan=3  height="20">소합계</td>            
          </tr>                                              
                 
              <%	car_type_cnt = 0;
           		user_type_size1 = 0;
          		user_type_cnt = 0;
          		s_cnt = 0;
          		chk = "";
          		
          		for(int i = 0 ; i < buss_18.size() ; i++){
					Hashtable ht = (Hashtable)buss_18.elementAt(i);   
						
					if ( i == 0 ) {
			    		chk = String.valueOf(ht.get("BUS_ID"));
			    		gubun4 = "0";	
					}
												
					user_type_size1 =  AddUtil.parseInt(String.valueOf(ht.get("DATA_RN")));
									
					String d_nm1 = "";
					
					if(String.valueOf(ht.get("RENT_WAY")).equals("1")){				d_nm1 = "일반식";	gubun5 = "1";
					}else if(String.valueOf(ht.get("RENT_WAY")).equals("3")){		d_nm1 = "기본식";	gubun5 = "3";					
					}
					
					if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
						user_type_cnt= 0;
						gubun4 = "2";
						s_cnt=1;
					} 
			%>	
                                
	
	  <tr> 
             <%if(car_type_cnt==0){%>
             <td align="center" width='70' rowspan='<%=car_type_size14+car_type_user_cnt14%>'><a href="javascript:list_move('0018','','');">송파지점</a></td>
		    <%}%>
             <%if(user_type_cnt==0 && s_cnt == 0  ){%>
             <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0018','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
		    <%}%>	
		     <%if( gubun4.equals("2") && s_cnt == 1 ){%> 
		  	 <td align="center" width="60" height="20">계</td>		  	 
		  	<% } else { %> 
             <td align="center" width="60" height="20"><a href="javascript:list_move('0018','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>       
            <%} %>     
          </tr>
           <%if( gubun4.equals("2") && s_cnt == 1 ){%> 		   
          <tr>         
		 	 <td align="center" width='50' rowspan='<%=user_type_size1+1%>'><a href="javascript:list_move('0018','<%=ht.get("BUS_ID")%>','');"><%=ht.get("USER_NM")%></a></td>
			 <td align="center" width="60" height="20"><a href="javascript:list_move('0018','<%=ht.get("BUS_ID")%>','<%=gubun5%>');"><%=d_nm1%></a></td>   
		  </tr>     
		  <% } %>  
     	 <%			car_type_cnt++;
      				user_type_cnt++;          				       				
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0";
					s_cnt=0;
       
           }%>
          <% if ( buss_18.size() > 0 ){%> 	 	
          <tr> 
           	 <td align="center" width="60" height="20">계</td>
          </tr>
          <% } %> 
          <tr> 
            <td class="title" align="center"  colspan=3  height="20">소합계</td>            
          </tr>                                                     
                 
          <tr> 
            <td class="title_p" align="center"  colspan=3  height="20">총합계</td>
          
          </tr>
        </table></td>
        
	<td class='line' width='900'>
	    <table border="0" cellspacing="1" cellpadding="0" width='900'>
          <%
            chk = "";
            gubun4 = "";            
            
          	for(int i = 0 ; i < buss_1.size() ; i++){
					Hashtable ht = (Hashtable)buss_1.elementAt(i);   
						
					if ( i == 0 ) {
				    	chk = String.valueOf(ht.get("BUS_ID"));
				    	gubun4 = "0";
					}
										
					if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
						gubun4 = "2";
					} 		
					
					for (int j = 0 ; j < 8 ; j++){	
						cnt1[j] = AddUtil.parseInt((String)ht.get("CNT"+(j))); 		
					}
											 
					cnt1[8] = cnt1[0]+ cnt1[2]+ cnt1[4]+ cnt1[6]; 	
					cnt1[9] = cnt1[1]+ cnt1[3]+ cnt1[5]+ cnt1[7];																										
		           									
		  %>
		  <%if(gubun4.equals("2")  ){%> 
           <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt1[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt1[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt1[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt1[8]))*100,1)%></td>        				
            <td align="right" height="20" width="60"><%=sub_cnt1[0]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt1[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt1[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt1[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt1[2]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt1[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt1[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt1[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt1[4]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt1[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt1[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt1[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt1[6]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt1[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt1[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt1[6]))*100,1)%></td>    																											
           </tr>
          <% }   %>	
          <%if(gubun4.equals("2")  ) { 		
          
          		for (int j = 0 ; j < 10 ; j++){													
					sub_cnt1[j] = 0;								
				}	
			
           } %>
          <tr> 
            <td align="right" height="20" width="60"><%=cnt1[8]%></td>
            <td align="right" height="20" width="60"><%=cnt1[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt1[9]))/AddUtil.parseFloat(String.valueOf(cnt1[8]))*100,1)%></td>         		
            <td align="right" height="20" width="60"><%=cnt1[0]%></td>
            <td align="right" height="20" width="60"><%=cnt1[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt1[1]))/AddUtil.parseFloat(String.valueOf(cnt1[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=cnt1[2]%></td>
            <td align="right" height="20" width="60"><%=cnt1[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt1[3]))/AddUtil.parseFloat(String.valueOf(cnt1[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt1[4]%></td>
            <td align="right" height="20" width="60"><%=cnt1[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt1[5]))/AddUtil.parseFloat(String.valueOf(cnt1[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=cnt1[6]%></td>
            <td align="right" height="20" width="60"><%=cnt1[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt1[7]))/AddUtil.parseFloat(String.valueOf(cnt1[6]))*100,1)%></td>    																															
          </tr>
                                       
          <%	
          			for (int j = 0 ; j < 8 ; j++){													 																			
						sub_cnt1[j] = sub_cnt1[j] + cnt1[j];
						t_cnt1[j] = t_cnt1[j] + cnt1[j];
						g_cnt[j] = g_cnt[j] + cnt1[j];																
					}
					
          			sub_cnt1[8] = sub_cnt1[8]+ cnt1[8]; 	
					sub_cnt1[9] = sub_cnt1[9]+ cnt1[9];	
					
					t_cnt1[8] = t_cnt1[8]+ cnt1[8]; 	
					t_cnt1[9] = t_cnt1[9]+ cnt1[9];	
					
					g_cnt[8] = g_cnt[8]+ cnt1[8]; 	
					g_cnt[9] = g_cnt[9]+ cnt1[9];	
					        
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0";				
					   
			 } %>
		
		 <% if ( buss_1.size() > 0 ){%> 
		   <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt1[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt1[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt1[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt1[8]))*100,1)%></td>        				
            <td align="right" height="20" width="60"><%=sub_cnt1[0]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt1[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt1[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt1[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt1[2]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt1[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt1[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt1[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt1[4]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt1[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt1[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt1[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt1[6]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt1[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt1[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt1[6]))*100,1)%></td>    																											
           </tr>
           			 
         <% } %>          		
         <tr> 
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt1[8]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt1[9]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt1[9]))/AddUtil.parseFloat(String.valueOf(t_cnt1[8]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt1[0]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt1[1]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt1[1]))/AddUtil.parseFloat(String.valueOf(t_cnt1[0]))*100,1)%></td>		
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt1[2]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt1[3]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt1[3]))/AddUtil.parseFloat(String.valueOf(t_cnt1[2]))*100,1)%></td>	
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt1[4]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt1[5]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt1[5]))/AddUtil.parseFloat(String.valueOf(t_cnt1[4]))*100,1)%></td>			
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt1[6]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt1[7]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt1[7]))/AddUtil.parseFloat(String.valueOf(t_cnt1[6]))*100,1)%></td>	
        																																
          </tr>
          <%
          		chk = "";
          		gubun4 = "";
          	            		 
          		for(int i = 0 ; i < buss_2.size() ; i++){
					Hashtable ht = (Hashtable)buss_2.elementAt(i);   
						
						if ( i == 0 ) {
					    	chk = String.valueOf(ht.get("BUS_ID"));
					    	gubun4 = "0";
						}
											
						if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
							gubun4 = "2";
						} 		
				
						for (int j = 0 ; j < 8 ; j++){	
							cnt2[j] = AddUtil.parseInt((String)ht.get("CNT"+(j))); 		
						}
											 
						cnt2[8] = cnt2[0]+ cnt2[2]+ cnt2[4]+ cnt2[6]; 	
						cnt2[9] = cnt2[1]+ cnt2[3]+ cnt2[5]+ cnt2[7];														
						
		  %>
		   <%if(gubun4.equals("2")  ){%> 
           <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt2[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt2[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt2[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt2[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt2[0]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt2[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt2[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt2[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt2[2]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt2[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt2[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt2[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt2[4]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt2[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt2[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt2[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt2[6]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt2[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt2[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt2[6]))*100,1)%></td>    																											
           </tr>
          <% }   %>	
          <%if(gubun4.equals("2")  ) { 		
          
       		    for (int j = 0 ; j < 10 ; j++){													
					sub_cnt2[j] = 0;								
				}	
           } %>		
          <tr> 
            <td align="right" height="20" width="60"><%=cnt2[8]%></td>
            <td align="right" height="20" width="60"><%=cnt2[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt2[9]))/AddUtil.parseFloat(String.valueOf(cnt2[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=cnt2[0]%></td>
            <td align="right" height="20" width="60"><%=cnt2[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt2[1]))/AddUtil.parseFloat(String.valueOf(cnt2[0]))*100,1)%></td>				
            <td align="right" height="20" width="60"><%=cnt2[2]%></td>
            <td align="right" height="20" width="60"><%=cnt2[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt2[3]))/AddUtil.parseFloat(String.valueOf(cnt2[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt2[4]%></td>
            <td align="right" height="20" width="60"><%=cnt2[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt2[5]))/AddUtil.parseFloat(String.valueOf(cnt2[4]))*100,1)%></td>																				
            <td align="right" height="20" width="60"><%=cnt2[6]%></td>
            <td align="right" height="20" width="60"><%=cnt2[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt2[6]))/AddUtil.parseFloat(String.valueOf(cnt2[6]))*100,1)%></td>		
          																																
          </tr>
          <%		
          			for (int j = 0 ; j < 8 ; j++){													 																			
						sub_cnt2[j] = sub_cnt2[j] + cnt2[j];
						t_cnt2[j] = t_cnt2[j] + cnt2[j];
						g_cnt[j] = g_cnt[j] + cnt2[j];																
					}
					
          			sub_cnt2[8] = sub_cnt2[8]+ cnt2[8]; 	
					sub_cnt2[9] = sub_cnt2[9]+ cnt2[9];	
					
					t_cnt2[8] = t_cnt2[8]+ cnt2[8]; 	
					t_cnt2[9] = t_cnt2[9]+ cnt2[9];	
					
					g_cnt[8] = g_cnt[8]+ cnt2[8]; 	
					g_cnt[9] = g_cnt[9]+ cnt2[9];	
															
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0"; 					
					
			} %>
		 <% if ( buss_2.size() > 0 ){%> 	
		  <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt2[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt2[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt2[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt2[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt2[0]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt2[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt2[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt2[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt2[2]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt2[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt2[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt2[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt2[4]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt2[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt2[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt2[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt2[6]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt2[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt2[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt2[6]))*100,1)%></td>    																											
           </tr>
          <% } %>	
          <tr> 
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt2[8]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt2[9]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt2[9]))/AddUtil.parseFloat(String.valueOf(t_cnt2[8]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt2[0]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt2[1]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt2[1]))/AddUtil.parseFloat(String.valueOf(t_cnt2[0]))*100,1)%></td>	
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt2[2]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt2[3]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt2[3]))/AddUtil.parseFloat(String.valueOf(t_cnt2[2]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt2[4]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt2[5]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt2[5]))/AddUtil.parseFloat(String.valueOf(t_cnt2[4]))*100,1)%></td>	
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt2[6]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt2[7]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt2[7]))/AddUtil.parseFloat(String.valueOf(t_cnt2[6]))*100,1)%></td>
         																																			
          </tr>
          
           <%    
           	 chk = "";
             gubun4 = "";
          	            
           	 for(int i = 0 ; i < buss_7.size() ; i++){
					Hashtable ht = (Hashtable)buss_7.elementAt(i);   
						
						if ( i == 0 ) {
					    	chk = String.valueOf(ht.get("BUS_ID"));
					    	gubun4 = "0";
						}
											
						if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
							gubun4 = "2";
						} 
						
						for (int j = 0 ; j < 8 ; j++){	
							cnt3[j] = AddUtil.parseInt((String)ht.get("CNT"+(j))); 		
						}
											 
						cnt3[8] = cnt3[0]+ cnt3[2]+ cnt3[4]+ cnt3[6]; 	
						cnt3[9] = cnt3[1]+ cnt3[3]+ cnt3[5]+ cnt3[7];									
											
		  %>
		   <%if(gubun4.equals("2")  ){%> 
           <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt3[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt3[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt3[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt3[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt3[0]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt3[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt3[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt3[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt3[2]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt3[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt3[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt3[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt3[4]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt3[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt3[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt3[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt3[6]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt3[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt3[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt3[6]))*100,1)%></td>    																											
           </tr>
          <% }   %>	
          <%if(gubun4.equals("2")  ) { 		
       		    for (int j = 0 ; j < 10 ; j++){													
					sub_cnt3[j] = 0;								
				}	
           } %>						
          <tr> 
            <td align="right" height="20" width="60"><%=cnt3[8]%></td>
            <td align="right" height="20" width="60"><%=cnt3[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt3[9]))/AddUtil.parseFloat(String.valueOf(cnt3[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=cnt3[0]%></td>
            <td align="right" height="20" width="60"><%=cnt3[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt3[1]))/AddUtil.parseFloat(String.valueOf(cnt3[0]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt3[2]%></td>
            <td align="right" height="20" width="60"><%=cnt3[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt3[3]))/AddUtil.parseFloat(String.valueOf(cnt3[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt3[4]%></td>
            <td align="right" height="20" width="60"><%=cnt3[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt3[5]))/AddUtil.parseFloat(String.valueOf(cnt3[4]))*100,1)%></td>																				
            <td align="right" height="20" width="60"><%=cnt3[6]%></td>
            <td align="right" height="20" width="60"><%=cnt3[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt3[7]))/AddUtil.parseFloat(String.valueOf(cnt3[6]))*100,1)%></td>		          																																
          </tr>
                              
          <%		
					for (int j = 0 ; j < 8 ; j++){													 																			
						sub_cnt3[j] = sub_cnt3[j] + cnt3[j];
						t_cnt3[j] = t_cnt3[j] + cnt3[j];
						g_cnt[j] = g_cnt[j] + cnt3[j];																
					}
					
          			sub_cnt3[8] = sub_cnt3[8]+ cnt3[8]; 	
					sub_cnt3[9] = sub_cnt3[9]+ cnt3[9];	
					
					t_cnt3[8] = t_cnt3[8]+ cnt3[8]; 	
					t_cnt3[9] = t_cnt3[9]+ cnt3[9];	
					
					g_cnt[8] = g_cnt[8]+ cnt3[8]; 	
					g_cnt[9] = g_cnt[9]+ cnt3[9];	
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0"; 					
					
			 } %>
		
		  <% if ( buss_7.size() > 0 ){%> 	
		  <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt3[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt3[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt3[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt3[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt3[0]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt3[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt3[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt3[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt3[2]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt3[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt3[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt3[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt3[4]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt3[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt3[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt3[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt3[6]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt3[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt3[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt3[6]))*100,1)%></td>    																											
           </tr>
		  <% } %>	
          <tr> 
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt3[8]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt3[9]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt3[9]))/AddUtil.parseFloat(String.valueOf(t_cnt3[8]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt3[0]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt3[1]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt3[1]))/AddUtil.parseFloat(String.valueOf(t_cnt3[0]))*100,1)%></td>	
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt3[2]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt3[3]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt3[3]))/AddUtil.parseFloat(String.valueOf(t_cnt3[2]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt3[4]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt3[5]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt3[5]))/AddUtil.parseFloat(String.valueOf(t_cnt3[4]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt3[6]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt3[7]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt3[7]))/AddUtil.parseFloat(String.valueOf(t_cnt3[6]))*100,1)%></td>
         																																			
          </tr>
          
            <%
				chk = "";
                gubun4 = "";          	   
          	             
            	for(int i = 0 ; i < buss_8.size() ; i++){
					Hashtable ht = (Hashtable)buss_8.elementAt(i);   
						
						if ( i == 0 ) {
					    	chk = String.valueOf(ht.get("BUS_ID"));
					    	gubun4 = "0";
						}
											
						if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
							gubun4 = "2";
						} 		
								
						for (int j = 0 ; j < 8 ; j++){	
							cnt4[j] = AddUtil.parseInt((String)ht.get("CNT"+(j))); 		
						}
											 
						cnt4[8] = cnt4[0]+ cnt4[2]+ cnt4[4]+ cnt4[6]; 	
						cnt4[9] = cnt4[1]+ cnt4[3]+ cnt4[5]+ cnt4[7];			
						
		  %>
		  <%if(gubun4.equals("2")  ){%> 
            <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt4[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt4[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt4[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt4[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt4[0]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt4[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt4[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt4[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt4[2]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt4[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt4[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt4[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt4[4]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt4[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt4[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt4[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt4[6]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt4[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt4[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt4[6]))*100,1)%></td>    																											
           </tr>
          <% } %>	
          <%if(gubun4.equals("2")  ) { 		
       		    for (int j = 0 ; j < 10 ; j++){													
					sub_cnt4[j] = 0;								
				}	
           } %>							
          <tr> 
            <td align="right" height="20" width="60"><%=cnt4[8]%></td>
            <td align="right" height="20" width="60"><%=cnt4[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt4[9]))/AddUtil.parseFloat(String.valueOf(cnt4[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=cnt4[0]%></td>
            <td align="right" height="20" width="60"><%=cnt4[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt4[1]))/AddUtil.parseFloat(String.valueOf(cnt4[0]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt4[2]%></td>
            <td align="right" height="20" width="60"><%=cnt4[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt4[3]))/AddUtil.parseFloat(String.valueOf(cnt4[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt4[4]%></td>
            <td align="right" height="20" width="60"><%=cnt4[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt4[5]))/AddUtil.parseFloat(String.valueOf(cnt4[4]))*100,1)%></td>																				
            <td align="right" height="20" width="60"><%=cnt4[6]%></td>
            <td align="right" height="20" width="60"><%=cnt4[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt4[7]))/AddUtil.parseFloat(String.valueOf(cnt4[6]))*100,1)%></td>		
          																																
          </tr>
                              
          <%		
					for (int j = 0 ; j < 8 ; j++){													 																			
						sub_cnt4[j] = sub_cnt4[j] + cnt4[j];
						t_cnt4[j] = t_cnt4[j] + cnt4[j];
						g_cnt[j] = g_cnt[j] + cnt4[j];																
					}
					
          			sub_cnt4[8] = sub_cnt4[8]+ cnt4[8]; 	
					sub_cnt4[9] = sub_cnt4[9]+ cnt4[9];	
					
					t_cnt4[8] = t_cnt4[8]+ cnt4[8]; 	
					t_cnt4[9] = t_cnt4[9]+ cnt4[9];	
					
					g_cnt[8] = g_cnt[8]+ cnt4[8]; 	
					g_cnt[9] = g_cnt[9]+ cnt4[9];	
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0"; 					
					
			} %>
		   <% if ( buss_8.size() > 0 ){%> 	
		   <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt4[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt4[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt4[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt4[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt4[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt4[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt4[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt4[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt4[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt4[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt4[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt4[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt4[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt4[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt4[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt4[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt4[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt4[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt4[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt4[6]))*100,1)%></td>    																											
           </tr>
		  <% } %>	 
          <tr> 
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt4[8]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt4[9]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt4[9]))/AddUtil.parseFloat(String.valueOf(t_cnt4[8]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt4[0]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt4[1]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt4[1]))/AddUtil.parseFloat(String.valueOf(t_cnt4[0]))*100,1)%></td>	
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt4[2]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt4[3]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt4[3]))/AddUtil.parseFloat(String.valueOf(t_cnt4[2]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt4[4]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt4[5]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt4[5]))/AddUtil.parseFloat(String.valueOf(t_cnt4[4]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt4[6]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt4[7]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt4[7]))/AddUtil.parseFloat(String.valueOf(t_cnt4[6]))*100,1)%></td>
         																																			
          </tr>  
          
        <!-- 강남지점 -->  
             <%
				chk = "";
                gubun4 = "";          	   
          	             
            	for(int i = 0 ; i < buss_9.size() ; i++){
					Hashtable ht = (Hashtable)buss_9.elementAt(i);   
						
						if ( i == 0 ) {
					    	chk = String.valueOf(ht.get("BUS_ID"));
					    	gubun4 = "0";
						}
											
						if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
							gubun4 = "2";
						} 		
								
						for (int j = 0 ; j < 8 ; j++){	
							cnt5[j] = AddUtil.parseInt((String)ht.get("CNT"+(j))); 		
						}
											 
						cnt5[8] = cnt5[0]+ cnt5[2]+ cnt5[4]+ cnt5[6]; 	
						cnt5[9] = cnt5[1]+ cnt5[3]+ cnt5[5]+ cnt5[7];			
						
		  %>
		  <%if(gubun4.equals("2")  ){%> 
            <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt5[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt5[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt5[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt5[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt5[0]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt5[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt5[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt5[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt5[2]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt5[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt5[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt5[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt5[4]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt5[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt5[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt5[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt5[6]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt5[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt5[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt5[6]))*100,1)%></td>    																											
           </tr>
          <% } %>	
          <%if(gubun4.equals("2")  ) { 		
       		    for (int j = 0 ; j < 10 ; j++){													
					sub_cnt5[j] = 0;								
				}	
           } %>							
          <tr> 
            <td align="right" height="20" width="60"><%=cnt5[8]%></td>
            <td align="right" height="20" width="60"><%=cnt5[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt5[9]))/AddUtil.parseFloat(String.valueOf(cnt5[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=cnt5[0]%></td>
            <td align="right" height="20" width="60"><%=cnt5[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt5[1]))/AddUtil.parseFloat(String.valueOf(cnt5[0]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt5[2]%></td>
            <td align="right" height="20" width="60"><%=cnt5[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt5[3]))/AddUtil.parseFloat(String.valueOf(cnt5[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt5[4]%></td>
            <td align="right" height="20" width="60"><%=cnt5[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt5[5]))/AddUtil.parseFloat(String.valueOf(cnt5[4]))*100,1)%></td>																				
            <td align="right" height="20" width="60"><%=cnt5[6]%></td>
            <td align="right" height="20" width="60"><%=cnt5[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt5[7]))/AddUtil.parseFloat(String.valueOf(cnt5[6]))*100,1)%></td>		
          																																
          </tr>
                              
          <%		
					for (int j = 0 ; j < 8 ; j++){													 																			
						sub_cnt5[j] = sub_cnt5[j] + cnt5[j];
						t_cnt5[j] = t_cnt5[j] + cnt5[j];
						g_cnt[j] = g_cnt[j] + cnt5[j];																
					}
					
          				sub_cnt5[8] = sub_cnt5[8]+ cnt5[8]; 	
					sub_cnt5[9] = sub_cnt5[9]+ cnt5[9];	
					
					t_cnt5[8] = t_cnt5[8]+ cnt5[8]; 	
					t_cnt5[9] = t_cnt5[9]+ cnt5[9];	
					
					g_cnt[8] = g_cnt[8]+ cnt5[8]; 	
					g_cnt[9] = g_cnt[9]+ cnt5[9];	
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0"; 					
					
			} %>
		   <% if ( buss_9.size() > 0 ){%> 	
		   <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt5[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt5[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt5[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt5[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt5[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt5[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt5[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt5[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt5[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt5[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt5[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt5[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt5[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt5[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt5[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt5[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt5[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt5[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt5[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt5[6]))*100,1)%></td>    																											
           </tr>
		  <% } %>	 
          <tr> 
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt5[8]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt5[9]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt5[9]))/AddUtil.parseFloat(String.valueOf(t_cnt5[8]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt5[0]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt5[1]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt5[1]))/AddUtil.parseFloat(String.valueOf(t_cnt5[0]))*100,1)%></td>	
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt5[2]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt5[3]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt5[3]))/AddUtil.parseFloat(String.valueOf(t_cnt5[2]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt5[4]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt5[5]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt5[5]))/AddUtil.parseFloat(String.valueOf(t_cnt5[4]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt5[6]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt5[7]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt5[7]))/AddUtil.parseFloat(String.valueOf(t_cnt5[6]))*100,1)%></td>
         																																			
          </tr>  
                 
                    <!-- 광주지점 -->  
             <%
				chk = "";
                gubun4 = "";          	   
          	             
            	for(int i = 0 ; i < buss_10.size() ; i++){
					Hashtable ht = (Hashtable)buss_10.elementAt(i);   
						
						if ( i == 0 ) {
					    	chk = String.valueOf(ht.get("BUS_ID"));
					    	gubun4 = "0";
						}
											
						if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
							gubun4 = "2";
						} 		
								
						for (int j = 0 ; j < 8 ; j++){	
							cnt6[j] = AddUtil.parseInt((String)ht.get("CNT"+(j))); 		
						}
											 
						cnt6[8] = cnt6[0]+ cnt6[2]+ cnt6[4]+ cnt6[6]; 	
						cnt6[9] = cnt6[1]+ cnt6[3]+ cnt6[5]+ cnt6[7];			
						
		  %>
		  <%if(gubun4.equals("2")  ){%> 
            <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt6[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt6[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt6[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt6[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt6[0]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt6[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt6[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt6[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt6[2]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt6[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt6[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt6[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt6[4]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt6[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt6[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt6[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt6[6]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt6[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt6[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt6[6]))*100,1)%></td>    																											
           </tr>
          <% } %>	
          <%if(gubun4.equals("2")  ) { 		
       		    for (int j = 0 ; j < 10 ; j++){													
					sub_cnt6[j] = 0;								
				}	
           } %>							
          <tr> 
            <td align="right" height="20" width="60"><%=cnt6[8]%></td>
            <td align="right" height="20" width="60"><%=cnt6[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt6[9]))/AddUtil.parseFloat(String.valueOf(cnt6[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=cnt6[0]%></td>
            <td align="right" height="20" width="60"><%=cnt6[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt6[1]))/AddUtil.parseFloat(String.valueOf(cnt6[0]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt6[2]%></td>
            <td align="right" height="20" width="60"><%=cnt6[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt6[3]))/AddUtil.parseFloat(String.valueOf(cnt6[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt6[4]%></td>
            <td align="right" height="20" width="60"><%=cnt6[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt6[5]))/AddUtil.parseFloat(String.valueOf(cnt6[4]))*100,1)%></td>																				
            <td align="right" height="20" width="60"><%=cnt6[6]%></td>
            <td align="right" height="20" width="60"><%=cnt6[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt6[7]))/AddUtil.parseFloat(String.valueOf(cnt6[6]))*100,1)%></td>		
          																																
          </tr>
                              
          <%		
					for (int j = 0 ; j < 8 ; j++){													 																			
						sub_cnt6[j] = sub_cnt6[j] + cnt6[j];
						t_cnt6[j] = t_cnt6[j] + cnt6[j];
						g_cnt[j] = g_cnt[j] + cnt6[j];																
					}
					
          				sub_cnt6[8] = sub_cnt6[8]+ cnt6[8]; 	
					sub_cnt6[9] = sub_cnt6[9]+ cnt6[9];	
					
					t_cnt6[8] = t_cnt6[8]+ cnt6[8]; 	
					t_cnt6[9] = t_cnt6[9]+ cnt6[9];	
					
					g_cnt[8] = g_cnt[8]+ cnt6[8]; 	
					g_cnt[9] = g_cnt[9]+ cnt6[9];	
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0"; 					
					
			} %>
		   <% if ( buss_10.size() > 0 ){%> 	
		   <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt6[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt6[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt6[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt6[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt6[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt6[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt6[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt6[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt6[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt6[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt6[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt6[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt6[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt6[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt6[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt6[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt6[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt6[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt6[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt6[6]))*100,1)%></td>    																											
           </tr>
		  <% } %>	 
          <tr> 
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt6[8]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt6[9]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt6[9]))/AddUtil.parseFloat(String.valueOf(t_cnt6[8]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt6[0]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt6[1]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt6[1]))/AddUtil.parseFloat(String.valueOf(t_cnt6[0]))*100,1)%></td>	
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt6[2]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt6[3]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt6[3]))/AddUtil.parseFloat(String.valueOf(t_cnt6[2]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt6[4]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt6[5]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt6[5]))/AddUtil.parseFloat(String.valueOf(t_cnt6[4]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt6[6]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt6[7]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt6[7]))/AddUtil.parseFloat(String.valueOf(t_cnt6[6]))*100,1)%></td>
         																																			
          </tr>      
                    
                      <!-- 대구지점 -->  
             <%
				chk = "";
                gubun4 = "";          	   
          	             
            	for(int i = 0 ; i < buss_11.size() ; i++){
					Hashtable ht = (Hashtable)buss_11.elementAt(i);   
						
						if ( i == 0 ) {
					    	chk = String.valueOf(ht.get("BUS_ID"));
					    	gubun4 = "0";
						}
											
						if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
							gubun4 = "2";
						} 		
								
						for (int j = 0 ; j < 8 ; j++){	
							cnt7[j] = AddUtil.parseInt((String)ht.get("CNT"+(j))); 		
						}
											 
						cnt7[8] = cnt7[0]+ cnt7[2]+ cnt7[4]+ cnt7[6]; 	
						cnt7[9] = cnt7[1]+ cnt7[3]+ cnt7[5]+ cnt7[7];			
						
		  %>
		  <%if(gubun4.equals("2")  ){%> 
            <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt7[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt7[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt7[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt7[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt7[0]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt7[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt7[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt7[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt7[2]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt7[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt7[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt7[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt7[4]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt7[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt7[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt7[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt7[6]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt7[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt7[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt7[6]))*100,1)%></td>    																											
           </tr>
          <% } %>	
          <%if(gubun4.equals("2")  ) { 		
       		    for (int j = 0 ; j < 10 ; j++){													
					sub_cnt6[j] = 0;								
				}	
           } %>							
          <tr> 
            <td align="right" height="20" width="60"><%=cnt7[8]%></td>
            <td align="right" height="20" width="60"><%=cnt7[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt7[9]))/AddUtil.parseFloat(String.valueOf(cnt7[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=cnt7[0]%></td>
            <td align="right" height="20" width="60"><%=cnt7[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt7[1]))/AddUtil.parseFloat(String.valueOf(cnt7[0]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt7[2]%></td>
            <td align="right" height="20" width="60"><%=cnt7[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt7[3]))/AddUtil.parseFloat(String.valueOf(cnt7[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt7[4]%></td>
            <td align="right" height="20" width="60"><%=cnt7[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt7[5]))/AddUtil.parseFloat(String.valueOf(cnt7[4]))*100,1)%></td>																				
            <td align="right" height="20" width="60"><%=cnt7[6]%></td>
            <td align="right" height="20" width="60"><%=cnt7[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt7[7]))/AddUtil.parseFloat(String.valueOf(cnt7[6]))*100,1)%></td>		
          																																
          </tr>
                              
          <%		
					for (int j = 0 ; j < 8 ; j++){													 																			
						sub_cnt7[j] = sub_cnt7[j] + cnt7[j];
						t_cnt7[j] = t_cnt7[j] + cnt7[j];
						g_cnt[j] = g_cnt[j] + cnt7[j];																
					}
					
          				sub_cnt7[8] = sub_cnt7[8]+ cnt7[8]; 	
					sub_cnt7[9] = sub_cnt7[9]+ cnt7[9];	
					
					t_cnt7[8] = t_cnt7[8]+ cnt7[8]; 	
					t_cnt7[9] = t_cnt7[9]+ cnt7[9];	
					
					g_cnt[8] = g_cnt[8]+ cnt7[8]; 	
					g_cnt[9] = g_cnt[9]+ cnt7[9];	
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0"; 					
					
			} %>
		   <% if ( buss_11.size() > 0 ){%> 	
		   <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt7[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt7[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt7[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt7[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt7[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt7[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt7[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt7[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt7[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt7[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt7[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt7[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt7[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt7[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt7[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt7[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt7[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt7[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt7[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt7[6]))*100,1)%></td>    																											
           </tr>
		  <% } %>	 
          <tr> 
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt7[8]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt7[9]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt7[9]))/AddUtil.parseFloat(String.valueOf(t_cnt7[8]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt7[0]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt7[1]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt7[1]))/AddUtil.parseFloat(String.valueOf(t_cnt7[0]))*100,1)%></td>	
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt7[2]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt7[3]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt7[3]))/AddUtil.parseFloat(String.valueOf(t_cnt7[2]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt7[4]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt7[5]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt7[5]))/AddUtil.parseFloat(String.valueOf(t_cnt7[4]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt7[6]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt7[7]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt7[7]))/AddUtil.parseFloat(String.valueOf(t_cnt7[6]))*100,1)%></td>
         																																			
          </tr>      
          
                      <!-- 인천지점 -->  
             <%
				chk = "";
                gubun4 = "";          	   
          	             
            	for(int i = 0 ; i < buss_12.size() ; i++){
					Hashtable ht = (Hashtable)buss_12.elementAt(i);   
						
						if ( i == 0 ) {
					    	chk = String.valueOf(ht.get("BUS_ID"));
					    	gubun4 = "0";
						}
											
						if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
							gubun4 = "2";
						} 		
								
						for (int j = 0 ; j < 8 ; j++){	
							cnt8[j] = AddUtil.parseInt((String)ht.get("CNT"+(j))); 		
						}
											 
						cnt8[8] = cnt8[0]+ cnt8[2]+ cnt8[4]+ cnt8[6]; 	
						cnt8[9] = cnt8[1]+ cnt8[3]+ cnt8[5]+ cnt8[7];			
						
		  %>
		  <%if(gubun4.equals("2")  ){%> 
            <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt8[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt8[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt8[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt8[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt8[0]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt8[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt8[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt8[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt8[2]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt8[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt8[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt8[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt8[4]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt8[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt8[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt8[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt8[6]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt8[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt8[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt8[6]))*100,1)%></td>    																											
           </tr>
          <% } %>	
          <%if(gubun4.equals("2")  ) { 		
       		    for (int j = 0 ; j < 10 ; j++){													
					sub_cnt8[j] = 0;								
				}	
           } %>							
          <tr> 
            <td align="right" height="20" width="60"><%=cnt8[8]%></td>
            <td align="right" height="20" width="60"><%=cnt8[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt8[9]))/AddUtil.parseFloat(String.valueOf(cnt8[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=cnt8[0]%></td>
            <td align="right" height="20" width="60"><%=cnt8[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt8[1]))/AddUtil.parseFloat(String.valueOf(cnt8[0]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt8[2]%></td>
            <td align="right" height="20" width="60"><%=cnt8[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt8[3]))/AddUtil.parseFloat(String.valueOf(cnt8[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt8[4]%></td>
            <td align="right" height="20" width="60"><%=cnt8[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt8[5]))/AddUtil.parseFloat(String.valueOf(cnt8[4]))*100,1)%></td>																				
            <td align="right" height="20" width="60"><%=cnt8[6]%></td>
            <td align="right" height="20" width="60"><%=cnt8[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt8[7]))/AddUtil.parseFloat(String.valueOf(cnt8[6]))*100,1)%></td>		
          																																
          </tr>
                              
          <%		
					for (int j = 0 ; j < 8 ; j++){													 																			
						sub_cnt8[j] = sub_cnt8[j] + cnt8[j];
						t_cnt8[j] = t_cnt8[j] + cnt8[j];
						g_cnt[j] = g_cnt[j] + cnt8[j];																
					}
					
          				sub_cnt8[8] = sub_cnt8[8]+ cnt8[8]; 	
					sub_cnt8[9] = sub_cnt8[9]+ cnt8[9];	
					
					t_cnt8[8] = t_cnt8[8]+ cnt8[8]; 	
					t_cnt8[9] = t_cnt8[9]+ cnt8[9];	
					
					g_cnt[8] = g_cnt[8]+ cnt8[8]; 	
					g_cnt[9] = g_cnt[9]+ cnt8[9];	
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0"; 					
					
			} %>
		   <% if ( buss_12.size() > 0 ){%> 	
		   <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt8[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt8[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt8[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt8[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt8[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt8[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt8[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt8[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt8[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt8[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt8[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt8[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt8[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt8[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt8[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt8[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt8[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt8[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt8[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt8[6]))*100,1)%></td>    																											
           </tr>
		  <% } %>	 
          <tr> 
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt8[8]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt8[9]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt8[9]))/AddUtil.parseFloat(String.valueOf(t_cnt8[8]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt8[0]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt8[1]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt8[1]))/AddUtil.parseFloat(String.valueOf(t_cnt8[0]))*100,1)%></td>	
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt8[2]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt8[3]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt8[3]))/AddUtil.parseFloat(String.valueOf(t_cnt8[2]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt8[4]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt8[5]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt8[5]))/AddUtil.parseFloat(String.valueOf(t_cnt8[4]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt8[6]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt8[7]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt8[7]))/AddUtil.parseFloat(String.valueOf(t_cnt8[6]))*100,1)%></td>
          </tr>      
          
              <!--  수원지점 -->  
             <%
				chk = "";
                gubun4 = "";          	   
          	             
            	for(int i = 0 ; i < buss_13.size() ; i++){
					Hashtable ht = (Hashtable)buss_13.elementAt(i);   
						
						if ( i == 0 ) {
					    	chk = String.valueOf(ht.get("BUS_ID"));
					    	gubun4 = "0";
						}
											
						if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
							gubun4 = "2";
						} 		
								
						for (int j = 0 ; j < 8 ; j++){	
							cnt9[j] = AddUtil.parseInt((String)ht.get("CNT"+(j))); 		
						}
											 
						cnt9[8] = cnt9[0]+ cnt9[2]+ cnt9[4]+ cnt9[6]; 	
						cnt9[9] = cnt9[1]+ cnt9[3]+ cnt9[5]+ cnt9[7];			
						
		  %>
		  <%if(gubun4.equals("2")  ){%> 
            <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt9[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt9[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt9[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt9[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt9[0]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt9[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt9[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt9[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt9[2]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt9[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt9[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt9[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt9[4]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt9[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt9[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt9[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt9[6]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt9[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt9[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt9[6]))*100,1)%></td>    																											
           </tr>
          <% } %>	
          <%if(gubun4.equals("2")  ) { 		
       		    for (int j = 0 ; j < 10 ; j++){													
					sub_cnt9[j] = 0;								
				}	
           } %>							
          <tr> 
            <td align="right" height="20" width="60"><%=cnt9[8]%></td>
            <td align="right" height="20" width="60"><%=cnt9[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt9[9]))/AddUtil.parseFloat(String.valueOf(cnt9[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=cnt9[0]%></td>
            <td align="right" height="20" width="60"><%=cnt9[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt9[1]))/AddUtil.parseFloat(String.valueOf(cnt9[0]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt9[2]%></td>
            <td align="right" height="20" width="60"><%=cnt9[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt9[3]))/AddUtil.parseFloat(String.valueOf(cnt9[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt9[4]%></td>
            <td align="right" height="20" width="60"><%=cnt9[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt9[5]))/AddUtil.parseFloat(String.valueOf(cnt9[4]))*100,1)%></td>																				
            <td align="right" height="20" width="60"><%=cnt9[6]%></td>
            <td align="right" height="20" width="60"><%=cnt9[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt9[7]))/AddUtil.parseFloat(String.valueOf(cnt9[6]))*100,1)%></td>		
          																																
          </tr>
                              
          <%		
					for (int j = 0 ; j < 8 ; j++){													 																			
						sub_cnt9[j] = sub_cnt9[j] + cnt9[j];
						t_cnt9[j] = t_cnt9[j] + cnt9[j];
						g_cnt[j] = g_cnt[j] + cnt9[j];																
					}
					
          				sub_cnt9[8] = sub_cnt9[8]+ cnt9[8]; 	
					sub_cnt9[9] = sub_cnt9[9]+ cnt9[9];	
					
					t_cnt9[8] = t_cnt9[8]+ cnt9[8]; 	
					t_cnt9[9] = t_cnt9[9]+ cnt9[9];	
					
					g_cnt[8] = g_cnt[8]+ cnt9[8]; 	
					g_cnt[9] = g_cnt[9]+ cnt9[9];	
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0"; 					
					
			} %>
		   <% if ( buss_13.size() > 0 ){%> 	
		   <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt9[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt9[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt9[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt9[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt9[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt9[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt9[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt9[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt9[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt9[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt9[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt9[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt9[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt9[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt9[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt9[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt9[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt9[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt9[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt9[6]))*100,1)%></td>    																											
           </tr>
		  <% } %>	 
          <tr> 
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt9[8]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt9[9]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt9[9]))/AddUtil.parseFloat(String.valueOf(t_cnt9[8]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt9[0]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt9[1]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt9[1]))/AddUtil.parseFloat(String.valueOf(t_cnt9[0]))*100,1)%></td>	
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt9[2]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt9[3]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt9[3]))/AddUtil.parseFloat(String.valueOf(t_cnt9[2]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt9[4]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt9[5]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt9[5]))/AddUtil.parseFloat(String.valueOf(t_cnt9[4]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt9[6]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt9[7]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt9[7]))/AddUtil.parseFloat(String.valueOf(t_cnt9[6]))*100,1)%></td>
          </tr>         
          
              <!--  강서지점 -->  
             <%
				chk = "";
                gubun4 = "";          	   
          	             
            	for(int i = 0 ; i < buss_14.size() ; i++){
					Hashtable ht = (Hashtable)buss_14.elementAt(i);   
						
						if ( i == 0 ) {
					    	chk = String.valueOf(ht.get("BUS_ID"));
					    	gubun4 = "0";
						}
											
						if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
							gubun4 = "2";
						} 		
								
						for (int j = 0 ; j < 8 ; j++){	
							cnt10[j] = AddUtil.parseInt((String)ht.get("CNT"+(j))); 		
						}
											 
						cnt10[8] = cnt10[0]+ cnt10[2]+ cnt10[4]+ cnt10[6]; 	
						cnt10[9] = cnt10[1]+ cnt10[3]+ cnt10[5]+ cnt10[7];			
						
		  %>
	  <%if(gubun4.equals("2")  ){%> 
            <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt10[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt10[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt10[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt10[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt10[0]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt10[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt10[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt10[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt10[2]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt10[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt10[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt10[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt10[4]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt10[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt10[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt10[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt10[6]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt10[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt10[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt10[6]))*100,1)%></td>    																											
           </tr>
          <% } %>	
          <%if(gubun4.equals("2")  ) { 		
       		    for (int j = 0 ; j < 10 ; j++){													
					sub_cnt10[j] = 0;								
				}	
           } %>							
          <tr> 
            <td align="right" height="20" width="60"><%=cnt10[8]%></td>
            <td align="right" height="20" width="60"><%=cnt10[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt10[9]))/AddUtil.parseFloat(String.valueOf(cnt10[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=cnt10[0]%></td>
            <td align="right" height="20" width="60"><%=cnt10[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt10[1]))/AddUtil.parseFloat(String.valueOf(cnt10[0]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt10[2]%></td>
            <td align="right" height="20" width="60"><%=cnt10[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt10[3]))/AddUtil.parseFloat(String.valueOf(cnt10[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt10[4]%></td>
            <td align="right" height="20" width="60"><%=cnt10[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt10[5]))/AddUtil.parseFloat(String.valueOf(cnt10[4]))*100,1)%></td>																				
            <td align="right" height="20" width="60"><%=cnt10[6]%></td>
            <td align="right" height="20" width="60"><%=cnt10[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt10[7]))/AddUtil.parseFloat(String.valueOf(cnt10[6]))*100,1)%></td>		
          																																
          </tr>
                              
          <%		
					for (int j = 0 ; j < 8 ; j++){													 																			
						sub_cnt10[j] = sub_cnt10[j] + cnt10[j];
						t_cnt10[j] = t_cnt10[j] + cnt10[j];
						g_cnt[j] = g_cnt[j] + cnt10[j];																
					}
					
          				sub_cnt10[8] = sub_cnt10[8]+ cnt10[8]; 	
					sub_cnt10[9] = sub_cnt10[9]+ cnt10[9];	
					
					t_cnt10[8] = t_cnt10[8]+ cnt10[8]; 	
					t_cnt10[9] = t_cnt10[9]+ cnt10[9];	
					
					g_cnt[8] = g_cnt[8]+ cnt10[8]; 	
					g_cnt[9] = g_cnt[9]+ cnt10[9];	
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0"; 					
					
			} %>
		   <% if ( buss_14.size() > 0 ){%> 	
		   <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt10[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt10[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt10[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt10[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt10[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt10[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt10[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt10[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt10[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt10[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt10[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt10[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt10[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt10[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt10[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt10[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt10[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt10[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt10[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt10[6]))*100,1)%></td>    																											
           </tr>
		  <% } %>	 
          <tr> 
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt10[8]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt10[9]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt10[9]))/AddUtil.parseFloat(String.valueOf(t_cnt10[8]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt10[0]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt10[1]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt10[1]))/AddUtil.parseFloat(String.valueOf(t_cnt10[0]))*100,1)%></td>	
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt10[2]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt10[3]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt10[3]))/AddUtil.parseFloat(String.valueOf(t_cnt10[2]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt10[4]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt10[5]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt10[5]))/AddUtil.parseFloat(String.valueOf(t_cnt10[4]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt10[6]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt10[7]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt10[7]))/AddUtil.parseFloat(String.valueOf(t_cnt10[6]))*100,1)%></td>
          </tr>         
          
             <!--  구로지점 -->  
             <%
				chk = "";
                gubun4 = "";          	   
          	             
            	for(int i = 0 ; i < buss_15.size() ; i++){
					Hashtable ht = (Hashtable)buss_15.elementAt(i);   
						
						if ( i == 0 ) {
					    	chk = String.valueOf(ht.get("BUS_ID"));
					    	gubun4 = "0";
						}
											
						if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
							gubun4 = "2";
						} 		
								
						for (int j = 0 ; j < 8 ; j++){	
							cnt11[j] = AddUtil.parseInt((String)ht.get("CNT"+(j))); 		
						}
											 
						cnt11[8] = cnt11[0]+ cnt11[2]+ cnt11[4]+ cnt11[6]; 	
						cnt11[9] = cnt11[1]+ cnt11[3]+ cnt11[5]+ cnt11[7];			
						
		  %>
	  <%if(gubun4.equals("2")  ){%> 
            <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt11[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt11[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt11[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt11[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt11[0]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt11[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt11[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt11[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt11[2]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt11[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt11[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt11[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt11[4]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt11[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt11[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt11[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt11[6]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt11[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt11[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt11[6]))*100,1)%></td>    																											
           </tr>
          <% } %>	
          <%if(gubun4.equals("2")  ) { 		
       		    for (int j = 0 ; j < 10 ; j++){													
					sub_cnt11[j] = 0;								
				}	
           } %>							
          <tr> 
            <td align="right" height="20" width="60"><%=cnt11[8]%></td>
            <td align="right" height="20" width="60"><%=cnt11[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt11[9]))/AddUtil.parseFloat(String.valueOf(cnt11[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=cnt11[0]%></td>
            <td align="right" height="20" width="60"><%=cnt11[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt11[1]))/AddUtil.parseFloat(String.valueOf(cnt11[0]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt11[2]%></td>
            <td align="right" height="20" width="60"><%=cnt11[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt11[3]))/AddUtil.parseFloat(String.valueOf(cnt11[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt11[4]%></td>
            <td align="right" height="20" width="60"><%=cnt11[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt11[5]))/AddUtil.parseFloat(String.valueOf(cnt11[4]))*100,1)%></td>																				
            <td align="right" height="20" width="60"><%=cnt11[6]%></td>
            <td align="right" height="20" width="60"><%=cnt11[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt11[7]))/AddUtil.parseFloat(String.valueOf(cnt11[6]))*100,1)%></td>		
          																																
          </tr>
                              
          <%		
					for (int j = 0 ; j < 8 ; j++){													 																			
						sub_cnt11[j] = sub_cnt11[j] + cnt11[j];
						t_cnt11[j] = t_cnt11[j] + cnt11[j];
						g_cnt[j] = g_cnt[j] + cnt11[j];																
					}
					
          				sub_cnt11[8] = sub_cnt11[8]+ cnt11[8]; 	
					sub_cnt11[9] = sub_cnt11[9]+ cnt11[9];	
					
					t_cnt11[8] = t_cnt11[8]+ cnt11[8]; 	
					t_cnt11[9] = t_cnt11[9]+ cnt11[9];	
					
					g_cnt[8] = g_cnt[8]+ cnt11[8]; 	
					g_cnt[9] = g_cnt[9]+ cnt11[9];	
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0"; 					
					
			} %>
		   <% if ( buss_15.size() > 0 ){%> 	
		   <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt11[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt11[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt11[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt11[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt11[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt11[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt11[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt11[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt11[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt11[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt11[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt11[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt11[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt11[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt11[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt11[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt11[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt11[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt11[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt11[6]))*100,1)%></td>    																											
           </tr>
		  <% } %>	 
          <tr> 
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt11[8]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt11[9]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt11[9]))/AddUtil.parseFloat(String.valueOf(t_cnt11[8]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt11[0]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt11[1]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt11[1]))/AddUtil.parseFloat(String.valueOf(t_cnt11[0]))*100,1)%></td>	
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt11[2]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt11[3]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt11[3]))/AddUtil.parseFloat(String.valueOf(t_cnt11[2]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt11[4]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt11[5]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt11[5]))/AddUtil.parseFloat(String.valueOf(t_cnt11[4]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt11[6]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt11[7]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt11[7]))/AddUtil.parseFloat(String.valueOf(t_cnt11[6]))*100,1)%></td>
          </tr>         
                    
               <!--  울산지점 -->  
             <%
				chk = "";
                gubun4 = "";          	   
          	             
            	for(int i = 0 ; i < buss_16.size() ; i++){
					Hashtable ht = (Hashtable)buss_16.elementAt(i);   
						
						if ( i == 0 ) {
					    	chk = String.valueOf(ht.get("BUS_ID"));
					    	gubun4 = "0";
						}
											
						if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
							gubun4 = "2";
						} 		
								
						for (int j = 0 ; j < 8 ; j++){	
							cnt12[j] = AddUtil.parseInt((String)ht.get("CNT"+(j))); 		
						}
											 
						cnt12[8] = cnt12[0]+ cnt12[2]+ cnt12[4]+ cnt12[6]; 	
						cnt12[9] = cnt12[1]+ cnt12[3]+ cnt12[5]+ cnt12[7];			
						
		  %>
	  <%if(gubun4.equals("2")  ){%> 
            <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt12[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt12[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt12[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt12[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt12[0]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt12[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt12[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt12[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt12[2]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt12[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt12[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt12[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt12[4]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt12[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt12[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt12[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt12[6]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt12[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt12[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt12[6]))*100,1)%></td>    																											
           </tr>
          <% } %>	
          <%if(gubun4.equals("2")  ) { 		
       		    for (int j = 0 ; j < 10 ; j++){													
					sub_cnt12[j] = 0;								
				}	
           } %>							
          <tr> 
            <td align="right" height="20" width="60"><%=cnt12[8]%></td>
            <td align="right" height="20" width="60"><%=cnt12[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt12[9]))/AddUtil.parseFloat(String.valueOf(cnt12[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=cnt12[0]%></td>
            <td align="right" height="20" width="60"><%=cnt12[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt12[1]))/AddUtil.parseFloat(String.valueOf(cnt12[0]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt12[2]%></td>
            <td align="right" height="20" width="60"><%=cnt12[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt12[3]))/AddUtil.parseFloat(String.valueOf(cnt12[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt12[4]%></td>
            <td align="right" height="20" width="60"><%=cnt12[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt12[5]))/AddUtil.parseFloat(String.valueOf(cnt12[4]))*100,1)%></td>																				
            <td align="right" height="20" width="60"><%=cnt12[6]%></td>
            <td align="right" height="20" width="60"><%=cnt12[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt12[7]))/AddUtil.parseFloat(String.valueOf(cnt12[6]))*100,1)%></td>		
          																																
          </tr>
                              
          <%		
					for (int j = 0 ; j < 8 ; j++){													 																			
						sub_cnt12[j] = sub_cnt12[j] + cnt12[j];
						t_cnt12[j] = t_cnt12[j] + cnt12[j];
						g_cnt[j] = g_cnt[j] + cnt12[j];																
					}
					
          				sub_cnt12[8] = sub_cnt12[8]+ cnt12[8]; 	
					sub_cnt12[9] = sub_cnt12[9]+ cnt12[9];	
					
					t_cnt12[8] = t_cnt12[8]+ cnt12[8]; 	
					t_cnt12[9] = t_cnt12[9]+ cnt12[9];	
					
					g_cnt[8] = g_cnt[8]+ cnt12[8]; 	
					g_cnt[9] = g_cnt[9]+ cnt12[9];	
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0"; 					
					
			} %>
		   <% if ( buss_16.size() > 0 ){%> 	
		   <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt12[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt12[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt12[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt12[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt12[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt12[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt12[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt12[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt12[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt12[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt12[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt12[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt12[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt12[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt12[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt12[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt12[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt12[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt12[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt12[6]))*100,1)%></td>    																											
           </tr>
		  <% } %>	 
          <tr> 
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt12[8]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt12[9]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt12[9]))/AddUtil.parseFloat(String.valueOf(t_cnt12[8]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt12[0]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt12[1]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt12[1]))/AddUtil.parseFloat(String.valueOf(t_cnt12[0]))*100,1)%></td>	
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt12[2]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt12[3]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt12[3]))/AddUtil.parseFloat(String.valueOf(t_cnt12[2]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt12[4]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt12[5]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt12[5]))/AddUtil.parseFloat(String.valueOf(t_cnt12[4]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt12[6]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt12[7]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt12[7]))/AddUtil.parseFloat(String.valueOf(t_cnt12[6]))*100,1)%></td>
          </tr>         
          
              <!--  광화문지점 -->  
             <%
				chk = "";
                gubun4 = "";          	   
          	             
            	for(int i = 0 ; i < buss_17.size() ; i++){
					Hashtable ht = (Hashtable)buss_17.elementAt(i);   
						
						if ( i == 0 ) {
					    	chk = String.valueOf(ht.get("BUS_ID"));
					    	gubun4 = "0";
						}
											
						if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
							gubun4 = "2";
						} 		
								
						for (int j = 0 ; j < 8 ; j++){	
							cnt13[j] = AddUtil.parseInt((String)ht.get("CNT"+(j))); 		
						}
											 
						cnt13[8] = cnt13[0]+ cnt13[2]+ cnt13[4]+ cnt13[6]; 	
						cnt13[9] = cnt13[1]+ cnt13[3]+ cnt13[5]+ cnt13[7];			
						
		  %>
	  <%if(gubun4.equals("2")  ){%> 
            <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt13[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt13[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt13[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt13[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt13[0]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt13[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt13[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt13[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt13[2]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt13[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt13[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt13[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt13[4]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt13[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt13[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt13[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt13[6]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt13[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt13[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt13[6]))*100,1)%></td>    																											
           </tr>
          <% } %>	
          <%if(gubun4.equals("2")  ) { 		
       		    for (int j = 0 ; j < 10 ; j++){													
					sub_cnt13[j] = 0;								
				}	
           } %>							
          <tr> 
            <td align="right" height="20" width="60"><%=cnt13[8]%></td>
            <td align="right" height="20" width="60"><%=cnt13[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt13[9]))/AddUtil.parseFloat(String.valueOf(cnt13[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=cnt13[0]%></td>
            <td align="right" height="20" width="60"><%=cnt13[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt13[1]))/AddUtil.parseFloat(String.valueOf(cnt13[0]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt13[2]%></td>
            <td align="right" height="20" width="60"><%=cnt13[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt13[3]))/AddUtil.parseFloat(String.valueOf(cnt13[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt13[4]%></td>
            <td align="right" height="20" width="60"><%=cnt13[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt13[5]))/AddUtil.parseFloat(String.valueOf(cnt13[4]))*100,1)%></td>																				
            <td align="right" height="20" width="60"><%=cnt13[6]%></td>
            <td align="right" height="20" width="60"><%=cnt13[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt13[7]))/AddUtil.parseFloat(String.valueOf(cnt13[6]))*100,1)%></td>		
          																																
          </tr>
                              
          <%		
					for (int j = 0 ; j < 8 ; j++){													 																			
						sub_cnt13[j] = sub_cnt13[j] + cnt13[j];
						t_cnt13[j] = t_cnt13[j] + cnt13[j];
						g_cnt[j] = g_cnt[j] + cnt13[j];																
					}
					
          				sub_cnt13[8] = sub_cnt13[8]+ cnt13[8]; 	
					sub_cnt13[9] = sub_cnt13[9]+ cnt13[9];	
					
					t_cnt13[8] = t_cnt13[8]+ cnt13[8]; 	
					t_cnt13[9] = t_cnt13[9]+ cnt13[9];	
					
					g_cnt[8] = g_cnt[8]+ cnt13[8]; 	
					g_cnt[9] = g_cnt[9]+ cnt13[9];	
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0"; 					
					
			} %>
		   <% if ( buss_17.size() > 0 ){%> 	
		   <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt13[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt13[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt13[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt13[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt13[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt13[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt13[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt13[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt13[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt13[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt13[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt13[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt13[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt13[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt13[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt13[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt13[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt13[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt13[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt13[6]))*100,1)%></td>    																											
           </tr>
		  <% } %>	 
          <tr> 
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt13[8]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt13[9]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt13[9]))/AddUtil.parseFloat(String.valueOf(t_cnt13[8]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt13[0]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt13[1]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt13[1]))/AddUtil.parseFloat(String.valueOf(t_cnt13[0]))*100,1)%></td>	
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt13[2]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt13[3]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt13[3]))/AddUtil.parseFloat(String.valueOf(t_cnt13[2]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt13[4]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt13[5]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt13[5]))/AddUtil.parseFloat(String.valueOf(t_cnt13[4]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt13[6]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt13[7]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt13[7]))/AddUtil.parseFloat(String.valueOf(t_cnt13[6]))*100,1)%></td>
          </tr>         
          
                  <!--  송파지점 -->  
             <%
				chk = "";
                gubun4 = "";          	   
          	             
            	for(int i = 0 ; i < buss_18.size() ; i++){
					Hashtable ht = (Hashtable)buss_18.elementAt(i);   
						
						if ( i == 0 ) {
					    	chk = String.valueOf(ht.get("BUS_ID"));
					    	gubun4 = "0";
						}
											
						if ( !chk.equals(String.valueOf(ht.get("BUS_ID")))) {       
							gubun4 = "2";
						} 		
								
						for (int j = 0 ; j < 8 ; j++){	
							cnt14[j] = AddUtil.parseInt((String)ht.get("CNT"+(j))); 		
						}
											 
						cnt14[8] = cnt14[0]+ cnt14[2]+ cnt14[4]+ cnt14[6]; 	
						cnt14[9] = cnt14[1]+ cnt14[3]+ cnt14[5]+ cnt14[7];			
						
		  %>
	  <%if(gubun4.equals("2")  ){%> 
            <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt14[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt14[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt14[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt14[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt14[0]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt14[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt14[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt14[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt14[2]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt14[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt14[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt14[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt14[4]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt14[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt14[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt14[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt14[6]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt14[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt14[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt14[6]))*100,1)%></td>    																											
           </tr>
          <% } %>	
          <%if(gubun4.equals("2")  ) { 		
       		    for (int j = 0 ; j < 10 ; j++){													
					sub_cnt14[j] = 0;								
				}	
           } %>							
          <tr> 
            <td align="right" height="20" width="60"><%=cnt14[8]%></td>
            <td align="right" height="20" width="60"><%=cnt14[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt14[9]))/AddUtil.parseFloat(String.valueOf(cnt14[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=cnt14[0]%></td>
            <td align="right" height="20" width="60"><%=cnt14[1]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt14[1]))/AddUtil.parseFloat(String.valueOf(cnt14[0]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt14[2]%></td>
            <td align="right" height="20" width="60"><%=cnt14[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt14[3]))/AddUtil.parseFloat(String.valueOf(cnt14[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=cnt14[4]%></td>
            <td align="right" height="20" width="60"><%=cnt14[5]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt14[5]))/AddUtil.parseFloat(String.valueOf(cnt14[4]))*100,1)%></td>																				
            <td align="right" height="20" width="60"><%=cnt14[6]%></td>
            <td align="right" height="20" width="60"><%=cnt14[7]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt14[7]))/AddUtil.parseFloat(String.valueOf(cnt14[6]))*100,1)%></td>		
          																																
          </tr>
                              
          <%		
					for (int j = 0 ; j < 8 ; j++){													 																			
						sub_cnt14[j] = sub_cnt14[j] + cnt14[j];
						t_cnt14[j] = t_cnt14[j] + cnt14[j];
						g_cnt[j] = g_cnt[j] + cnt14[j];																
					}
					
          				sub_cnt14[8] = sub_cnt14[8]+ cnt14[8]; 	
					sub_cnt14[9] = sub_cnt14[9]+ cnt14[9];	
					
					t_cnt14[8] = t_cnt14[8]+ cnt14[8]; 	
					t_cnt14[9] = t_cnt14[9]+ cnt14[9];	
					
					g_cnt[8] = g_cnt[8]+ cnt14[8]; 	
					g_cnt[9] = g_cnt[9]+ cnt14[9];	
					
					chk = String.valueOf(ht.get("BUS_ID"));
					gubun4 = "0"; 					
					
			} %>
		   <% if ( buss_18.size() > 0 ){%> 	
		   <tr> 
            <td align="right" height="20" width="60"><%=sub_cnt14[8]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt14[9]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt14[9]))/AddUtil.parseFloat(String.valueOf(sub_cnt14[8]))*100,1)%></td>
            <td align="right" height="20" width="60"><%=sub_cnt14[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt14[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt14[1]))/AddUtil.parseFloat(String.valueOf(sub_cnt14[0]))*100,1)%></td>			
            <td align="right" height="20" width="60"><%=sub_cnt14[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt14[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt14[3]))/AddUtil.parseFloat(String.valueOf(sub_cnt14[2]))*100,1)%></td>		
            <td align="right" height="20" width="60"><%=sub_cnt14[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt14[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt14[5]))/AddUtil.parseFloat(String.valueOf(sub_cnt14[4]))*100,1)%></td>																			
            <td align="right" height="20" width="60"><%=sub_cnt14[3]%></td>
            <td align="right" height="20" width="60"><%=sub_cnt14[3]%></td>
            <td align="right" height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sub_cnt14[7]))/AddUtil.parseFloat(String.valueOf(sub_cnt14[6]))*100,1)%></td>    																											
           </tr>
		  <% } %>	 
          <tr> 
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt14[8]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt14[9]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt14[9]))/AddUtil.parseFloat(String.valueOf(t_cnt14[8]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt14[0]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt14[1]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt14[1]))/AddUtil.parseFloat(String.valueOf(t_cnt14[0]))*100,1)%></td>	
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt14[2]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt14[3]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt14[3]))/AddUtil.parseFloat(String.valueOf(t_cnt14[2]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt14[4]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt14[5]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt14[5]))/AddUtil.parseFloat(String.valueOf(t_cnt14[4]))*100,1)%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt14[6]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=t_cnt14[7]%></td>
            <td class="title" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(t_cnt14[7]))/AddUtil.parseFloat(String.valueOf(t_cnt14[6]))*100,1)%></td>
          </tr>         
          
          <tr> 
            <td class="title_p" style='text-align:right' height="20" width="60"><%=g_cnt[8]%></td>
            <td class="title_p" style='text-align:right' height="20" width="60"><%=g_cnt[9]%></td>
            <td class="title_p" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(g_cnt[9]))/AddUtil.parseFloat(String.valueOf(g_cnt[8]))*100,1)%></td> 
            <td class="title_p" style='text-align:right' height="20" width="60"><%=g_cnt[0]%></td>
            <td class="title_p" style='text-align:right' height="20" width="60"><%=g_cnt[1]%></td>
            <td class="title_p" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(g_cnt[1]))/AddUtil.parseFloat(String.valueOf(g_cnt[0]))*100,1)%></td> 	
            <td class="title_p" style='text-align:right' height="20" width="60"><%=g_cnt[2]%></td>
            <td class="title_p" style='text-align:right' height="20" width="60"><%=g_cnt[3]%></td>
            <td class="title_p" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(g_cnt[3]))/AddUtil.parseFloat(String.valueOf(g_cnt[2]))*100,1)%></td> 	
            <td class="title_p" style='text-align:right' height="20" width="60"><%=g_cnt[4]%></td>
            <td class="title_p" style='text-align:right' height="20" width="60"><%=g_cnt[5]%></td>
            <td class="title_p" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(g_cnt[5]))/AddUtil.parseFloat(String.valueOf(g_cnt[4]))*100,1)%></td> 		
            <td class="title_p" style='text-align:right' height="20" width="60"><%=g_cnt[6]%></td>
            <td class="title_p" style='text-align:right' height="20" width="60"><%=g_cnt[7]%></td>
            <td class="title_p" style='text-align:right' height="20" width="60"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(g_cnt[7]))/AddUtil.parseFloat(String.valueOf(g_cnt[6]))*100,1)%></td> 	         																																	
          </tr>
          
        </table>
	  </td>
	</tr>
</table>		
</form>
<script language='javascript'>
<!--
//-->
</script>
<font size=2>* 2011년 해지건부터 적용 </font>
</body>
</html>
