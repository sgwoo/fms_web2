<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");

	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
		
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	
	Hashtable  ht1 = cr_db.getServjListNew(s_kd, t_wd, gubun1, gubun2, gubun3,  st_dt, end_dt, "000620");   //명진
	
	Hashtable  ht2 = cr_db.getServjListNew(s_kd, t_wd, gubun1, gubun2, gubun3,  st_dt, end_dt, "006858");  //오토크린
		
	Hashtable  ht3 = cr_db.getServjListNew(s_kd, t_wd, gubun1, gubun2, gubun3,  st_dt, end_dt, "000286");  //정일현대
	
	Hashtable  ht4 = cr_db.getServjListNew(s_kd, t_wd, gubun1, gubun2, gubun3,  st_dt, end_dt, "002105");   //부경
	
	
	Hashtable  ht5 = cr_db.getServjListNew(s_kd, t_wd, gubun1, gubun2, gubun3,  st_dt, end_dt, "002734");  //현대카독크	
	//2013년 4월까지는 노블래스 기 이후는 1급금호자동차
	Hashtable  ht6 = cr_db.getServjListNew(s_kd, t_wd, gubun1, gubun2, gubun3,  st_dt, end_dt, "007603");  //노블래스
	
	Hashtable  ht8 = cr_db.getServjListNew(s_kd, t_wd, gubun1, gubun2, gubun3,  st_dt, end_dt, "007897");  //1급금호자동차
		
	Hashtable  ht7 = cr_db.getServjListNew(s_kd, t_wd, gubun1, gubun2, gubun3,  st_dt, end_dt, "001816");  //삼일정비 -- 부산
	
	Hashtable  ht9 = cr_db.getServjListNew(s_kd, t_wd, gubun1, gubun2, gubun3,  st_dt, end_dt, "008462");  //성서현대 -- 대구
	
	Hashtable  ht10 = cr_db.getServjListNew(s_kd, t_wd, gubun1, gubun2, gubun3,  st_dt, end_dt, "008507");  //상무현대 -- 광주
	

	Hashtable  ht11 = cr_db.getServjListNew(s_kd, t_wd, gubun1, gubun2, gubun3,  st_dt, end_dt, "009290");  //우리자동차 -- 서울
	
	Hashtable  ht12 = cr_db.getServjListNew(s_kd, t_wd, gubun1, gubun2, gubun3,  st_dt, end_dt, "006490");  //상무1급 --광주
	
	Hashtable  ht13 = cr_db.getServjListNew(s_kd, t_wd, gubun1, gubun2, gubun3,  st_dt, end_dt, "010424");  //강서현대 --서울
	
//	out.println(AddUtil.getTime() + " |");

	int cnt[] 	= new int[5];
	
	cnt[0] = 0;   //본사
	cnt[1] = 0;   //부산
	cnt[2] = 0;   //대전
	cnt[3] = 0;   //대구
	cnt[4] = 0;   //광주
	
	
	if ( ht1.get("GUBUN1") != null   )   cnt[0]	+= 1;
	if ( ht2.get("GUBUN1") != null   )   cnt[0]	+= 1;
//	if ( ht3.get("GUBUN1") != null   )   cnt[0]	+= 1;
	if (  AddUtil.parseLong(String.valueOf(ht3.get("IP_CNT")))   != 0 ||  AddUtil.parseLong(String.valueOf(ht3.get("CH_CNT")))   != 0 ||  AddUtil.parseLong(String.valueOf(ht3.get("TOT_CNT")))   != 0  ||  AddUtil.parseLong(String.valueOf(ht3.get("PAY_AMT")))   != 0    )   cnt[0]	+= 1;
	
	
//	if ( ht11.get("GUBUN1") != null   )   cnt[0]	+= 1;
	if (  AddUtil.parseLong(String.valueOf(ht11.get("IP_CNT")))   != 0 ||  AddUtil.parseLong(String.valueOf(ht11.get("CH_CNT")))   != 0 ||  AddUtil.parseLong(String.valueOf(ht11.get("TOT_CNT")))   != 0  ||  AddUtil.parseLong(String.valueOf(ht11.get("PAY_AMT")))   != 0    )   cnt[0]	+= 1;
	

	if ( ht13.get("GUBUN1") != null   )   cnt[0]	+= 1;
	
	if ( ht4.get("GUBUN1") != null   )   cnt[1]	+= 1;
	if ( ht7.get("GUBUN1") != null   )   cnt[1]	+= 1;

//	대전
	if ( ht5.get("GUBUN1") != null   )   cnt[2]	+= 1;	
//	if (  AddUtil.parseLong(String.valueOf(ht5.get("IP_CNT")))   != 0 ||  AddUtil.parseLong(String.valueOf(ht5.get("CH_CNT")))   != 0 ||  AddUtil.parseLong(String.valueOf(ht5.get("TOT_CNT")))   != 0  ||  AddUtil.parseLong(String.valueOf(ht5.get("PAY_AMT")))   != 0    )   cnt[2]	+= 1;
	if (  AddUtil.parseLong(String.valueOf(ht6.get("IP_CNT")))   != 0 ||  AddUtil.parseLong(String.valueOf(ht6.get("CH_CNT")))   != 0 ||  AddUtil.parseLong(String.valueOf(ht6.get("TOT_CNT")))   != 0  ||  AddUtil.parseLong(String.valueOf(ht6.get("PAY_AMT")))   != 0    )   cnt[2]	+= 1;
	if (  AddUtil.parseLong(String.valueOf(ht8.get("IP_CNT")))   != 0 ||  AddUtil.parseLong(String.valueOf(ht8.get("CH_CNT")))   != 0 ||  AddUtil.parseLong(String.valueOf(ht8.get("TOT_CNT")))   != 0  ||  AddUtil.parseLong(String.valueOf(ht8.get("PAY_AMT")))   != 0    )   cnt[2]	+= 1;
	
	if ( ht9.get("GUBUN1") != null   )     cnt[3]	+= 1;
	
	if ( ht10.get("GUBUN1") != null   )   cnt[4]	+= 1;
	if ( ht12.get("GUBUN1") != null   )   cnt[4]	+= 1;
					
	long sub_amt1 = 0;
	long sub_amt2 = 0;
	long sub_amt3= 0;
	long sub_amt4 = 0;
	long sub_amt5 = 0;
	long sub_amt6 = 0;
	long sub_amt7 = 0;
	long sub_amt8 = 0;
	long sub_amt9 = 0;   //공임
	long sub_amt10 = 0;   //부품
	long sub_amt11 = 0;   //부품
	
	
	long sub1_amt1= 0;
	long sub1_amt2 = 0;
	long sub1_amt3= 0;
	long sub1_amt4 = 0;
	long sub1_amt5 = 0;
	long sub1_amt6 = 0;
	long sub1_amt7 = 0;
	long sub1_amt8 = 0;
	long sub1_amt9 = 0;
	long sub1_amt10 = 0;
	long sub1_amt11 = 0;
	
	long sub2_amt1= 0;
	long sub2_amt2 = 0;
	long sub2_amt3= 0;
	long sub2_amt4 = 0;
	long sub2_amt5 = 0;
	long sub2_amt6 = 0;
	long sub2_amt7 = 0;
	long sub2_amt8 = 0;
	long sub2_amt9 = 0;
	long sub2_amt10 = 0;	
	long sub2_amt11 = 0;	
	
	long sub3_amt1= 0;
	long sub3_amt2 = 0;
	long sub3_amt3= 0;
	long sub3_amt4 = 0;
	long sub3_amt5 = 0;
	long sub3_amt6 = 0;
	long sub3_amt7 = 0;
	long sub3_amt8 = 0;
	long sub3_amt9 = 0;
	long sub3_amt10 = 0;	
	long sub3_amt11 = 0;	
	
	long total_amt1= 0;
	long total_amt2 = 0;
	long total_amt3= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;
	long total_amt11 = 0;
	
	long amt1 = 0;
	long amt2 = 0;
	long amt4 = 0;
	
	long amt3 = 0; //정비중
	
	long amt5 = 0;
	long amt6 = 0;
		
	long amt9 = 0;  //  공임
	long amt10 = 0; //부품	 
	long amt11 = 0; //부품	 

//	out.println(AddUtil.getTime() + " |");
%>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">


<body>
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

  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/service/servj_s_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='tint_no' value=''>  
  <input type='hidden' name='mode' value=''>    
  <table border="0" cellspacing="0" cellpadding="0" width='1420'>
     <tr>
        <td class=line2></td>
    </tr>
	<tr>
	  <td class='line'> 
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>	
		   	<td rowspan=3 width='70' class='title'  style='height:70'>관리지점</td> 	
			<td rowspan=3 width='110' class='title'>업체명</td>   	
			<td colspan="7" class='title'>입출고현황(댓수)</td>	
			<td colspan="5" class='title'>청구현황</td>				  
			<td colspan="4" class='title' style='height:23'>지급현황</td>		
			<td rowspan=3 width='70' class='title' >부품<br>캐쉬백</td> 		
		  </tr>
		  <tr>
			<td colspan=2  class='title'>입고</td>
			<td colspan=2  class='title'>출고</td>
			<td colspan=2  class='title'>재고<br>(정비중)</td>									
			<td rowspan=2 width='70' class='title'>합계</td>		
			<td colspan=3  class='title'>청구금액</td>	
			<td rowspan=2 width='70' class='title'>대당<br>공임금액</td>				  			
			<td rowspan=2 width='70' class='title'>대당<br>청구금액</td>	
			<td rowspan=2 width='90' class='title'>지급금액</td>				  			
			<td rowspan=2 width='90' class='title'>미지급금액</td>	
			<td colspan=2   class='title'>합계</td>					  
		  </tr>
		    <tr>
			<td width='60' class='title'>댓수</td>
			<td width='60' class='title'>점유비</td>
			<td width='60' class='title'>댓수</td>
			<td width='60' class='title'>점유비</td>
			<td width='60' class='title'>댓수</td>
			<td width='60' class='title'>점유비</td>
			<td width='80' class='title'>공임</td>			
			<td width='80' class='title'>부품</td>		
			<td width='90' class='title'>계</td>						
			<td width='90' class='title'>금액</td>									
			<td width='60' class='title'>점유비</td>												  
							  
		  </tr>
		</table>
	  </td>
	</tr>

