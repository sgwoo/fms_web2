<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.stat_bus.*"%>
<jsp:useBean id="sb_db" scope="page" class="acar.stat_bus.StatBusDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String brch_id = request.getParameter("brch_id")==null?br_id:request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String s_yy = request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	if(save_dt.equals(""))	save_dt = sb_db.getMaxSaveDt("stat_bus");
	
	s_yy = AddUtil.replace(s_yy,"-","");
	s_mm = AddUtil.replace(s_mm,"-","");

	Vector buss = sb_db.getStatBusSearch_20160314(gubun, gubun2, brch_id, s_yy, s_mm, "all");
	int bus_size = buss.size();
	
	int tot_cnt[] 	= new int[7];
	int c_cnt[] 	= new int[7];
	int cnt10[] 	= new int[7];
	int cnt20[] 	= new int[7];
	int cnt30[] 	= new int[7];
	int cnt01[] 	= new int[7];
	int cnt02[] 	= new int[7];
	int cnt03[] 	= new int[7];
	int cnt04[] 	= new int[7];
	int cnt05[] 	= new int[7];
	int cnt11[] 	= new int[7];
	int cnt12[] 	= new int[7];
	int cnt13[] 	= new int[7];
	int cnt14[] 	= new int[7];
	int cnt15[] 	= new int[7];
	int cnt21[] 	= new int[7];
	int cnt22[] 	= new int[7];
	int cnt23[] 	= new int[7];
	int cnt24[] 	= new int[7];
	int cnt25[] 	= new int[7];
	int cnt31[] 	= new int[7];
	int cnt32[] 	= new int[7];
	int cnt33[] 	= new int[7];
	int cnt34[] 	= new int[7];
	int cnt35[] 	= new int[7];
	
	int e_tot_cnt[] = new int[7];
	int e_cnt01[] 	= new int[7];
	int e_cnt02[] 	= new int[7];
	int e_cnt03[] 	= new int[7];
	int e_cnt04[] 	= new int[7];
	int e_cnt05[] 	= new int[7];
	
	String b_nm ="";
	String b_nm2 ="";
	
	float b_cnt =0;
	float b_cnt2 =0;	
	float b_cnt3 =0;	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
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
		parent.location.href = "/acar/condition/rent_cond_frame.jsp?dt=3&gubun2=<%if(gubun.equals("6")){%>1<%}else{%>2<%}%>&ref_dt1=<%=s_yy%>&ref_dt2=<%=s_mm%>&gubun3=2&gubun4="+bus_id2;		
	}		
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<form action="stat_bus_sc_null.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>

