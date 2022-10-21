<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>

<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1"); //년도
	
	Vector vt = ad_db.getStatCmpList(gubun1);
		
	int vt_size =vt.size();
	    
    long s_amt[] = new long[5];   
    long d_amt[] = new long[5];   
    long c_amt[] = new long[5];   
    long e_amt[] = new long[5];   
    long f_amt[] = new long[5];   
    long g_amt[] = new long[5];   
    long p_amt[] = new long[5];  
       
    long w_s_amt[] = new long[5];   
    long w_d_amt[] = new long[5];   
    long w_c_amt[] = new long[5];   
    long w_e_amt[] = new long[5];   
    long w_f_amt[] = new long[5];   
    long w_g_amt[] = new long[5];   
    long w_p_amt[] = new long[5];  
   	       
    String loan_chk = "";   
    int    loan_cnt = 0; 
    int    t_loan_cnt = 0; 
    int w_cnt=0;
    int wy_cnt=0;
    int p_cnt=0;
        
    String dept_nm = "";    
	    
	long s_st_s_amt=0;
	long s_st_d_amt=0;
	long s_st_c_amt=0;
	long s_st_f_amt=0;			
	long s_st_p_amt=0;
	
	long st_s_amt=0;
	long st_d_amt=0;
	long st_c_amt=0;
	long st_f_amt=0;			
	long st_p_amt=0;
	
	long gt_s_amt=0;
	long gt_d_amt=0;
	long gt_c_amt=0;
	long gt_f_amt=0;			
	long gt_p_amt=0;
	
	long ws_st_s_amt=0;
	long ws_st_d_amt=0;
	long ws_st_c_amt=0;			
	long ws_st_f_amt=0;			
	long ws_st_p_amt=0;
	
	long w_gt_s_amt = 0;   
	long w_gt_d_amt = 0;   
	long w_gt_c_amt = 0;   
	long w_gt_e_amt = 0;   
	long w_gt_f_amt = 0;   
	long w_gt_g_amt = 0;   
	long w_gt_p_amt = 0;  
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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

</head>

<body  onLoad="javascript:onprint()" >
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>