<%	if ( ht1.get("GUBUN1") != null   )         { %>
        	<tr>
		<td class='line' >
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>

				<tr>
					<td  width='70' align='center' rowspan='<%=cnt[0]+1%>' >본사</td>
					<td  width='110' align='center'><a href="javascript:parent.list_move('000620');">MJ모터스</a></td>							
													
<%			
			amt1 	= AddUtil.parseLong(String.valueOf(ht1.get("IP_CNT")));
			amt2 	= AddUtil.parseLong(String.valueOf(ht1.get("CH_CNT")));
			amt4 	= AddUtil.parseLong(String.valueOf(ht1.get("TOT_CNT")));
			
			amt3 = amt4 - amt2;
			if ( amt3 < 0) {
			   amt3 = 0;
			}
						
			amt5 	= AddUtil.parseLong(String.valueOf(ht1.get("TOT_AMT")));
			amt6 	= AddUtil.parseLong(String.valueOf(ht1.get("PAY_AMT")));			
			amt9 	= AddUtil.parseLong(String.valueOf(ht1.get("LABOR_AMT")));
			amt10 	= AddUtil.parseLong(String.valueOf(ht1.get("R_J_AMT")));
			amt11 	= AddUtil.parseLong(String.valueOf(ht1.get("PARTS_AMT")));
			
			sub_amt1 	= sub_amt1 + AddUtil.parseLong(String.valueOf(ht1.get("IP_CNT")));
			sub_amt2 	= sub_amt2 + AddUtil.parseLong(String.valueOf(ht1.get("CH_CNT")));
			sub_amt3 	= sub_amt3 + AddUtil.parseLong(String.valueOf(ht1.get("TOT_CNT")));
			sub_amt4 	= sub_amt4 + amt3;
				
			sub_amt5 	= sub_amt5 + AddUtil.parseLong(String.valueOf(ht1.get("TOT_AMT")));
			sub_amt6 	= sub_amt6 + AddUtil.parseLong(String.valueOf(ht1.get("PAY_AMT")));			
			sub_amt9 	= sub_amt9 + AddUtil.parseLong(String.valueOf(ht1.get("LABOR_AMT"))); //공임
			sub_amt10 	= sub_amt10 + AddUtil.parseLong(String.valueOf(ht1.get("R_J_AMT")));  //부품		
			sub_amt11 	= sub_amt11 + AddUtil.parseLong(String.valueOf(ht1.get("PARTS_AMT")));  //부품			
						
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht1.get("IP_CNT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht1.get("CH_CNT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht1.get("TOT_CNT")));
			total_amt4 	= total_amt4 + amt3;
				
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht1.get("TOT_AMT")));
			total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht1.get("PAY_AMT")));			
			total_amt9 	= total_amt9 + AddUtil.parseLong(String.valueOf(ht1.get("LABOR_AMT")));
			total_amt10 	= total_amt10 + AddUtil.parseLong(String.valueOf(ht1.get("R_J_AMT")));
			
			total_amt11 	= total_amt11 + AddUtil.parseLong(String.valueOf(ht1.get("PARTS_AMT")));
			
%>					
					<td  width='60' align='right'><input type="text" name="c1_cnt" size="5" value="<%=Util.parseDecimal(amt1)%>" class="whitenum"></td>																								
					<td  width='60' align='right'><input type="text" name="c1_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c2_cnt" size="5" value="<%=Util.parseDecimal(amt2)%>" class="whitenum"></td>																								
					<td  width='60' align='right'><input type="text" name="c2_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c3_cnt" size="5" value="<%=Util.parseDecimal(amt3)%>" class="whitenum"></td>																								
					<td  width='60' align='right'><input type="text" name="c3_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'><%=Util.parseDecimal(amt1 + amt2 + amt3)%></td>			
					<td  width='80' align='right'><%=Util.parseDecimal(amt9)%></td>	
					<td  width='80' align='right'><%=Util.parseDecimal(amt10)%></td>	
					<td  width='90' align='right'><%=Util.parseDecimal(amt5)%></td>	
					<td  width='70' align='right'><% if ( amt4 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt9/amt4)%><% } %>
					</td>
					<td  width='70' align='right'><% if ( amt4 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt5/amt4)%><% } %>
					</td>				
					<td  width='90' align='right'><%=Util.parseDecimal(amt6)%></td>					
					<td  width='90' align='right'><%=Util.parseDecimal(amt5 - amt6)%></td>					
					<td  width='90' align='right'><input type="text" name="c_amt" size="10" value="<%=Util.parseDecimal( amt6+ amt5 - amt6)%>" class="whitenum"></td>							
					<td  width='60' align='right'><input type="text" name="a_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'><%=Util.parseDecimal(amt11)%></td>
				</tr>	
				
<% } %>

<%       	if (  AddUtil.parseLong(String.valueOf(ht11.get("IP_CNT")))   != 0 ||  AddUtil.parseLong(String.valueOf(ht11.get("CH_CNT")))   != 0 ||  AddUtil.parseLong(String.valueOf(ht11.get("TOT_CNT")))   != 0  ||  AddUtil.parseLong(String.valueOf(ht11.get("PAY_AMT")))   != 0    )    {  %>
					

		<tr>					
					<td  width='110' align='center'><a href="javascript:parent.list_move('009290');">우리자동차</a></td>							
													
<%			
			amt1 	= AddUtil.parseLong(String.valueOf(ht11.get("IP_CNT")));
			amt2 	= AddUtil.parseLong(String.valueOf(ht11.get("CH_CNT")));
			amt4 	= AddUtil.parseLong(String.valueOf(ht11.get("TOT_CNT")));
			
			amt3 = amt4 - amt2;
			if ( amt3 < 0) {
			   amt3 = 0;
			}
			
			amt5 	= AddUtil.parseLong(String.valueOf(ht11.get("TOT_AMT")));
			amt6 	= AddUtil.parseLong(String.valueOf(ht11.get("PAY_AMT")));
			amt9 	= AddUtil.parseLong(String.valueOf(ht11.get("LABOR_AMT")));
			amt10 	= AddUtil.parseLong(String.valueOf(ht11.get("R_J_AMT")));
			
			sub_amt1 	= sub_amt1 + AddUtil.parseLong(String.valueOf(ht11.get("IP_CNT")));
			sub_amt2 	= sub_amt2 + AddUtil.parseLong(String.valueOf(ht11.get("CH_CNT")));
			sub_amt3 	= sub_amt3 + AddUtil.parseLong(String.valueOf(ht11.get("TOT_CNT")));
			sub_amt4 	= sub_amt4 + amt3;
				
			sub_amt5 	= sub_amt5 + AddUtil.parseLong(String.valueOf(ht11.get("TOT_AMT")));
			sub_amt6 	= sub_amt6 + AddUtil.parseLong(String.valueOf(ht11.get("PAY_AMT")));
			sub_amt9 	= sub_amt9 + AddUtil.parseLong(String.valueOf(ht11.get("LABOR_AMT"))); //공임
			sub_amt10 	= sub_amt10 + AddUtil.parseLong(String.valueOf(ht11.get("R_J_AMT")));  //부품		
			
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht11.get("IP_CNT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht11.get("CH_CNT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht11.get("TOT_CNT")));
			total_amt4 	= total_amt4 + amt3;
				
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht11.get("TOT_AMT")));
			total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht11.get("PAY_AMT")));
			total_amt9 	= total_amt9 + AddUtil.parseLong(String.valueOf(ht11.get("LABOR_AMT")));
			total_amt10 	= total_amt10 + AddUtil.parseLong(String.valueOf(ht11.get("R_J_AMT")));
			
%>									
					<td  width='60' align='right'><input type="text" name="c1_cnt" size="5" value="<%=Util.parseDecimal(amt1)%>" class="whitenum"></td>																							
					<td  width='60' align='right'><input type="text" name="c1_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c2_cnt" size="5" value="<%=Util.parseDecimal( amt2)%>" class="whitenum"></td>																							
					<td  width='60' align='right'><input type="text" name="c2_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c3_cnt" size="5" value="<%=Util.parseDecimal(amt3)%>" class="whitenum"></td>																							
					<td  width='60' align='right'><input type="text" name="c3_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'><%=Util.parseDecimal(amt1 + amt2 + amt3)%></td>	
					<td  width='80' align='right'><%=Util.parseDecimal(amt9)%></td>	
					<td  width='80' align='right'><%=Util.parseDecimal(amt10)%></td>	
					<td  width='90' align='right'><%=Util.parseDecimal(amt5)%></td>	
					<td  width='70' align='right'><% if ( amt4 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt9/amt4)%><% } %>
					</td>
					<td  width='70' align='right'><% if ( amt4 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt5/amt4)%><% } %>
					</td>						
					<td  width='90' align='right'><%=Util.parseDecimal(amt6)%></td>					
					<td  width='90' align='right'><%=Util.parseDecimal(amt5 - amt6)%></td>					
					<td  width='90' align='right'><input type="text" name="c_amt" size="10" value="<%=Util.parseDecimal( amt6+ amt5 - amt6)%>" class="whitenum"></td>							
					<td  width='60' align='right'><input type="text" name="a_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'>0</td>
				</tr>	
<% } %>				