<input type='hidden' name='s_user' value=''>
<input type='hidden' name='s_dept' value=''>
<input type='hidden' name='s_mng_way' value=''>
<input type='hidden' name='s_mng_st' value=''>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_yy' value='<%=s_yy%>'>
<input type='hidden' name='s_mm' value='<%=s_mm%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='bus_id2' value=''>
<input type='hidden' name='mode' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=1076>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class=line width='326' id='td_title' style='position:relative;'> 
	        <table width='326' border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width="100" class=title>부서</td>
                    <td width="32" class=title style='height:51'>연번</td>
                    <td width="67" class=title>성명</td>
                    <td width="77" class=title>입사일자</td>
                    <td width="50" class=title>총합계</td>
                </tr>
            </table>
        </td>
	    <td class=line>
	        <table width='800' border="0" cellspacing="1" cellpadding="0" style="height: 50px;">
                <tr> 
                    <td colspan="4" class=title>합계</td>			
                    <td colspan="4" class=title>일반식</td>
                    <!-- <td colspan="6" class=title>맞춤식</td> -->
                    <td colspan="4" class=title>기본식</td>
                    <td rowspan="2" width="50" class=title>업체수</td>
                </tr>
                <tr> 
                    <td width="50" class=title>신차</td>
                    <td width="50" class=title>재리스</td>
                    <td width="50" class=title>연장</td>
                    <td width="50" class=title>계</td>
                    <td width="50" class=title>신차</td>
                    <td width="50" class=title>재리스</td>
                    <td width="50" class=title>연장</td>
                    <td width="50" class=title>계</td>
                    <td width="50" class=title>신차</td>
                    <td width="50" class=title>재리스</td>
                    <td width="50" class=title>연장</td>
                    <td width="50" class=title>계</td>
                </tr>
            </table>
	    </td>
    </tr>  			  
    <tr>
	    <td class='line' width='326' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='326'>
              <%for (int i = 0 ; i < bus_size ; i++){
    				Hashtable ht = (Hashtable)buss.elementAt(i);  
    				
    				tot_cnt[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_CNT")));  //grand_total
    				
    				if (i == 0) {
    					b_nm = String.valueOf(ht.get("NM"));
    					b_nm2 = String.valueOf(ht.get("NM1"));    					    					
    				}
    				
    				if ( b_nm.equals( ht.get("NM") )) {				
    					tot_cnt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_CNT"))); //sub_total
    					b_cnt++;
    				}	
    				if ( b_nm2.equals( ht.get("NM1") )) {				
    					tot_cnt[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_CNT"))); //sub_total2
    					b_cnt2++;
    				}	
    				    				
    		%>         	
    		
  		<%		    if (!b_nm2.equals( ht.get("NM1"))) {           	%> 			
  				<tr> 
  		    <td class=is align="center" width="100" height="20" rowspan='2'><%=b_nm2%></td>		
                    <td class=is align="center" colspan="3" height="20">합계</td>
                    <td class=is align="center" height="20" width="50"><%=tot_cnt[6]%></td>
                </tr>
  				<tr> 
                    
                    <td class=is align="center" colspan="3" height="20">평균</td>
                    <td class=is align="center" height="20" width="50"><%if(tot_cnt[6]>0 && b_cnt2>0){%><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(tot_cnt[6]))/b_cnt2,1)%><%}else{%><%=tot_cnt[6]%><%}%></td>
                </tr>                
			<% 
						 b_nm2 = String.valueOf(ht.get("NM1"));
			 			 tot_cnt[6] = 0;   
			 			 b_cnt2 = 0;
			 			 tot_cnt[6] += AddUtil.parseInt(String.valueOf(ht.get("TOT_CNT"))); //sub_total2
			 			 b_cnt2++;
		   			}              	
   			%>  
   			    			
  		<%		    if (!b_nm.equals( ht.get("NM"))) {           	%> 			
  				<tr> 
                    <td class=title align="center" colspan="4" height="20"><%=b_nm%>&nbsp;소합계</td>
                    <td class=title align="center" height="20" width="50"><%=tot_cnt[0]%></td>
                </tr>
                <!--
  				<tr> 
                    <td class=title align="center" colspan="4" height="20"><%=b_nm%>&nbsp;평균</td>
                    <td class=title align="center" height="20" width="50"><%if(tot_cnt[0]>0 && b_cnt>0){%><%=tot_cnt[0]/b_cnt%><%}else{%><%=tot_cnt[0]%><%}%></td>
                </tr>
                -->
			<% 
						 b_nm = String.valueOf(ht.get("NM"));
			 			 tot_cnt[0] = 0;  
			 			 b_cnt = 0; 
			 			 tot_cnt[0] += AddUtil.parseInt(String.valueOf(ht.get("TOT_CNT"))); //sub_total2
			 			 b_cnt++;
			 			 
			 			 b_cnt3 = b_cnt3+b_cnt;
		   			}              	
   			%>  
   			

   			   			
                <tr> 
                    <td align="center" width="100" height="20"><%=ht.get("NM1")%></td>
                    <td align="center" width="32" height="20"><%=i+1%></td>
                    <td align="center" width="67" height="20"><a href="javascript:stat_search('d','<%=ht.get("BUS_ID2")%>');" onMouseOver="window.status=''; return true"><font color="#0000FF"><%=ht.get("USER_NM")%></font></a></td>
                    <td align="center" width="77" height="20"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%> </td>
                    <td align="center" width="50" height="20"><%=ht.get("TOT_CNT")%></td>
                </tr>
         <% } %> 
  				<tr> 
                    <td class=title align="center" colspan="4" height="20"><%=b_nm%>&nbsp;소합계</td>
                    <td class=title align="center" height="20" width="50"><%=tot_cnt[0]%></td>
                </tr>
		    
                <tr> 
                    <td class=title_p align="center" colspan="4" height="20">총합계</td>
                    <td class=title_p align="center" height="20" width="50"><%=tot_cnt[1]%></td>
                </tr>
            </table>
        </td>
	    <td class='line' width='800'>
	        <table border="0" cellspacing="1" cellpadding="0" width='800'>
          <%		tot_cnt[0] = 0;
          		tot_cnt[1] = 0;
          		tot_cnt[6] = 0;
          		b_cnt = 0; 
          		b_cnt2 = 0; 
          		
          		for (int i = 0 ; i < bus_size ; i++){
				Hashtable ht = (Hashtable)buss.elementAt(i);
				
					c_cnt[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("C_CNT"))); //grand_total
					cnt10[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT10")));
					cnt20[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT20")));
					cnt30[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT30")));
					cnt01[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT01")));
					cnt02[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT02")));
					cnt03[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT03")));
					cnt04[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT04")));
					cnt05[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT05")));
					cnt11[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT11")));
					cnt12[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT12")));
					cnt13[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT13")));
					cnt14[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT14")));
					cnt15[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT15")));
					cnt21[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT21")));
					cnt22[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT22")));
					cnt23[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT23")));
					cnt24[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT24")));
					cnt25[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT25")));
					cnt31[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT31")));
					cnt32[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT32")));
					cnt33[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT33")));
					cnt34[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT34")));
					cnt35[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT35")));
					tot_cnt[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_CNT")));  //grand_total
					e_cnt01[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT01")));
					e_cnt02[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT02")));
					e_cnt03[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT03")));
					e_cnt04[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT04")));
					e_cnt05[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT05")));
					e_tot_cnt[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_TOT_CNT")));
					
    				
    				if (i == 0) {
    					b_nm = String.valueOf(ht.get("NM"));
    				}
    				
    				if (i == 0) {
    					b_nm2 = String.valueOf(ht.get("NM1"));
    				}
    				
    				if ( b_nm.equals( ht.get("NM") )) {	
    				                b_cnt++;
    						c_cnt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("C_CNT")));
						cnt10[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT10")));
						cnt20[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT20")));
						cnt30[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT30")));
						cnt01[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT01")));
						cnt02[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT02")));
						cnt03[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT03")));
						cnt04[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT04")));
						cnt05[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT05")));
						cnt11[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT11")));
						cnt12[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT12")));
						cnt13[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT13")));
						cnt14[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT14")));
						cnt15[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT15")));
						cnt21[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT21")));
						cnt22[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT22")));
						cnt23[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT23")));
						cnt24[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT24")));
						cnt25[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT25")));
						cnt31[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT31")));
						cnt32[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT32")));
						cnt33[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT33")));
						cnt34[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT34")));
						cnt35[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT35")));
						tot_cnt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_CNT")));  //grand_total
						
						e_cnt01[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT01")));
						e_cnt02[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT02")));
						e_cnt03[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT03")));
						e_cnt04[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT04")));
						e_cnt05[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT05")));
						e_tot_cnt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_TOT_CNT")));
						
    				}	
    				
    				if ( b_nm2.equals( ht.get("NM1") )) {				
    				                b_cnt2++;
    						c_cnt[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("C_CNT")));
						cnt10[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT10")));
						cnt20[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT20")));
						cnt30[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT30")));
						cnt01[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT01")));
						cnt02[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT02")));
						cnt03[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT03")));
						cnt04[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT04")));
						cnt05[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT05")));
						cnt11[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT11")));
						cnt12[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT12")));
						cnt13[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT13")));
						cnt14[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT14")));
						cnt15[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT15")));
						cnt21[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT21")));
						cnt22[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT22")));
						cnt23[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT23")));
						cnt24[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT24")));
						cnt25[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT25")));
						cnt31[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT31")));
						cnt32[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT32")));
						cnt33[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT33")));
						cnt34[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT34")));
						cnt35[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT35")));
						tot_cnt[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_CNT")));  //grand_total
						
						e_cnt01[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT01")));
						e_cnt02[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT02")));
						e_cnt03[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT03")));
						e_cnt04[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT04")));
						e_cnt05[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT05")));
						e_tot_cnt[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_TOT_CNT")));
						
    				}	    				
    		         %>		
  			<%	    if (!b_nm2.equals( ht.get("NM1"))) {
  		       	%> 
           		   <tr> 
                    <td class=is align="center" height="20" width="30"><%=cnt01[6]%></td>
                    <td class=is align="center" height="20" width="30"><%=cnt02[6]%></td>
                    <td class=is align="center" height="20" width="30"><%=cnt03[6]%></td>
                    <td class=is align="center" height="20" width="30"><%=tot_cnt[6]%></td>
                    <td class=is align="center" height="20" width="30"><%=cnt11[6]%></td>
                    <td class=is align="center" height="20" width="30"><%=cnt12[6]%></td>		
                    <td class=is align="center" height="20" width="30"><%=cnt13[6]%></td>
                    <td class=is align="center" height="20" width="30"><%=cnt10[6]%></td>
                    <td class=is align="center" height="20" width="30"><%=cnt31[6]%></td>
                    <td class=is align="center" height="20" width="30"><%=cnt32[6]%></td>
                    <td class=is align="center" height="20" width="30"><%=cnt33[6]%></td>
                    <td class=is align="center" height="20" width="30"><%=cnt30[6]%></td>		
                    <td class=is align="center" height="20" width="30"><%=c_cnt[6]%></td>
                   																								
                </tr>                
  		       	
           		   <tr> 
                    <td class=is align="center" height="20" width="50"><%if(cnt01[6]>0 && b_cnt2>0){%><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt01[6]))/b_cnt2,1)%><%}else{%><%=cnt01[6]%><%}%></td>
                    <td class=is align="center" height="20" width="50"><%if(cnt02[6]>0 && b_cnt2>0){%><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt02[6]))/b_cnt2,1)%><%}else{%><%=cnt02[6]%><%}%></td>
                    <td class=is align="center" height="20" width="50"><%if(cnt03[6]>0 && b_cnt2>0){%><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt03[6]))/b_cnt2,1)%><%}else{%><%=cnt03[6]%><%}%></td>
                    <td class=is align="center" height="20" width="50"><%if(tot_cnt[6]>0 && b_cnt2>0){%><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(tot_cnt[6]))/b_cnt2,1)%><%}else{%><%=tot_cnt[6]%><%}%></td>
                    <td class=is align="center" height="20" width="50"><%if(cnt11[6]>0 && b_cnt2>0){%><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt11[6]))/b_cnt2,1)%><%}else{%><%=cnt11[6]%><%}%></td>
                    <td class=is align="center" height="20" width="50"><%if(cnt12[6]>0 && b_cnt2>0){%><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt12[6]))/b_cnt2,1)%><%}else{%><%=cnt12[6]%><%}%></td>		
                    <td class=is align="center" height="20" width="50"><%if(cnt13[6]>0 && b_cnt2>0){%><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt13[6]))/b_cnt2,1)%><%}else{%><%=cnt13[6]%><%}%></td>
                    <td class=is align="center" height="20" width="50"><%if(cnt10[6]>0 && b_cnt2>0){%><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt10[6]))/b_cnt2,1)%><%}else{%><%=cnt10[6]%><%}%></td>
                    <td class=is align="center" height="20" width="50"><%if(cnt31[6]>0 && b_cnt2>0){%><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt31[6]))/b_cnt2,1)%><%}else{%><%=cnt31[6]%><%}%></td>
                    <td class=is align="center" height="20" width="50"><%if(cnt32[6]>0 && b_cnt2>0){%><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt32[6]))/b_cnt2,1)%><%}else{%><%=cnt32[6]%><%}%></td>
                    <td class=is align="center" height="20" width="50"><%if(cnt33[6]>0 && b_cnt2>0){%><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt33[6]))/b_cnt2,1)%><%}else{%><%=cnt33[6]%><%}%></td>
                    <td class=is align="center" height="20" width="50"><%if(cnt30[6]>0 && b_cnt2>0){%><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt30[6]))/b_cnt2,1)%><%}else{%><%=cnt30[6]%><%}%></td>		
                    <td class=is align="center" height="20" width="50"><%if(c_cnt[6]>0 && b_cnt2>0){%><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(c_cnt[6]))/b_cnt2,1)%><%}else{%><%=c_cnt[6]%><%}%></td>	
                   
                </tr>
			<% 
						 b_nm2 = String.valueOf(ht.get("NM1"));
						 b_cnt2 = 0;
			 			    c_cnt[6] 	= 0;
							cnt10[6] 	= 0;
							cnt20[6] 	= 0;
							cnt30[6] 	= 0;
							cnt01[6] 	= 0;
							cnt02[6] 	= 0;
							cnt03[6] 	= 0;
							cnt04[6] 	= 0;
							cnt05[6] 	= 0;
							cnt11[6] 	= 0;
							cnt12[6] 	= 0;
							cnt13[6]	= 0;
							cnt14[6] 	= 0;
							cnt15[6] 	= 0;
							cnt21[6] 	= 0;
							cnt22[6] 	= 0;
							cnt23[6] 	= 0;
							cnt24[6] 	= 0;
							cnt25[6] 	= 0;
							cnt31[6] 	= 0;
							cnt32[6] 	= 0;
							cnt33[6] 	= 0;
							cnt34[6] 	= 0;
							cnt35[6] 	= 0;
							tot_cnt[6]  = 0;
							e_cnt01[6] 	= 0;
							e_cnt02[6] 	= 0;
							e_cnt03[6] 	= 0;
							e_cnt04[6] 	= 0;
							e_cnt05[6] 	= 0;
							e_tot_cnt[6] = 0;
							
							b_cnt2++;
				 			c_cnt[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("C_CNT")));
							cnt10[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT10")));
							cnt20[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT20")));
							cnt30[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT30")));
							cnt01[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT01")));
							cnt02[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT02")));
							cnt03[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT03")));
							cnt04[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT04")));
							cnt05[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT05")));
							cnt11[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT11")));
							cnt12[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT12")));
							cnt13[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT13")));
							cnt14[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT14")));
							cnt15[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT15")));
							cnt21[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT21")));
							cnt22[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT22")));
							cnt23[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT23")));
							cnt24[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT24")));
							cnt25[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT25")));
							cnt31[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT31")));
							cnt32[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT32")));
							cnt33[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT33")));
							cnt34[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT34")));
							cnt35[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT35")));
							tot_cnt[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_CNT")));  //grand_total
							e_cnt01[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT01")));
							e_cnt02[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT02")));
							e_cnt03[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT03")));
							e_cnt04[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT04")));
							e_cnt05[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT05")));
							e_tot_cnt[6] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_TOT_CNT")));
							
		   			}              	
   			%>  
  			<%	    if (!b_nm.equals( ht.get("NM"))) {
  		       	%> 
           		   <tr> 
                    <td class=title align="center" height="20" width="50"><%=cnt01[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=cnt02[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=cnt03[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=tot_cnt[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=cnt11[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=cnt12[0]%></td>		
                    <td class=title align="center" height="20" width="50"><%=cnt13[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=cnt10[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=cnt31[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=cnt32[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=cnt33[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=cnt30[0]%></td>		
                    <td class=title align="center" height="20" width="50"><%=c_cnt[0]%></td>
                  
                <!--
           		   <tr> 
                    <td class=title align="center" height="20" width="50"><%if(cnt01[0]>0 && b_cnt>0){%><%=cnt01[0]/b_cnt%><%}else{%><%=cnt01[0]%><%}%></td>
                    <td class=title align="center" height="20" width="50"><%if(cnt02[0]>0 && b_cnt>0){%><%=cnt02[0]/b_cnt%><%}else{%><%=cnt02[0]%><%}%></td>
                    <td class=title align="center" height="20" width="50"><%if(cnt03[0]>0 && b_cnt>0){%><%=cnt03[0]/b_cnt%><%}else{%><%=cnt03[0]%><%}%></td>
                    <td class=title align="center" height="20" width="50"><%if(cnt04[0]>0 && b_cnt>0){%><%=cnt04[0]/b_cnt%><%}else{%><%=cnt04[0]%><%}%></td>
                    <td class=title align="center" height="20" width="50"><%if(cnt05[0]>0 && b_cnt>0){%><%=cnt05[0]/b_cnt%><%}else{%><%=cnt05[0]%><%}%></td>
                    <td class=title align="center" height="20" width="50"><%if(tot_cnt[0]>0 && b_cnt>0){%><%=tot_cnt[0]/b_cnt%><%}else{%><%=tot_cnt[0]%><%}%></td>		
                    <td class=title align="center" height="20" width="50"><%if(e_cnt01[0]>0 && b_cnt>0){%><%=e_cnt01[0]/b_cnt%><%}else{%><%=e_cnt01[0]%><%}%></td>
                    <td class=title align="center" height="20" width="50"><%if(e_cnt02[0]>0 && b_cnt>0){%><%=e_cnt02[0]/b_cnt%><%}else{%><%=e_cnt02[0]%><%}%></td>
                    <td class=title align="center" height="20" width="50"><%if(e_cnt03[0]>0 && b_cnt>0){%><%=e_cnt03[0]/b_cnt%><%}else{%><%=e_cnt03[0]%><%}%></td>
                    <td class=title align="center" height="20" width="50"><%if(e_cnt04[0]>0 && b_cnt>0){%><%=e_cnt04[0]/b_cnt%><%}else{%><%=e_cnt04[0]%><%}%></td>
                    <td class=title align="center" height="20" width="50"><%if(e_cnt05[0]>0 && b_cnt>0){%><%=e_cnt05[0]/b_cnt%><%}else{%><%=e_cnt05[0]%><%}%></td>
                    <td class=title align="center" height="20" width="50"><%if(e_tot_cnt[0]>0 && b_cnt>0){%><%=e_tot_cnt[0]/b_cnt%><%}else{%><%=e_tot_cnt[0]%><%}%></td>		
                    <td class=title align="center" height="20" width="50"><%if(cnt11[0]>0 && b_cnt>0){%><%=cnt11[0]/b_cnt%><%}else{%><%=cnt11[0]%><%}%></td>
                    <td class=title align="center" height="20" width="50"><%if(cnt12[0]>0 && b_cnt>0){%><%=cnt12[0]/b_cnt%><%}else{%><%=cnt12[0]%><%}%></td>
                    <td class=title align="center" height="20" width="50"><%if(cnt13[0]>0 && b_cnt>0){%><%=cnt13[0]/b_cnt%><%}else{%><%=cnt13[0]%><%}%></td>
                    <td class=title align="center" height="20" width="50"><%if(cnt14[0]>0 && b_cnt>0){%><%=cnt14[0]/b_cnt%><%}else{%><%=cnt14[0]%><%}%></td>
                    <td class=title align="center" height="20" width="50"><%if(cnt15[0]>0 && b_cnt>0){%><%=cnt15[0]/b_cnt%><%}else{%><%=cnt15[0]%><%}%></td>
                    <td class=title align="center" height="20" width="50"><%if(cnt10[0]>0 && b_cnt>0){%><%=cnt10[0]/b_cnt%><%}else{%><%=cnt10[0]%><%}%></td>		
                    <td class=title align="center" height="20" width="50"><%if(cnt31[0]>0 && b_cnt>0){%><%=cnt31[0]/b_cnt%><%}else{%><%=cnt31[0]%><%}%></td>
                    <td class=title align="center" height="20" width="50"><%if(cnt32[0]>0 && b_cnt>0){%><%=cnt32[0]/b_cnt%><%}else{%><%=cnt32[0]%><%}%></td>
                    <td class=title align="center" height="20" width="50"><%if(cnt33[0]>0 && b_cnt>0){%><%=cnt33[0]/b_cnt%><%}else{%><%=cnt33[0]%><%}%></td>
                    <td class=title align="center" height="20" width="50"><%if(cnt34[0]>0 && b_cnt>0){%><%=cnt34[0]/b_cnt%><%}else{%><%=cnt34[0]%><%}%></td>
                    <td class=title align="center" height="20" width="50"><%if(cnt35[0]>0 && b_cnt>0){%><%=cnt35[0]/b_cnt%><%}else{%><%=cnt35[0]%><%}%></td>
                    <td class=title align="center" height="20" width="50"><%if(cnt30[0]>0 && b_cnt>0){%><%=cnt30[0]/b_cnt%><%}else{%><%=cnt30[0]%><%}%></td>		
                    <td class=title align="center" height="20" width="50"><%if(c_cnt[0]>0 && b_cnt>0){%><%=c_cnt[0]/b_cnt%><%}else{%><%=c_cnt[0]%><%}%></td>																																				
                </tr>    
                -->            
			<% 
						 b_nm = String.valueOf(ht.get("NM"));
			 			    c_cnt[0] 	= 0;
							cnt10[0] 	= 0;
							cnt20[0] 	= 0;
							cnt30[0] 	= 0;
							cnt01[0] 	= 0;
							cnt02[0] 	= 0;
							cnt03[0] 	= 0;
							cnt04[0] 	= 0;
							cnt05[0] 	= 0;
							cnt11[0] 	= 0;
							cnt12[0] 	= 0;
							cnt13[0]	= 0;
							cnt14[0] 	= 0;
							cnt15[0] 	= 0;
							cnt21[0] 	= 0;
							cnt22[0] 	= 0;
							cnt23[0] 	= 0;
							cnt24[0] 	= 0;
							cnt25[0] 	= 0;
							cnt31[0] 	= 0;
							cnt32[0] 	= 0;
							cnt33[0] 	= 0;
							cnt34[0] 	= 0;
							cnt35[0] 	= 0;
							tot_cnt[0]  = 0;
							e_cnt01[0] 	= 0;
							e_cnt02[0] 	= 0;
							e_cnt03[0] 	= 0;
							e_cnt04[0] 	= 0;
							e_cnt05[0] 	= 0;
							e_tot_cnt[0] = 0;
							
							
				 			c_cnt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("C_CNT")));
							cnt10[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT10")));
							cnt20[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT20")));
							cnt30[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT30")));
							cnt01[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT01")));
							cnt02[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT02")));
							cnt03[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT03")));
							cnt04[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT04")));
							cnt05[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT05")));
							cnt11[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT11")));
							cnt12[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT12")));
							cnt13[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT13")));
							cnt14[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT14")));
							cnt15[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT15")));
							cnt21[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT21")));
							cnt22[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT22")));
							cnt23[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT23")));
							cnt24[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT24")));
							cnt25[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT25")));
							cnt31[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT31")));
							cnt32[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT32")));
							cnt33[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT33")));
							cnt34[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT34")));
							cnt35[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT35")));
							tot_cnt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_CNT")));  //grand_total
							e_cnt01[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT01")));
							e_cnt02[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT02")));
							e_cnt03[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT03")));
							e_cnt04[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT04")));
							e_cnt05[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_CNT05")));
							e_tot_cnt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("E_TOT_CNT")));
							
		   			}              	
   			%>     			
   			   						
                <tr> 
                    <td  align="center" height="20" width="50"><%=ht.get("CNT01")%></td>
                    <td  align="center" height="20" width="50"><%=ht.get("CNT02")%></td>
                    <td  align="center" height="20" width="50"><%=ht.get("CNT03")%></td>
                    <td  align="center" height="20" width="50"><%=ht.get("TOT_CNT")%></td>
                    <td  align="center" height="20" width="50"><%=ht.get("CNT11")%></td>
                    <td  align="center" height="20" width="50"><%=ht.get("CNT12")%></td>		
                    <td  align="center" height="20" width="50"><%=ht.get("CNT13")%></td>
                    <td  align="center" height="20" width="50"><%=ht.get("CNT10")%></td>
                    
                    <td  align="center" height="20" width="50"><%=ht.get("CNT31")%></td>
                    <td  align="center" height="20" width="50"><%=ht.get("CNT32")%></td>
                    <td  align="center" height="20" width="50"><%=ht.get("CNT33")%></td>
                    <td  align="center" height="20" width="50"><%=ht.get("CNT30")%></td>		
                    
                    <td  align="center" height="20" width="50"><%=ht.get("C_CNT")%></td>																										
                </tr>
        <% } %> 
                <tr> 
                    <td class=title align="center" height="20" width="50"><%=cnt01[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=cnt02[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=cnt03[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=tot_cnt[0]%></td>
                    
                    <td class=title align="center" height="20" width="50"><%=cnt11[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=cnt12[0]%></td>		
                    <td class=title align="center" height="20" width="50"><%=cnt13[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=cnt10[0]%></td>
                    
                    <td class=title align="center" height="20" width="50"><%=cnt31[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=cnt32[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=cnt33[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=cnt30[0]%></td>		
                    
                    <td class=title align="center" height="20" width="50"><%=c_cnt[0]%></td>																						
                </tr>
               
                <tr> 
                    <td class=title_p align="center" height="20" width="50"><%=cnt01[1]%></td>
                    <td class=title_p align="center" height="20" width="50"><%=cnt02[1]%></td>
                    <td class=title_p align="center" height="20" width="50"><%=cnt03[1]%></td>
                    <td class=title_p align="center" height="20" width="50"><%=tot_cnt[1]%></td>
                    
                    <td class=title_p align="center" height="20" width="50"><%=cnt11[1]%></td>
                    <td class=title_p align="center" height="20" width="50"><%=cnt12[1]%></td>		
                    <td class=title_p align="center" height="20" width="50"><%=cnt13[1]%></td>
                    <td class=title_p align="center" height="20" width="50"><%=cnt10[1]%></td>
                    
                    <td class=title_p align="center" height="20" width="50"><%=cnt31[1]%></td>
                    <td class=title_p align="center" height="20" width="50"><%=cnt32[1]%></td>
                    <td class=title_p align="center" height="20" width="50"><%=cnt33[1]%></td>
                    <td class=title_p align="center" height="20" width="50"><%=cnt30[1]%></td>		
                    <td class=title_p align="center" height="20" width="50"><%=c_cnt[1]%></td>
                   																												
                </tr>
            </table>
	    </td>
	</tr>
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td colspan=2>
<span class=style1><%if(gubun.equals("5")){%>&nbsp;&nbsp;♣ 대여개시된 계약<br><%}%>
        &nbsp;&nbsp;♣ 약정기간이 6개월 이상인 계약<br>
        &nbsp;&nbsp;♣ 연장계약은 연장계약담당자, 연장계약일, 연장대여개시일</span></td>
    </tr>
</table>		
</form>
<script language='javascript'>
<!--
//-->
</script>

</body>
</html>
