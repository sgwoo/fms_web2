<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>

<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1"); //�⵵
	
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
	/* Title ���� */
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
    <td colspan="2" align="left"><font face="����" size="2" > 
      <b>&nbsp; * &nbsp <%= gubun1%>��&nbsp;  ķ����������Ȳ </b> </font></td>
  </tr> 
  
  
    <tr>		
        <td class=line>	
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                  <tr> 
                   <td rowspan=2 width="4%" class='title' >����</td>
                    <td rowspan=2 width="12%" class='title' >����</td>                    
                    <td rowspan=2 width="12%" class='title'>����</td>
                    <td rowspan=2  width="12%" class='title'>�Ի���</td>
                     <td colspan=7 class=title width="60%" >�հ�</td>   
                </tr>
                 <tr>               
                    <td class=title   width='10%'  >����</td> <!--4�б� --> 
                    <td class=title   width='10%'>ä��</td>       
                    <td class=title   width='10%'>1�����</td>
               <!--   <td class=title   width='10%'>�����</td>  -->
                      <td class=title   width='10%'>2�����</td>
                    <td class=title  width='10%' >����</td>  
                    <td class=title  width='10%' >��</td> 
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
				
					//��Ī
				dept_nm = ad_db.getUserDeptNm(String.valueOf(ht.get("USER_ID")));
				
			   if ( !loan_chk.equals(String.valueOf(ht.get("LOAN_ST")))) {       
	%>
	    	  <tr> 
                    <td class=title colspan="4" style='height:34;'>
         <% if ( loan_chk.equals("2")) { %>2��<% } else if ( loan_chk.equals("4")) { %>1��<%} else {%>����<% } %>&nbsp;�Ұ�<br>&nbsp;&nbsp;&nbsp;&nbsp;���</td>  
                    <td class=title  width='10%' style='text-align:right' ><%=Util.parseDecimal(s_st_s_amt)%><br><%=Util.parseDecimal(s_st_s_amt/loan_cnt)%></td>
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(s_st_d_amt)%><br><%=Util.parseDecimal(s_st_d_amt/loan_cnt)%></td>	
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(s_st_c_amt)%><br><%=Util.parseDecimal(s_st_c_amt/loan_cnt)%></td>
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(s_st_f_amt)%><br><%=Util.parseDecimal(s_st_f_amt/loan_cnt)%></td>
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(s_st_p_amt)%><br><%=Util.parseDecimal(s_st_p_amt/loan_cnt)%></td>
        		    <td class=title  width='10%'style='text-align:right' ><%=Util.parseDecimal(s_st_s_amt+s_st_d_amt+s_st_c_amt+s_st_f_amt +s_st_p_amt)%><br><%=Util.parseDecimal((s_st_s_amt+s_st_d_amt+s_st_c_amt+s_st_f_amt +s_st_p_amt)/loan_cnt)%></td>	      		
        	   </tr>
                
               <tr> 
                    <td class=title colspan="4" style='height:34;'>
            <% if ( loan_chk.equals("2")) { %>2��<% } else if ( loan_chk.equals("4")) { %>1��<%} else {%>����<% } %>&nbsp;�Ұ�(1��̸�����)<br>&nbsp;&nbsp;&nbsp;&nbsp;���(1��̸�����)</td>   
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
        
        //1��̸� 
		if  (  AddUtil.parseInt(String.valueOf(ht.get("WY")) ) > 11 ) { 
			  w_cnt++;
			  wy_cnt++;			  
		}    
%>   
      	  
	<%		for (int j = 1 ; j < 5 ; j++){
					  s_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("S"+(j))));  //����
					  d_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("D"+(j))));  //ä��
					  c_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("C"+(j))));	//1�����		
					  e_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("E"+(j))));
					  f_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("F"+(j))));  //2�����
					  g_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("G"+(j))));
					  p_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("P"+(j))));  //����	
												  										 				 
					  st_s_amt = st_s_amt +  (s_amt[j]);  //����
					  st_d_amt = st_d_amt +  (d_amt[j]);  //ä��
					  st_c_amt = st_c_amt +  (c_amt[j] + e_amt[j] + g_amt[j]);  //1�����
					  st_f_amt = st_f_amt +  (f_amt[j]);  //2�����
					  st_p_amt = st_p_amt +  (p_amt[j]);  //����
					  
					  s_st_s_amt = s_st_s_amt +  (s_amt[j]);  //����  -- sub
					  s_st_d_amt = s_st_d_amt +  (d_amt[j]);  //ä��
					  s_st_c_amt = s_st_c_amt +  (c_amt[j] + e_amt[j] + g_amt[j]);  //1�����
					  s_st_f_amt = s_st_f_amt +  (f_amt[j]);  //2�����
					  s_st_p_amt = s_st_p_amt +  (p_amt[j]);  //����
					  
					  gt_s_amt = gt_s_amt +  (s_amt[j]);  //����  -- tot
					  gt_d_amt = gt_d_amt +  (d_amt[j]);  //ä��
					  gt_c_amt = gt_c_amt +  (c_amt[j] + e_amt[j] + g_amt[j]);  //1�����
					  gt_f_amt = gt_f_amt +  (f_amt[j]);  //2�����
					  gt_p_amt = gt_p_amt +  (p_amt[j]);  //����
					
					  //1��̸� 
					  if  (  AddUtil.parseInt(String.valueOf(ht.get("WY")) ) > 11 ) { 
							  w_s_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("S"+(j))));  //����
							  w_d_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("D"+(j))));  //ä��
							  w_c_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("C"+(j))));	//1�����		
							  w_e_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("E"+(j))));
							  w_f_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("F"+(j))));  //2�����
							  w_g_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("G"+(j))));
							  w_p_amt[j] = AddUtil.parseLong(String.valueOf(ht.get("P"+(j))));  //����	
							  
							  ws_st_s_amt = ws_st_s_amt +  (w_s_amt[j]);  //����
							  ws_st_d_amt = ws_st_d_amt +  (w_d_amt[j]);  //ä��
							  ws_st_c_amt = ws_st_c_amt +  (w_c_amt[j] + w_e_amt[j] + w_g_amt[j]);  //1�����
							  ws_st_f_amt = ws_st_f_amt +  (w_f_amt[j]);  //2�����
							  ws_st_p_amt = ws_st_p_amt +  (w_p_amt[j]);  //����	 	
							  
							  w_gt_s_amt = w_gt_s_amt +  (w_s_amt[j]);  //����
							  w_gt_d_amt = w_gt_d_amt +  (w_d_amt[j]);  //ä��
							  w_gt_c_amt = w_gt_c_amt +  (w_c_amt[j] + w_e_amt[j] + w_g_amt[j]);  //1�����
							  w_gt_f_amt = w_gt_f_amt +  (w_f_amt[j]);  //2�����
							  w_gt_p_amt = w_gt_p_amt +  (w_p_amt[j]);  //����	 	
					  
					  }
				    
			} 
								
			p_cnt++;			
					
	%>
   			
           <tr> 
           	 <td width='4%' align='center'>&nbsp;<%=p_cnt%></td>	
                    <td width='12%' align='center'>
           <%  if ( ht.get("NM").equals("�����")) { %>
           �����
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
	 st_s_amt = 0;  //����
	 st_d_amt = 0;  //ä��
	 st_c_amt = 0;  //1�����
	 st_f_amt = 0;  //2�����
	 st_p_amt = 0;  //����	 
	  
  }  
        
  %>		    

		   <tr> 
                    <td class=title colspan="4" style='height:34;'>
                     <% if ( loan_chk.equals("2")) { %>2��<% } else if ( loan_chk.equals("4")) { %>1��<%} else {%>����<% } %>&nbsp;�Ұ�<br>&nbsp;&nbsp;&nbsp;&nbsp;���</td>  
                    <td class=title  width='10%' style='text-align:right' ><%=Util.parseDecimal(s_st_s_amt)%><br><%=Util.parseDecimal(s_st_s_amt/loan_cnt)%></td>
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(s_st_d_amt)%><br><%=Util.parseDecimal(s_st_d_amt/loan_cnt)%></td>	
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(s_st_c_amt)%><br><%=Util.parseDecimal(s_st_c_amt/loan_cnt)%></td>
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(s_st_f_amt)%><br><%=Util.parseDecimal(s_st_f_amt/loan_cnt)%></td>
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(s_st_p_amt)%><br><%=Util.parseDecimal(s_st_p_amt/loan_cnt)%></td>
        		    <td class=title  width='10%'style='text-align:right' ><%=Util.parseDecimal(s_st_s_amt+s_st_d_amt+s_st_c_amt+s_st_f_amt +s_st_p_amt)%><br><%=Util.parseDecimal((s_st_s_amt+s_st_d_amt+s_st_c_amt+s_st_f_amt +s_st_p_amt)/loan_cnt)%></td>	      		
        	</tr>
                
            <tr> 
                    <td class=title colspan="4" style='height:34;'>
                      <% if ( loan_chk.equals("2")) { %>2��<% } else if ( loan_chk.equals("4")) { %>1��<%} else {%>����<% } %>&nbsp;�Ұ�(1��̸�����)<br>&nbsp;&nbsp;&nbsp;&nbsp;���(1��̸�����)</td>   
                    <td class=title  width='10%' style='text-align:right' ><%=Util.parseDecimal(ws_st_s_amt)%><br><%=Util.parseDecimal(ws_st_s_amt/w_cnt)%></td>
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(ws_st_d_amt)%><br><%=Util.parseDecimal(ws_st_d_amt/w_cnt)%></td>	
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(ws_st_c_amt)%><br><%=Util.parseDecimal(ws_st_c_amt/w_cnt)%></td>
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(ws_st_f_amt)%><br><%=Util.parseDecimal(ws_st_f_amt/w_cnt)%></td>
        		    <td class=title  width='10%' style='text-align:right'><%=Util.parseDecimal(ws_st_p_amt)%><br><%=Util.parseDecimal(ws_st_p_amt/w_cnt)%></td>
        		    <td class=title  width='10%'style='text-align:right' ><%=Util.parseDecimal(ws_st_s_amt+ws_st_d_amt+ws_st_c_amt+ws_st_f_amt +ws_st_p_amt)%><br><%=Util.parseDecimal((ws_st_s_amt+ws_st_d_amt+ws_st_c_amt+ws_st_f_amt +ws_st_p_amt)/w_cnt)%></td>	      		
        	</tr>
        	     
		  <tr> 
		        	<td class=title_p align='center' colspan=4>�հ�<br>���</td>     		        	
		      	    <td class=title_p  width='10%' style='text-align:right' ><%=Util.parseDecimal(gt_s_amt)%><br><%=Util.parseDecimal(gt_s_amt/t_loan_cnt)%></td>
        		    <td class=title_p  width='10%' style='text-align:right'><%=Util.parseDecimal(gt_d_amt)%><br><%=Util.parseDecimal(gt_d_amt/t_loan_cnt)%></td>	
        		    <td class=title_p  width='10%' style='text-align:right'><%=Util.parseDecimal(gt_c_amt)%><br><%=Util.parseDecimal(gt_c_amt/t_loan_cnt)%></td>
        		    <td class=title_p  width='10%' style='text-align:right'><%=Util.parseDecimal(gt_f_amt)%><br><%=Util.parseDecimal(gt_f_amt/t_loan_cnt)%></td>
        		    <td class=title_p  width='10%' style='text-align:right'><%=Util.parseDecimal(gt_p_amt)%><br><%=Util.parseDecimal(gt_p_amt/t_loan_cnt)%></td>
        		    <td class=title_p  width='10%'style='text-align:right' ><%=Util.parseDecimal(gt_s_amt+gt_d_amt+gt_c_amt+gt_f_amt +gt_p_amt)%><br><%=Util.parseDecimal((gt_s_amt+gt_d_amt+gt_c_amt+gt_f_amt +gt_p_amt)/t_loan_cnt)%></td>	      		
          </tr>
        	
		   <tr> 
		        	<td class=title_p align='center' colspan=4>�հ�(1��̸�����)<br>���(1��̸�����)</td>     		        	
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
                    <td align='center' >��ϵ� ����Ÿ�� �����ϴ�</td>
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
		factory.printing.header 	= ""; //��������� �μ�
		factory.printing.footer 	= ""; //�������ϴ� �μ�
		factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin 	= 12.0; //��������   
		factory.printing.rightMargin 	= 12.0; //��������
		factory.printing.topMargin 	= 30.0; //��ܿ���    
		factory.printing.bottomMargin 	= 30.0; //�ϴܿ���
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
	
	}

</script>