<%	if ( ht2.get("GUBUN1") != null   )         { %>
				<tr>					
					<td  width='110' align='center'><a href="javascript:parent.list_move('006858');">오토크린</a></td>							
													
<%			
			amt1 	= AddUtil.parseLong(String.valueOf(ht2.get("IP_CNT")));
			amt2 	= AddUtil.parseLong(String.valueOf(ht2.get("CH_CNT")));
			amt4 	= AddUtil.parseLong(String.valueOf(ht2.get("TOT_CNT")));
			
			amt3 = amt4 - amt2;
			if ( amt3 < 0) {
			   amt3 = 0;
			}
			
			amt5 	= AddUtil.parseLong(String.valueOf(ht2.get("TOT_AMT")));
			amt6 	= AddUtil.parseLong(String.valueOf(ht2.get("PAY_AMT")));			
			amt9 	= AddUtil.parseLong(String.valueOf(ht2.get("LABOR_AMT")));
			amt10 	= AddUtil.parseLong(String.valueOf(ht2.get("R_J_AMT")));
			amt11 	= AddUtil.parseLong(String.valueOf(ht2.get("PARTS_AMT")));
			
			sub_amt1 	= sub_amt1 + AddUtil.parseLong(String.valueOf(ht2.get("IP_CNT")));
			sub_amt2 	= sub_amt2 + AddUtil.parseLong(String.valueOf(ht2.get("CH_CNT")));
			sub_amt3 	= sub_amt3 + AddUtil.parseLong(String.valueOf(ht2.get("TOT_CNT")));
			sub_amt4 	= sub_amt4 + amt3;
				
			sub_amt5 	= sub_amt5 + AddUtil.parseLong(String.valueOf(ht2.get("TOT_AMT")));
			sub_amt6 	= sub_amt6 + AddUtil.parseLong(String.valueOf(ht2.get("PAY_AMT")));
			sub_amt9 	= sub_amt9 + AddUtil.parseLong(String.valueOf(ht2.get("LABOR_AMT"))); //공임
			sub_amt10 	= sub_amt10 + AddUtil.parseLong(String.valueOf(ht2.get("R_J_AMT")));  //부품
			sub_amt11 	= sub_amt11 + AddUtil.parseLong(String.valueOf(ht2.get("PARTS_AMT")));  //부품			
			
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht2.get("IP_CNT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht2.get("CH_CNT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht2.get("TOT_CNT")));
			total_amt4 	= total_amt4 + amt3;
				
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht2.get("TOT_AMT")));
			total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht2.get("PAY_AMT")));
			total_amt9 	= total_amt9 + AddUtil.parseLong(String.valueOf(ht2.get("LABOR_AMT")));
			total_amt10 	= total_amt10 + AddUtil.parseLong(String.valueOf(ht2.get("R_J_AMT")));
			total_amt11 	= total_amt11 + AddUtil.parseLong(String.valueOf(ht2.get("PARTS_AMT")));  //부품
			
%>										
					<td  width='60' align='right'><input type="text" name="c1_cnt" size="5" value="<%=Util.parseDecimal(amt1)%>" class="whitenum"></td>																						
					<td  width='60' align='right'><input type="text" name="c1_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c2_cnt" size="5" value="<%=Util.parseDecimal(amt2)%>" class="whitenum"></td>																						
					<td  width='60' align='right'><input type="text" name="c2_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c3_cnt" size="5" value="<%=Util.parseDecimal( amt3)%>" class="whitenum"></td>																						
					<td  width='60' align='right'><input type="text" name="c3_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'><%=Util.parseDecimal(amt1 + amt2 + amt3)%></td>	
					<td  width='80' align='right'><%=Util.parseDecimal(amt9)%></td>
					<td  width='80' align='right'><%=Util.parseDecimal(amt10)%></td>
					<td  width='90' align='right'><%=Util.parseDecimal(amt5)%></td>
					<td  width='70' align='right'><% if ( amt4 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt9/amt4)%><% } %>
					</td>
					<td  width='70' align='right'><% if ( amt4 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt5/amt4)%><% } %>
					</td>							
					<td  width='90' align='right'><%=Util.parseDecimal(amt6)%></td>					
					<td  width='90' align='right'><%=Util.parseDecimal(amt5 - amt6)%></td>					
					<td  width='90' align='right'><input type="text" name="c_amt" size="10" value="<%=Util.parseDecimal( amt6+ amt5 - amt6)%>" class="whitenum"></td>							
					<td  width='60' align='right'><input type="text" name="a_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'><%=Util.parseDecimal(amt11)%></td>
				</tr>	
				
<% } %>		

<%       	if (  AddUtil.parseLong(String.valueOf(ht3.get("IP_CNT")))   != 0 ||  AddUtil.parseLong(String.valueOf(ht3.get("CH_CNT")))   != 0 ||  AddUtil.parseLong(String.valueOf(ht3.get("TOT_CNT")))   != 0  ||  AddUtil.parseLong(String.valueOf(ht3.get("PAY_AMT")))   != 0    )    {  %>
				
		<tr>					
					<td  width='110' align='center'><a href="javascript:parent.list_move('000286');">정일공업사</a></td>							
													
<%			
			amt1 	= AddUtil.parseLong(String.valueOf(ht3.get("IP_CNT")));
			amt2 	= AddUtil.parseLong(String.valueOf(ht3.get("CH_CNT")));
			amt4 	= AddUtil.parseLong(String.valueOf(ht3.get("TOT_CNT")));
			
			amt3 = amt4 - amt2;
			if ( amt3 < 0) {
			   amt3 = 0;
			}
			
			amt5 	= AddUtil.parseLong(String.valueOf(ht3.get("TOT_AMT")));
			amt6 	= AddUtil.parseLong(String.valueOf(ht3.get("PAY_AMT")));
			amt9 	= AddUtil.parseLong(String.valueOf(ht3.get("LABOR_AMT")));
			amt10 	= AddUtil.parseLong(String.valueOf(ht3.get("R_J_AMT")));
			
			sub_amt1 	= sub_amt1 + AddUtil.parseLong(String.valueOf(ht3.get("IP_CNT")));
			sub_amt2 	= sub_amt2 + AddUtil.parseLong(String.valueOf(ht3.get("CH_CNT")));
			sub_amt3 	= sub_amt3 + AddUtil.parseLong(String.valueOf(ht3.get("TOT_CNT")));
			sub_amt4 	= sub_amt4 + amt3;
				
			sub_amt5 	= sub_amt5 + AddUtil.parseLong(String.valueOf(ht3.get("TOT_AMT")));
			sub_amt6 	= sub_amt6 + AddUtil.parseLong(String.valueOf(ht3.get("PAY_AMT")));
			sub_amt9 	= sub_amt9 + AddUtil.parseLong(String.valueOf(ht3.get("LABOR_AMT"))); //공임
			sub_amt10 	= sub_amt10 + AddUtil.parseLong(String.valueOf(ht3.get("R_J_AMT")));  //부품		
			
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht3.get("IP_CNT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht3.get("CH_CNT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht3.get("TOT_CNT")));
			total_amt4 	= total_amt4 + amt3;
				
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht3.get("TOT_AMT")));
			total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht3.get("PAY_AMT")));
			total_amt9 	= total_amt9 + AddUtil.parseLong(String.valueOf(ht3.get("LABOR_AMT")));
			total_amt10 	= total_amt10 + AddUtil.parseLong(String.valueOf(ht3.get("R_J_AMT")));
			
%>									
					<td  width='60' align='right'><input type="text" name="c1_cnt" size="5" value="<%=Util.parseDecimal(amt1)%>" class="whitenum"></td>																							
					<td  width='60' align='right'><input type="text" name="c1_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c2_cnt" size="5" value="<%=Util.parseDecimal( amt2)%>" class="whitenum"></td>																							
					<td  width='60' align='right'><input type="text" name="c2_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c3_cnt" size="5" value="<%=Util.parseDecimal(amt3)%>" class="whitenum"></td>																							
					<td  width='60' align='right'><input type="text" name="c3_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'><%=Util.parseDecimal(amt1 + amt2 + amt3)%></td>	
					<td  width='80' align='right'><%=Util.parseDecimal(amt9)%></td>	
					<td  width='80' align='right'><%=Util.parseDecimal(amt10)%></td>	
					<td  width='90' align='right'><%=Util.parseDecimal(amt5)%></td>	
					<td  width='70' align='right'><% if ( amt4 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt9/amt4)%><% } %>
					</td>
					<td  width='70' align='right'><% if ( amt4 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt5/amt4)%><% } %>
					</td>						
					<td  width='90' align='right'><%=Util.parseDecimal(amt6)%></td>					
					<td  width='90' align='right'><%=Util.parseDecimal(amt5 - amt6)%></td>					
					<td  width='90' align='right'><input type="text" name="c_amt" size="10" value="<%=Util.parseDecimal( amt6+ amt5 - amt6)%>" class="whitenum"></td>							
					<td  width='60' align='right'><input type="text" name="a_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'>0</td>
				</tr>	
<% } %>				


<%if ( ht13.get("GUBUN1") != null   ) 	{%>	
		<tr>					
					<td  width='110' align='center'><a href="javascript:parent.list_move('010424');">강서현대</a></td>							
													
<%			
			amt1 	= AddUtil.parseLong(String.valueOf(ht13.get("IP_CNT")));
			amt2 	= AddUtil.parseLong(String.valueOf(ht13.get("CH_CNT")));
			amt4 	= AddUtil.parseLong(String.valueOf(ht13.get("TOT_CNT")));
			
			amt3 = amt4 - amt2;
			if ( amt3 < 0) {
			   amt3 = 0;
			}
			
			amt5 	= AddUtil.parseLong(String.valueOf(ht13.get("TOT_AMT")));
			amt6 	= AddUtil.parseLong(String.valueOf(ht13.get("PAY_AMT")));
			amt9 	= AddUtil.parseLong(String.valueOf(ht13.get("LABOR_AMT")));
			amt10 	= AddUtil.parseLong(String.valueOf(ht13.get("R_J_AMT")));
			
			sub_amt1 	= sub_amt1 + AddUtil.parseLong(String.valueOf(ht13.get("IP_CNT")));
			sub_amt2 	= sub_amt2 + AddUtil.parseLong(String.valueOf(ht13.get("CH_CNT")));
			sub_amt3 	= sub_amt3 + AddUtil.parseLong(String.valueOf(ht13.get("TOT_CNT")));
			sub_amt4 	= sub_amt4 + amt3;
				
			sub_amt5 	= sub_amt5 + AddUtil.parseLong(String.valueOf(ht13.get("TOT_AMT")));
			sub_amt6 	= sub_amt6 + AddUtil.parseLong(String.valueOf(ht13.get("PAY_AMT")));
			sub_amt9 	= sub_amt9 + AddUtil.parseLong(String.valueOf(ht13.get("LABOR_AMT"))); //공임
			sub_amt10 	= sub_amt10 + AddUtil.parseLong(String.valueOf(ht13.get("R_J_AMT")));  //부품		
			
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht13.get("IP_CNT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht13.get("CH_CNT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht13.get("TOT_CNT")));
			total_amt4 	= total_amt4 + amt3;
				
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht13.get("TOT_AMT")));
			total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht13.get("PAY_AMT")));
			total_amt9 	= total_amt9 + AddUtil.parseLong(String.valueOf(ht13.get("LABOR_AMT")));
			total_amt10 	= total_amt10 + AddUtil.parseLong(String.valueOf(ht13.get("R_J_AMT")));
			