<table border="0" cellspacing="0" cellpadding="0"  width='100%'>
       <tr> 
    <td colspan="2" align="left"><font face="굴림" size="2" > 
      <b>&nbsp; * &nbsp <%= gubun1%>년&nbsp;  캠페인지급현황 </b> </font></td>
  </tr> 
  
  
    <tr>		
        <td class=line>	
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                  <tr> 
                   <td rowspan=2 width="4%" class='title' >연번</td>
                    <td rowspan=2 width="12%" class='title' >구분</td>                    
                    <td rowspan=2 width="12%" class='title'>성명</td>
                    <td rowspan=2  width="12%" class='title'>입사일</td>
                     <td colspan=7 class=title width="60%" >합계</td>   
                </tr>
                 <tr>               
                    <td class=title   width='10%'  >영업</td> <!--4분기 --> 
                    <td class=title   width='10%'>채권</td>       
                    <td class=title   width='10%'>1군비용</td>
               <!--   <td class=title   width='10%'>사고비용</td>  -->
                      <td class=title   width='10%'>2군비용</td>
                    <td class=title  width='10%' >제안</td>  
                    <td class=title  width='10%' >계</td> 
                </tr>
            </table>
		</td>
	</tr>
	
 
 <%if(vt_size > 0){%>
    <tr>		
        <td class='line'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
	        	        
        <%	for(int i = 0 ; i < vt_size ; i++){
        
        	   Hashtable ht = (Hashtable)vt.elementAt(i);		
        			
        	   if ( i == 0 ) {
				    loan_chk = String.valueOf(ht.get("LOAN_ST"));
				    p_cnt=0; 
				}
				
					//명칭
				dept_nm = ad_db.getUserDeptNm(String.valueOf(ht.get("USER_ID")));
				
			   if ( !loan_chk.equals(String.valueOf(ht.get("LOAN_ST")))) {       
	%>
	    	  <tr> 
                    <td class=title colspan="4" style='height:34;'>
         <% if ( loan_chk.equals("2")) { %>2군<% } else if ( loan_chk.equals("4")) { %>1군<%} else {%>내근<% } %>&nbsp;소계<br>&nbsp;&nbsp;&nbsp;&nbsp;평균</td>  
                    <td class=title  width='10%' style='text-align:right' ><%=Util.parseDecimal(s_st_s_amt)%><br><%=Util.parseDecimal(s_st_s_amt/loan_cnt)%></td>
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(s_st_d_amt)%><br><%=Util.parseDecimal(s_st_d_amt/loan_cnt)%></td>	
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(s_st_c_amt)%><br><%=Util.parseDecimal(s_st_c_amt/loan_cnt)%></td>
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(s_st_f_amt)%><br><%=Util.parseDecimal(s_st_f_amt/loan_cnt)%></td>
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(s_st_p_amt)%><br><%=Util.parseDecimal(s_st_p_amt/loan_cnt)%></td>
        		    <td class=title  width='10%'style='text-align:right' ><%=Util.parseDecimal(s_st_s_amt+s_st_d_amt+s_st_c_amt+s_st_f_amt +s_st_p_amt)%><br><%=Util.parseDecimal((s_st_s_amt+s_st_d_amt+s_st_c_amt+s_st_f_amt +s_st_p_amt)/loan_cnt)%></td>	      		
        	   </tr>
                
               <tr> 
                    <td class=title colspan="4" style='height:34;'>
            <% if ( loan_chk.equals("2")) { %>2군<% } else if ( loan_chk.equals("4")) { %>1군<%} else {%>내근<% } %>&nbsp;소계(1년미만제외)<br>&nbsp;&nbsp;&nbsp;&nbsp;평균(1년미만제외)</td>   
                     <td class=title  width='10%' style='text-align:right' ><%=Util.parseDecimal(ws_st_s_amt)%><br><%=Util.parseDecimal(ws_st_s_amt/w_cnt)%></td>
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(ws_st_d_amt)%><br><%=Util.parseDecimal(ws_st_d_amt/w_cnt)%></td>	
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(ws_st_c_amt)%><br><%=Util.parseDecimal(ws_st_c_amt/w_cnt)%></td>
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(ws_st_f_amt)%><br><%=Util.parseDecimal(ws_st_f_amt/w_cnt)%></td>
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(ws_st_p_amt)%><br><%=Util.parseDecimal(ws_st_p_amt/w_cnt)%></td>
        		    <td class=title  width='10%'style='text-align:right' ><%=Util.parseDecimal(ws_st_s_amt+ws_st_d_amt+ws_st_c_amt+ws_st_f_amt +ws_st_p_amt)%><br><%=Util.parseDecimal((ws_st_s_amt+ws_st_d_amt+ws_st_c_amt+ws_st_f_amt +ws_st_p_amt)/w_cnt)%></td>	      		
        	    </tr>
 <%		
       		 loan_chk = String.valueOf(ht.get("LOAN_ST"));
       		 
       		  p_cnt=0;
       		  w_cnt = 0;     
       		  loan_cnt = 0;    
       	    	  
	    	  s_st_s_amt = 0;  
    		  s_st_d_amt = 0;  
    		  s_st_c_amt = 0; 
    		  s_st_f_amt = 0;  
    		  s_st_p_amt = 0; 	    
	    	  
	    	  ws_st_s_amt = 0;  
    		  ws_st_d_amt = 0;  
    		  ws_st_c_amt = 0; 
    		  ws_st_f_amt = 0;  
    		  ws_st_p_amt = 0; 
         }

        loan_cnt++;
        t_loan_cnt++;	
        
        //1년미만 
		if  (  AddUtil.parseInt(String.valueOf(ht.get("WY")) ) > 11 ) { 
			  w_cnt++;
			  wy_cnt++;			  
		}    
%>   
      	  
	<%		for (int j = 1 ; j < 5 ; j++){
					  s_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("S"+(j))));  //영업
					  d_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("D"+(j))));  //채권
					  c_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("C"+(j))));	//1군비용		
					  e_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("E"+(j))));
					  f_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("F"+(j))));  //2군비용
					  g_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("G"+(j))));
					  p_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("P"+(j))));  //제안	
												  										 				 
					  st_s_amt = st_s_amt +  (s_amt[j]);  //영업
					  st_d_amt = st_d_amt +  (d_amt[j]);  //채권
					  st_c_amt = st_c_amt +  (c_amt[j] + e_amt[j] + g_amt[j]);  //1군비용
					  st_f_amt = st_f_amt +  (f_amt[j]);  //2군비용
					  st_p_amt = st_p_amt +  (p_amt[j]);  //제안
					  
					  s_st_s_amt = s_st_s_amt +  (s_amt[j]);  //영업  -- sub
					  s_st_d_amt = s_st_d_amt +  (d_amt[j]);  //채권
					  s_st_c_amt = s_st_c_amt +  (c_amt[j] + e_amt[j] + g_amt[j]);  //1군비용
					  s_st_f_amt = s_st_f_amt +  (f_amt[j]);  //2군비용
					  s_st_p_amt = s_st_p_amt +  (p_amt[j]);  //제안
					  
					  gt_s_amt = gt_s_amt +  (s_amt[j]);  //영업  -- tot
					  gt_d_amt = gt_d_amt +  (d_amt[j]);  //채권
					  gt_c_amt = gt_c_amt +  (c_amt[j] + e_amt[j] + g_amt[j]);  //1군비용
					  gt_f_amt = gt_f_amt +  (f_amt[j]);  //2군비용
					  gt_p_amt = gt_p_amt +  (p_amt[j]);  //제안
					
					  //1년미만 
					  if  (  AddUtil.parseInt(String.valueOf(ht.get("WY")) ) > 11 ) { 
							  w_s_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("S"+(j))));  //영업
							  w_d_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("D"+(j))));  //채권
							  w_c_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("C"+(j))));	//1군비용		
							  w_e_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("E"+(j))));
							  w_f_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("F"+(j))));  //2군비용
							  w_g_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("G"+(j))));
							  w_p_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("P"+(j))));  //제안	
							  
							  ws_st_s_amt = ws_st_s_amt +  (w_s_amt[j]);  //영업
							  ws_st_d_amt = ws_st_d_amt +  (w_d_amt[j]);  //채권
							  ws_st_c_amt = ws_st_c_amt +  (w_c_amt[j] + w_e_amt[j] + w_g_amt[j]);  //1군비용
							  ws_st_f_amt = ws_st_f_amt +  (w_f_amt[j]);  //2군비용
							  ws_st_p_amt = ws_st_p_amt +  (w_p_amt[j]);  //제안	 	
							  
							  w_gt_s_amt = w_gt_s_amt +  (w_s_amt[j]);  //영업
							  w_gt_d_amt = w_gt_d_amt +  (w_d_amt[j]);  //채권
							  w_gt_c_amt = w_gt_c_amt +  (w_c_amt[j] + w_e_amt[j] + w_g_amt[j]);  //1군비용
							  w_gt_f_amt = w_gt_f_amt +  (w_f_amt[j]);  //2군비용
							  w_gt_p_amt = w_gt_p_amt +  (w_p_amt[j]);  //제안	 	
					  
					  }
				    
			} 
								
			p_cnt++;			
					
	%>
   			
           <tr> 
           	 <td width='4%' align='center'>&nbsp;<%=p_cnt%></td>	
                    <td width='12%' align='center'>
           <%  if ( ht.get("NM").equals("퇴사자")) { %>
           퇴사자
           <% } else { %>
           <%    if (ht.get("LOAN_ST").equals("2")){ %>
                   <%=dept_nm%>&nbsp;       
          
           <%}else if( ht.get("LOAN_ST").equals("4")){%>
           			<%=dept_nm%>&nbsp;
            
           <%}else if( ht.get("LOAN_ST").equals("5")){%><%=dept_nm%> <%}%>
           <% } %>     
                   </td>
                   <td width='12%' align='center'><%=ht.get("USER_NM")%></td>
                   <td width='12%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%></td>      
       		    <td width='10%' align='right'><%=Util.parseDecimal(st_s_amt)%></td>	
       		    <td align='right' width='10%'><%=Util.parseDecimal(st_d_amt)%></td>
       		    <td align='right' width='10%'><%=Util.parseDecimal(st_c_amt)%></td> 
       		    <td align='right' width='10%'><%=Util.parseDecimal(st_f_amt)%></td>
       		    <td align='right' width='10%'><%=Util.parseDecimal(st_p_amt)%></td>
       		    <td align='right' width='10%'><%=Util.parseDecimal(st_s_amt+st_d_amt+st_c_amt+st_f_amt+st_p_amt)%></td>        		    
               </tr>
 
