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
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	if(save_dt.equals(""))	save_dt = sb_db.getMaxSaveDt("stat_bus");
	
	s_yy = AddUtil.replace(s_yy,"-","");
	s_mm = AddUtil.replace(s_mm,"-","");
	
		
	Vector buss = sb_db.getStatBusSearch_20070927(gubun, brch_id, s_yy, s_mm, "all");
	int bus_size = buss.size();
	
	int tot_cnt[] 	= new int[6];
	int c_cnt[] 	= new int[6];
	int cnt10[] 	= new int[6];
	int cnt20[] 	= new int[6];
	int cnt30[] 	= new int[6];
	int cnt01[] 	= new int[6];
	int cnt02[] 	= new int[6];
	int cnt03[] 	= new int[6];
	int cnt04[] 	= new int[6];
	int cnt05[] 	= new int[6];
	int cnt11[] 	= new int[6];
	int cnt12[] 	= new int[6];
	int cnt13[] 	= new int[6];
	int cnt14[] 	= new int[6];
	int cnt15[] 	= new int[6];
	int cnt21[] 	= new int[6];
	int cnt22[] 	= new int[6];
	int cnt23[] 	= new int[6];
	int cnt24[] 	= new int[6];
	int cnt25[] 	= new int[6];
	int cnt31[] 	= new int[6];
	int cnt32[] 	= new int[6];
	int cnt33[] 	= new int[6];
	int cnt34[] 	= new int[6];
	int cnt35[] 	= new int[6];
	
	String b_nm ="";
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
		parent.location.href = "/acar/condition/rent_cond_frame.jsp?dt=3&gubun2=<%if(gubun.equals("6")){%>1<%}else{%>2<%}%>&ref_dt1=<%=s_yy%>&ref_dt2=<%=s_mm%>&gubun3=1&gubun4="+bus_id2;		
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
<input type='hidden' name='bus_id2' value=''>
<input type='hidden' name='mode' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=1492>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class=line id='td_title' style='position:relative;'> 
	        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td class=title width="30%">부서</td>
                    <td class=title width="10%" style='height:51'>연번</td>
                    <td class=title width="20%">성명</td>
                    <td class=title width="40%">입사일자</td>               
                </tr>
            </table>
        </td>
	    <td width='1200' class=line>
	        <table width='1200' border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                     <td class=title rowspan="2" width="60"> 총합계</td>
                    <td class=title colspan="6">합계</td>
                    <td class=title colspan="6">일반식</td>
                    <td class=title colspan="6">기본식</td>
                    <td class=title rowspan="2" width="60">업체수</td>
                </tr>
                <tr align="center"> 
                    <td class=title width="60">홈페이지</td>
                    <td class=title width="60">영업사원</td>
                    <td class=title width="60">기존업체</td>
                    <td class=title width="60">업체소개<br>
                      </td>
                    <td class=title width="60">카탈로그<br>
                    </td>
                    <td class=title width="60">계</td>
                    <td class=title width="60">홈페이지</td>
                    <td class=title width="60">영업사원</td>
                    <td class=title width="60">기존업체</td>
                    <td class=title width="60">업체소개<br>
                      </td>
                    <td class=title width="60">카탈로그<br>
                      </td>
                    <td class=title width="60">계</td>
                    <td class=title width="60">홈페이지</td>
                    <td class=title width="60">영업사원</td>
                    <td class=title width="60">기존업체</td>
                    <td class=title width="60">업체소개<br>
                      </td>
                    <td class=title width="60">카탈로그<br>
                      </td>
                    <td class=title width="60">계</td>
                </tr>
            </table>
	    </td>
    </tr>  			  
    <tr>
	    <td class='line' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
	       
	         <%for (int i = 0 ; i < bus_size ; i++){
    				Hashtable ht = (Hashtable)buss.elementAt(i);
    			
    				if (i == 0) {
    					b_nm = String.valueOf(ht.get("NM"));
    				}
    				    		   		         		
  				if (!b_nm.equals( String.valueOf(ht.get("NM")) )) {
           	%> 			
  				<tr> 
                    <td class=title align="center" colspan="4" height="20"><%=b_nm%>&nbsp;소합계</td>
               
                </tr>
              	<% 
					 b_nm =  String.valueOf(ht.get("NM"));
			 	
		   		}              	
   			%>  
                <tr> 
                    <td align="center" width="30%" height="20"><%= String.valueOf(ht.get("NM"))%></td>
                    <td align="center" width="10%" height="20"><%=i+1%></td>
                    <td align="center" width="20%" height="20"><%= String.valueOf(ht.get("USER_NM"))%></font></a></td>
                    <td align="center" width="40%" height="20"><%=AddUtil.ChangeDate2( String.valueOf(ht.get("ENTER_DT")))%>  </td>
             
                </tr>
         <% } %> 
  	       <tr> 
                    <td class=title align="center" colspan="4" height="20"><%=b_nm%>&nbsp;소합계</td>                 
                </tr>
		    
                <tr> 
                    <td class=title_p align="center" colspan="4" height="20">총합계</td>                
                </tr>
            </table>
        </td>   
	        
	
	    <td class='line' width='1200'>
	        <table border="0" cellspacing="1" cellpadding="0" width='1200'>
	        
	            <%for (int i = 0 ; i < bus_size ; i++){
				Hashtable ht = (Hashtable)buss.elementAt(i);
			
				tot_cnt[1]	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_CNT")));
				c_cnt[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("C_CNT")));
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
											
				if (i == 0) {
    					 b_nm =  String.valueOf(ht.get("NM"));
    				}
    				
    				 if (b_nm.equals( String.valueOf(ht.get("NM")) )) {   				
					tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_CNT")));
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
			
				}
					 				
			        if (!b_nm.equals( String.valueOf(ht.get("NM")) )) {
			       
		%>
	        <tr> 
	            <td class="title" align="center"  width="60"><%=tot_cnt[0]%></td>
	            <td class="title" align="center"  width="60"><%=cnt01[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt02[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt03[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt04[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt05[0]%></td>
                    <td class="title" align="center"  width="60"><%=tot_cnt[0]%></td>		
                    <td class="title" align="center"  width="60"><%=cnt11[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt12[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt13[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt14[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt15[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt10[0]%></td>		
                    <td class="title" align="center"  width="60"><%=cnt21[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt22[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt23[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt24[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt25[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt20[0]%></td>		
                    <td class="title" align="center"  width="60"><%=c_cnt[0]%></td>	
                </tr>

	        
          <%
       				 b_nm =  String.valueOf(ht.get("NM"));
       		 
       			 	tot_cnt[0]	= 0;
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
				cnt13[0] 	= 0;
				cnt14[0] 	= 0;
				cnt15[0] 	= 0;
				cnt21[0] 	= 0;
				cnt22[0] 	= 0;
				cnt23[0] 	= 0;
				cnt24[0] 	= 0;
				cnt25[0] 	= 0;
          
          		
          			tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_CNT")));
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
		}        
		%>  
                <tr> 
                    <td align="center"  width="60"><%=ht.get("TOT_CNT")%></td>
                    <td align="center"  width="60"><%=ht.get("CNT01")%></td>
                    <td align="center"  width="60"><%=ht.get("CNT02")%></td>
                    <td align="center"  width="60"><%=ht.get("CNT03")%></td>
                    <td align="center"  width="60"><%=ht.get("CNT04")%></td>
                    <td align="center"  width="60"><%=ht.get("CNT05")%></td>
                    <td align="center"  width="60"><%=ht.get("TOT_CNT")%></td>		
                    <td align="center"  width="60"><%=ht.get("CNT11")%></td>
                    <td align="center"  width="60"><%=ht.get("CNT12")%></td>
                    <td align="center"  width="60"><%=ht.get("CNT13")%></td>
                    <td align="center"  width="60"><%=ht.get("CNT14")%></td>
                    <td align="center"  width="60"><%=ht.get("CNT15")%></td>
                    <td align="center"  width="60"><%=ht.get("CNT10")%></td>																		
                    <td align="center"  width="60"><%=ht.get("CNT21")%></td>
                    <td align="center"  width="60"><%=ht.get("CNT22")%></td>
                    <td align="center"  width="60"><%=ht.get("CNT23")%></td>
                    <td align="center"  width="60"><%=ht.get("CNT24")%></td>
                    <td align="center"  width="60"><%=ht.get("CNT25")%></td>
                    <td align="center"  width="60"><%=ht.get("CNT20")%></td>
                    <td align="center"  width="60"><%=ht.get("C_CNT")%></td>																																				
                </tr>
          <%}%> 
       
                <tr> 
                    <td class="title" align="center"  width="60"><%=tot_cnt[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt01[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt02[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt03[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt04[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt05[0]%></td>
                    <td class="title" align="center"  width="60"><%=tot_cnt[0]%></td>		
                    <td class="title" align="center"  width="60"><%=cnt11[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt12[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt13[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt14[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt15[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt10[0]%></td>		
                    <td class="title" align="center"  width="60"><%=cnt21[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt22[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt23[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt24[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt25[0]%></td>
                    <td class="title" align="center"  width="60"><%=cnt20[0]%></td>		
                    <td class="title" align="center"  width="60"><%=c_cnt[0]%></td>																																				
                </tr>
       
               <tr> 
                    <td class="title_p" align="center"  width="60"><%=tot_cnt[1]%></td>
                    <td class="title_p" align="center"  width="60"><%=cnt01[1]%></td>
                    <td class="title_p" align="center"  width="60"><%=cnt02[1]%></td>
                    <td class="title_p" align="center"  width="60"><%=cnt03[1]%></td>
                    <td class="title_p" align="center"  width="60"><%=cnt04[1]%></td>
                    <td class="title_p" align="center"  width="60"><%=cnt05[1]%></td>
                    <td class="title_p" align="center"  width="60"><%=tot_cnt[1]%></td>		
                    <td class="title_p" align="center"  width="60"><%=cnt11[1]%></td>
                    <td class="title_p" align="center"  width="60"><%=cnt12[1]%></td>
                    <td class="title_p" align="center"  width="60"><%=cnt13[1]%></td>
                    <td class="title_p" align="center"  width="60"><%=cnt14[1]%></td>
                    <td class="title_p" align="center"  width="60"><%=cnt15[1]%></td>
                    <td class="title_p" align="center"  width="60"><%=cnt10[1]%></td>		
                    <td class="title_p" align="center"  width="60"><%=cnt21[1]%></td>
                    <td class="title_p" align="center"  width="60"><%=cnt22[1]%></td>
                    <td class="title_p" align="center"  width="60"><%=cnt23[1]%></td>
                    <td class="title_p" align="center"  width="60"><%=cnt24[1]%></td>
                    <td class="title_p" align="center"  width="60"><%=cnt25[1]%></td>
                    <td class="title_p" align="center"  width="60"><%=cnt20[1]%></td>		
                    <td class="title_p" align="center"  width="60"><%=c_cnt[1]%></td>																																				
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