%>									
					<td  width='60' align='right'><input type="text" name="c1_cnt" size="5" value="<%=Util.parseDecimal(amt1)%>" class="whitenum"></td>																							
					<td  width='60' align='right'><input type="text" name="c1_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c2_cnt" size="5" value="<%=Util.parseDecimal( amt2)%>" class="whitenum"></td>																							
					<td  width='60' align='right'><input type="text" name="c2_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c3_cnt" size="5" value="<%=Util.parseDecimal(amt3)%>" class="whitenum"></td>																							
					<td  width='60' align='right'><input type="text" name="c3_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'><%=Util.parseDecimal(amt1 + amt2 + amt3)%></td>	
					<td  width='80' align='right'><%=Util.parseDecimal(amt9)%></td>	
					<td  width='80' align='right'><%=Util.parseDecimal(amt10)%></td>	
					<td  width='90' align='right'><%=Util.parseDecimal(amt5)%></td>	
					<td  width='70' align='right'><% if ( amt4 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt9/amt4)%><% } %>
					</td>
					<td  width='70' align='right'><% if ( amt4 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt5/amt4)%><% } %>
					</td>						
					<td  width='90' align='right'><%=Util.parseDecimal(amt6)%></td>					
					<td  width='90' align='right'><%=Util.parseDecimal(amt5 - amt6)%></td>					
					<td  width='90' align='right'><input type="text" name="c_amt" size="10" value="<%=Util.parseDecimal( amt6+ amt5 - amt6)%>" class="whitenum"></td>							
					<td  width='60' align='right'><input type="text" name="a_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'>0</td>
				</tr>	
<% } %>				


				<tr>
					<td  width='100' align='center'>합계</td>	
					<td  width='60' align='right'><input type="text" name="c1_t_cnt" size="5" value="<%=Util.parseDecimal(sub_amt1)%>" class="whitenum"></td>																								
					<td  width='60' align='right'>100.0</td>
					<td  width='60' align='right'><input type="text" name="c2_t_cnt" size="5" value="<%=Util.parseDecimal( sub_amt2)%>" class="whitenum"></td>																								
					<td  width='60' align='right'>100.0</td>
					<td  width='60' align='right'><input type="text" name="c3_t_cnt" size="5" value="<%=Util.parseDecimal(sub_amt4)%>" class="whitenum"></td>																								
					<td  width='60' align='right'>100.0</td>
					<td  width='70' align='right'><%=Util.parseDecimal(sub_amt1 + sub_amt2 + sub_amt4)%></td>		
					<td  width='80' align='right'><%=Util.parseDecimal(sub_amt9)%></td>
					<td  width='80' align='right'><%=Util.parseDecimal(sub_amt10)%></td>
					<td  width='90' align='right'><%=Util.parseDecimal(sub_amt5)%></td>
					<td  width='70' align='right'><% if ( sub_amt3 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(sub_amt9/sub_amt3)%><% } %>
					</td>
					<td  width='70' align='right'><% if ( sub_amt3 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(sub_amt5/sub_amt3)%><% } %>
					</td>					
					<td  width='90' align='right'><%=Util.parseDecimal(sub_amt6)%></td>					
					<td  width='90' align='right'><%=Util.parseDecimal(sub_amt5 - sub_amt6)%></td>					
					<td  width='90' align='right'><input type="text" name="c_t_amt" size="10" value="<%=Util.parseDecimal( sub_amt6+ sub_amt5 - sub_amt6)%>" class="whitenum"> </td>							
					<td  width='60' align='right'>100.0</td>
					<td  width='70' align='right'><%=Util.parseDecimal(sub_amt11)%></td>
				</tr>	

<%if ( ht4.get("GUBUN1") != null   ) { %>	      				
				<tr>
					<td  width='70' align='center' rowspan=<%=cnt[1]+1%> > 부산지점</td>
					<td  width='110' align='center'><a href="javascript:parent.list_move('002105');">부경공업사</a></td>							
													
<%			
			amt1 	= AddUtil.parseLong(String.valueOf(ht4.get("IP_CNT")));
			amt2 	= AddUtil.parseLong(String.valueOf(ht4.get("CH_CNT")));
			amt4 	= AddUtil.parseLong(String.valueOf(ht4.get("TOT_CNT")));
			amt3 = amt4 - amt2;
			if ( amt3 < 0) {
			   amt3 = 0;
			}
			
			amt5 	= AddUtil.parseLong(String.valueOf(ht4.get("TOT_AMT")));
			amt6 	= AddUtil.parseLong(String.valueOf(ht4.get("PAY_AMT")));
			amt9 	= AddUtil.parseLong(String.valueOf(ht4.get("LABOR_AMT")));
			amt10 	= AddUtil.parseLong(String.valueOf(ht4.get("R_J_AMT")));
			
			sub1_amt1 	= sub1_amt1 + AddUtil.parseLong(String.valueOf(ht4.get("IP_CNT")));
			sub1_amt2 	= sub1_amt2 + AddUtil.parseLong(String.valueOf(ht4.get("CH_CNT")));
			sub1_amt3 	= sub1_amt3 + AddUtil.parseLong(String.valueOf(ht4.get("TOT_CNT")));
			sub1_amt4 	= sub1_amt4 + amt3;
				
			sub1_amt5 	= sub1_amt5 + AddUtil.parseLong(String.valueOf(ht4.get("TOT_AMT")));
			sub1_amt6 	= sub1_amt6 + AddUtil.parseLong(String.valueOf(ht4.get("PAY_AMT")));
			sub1_amt9 	= sub1_amt9 + AddUtil.parseLong(String.valueOf(ht4.get("LABOR_AMT"))); //공임
			sub1_amt10 	= sub1_amt10 + AddUtil.parseLong(String.valueOf(ht4.get("R_J_AMT")));  //부품		
			
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht4.get("IP_CNT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht4.get("CH_CNT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht4.get("TOT_CNT")));
			total_amt4 	= total_amt4 + amt3;
				
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht4.get("TOT_AMT")));
			total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht4.get("PAY_AMT")));
			total_amt9 	= total_amt9 + AddUtil.parseLong(String.valueOf(ht4.get("LABOR_AMT")));
			total_amt10 	= total_amt10 + AddUtil.parseLong(String.valueOf(ht4.get("R_J_AMT")));
			
%>									
					<td  width='60' align='right'><input type="text" name="c1_cnt" size="5" value="<%=Util.parseDecimal(amt1)%>" class="whitenum"></td>				 																									
					<td  width='60' align='right'><input type="text" name="c1_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c2_cnt" size="5" value="<%=Util.parseDecimal(amt2)%>" class="whitenum"></td>																										
					<td  width='60' align='right'><input type="text" name="c2_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c3_cnt" size="5" value="<%=Util.parseDecimal(amt3)%>" class="whitenum"></td>																										
					<td  width='60' align='right'><input type="text" name="c3_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'><%=Util.parseDecimal(amt1 + amt2 + amt3)%></td>			
					<td  width='80' align='right'><%=Util.parseDecimal(amt9)%></td>		
					<td  width='80' align='right'><%=Util.parseDecimal(amt10)%></td>		
					<td  width='90' align='right'><%=Util.parseDecimal(amt5)%></td>		
					<td  width='70' align='right'><% if ( amt4 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt9/amt4)%><% } %>
					</td>	
					<td  width='70' align='right'><% if ( amt4 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt5/amt4)%><% } %>
					</td>						
					<td  width='90' align='right'><%=Util.parseDecimal(amt6)%></td>					
					<td  width='90' align='right'><%=Util.parseDecimal(amt5 - amt6)%></td>					
					<td  width='90' align='right'><input type="text" name="c_amt" size="10" value="<%=Util.parseDecimal( amt6+ amt5 - amt6)%>" class="whitenum"></td>	 											
					<td  width='60' align='right'><input type="text" name="a_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'>0</td>
				</tr>

<% } %>	