<%		
	 st_s_amt = 0;  //영업
	 st_d_amt = 0;  //채권
	 st_c_amt = 0;  //1군비용
	 st_f_amt = 0;  //2군비용
	 st_p_amt = 0;  //제안	 
	  
  }  
        
  %>		    

		   <tr> 
                    <td class=title colspan="4" style='height:34;'>
                     <% if ( loan_chk.equals("2")) { %>2군<% } else if ( loan_chk.equals("4")) { %>1군<%} else {%>내근<% } %>&nbsp;소계<br>&nbsp;&nbsp;&nbsp;&nbsp;평균</td>  
                    <td class=title  width='10%' style='text-align:right' ><%=Util.parseDecimal(s_st_s_amt)%><br><%=Util.parseDecimal(s_st_s_amt/loan_cnt)%></td>
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(s_st_d_amt)%><br><%=Util.parseDecimal(s_st_d_amt/loan_cnt)%></td>	
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(s_st_c_amt)%><br><%=Util.parseDecimal(s_st_c_amt/loan_cnt)%></td>
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(s_st_f_amt)%><br><%=Util.parseDecimal(s_st_f_amt/loan_cnt)%></td>
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(s_st_p_amt)%><br><%=Util.parseDecimal(s_st_p_amt/loan_cnt)%></td>
        		    <td class=title  width='10%'style='text-align:right' ><%=Util.parseDecimal(s_st_s_amt+s_st_d_amt+s_st_c_amt+s_st_f_amt +s_st_p_amt)%><br><%=Util.parseDecimal((s_st_s_amt+s_st_d_amt+s_st_c_amt+s_st_f_amt +s_st_p_amt)/loan_cnt)%></td>	      		
        	</tr>
                
            <tr> 
                    <td class=title colspan="4" style='height:34;'>
                      <% if ( loan_chk.equals("2")) { %>2군<% } else if ( loan_chk.equals("4")) { %>1군<%} else {%>내근<% } %>&nbsp;소계(1년미만제외)<br>&nbsp;&nbsp;&nbsp;&nbsp;평균(1년미만제외)</td>   
                    <td class=title  width='10%' style='text-align:right' ><%=Util.parseDecimal(ws_st_s_amt)%><br><%=Util.parseDecimal(ws_st_s_amt/w_cnt)%></td>
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(ws_st_d_amt)%><br><%=Util.parseDecimal(ws_st_d_amt/w_cnt)%></td>	
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(ws_st_c_amt)%><br><%=Util.parseDecimal(ws_st_c_amt/w_cnt)%></td>
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(ws_st_f_amt)%><br><%=Util.parseDecimal(ws_st_f_amt/w_cnt)%></td>
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(ws_st_p_amt)%><br><%=Util.parseDecimal(ws_st_p_amt/w_cnt)%></td>
        		    <td class=title  width='10%'style='text-align:right' ><%=Util.parseDecimal(ws_st_s_amt+ws_st_d_amt+ws_st_c_amt+ws_st_f_amt +ws_st_p_amt)%><br><%=Util.parseDecimal((ws_st_s_amt+ws_st_d_amt+ws_st_c_amt+ws_st_f_amt +ws_st_p_amt)/w_cnt)%></td>	      		
        	</tr>
        	     
		  <tr> 
		        	<td class=title_p align='center' colspan=4>합계<br>평균</td>     		        	
		      	    <td class=title_p  width='10%' style='text-align:right' ><%=Util.parseDecimal(gt_s_amt)%><br><%=Util.parseDecimal(gt_s_amt/t_loan_cnt)%></td>
        		    <td class=title_p  width='10%' style='text-align:right'><%=Util.parseDecimal(gt_d_amt)%><br><%=Util.parseDecimal(gt_d_amt/t_loan_cnt)%></td>	
        		    <td class=title_p  width='10%' style='text-align:right'><%=Util.parseDecimal(gt_c_amt)%><br><%=Util.parseDecimal(gt_c_amt/t_loan_cnt)%></td>
        		    <td class=title_p  width='10%' style='text-align:right'><%=Util.parseDecimal(gt_f_amt)%><br><%=Util.parseDecimal(gt_f_amt/t_loan_cnt)%></td>
        		    <td class=title_p  width='10%' style='text-align:right'><%=Util.parseDecimal(gt_p_amt)%><br><%=Util.parseDecimal(gt_p_amt/t_loan_cnt)%></td>
        		    <td class=title_p  width='10%'style='text-align:right' ><%=Util.parseDecimal(gt_s_amt+gt_d_amt+gt_c_amt+gt_f_amt +gt_p_amt)%><br><%=Util.parseDecimal((gt_s_amt+gt_d_amt+gt_c_amt+gt_f_amt +gt_p_amt)/t_loan_cnt)%></td>	      		
          </tr>
        	
		   <tr> 
		        	<td class=title_p align='center' colspan=4>합계(1년미만제외)<br>평균(1년미만제외)</td>     		        	
		      	    <td class=title_p  width='10%' style='text-align:right' ><%=Util.parseDecimal(w_gt_s_amt)%><br><%=Util.parseDecimal(w_gt_s_amt/wy_cnt)%></td>
        		    <td class=title_p  width='10%' style='text-align:right'><%=Util.parseDecimal(w_gt_d_amt)%><br><%=Util.parseDecimal(w_gt_d_amt/wy_cnt)%></td>	
        		    <td class=title_p  width='10%' style='text-align:right'><%=Util.parseDecimal(w_gt_c_amt)%><br><%=Util.parseDecimal(w_gt_c_amt/wy_cnt)%></td>
        		    <td class=title_p  width='10%' style='text-align:right'><%=Util.parseDecimal(w_gt_f_amt)%><br><%=Util.parseDecimal(w_gt_f_amt/wy_cnt)%></td>
        		    <td class=title_p  width='10%' style='text-align:right'><%=Util.parseDecimal(w_gt_p_amt)%><br><%=Util.parseDecimal(w_gt_p_amt/wy_cnt)%></td>
        		    <td class=title_p  width='10%'style='text-align:right' ><%=Util.parseDecimal(w_gt_s_amt+w_gt_d_amt+w_gt_c_amt+w_gt_f_amt +w_gt_p_amt)%><br><%=Util.parseDecimal((w_gt_s_amt+w_gt_d_amt+w_gt_c_amt+w_gt_f_amt +w_gt_p_amt)/wy_cnt)%></td>	      		
        	</tr> 		        
	        </table>
	    </td>		  
<%	}else{	%>                     
  <tr>		
        <td class='line' width='100%'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center' >등록된 데이타가 없습니다</td>
                </tr>
            </table>
	    </td>
	   
  </tr>
<%	}	%>
</table>	


<form action="" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='gubun1' value=>
<input type='hidden' name='ba_amt' value=>
<input type='hidden' name='ba1_amt' value=>
</form>
</body>
</html>

<script language="JavaScript" type="text/JavaScript">	

	function onprint(){
		factory.printing.header 	= ""; //폐이지상단 인쇄
		factory.printing.footer 	= ""; //폐이지하단 인쇄
		factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
		factory.printing.leftMargin 	= 12.0; //좌측여백   
		factory.printing.rightMargin 	= 12.0; //우측여백
		factory.printing.topMargin 	= 30.0; //상단여백    
		factory.printing.bottomMargin 	= 30.0; //하단여백
		factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
	
	}

</script>