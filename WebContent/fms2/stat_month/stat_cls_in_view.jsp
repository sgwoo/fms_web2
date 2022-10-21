<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.stat_bus.*"%>
<jsp:useBean id="sb_db" scope="page" class="acar.stat_bus.StatBusDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String brch_id = request.getParameter("brch_id")==null?br_id:request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"5":request.getParameter("gubun");
	String s_yy = request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	
	String from_page = "/fms2/stat_month/stat_cls.jsp";
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
		
	if(save_dt.equals(""))	save_dt = sb_db.getMaxSaveDt("stat_bus");
	
	s_yy = AddUtil.replace(s_yy,"-","");
	s_mm = AddUtil.replace(s_mm,"-","");
	
	Vector buss1 = sb_db.getStatClsSearch("5", brch_id, s_yy, s_mm, "0002");
	int bus_size1 = buss1.size();

	int cnt1[] 	= new int[10];
	int cnt2[] 	= new int[10];
	int cnt3[] 	= new int[10];
			
	int t_cnt1[] 	= new int[10];	
	int t_cnt2[] 	= new int[10];	
	int t_cnt3[] 	= new int[10];	
		
	int g_cnt[] 	= new int[10];
				
	int car_type_cnt = 0;
	int car_type_size1 = 0;
	int car_type_size2 = 0;
	int car_type_size3 = 0;

	for(int i = 0 ; i < bus_size1 ; i++){
		Hashtable ht = (Hashtable)buss1.elementAt(i);
		if(String.valueOf(ht.get("CAR_GU")).equals("1")) car_type_size1++;
		if(String.valueOf(ht.get("CAR_GU")).equals("2")) car_type_size2++;
		if(String.valueOf(ht.get("CAR_GU")).equals("9")) car_type_size3++;
	}
	
	String gubun4 = "";
	String gubun5 = "";
	
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
<form action="stat_bus_sc_null.jsp" name="form1" method="POST">
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
<input type='hidden' name='bm' 	value=''>
  
  <table border="0" cellspacing="0" cellpadding="0" width=1050>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	  <td  class=line width='150' id='td_title' style='position:relative;'>
	   <table width="150" border="0" cellspacing="1" cellpadding="1" height="61">
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
	  <td class='line' width='150' id='td_con' style='position:relative;'>
	   <table border="0" cellspacing="1" cellpadding="0" width='150'>
          <%	car_type_cnt = 0;
          		for (int i = 0 ; i < bus_size1 ; i++){
					Hashtable ht = (Hashtable)buss1.elementAt(i);
					if(String.valueOf(ht.get("CAR_GU")).equals("1")){
										
						String d_nm1 = "";
						
						if(String.valueOf(ht.get("GUBUN")).equals("11")){			d_nm1 = "렌트 일반식";	gubun4 = "1";	gubun5 = "1";
						}else if(String.valueOf(ht.get("GUBUN")).equals("13")){		d_nm1 = "렌트 기본식";	gubun4 = "1";	gubun5 = "3";
						}else if(String.valueOf(ht.get("GUBUN")).equals("31")){		d_nm1 = "리스 일반식";	gubun4 = "3";	gubun5 = "1";
						}else if(String.valueOf(ht.get("GUBUN")).equals("33")){		d_nm1 = "리스 기본식";	gubun4 = "3";	gubun5 = "3";
						}
			%>	
				
          <tr>
            <%if(car_type_cnt==0){%>
             <td align="center" width='60' rowspan='<%=car_type_size1%>'><a href="javascript:list_move('1','','');">신차</a></td>
		    <%}%>
            <td align="center" width="100" height="20"><a href="javascript:list_move('1','<%=gubun4%>','<%=gubun5%>');"><%=d_nm1%></a></td>          
          </tr>
           <%						car_type_cnt++;}}%>	
          <tr> 
            <td class="title" align="center" colspan=2  height="20">소합계</td>           
          </tr>
          
          <%	car_type_cnt = 0;
          		for (int i = 0 ; i < bus_size1 ; i++){
					Hashtable ht = (Hashtable)buss1.elementAt(i);
					if(String.valueOf(ht.get("CAR_GU")).equals("2")){
										
						String d_nm1 = "";
						
						if(String.valueOf(ht.get("GUBUN")).equals("11")){			d_nm1 = "렌트 일반식";	gubun4 = "1";	gubun5 = "1";
						}else if(String.valueOf(ht.get("GUBUN")).equals("13")){		d_nm1 = "렌트 기본식";	gubun4 = "1";	gubun5 = "3";
						}else if(String.valueOf(ht.get("GUBUN")).equals("31")){		d_nm1 = "리스 일반식";	gubun4 = "3";	gubun5 = "1";
						}else if(String.valueOf(ht.get("GUBUN")).equals("33")){		d_nm1 = "리스 기본식";	gubun4 = "3";	gubun5 = "3";
						}
		 %>	
				
          <tr>           
            <%if(car_type_cnt==0){%>
             <td align="center" width='60' rowspan='<%=car_type_size2%>'><a href="javascript:list_move('2','','');">재리스</a></td>
		    <%}%>
            <td align="center" width="100" height="20"><a href="javascript:list_move('2','<%=gubun4%>','<%=gubun5%>');"><%=d_nm1%></a></td>          
          </tr>
         <%						car_type_cnt++;}}%>	
          <tr> 
            <td class="title" align="center"  colspan=2  height="20">소합계</td>           
          </tr>
          
          <%	car_type_cnt = 0;
          		for (int i = 0 ; i < bus_size1 ; i++){
					Hashtable ht = (Hashtable)buss1.elementAt(i);
					if(String.valueOf(ht.get("CAR_GU")).equals("9")){
										
						String d_nm1 = "";
						
						if(String.valueOf(ht.get("GUBUN")).equals("11")){			d_nm1 = "렌트 일반식";	gubun4 = "1";	gubun5 = "1";
						}else if(String.valueOf(ht.get("GUBUN")).equals("13")){		d_nm1 = "렌트 기본식";	gubun4 = "1";	gubun5 = "3";
						}else if(String.valueOf(ht.get("GUBUN")).equals("31")){		d_nm1 = "리스 일반식";	gubun4 = "3";	gubun5 = "1";
						}else if(String.valueOf(ht.get("GUBUN")).equals("33")){		d_nm1 = "리스 기본식";	gubun4 = "3";	gubun5 = "3";
						}
			%>	
				
          <tr> 
             <%if(car_type_cnt==0){%>
             <td align="center" width='60' rowspan='<%=car_type_size3%>'><a href="javascript:list_move('9','','');">연장</a></td>
		    <%}%>
            <td align="center" width="100" height="20"><a href="javascript:list_move('9','<%=gubun4%>','<%=gubun5%>');"><%=d_nm1%></a></td>          
          </tr>
           <%						car_type_cnt++;}}%>	
          <tr> 
            <td class="title" align="center"  colspan=2  height="20">소합계</td>            
          </tr>
                 
          <tr> 
            <td class="title_p" align="center"  colspan=2  height="20">총합계</td>
          
          </tr>
        </table></td>
	<td class='line' width='900'>
	    <table border="0" cellspacing="1" cellpadding="0" width='900'>
          <%for (int i = 0 ; i < bus_size1 ; i++){
				Hashtable ht = (Hashtable)buss1.elementAt(i);
				
					if(String.valueOf(ht.get("CAR_GU")).equals("1")){
					
					for (int j = 0 ; j < 8 ; j++){	
						cnt1[j] = AddUtil.parseInt((String)ht.get("CNT"+(j))); 		
					}
											 
					cnt1[8] = cnt1[0]+ cnt1[2]+ cnt1[4]+ cnt1[6]; 	
					cnt1[9] = cnt1[1]+ cnt1[3]+ cnt1[5]+ cnt1[7];		
		  %>	
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
						t_cnt1[j] = t_cnt1[j] + cnt1[j];
						g_cnt[j] = g_cnt[j] + cnt1[j];																
					}
			
					t_cnt1[8] = t_cnt1[8]+ cnt1[8]; 	
					t_cnt1[9] = t_cnt1[9]+ cnt1[9];	
					
					g_cnt[8] = g_cnt[8]+ cnt1[8]; 	
					g_cnt[9] = g_cnt[9]+ cnt1[9];	
									
			} } %>
		
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
    
          <%for (int i = 0 ; i < bus_size1 ; i++){
					Hashtable ht = (Hashtable)buss1.elementAt(i);
				
					if(String.valueOf(ht.get("CAR_GU")).equals("2")){ 
					
					for (int j = 0 ; j < 8 ; j++){	
						cnt2[j] = AddUtil.parseInt((String)ht.get("CNT"+(j))); 		
					}
											 
					cnt2[8] = cnt2[0]+ cnt2[2]+ cnt2[4]+ cnt2[6]; 	
					cnt2[9] = cnt2[1]+ cnt2[3]+ cnt2[5]+ cnt2[7];	
							
		  %>
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
						t_cnt2[j] = t_cnt2[j] + cnt2[j];
						g_cnt[j] = g_cnt[j] + cnt2[j];																
					}
			
					t_cnt2[8] = t_cnt2[8]+ cnt2[8]; 	
					t_cnt2[9] = t_cnt2[9]+ cnt2[9];	
					
					g_cnt[8] = g_cnt[8]+ cnt2[8]; 	
					g_cnt[9] = g_cnt[9]+ cnt2[9];	
					
			} } %>
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
                    
           <%for (int i = 0 ; i < bus_size1 ; i++){
					Hashtable ht = (Hashtable)buss1.elementAt(i);
				
					if(String.valueOf(ht.get("CAR_GU")).equals("9")){ 
		
					for (int j = 0 ; j < 8 ; j++){	
						cnt3[j] = AddUtil.parseInt((String)ht.get("CNT"+(j))); 		
					}
											 
					cnt3[8] = cnt3[0]+ cnt3[2]+ cnt3[4]+ cnt3[6]; 	
					cnt3[9] = cnt3[1]+ cnt3[3]+ cnt3[5]+ cnt3[7];	
											
		  %>  				
            	
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
						t_cnt3[j] = t_cnt3[j] + cnt3[j];
						g_cnt[j] = g_cnt[j] + cnt3[j];																
					}
			
					t_cnt3[8] = t_cnt3[8]+ cnt3[8]; 	
					t_cnt3[9] = t_cnt3[9]+ cnt3[9];	
					
					g_cnt[8] = g_cnt[8]+ cnt3[8]; 	
					g_cnt[9] = g_cnt[9]+ cnt3[9];	
					
			} } %>
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