<%if ( ht7.get("GUBUN1") != null   ) { %>

				<tr>					
					<td  width='110' align='center'><a href="javascript:parent.list_move('001816');">삼일정비</a></td>							
													
<%			
			amt1 	= AddUtil.parseLong(String.valueOf(ht7.get("IP_CNT")));
			amt2 	= AddUtil.parseLong(String.valueOf(ht7.get("CH_CNT")));
			amt4 	= AddUtil.parseLong(String.valueOf(ht7.get("TOT_CNT")));
			amt3 = amt4 - amt2;
			if ( amt3 < 0) {
			   amt3 = 0;
			}
			
			amt5 	= AddUtil.parseLong(String.valueOf(ht7.get("TOT_AMT")));
			amt6 	= AddUtil.parseLong(String.valueOf(ht7.get("PAY_AMT")));
			amt9 	= AddUtil.parseLong(String.valueOf(ht7.get("LABOR_AMT")));
			amt10 	= AddUtil.parseLong(String.valueOf(ht7.get("R_J_AMT")));
			
			sub1_amt1 	= sub1_amt1 + AddUtil.parseLong(String.valueOf(ht7.get("IP_CNT")));
			sub1_amt2 	= sub1_amt2 + AddUtil.parseLong(String.valueOf(ht7.get("CH_CNT")));
			sub1_amt3 	= sub1_amt3 + AddUtil.parseLong(String.valueOf(ht7.get("TOT_CNT")));
			sub1_amt4 	= sub1_amt4 + amt3;
				
			sub1_amt5 	= sub1_amt5 + AddUtil.parseLong(String.valueOf(ht7.get("TOT_AMT")));
			sub1_amt6 	= sub1_amt6 + AddUtil.parseLong(String.valueOf(ht7.get("PAY_AMT")));
			sub1_amt9 	= sub1_amt9 + AddUtil.parseLong(String.valueOf(ht7.get("LABOR_AMT"))); //공임
			sub1_amt10 	= sub1_amt10 + AddUtil.parseLong(String.valueOf(ht7.get("R_J_AMT")));  //부품		
			
			
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht7.get("IP_CNT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht7.get("CH_CNT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht7.get("TOT_CNT")));
			total_amt4 	= total_amt4 + amt3;
				
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht7.get("TOT_AMT")));
			total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht7.get("PAY_AMT")));
			total_amt9 	= total_amt9 + AddUtil.parseLong(String.valueOf(ht7.get("LABOR_AMT")));
			total_amt10 	= total_amt10 + AddUtil.parseLong(String.valueOf(ht7.get("R_J_AMT")));
			
%>									
					<td  width='60' align='right'><input type="text" name="c1_cnt" size="5" value="<%=Util.parseDecimal(amt1)%>" class="whitenum"></td>				 																									
					<td  width='60' align='right'><input type="text" name="c1_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c2_cnt" size="5" value="<%=Util.parseDecimal(amt2)%>" class="whitenum"></td>																										
					<td  width='60' align='right'><input type="text" name="c2_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c3_cnt" size="5" value="<%=Util.parseDecimal(amt3)%>" class="whitenum"></td>																									
					<td  width='60' align='right'><input type="text" name="c3_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'><%=Util.parseDecimal(amt1 + amt2 + amt3)%></td>			
					<td  width='80' align='right'><%=Util.parseDecimal(amt9)%></td>	
					<td  width='80' align='right'><%=Util.parseDecimal(amt10)%></td>	
					<td  width='90' align='right'><%=Util.parseDecimal(amt5)%></td>			
					<td  width='70' align='right'>
					<% if ( amt4 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt9/amt4)%><% } %>
					</td>	
					<td  width='70' align='right'><% if ( amt4 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt5/amt4)%><% } %>
					</td>						
					<td  width='90' align='right'><%=Util.parseDecimal(amt6)%></td>					
					<td  width='90' align='right'><%=Util.parseDecimal(amt5 - amt6)%></td>					
					<td  width='90' align='right'><input type="text" name="c_amt" size="10" value="<%=Util.parseDecimal( amt6+ amt5 - amt6)%>" class="whitenum"></td>	 							
					<td  width='60' align='right'><input type="text" name="a_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'>0</td>
				</tr>

<% } %>				
			<tr>
					<td  width='110' align='center'>합계</td>	
					<td  width='60' align='right'><input type="text" name="c1_t_cnt" size="5" value="<%=Util.parseDecimal(sub1_amt1)%>" class="whitenum"></td>																								
					<td  width='60' align='right'>100.0</td>
					<td  width='60' align='right'><input type="text" name="c2_t_cnt" size="5" value="<%=Util.parseDecimal(sub1_amt2)%>" class="whitenum"></td>																								
					<td  width='60' align='right'>100.0</td>
					<td  width='60' align='right'><input type="text" name="c3_t_cnt" size="5" value="<%=Util.parseDecimal(sub1_amt4)%>" class="whitenum"></td>																								
					<td  width='60' align='right'>100.0</td>
					<td  width='70' align='right'><%=Util.parseDecimal(sub1_amt1 + sub1_amt2 + sub1_amt4)%></td>		
					<td  width='80' align='right'><%=Util.parseDecimal(sub1_amt9)%></td>	
					<td  width='80' align='right'><%=Util.parseDecimal(sub1_amt10)%></td>	
					<td  width='90' align='right'><%=Util.parseDecimal(sub1_amt5)%></td>	
					<td  width='70' align='right'><% if ( sub1_amt3 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(sub1_amt9/sub1_amt3)%><% } %>
					</td>
					<td  width='70' align='right'><% if ( sub1_amt3 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(sub1_amt5/sub1_amt3)%><% } %>
					</td>
					<td  width='90' align='right'><%=Util.parseDecimal(sub1_amt6)%></td>					
					<td  width='90' align='right'><%=Util.parseDecimal(sub1_amt5 - sub1_amt6)%></td>					
					<td  width='90' align='right'><input type="text" name="c_t_amt" size="10" value="<%=Util.parseDecimal( sub1_amt6+ sub1_amt5 - sub1_amt6)%>" class="whitenum"> </td>							
					<td  width='60' align='right'>100.0</td>
					<td  width='70' align='right'>0</td>
				</tr>				
				
				
<%if ( ht5.get("GUBUN1") != null   ) { %>	
				<tr>
					<td  width='70' align='center'  rowspan=<%=cnt[2]+1%> >대전지점</td>
					<td  width='110' align='center'><a href="javascript:parent.list_move('002734');">현대카독크</a></td>							
													
<%			
			amt1 	= AddUtil.parseLong(String.valueOf(ht5.get("IP_CNT")));
			amt2 	= AddUtil.parseLong(String.valueOf(ht5.get("CH_CNT")));
			amt4 	= AddUtil.parseLong(String.valueOf(ht5.get("TOT_CNT")));
			
			amt3 = amt4 - amt2;
			if ( amt3 < 0) {
			   amt3 = 0;
			}
			amt5 	= AddUtil.parseLong(String.valueOf(ht5.get("TOT_AMT")));
			amt6 	= AddUtil.parseLong(String.valueOf(ht5.get("PAY_AMT")));
			amt9 	= AddUtil.parseLong(String.valueOf(ht5.get("LABOR_AMT")));
			amt10 	= AddUtil.parseLong(String.valueOf(ht5.get("R_J_AMT")));
			
			sub2_amt1 	= sub2_amt1 + AddUtil.parseLong(String.valueOf(ht5.get("IP_CNT")));
			sub2_amt2 	= sub2_amt2 + AddUtil.parseLong(String.valueOf(ht5.get("CH_CNT")));
			sub2_amt3 	= sub2_amt3 + AddUtil.parseLong(String.valueOf(ht5.get("TOT_CNT")));
			sub2_amt4 	= sub2_amt4 + amt3;
				
			sub2_amt5 	= sub2_amt5 + AddUtil.parseLong(String.valueOf(ht5.get("TOT_AMT")));
			sub2_amt6 	= sub2_amt6 + AddUtil.parseLong(String.valueOf(ht5.get("PAY_AMT")));
			sub2_amt9 	= sub2_amt9 + AddUtil.parseLong(String.valueOf(ht5.get("LABOR_AMT")));
			sub2_amt10 	= sub2_amt10 + AddUtil.parseLong(String.valueOf(ht5.get("R_J_AMT")));
						
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht5.get("IP_CNT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht5.get("CH_CNT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht5.get("TOT_CNT")));
			total_amt4 	= total_amt4 + amt3;
				
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht5.get("TOT_AMT")));
			total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht5.get("PAY_AMT")));
			total_amt9 	= total_amt9 + AddUtil.parseLong(String.valueOf(ht5.get("LABOR_AMT")));
			total_amt10 	= total_amt10 + AddUtil.parseLong(String.valueOf(ht5.get("R_J_AMT")));
			
%>						
					<td  width='60' align='right'><input type="text" name="c1_cnt" size="5" value="<%=AddUtil.parseDecimal(amt1)%>" class="whitenum"></td>																						
					<td  width='60' align='right'><input type="text" name="c1_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c2_cnt" size="5" value="<%=AddUtil.parseDecimal(amt2)%>" class="whitenum"></td>																						
					<td  width='60' align='right'><input type="text" name="c2_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c3_cnt" size="5" value="<%=AddUtil.parseDecimal( amt3)%>" class="whitenum"></td>																						
					<td  width='60' align='right'><input type="text" name="c3_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'><%=AddUtil.parseDecimal(amt1 + amt2 + amt3)%></td>	
					<td  width='80' align='right'><%=AddUtil.parseDecimal(amt9)%></td>	
					<td  width='80' align='right'><%=AddUtil.parseDecimal(amt10)%></td>	
					<td  width='90' align='right'><%=AddUtil.parseDecimal(amt5)%></td>	
					
					<td  width='70' align='right'><% if ( amt4 == 0 || amt9 == 0 ) {%>0					
					<% } else {%><%=AddUtil.parseDecimal(amt9/amt4)%><% } %>
					</td>	
					
					<td  width='70' align='right'><% if ( amt4 == 0 || amt5 == 0 ) {%>0					
					<% } else {%><%=AddUtil.parseDecimal(amt5/amt4)%><% } %>
					</td>					
					
					<td  width='90' align='right'><%=AddUtil.parseDecimal(amt6)%></td>					
					<td  width='90' align='right'><%=AddUtil.parseDecimal(amt5 - amt6)%></td>					
					<td  width='90' align='right'><input type="text" name="c_amt" size="10" value="<%=AddUtil.parseDecimal( amt6+ amt5 - amt6)%>" class="whitenum"></td>							
					<td  width='60' align='right'><input type="text" name="a_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'>0</td>
				</tr>
				
<% } %>	

<%         	if (  AddUtil.parseLong(String.valueOf(ht6.get("IP_CNT")))   != 0 ||  AddUtil.parseLong(String.valueOf(ht6.get("CH_CNT")))   != 0 ||  AddUtil.parseLong(String.valueOf(ht6.get("TOT_CNT")))   != 0  ||  AddUtil.parseLong(String.valueOf(ht6.get("PAY_AMT")))   != 0    )    {  %>
					
			<tr>			
					<td  width='110' align='center'><a href="javascript:parent.list_move('007603');">노블래스</a></td>							
													
<%			
			amt1 	= AddUtil.parseLong(String.valueOf(ht6.get("IP_CNT")));
			amt2 	= AddUtil.parseLong(String.valueOf(ht6.get("CH_CNT")));
			amt4 	= AddUtil.parseLong(String.valueOf(ht6.get("TOT_CNT")));
			
			amt3 = amt4 - amt2;
			if ( amt3 < 0) {
			   amt3 = 0;
			}
			amt5 	= AddUtil.parseLong(String.valueOf(ht6.get("TOT_AMT")));			
			amt6 	= AddUtil.parseLong(String.valueOf(ht6.get("PAY_AMT")));
			amt9 	= AddUtil.parseLong(String.valueOf(ht6.get("LABOR_AMT")));
			amt10 	= AddUtil.parseLong(String.valueOf(ht6.get("R_J_AMT")));
			
			sub2_amt1 	= sub2_amt1 + AddUtil.parseLong(String.valueOf(ht6.get("IP_CNT")));
			sub2_amt2 	= sub2_amt2 + AddUtil.parseLong(String.valueOf(ht6.get("CH_CNT")));
			sub2_amt3 	= sub2_amt3 + AddUtil.parseLong(String.valueOf(ht6.get("TOT_CNT")));
			sub2_amt4 	= sub2_amt4 + amt3;
				
			sub2_amt5 	= sub2_amt5 + AddUtil.parseLong(String.valueOf(ht6.get("TOT_AMT")));
			sub2_amt6 	= sub2_amt6 + AddUtil.parseLong(String.valueOf(ht6.get("PAY_AMT")));
			sub2_amt9 	= sub2_amt9 + AddUtil.parseLong(String.valueOf(ht6.get("LABOR_AMT")));
			sub2_amt10 	= sub2_amt10 + AddUtil.parseLong(String.valueOf(ht6.get("R_J_AMT")));
			
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht6.get("IP_CNT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht6.get("CH_CNT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht6.get("TOT_CNT")));
			total_amt4 	= total_amt4 + amt3;
				
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht6.get("TOT_AMT")));
			total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht6.get("PAY_AMT")));
			total_amt9 	= total_amt9 + AddUtil.parseLong(String.valueOf(ht6.get("LABOR_AMT")));
			total_amt10 	= total_amt10 + AddUtil.parseLong(String.valueOf(ht6.get("R_J_AMT")));
			
%>										
					<td  width='60' align='right'><input type="text" name="c1_cnt" size="5" value="<%=Util.parseDecimal(amt1)%>" class="whitenum"></td>																						
					<td  width='60' align='right'><input type="text" name="c1_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c2_cnt" size="5" value="<%=Util.parseDecimal(amt2)%>" class="whitenum"></td>																						
					<td  width='60' align='right'><input type="text" name="c2_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c3_cnt" size="5" value="<%=Util.parseDecimal( amt3)%>" class="whitenum"></td>																						
					<td  width='60' align='right'><input type="text" name="c3_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'><%=Util.parseDecimal(amt1 + amt2 + amt3)%></td>	
					<td  width='80' align='right'><%=Util.parseDecimal(amt9)%></td>
					<td  width='80' align='right'><%=Util.parseDecimal(amt10)%></td>	
					<td  width='90' align='right'><%=Util.parseDecimal(amt5)%></td>	
					<td  width='70' align='right'><% if ( amt4 == 0 || amt9 ==0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt9/amt4)%><% } %>
					 </td>
					 <td  width='70' align='right'><% if ( amt4 == 0 || amt5 ==0  ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt5/amt4)%><% } %>
					</td>						
					<td  width='90' align='right'><%=Util.parseDecimal(amt6)%></td>					
					<td  width='90' align='right'><%=Util.parseDecimal(amt5 - amt6)%></td>					
					<td  width='90' align='right'><input type="text" name="c_amt" size="10" value="<%=Util.parseDecimal( amt6+ amt5 - amt6)%>" class="whitenum"></td>							
					<td  width='60' align='right'><input type="text" name="a_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'>0</td>
				</tr>	
				
<% } %>


<%  if (  AddUtil.parseLong(String.valueOf(ht8.get("IP_CNT")))   != 0 ||  AddUtil.parseLong(String.valueOf(ht8.get("CH_CNT")))   != 0 ||  AddUtil.parseLong(String.valueOf(ht8.get("TOT_CNT")))   != 0  ||  AddUtil.parseLong(String.valueOf(ht8.get("PAY_AMT")))   != 0    )   { %>
	
				<tr>					
					<td  width='110' align='center'><a href="javascript:parent.list_move('007897');">1급금호자동차</a></td>							
													
<%			
			amt1 	= AddUtil.parseLong(String.valueOf(ht8.get("IP_CNT")));
			amt2 	= AddUtil.parseLong(String.valueOf(ht8.get("CH_CNT")));
			amt4 	= AddUtil.parseLong(String.valueOf(ht8.get("TOT_CNT")));
					
			amt3 = amt4 - amt2;
			if ( amt3 < 0) {
			   amt3 = 0;
			}
			amt5 	= AddUtil.parseLong(String.valueOf(ht8.get("TOT_AMT")));			
			amt6 	= AddUtil.parseLong(String.valueOf(ht8.get("PAY_AMT")));
			amt9 	= AddUtil.parseLong(String.valueOf(ht8.get("LABOR_AMT")));
			amt10 	= AddUtil.parseLong(String.valueOf(ht8.get("R_J_AMT")));
			
			sub2_amt1 	= sub2_amt1 + AddUtil.parseLong(String.valueOf(ht8.get("IP_CNT")));
			sub2_amt2 	= sub2_amt2 + AddUtil.parseLong(String.valueOf(ht8.get("CH_CNT")));
			sub2_amt3 	= sub2_amt3 + AddUtil.parseLong(String.valueOf(ht8.get("TOT_CNT")));
			sub2_amt4 	= sub2_amt4 + amt3;
				
			sub2_amt5 	= sub2_amt5 + AddUtil.parseLong(String.valueOf(ht8.get("TOT_AMT")));
			sub2_amt6 	= sub2_amt6 + AddUtil.parseLong(String.valueOf(ht8.get("PAY_AMT")));
			sub2_amt9 	= sub2_amt9 + AddUtil.parseLong(String.valueOf(ht8.get("LABOR_AMT")));
			sub2_amt10 	= sub2_amt10 + AddUtil.parseLong(String.valueOf(ht8.get("R_J_AMT")));
			
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht8.get("IP_CNT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht8.get("CH_CNT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht8.get("TOT_CNT")));
			total_amt4 	= total_amt4 + amt3;
				
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht8.get("TOT_AMT")));
			total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht8.get("PAY_AMT")));
			total_amt9 	= total_amt9 + AddUtil.parseLong(String.valueOf(ht8.get("LABOR_AMT")));
			total_amt10 	= total_amt10 + AddUtil.parseLong(String.valueOf(ht8.get("R_J_AMT")));
			
%>										
					<td  width='60' align='right'><input type="text" name="c1_cnt" size="5" value="<%=Util.parseDecimal(amt1)%>" class="whitenum"></td>																						
					<td  width='60' align='right'><input type="text" name="c1_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c2_cnt" size="5" value="<%=Util.parseDecimal(amt2)%>" class="whitenum"></td>																						
					<td  width='60' align='right'><input type="text" name="c2_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c3_cnt" size="5" value="<%=Util.parseDecimal( amt3)%>" class="whitenum"></td>																						
					<td  width='60' align='right'><input type="text" name="c3_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'><%=Util.parseDecimal(amt1 + amt2 + amt3)%></td>	
					<td  width='80' align='right'><%=Util.parseDecimal(amt9)%></td>	
					<td  width='80' align='right'><%=Util.parseDecimal(amt10)%></td>	
					<td  width='90' align='right'><%=Util.parseDecimal(amt5)%></td>	
					<td  width='70' align='right'><% if ( amt4 == 0 || amt9 == 0) {%>0					
					<% } else {%><%=Util.parseDecimal(amt9/amt4)%><% } %>
					</td>
					<td  width='70' align='right'><% if ( amt4 == 0 || amt5 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt5/amt4)%><% } %>
					</td>							
					<td  width='90' align='right'><%=Util.parseDecimal(amt6)%></td>					
					<td  width='90' align='right'><%=Util.parseDecimal(amt5 - amt6)%></td>					
					<td  width='90' align='right'><input type="text" name="c_amt" size="10" value="<%=Util.parseDecimal( amt6+ amt5 - amt6)%>" class="whitenum"></td>							
					<td  width='60' align='right'><input type="text" name="a_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'>0</td>
				</tr>	
<% } %>	




				<tr>
					<td  width='110' align='center'>합계</td>	
					<td  width='60' align='right'><input type="text" name="c1_t_cnt" size="5" value="<%=Util.parseDecimal(sub2_amt1)%>" class="whitenum"></td>																								
					<td  width='60' align='right'>100.0</td>
					<td  width='60' align='right'><input type="text" name="c2_t_cnt" size="5" value="<%=Util.parseDecimal( sub2_amt2)%>" class="whitenum"></td>																								
					<td  width='60' align='right'>100.0</td>
					<td  width='60' align='right'><input type="text" name="c3_t_cnt" size="5" value="<%=Util.parseDecimal(sub2_amt4)%>" class="whitenum"></td>																								
					<td  width='60' align='right'>100.0</td>
					<td  width='70' align='right'><%=Util.parseDecimal(sub2_amt1 + sub2_amt2 + sub2_amt4)%></td>		
					<td  width='80' align='right'><%=Util.parseDecimal(sub2_amt9)%></td>	
					<td  width='80' align='right'><%=Util.parseDecimal(sub2_amt10)%></td>	
					<td  width='90' align='right'><%=Util.parseDecimal(sub2_amt5)%></td>	
					<td  width='70' align='right'><% if ( sub2_amt3 == 0 || sub2_amt9 == 0) {%>0					
					<% } else {%><%=Util.parseDecimal(sub2_amt9/sub2_amt3)%><% } %>
					</td>
					<td  width='70' align='right'><% if ( sub2_amt3 == 0 || sub2_amt5 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(sub2_amt5/sub2_amt3)%><% } %>
					</td>
					<td  width='90' align='right'><%=Util.parseDecimal(sub2_amt6)%></td>					
					<td  width='90' align='right'><%=Util.parseDecimal(sub2_amt5 - sub2_amt6)%></td>					
					<td  width='90' align='right'><input type="text" name="c_t_amt" size="10" value="<%=Util.parseDecimal( sub2_amt6+ sub2_amt5 - sub2_amt6)%>" class="whitenum"> </td>							
					<td  width='60' align='right'>100.0</td>
					<td  width='70' align='right'>0</td>
				</tr>


				
<%if ( ht9.get("GUBUN1") != null   ) { %>					
				<tr>
					<td  width='80' align='center' >대구지점</td>
					<td  width='110' align='center'><a href="javascript:parent.list_move('008462');">성서현대</a></td>							
													
<%			
			amt1 	= AddUtil.parseLong(String.valueOf(ht9.get("IP_CNT")));
			amt2 	= AddUtil.parseLong(String.valueOf(ht9.get("CH_CNT")));
			amt4 	= AddUtil.parseLong(String.valueOf(ht9.get("TOT_CNT")));
			
			amt3 = amt4 - amt2;
			if ( amt3 < 0) {
			   amt3 = 0;
			}
			
			amt5 	= AddUtil.parseLong(String.valueOf(ht9.get("TOT_AMT")));
			amt6 	= AddUtil.parseLong(String.valueOf(ht9.get("PAY_AMT")));
			amt9 	= AddUtil.parseLong(String.valueOf(ht9.get("LABOR_AMT")));
			amt10 	= AddUtil.parseLong(String.valueOf(ht9.get("R_J_AMT")));
									
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht9.get("IP_CNT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht9.get("CH_CNT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht9.get("TOT_CNT")));
			total_amt4 	= total_amt4 + amt3;
				
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht9.get("TOT_AMT")));
			total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht9.get("PAY_AMT")));
			total_amt9 	= total_amt9 + AddUtil.parseLong(String.valueOf(ht9.get("LABOR_AMT")));
			total_amt10 	= total_amt10 + AddUtil.parseLong(String.valueOf(ht9.get("R_J_AMT")));
		
%>						
					<td  width='60' align='right'><%=Util.parseDecimal(amt1)%></td>																									
					<td  width='60' align='right'>100.0</td>
					<td  width='60' align='right'><%=Util.parseDecimal( amt2)%></td>																									
					<td  width='60' align='right'>100.0</td>
					<td  width='60' align='right'><%=Util.parseDecimal(amt3)%></td>																									
					<td  width='60' align='right'>100.0</td>
					<td  width='70' align='right'><%=Util.parseDecimal(amt1 + amt2 + amt3)%></td>	
					<td  width='80' align='right'><%=Util.parseDecimal(amt9)%></td>
					<td  width='80' align='right'><%=Util.parseDecimal(amt10)%></td>
					<td  width='90' align='right'><%=Util.parseDecimal(amt5)%></td>
					<td  width='70' align='right'><% if ( amt4 == 0 || amt9 == 0) {%>0					
					<% } else {%><%=Util.parseDecimal(amt9/amt4)%><% } %>
					</td>	
					<td  width='70' align='right'><% if ( amt4 == 0 || amt5 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt5/amt4)%><% } %>
					</td>											
					<td  width='90' align='right'><%=Util.parseDecimal(amt6)%></td>					
					<td  width='90' align='right'><%=Util.parseDecimal(amt5 - amt6)%></td>					
					<td  width='90' align='right'><%=Util.parseDecimal( amt6+ amt5 - amt6)%></td>							
					<td  width='60' align='right'>100.0</td>
					<td  width='70' align='right'>0</td>
				</tr>						
									
<% } %>

<%if ( ht10.get("GUBUN1") != null   ) { %>					
				<tr>
					<td  width='80' align='center'  rowspan=<%=cnt[4]+1%>>광주지점</td>
					<td  width='110' align='center'><a href="javascript:parent.list_move('008507');">상무현대</a></td>							
													
<%			
			amt1 	= AddUtil.parseLong(String.valueOf(ht10.get("IP_CNT")));
			amt2 	= AddUtil.parseLong(String.valueOf(ht10.get("CH_CNT")));
			amt4 	= AddUtil.parseLong(String.valueOf(ht10.get("TOT_CNT")));
			
			amt3 = amt4 - amt2;
			if ( amt3 < 0) {
			   amt3 = 0;
			}
			
			amt5 	= AddUtil.parseLong(String.valueOf(ht10.get("TOT_AMT")));
			amt6 	= AddUtil.parseLong(String.valueOf(ht10.get("PAY_AMT")));
			amt9 	= AddUtil.parseLong(String.valueOf(ht10.get("LABOR_AMT")));
			amt10 	= AddUtil.parseLong(String.valueOf(ht10.get("R_J_AMT")));
									
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht10.get("IP_CNT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht10.get("CH_CNT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht10.get("TOT_CNT")));
			total_amt4 	= total_amt4 + amt3;
				
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht10.get("TOT_AMT")));
			total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht10.get("PAY_AMT")));
			total_amt9 	= total_amt9 + AddUtil.parseLong(String.valueOf(ht10.get("LABOR_AMT")));
			total_amt10 	= total_amt10 + AddUtil.parseLong(String.valueOf(ht10.get("R_J_AMT")));
		
%>					
					<td  width='60' align='right'><input type="text" name="c1_cnt" size="5" value="<%=Util.parseDecimal(amt1)%>" class="whitenum"></td>																						
					<td  width='60' align='right'><input type="text" name="c1_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c2_cnt" size="5" value="<%=Util.parseDecimal(amt2)%>" class="whitenum"></td>																						
					<td  width='60' align='right'><input type="text" name="c2_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c3_cnt" size="5" value="<%=Util.parseDecimal( amt3)%>" class="whitenum"></td>																						
					<td  width='60' align='right'><input type="text" name="c3_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'><%=Util.parseDecimal(amt1 + amt2 + amt3)%></td>	
					<td  width='80' align='right'><%=Util.parseDecimal(amt9)%></td>
					<td  width='80' align='right'><%=Util.parseDecimal(amt10)%></td>
					<td  width='90' align='right'><%=Util.parseDecimal(amt5)%></td>
					<td  width='70' align='right'><% if ( amt4 == 0 || amt9 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt9/amt4)%><% } %>
					</td>
					<td  width='70' align='right'><% if ( amt4 == 0 || amt5 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt5/amt4)%><% } %>
					</td>							
					<td  width='90' align='right'><%=Util.parseDecimal(amt6)%></td>					
					<td  width='90' align='right'><%=Util.parseDecimal(amt5 - amt6)%></td>					
					<td  width='90' align='right'><input type="text" name="c_amt" size="10" value="<%=Util.parseDecimal( amt6+ amt5 - amt6)%>" class="whitenum"></td>							
					<td  width='60' align='right'><input type="text" name="a_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'>0</td>
					
				</tr>						
<% } %>		

<%	if ( ht12.get("GUBUN1") != null   )         { %>
				<tr>					
					<td  width='110' align='center'><a href="javascript:parent.list_move('006490');">상무1급</a></td>							
													
<%			
			amt1 	= AddUtil.parseLong(String.valueOf(ht12.get("IP_CNT")));
			amt2 	= AddUtil.parseLong(String.valueOf(ht12.get("CH_CNT")));
			amt4 	= AddUtil.parseLong(String.valueOf(ht12.get("TOT_CNT")));
			
			amt3 = amt4 - amt2;
			if ( amt3 < 0) {
			   amt3 = 0;
			}
			
			amt5 	= AddUtil.parseLong(String.valueOf(ht12.get("TOT_AMT")));
			amt6 	= AddUtil.parseLong(String.valueOf(ht12.get("PAY_AMT")));			
			amt9 	= AddUtil.parseLong(String.valueOf(ht12.get("LABOR_AMT")));
			amt10 	= AddUtil.parseLong(String.valueOf(ht12.get("R_J_AMT")));
			
			sub3_amt1 	= sub3_amt1 + AddUtil.parseLong(String.valueOf(ht12.get("IP_CNT")));
			sub3_amt2 	= sub3_amt2 + AddUtil.parseLong(String.valueOf(ht12.get("CH_CNT")));
			sub3_amt3 	= sub3_amt3 + AddUtil.parseLong(String.valueOf(ht12.get("TOT_CNT")));
			sub3_amt4 	= sub3_amt4 + amt3;
				
			sub3_amt5 	= sub3_amt5 + AddUtil.parseLong(String.valueOf(ht12.get("TOT_AMT")));
			sub3_amt6 	= sub3_amt6 + AddUtil.parseLong(String.valueOf(ht12.get("PAY_AMT")));
			sub3_amt9 	= sub3_amt9 + AddUtil.parseLong(String.valueOf(ht12.get("LABOR_AMT"))); //공임
			sub3_amt10 	= sub3_amt10 + AddUtil.parseLong(String.valueOf(ht12.get("R_J_AMT")));  //부품			
			
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht12.get("IP_CNT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht12.get("CH_CNT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht12.get("TOT_CNT")));
			total_amt4 	= total_amt4 + amt3;
				
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht12.get("TOT_AMT")));
			total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht12.get("PAY_AMT")));
			total_amt9 	= total_amt9 + AddUtil.parseLong(String.valueOf(ht12.get("LABOR_AMT")));
			total_amt10 	= total_amt10 + AddUtil.parseLong(String.valueOf(ht12.get("R_J_AMT")));
			
%>										
					<td  width='60' align='right'><input type="text" name="c1_cnt" size="5" value="<%=Util.parseDecimal(amt1)%>" class="whitenum"></td>																						
					<td  width='60' align='right'><input type="text" name="c1_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c2_cnt" size="5" value="<%=Util.parseDecimal(amt2)%>" class="whitenum"></td>																						
					<td  width='60' align='right'><input type="text" name="c2_per" size="5" value="" class="whitenum"></td>
					<td  width='60' align='right'><input type="text" name="c3_cnt" size="5" value="<%=Util.parseDecimal( amt3)%>" class="whitenum"></td>																						
					<td  width='60' align='right'><input type="text" name="c3_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'><%=Util.parseDecimal(amt1 + amt2 + amt3)%></td>	
					<td  width='80' align='right'><%=Util.parseDecimal(amt9)%></td>
					<td  width='80' align='right'><%=Util.parseDecimal(amt10)%></td>
					<td  width='90' align='right'><%=Util.parseDecimal(amt5)%></td>
					<td  width='70' align='right'><% if ( amt4 == 0 || amt9 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt9/amt4)%><% } %>
					</td>
					<td  width='70' align='right'><% if ( amt4 == 0 || amt5 == 0 ) {%>0					
					<% } else {%><%=Util.parseDecimal(amt5/amt4)%><% } %>
					</td>							
					<td  width='90' align='right'><%=Util.parseDecimal(amt6)%></td>					
					<td  width='90' align='right'><%=Util.parseDecimal(amt5 - amt6)%></td>					
					<td  width='90' align='right'><input type="text" name="c_amt" size="10" value="<%=Util.parseDecimal( amt6+ amt5 - amt6)%>" class="whitenum"></td>							
					<td  width='60' align='right'><input type="text" name="a_per" size="5" value="" class="whitenum"></td>
					<td  width='70' align='right'>0</td>
				</tr>	
				
<% } %>		
					<tr>
					<td  width='110' align='center'>합계</td>	
					<td  width='60' align='right'><input type="text" name="c1_t_cnt" size="5" value="<%=Util.parseDecimal(sub3_amt1)%>" class="whitenum"></td>																								
					<td  width='60' align='right'>100.0</td>
					<td  width='60' align='right'><input type="text" name="c2_t_cnt" size="5" value="<%=Util.parseDecimal(sub3_amt2)%>" class="whitenum"></td>																								
					<td  width='60' align='right'>100.0</td>
					<td  width='60' align='right'><input type="text" name="c3_t_cnt" size="5" value="<%=Util.parseDecimal(sub3_amt4)%>" class="whitenum"></td>																								
					<td  width='60' align='right'>100.0</td>
					<td  width='70' align='right'><%=Util.parseDecimal(sub3_amt1 + sub3_amt2 + sub3_amt4)%></td>		
					<td  width='80' align='right'><%=Util.parseDecimal(sub3_amt9)%></td>	
					<td  width='80' align='right'><%=Util.parseDecimal(sub3_amt10)%></td>	
					<td  width='90' align='right'><%=Util.parseDecimal(sub3_amt5)%></td>	
					<td  width='70' align='right'><% if ( sub1_amt3 == 0  || sub3_amt9 == 0) {%>0					
					<% } else {%><%=Util.parseDecimal(sub3_amt9/sub3_amt3)%><% } %>
					</td>
					<td  width='70' align='right'><% if ( sub3_amt3 == 0  || sub3_amt5 == 0) {%>0					
					<% } else {%><%=Util.parseDecimal(sub3_amt5/sub3_amt3)%><% } %>
					</td>
					<td  width='90' align='right'><%=Util.parseDecimal(sub3_amt6)%></td>					
					<td  width='90' align='right'><%=Util.parseDecimal(sub3_amt5 - sub3_amt6)%></td>					
					<td  width='90' align='right'><input type="text" name="c_t_amt" size="10" value="<%=Util.parseDecimal( sub3_amt6+ sub3_amt5 - sub3_amt6)%>" class="whitenum"> </td>							
					<td  width='60' align='right'>100.0</td>
					<td  width='70' align='right'>0</td>
				</tr>				

		
				<tr>
					<td  colspan=2  align='center' >총계</td>									
					<td  width='60' align='right'><%=Util.parseDecimal(total_amt1)%></td>																								
					<td  width='60' align='right'>100.0</td>
					<td  width='60' align='right'><%=Util.parseDecimal(total_amt2)%></td>																								
					<td  width='60' align='right'>100.0</td>
					<td  width='60' align='right'><%=Util.parseDecimal( total_amt4)%></td>																								
					<td  width='60' align='right'>100.0</td>
					<td  width='70' align='right'><%=Util.parseDecimal(total_amt1 + total_amt2 + total_amt4)%></td>		
					<td  width='80' align='right'><%=Util.parseDecimal(total_amt9)%></td>	
					<td  width='80' align='right'><%=Util.parseDecimal(total_amt10)%></td>	
					<td  width='90' align='right'><%=Util.parseDecimal(total_amt5)%></td>	
					<td  width='70' align='right'><% if ( total_amt3 == 0  || total_amt9 == 0) {%>0					
					<% } else {%><%=Util.parseDecimal(total_amt9/total_amt3)%><% } %>
					</td>	
					<td  width='70' align='right'><% if ( total_amt3 == 0  || total_amt5 == 0) {%>0					
					<% } else {%><%=Util.parseDecimal(total_amt5/total_amt3)%><% } %>
					</td>	
					<td  width='90' align='right'><%=Util.parseDecimal(total_amt6)%></td>					
					<td  width='90' align='right'><%=Util.parseDecimal(total_amt5 - total_amt6)%></td>					
					<td  width='90' align='right'><%=Util.parseDecimal( total_amt6+ total_amt5 - total_amt6)%></td>							
					<td  width='60' align='right'>100.0</td>
					<td  width='70' align='right'><%=Util.parseDecimal(total_amt11)%></td>
				</tr>	
				
			</table>
		</td>
        </tr>
                        
</table>
</form>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	set_per();
	
	function set_per(){
		
		var fm = document.form1;
				
		//계
		for(i=0; i<10; i++){
			if ( i  == 0 ||   i  == 1 ||  i  == 2 ||  i  == 3) {
			  	fm.c1_per[i].value=parseFloatCipher(toInt(parseDigit(fm.c1_cnt[i].value))  /  toInt(parseDigit(fm.c1_t_cnt[0].value))   * 100 ,   1  );			
				fm.c2_per[i].value=parseFloatCipher(toInt(parseDigit(fm.c2_cnt[i].value))  /  toInt(parseDigit(fm.c2_t_cnt[0].value))   * 100 ,   1  );			
				fm.c3_per[i].value=parseFloatCipher(toInt(parseDigit(fm.c3_cnt[i].value))  /  toInt(parseDigit(fm.c3_t_cnt[0].value))   * 100 ,   1  );
				fm.a_per[i].value=parseFloatCipher(toInt(parseDigit(fm.c_amt[i].value))  /  toInt(parseDigit(fm.c_t_amt[0].value))   * 100,  1  );	
			} else  if ( i  ==4 ||   i  == 5   ) {
				fm.c1_per[i].value=parseFloatCipher(toInt(parseDigit(fm.c1_cnt[i].value))  /  toInt(parseDigit(fm.c1_t_cnt[1].value))   * 100 ,   1  );			
				fm.c2_per[i].value=parseFloatCipher(toInt(parseDigit(fm.c2_cnt[i].value))  /  toInt(parseDigit(fm.c2_t_cnt[1].value))   * 100 ,   1  );			
				fm.c3_per[i].value=parseFloatCipher(toInt(parseDigit(fm.c3_cnt[i].value))  /  toInt(parseDigit(fm.c3_t_cnt[1].value))   * 100 ,   1  );
				fm.a_per[i].value=parseFloatCipher(toInt(parseDigit(fm.c_amt[i].value))  /  toInt(parseDigit(fm.c_t_amt[1].value))   * 100,  1  );					
			} else if ( i  == 6 ||   i  == 7  ||   i  == 8  ) {	
				fm.c1_per[i].value=parseFloatCipher(toInt(parseDigit(fm.c1_cnt[i].value))  /  toInt(parseDigit(fm.c1_t_cnt[2].value))   * 100 ,   1  );			
				fm.c2_per[i].value=parseFloatCipher(toInt(parseDigit(fm.c2_cnt[i].value))  /  toInt(parseDigit(fm.c2_t_cnt[2].value))   * 100 ,   1  );			
				fm.c3_per[i].value=parseFloatCipher(toInt(parseDigit(fm.c3_cnt[i].value))  /  toInt(parseDigit(fm.c3_t_cnt[2].value))   * 100 ,   1  );
				fm.a_per[i].value=parseFloatCipher(toInt(parseDigit(fm.c_amt[i].value))  /  toInt(parseDigit(fm.c_t_amt[2].value))   * 100,  1  );	
			} else if ( i  == 9 ||   i  == 10    ) {	
				fm.c1_per[i].value=parseFloatCipher(toInt(parseDigit(fm.c1_cnt[i].value))  /  toInt(parseDigit(fm.c1_t_cnt[3].value))   * 100 ,   1  );			
				fm.c2_per[i].value=parseFloatCipher(toInt(parseDigit(fm.c2_cnt[i].value))  /  toInt(parseDigit(fm.c2_t_cnt[3].value))   * 100 ,   1  );			
				fm.c3_per[i].value=parseFloatCipher(toInt(parseDigit(fm.c3_cnt[i].value))  /  toInt(parseDigit(fm.c3_t_cnt[3].value))   * 100 ,   1  );
				fm.a_per[i].value=parseFloatCipher(toInt(parseDigit(fm.c_amt[i].value))  /  toInt(parseDigit(fm.c_t_amt[3].value))   * 100,  1  );	
			}					
						
		}	
		
	}

//-->
</script>
</body>
</html>

